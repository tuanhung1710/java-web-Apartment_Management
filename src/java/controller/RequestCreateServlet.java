package controller;

import dao.RequestDAO;
import model.Request;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "RequestCreateServlet", urlPatterns = {"/resident/request/create"})
public class RequestCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/create-request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Giả định đã có user_id và apartment_id trên Session
        HttpSession session = request.getSession();
        Integer sessionUserId = (Integer) session.getAttribute("userId");
        Integer sessionApartmentId = (Integer) session.getAttribute("apartmentId");
        
        // Để thuận tiện test nếu chưa cấu hình login, ta dùng giá trị giả lập
        int userId = sessionUserId != null ? sessionUserId : 1; 
        int apartmentId = sessionApartmentId != null ? sessionApartmentId : 101;

        // Lấy dữ liệu từ form
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String requestType = request.getParameter("request_type");
        String scheduledTimeStr = request.getParameter("scheduled_time");
        
        Map<String, String> errors = new HashMap<>();

        // Validation: title, description không được rỗng
        if (title == null || title.trim().isEmpty()) {
            errors.put("title", "Lỗi: Tiêu đề không được để trống.");
        }
        
        if (description == null || description.trim().isEmpty()) {
            errors.put("description", "Lỗi: Nội dung yêu cầu không được để trống.");
        }
        
        // Validation request_type
        if (requestType == null || !requestType.matches("^(REPAIR|MOVE_IN_OUT|PARKING_REGISTRATION|COMPLAINT|OTHER)$")) {
            errors.put("request_type", "Lỗi: Loại yêu cầu không hợp lệ. Vui lòng chọn từ danh sách.");
        }

        LocalDateTime scheduledTime = null;
        
        // Logic Thời Gian (Quan trọng)
        if ("MOVE_IN_OUT".equals(requestType)) {
            if (scheduledTimeStr == null || scheduledTimeStr.trim().isEmpty()) {
                errors.put("scheduled_time", "Lỗi: Bắt buộc phải chọn ngày giờ chuyển đồ.");
            } else {
                try {
                    // Dữ liệu từ thẻ <input type="datetime-local"> sẽ có format yyyy-MM-ddTHH:mm
                    scheduledTime = LocalDateTime.parse(scheduledTimeStr);
                    
                    // Phải là thời gian trong tương lai
                    if (scheduledTime.isBefore(LocalDateTime.now())) {
                        errors.put("scheduled_time", "Lỗi: Thời gian chuyển đồ phải nằm trong tương lai.");
                    } else {
                        // Chỉ cho phép khung giờ: 08:00 - 11:30 VÀ 14:00 - 17:00
                        LocalTime time = scheduledTime.toLocalTime();
                        
                        LocalTime morningStart = LocalTime.of(8, 0);
                        LocalTime morningEnd = LocalTime.of(11, 30);
                        LocalTime afternoonStart = LocalTime.of(14, 0);
                        LocalTime afternoonEnd = LocalTime.of(17, 0);
                        
                        boolean isMorning = (!time.isBefore(morningStart)) && (!time.isAfter(morningEnd));
                        boolean isAfternoon = (!time.isBefore(afternoonStart)) && (!time.isAfter(afternoonEnd));
                        
                        if (!isMorning && !isAfternoon) {
                            errors.put("scheduled_time", "Lỗi: BQL chỉ hỗ trợ chuyển đồ trong giờ hành chính (08:00 - 11:30 hoặc 14:00 - 17:00).");
                        }
                    }
                } catch (DateTimeParseException e) {
                    errors.put("scheduled_time", "Lỗi: Định dạng ngày giờ không hợp lệ.");
                }
            }
        }

        // Xử lý trả về lỗi
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            // Forward lại trang JSP giữ nguyên dữ liệu user đã nhập
            request.getRequestDispatcher("/create-request.jsp").forward(request, response);
            return;
        }

        // Tạo object Request
        Request req = new Request();
        req.setApartmentId(apartmentId);
        req.setRequesterId(userId);
        req.setRequestType(requestType);
        req.setTitle(title.trim());
        req.setDescription(description.trim());
        req.setScheduledTime(scheduledTime);
        req.setStatus("PENDING");

        // Gọi DAO
        RequestDAO dao = new RequestDAO();
        boolean success = dao.createRequest(req, userId);

        if (success) {
            // Chuyển hướng sang danh sách yêu cầu
            session.setAttribute("successMessage", "Đã gửi yêu cầu hỗ trợ thành công!");
            response.sendRedirect(request.getContextPath() + "/resident/request/list");
        } else {
            request.setAttribute("globalError", "Đã xảy ra lỗi kết nối Database. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/create-request.jsp").forward(request, response);
        }
    }
}
