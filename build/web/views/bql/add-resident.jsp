<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Cư Dân - BQL Skyline Apartment</title>
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
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="resident"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <main class="content-area">
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Thêm Cư Dân Vào Căn Hộ</h3>
                <p class="text-secondary">Đăng ký thông tin cho người nhà hoặc khách thuê vào một căn hộ có sẵn.</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="form-card">
                        
                        <c:if test="${not empty globalError}">
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${globalError}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/bql/resident/add" method="POST">
                            
                            <h5 class="mb-3 text-secondary border-bottom pb-2">Thông tin Căn hộ</h5>
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-medium">Chọn căn hộ <span class="text-danger">*</span></label>
                                    <select class="form-select ${not empty errors['apartment_id'] ? 'is-invalid' : ''}" name="apartment_id">
                                        <option value="" disabled selected>-- Chọn căn hộ --</option>
                                        <c:forEach var="apt" items="${aptList}">
                                            <option value="${apt.id}" ${param.apartment_id == apt.id ? 'selected' : ''}>Căn ${apt.apartmentCode}</option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${not empty errors['apartment_id']}"><div class="invalid-feedback d-block">${errors['apartment_id']}</div></c:if>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-medium">Vai trò (Mối quan hệ) <span class="text-danger">*</span></label>
                                    <select class="form-select ${not empty errors['relationship'] ? 'is-invalid' : ''}" name="relationship">
                                        <option value="" disabled selected>-- Chọn vai trò --</option>
                                        <option value="FAMILY_MEMBER" ${param.relationship == 'FAMILY_MEMBER' ? 'selected' : ''}>Người nhà / Thành viên</option>
                                        <option value="TENANT" ${param.relationship == 'TENANT' ? 'selected' : ''}>Khách thuê (Đại diện thuê)</option>
                                    </select>
                                    <c:if test="${not empty errors['relationship']}"><div class="invalid-feedback d-block">${errors['relationship']}</div></c:if>
                                </div>
                            </div>

                            <h5 class="mb-3 text-secondary border-bottom pb-2">Thông tin Cư Dân</h5>
                            <div class="mb-3">
                                <label class="form-label fw-medium">Họ và Tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control ${not empty errors['full_name'] ? 'is-invalid' : ''}" name="full_name" value="${param.full_name}">
                                <c:if test="${not empty errors['full_name']}"><div class="invalid-feedback d-block">${errors['full_name']}</div></c:if>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-medium">CCCD <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['cccd'] ? 'is-invalid' : ''}" name="cccd" value="${param.cccd}">
                                    <c:if test="${not empty errors['cccd']}"><div class="invalid-feedback d-block">${errors['cccd']}</div></c:if>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-medium">Số Điện Thoại <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" name="phone" value="${param.phone}">
                                    <c:if test="${not empty errors['phone']}"><div class="invalid-feedback d-block">${errors['phone']}</div></c:if>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-medium">Email (Tên đăng nhập) <span class="text-danger">*</span></label>
                                <input type="email" class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}" name="email" value="${param.email}">
                                <c:if test="${not empty errors['email']}"><div class="invalid-feedback d-block">${errors['email']}</div></c:if>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg fw-bold shadow">
                                    <i class="bi bi-person-plus-fill me-2"></i> Thêm Cư Dân Mới
                                </button>
                                <a href="${pageContext.request.contextPath}/bql/resident/list" class="btn btn-light fw-medium">Hủy bỏ</a>
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
