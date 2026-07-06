package controller;

import dao.TaskDAO;
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

@WebServlet(name = "StaffTaskServlet", urlPatterns = {"/staff/tasks"})
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        int staffId = currentUser.getId();
        
        // Gọi DAO lấy danh sách công việc
        TaskDAO taskDAO = new TaskDAO();
        List<RequestDTO> assignedTasks = taskDAO.getAssignedTasks(staffId);
        
        // Đẩy xuống View
        request.setAttribute("assignedTasks", assignedTasks);
        request.getRequestDispatcher("/views/staff/task-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Hỗ trợ nhập liệu tiếng Việt
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        int staffId = currentUser.getId();
        
        // Nhận dữ liệu từ form
        String requestIdStr = request.getParameter("request_id");
        String newStatus = request.getParameter("new_status");
        String resolutionNote = request.getParameter("resolution_note");
        
        // Validation khắt khe theo đặc tả
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy mã công việc.");
            doGet(request, response);
            return;
        }
        
        if (newStatus == null || (!newStatus.equals("COMPLETED") && !newStatus.equals("WAITING_CONFIRMATION"))) {
            request.setAttribute("errorMessage", "Trạng thái cập nhật không hợp lệ! Vui lòng không sửa code F12.");
            doGet(request, response);
            return;
        }
        
        if (resolutionNote == null || resolutionNote.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bắt buộc phải nhập ghi chú xử lý để làm bằng chứng nghiệm thu.");
            doGet(request, response);
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            
            // Gọi hàm cập nhật với Transaction
            TaskDAO taskDAO = new TaskDAO();
            boolean success = taskDAO.updateTaskStatus(requestId, staffId, newStatus, resolutionNote);
            
            if (success) {
                // Chuyển hướng redirect về lại trang danh sách kèm query param báo thành công
                response.sendRedirect(request.getContextPath() + "/staff/tasks?success=true");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại. Xin lỗi, công việc này có thể không thuộc về bạn hoặc đã được xử lý trước đó.");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu ID gửi lên không hợp lệ.");
            doGet(request, response);
        }
    }
}
