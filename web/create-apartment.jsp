<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khởi tạo Căn hộ & Gán Chủ hộ</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-label {
            font-weight: 500;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-primary text-white p-3 rounded-top">
                    <h4 class="mb-0 text-center">Khởi tạo Căn hộ & Gán Chủ hộ</h4>
                </div>
                <div class="card-body p-4">
                    
                    <%-- Hiển thị thông báo lỗi chung khi thất bại từ DAO (ví dụ trùng khóa chính) --%>
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
                                <!-- Giữ lại giá trị cũ trong thuộc tính value để user không phải nhập lại -->
                                <input type="text" class="form-control ${not empty errors['apartment_code'] ? 'is-invalid' : ''}" 
                                       id="apartment_code" name="apartment_code" 
                                       value="${param.apartment_code}" placeholder="VD: A1-1205">
                                <%-- Dùng thẻ c:if để in ra thông báo lỗi dưới ô input --%>
                                <c:if test="${not empty errors['apartment_code']}">
                                    <div class="invalid-feedback d-block">
                                        ${errors['apartment_code']}
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label for="area" class="form-label">Diện Tích (m2) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" class="form-control ${not empty errors['area'] ? 'is-invalid' : ''}" 
                                       id="area" name="area" 
                                       value="${param.area}" placeholder="VD: 75.5">
                                <c:if test="${not empty errors['area']}">
                                    <div class="invalid-feedback d-block">
                                        ${errors['area']}
                                    </div>
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
                                <div class="invalid-feedback d-block">
                                    ${errors['full_name']}
                                </div>
                            </c:if>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="cccd" class="form-label">Căn cước công dân (12 số) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control ${not empty errors['cccd'] ? 'is-invalid' : ''}" 
                                       id="cccd" name="cccd" 
                                       value="${param.cccd}" placeholder="Nhập đúng 12 số">
                                <c:if test="${not empty errors['cccd']}">
                                    <div class="invalid-feedback d-block">
                                        ${errors['cccd']}
                                    </div>
                                </c:if>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">Số Điện Thoại <span class="text-danger">*</span></label>
                                <input type="text" class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" 
                                       id="phone" name="phone" 
                                       value="${param.phone}" placeholder="VD: 0987654321">
                                <c:if test="${not empty errors['phone']}">
                                    <div class="invalid-feedback d-block">
                                        ${errors['phone']}
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="email" class="form-label">Email (Dùng làm Tên Đăng Nhập) <span class="text-danger">*</span></label>
                            <input type="email" class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}" 
                                   id="email" name="email" 
                                   value="${param.email}" placeholder="VD: nguyenvan@example.com">
                            <c:if test="${not empty errors['email']}">
                                <div class="invalid-feedback d-block">
                                    ${errors['email']}
                                </div>
                            </c:if>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold">Khởi tạo và Gán Chủ hộ</button>
                        </div>
                    </form>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
