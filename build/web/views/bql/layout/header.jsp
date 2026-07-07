<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
    /* Top Navbar */
    .top-navbar {
        height: 64px;
        background-color: #fff;
        box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
        flex-shrink: 0;
    }
    .search-bar {
        position: relative;
        width: 300px;
    }
    .search-bar input {
        padding-left: 35px;
        border-radius: 20px;
        background-color: #f1f5f9;
        border: none;
    }
    .search-bar input:focus {
        box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        background-color: #fff;
        border: 1px solid #dee2e6;
    }
    .search-bar i {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #94a3b8;
    }
    @media (max-width: 991.98px) {
        .search-bar { width: 200px; }
    }
</style>

<header class="top-navbar">
    <div class="d-flex align-items-center">
        <!-- Hamburger Menu Toggle cho Mobile -->
        <button class="btn btn-light d-lg-none me-3" id="sidebarToggle">
            <i class="bi bi-list fs-5"></i>
        </button>
        <!-- Thanh Search -->
        <div class="search-bar d-none d-md-block">
            <i class="bi bi-search"></i>
            <input type="text" class="form-control" placeholder="Tìm kiếm căn hộ, mã yêu cầu...">
        </div>
    </div>
    
    <div class="d-flex align-items-center">
        <!-- Icon Chuông -->
        <a href="#" class="text-secondary position-relative me-4 fs-5">
            <i class="bi bi-bell-fill"></i>
            <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
        </a>
        
        <!-- User Profile Dropdown -->
        <div class="dropdown">
            <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="https://ui-avatars.com/api/?name=${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Admin'}&background=0d6efd&color=fff" 
                     alt="Avatar" width="36" height="36" class="rounded-circle me-2 shadow-sm">
                <span class="fw-medium d-none d-sm-block">
                    <c:out value="${not empty sessionScope.currentUser.username ? sessionScope.currentUser.username : 'Ban Quản Lý'}"/>
                </span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" aria-labelledby="userDropdown">
                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/auth/change-password"><i class="bi bi-shield-lock me-2"></i> Đổi mật khẩu</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</header>
