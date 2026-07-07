<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ Cư Dân - Skyline Apartment</title>
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
        
        .kpi-card { border: none; border-radius: 12px; color: #fff; box-shadow: 0 4px 6px rgba(0,0,0,0.05); overflow: hidden; position: relative;}
        .kpi-card .inner { padding: 20px; position: relative; z-index: 2; }
        .kpi-card h3 { font-size: 2.2rem; margin-bottom: 0; font-weight: 700; }
        .kpi-card p { margin-bottom: 5px; font-size: 0.95rem; opacity: 0.9; font-weight: 500;}
        .kpi-card i.bg-icon { font-size: 4rem; opacity: 0.2; position: absolute; right: 15px; top: 50%; transform: translateY(-50%); z-index: 1; }
        
        .card-green { background: linear-gradient(135deg, #10b981, #059669); }
        .card-orange { background: linear-gradient(135deg, #f59e0b, #ea580c); }
        .card-red { background: linear-gradient(135deg, #ef4444, #dc2626); }
        
        .action-card { background: #fff; border-radius: 12px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); transition: transform 0.2s; cursor: pointer; text-decoration: none; color: inherit; display: block;}
        .action-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="home"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <main class="content-area">
            
            <c:if test="${param.success == 'request_created'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Gửi yêu cầu hỗ trợ thành công! Ban Quản Lý sẽ sớm xử lý.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="mb-4">
                <h3 class="fw-bold text-dark">
                    Xin chào, <span class="text-success"><c:out value="${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Cư dân'}"/>!</span>
                </h3>
                <p class="text-secondary">Chúc bạn một ngày tốt lành tại Skyline Apartment.</p>
            </div>

            <!-- KPI Cards -->
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="card kpi-card card-green h-100">
                        <div class="inner">
                            <p>Phí Dịch Vụ Tháng Này</p>
                            <h3>Đã thanh toán</h3>
                        </div>
                        <i class="bi bi-check-circle-fill bg-icon"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card kpi-card card-orange h-100">
                        <div class="inner">
                            <p>Yêu cầu đang xử lý</p>
                            <h3>1</h3>
                        </div>
                        <i class="bi bi-tools bg-icon"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card kpi-card card-red h-100">
                        <div class="inner">
                            <p>Cảnh báo / Thông báo</p>
                            <h3 class="fs-4 mt-2">Bảo trì thang máy A2</h3>
                        </div>
                        <i class="bi bi-exclamation-triangle-fill bg-icon"></i>
                    </div>
                </div>
            </div>

            <h5 class="fw-bold text-dark mb-3">Dịch Vụ Tiện Ích</h5>
            <div class="row g-4">
                <div class="col-6 col-md-3">
                    <a href="${pageContext.request.contextPath}/resident/request/create" class="card action-card text-center p-4 h-100">
                        <i class="bi bi-chat-square-text text-primary fs-1 mb-2"></i>
                        <h6 class="fw-bold mb-0">Gửi Yêu Cầu</h6>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="#" class="card action-card text-center p-4 h-100">
                        <i class="bi bi-receipt text-success fs-1 mb-2"></i>
                        <h6 class="fw-bold mb-0">Hóa Đơn Của Tôi</h6>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="#" class="card action-card text-center p-4 h-100">
                        <i class="bi bi-car-front-fill text-warning fs-1 mb-2"></i>
                        <h6 class="fw-bold mb-0">Đăng ký Thẻ Xe</h6>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="#" class="card action-card text-center p-4 h-100">
                        <i class="bi bi-info-circle-fill text-info fs-1 mb-2"></i>
                        <h6 class="fw-bold mb-0">Sổ Tay Cư Dân</h6>
                    </a>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
