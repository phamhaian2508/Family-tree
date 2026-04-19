<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>Học hàm học vị</title>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page.jsp">
    <jsp:param name="pageTitle" value="Học hàm học vị"/>
    <jsp:param name="pageSubtitle" value="Lưu trữ hồ sơ học hàm, học vị, chuyên môn và thành tích nổi bật của các thành viên trong cây gia phả hiện tại."/>
</jsp:include>
<script>
    window.familyContentPageConfig = {
        endpoint: '/api/family-content/academics',
        entityName: 'h\u1ed3 s\u01a1 h\u1ecdc h\u00e0m h\u1ecdc v\u1ecb',
        filterPlaceholder: 'T\u00ecm theo h\u1ecd t\u00ean',
        searchField: 'fullName',
        columns: [
            { key: 'fullName', label: 'H\u1ecd t\u00ean' },
            { key: 'degreeName', label: 'H\u1ecdc v\u1ecb' },
            { key: 'academicRank', label: 'H\u1ecdc h\u00e0m' },
            { key: 'specialty', label: 'Chuy\u00ean m\u00f4n' },
            { key: 'workplace', label: 'N\u01a1i c\u00f4ng t\u00e1c' }
        ],
        fields: [
            { key: 'fullName', label: 'H\u1ecd t\u00ean', type: 'text', required: true },
            { key: 'birthYear', label: 'N\u0103m sinh', type: 'number' },
            { key: 'branchName', label: 'Chi h\u1ecd / ng\u00e0nh', type: 'text' },
            { key: 'degreeName', label: 'H\u1ecdc v\u1ecb', type: 'text' },
            { key: 'academicRank', label: 'H\u1ecdc h\u00e0m', type: 'text' },
            { key: 'specialty', label: 'Chuy\u00ean m\u00f4n', type: 'text' },
            { key: 'workplace', label: 'N\u01a1i c\u00f4ng t\u00e1c', type: 'text' },
            { key: 'currentPosition', label: 'Ch\u1ee9c v\u1ee5 hi\u1ec7n t\u1ea1i', type: 'text' },
            { key: 'portraitUrl', label: '\u1ea2nh ch\u00e2n dung', type: 'text', uploadType: 'image', uploadButtonLabel: 'Ch\u1ecdn \u1ea3nh', uploadHint: 'T\u1ea3i \u1ea3nh ch\u00e2n dung th\u00e0nh vi\u00ean' },
            { key: 'highlightAchievement', label: 'Th\u00e0nh t\u00edch n\u1ed5i b\u1eadt', type: 'textarea' },
            { key: 'note', label: 'Ghi ch\u00fa', type: 'textarea' }
        ],
        totalRenderer: function (items) {
            var degreeMap = {};
            items.forEach(function (item) {
                var degree = item.degreeName || 'Ch\u01b0a ph\u00e2n lo\u1ea1i';
                degreeMap[degree] = (degreeMap[degree] || 0) + 1;
            });
            return Object.keys(degreeMap).sort().map(function (degree) {
                return '<span class="record-chip">' + degree + ': ' + degreeMap[degree] + '</span>';
            }).join(' ');
        }
    };
</script>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page-script.jsp"/>
