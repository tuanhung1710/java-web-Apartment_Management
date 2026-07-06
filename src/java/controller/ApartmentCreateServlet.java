package controller;

import dao.ApartmentDAO;
import model.Apartment;
import model.Resident;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "ApartmentCreateServlet", urlPatterns = {"/bql/apartment/create"})
public class ApartmentCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Method GET: Trả về trang create-apartment.jsp.
        request.getRequestDispatcher("/create-apartment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập mã hóa UTF-8 cho request để nhận tiếng Việt
        request.setCharacterEncoding("UTF-8");

        // Nhận dữ liệu từ form request
        String apartmentCode = request.getParameter("apartment_code");
        String areaStr = request.getParameter("area");
        String cccd = request.getParameter("cccd");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String fullName = request.getParameter("full_name");

        Map<String, String> errors = new HashMap<>();

        // Thực hiện Validation Backend (Cực kỳ quan trọng)
        if (apartmentCode == null || !apartmentCode.matches("^[A-Z0-9-]+$")) {
            errors.put("apartment_code", "Lỗi: Mã căn hộ bắt buộc nhập và chỉ chứa chữ hoa, số, dấu '-' (VD: A1-1205).");
        }

        double area = 0;
        try {
            area = Double.parseDouble(areaStr);
            if (area <= 0) {
                errors.put("area", "Lỗi: Diện tích phải là số lớn hơn 0.");
            }
        } catch (NumberFormatException | NullPointerException e) {
            errors.put("area", "Lỗi: Diện tích bắt buộc phải là một số hợp lệ.");
        }

        if (cccd == null || !cccd.matches("^\\d{12}$")) {
            errors.put("cccd", "Lỗi: CCCD bắt buộc phải đúng 12 chữ số.");
        }

        if (phone == null || !phone.matches("^0\\d{9}$")) {
            errors.put("phone", "Lỗi: Số điện thoại phải chuẩn VN (10 số, bắt đầu bằng 0).");
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errors.put("email", "Lỗi: Email (Tên đăng nhập) không đúng định dạng.");
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("full_name", "Lỗi: Họ và tên không được để trống.");
        }

        // Nếu Validation thất bại: Lưu thông báo lỗi (Error Map) vào request
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            // Forward lại trang form để hiển thị lỗi, view sẽ giữ nguyên data param để user không phải nhập lại
            request.getRequestDispatcher("/create-apartment.jsp").forward(request, response);
            return;
        }

        // Nếu Validation thành công:
        // Băm mật khẩu mặc định (sinh random 8 ký tự rồi băm, ở đây dùng giả lập SHA-256 như yêu cầu)
        String rawPassword = UUID.randomUUID().toString().substring(0, 8);
        String hashedPassword = hashPassword(rawPassword);

        // Khởi tạo 3 object để truyền xuống DAO
        User user = new User();
        user.setUsername(email); // email dùng làm username
        user.setPassword(hashedPassword);
        user.setRole("RESIDENT"); // Set role là RESIDENT
        user.setStatus("ACTIVE");

        Apartment apt = new Apartment();
        apt.setApartmentCode(apartmentCode);
        apt.setArea(area);
        apt.setStatus("OCCUPIED"); // Đã có chủ thì Occupied

        Resident res = new Resident();
        res.setFullName(fullName);
        res.setPhone(phone);
        res.setCccd(cccd);
        res.setRelationship("OWNER"); // Mặc định là chủ hộ (OWNER)
        res.setRepresentative(true); // Gán là người đại diện (Chủ hộ)

        // Gọi ApartmentDAO
        ApartmentDAO dao = new ApartmentDAO();
        boolean success = dao.createApartmentWithOwner(user, apt, res);

        if (success) {
            // Nếu trả về true -> redirect sang danh sách căn hộ kèm thông báo thành công.
            // Có thể dùng session để chuyển tin nhắn mật khẩu sang trang list
            request.getSession().setAttribute("successMessage", "Khởi tạo căn hộ và gán chủ hộ thành công! Mật khẩu mặc định: " + rawPassword);
            response.sendRedirect(request.getContextPath() + "/bql/apartment/list");
        } else {
            // Nếu false -> forward lại form kèm thông báo lỗi
            request.setAttribute("globalError", "Hệ thống bận hoặc dữ liệu bị trùng lặp (CCCD, Mã căn hộ hoặc Email đã tồn tại).");
            request.getRequestDispatcher("/create-apartment.jsp").forward(request, response);
        }
    }

    // Giả lập hàm băm mật khẩu
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
