package controller;

import dao.ApartmentDAO;
import dao.ResidentDAO;
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
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/bql/resident/add")
public class ResidentAddServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy danh sách căn hộ để cho vào dropdown chọn
        ApartmentDAO aptDao = new ApartmentDAO();
        List<Apartment> aptList = aptDao.getAllApartments();
        request.setAttribute("aptList", aptList);
        
        request.getRequestDispatcher("/views/bql/add-resident.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String apartmentIdStr = request.getParameter("apartment_id");
        String relationship = request.getParameter("relationship");
        String cccd = request.getParameter("cccd");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String fullName = request.getParameter("full_name");

        Map<String, String> errors = new HashMap<>();

        int apartmentId = 0;
        try {
            apartmentId = Integer.parseInt(apartmentIdStr);
        } catch (NumberFormatException e) {
            errors.put("apartment_id", "Vui lòng chọn căn hộ.");
        }

        if (relationship == null || relationship.isEmpty()) {
            errors.put("relationship", "Vui lòng chọn vai trò.");
        }

        if (cccd == null || !cccd.matches("^\\d{12}$")) {
            errors.put("cccd", "CCCD bắt buộc phải đúng 12 chữ số.");
        }

        if (phone == null || !phone.matches("^0\\d{9}$")) {
            errors.put("phone", "Số điện thoại phải chuẩn VN (10 số).");
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errors.put("email", "Email (Tên đăng nhập) không hợp lệ.");
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("full_name", "Họ và tên không được để trống.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            doGet(request, response); // Forward back to form with apartment list
            return;
        }

        String rawPassword = UUID.randomUUID().toString().substring(0, 8);
        String hashedPassword = hashPassword(rawPassword);

        User user = new User();
        user.setUsername(email);
        user.setPassword(hashedPassword);
        user.setRole("RESIDENT");
        user.setStatus("REQUIRE_PASSWORD_CHANGE");

        Resident res = new Resident();
        res.setApartmentId(apartmentId);
        res.setFullName(fullName);
        res.setPhone(phone);
        res.setCccd(cccd);
        res.setRelationship(relationship); // OWNER or TENANT or FAMILY_MEMBER
        // Nếu là TENANT và là đại diện thuê thì true, tạm mặc định false nếu là người nhà
        res.setRepresentative("TENANT".equals(relationship)); 

        ResidentDAO dao = new ResidentDAO();
        boolean success = dao.addResident(user, res);

        if (success) {
            request.getSession().setAttribute("successMessage", "Thêm cư dân thành công! Mật khẩu: " + rawPassword);
            response.sendRedirect(request.getContextPath() + "/bql/resident/list");
        } else {
            request.setAttribute("globalError", "Lỗi: Email hoặc CCCD có thể đã tồn tại.");
            doGet(request, response);
        }
    }

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
