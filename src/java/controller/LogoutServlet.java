package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy session hiện tại, tham số false để không tạo mới session nếu chưa tồn tại
        HttpSession session = request.getSession(false);
        
        // Nếu user đang có session (đã đăng nhập) thì tiến hành xóa
        if (session != null) {
            session.invalidate(); // Hủy toàn bộ dữ liệu lưu trong Session
        }
        
        // Chuyển hướng về trang đăng nhập (index.jsp)
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hỗ trợ cả method POST nếu form Logout dùng phương thức POST
        doGet(request, response);
    }
}
