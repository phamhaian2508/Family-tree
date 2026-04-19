<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<title>Khen thưởng - Khuyến học</title>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page.jsp">
    <jsp:param name="pageTitle" value="Khen thưởng - Khuyến học"/>
    <jsp:param name="pageSubtitle" value="Quản lý danh sách cá nhân có thành tích, nhận khen thưởng hoặc hỗ trợ khuyến học trong cây gia phả hiện tại."/>
</jsp:include>
<script>
    window.familyContentPageConfig = {
        endpoint: '/api/family-content/awards',
        entityName: 'b\u1ea3n ghi khen th\u01b0\u1edfng',
        filterPlaceholder: 'T\u00ecm theo h\u1ecd t\u00ean',
        yearField: 'awardYear',
        searchField: 'fullName',
        columns: [
            { key: 'awardYear', label: 'N\u0103m' },
            { key: 'fullName', label: 'H\u1ecd t\u00ean' },
            { key: 'achievementTitle', label: 'Th\u00e0nh t\u00edch' },
            { key: 'educationLevel', label: 'B\u1eadc h\u1ecdc' },
            { key: 'rewardValue', label: 'M\u1ee9c th\u01b0\u1edfng' }
        ],
        fields: [
            { key: 'fullName', label: 'H\u1ecd t\u00ean', type: 'text', required: true },
            { key: 'awardYear', label: 'N\u0103m khen th\u01b0\u1edfng', type: 'number', required: true },
            { key: 'achievementTitle', label: 'Th\u00e0nh t\u00edch / danh hi\u1ec7u', type: 'text' },
            { key: 'educationLevel', label: 'B\u1eadc h\u1ecdc', type: 'text' },
            { key: 'schoolName', label: 'Tr\u01b0\u1eddng / \u0111\u01a1n v\u1ecb', type: 'text' },
            { key: 'rewardType', label: 'H\u00ecnh th\u1ee9c khen th\u01b0\u1edfng', type: 'text' },
            { key: 'rewardValue', label: 'Gi\u00e1 tr\u1ecb / m\u1ee9c th\u01b0\u1edfng', type: 'text' },
            { key: 'categoryName', label: 'Danh m\u1ee5c', type: 'text' },
            { key: 'proofImage', label: '\u1ea2nh minh ch\u1ee9ng', type: 'text', uploadType: 'image', uploadButtonLabel: 'Ch\u1ecdn \u1ea3nh', uploadHint: 'T\u1ea3i b\u1eb1ng khen, gi\u1ea5y ch\u1ee9ng nh\u1eadn ho\u1eb7c \u1ea3nh minh h\u1ecda' },
            { key: 'note', label: 'Ghi ch\u00fa', type: 'textarea' }
        ],
        totalRenderer: function (items) {
            var total = items.length;
            var yearMap = {};
            items.forEach(function (item) {
                var year = item.awardYear || 'Kh\u00e1c';
                yearMap[year] = (yearMap[year] || 0) + 1;
            });
            return '<span class="record-chip">T\u1ed5ng s\u1ed1: ' + total + ' b\u1ea3n ghi</span>'
                + Object.keys(yearMap).sort().map(function (year) {
                    return '<span class="record-chip">' + year + ': ' + yearMap[year] + '</span>';
                }).join(' ');
        }
    };
</script>
<jsp:include page="/WEB-INF/views/admin/family-tree/partials/record-page-script.jsp"/>
