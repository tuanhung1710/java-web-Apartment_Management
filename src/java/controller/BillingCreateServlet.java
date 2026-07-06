package controller;

import dao.ApartmentDAO;
import dao.BillingDAO;
import model.Apartment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BillingCreateServlet", urlPatterns = {"/bql/billing/create"})
public class BillingCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // Bảo vệ route: Chỉ MANAGER hoặc ADMIN mới được vào
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || (!currentUser.getRole().equals("MANAGER") && !currentUser.getRole().equals("ADMIN"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Lấy danh sách toàn bộ Căn hộ đẩy vào thuộc tính aptList
        ApartmentDAO aptDAO = new ApartmentDAO();
        List<Apartment> aptList = aptDAO.getAllApartments();
        
        request.setAttribute("aptList", aptList);
        request.getRequestDispatcher("/views/bql/create-invoice.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String aptIdStr = request.getParameter("apartment_id");
        String monthStr = request.getParameter("billing_month");
        String yearStr = request.getParameter("billing_year");
        String oldWaterStr = request.getParameter("old_water_index");
        String newWaterStr = request.getParameter("new_water_index");
        
        try {
            // Ép kiểu
            int aptId = Integer.parseInt(aptIdStr);
            int month = Integer.parseInt(monthStr);
            int year = Integer.parseInt(yearStr);
            double oldWater = Double.parseDouble(oldWaterStr);
            double newWater = Double.parseDouble(newWaterStr);
            
            // Validation khắt khe: Số nước mới không được lùi
            if (newWater < oldWater) {
                request.setAttribute("errorMessage", "Chỉ số nước mới PHẢI LỚN HƠN HOẶC BẰNG chỉ số nước cũ!");
                doGet(request, response);
                return;
            }
            
            BillingDAO billingDAO = new BillingDAO();
            
            // Gọi DAO check xem Hóa đơn tháng/năm này của căn hộ đã tồn tại chưa
            if (billingDAO.checkInvoiceExists(aptId, month, year)) {
                request.setAttribute("errorMessage", "Hóa đơn tháng " + month + "/" + year + " của căn hộ này ĐÃ ĐƯỢC TẠO rồi! Không thể tạo trùng lặp.");
                doGet(request, response);
                return;
            }
            
            // Tiến hành kích hoạt nghiệp vụ tính tiền Transaction
            boolean success = billingDAO.generateMonthlyInvoice(aptId, month, year, oldWater, newWater);
            
            if (success) {
                // Giả định sẽ có trang danh sách hóa đơn /bql/billing/list
                response.sendRedirect(request.getContextPath() + "/bql/billing/list?success=true");
            } else {
                request.setAttribute("errorMessage", "Lỗi hệ thống nội bộ khi thực hiện ghi Transaction tính phí. Đã tự động Rollback, dữ liệu an toàn.");
                doGet(request, response);
            }
            
        } catch (NumberFormatException | NullPointerException e) {
            request.setAttribute("errorMessage", "Dữ liệu số (Tháng, Năm, Chỉ số nước) không hợp lệ.");
            doGet(request, response);
        }
    }
}
