<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skyland Apartment - Quản lý Chung Cư</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }
        .text-primary-custom {
            color: #1a4388 !important; /* Xanh dương đậm - Primary Color */
        }
        .bg-primary-custom {
            background-color: #1a4388 !important;
        }
        .btn-primary-custom {
            background-color: #1a4388;
            border-color: #1a4388;
            color: white;
        }
        .btn-primary-custom:hover, .btn-primary-custom:focus {
            background-color: #123063;
            border-color: #123063;
            color: white;
        }
        .btn-outline-primary-custom {
            color: #1a4388;
            border-color: #1a4388;
            font-weight: 500;
        }
        .btn-outline-primary-custom:hover {
            background-color: #1a4388;
            color: white;
        }
        /* Navbar */
        .navbar {
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        /* Hero Section */
        .hero-section {
            /* Hình ảnh background tòa nhà chung cư cao cấp */
            background: linear-gradient(to right, rgba(26, 67, 136, 0.85), rgba(26, 67, 136, 0.4)), url('https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            color: white;
            padding: 120px 0 160px;
        }
        .hero-title {
            font-weight: 700;
            font-size: 3.5rem;
            line-height: 1.2;
            margin-bottom: 24px;
        }
        .hero-subtitle {
            font-size: 1.25rem;
            font-weight: 300;
            margin-bottom: 40px;
            opacity: 0.9;
        }
        /* Login Card - Đẩy lên chèn vào hero section một chút cho đẹp */
        .login-section {
            margin-top: -100px;
            position: relative;
            z-index: 10;
        }
        .login-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
            overflow: hidden;
            background-color: white;
        }
        /* Nửa trái của Card (Hình ảnh) */
        .login-image {
            background: url('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80') center/cover no-repeat;
            height: 100%;
            min-height: 500px;
        }
        .login-form-container {
            padding: 3.5rem 3rem;
        }
        /* Input Styles */
        .input-group-text {
            background-color: transparent;
            border-right: none;
            color: #6c757d;
        }
        .form-control.border-start-0 {
            border-left: none;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #dee2e6;
        }
        .input-group:focus-within {
            box-shadow: 0 0 0 0.25rem rgba(26, 67, 136, 0.15);
            border-radius: 0.375rem;
        }
        .input-group:focus-within .form-control, 
        .input-group:focus-within .input-group-text, 
        .input-group:focus-within .btn {
            border-color: #1a4388;
            color: #1a4388;
        }
        
        /* Footer */
        .footer {
            background-color: #111827; /* Darker modern shade */
            color: #9ca3af;
            padding: 60px 0 30px;
            margin-top: 80px;
        }
        .footer h5 {
            color: #f3f4f6;
            font-weight: 600;
        }
        .footer a {
            color: #9ca3af;
            text-decoration: none;
            transition: color 0.2s;
        }
        .footer a:hover {
            color: white;
        }
        
        /* Responsive tweaks */
        @media (max-width: 991px) {
            .hero-title {
                font-size: 2.5rem;
            }
            .hero-section {
                padding: 80px 0 120px;
            }
            .login-section {
                margin-top: -60px;
            }
            .login-form-container {
                padding: 2rem;
            }
            .login-image {
                min-height: 250px; /* Optional: show a small image banner on mobile, or hide completely */
            }
        }
    </style>
</head>
<body>

    <!-- 1. Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-2">
        <div class="container">
            <!-- Logo -->
            <a class="navbar-brand text-primary-custom fw-bold fs-4 d-flex align-items-center" href="#">
                <i class="bi bi-buildings-fill fs-3 me-2"></i> Skyland Apartment
            </a>
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <!-- Right Menu -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item me-4 mb-2 mb-lg-0 mt-2 mt-lg-0">
                        <a class="nav-link fw-medium text-dark" href="tel:19001234">
                            <i class="bi bi-telephone-fill text-danger me-1"></i> Hotline: <span class="fw-bold">1900 1234</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-primary-custom px-4 py-2 rounded-pill shadow-sm" href="#login-section">Đăng nhập</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 2. Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-7 col-md-10 text-center text-lg-start">
                    <h1 class="hero-title">Không Gian Sống Thông Minh,<br>Quản Lý Tiện Lợi</h1>
                    <p class="hero-subtitle">Nền tảng số hóa quản lý vận hành chung cư. Mang đến trải nghiệm an toàn, minh bạch và đẳng cấp dành riêng cho cư dân Skyland.</p>
                    <a href="#login-section" class="btn btn-primary-custom btn-lg rounded-pill px-5 py-3 shadow">
                        Tra cứu phí dịch vụ <i class="bi bi-arrow-down-circle ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- 3. Login Section -->
    <section id="login-section" class="login-section container">
        <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12">
                <div class="login-card row g-0">
                    
                    <!-- Nửa trái: Hình minh họa (Bị ẩn trên Mobile nhỏ) -->
                    <div class="col-md-5 d-none d-md-block">
                        <div class="login-image"></div>
                    </div>
                    
                    <!-- Nửa phải: Form Đăng Nhập -->
                    <div class="col-md-7 col-12 bg-white">
                        <div class="login-form-container">
                            
                            <div class="text-center mb-4 pb-2">
                                <div class="d-inline-flex align-items-center justify-content-center bg-primary-custom text-white rounded-circle mb-3" style="width: 60px; height: 60px;">
                                    <i class="bi bi-person-fill fs-2"></i>
                                </div>
                                <h3 class="fw-bold text-dark">Cổng Đăng Nhập</h3>
                                <p class="text-muted">Dành cho Cư dân và Ban quản lý</p>
                            </div>

                            <%-- JSTL: Hiển thị lỗi nếu sai mật khẩu/tài khoản --%>
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger d-flex align-items-center border-0 rounded-3 shadow-sm mb-4" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill fs-5 me-3"></i>
                                    <div>
                                        <strong>Lỗi đăng nhập!</strong><br>
                                        ${errorMessage}
                                    </div>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/login" method="POST">
                                
                                <!-- Input Username (Email/SĐT) -->
                                <div class="mb-4">
                                    <label for="username" class="form-label fw-medium text-dark">Email hoặc Số điện thoại</label>
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                        <input type="text" class="form-control border-start-0" id="username" name="username" 
                                               placeholder="Nhập email hoặc SĐT" required value="${not empty param.username ? param.username : cookie.username.value}">
                                    </div>
                                </div>

                                <!-- Input Password -->
                                <div class="mb-4">
                                    <label for="password" class="form-label fw-medium text-dark">Mật khẩu</label>
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                        <input type="password" class="form-control border-start-0" id="password" name="password" 
                                               placeholder="Nhập mật khẩu" required value="${cookie.password.value}">
                                        <!-- Nút toggle ẩn hiện pass -->
                                        <button class="btn border border-start-0 bg-transparent text-muted" type="button" id="togglePassword">
                                            <i class="bi bi-eye-slash" id="toggleIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Remember & Forgot Password Link -->
                                <div class="d-flex justify-content-between align-items-center mb-4 pb-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="remember" name="remember" ${not empty cookie.username ? 'checked' : ''}>
                                        <label class="form-check-label text-muted user-select-none" for="remember">
                                            Nhớ tài khoản
                                        </label>
                                    </div>
                                    <a href="#" class="text-primary-custom text-decoration-none fw-medium">Quên mật khẩu?</a>
                                </div>

                                <!-- Submit Button -->
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary-custom btn-lg fw-bold rounded-3 shadow">
                                        ĐĂNG NHẬP
                                    </button>
                                </div>
                            </form>
                            
                            <div class="text-center mt-4 pt-2 text-muted small">
                                Tài khoản cư dân mới? Vui lòng liên hệ <br class="d-block d-sm-none"><span class="fw-bold text-dark">Ban Quản Lý</span> để được cấp phát.
                            </div>
                            
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
    </section>

    <!-- 4. Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-5 col-md-6">
                    <h5 class="mb-3"><i class="bi bi-buildings me-2 text-primary-custom"></i>Skyland Apartment</h5>
                    <p class="mb-2 pe-md-4">Khu đô thị kiểu mẫu với hệ thống quản lý vận hành chuẩn quốc tế, mang lại cuộc sống xanh và tiện nghi.</p>
                </div>
                <div class="col-lg-4 col-md-6">
                    <h5 class="mb-3">Thông tin liên hệ</h5>
                    <p class="mb-2"><i class="bi bi-geo-alt me-2 text-primary-custom"></i>Số 1 Đại lộ Thăng Long, Nam Từ Liêm, Hà Nội</p>
                    <p class="mb-2"><i class="bi bi-envelope me-2 text-primary-custom"></i>Email: bql@skylineapartment.com</p>
                    <p class="mb-0"><i class="bi bi-telephone me-2 text-primary-custom"></i>Hotline: 1900 1234 (Hỗ trợ 24/7)</p>
                </div>
                <div class="col-lg-3 col-md-12 text-lg-end">
                    <h5 class="mb-3">Kết nối với chúng tôi</h5>
                    <div class="d-flex justify-content-lg-end mb-3">
                        <a href="#" class="me-3 fs-4"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="me-3 fs-4"><i class="bi bi-youtube"></i></a>
                        <a href="#" class="fs-4"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>
            <hr class="border-secondary mt-5 mb-4">
            <div class="row text-center text-md-start">
                <div class="col-md-6 mb-2 mb-md-0">
                    <p class="small mb-0">&copy; 2026 Skyland Apartment Management. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="small me-3">Chính sách bảo mật</a>
                    <a href="#" class="small">Điều khoản dịch vụ</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle (Kèm Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom Script xử lý JS Logic -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Logic Ẩn/Hiện Mật khẩu
            const togglePasswordBtn = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');

            togglePasswordBtn.addEventListener('click', function() {
                // Kiểm tra type hiện tại
                const isPassword = passwordInput.getAttribute('type') === 'password';
                
                // Chuyển đổi type
                passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
                
                // Đổi icon con mắt
                if (isPassword) {
                    toggleIcon.classList.remove('bi-eye-slash');
                    toggleIcon.classList.add('bi-eye');
                } else {
                    toggleIcon.classList.remove('bi-eye');
                    toggleIcon.classList.add('bi-eye-slash');
                }
            });

            // Hiệu ứng Smooth Scroll cho các anchor links (vd: nút cuộn xuống Login)
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    const targetId = this.getAttribute('href');
                    if (targetId && targetId !== '#') {
                        e.preventDefault();
                        const targetElement = document.querySelector(targetId);
                        if(targetElement) {
                            // Cuộn mượt mà đến phần tử
                            targetElement.scrollIntoView({ behavior: 'smooth' });
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>
