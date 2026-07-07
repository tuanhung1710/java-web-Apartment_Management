<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    /* ==== Sidebar ==== */
    .sidebar {
        width: 250px;
        background-color: #0f172a; /* Xanh đen */
        color: #fff;
        display: flex;
        flex-direction: column;
        transition: all 0.3s ease;
        z-index: 1000;
        height: 100vh;
    }
    .sidebar-header {
        padding: 20px;
        font-size: 1.25rem;
        font-weight: 700;
        text-align: left;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        white-space: nowrap;
    }
    .sidebar-menu {
        list-style: none;
        padding: 10px 0;
        margin: 0;
        flex-grow: 1;
        overflow-y: auto;
    }
    .sidebar-menu li {
        padding: 4px 15px;
    }
    .sidebar-menu a {
        color: #cbd5e1;
        text-decoration: none;
        display: flex;
        align-items: center;
        font-size: 0.95rem;
        font-weight: 500;
        padding: 10px 15px;
        border-radius: 8px;
        transition: 0.2s;
    }
    .sidebar-menu a:hover, .sidebar-menu a.active {
        background-color: rgba(255, 255, 255, 0.1);
        color: #fff;
    }
    .sidebar-menu a.active {
        background-color: #10b981; /* Màu xanh lá (success) cho Cư dân */
    }
    .sidebar-menu i {
        margin-right: 12px;
        font-size: 1.2rem;
    }
    @media (max-width: 991.98px) {
        .sidebar {
            position: fixed;
            height: 100%;
            left: -250px;
        }
        .sidebar.show {
            left: 0;
        }
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
        .sidebar-overlay.show { display: block; }
    }
</style>

<!-- Sidebar Overlay for Mobile -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<nav class="sidebar" id="sidebar">
    <div class="sidebar-header d-flex align-items-center">
        <i class="bi bi-house-heart-fill fs-3 me-2 text-success"></i> 
        <span class="fs-5">Skyline Resident</span>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/resident/home" class="${param.activeMenu == 'home' ? 'active' : ''}"><i class="bi bi-grid-1x2-fill"></i> Trang chủ</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/resident/request/create" class="${param.activeMenu == 'request' ? 'active' : ''}"><i class="bi bi-chat-square-text-fill"></i> Gửi Yêu cầu hỗ trợ</a>
        </li>
        <li>
            <a href="#" class="${param.activeMenu == 'billing' ? 'active' : ''}"><i class="bi bi-receipt"></i> Tra cứu phí dịch vụ</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/auth/change-password"><i class="bi bi-shield-lock-fill"></i> Đổi mật khẩu</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-left"></i> Đăng xuất</a>
        </li>
    </ul>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const sidebarToggle = document.getElementById("sidebarToggle");
        const sidebar = document.getElementById("sidebar");
        const sidebarOverlay = document.getElementById("sidebarOverlay");

        if(sidebarToggle) {
            sidebarToggle.addEventListener("click", function() {
                sidebar.classList.add("show");
                sidebarOverlay.classList.add("show");
            });
        }
        if(sidebarOverlay) {
            sidebarOverlay.addEventListener("click", function() {
                sidebar.classList.remove("show");
                sidebarOverlay.classList.remove("show");
            });
        }
    });
</script>
