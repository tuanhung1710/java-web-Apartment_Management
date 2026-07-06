<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Đã sửa cứng lại thẻ JSTL thành link chuẩn java.sun.com để tương thích với JSTL 2.0.0 --%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Công việc của tôi - Nhân Viên BQL</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f1f5f9; 
            padding-bottom: 80px; 
            -webkit-tap-highlight-color: transparent;
        }
        
        /* Navbar dính trên cùng Mobile */
        .top-navbar {
            background-color: #1e293b;
            color: white;
            padding: 15px 20px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }
        
        /* Cấu trúc Card Mobile-First */
        .task-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.1s ease;
        }
        .task-card:active {
            transform: scale(0.98); /* Hiệu ứng nhún mượt trên điện thoại */
        }
        .task-header {
            background-color: #fff;
            border-bottom: 1px solid #e2e8f0;
            padding: 14px 16px;
        }
        .task-body {
            padding: 16px;
            background-color: #fff;
        }
        .task-footer {
            background-color: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 12px 16px;
        }
        
        textarea.form-control { resize: none; }
    </style>
</head>
<body>

    <!-- Header Navbar -->
    <header class="top-navbar d-flex justify-content-between align-items-center">
        <h5 class="mb-0 fw-bold"><i class="bi bi-tools text-warning me-2"></i> Việc Của Tôi</h5>
        <a href="${pageContext.request.contextPath}/logout" class="text-white text-decoration-none" aria-label="Đăng xuất">
            <i class="bi bi-box-arrow-right fs-4"></i>
        </a>
    </header>

    <div class="container mt-4 px-3">
        
        <!-- Lời chào Mobile -->
        <div class="mb-4">
            <h5 class="text-dark fw-bold mb-1">Xin chào, <c:out value="${sessionScope.currentUser.username}"/>!</h5>
            <p class="text-secondary small mb-0">Dưới đây là danh sách công việc BQL phân công cho bạn.</p>
        </div>

        <!-- Success Alert -->
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-3" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Tuyệt vời!</strong> Bạn đã cập nhật thành công 1 công việc.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Error Alert -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Danh sách Card Công Việc -->
        <div class="row">
            <c:choose>
                <c:when test="${empty assignedTasks}">
                    <!-- Rỗng việc -->
                    <div class="col-12 text-center py-5 mt-3">
                        <i class="bi bi-cup-hot-fill fs-1 text-secondary opacity-25 d-block mb-3"></i>
                        <h6 class="text-secondary fw-bold">Hiện không có công việc nào!</h6>
                        <p class="text-muted small">Bạn có thể nghỉ ngơi hoặc đi kiểm tra khu vực.</p>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <!-- Danh sách việc -->
                    <c:forEach var="task" items="${assignedTasks}">
                        <div class="col-12 col-md-6 col-lg-4">
                            
                            <!-- Thẻ 1 Công việc -->
                            <div class="card task-card shadow-sm mb-4">
                                <!-- Card Header -->
                                <div class="task-header d-flex justify-content-between align-items-center">
                                    <span class="text-secondary fw-bold small">Mã YC: <span class="text-primary">#<c:out value="${task.requestId}"/></span></span>
                                    <span class="badge bg-danger py-2 px-3 shadow-sm rounded-pill"><i class="bi bi-door-open-fill me-1"></i> <c:out value="${task.apartmentCode}"/></span>
                                </div>
                                
                                <!-- Card Body -->
                                <div class="task-body">
                                    <h5 class="card-title fw-bold text-dark mb-2"><c:out value="${task.title}"/></h5>
                                    <p class="card-text text-muted mb-3" style="font-size: 0.95rem; line-height: 1.5;">
                                        <c:out value="${task.description}"/>
                                    </p>
                                    <div class="d-flex align-items-center text-secondary small fw-medium">
                                        <i class="bi bi-clock-history text-primary me-2"></i> 
                                        Giao lúc: <c:out value="${task.createdAt}"/>
                                    </div>
                                </div>
                                
                                <!-- Card Footer -->
                                <div class="task-footer">
                                    <!-- Nút to dễ bấm trên Mobile -->
                                    <button type="button" class="btn btn-primary w-100 fw-bold py-2 shadow-sm rounded-3" 
                                            data-bs-toggle="modal" data-bs-target="#updateModal"
                                            onclick="prepareUpdateForm('${task.requestId}', '${task.title}')">
                                        <i class="bi bi-pencil-square me-1"></i> Cập nhật tiến độ
                                    </button>
                                </div>
                            </div>
                            
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Bootstrap Modal Cập Nhật -->
    <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
        <!-- Căn Modal vào giữa màn hình cho thân thiện Mobile -->
        <div class="modal-dialog modal-dialog-centered modal-fullscreen-sm-down">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white border-0 py-3">
                    <h5 class="modal-title fw-bold" id="updateModalLabel">
                        <i class="bi bi-clipboard-check-fill me-2"></i> Báo cáo Xử lý
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                
                <form action="${pageContext.request.contextPath}/staff/tasks" method="POST">
                    <div class="modal-body p-4 bg-light">
                        <div class="alert alert-info border-0 shadow-sm rounded-3 py-2 px-3 mb-4">
                            <span class="text-primary small fw-bold">YÊU CẦU:</span> <br>
                            <strong class="text-dark" id="modalTaskTitle"></strong>
                        </div>
                        
                        <!-- Input ẩn chứa ID công việc -->
                        <input type="hidden" name="request_id" id="modalRequestId">
                        
                        <!-- Chọn Trạng thái -->
                        <div class="mb-4">
                            <label for="new_status" class="form-label fw-bold text-dark">Tình trạng <span class="text-danger">*</span></label>
                            <select class="form-select form-select-lg shadow-sm border-0" id="new_status" name="new_status" required>
                                <option value="" disabled selected>-- Chạm để chọn --</option>
                                <option value="COMPLETED" class="text-success fw-bold">✔️ Đã xử lý xong (COMPLETED)</option>
                                <option value="WAITING_CONFIRMATION" class="text-warning fw-bold">⏳ Chờ xác nhận / Chờ vật tư</option>
                            </select>
                        </div>
                        
                        <!-- Ghi chú xử lý -->
                        <div class="mb-3">
                            <label for="resolution_note" class="form-label fw-bold text-dark">Ghi chú xử lý (Bằng chứng) <span class="text-danger">*</span></label>
                            <textarea class="form-control shadow-sm border-0 rounded-3" id="resolution_note" name="resolution_note" rows="5" 
                                      placeholder="Ví dụ: Đã thay xong bóng đèn khu vực hành lang lúc 15h30, không phát sinh thêm chi phí..." required></textarea>
                            <div class="form-text mt-2 text-muted">
                                <i class="bi bi-info-circle me-1"></i> Bắt buộc mô tả chi tiết nội dung đã làm để BQL và cư dân nghiệm thu.
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer border-0 bg-white p-3 d-flex flex-column gap-2 flex-sm-row">
                        <!-- Nút hủy và submit đặt cạnh nhau hoặc chồng lên nhau trên màn hình nhỏ xíu -->
                        <button type="button" class="btn btn-light w-100 py-2 fw-medium border shadow-sm" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow">
                            <i class="bi bi-cloud-arrow-up-fill me-1"></i> Gửi Báo Cáo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JS Logic Modal -->
    <script>
        // Bơm dữ liệu từ nút bấm ngoài Card vào trong Popup Modal
        function prepareUpdateForm(requestId, taskTitle) {
            document.getElementById('modalRequestId').value = requestId;
            document.getElementById('modalTaskTitle').textContent = taskTitle;
            
            // Đặt lại (Reset) các ô nhập liệu cũ để tránh nhầm việc
            document.getElementById('resolution_note').value = '';
            document.getElementById('new_status').selectedIndex = 0;
        }
    </script>
</body>
</html>
