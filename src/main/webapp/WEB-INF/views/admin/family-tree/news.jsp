<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>Tin tức</title>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page.jsp">
    <jsp:param name="pageTitle" value="Tin tức"/>
    <jsp:param name="pageSubtitle" value="Quản lý tin tức, thông báo và các hoạt động nổi bật của dòng họ theo cây gia phả hiện tại."/>
</jsp:include>
<script>
    window.familyContentPageConfig = {
        endpoint: '/api/family-content/news',
        entityName: 'tin t\u1ee9c',
        filterPlaceholder: 'T\u00ecm theo ti\u00eau \u0111\u1ec1',
        searchField: 'title',
        columns: [
            { key: 'title', label: 'Ti\u00eau \u0111\u1ec1' },
            { key: 'categoryName', label: 'Danh m\u1ee5c' },
            { key: 'publisherName', label: 'Ng\u01b0\u1eddi \u0111\u0103ng' },
            { key: 'publishedAt', label: 'Ng\u00e0y \u0111\u0103ng' },
            { key: 'visible', label: 'Hi\u1ec3n th\u1ecb', render: function (value) { return value ? 'C\u00f3' : 'Kh\u00f4ng'; } }
        ],
        fields: [
            { key: 'title', label: 'Ti\u00eau \u0111\u1ec1', type: 'text', required: true },
            { key: 'coverImage', label: 'Link \u1ea3nh b\u00eca', type: 'text', uploadType: 'image', uploadButtonLabel: 'Ch\u1ecdn \u1ea3nh b\u00eca', uploadHint: 'T\u1ea3i \u1ea3nh \u0111\u1ea1i di\u1ec7n cho b\u00e0i vi\u1ebft' },
            { key: 'categoryName', label: 'Danh m\u1ee5c', type: 'text' },
            { key: 'publisherName', label: 'Ng\u01b0\u1eddi \u0111\u0103ng', type: 'text' },
            { key: 'publishedAt', label: 'Ng\u00e0y \u0111\u0103ng', type: 'text' },
            { key: 'visible', label: 'Hi\u1ec3n th\u1ecb tin t\u1ee9c', type: 'checkbox' },
            { key: 'summary', label: 'T\u00f3m t\u1eaft', type: 'textarea' },
            { key: 'content', label: 'N\u1ed9i dung chi ti\u1ebft', type: 'textarea' },
            { key: 'attachmentUrls', label: 'T\u1ec7p / \u1ea3nh \u0111\u00ednh k\u00e8m', type: 'textarea', uploadType: 'image', uploadMultiple: true, uploadButtonLabel: 'Ch\u1ecdn nhi\u1ec1u \u1ea3nh', uploadHint: 'M\u1ed7i \u1ea3nh sau khi t\u1ea3i s\u1ebd th\u00eam m\u1ed9t d\u00f2ng URL' }
        ],
        totalRenderer: function (items) {
            var visibleCount = items.filter(function (item) { return item.visible; }).length;
            return '<span class="record-chip">T\u1ed5ng s\u1ed1: ' + items.length + ' tin</span>'
                + '<span class="record-chip">\u0110ang hi\u1ec3n th\u1ecb: ' + visibleCount + '</span>';
        }
    };
</script>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page-script.jsp"/>
