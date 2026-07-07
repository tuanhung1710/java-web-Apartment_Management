<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu - Skyland Apartment</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            background-color: white;
            width: 100%;
            max-width: 500px;
            padding: 3rem 2rem;
        }
        .bg-primary-custom {
            background-color: #1a4388 !important;
        }
        .text-primary-custom {
            color: #1a4388 !important;
        }
        .btn-primary-custom {
            background-color: #1a4388;
            border-color: #1a4388;
            color: white;
        }
        .btn-primary-custom:hover {
            background-color: #123063;
            border-color: #123063;
            color: white;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(26, 67, 136, 0.15);
            border-color: #1a4388;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="text-center mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-primary-custom text-white rounded-circle mb-3" style="width: 60px; height: 60px;">
                <i class="bi bi-shield-lock-fill fs-2"></i>
            </div>
            <h3 class="fw-bold text-dark">Đổi Mật Khẩu</h3>
        </div>

        <div class="alert alert-warning d-flex align-items-center border-0 rounded-3 mb-4" role="alert">
            <i class="bi bi-info-circle-fill fs-5 me-3"></i>
            <div class="small">
                Tài khoản của bạn cần được đổi mật khẩu trong lần đăng nhập đầu tiên để đảm bảo bảo mật.
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center border-0 rounded-3 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 me-3"></i>
                <div class="small">
                    <strong>Lỗi!</strong><br>
                    ${errorMessage}
                </div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/change-password" method="POST">
            
            <!-- Mật khẩu hiện tại -->
            <div class="mb-3">
                <label class="form-label fw-medium text-dark">Mật khẩu hiện tại</label>
                <div class="input-group">
                    <span class="input-group-text bg-transparent text-muted"><i class="bi bi-key"></i></span>
                    <input type="password" class="form-control border-start-0" id="old_password" name="old_password" required>
                    <button class="btn border border-start-0 text-muted" type="button" onclick="togglePassword('old_password', 'icon1')">
                        <i class="bi bi-eye-slash" id="icon1"></i>
                    </button>
                </div>
            </div>

            <!-- Mật khẩu mới -->
            <div class="mb-3">
                <label class="form-label fw-medium text-dark">Mật khẩu mới (Tối thiểu 8 ký tự)</label>
                <div class="input-group">
                    <span class="input-group-text bg-transparent text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control border-start-0" id="new_password" name="new_password" minlength="8" required>
                    <button class="btn border border-start-0 text-muted" type="button" onclick="togglePassword('new_password', 'icon2')">
                        <i class="bi bi-eye-slash" id="icon2"></i>
                    </button>
                </div>
            </div>

            <!-- Xác nhận mật khẩu mới -->
            <div class="mb-4">
                <label class="form-label fw-medium text-dark">Xác nhận mật khẩu mới</label>
                <div class="input-group">
                    <span class="input-group-text bg-transparent text-muted"><i class="bi bi-check-circle"></i></span>
                    <input type="password" class="form-control border-start-0" id="confirm_password" name="confirm_password" minlength="8" required>
                    <button class="btn border border-start-0 text-muted" type="button" onclick="togglePassword('confirm_password', 'icon3')">
                        <i class="bi bi-eye-slash" id="icon3"></i>
                    </button>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary-custom py-2 fw-bold rounded-3">Cập Nhật Mật Khẩu</button>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-light py-2 text-muted fw-medium rounded-3">Hủy và Đăng xuất</a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('bi-eye-slash', 'bi-eye');
            } else {
                input.type = 'password';
                icon.classList.replace('bi-eye', 'bi-eye-slash');
            }
        }
    </script>
</body>
</html>
