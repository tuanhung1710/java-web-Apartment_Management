<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi Yêu Cầu Hỗ Trợ - Cư Dân</title>
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
        .form-label { font-weight: 500; }
        .card { border-radius: 12px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
        .card-header { border-top-left-radius: 12px !important; border-top-right-radius: 12px !important; }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="layout/sidebar.jsp">
        <jsp:param name="activeMenu" value="request"/>
    </jsp:include>

    <!-- Main Content -->
    <div class="main-content">
        <jsp:include page="layout/header.jsp" />

        <main class="content-area">
            <div class="mb-4">
                <h3 class="fw-bold text-dark">Tạo Yêu Cầu Hỗ Trợ Mới</h3>
                <p class="text-secondary">Gửi các phản ánh, báo cáo sự cố hoặc yêu cầu chuyển đồ để Ban Quản Lý xử lý.</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="card">
                        <div class="card-body p-4">
                            
                            <c:if test="${not empty globalError}">
                                <div class="alert alert-danger d-flex align-items-center" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2"></i>
                                    <div>${globalError}</div>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/resident/request/create" method="POST">
                                
                                <div class="mb-3">
                                    <label for="title" class="form-label">Tiêu đề yêu cầu <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control ${not empty errors['title'] ? 'is-invalid' : ''}" 
                                           id="title" name="title" value="${param.title}" placeholder="VD: Sửa ống nước nhà tắm bị rò rỉ">
                                    <c:if test="${not empty errors['title']}">
                                        <div class="invalid-feedback d-block">${errors['title']}</div>
                                    </c:if>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="request_type" class="form-label">Loại yêu cầu <span class="text-danger">*</span></label>
                                    <select class="form-select ${not empty errors['request_type'] ? 'is-invalid' : ''}" 
                                            id="request_type" name="request_type">
                                        <option value="" disabled ${empty param.request_type ? 'selected' : ''}>--- Chọn loại yêu cầu ---</option>
                                        <option value="REPAIR" ${param.request_type == 'REPAIR' ? 'selected' : ''}>Sửa chữa/Bảo trì</option>
                                        <option value="MOVE_IN_OUT" ${param.request_type == 'MOVE_IN_OUT' ? 'selected' : ''}>Chuyển đồ (Chuyển đến/đi)</option>
                                        <option value="PARKING_REGISTRATION" ${param.request_type == 'PARKING_REGISTRATION' ? 'selected' : ''}>Đăng ký gửi xe</option>
                                        <option value="COMPLAINT" ${param.request_type == 'COMPLAINT' ? 'selected' : ''}>Phản ánh/Khiếu nại</option>
                                        <option value="OTHER" ${param.request_type == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                    <c:if test="${not empty errors['request_type']}">
                                        <div class="invalid-feedback d-block">${errors['request_type']}</div>
                                    </c:if>
                                </div>
                                
                                <div class="mb-3" id="scheduledTimeContainer" style="display: none;">
                                    <label for="scheduled_time" class="form-label text-primary">
                                        <i class="bi bi-clock-history me-1"></i> Ngày giờ dự kiến chuyển đồ <span class="text-danger">*</span>
                                    </label>
                                    <input type="datetime-local" class="form-control ${not empty errors['scheduled_time'] ? 'is-invalid' : ''}" 
                                           id="scheduled_time" name="scheduled_time" value="${param.scheduled_time}">
                                    <div class="form-text text-muted">
                                        <strong>Lưu ý:</strong> BQL chỉ hỗ trợ dùng thang máy hàng hóa để chuyển đồ trong giờ hành chính: <br>
                                        Sáng: <b>08:00 - 11:30</b> | Chiều: <b>14:00 - 17:00</b>
                                    </div>
                                    <c:if test="${not empty errors['scheduled_time']}">
                                        <div class="invalid-feedback d-block fw-bold">${errors['scheduled_time']}</div>
                                    </c:if>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="description" class="form-label">Nội dung chi tiết <span class="text-danger">*</span></label>
                                    <textarea class="form-control ${not empty errors['description'] ? 'is-invalid' : ''}" 
                                              id="description" name="description" rows="5" 
                                              placeholder="Mô tả chi tiết vấn đề của bạn để BQL hỗ trợ tốt nhất...">${param.description}</textarea>
                                    <c:if test="${not empty errors['description']}">
                                        <div class="invalid-feedback d-block">${errors['description']}</div>
                                    </c:if>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                    <a href="${pageContext.request.contextPath}/resident/home" class="btn btn-outline-secondary px-4 me-md-2">Hủy bỏ</a>
                                    <button type="submit" class="btn btn-primary px-5 fw-bold shadow-sm">
                                        <i class="bi bi-send me-1"></i> Gửi Yêu Cầu
                                    </button>
                                </div>
                            </form>
                            
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const requestTypeSelect = document.getElementById('request_type');
        const scheduledTimeContainer = document.getElementById('scheduledTimeContainer');

        function toggleScheduledTime() {
            if (requestTypeSelect.value === 'MOVE_IN_OUT') {
                scheduledTimeContainer.style.display = 'block';
            } else {
                scheduledTimeContainer.style.display = 'none';
            }
        }

        toggleScheduledTime();
        requestTypeSelect.addEventListener('change', toggleScheduledTime);
    });
</script>
</body>
</html>
