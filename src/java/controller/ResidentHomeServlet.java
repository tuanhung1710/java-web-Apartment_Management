package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/resident/home")
public class ResidentHomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Trong hệ thống thực tế, bạn sẽ lấy dữ liệu từ DAO (vd: nợ phí, thông báo)
        // Hiện tại ta chỉ chuyển hướng về trang jsp
        request.getRequestDispatcher("/views/resident/home.jsp").forward(request, response);
    }
}
