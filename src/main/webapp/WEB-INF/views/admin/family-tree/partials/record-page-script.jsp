<% boolean canManageRecord = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>
<script>
    (function () {
        var config = window.familyContentPageConfig || {};
        var state = { items: [], editingId: null };
        var canManage = <%= canManageRecord %>;
        var currentFamilyTreeId = Number('${empty currentFamilyTreeId ? 0 : currentFamilyTreeId}');

        function byId(id) {
            return document.getElementById(id);
        }

        function openDialog(options) {
            function normalizeDialogResult(result) {
                if (typeof result === 'boolean') {
                    return { isConfirmed: result };
                }
                if (!result) {
                    return { isConfirmed: false };
                }
                if (typeof result.isConfirmed === 'boolean') {
                    return result;
                }
                if (typeof result.value !== 'undefined') {
                    return { isConfirmed: !!result.value };
                }
                if (result.dismiss) {
                    return { isConfirmed: false, dismiss: result.dismiss };
                }
                return { isConfirmed: false };
            }

            if (window.Swal && typeof window.Swal.fire === 'function') {
                return window.Swal.fire(options).then(normalizeDialogResult);
            }
            if (typeof window.swal === 'function') {
                return window.swal({
                    title: options.title,
                    text: options.text,
                    type: options.icon,
                    showCancelButton: !!options.showCancelButton,
                    confirmButtonText: options.confirmButtonText || '\u0110\u00f3ng',
                    cancelButtonText: options.cancelButtonText || 'H\u1ee7y',
                    reverseButtons: !!options.reverseButtons
                }).then(normalizeDialogResult);
            }
            if (options.showCancelButton) {
                return Promise.resolve({
                    isConfirmed: window.confirm(options.text || options.title || '')
                });
            }
            window.alert(options.text || options.title || '');
            return Promise.resolve({ isConfirmed: true });
        }

        function notify(message) {
            return openDialog({
                icon: 'info',
                title: 'Th\u00f4ng b\u00e1o',
                text: message,
                confirmButtonText: '\u0110\u00f3ng'
            });
        }

        function notifyError(message) {
            return openDialog({
                icon: 'error',
                title: 'Th\u00f4ng b\u00e1o',
                text: message,
                confirmButtonText: '\u0110\u00f3ng'
            });
        }

        function confirmDelete(message) {
            return openDialog({
                icon: 'warning',
                title: 'X\u00e1c nh\u1eadn x\u00f3a',
                text: message,
                showCancelButton: true,
                confirmButtonText: 'X\u00f3a',
                cancelButtonText: 'H\u1ee7y',
                reverseButtons: true
            });
        }

        function esc(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function modal(open) {
            byId('recordModal').style.display = open ? 'flex' : 'none';
        }

        function endpointFor(id) {
            return id ? config.endpoint + '/' + id : config.endpoint;
        }

        function fieldByKey(key) {
            return (config.fields || []).find(function (field) {
                return field.key === key;
            }) || null;
        }

        function splitValues(value, multiple) {
            var text = String(value || '').trim();
            if (!text) {
                return [];
            }
            if (!multiple) {
                return [text];
            }
            return text.split(/\r?\n/).map(function (item) {
                return String(item || '').trim();
            }).filter(Boolean);
        }

        function isImageUrl(value) {
            return /^(https?:)?\/\//i.test(value)
                || value.indexOf('/api/media/file/') >= 0
                || /\.(png|jpe?g|gif|webp|bmp|svg)(\?.*)?$/i.test(value);
        }

        function renderPreview(field, value) {
            var preview = document.querySelector('[data-upload-preview="' + field.key + '"]');
            if (!preview) {
                return;
            }
            var values = splitValues(value, !!field.uploadMultiple);
            if (!values.length) {
                preview.classList.add('is-empty');
                preview.innerHTML = '';
                return;
            }
            preview.classList.remove('is-empty');
            preview.innerHTML = values.map(function (item) {
                if (field.uploadType === 'image' && isImageUrl(item)) {
                    return '<div><div class="record-upload-thumb" style="background-image:url(\'' + esc(item) + '\')"></div><div class="record-upload-link">' + esc(item) + '</div></div>';
                }
                return '<div class="record-upload-link">' + esc(item) + '</div>';
            }).join('');
        }

        function updateAllPreviews() {
            (config.fields || []).forEach(function (field) {
                if (!field.uploadType) {
                    return;
                }
                var el = document.querySelector('[data-field="' + field.key + '"]');
                renderPreview(field, el ? el.value : '');
            });
        }

        function uploadFiles(files) {
            var formData = new FormData();
            Array.prototype.forEach.call(files, function (file) {
                formData.append('files', file);
                formData.append('displayNames', String(file.name || '').replace(/\.[^/.]+$/, ''));
                formData.append('visibilityScopes', 'PUBLIC');
            });
            if (currentFamilyTreeId > 0) {
                formData.append('familyTreeId', currentFamilyTreeId);
            }
            return fetch('/api/media/upload', { method: 'POST', body: formData })
                .then(function (res) {
                    if (!res.ok) {
                        return res.text().then(function (text) {
                            throw new Error(text || 'Kh\u00f4ng th\u1ec3 t\u1ea3i \u1ea3nh l\u00ean');
                        });
                    }
                    return res.json();
                })
                .then(function (items) {
                    return (Array.isArray(items) ? items : []).map(function (item) {
                        return item && item.fileUrl ? String(item.fileUrl).trim() : '';
                    }).filter(Boolean);
                });
        }

        function pickFiles(field) {
            var input = document.createElement('input');
            input.type = 'file';
            input.accept = field.uploadAccept || 'image/*';
            input.multiple = !!field.uploadMultiple;
            input.style.display = 'none';
            document.body.appendChild(input);
            input.addEventListener('change', function () {
                if (!input.files || !input.files.length) {
                    document.body.removeChild(input);
                    return;
                }
                uploadFiles(input.files)
                    .then(function (urls) {
                        var el = document.querySelector('[data-field="' + field.key + '"]');
                        if (!el || !urls.length) {
                            return;
                        }
                        if (field.uploadMultiple) {
                            var existing = splitValues(el.value, true);
                            el.value = existing.concat(urls).join('\n');
                        } else {
                            el.value = urls[0];
                        }
                        renderPreview(field, el.value);
                    })
                    .catch(function (err) {
                        notifyError(err && err.message ? err.message : 'Kh\u00f4ng th\u1ec3 t\u1ea3i t\u1ec7p l\u00ean.');
                    })
                    .then(function () {
                        document.body.removeChild(input);
                    });
            });
            input.click();
        }

        function renderForm(item) {
            var data = item || {};
            byId('recordModalTitle').textContent = state.editingId
                ? 'C\u1eadp nh\u1eadt ' + config.entityName
                : 'Th\u00eam m\u1edbi ' + config.entityName;

            byId('recordFormGrid').innerHTML = (config.fields || []).map(function (field) {
                var value = data[field.key];
                if (field.type === 'checkbox') {
                    return '<div class="record-field is-full"><label><input data-field="' + field.key + '" type="checkbox"' + (value === false ? '' : ' checked') + '> ' + field.label + '</label></div>';
                }

                var isFull = field.type === 'textarea' ? ' is-full' : '';
                var html = '<div class="record-field' + isFull + '"><label>' + field.label + '</label>';
                html += field.type === 'textarea'
                    ? '<textarea rows="4" data-field="' + field.key + '">' + esc(value) + '</textarea>'
                    : '<input type="' + (field.type || 'text') + '" data-field="' + field.key + '" value="' + esc(value) + '">';

                if (field.uploadType && canManage) {
                    html += '<div class="record-upload-row">'
                        + '<button class="record-btn record-btn-secondary record-upload-btn" type="button" data-upload-field="' + field.key + '">'
                        + (field.uploadButtonLabel || (field.uploadMultiple ? 'Ch\u1ecdn nhi\u1ec1u \u1ea3nh' : 'Ch\u1ecdn \u1ea3nh'))
                        + '</button>'
                        + '<span class="record-upload-note">' + esc(field.uploadHint || 'T\u1ea3i t\u1ec7p l\u00ean \u0111\u1ec3 t\u1ef1 \u0111\u1ed9ng \u0111i\u1ec1n \u0111\u01b0\u1eddng d\u1eabn') + '</span>'
                        + '</div>';
                }
                if (field.uploadType) {
                    html += '<div class="record-upload-preview is-empty" data-upload-preview="' + field.key + '"></div>';
                }
                html += '</div>';
                return html;
            }).join('');

            if (!canManage) {
                Array.prototype.forEach.call(byId('recordFormGrid').querySelectorAll('input, textarea'), function (el) {
                    if (el.type === 'checkbox') {
                        el.disabled = true;
                    } else {
                        el.readOnly = true;
                    }
                });
            }

            updateAllPreviews();
        }

        function collectPayload() {
            var payload = {};
            (config.fields || []).forEach(function (field) {
                var el = document.querySelector('[data-field="' + field.key + '"]');
                if (!el) {
                    return;
                }
                payload[field.key] = field.type === 'checkbox' ? !!el.checked : String(el.value || '').trim();
                if (field.type === 'number' && payload[field.key] !== '') {
                    payload[field.key] = Number(payload[field.key]);
                }
            });
            return payload;
        }

        function validatePayload(payload) {
            var requiredField = (config.fields || []).find(function (field) {
                return field.required;
            });
            if (requiredField && !payload[requiredField.key]) {
                notify(requiredField.label + ' kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.');
                return false;
            }
            return true;
        }

        function filteredItems() {
            var searchValue = String(byId('recordSearchInput').value || '').trim().toLowerCase();
            var yearValue = String(byId('recordYearInput').value || '').trim();
            return state.items.filter(function (item) {
                var okSearch = !searchValue || String(item[config.searchField] || '').toLowerCase().indexOf(searchValue) >= 0;
                var okYear = !config.yearField || !yearValue || String(item[config.yearField] || '') === yearValue;
                return okSearch && okYear;
            });
        }

        function renderTable() {
            var items = filteredItems();
            var wrap = byId('recordTableWrap');
            var summary = byId('recordSummaryBox');
            summary.innerHTML = typeof config.totalRenderer === 'function'
                ? config.totalRenderer(items)
                : '<span class="record-chip">T\u1ed5ng s\u1ed1: ' + items.length + '</span>';

            if (!items.length) {
                wrap.innerHTML = ''
                    + '<div class="record-empty">'
                    + '<p class="record-empty-title">Ch\u01b0a c\u00f3 d\u1eef li\u1ec7u ph\u00f9 h\u1ee3p</p>'
                    + '<p class="record-empty-note">H\u00e3y th\u1eed t\u00ecm ki\u1ebfm theo t\u1eeb kh\u00f3a kh\u00e1c, ch\u1ecdn l\u1ea1i n\u0103m ho\u1eb7c th\u00eam b\u1ea3n ghi m\u1edbi cho n\u1ed9i dung n\u00e0y.</p>'
                    + '</div>';
                return;
            }

            var head = (config.columns || []).map(function (column) {
                return '<th>' + column.label + '</th>';
            }).join('');
            if (canManage) {
                head += '<th>Thao t\u00e1c</th>';
            }

            wrap.innerHTML = '<div class="record-table-scroll"><table class="record-table"><thead><tr>' + head + '</tr></thead><tbody>'
                + items.map(function (item) {
                    var cells = (config.columns || []).map(function (column) {
                        var value = typeof column.render === 'function' ? column.render(item[column.key], item) : item[column.key];
                        return '<td>' + esc(value);
                    }).join('</td>');
                    var actionCell = canManage
                        ? '<td><button class="record-btn record-btn-secondary" type="button" data-edit="' + item.id + '">S\u1eeda</button> <button class="record-btn record-btn-danger" type="button" data-delete="' + item.id + '">X\u00f3a</button></td>'
                        : '';
                    return '<tr>' + cells + '</td>' + actionCell + '</tr>';
                }).join('')
                + '</tbody></table></div>';
        }

        function loadItems() {
            fetch(config.endpoint)
                .then(function (res) {
                    return res.json();
                })
                .then(function (items) {
                    state.items = Array.isArray(items) ? items : [];
                    renderTable();
                })
                .catch(function () {
                    notifyError('Kh\u00f4ng th\u1ec3 t\u1ea3i danh s\u00e1ch.');
                });
        }

        function saveItem() {
            var payload = collectPayload();
            if (!validatePayload(payload)) {
                return;
            }
            fetch(endpointFor(state.editingId), {
                method: state.editingId ? 'PUT' : 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            })
                .then(function (res) {
                    if (!res.ok) {
                        return res.text().then(function (text) {
                            throw new Error(text || 'Kh\u00f4ng th\u1ec3 l\u01b0u d\u1eef li\u1ec7u.');
                        });
                    }
                    return res.json();
                })
                .then(function () {
                    modal(false);
                    loadItems();
                })
                .catch(function (err) {
                    notifyError(err && err.message ? err.message : 'Kh\u00f4ng th\u1ec3 l\u01b0u d\u1eef li\u1ec7u.');
                });
        }

        function deleteItem(id) {
            confirmDelete('X\u00f3a ' + config.entityName + ' n\u00e0y?')
                .then(function (result) {
                    if (!result.isConfirmed) {
                        return null;
                    }
                    return fetch(endpointFor(id), { method: 'DELETE' })
                        .then(function (res) {
                            if (!res.ok) {
                                return res.text().then(function (text) {
                                    throw new Error(text || 'Kh\u00f4ng th\u1ec3 x\u00f3a d\u1eef li\u1ec7u.');
                                });
                            }
                            return true;
                        });
                })
                .then(function (deleted) {
                    if (deleted) {
                        loadItems();
                    }
                })
                .catch(function (err) {
                    notifyError(err && err.message ? err.message : 'Kh\u00f4ng th\u1ec3 x\u00f3a d\u1eef li\u1ec7u.');
                });
        }

        if (canManage && byId('addRecordBtn')) {
            byId('addRecordBtn').addEventListener('click', function () {
                state.editingId = null;
                renderForm(null);
                modal(true);
            });
        }

        byId('closeRecordModalBtn').addEventListener('click', function () {
            modal(false);
        });

        if (canManage && byId('saveRecordBtn')) {
            byId('saveRecordBtn').addEventListener('click', saveItem);
        }

        byId('recordSearchInput').setAttribute('placeholder', config.filterPlaceholder || 'T\u00ecm ki\u1ebfm');
        byId('recordYearInput').style.display = config.yearField ? '' : 'none';
        byId('recordSearchInput').addEventListener('input', renderTable);
        byId('recordYearInput').addEventListener('input', renderTable);
        byId('recordModal').addEventListener('click', function (event) {
            if (event.target === this) {
                modal(false);
            }
        });

        byId('recordFormGrid').addEventListener('input', function (event) {
            var fieldKey = event.target && event.target.getAttribute ? event.target.getAttribute('data-field') : '';
            var field = fieldByKey(fieldKey);
            if (field && field.uploadType) {
                renderPreview(field, event.target.value);
            }
        });

        byId('recordFormGrid').addEventListener('click', function (event) {
            if (!canManage) {
                return;
            }
            var button = event.target.closest('[data-upload-field]');
            if (!button) {
                return;
            }
            var field = fieldByKey(button.getAttribute('data-upload-field'));
            if (!field) {
                return;
            }
            pickFiles(field);
        });

        byId('recordTableWrap').addEventListener('click', function (event) {
            if (!canManage) {
                return;
            }
            var editBtn = event.target.closest('[data-edit]');
            if (editBtn) {
                state.editingId = Number(editBtn.getAttribute('data-edit') || 0);
                renderForm(state.items.find(function (item) {
                    return Number(item.id || 0) === state.editingId;
                }) || null);
                modal(true);
                return;
            }
            var deleteBtn = event.target.closest('[data-delete]');
            if (deleteBtn) {
                deleteItem(Number(deleteBtn.getAttribute('data-delete') || 0));
            }
        });

        loadItems();
    })();
</script>
