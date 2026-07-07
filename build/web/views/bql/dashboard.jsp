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
        .wrapper {
            display: flex;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
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
    </style>
</head>
<body>

<div class="wrapper">
    <!-- Truyền tham số activeMenu = 'dashboard' -->
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard"/>
    </jsp:include>

    <!-- 2. Main Content -->
    <div class="main-content">
        
        <jsp:include page="layout/header.jsp" />

        <!-- Content Area -->
        <main class="content-area">
            
            <c:if test="${param.success == 'apartment_created'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Khởi tạo căn hộ thành công! Cư dân đã được cấp phát tài khoản.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${param.success == 'billing_created'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Đã tạo hóa đơn thu phí dịch vụ thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Welcome text lấy từ Session bằng JSTL -->
            <div class="mb-4">
                <h3 class="fw-bold text-dark">
                    Xin chào, <span class="text-primary"><c:out value="${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Ban Quản Lý'}"/>!</span>
                </h3>
                <p class="text-secondary">Dưới đây là tổng quan tình hình vận hành tòa nhà hôm nay.</p>
            </div>

            <!-- 4 Khối KPI Cards -->
            <div class="row g-4 mb-5">
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-blue h-100">
                        <div class="inner">
                            <p>Tổng số căn hộ</p>
                            <h3>250</h3>
                        </div>
                        <i class="bi bi-door-open-fill bg-icon"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-green h-100">
                        <div class="inner">
                            <p>Cư dân đang ở</p>
                            <h3>840</h3>
                        </div>
                        <i class="bi bi-people-fill bg-icon"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="card kpi-card card-orange h-100 position-relative">
                        <div class="inner">
                            <p class="fw-bold">Yêu cầu chờ xử lý</p>
                            <h3>15</h3>
                        </div>
                        <i class="bi bi-exclamation-triangle-fill bg-icon"></i>
                        <span class="position-absolute top-0 end-0 p-2 text-white"><i class="bi bi-circle-fill text-danger"></i> Mới</span>
                    </div>
                </div>
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
                    <div><i class="bi bi-list-task me-2 text-primary"></i>Yêu cầu hỗ trợ mới nhất từ Cư dân</div>
                    <a href="${pageContext.request.contextPath}/bql/request/manage" class="btn btn-sm btn-outline-primary fw-medium px-3">Quản lý Yêu cầu</a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary">
                                <tr>
                                    <th>Mã YC</th>
                                    <th>Căn hộ</th>
                                    <th>Nội dung yêu cầu</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1005</td>
                                    <td class="fw-medium">A1-1205</td>
                                    <td>Sửa ống nước nhà tắm bị rò rỉ</td>
                                    <td><span class="badge bg-warning text-dark px-2 py-1">Chờ xử lý</span></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-primary">#REQ-1004</td>
                                    <td class="fw-medium">B2-0802</td>
                                    <td>Đăng ký sử dụng thang máy chuyển đồ</td>
                                    <td><span class="badge bg-warning text-dark px-2 py-1">Chờ xử lý</span></td>
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
</body>
</html>
