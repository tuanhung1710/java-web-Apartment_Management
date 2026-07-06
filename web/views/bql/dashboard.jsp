<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BQL Dashboard - Skyline Apartment</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
        }
        
        /* Layout CSS Grid / Flexbox */
        .wrapper {
            display: flex;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }
        
        /* ==== Sidebar ==== */
        .sidebar {
            width: 250px;
            background-color: #1e293b; /* Xanh navy đậm */
            color: #fff;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
            z-index: 1000;
        }
        .sidebar-header {
            padding: 20px;
            font-size: 1.25rem;
            font-weight: 700;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            white-space: nowrap;
        }
        .sidebar-menu {
            list-style: none;
            padding: 10px 0;
            margin: 0;
            flex-grow: 1;
            overflow-y: auto;
        }
        .sidebar-menu li {
            padding: 4px 15px;
        }
        .sidebar-menu a {
            color: #cbd5e1;
            text-decoration: none;
            display: flex;
            align-items: center;
            font-size: 0.95rem;
            font-weight: 500;
            padding: 10px 15px;
            border-radius: 8px;
            transition: 0.2s;
        }
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }
        .sidebar-menu a.active {
            background-color: #0d6efd; /* Màu primary nổi bật */
        }
        .sidebar-menu i {
            margin-right: 12px;
            font-size: 1.2rem;
        }
        
        /* ==== Main Content ==== */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }
        
        /* Top Navbar */
        .top-navbar {
            height: 64px;
            background-color: #fff;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            flex-shrink: 0;
        }
        .search-bar {
            position: relative;
            width: 300px;
        }
        .search-bar input {
            padding-left: 35px;
            border-radius: 20px;
            background-color: #f1f5f9;
            border: none;
        }
        .search-bar input:focus {
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
            background-color: #fff;
            border: 1px solid #dee2e6;
        }
        .search-bar i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }
        
        /* Cụm Content Area */
        .content-area {
            padding: 24px;
        }
        
        /* 4 Khối KPI Cards */
        .kpi-card {
            border: none;
            border-radius: 12px;
            color: #fff;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .card-blue { background: linear-gradient(135deg, #3b82f6, #2563eb); }
        .card-green { background: linear-gradient(135deg, #10b981, #059669); }
        .card-orange { background: linear-gradient(135deg, #f59e0b, #ea580c); }
        .card-red { background: linear-gradient(135deg, #ef4444, #dc2626); }
        
        .kpi-card .inner { padding: 20px; position: relative; z-index: 2; }
        .kpi-card h3 { font-size: 2.2rem; margin-bottom: 0; font-weight: 700; }
        .kpi-card p { margin-bottom: 5px; font-size: 0.95rem; opacity: 0.9; font-weight: 500;}
        /* Icon background mờ */
        .kpi-card i.bg-icon { 
            font-size: 4rem; 
            opacity: 0.2; 
            position: absolute; 
            right: 15px; 
            top: 50%; 
            transform: translateY(-50%); 
            z-index: 1;
        }

        /* Bảng Quick Table */
        .table-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: none;
        }
        .table-card-header {
            background: transparent;
            border-bottom: 1px solid #f1f5f9;
            padding: 16px 20px;
            font-weight: 700;
            font-size: 1.1rem;
            color: #1e293b;
        }
        .table > :not(caption) > * > * {
            padding: 12px 20px;
        }

        /* Responsive */
        @media (max-width: 991.98px) {
            .sidebar {
                position: fixed;
                height: 100%;
                left: -250px;
            }
            .sidebar.show {
                left: 0;
            }
            .search-bar { width: 200px; }
            /* Cần một lớp overlay khi mở menu trên mobile */
            .sidebar-overlay {
                display: none;
                position: fixed;
                top: 0; left: 0; right: 0; bottom: 0;
                background: rgba(0,0,0,0.5);
                z-index: 999;
            }
            .sidebar-overlay.show { display: block; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    
    <!-- Sidebar Overlay for Mobile -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- 1. Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header d-flex align-items-center">
            <i class="bi bi-buildings-fill fs-3 me-2 text-primary"></i> 
            <span class="fs-5">Skyline Admin</span>
        </div>
        <ul class="sidebar-menu">
            <li>
                <a href="#" class="active"><i class="bi bi-grid-1x2-fill"></i> Trang chủ</a>
            </li>
            <li>
                <a href="#"><i class="bi bi-door-closed"></i> Quản lý Căn hộ</a>
            </li>
            <li>
                <a href="#"><i class="bi bi-people-fill"></i> Quản lý Cư dân</a>
            </li>
            <li>
                <a href="#"><i class="bi bi-cash-stack"></i> Thu phí Dịch vụ</a>
            </li>
            <li>
                <a href="#" class="d-flex justify-content-between align-items-center">
                    <div><i class="bi bi-tools"></i> Quản lý Yêu cầu</div>
                    <!-- Badge hiện số yêu cầu chờ -->
                    <span class="badge bg-danger rounded-pill shadow-sm">3</span>
                </a>
            </li>
            <li>
                <a href="#"><i class="bi bi-gear-fill"></i> Cài đặt</a>
            </li>
        </ul>
    </nav>

    <!-- 2. Main Content -->
    <div class="main-content">
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="d-flex align-items-center">
                <!-- Hamburger Menu Toggle cho Mobile -->
                <button class="btn btn-light d-lg-none me-3" id="sidebarToggle">
                    <i class="bi bi-list fs-5"></i>
                </button>
                <!-- Thanh Search -->
                <div class="search-bar d-none d-md-block">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control" placeholder="Tìm kiếm căn hộ, mã yêu cầu...">
                </div>
            </div>
            
            <div class="d-flex align-items-center">
                <!-- Icon Chuông -->
                <a href="#" class="text-secondary position-relative me-4 fs-5">
                    <i class="bi bi-bell-fill"></i>
                    <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                </a>
                
                <!-- User Profile Dropdown -->
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://ui-avatars.com/api/?name=${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Admin'}&background=0d6efd&color=fff" 
                             alt="Avatar" width="36" height="36" class="rounded-circle me-2 shadow-sm">
                        <span class="fw-medium d-none d-sm-block">
                            <c:out value="${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Ban Quản Lý'}"/>
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item py-2" href="#"><i class="bi bi-person me-2"></i> Hồ sơ của tôi</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-area">
            
            <!-- Welcome text lấy từ Session bằng JSTL -->
            <div class="mb-4">
                <h3 class="fw-bold text-dark">
                    Xin chào, <span class="text-primary"><c:out value="${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Ban Quản Lý'}"/>!</span>
                </h3>
                <p class="text-secondary">Dưới đây là tổng quan tình hình vận hành tòa nhà hôm nay.</p>
            </div>

            <!-- 4 Khối KPI Cards -->
            <div class="row g-4 mb-5">
                <!-- Card 1 -->
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-blue h-100">
                        <div class="inner">
                            <p>Tổng số căn hộ</p>
                            <h3>250</h3>
                        </div>
                        <i class="bi bi-door-open-fill bg-icon"></i>
                    </div>
                </div>
                <!-- Card 2 -->
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-green h-100">
                        <div class="inner">
                            <p>Cư dân đang ở</p>
                            <h3>840</h3>
                        </div>
                        <i class="bi bi-people-fill bg-icon"></i>
                    </div>
                </div>
                <!-- Card 3 (Quan trọng) -->
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-orange h-100 position-relative">
                        <div class="inner">
                            <p class="fw-bold">Yêu cầu chờ xử lý</p>
                            <h3>15</h3>
                        </div>
                        <i class="bi bi-exclamation-triangle-fill bg-icon"></i>
                        <!-- Highlight Effect -->
                        <span class="position-absolute top-0 end-0 p-2 text-white"><i class="bi bi-circle-fill text-danger"></i> Mới</span>
                    </div>
                </div>
                <!-- Card 4 -->
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-red h-100">
                        <div class="inner">
                            <p>Tổng nợ phí tháng này</p>
                            <h3 class="fs-4 mt-2">45,000,000 ₫</h3>
                        </div>
                        <i class="bi bi-wallet-fill bg-icon"></i>
                    </div>
                </div>
            </div>

            <!-- Bảng Quick Table -->
            <div class="card table-card">
                <div class="card-header table-card-header d-flex justify-content-between align-items-center">
                    <div><i class="bi bi-list-task me-2 text-primary"></i>5 Yêu cầu hỗ trợ mới nhất từ Cư dân</div>
                    <a href="#" class="btn btn-sm btn-outline-primary fw-medium px-3">Xem tất cả</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary">
                                <tr>
                                    <th>Mã YC</th>
                                    <th>Căn hộ</th>
                                    <th>Nội dung yêu cầu</th>
                                    <th>Thời gian</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Dữ liệu Fake HTML -->
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1005</td>
                                    <td class="fw-medium">A1-1205</td>
                                    <td>Sửa ống nước nhà tắm bị rò rỉ</td>
                                    <td class="text-muted small">10 phút trước</td>
                                    <td><span class="badge bg-warning text-dark px-2 py-1">Chờ xử lý</span></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1004</td>
                                    <td class="fw-medium">B2-0802</td>
                                    <td>Đăng ký sử dụng thang máy chuyển đồ</td>
                                    <td class="text-muted small">1 giờ trước</td>
                                    <td><span class="badge bg-warning text-dark px-2 py-1">Chờ xử lý</span></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1003</td>
                                    <td class="fw-medium">A2-0511</td>
                                    <td>Phản ánh tiếng ồn từ nhà tầng trên</td>
                                    <td class="text-muted small">Hôm qua</td>
                                    <td><span class="badge bg-info text-dark px-2 py-1">Đang xử lý</span></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1002</td>
                                    <td class="fw-medium">C1-1901</td>
                                    <td>Đăng ký làm thẻ xe phụ</td>
                                    <td class="text-muted small">Hôm qua</td>
                                    <td><span class="badge bg-success px-2 py-1">Đã hoàn thành</span></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1001</td>
                                    <td class="fw-medium">B1-0205</td>
                                    <td>Thay bóng đèn hành lang tầng 2</td>
                                    <td class="text-muted small">2 ngày trước</td>
                                    <td><span class="badge bg-success px-2 py-1">Đã hoàn thành</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script xử lý Toggle Sidebar trên Mobile -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const sidebarToggle = document.getElementById("sidebarToggle");
        const sidebar = document.getElementById("sidebar");
        const sidebarOverlay = document.getElementById("sidebarOverlay");

        // Khi bấm nút Toggle
        if(sidebarToggle) {
            sidebarToggle.addEventListener("click", function() {
                sidebar.classList.add("show");
                sidebarOverlay.classList.add("show");
            });
        }

        // Khi bấm ra ngoài vùng tối (Overlay)
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
