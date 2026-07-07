<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Yêu Cầu - BQL Skyline Apartment</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .wrapper { display: flex; width: 100%; height: 100vh; overflow: hidden; }
        .main-content { flex-grow: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .content-area { padding: 24px; }
        
        /* Bảng CSS */
        .table-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: none; }
        .table-card-header { background: transparent; border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-weight: 700; font-size: 1.1rem; color: #1e293b; }
        .table > :not(caption) > * > * { padding: 12px 20px; vertical-align: middle; }
        
        /* Form in-line */
        .inline-assign-form { display: flex; gap: 8px; align-items: center; }
        .inline-assign-form select { min-width: 150px; }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="request"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <!-- Content Area -->
        <main class="content-area">
            
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Danh Sách Yêu Cầu Chờ Phân Công</h3>
                <p class="text-secondary">Các yêu cầu mới nhất từ cư dân đang chờ Ban Quản Lý phê duyệt và giao việc.</p>
            </div>

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Tuyệt vời!</strong> Phân công công việc thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card table-card">
                <div class="card-header table-card-header d-flex justify-content-between align-items-center">
                    <div><i class="bi bi-card-checklist me-2 text-primary"></i> Yêu cầu trạng thái PENDING</div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary">
                                <tr>
                                    <th>Mã YC</th>
                                    <th>Căn Hộ</th>
                                    <th>Người Gửi</th>
                                    <th>Tiêu Đề</th>
                                    <th>Thời Gian</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty pendingRequests}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                <i class="bi bi-check2-circle fs-1 text-success d-block mb-2"></i>
                                                Hiện tại không có yêu cầu nào chờ phân công.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="req" items="${pendingRequests}">
                                            <tr>
                                                <td class="fw-bold text-primary">#REQ-${req.requestId}</td>
                                                <td class="fw-medium">${req.apartmentCode}</td>
                                                <td>${req.requesterName}</td>
                                                <td>
                                                    <strong>${req.title}</strong>
                                                    <div class="text-muted small text-truncate" style="max-width: 200px;" title="${req.description}">
                                                        ${req.description}
                                                    </div>
                                                </td>
                                                <td class="text-muted small">
                                                    <c:out value="${req.createdAt}" />
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/bql/request/manage" method="POST" class="inline-assign-form">
                                                        <input type="hidden" name="request_id" value="${req.requestId}">
                                                        <select name="staff_id" class="form-select form-select-sm" required>
                                                            <option value="" disabled selected>-- Chọn Nhân viên --</option>
                                                            <c:forEach var="staff" items="${staffList}">
                                                                <option value="${staff.id}">[${staff.role}] ${staff.username}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="submit" class="btn btn-sm btn-success fw-medium shadow-sm text-nowrap">
                                                            <i class="bi bi-person-check-fill"></i> Giao việc
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
