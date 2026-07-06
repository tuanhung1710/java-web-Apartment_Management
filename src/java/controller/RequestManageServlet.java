package controller;

import dao.RequestDAO;
import dao.UserDAO;
import model.RequestDTO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RequestManageServlet", urlPatterns = {"/bql/request/manage"})
public class RequestManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RequestDAO requestDAO = new RequestDAO();
        UserDAO userDAO = new UserDAO();
        
        // 1. Lấy danh sách yêu cầu PENDING từ RequestDAO
        List<RequestDTO> pendingRequests = requestDAO.getRequestsByStatus("PENDING");
        
        // 2. Lấy danh sách Staff từ UserDAO
        List<User> staffList = userDAO.getStaffList();
        
        // 3. Set attributes và forward
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("staffList", staffList);
        
        request.getRequestDispatcher("/views/bql/request-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Nhận request_id và staff_id từ form
        String requestIdStr = request.getParameter("request_id");
        String staffIdStr = request.getParameter("staff_id");
        
        // Lấy manager_id từ Session currentUser
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        int managerId = currentUser.getId(); 
        
        // Validate: Đảm bảo request_id và staff_id không rỗng và là số nguyên hợp lệ
        if (requestIdStr == null || requestIdStr.trim().isEmpty() || staffIdStr == null || staffIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn nhân viên để giao việc!");
            doGet(request, response);
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            int staffId = Integer.parseInt(staffIdStr);
            
            // Gọi DAO assignTask
            RequestDAO requestDAO = new RequestDAO();
            boolean success = requestDAO.assignTask(requestId, staffId, managerId);
            
            if (success) {
                // Nếu thành công, redirect về /bql/request/manage?success=true
                response.sendRedirect(request.getContextPath() + "/bql/request/manage?success=true");
            } else {
                // Nếu thất bại
                request.setAttribute("errorMessage", "Giao việc thất bại. Yêu cầu này có thể không tồn tại hoặc đã được xử lý bởi người khác.");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu giao việc không hợp lệ (Không phải số nguyên).");
            doGet(request, response);
        }
    }
}
