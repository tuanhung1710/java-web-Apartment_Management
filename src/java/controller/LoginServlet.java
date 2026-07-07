package controller;

import model.User;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bước 1: Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Bước 2: Validate rỗng
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // Bước 3: Kiểm tra tồn tại
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);
        
        if (user == null) {
            request.setAttribute("errorMessage", "Tài khoản không tồn tại trong hệ thống.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // Bước 4: Kiểm tra Mật khẩu
        // Hỗ trợ linh hoạt 3 trường hợp:
        // 1. Mật khẩu chuẩn SHA-256 (tạo từ ApartmentCreateServlet)
        // 2. Mật khẩu Dummy có tiền tố "hashed_" (trong data cứng của db)
        // 3. Mật khẩu trơn (phòng hờ rủi ro lưu nhầm trơn vào db)
        String hashedInput = hashPassword(password);
        String dummyInput = "hashed_" + password;
        
        if (!password.equals(user.getPassword()) && 
            !dummyInput.equals(user.getPassword()) && 
            !hashedInput.equals(user.getPassword())) {
            
            request.setAttribute("errorMessage", "Mật khẩu không chính xác.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // Bước 5: Kiểm tra Trạng thái
        if ("INACTIVE".equals(user.getStatus())) {
            request.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ BQL.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }
        
        // Bước 6: Xử lý Đăng nhập thành công
        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);
        
        // --- Xử lý chức năng Nhớ tài khoản (Remember Me) ---
        String remember = request.getParameter("remember");
        Cookie userCookie = new Cookie("username", username);
        Cookie passCookie = new Cookie("password", password);
        
        if (remember != null) {
            // Nếu có tích chọn: Lưu cookie trong 7 ngày
            userCookie.setMaxAge(60 * 60 * 24 * 7);
            passCookie.setMaxAge(60 * 60 * 24 * 7);
        } else {
            // Nếu không tích chọn: Xóa cookie ngay lập tức
            userCookie.setMaxAge(0);
            passCookie.setMaxAge(0);
        }
        response.addCookie(userCookie);
        response.addCookie(passCookie);
        // ---------------------------------------------------
        
        if ("REQUIRE_PASSWORD_CHANGE".equals(user.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/auth/change-password");
            return;
        }
        
        if ("ACTIVE".equals(user.getStatus())) {
            String role = user.getRole();
            if (role != null) {
                switch (role.toUpperCase()) {
                    case "MANAGER":
                    case "ADMIN":
                        response.sendRedirect(request.getContextPath() + "/bql/dashboard");
                        break;
                    case "RESIDENT":
                        response.sendRedirect(request.getContextPath() + "/resident/home");
                        break;
                    case "TECHNICIAN":
                    case "RECEPTIONIST":
                    case "GUARD":
                        response.sendRedirect(request.getContextPath() + "/staff/tasks");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                        break;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
    
    // Hàm băm mật khẩu SHA-256 đồng nhất với hệ thống đăng ký
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tránh lỗi truy cập trực tiếp bằng GET
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
