<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chốt Chỉ Số & Xuất Hóa Đơn - BQL Skyline Apartment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .wrapper { display: flex; width: 100%; height: 100vh; overflow: hidden; }
        .sidebar { width: 250px; background-color: #1e293b; color: #fff; display: flex; flex-direction: column; transition: all 0.3s ease; z-index: 1000; }
        .sidebar-header { padding: 20px; font-size: 1.25rem; font-weight: 700; border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
        .sidebar-menu { list-style: none; padding: 10px 0; margin: 0; flex-grow: 1; overflow-y: auto; }
        .sidebar-menu li { padding: 4px 15px; }
        .sidebar-menu a { color: #cbd5e1; text-decoration: none; display: flex; align-items: center; font-size: 0.95rem; font-weight: 500; padding: 10px 15px; border-radius: 8px; transition: 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background-color: rgba(255, 255, 255, 0.1); color: #fff; }
        .sidebar-menu a.active { background-color: #0d6efd; }
        .sidebar-menu i { margin-right: 12px; font-size: 1.2rem; }
        .main-content { flex-grow: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-navbar { height: 64px; background-color: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; flex-shrink: 0; }
        .content-area { padding: 24px; }
        
        .form-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: none; padding: 30px; }
        .water-index-box { background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-top: 10px; }

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

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header d-flex align-items-center">
            <i class="bi bi-buildings-fill fs-3 me-2 text-primary"></i> 
            <span class="fs-5">Skyline Admin</span>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/bql/dashboard"><i class="bi bi-grid-1x2-fill"></i> Trang chủ</a></li>
            <li><a href="#"><i class="bi bi-door-closed"></i> Quản lý Căn hộ</a></li>
            <li><a href="#"><i class="bi bi-people-fill"></i> Quản lý Cư dân</a></li>
            <li><a href="${pageContext.request.contextPath}/bql/billing/create" class="active"><i class="bi bi-cash-stack"></i> Thu phí Dịch vụ</a></li>
            <li><a href="${pageContext.request.contextPath}/bql/request/manage"><i class="bi bi-tools"></i> Quản lý Yêu cầu</a></li>
            <li><a href="#"><i class="bi bi-gear-fill"></i> Cài đặt</a></li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <header class="top-navbar">
            <div class="d-flex align-items-center">
                <button class="btn btn-light d-lg-none me-3" id="sidebarToggle"><i class="bi bi-list fs-5"></i></button>
                <h5 class="mb-0 fw-bold d-none d-md-block text-secondary">Hệ Thống Tính Phí & Xuất Hóa Đơn</h5>
            </div>
            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.username}&background=0d6efd&color=fff" width="36" height="36" class="rounded-circle me-2">
                        <span class="fw-medium d-none d-sm-block"><c:out value="${sessionScope.currentUser.username}"/></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <main class="content-area">
            
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Lập Hóa Đơn Dịch Vụ Mới</h3>
                <p class="text-secondary">Hệ thống sẽ tự động quét diện tích và xe cộ để tính toán toàn bộ chi phí sau khi chốt sổ nước.</p>
            </div>

            <!-- Error Notification -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="form-card">
                        <form action="${pageContext.request.contextPath}/bql/billing/create" method="POST">
                            
                            <!-- 1. Chọn Căn Hộ -->
                            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-house-door text-primary me-2"></i> Thông tin Căn hộ</h5>
                            <div class="mb-4">
                                <label class="form-label fw-medium">Chọn căn hộ cần xuất hóa đơn <span class="text-danger">*</span></label>
                                <select class="form-select form-select-lg" name="apartment_id" required>
                                    <option value="" disabled selected>-- Vui lòng chọn mã căn hộ --</option>
                                    <c:forEach var="apt" items="${aptList}">
                                        <option value="${apt.id}" ${param.apartment_id == apt.id ? 'selected' : ''}>
                                            Căn ${apt.apartmentCode} (Diện tích: ${apt.area} m2)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- 2. Chọn Kỳ Hóa Đơn -->
                            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-calendar3 text-primary me-2"></i> Kỳ Hóa Đơn</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Tháng <span class="text-danger">*</span></label>
                                    <select class="form-select" name="billing_month" required>
                                        <c:forEach var="m" begin="1" end="12">
                                            <option value="${m}" ${param.billing_month == m ? 'selected' : ''}>Tháng ${m}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Năm <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="billing_year" value="${not empty param.billing_year ? param.billing_year : '2026'}" required min="2000" max="2100">
                                </div>
                            </div>

                            <!-- 3. Chốt Chỉ Số Nước -->
                            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-droplet-half text-info me-2"></i> Chốt Chỉ Số Nước</h5>
                            <div class="water-index-box row g-4 mb-5">
                                <div class="col-md-6">
                                    <label class="form-label fw-medium text-muted">Chỉ số kỳ trước (Khối) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" class="form-control form-control-lg text-end" name="old_water_index" value="${param.old_water_index}" placeholder="0.00" required min="0">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-primary">Chỉ số kỳ này (Khối) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" class="form-control form-control-lg text-end border-primary" name="new_water_index" value="${param.new_water_index}" placeholder="0.00" required min="0">
                                </div>
                                <div class="col-12 mt-2">
                                    <div class="form-text text-warning"><i class="bi bi-info-circle me-1"></i> Lưu ý: Chỉ số kỳ này bắt buộc phải lớn hơn hoặc bằng chỉ số kỳ trước.</div>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg fw-bold shadow">
                                    <i class="bi bi-calculator-fill me-2"></i> TÍNH TOÁN & XUẤT HÓA ĐƠN
                                </button>
                                <a href="${pageContext.request.contextPath}/bql/dashboard" class="btn btn-light fw-medium">Hủy bỏ</a>
                            </div>

                        </form>
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
