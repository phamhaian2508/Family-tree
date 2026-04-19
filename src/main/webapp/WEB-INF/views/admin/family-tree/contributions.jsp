<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>Công đức hàng năm</title>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page.jsp">
    <jsp:param name="pageTitle" value="Công đức hàng năm"/>
    <jsp:param name="pageSubtitle" value="Quản lý danh sách cá nhân, gia đình đóng góp công đức theo từng năm cho cây gia phả hiện tại."/>
</jsp:include>
<script>
    window.familyContentPageConfig = {
        endpoint: '/api/family-content/contributions',
        entityName: 'b\u1ea3n ghi c\u00f4ng \u0111\u1ee9c',
        filterPlaceholder: 'T\u00ecm theo t\u00ean ng\u01b0\u1eddi \u0111\u00f3ng g\u00f3p',
        yearField: 'contributionYear',
        searchField: 'contributorName',
        columns: [{ key: 'contributionYear', label: 'N\u0103m' }, { key: 'contributorName', label: 'H\u1ecd t\u00ean' }, { key: 'branchLabel', label: '\u0110\u1ea1i di\u1ec7n gia \u0111\u00ecnh / chi h\u1ecd' }, { key: 'contributionValue', label: 'Gi\u00e1 tr\u1ecb' }, { key: 'contributionDate', label: 'Ng\u00e0y \u0111\u00f3ng g\u00f3p' }],
        fields: [
            { key: 'contributionYear', label: 'N\u0103m', type: 'number' },
            { key: 'contributorName', label: 'H\u1ecd t\u00ean ng\u01b0\u1eddi \u0111\u00f3ng g\u00f3p', type: 'text', required: true },
            { key: 'branchLabel', label: '\u0110\u1ea1i di\u1ec7n gia \u0111\u00ecnh / chi h\u1ecd', type: 'text' },
            { key: 'contributionValue', label: 'S\u1ed1 ti\u1ec1n / gi\u00e1 tr\u1ecb', type: 'text' },
            { key: 'contributionDate', label: 'Ng\u00e0y \u0111\u00f3ng g\u00f3p', type: 'text' },
            { key: 'attachmentUrl', label: '\u1ea2nh ch\u1ee9ng t\u1eeb / t\u01b0 li\u1ec7u', type: 'text', uploadType: 'image', uploadButtonLabel: 'Ch\u1ecdn \u1ea3nh', uploadHint: 'T\u1ea3i \u1ea3nh bi\u00ean nh\u1eadn ho\u1eb7c minh ch\u1ee9ng' },
            { key: 'note', label: 'N\u1ed9i dung / ghi ch\u00fa', type: 'textarea' }
        ],
        totalRenderer: function (items) {
            var map = {};
            items.forEach(function (item) { var year = item.contributionYear || 'Kh\u00e1c'; map[year] = (map[year] || 0) + 1; });
            return Object.keys(map).sort().map(function (year) { return '<span class="record-chip">' + year + ': ' + map[year] + ' b\u1ea3n ghi</span>'; }).join(' ');
        }
    };
</script>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page-script.jsp"/>
