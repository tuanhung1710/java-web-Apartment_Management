package filter;

import model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // 1. Các đường dẫn public không cần đăng nhập
        if (path.startsWith("/css") || path.startsWith("/js") || path.startsWith("/images") || path.startsWith("/views/assets")
                || path.equals("/login") || path.equals("/logout") || path.equals("/request-account")
                || path.equals("/index.jsp") || path.equals("/test-users.jsp") || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Logic 1: Kiểm tra đăng nhập
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
        }
        
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }
        
        // 3. Logic 2: Kiểm tra trạng thái REQUIRE_PASSWORD_CHANGE
        if ("REQUIRE_PASSWORD_CHANGE".equals(currentUser.getStatus())) {
            // Cho phép truy cập trang đổi mật khẩu hoặc logout
            if (path.equals("/auth/change-password") || path.equals("/logout")) {
                chain.doFilter(request, response);
            } else {
                // Ép redirect về trang đổi mật khẩu
                res.sendRedirect(req.getContextPath() + "/auth/change-password");
            }
            return;
        }
        
        // 4. Logic 3: Phân quyền Role-Based theo tiền tố URL
        String role = currentUser.getRole();
        
        if (path.startsWith("/bql/") || path.startsWith("/views/bql/")) {
            if ("ADMIN".equals(role) || "MANAGER".equals(role)) {
                chain.doFilter(request, response);
            } else {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang quản trị BQL.");
            }
            return;
        }
        
        if (path.startsWith("/resident/") || path.startsWith("/views/resident/")) {
            if ("RESIDENT".equals(role)) {
                chain.doFilter(request, response);
            } else {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang cư dân.");
            }
            return;
        }
        
        if (path.startsWith("/staff/") || path.startsWith("/views/staff/")) {
            if ("TECHNICIAN".equals(role) || "RECEPTIONIST".equals(role) || "GUARD".equals(role)) {
                chain.doFilter(request, response);
            } else {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang nhân viên.");
            }
            return;
        }
        
        // Nếu không thuộc các route được bảo vệ đặc biệt, cho phép đi qua
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}
