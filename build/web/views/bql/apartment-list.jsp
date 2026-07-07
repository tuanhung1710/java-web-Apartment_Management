<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Căn Hộ - BQL Skyline Apartment</title>
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
        <jsp:param name="activeMenu" value="apartment"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <main class="content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold text-dark mb-1">Quản Lý Căn Hộ</h3>
                    <p class="text-secondary mb-0">Danh sách toàn bộ căn hộ trong tòa nhà.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/bql/apartment/create" class="btn btn-primary fw-medium shadow-sm">
                        <i class="bi bi-plus-lg me-1"></i> Thêm Căn Hộ Mới
                    </a>
                </div>
            </div>

            <!-- Error/Success Notification -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <div class="card table-card">
                <div class="card-header table-card-header">
                    <i class="bi bi-building me-2 text-primary"></i> Danh sách Căn hộ
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary">
                                <tr>
                                    <th>ID</th>
                                    <th>Mã Căn Hộ</th>
                                    <th>Diện Tích (m2)</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty apartmentList}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                <i class="bi bi-inbox fs-1 text-secondary d-block mb-2"></i>
                                                Chưa có căn hộ nào.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="apt" items="${apartmentList}">
                                            <tr>
                                                <td class="fw-medium text-muted">#${apt.id}</td>
                                                <td class="fw-bold text-primary">${apt.apartmentCode}</td>
                                                <td>${apt.area}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${apt.status == 'OCCUPIED'}">
                                                            <span class="badge bg-success bg-opacity-10 text-success border border-success">Đang sử dụng</span>
                                                        </c:when>
                                                        <c:when test="${apt.status == 'MAINTENANCE'}">
                                                            <span class="badge bg-warning bg-opacity-10 text-warning border border-warning">Bảo trì</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">${apt.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <button class="btn btn-sm btn-light text-primary me-1" title="Chi tiết"><i class="bi bi-eye"></i></button>
                                                    <button class="btn btn-sm btn-light text-warning me-1" title="Sửa"><i class="bi bi-pencil"></i></button>
                                                    <button class="btn btn-sm btn-light text-danger" title="Xóa"><i class="bi bi-trash"></i></button>
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
