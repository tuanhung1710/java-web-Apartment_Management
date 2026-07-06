<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
        /* ==== Kế thừa Layout CSS ==== */
        .wrapper { display: flex; width: 100%; height: 100vh; overflow: hidden; }
        .sidebar { width: 250px; background-color: #1e293b; color: #fff; display: flex; flex-direction: column; transition: all 0.3s ease; z-index: 1000; }
        .sidebar-header { padding: 20px; font-size: 1.25rem; font-weight: 700; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.1); white-space: nowrap; }
        .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; flex-grow: 1; overflow-y: auto; }
        .sidebar-menu li { padding: 4px 15px; }
        .sidebar-menu a { color: #cbd5e1; text-decoration: none; display: flex; align-items: center; font-size: 0.95rem; font-weight: 500; padding: 10px 15px; border-radius: 8px; transition: 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255, 255, 255, 0.1); color: #fff; }
        .sidebar-menu a.active { background-color: #0d6efd; }
        .sidebar-menu i { margin-right: 12px; font-size: 1.2rem; }
        .main-content { flex-grow: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-navbar { height: 64px; background-color: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; flex-shrink: 0; }
        .content-area { padding: 24px; }
        
        /* Bảng CSS */
        .table-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: none; }
        .table-card-header { background: transparent; border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-weight: 700; font-size: 1.1rem; color: #1e293b; }
        .table > :not(caption) > * > * { padding: 12px 20px; vertical-align: middle; }
        
        /* Form in-line */
        .inline-assign-form { display: flex; gap: 8px; align-items: center; }
        .inline-assign-form select { min-width: 150px; }

        @media (max-width: 991.98px) {
            .sidebar { position: fixed; height: 100%; left: -250px; }
            .sidebar.show { left: 0; }
            .sidebar-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 999; }
            .sidebar-overlay.show { display: block; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- 1. Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header d-flex align-items-center">
            <i class="bi bi-buildings-fill fs-3 me-2 text-primary"></i> 
            <span class="fs-5">Skyline Admin</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/bql/dashboard"><i class="bi bi-grid-1x2-fill"></i> Trang chủ</a></li>
            <li><a href="#"><i class="bi bi-door-closed"></i> Quản lý Căn hộ</a></li>
            <li><a href="#"><i class="bi bi-people-fill"></i> Quản lý Cư dân</a></li>
            <li><a href="#"><i class="bi bi-cash-stack"></i> Thu phí Dịch vụ</a></li>
            <li>
                <a href="${pageContext.request.contextPath}/bql/request/manage" class="active d-flex justify-content-between align-items-center">
                    <div><i class="bi bi-tools"></i> Quản lý Yêu cầu</div>
                    <span class="badge bg-danger rounded-pill shadow-sm">${fn:length(pendingRequests)}</span>
                </a>
            </li>
            <li><a href="#"><i class="bi bi-gear-fill"></i> Cài đặt</a></li>
        </ul>
    </nav>

    <!-- 2. Main Content -->
    <div class="main-content">
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="d-flex align-items-center">
                <button class="btn btn-light d-lg-none me-3" id="sidebarToggle"><i class="bi bi-list fs-5"></i></button>
                <h5 class="mb-0 fw-bold d-none d-md-block text-secondary">Phân Công Yêu Cầu Cư Dân</h5>
            </div>
            
            <div class="d-flex align-items-center">
                <a href="#" class="text-secondary position-relative me-4 fs-5"><i class="bi bi-bell-fill"></i></a>
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.username}&background=0d6efd&color=fff" width="36" height="36" class="rounded-circle me-2 shadow-sm">
                        <span class="fw-medium d-none d-sm-block"><c:out value="${sessionScope.currentUser.username}"/></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-area">
            
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Danh Sách Yêu Cầu Chờ Phân Công</h3>
                <p class="text-secondary">Các yêu cầu mới nhất từ cư dân đang chờ Ban Quản Lý phê duyệt và giao việc.</p>
            </div>

            <%-- Hiển thị thông báo Alert nếu thành công --%>
            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <strong>Tuyệt vời!</strong> Phân công công việc thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <%-- Thông báo lỗi từ POST --%>
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
                                                    <!-- Form in-line giao việc -->
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
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const sidebarToggle = document.getElementById("sidebarToggle");
        const sidebar = document.getElementById("sidebar");
        const sidebarOverlay = document.getElementById("sidebarOverlay");

        if(sidebarToggle) {
            sidebarToggle.addEventListener("click", function() {
                sidebar.classList.add("show");
                sidebarOverlay.classList.add("show");
            });
        }

        if(sidebarOverlay) {
            sidebarOverlay.addEventListener("click", function() {
                sidebar.classList.remove("show");
                sidebarOverlay.classList.remove("show");
            });
        }
    });
</script>
</body>
</html>
