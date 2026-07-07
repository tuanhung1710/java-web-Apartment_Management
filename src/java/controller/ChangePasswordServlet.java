package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/auth/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String oldPassword = request.getParameter("old_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        
        if (newPassword == null || newPassword.length() < 8) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.equals(oldPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới không được trùng với mật khẩu cũ.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String oldHashed = hashPassword(oldPassword);
        String newHashed = hashPassword(newPassword);
        
        UserDAO dao = new UserDAO();
        // Cố gắng update với mật khẩu SHA-256
        boolean success = dao.changePassword(currentUser.getId(), oldHashed, newHashed);
        
        if (!success) {
            // Thử với mật khẩu dummy "hashed_"
            success = dao.changePassword(currentUser.getId(), "hashed_" + oldPassword, newHashed);
        }
        if (!success) {
            // Thử với mật khẩu trơn
            success = dao.changePassword(currentUser.getId(), oldPassword, newHashed);
        }
        
        if (success) {
            // Đổi mật khẩu thành công -> Set status thành ACTIVE
            currentUser.setStatus("ACTIVE");
            currentUser.setPassword(newHashed); // Cập nhật luôn password trong session (tuỳ chọn)
            
            // Redirect về đúng dashboard dựa trên Role
            String role = currentUser.getRole();
            if ("ADMIN".equals(role) || "MANAGER".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/bql/dashboard");
            } else if ("RESIDENT".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/resident/home");
            } else if ("TECHNICIAN".equals(role) || "RECEPTIONIST".equals(role) || "GUARD".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/staff/tasks");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
        }
    }
    
    // Hàm băm mật khẩu SHA-256
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
}
