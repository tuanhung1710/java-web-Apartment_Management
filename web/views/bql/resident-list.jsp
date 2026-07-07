<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Cư Dân - BQL Skyline Apartment</title>
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
        
        .table-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: none; }
        .table-card-header { background: transparent; border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-weight: 700; font-size: 1.1rem; color: #1e293b; }
        .table > :not(caption) > * > * { padding: 12px 20px; vertical-align: middle; }
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
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Quản Lý Cư Dân</h3>
                    <p class="text-secondary mb-0">Danh sách thông tin chủ hộ, thành viên và người thuê.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/bql/resident/add" class="btn btn-primary fw-medium shadow-sm">
                        <i class="bi bi-person-plus-fill me-1"></i> Thêm Cư Dân
                    </a>
                </div>
            </div>

            <div class="card table-card">
                <div class="card-header table-card-header">
                    <i class="bi bi-people-fill me-2 text-primary"></i> Thông tin Cư dân & Người lưu trú
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary">
                                <tr>
                                    <th>Căn Hộ</th>
                                    <th>Họ và Tên</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Tài khoản (Email)</th>
                                    <th>Vai trò</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty residentList}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                <i class="bi bi-people fs-1 text-secondary d-block mb-2"></i>
                                                Chưa có dữ liệu cư dân.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="res" items="${residentList}">
                                            <tr>
                                                <td class="fw-bold text-primary">${res.apartmentCode}</td>
                                                <td class="fw-medium">${res.fullName}</td>
                                                <td>${res.phone}</td>
                                                <td><span class="text-muted small">${res.email}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${res.relationship == 'OWNER' && res.representative}">
                                                            <span class="badge bg-success"><i class="bi bi-star-fill me-1"></i> Chủ hộ</span>
                                                        </c:when>
                                                        <c:when test="${res.relationship == 'OWNER' && !res.representative}">
                                                            <span class="badge bg-info text-dark">Thành viên (Chủ hộ)</span>
                                                        </c:when>
                                                        <c:when test="${res.relationship == 'TENANT' && res.representative}">
                                                            <span class="badge bg-warning text-dark"><i class="bi bi-person-badge-fill me-1"></i> Khách thuê (Đại diện)</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${res.relationship}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <button class="btn btn-sm btn-light text-primary me-1" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                                    <button class="btn btn-sm btn-light text-danger" title="Khóa TK"><i class="bi bi-lock-fill"></i></button>
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
