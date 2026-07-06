package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // GIẢ ĐỊNH: Lấy thông tin user từ DB thành công
        // User user = userDAO.login(request.getParameter("username"), request.getParameter("password"));
        
        // Mock data để demo quá trình điều hướng
        User currentUser = new User();
        currentUser.setUsername("Admin_TòaNhà");
        currentUser.setRole("MANAGER"); // Thử nghiệm các role: MANAGER, ADMIN, RESIDENT, TECHNICIAN
        currentUser.setStatus("ACTIVE"); // Thử nghiệm status: ACTIVE, REQUIRE_PASSWORD_CHANGE
        
        if (currentUser != null) {
            // Lưu đối tượng User vào Session
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", currentUser);
            
            // 1. Kiểm tra trạng thái tài khoản: Nếu Đăng nhập lần đầu thì ép đổi mật khẩu
            if ("REQUIRE_PASSWORD_CHANGE".equals(currentUser.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/auth/change-password");
                return; // Kết thúc sớm tránh chạy logic bên dưới
            }
            
            // 2. Role-Based Redirect (Điều hướng theo Role)
            String role = currentUser.getRole();
            if (role == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
            
            switch (role.toUpperCase()) {
                case "MANAGER":
                case "ADMIN":
                    // Chuyển hướng tới trang Dashboard BQL
                    response.sendRedirect(request.getContextPath() + "/bql/dashboard");
                    break;
                case "RESIDENT":
                    // Chuyển hướng tới trang Cư Dân
                    response.sendRedirect(request.getContextPath() + "/resident/home");
                    break;
                case "TECHNICIAN":
                case "RECEPTIONIST":
                case "GUARD":
                    // Chuyển hướng tới trang Nhân viên/Kỹ thuật
                    response.sendRedirect(request.getContextPath() + "/staff/tasks");
                    break;
                default:
                    // Mặc định ném ra trang chủ hoặc lỗi nếu role không hợp lệ
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    break;
            }
        } else {
            // Login thất bại, báo lỗi
            request.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tránh lỗi truy cập trực tiếp bằng GET
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
