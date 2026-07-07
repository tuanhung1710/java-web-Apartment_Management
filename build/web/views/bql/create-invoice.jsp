<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chốt Chỉ Số & Xuất Hóa Đơn - BQL Skyline Apartment</title>
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
        .water-index-box { background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-top: 10px; }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="billing"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

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

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
