<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khởi tạo Căn hộ & Gán Chủ hộ - BQL Skyline Apartment</title>
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
        .form-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: none; padding: 30px; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="apartment"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <main class="content-area">
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Khởi tạo Căn hộ & Gán Chủ hộ</h3>
                <p class="text-secondary">Thêm mới căn hộ và cấp phát tài khoản tự động cho cư dân.</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="form-card">
                        <c:if test="${not empty globalError}">
                            <div class="alert alert-danger" role="alert">
                                ${globalError}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/bql/apartment/create" method="POST">
                            
                            <h5 class="mb-3 text-secondary border-bottom pb-2">Thông tin Căn hộ</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="apartment_code" class="form-label">Mã Căn Hộ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['apartment_code'] ? 'is-invalid' : ''}" 
                                           id="apartment_code" name="apartment_code" 
                                           value="${param.apartment_code}" placeholder="VD: A1-1205">
                                    <c:if test="${not empty errors['apartment_code']}">
                                        <div class="invalid-feedback d-block">${errors['apartment_code']}</div>
                                    </c:if>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="area" class="form-label">Diện Tích (m2) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" class="form-control ${not empty errors['area'] ? 'is-invalid' : ''}" 
                                           id="area" name="area" 
                                           value="${param.area}" placeholder="VD: 75.5">
                                    <c:if test="${not empty errors['area']}">
                                        <div class="invalid-feedback d-block">${errors['area']}</div>
                                    </c:if>
                                </div>
                            </div>

                            <h5 class="mb-3 mt-4 text-secondary border-bottom pb-2">Thông tin Chủ Hộ / Đại diện</h5>
                            <div class="mb-3">
                                <label for="full_name" class="form-label">Họ và Tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control ${not empty errors['full_name'] ? 'is-invalid' : ''}" 
                                       id="full_name" name="full_name" 
                                       value="${param.full_name}" placeholder="Nhập họ và tên đầy đủ">
                                <c:if test="${not empty errors['full_name']}">
                                    <div class="invalid-feedback d-block">${errors['full_name']}</div>
                                </c:if>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="cccd" class="form-label">Căn cước công dân (12 số) <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['cccd'] ? 'is-invalid' : ''}" 
                                           id="cccd" name="cccd" 
                                           value="${param.cccd}" placeholder="Nhập đúng 12 số">
                                    <c:if test="${not empty errors['cccd']}">
                                        <div class="invalid-feedback d-block">${errors['cccd']}</div>
                                    </c:if>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Số Điện Thoại <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" 
                                           id="phone" name="phone" 
                                           value="${param.phone}" placeholder="VD: 0987654321">
                                    <c:if test="${not empty errors['phone']}">
                                        <div class="invalid-feedback d-block">${errors['phone']}</div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="email" class="form-label">Email (Dùng làm Tên Đăng Nhập) <span class="text-danger">*</span></label>
                                <input type="email" class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}" 
                                       id="email" name="email" 
                                       value="${param.email}" placeholder="VD: nguyenvan@example.com">
                                <c:if test="${not empty errors['email']}">
                                    <div class="invalid-feedback d-block">${errors['email']}</div>
                                </c:if>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg fw-bold shadow">
                                    <i class="bi bi-person-plus-fill me-2"></i> Khởi tạo và Cấp phát tài khoản
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
</body>
</html>
