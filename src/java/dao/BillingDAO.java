package dao;

import dao.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class BillingDAO extends DBContext {

    /**
     * Hàm kiểm tra căn hộ đã được tạo hóa đơn trong tháng/năm đó chưa.
     */
    public boolean checkInvoiceExists(int aptId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE apartment_id = ? AND billing_month = ? AND billing_year = ?";
        try (Connection conn = this.connection; 
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, aptId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Hàm xử lý nghiệp vụ khổng lồ: Tính tiền và tạo hóa đơn tự động
     */
    public boolean generateMonthlyInvoice(int aptId, int month, int year, double oldWater, double newWater) {
        try (Connection conn = this.connection) {
            // Transaction Ghi: conn.setAutoCommit(false)
            conn.setAutoCommit(false);
            
            try {
                // ==========================================
                // BƯỚC 1: LẤY DỮ LIỆU TỪ DB
                // ==========================================
                
                // 1.1 Lấy area (diện tích) của apartment
                double area = 0;
                String sqlArea = "SELECT area FROM apartments WHERE apartment_id = ?";
                try (PreparedStatement psArea = conn.prepareStatement(sqlArea)) {
                    psArea.setInt(1, aptId);
                    try (ResultSet rs = psArea.executeQuery()) {
                        if (rs.next()) area = rs.getDouble("area");
                    }
                }
                
                // 1.2 Đếm số xe máy
                int motorbikeCount = 0;
                String sqlMoto = "SELECT COUNT(*) FROM vehicles WHERE apartment_id = ? AND vehicle_type = 'MOTORBIKE' AND status = 'ACTIVE'";
                try (PreparedStatement psMoto = conn.prepareStatement(sqlMoto)) {
                    psMoto.setInt(1, aptId);
                    try (ResultSet rs = psMoto.executeQuery()) {
                        if (rs.next()) motorbikeCount = rs.getInt(1);
                    }
                }
                
                // 1.3 Đếm ô tô
                int carCount = 0;
                String sqlCar = "SELECT COUNT(*) FROM vehicles WHERE apartment_id = ? AND vehicle_type = 'CAR' AND status = 'ACTIVE'";
                try (PreparedStatement psCar = conn.prepareStatement(sqlCar)) {
                    psCar.setInt(1, aptId);
                    try (ResultSet rs = psCar.executeQuery()) {
                        if (rs.next()) carCount = rs.getInt(1);
                    }
                }
                
                // 1.4 Lấy đơn giá dịch vụ
                double priceManage = 0, priceWater = 0, priceMoto = 0, priceCar = 0;
                String sqlService = "SELECT service_id, unit_price FROM services WHERE service_id IN (1, 2, 3, 4)";
                try (PreparedStatement psService = conn.prepareStatement(sqlService);
                     ResultSet rs = psService.executeQuery()) {
                    while (rs.next()) {
                        int id = rs.getInt("service_id");
                        double price = rs.getDouble("unit_price");
                        if (id == 1) priceManage = price;
                        else if (id == 2) priceWater = price;
                        else if (id == 3) priceMoto = price;
                        else if (id == 4) priceCar = price;
                    }
                }
                
                // ==========================================
                // BƯỚC 2: TÍNH TOÁN (Java Math)
                // ==========================================
                double waterUsed = newWater - oldWater;
                double waterFee = waterUsed * priceWater;
                double manageFee = area * priceManage;
                double parkingFee = (motorbikeCount * priceMoto) + (carCount * priceCar);
                
                double totalAmount = waterFee + manageFee + parkingFee;
                
                // ==========================================
                // BƯỚC 3: LƯU DB THEO TRANSACTION
                // ==========================================
                
                // 3.1 Ghi log chỉ số nước
                String sqlWaterUsage = "INSERT INTO water_usages (apartment_id, billing_month, billing_year, old_index, new_index) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement psWater = conn.prepareStatement(sqlWaterUsage)) {
                    psWater.setInt(1, aptId);
                    psWater.setInt(2, month);
                    psWater.setInt(3, year);
                    psWater.setDouble(4, oldWater);
                    psWater.setDouble(5, newWater);
                    psWater.executeUpdate();
                }
                
                // 3.2 Khởi tạo Hóa Đơn (invoices)
                String sqlInvoice = "INSERT INTO invoices (apartment_id, title, billing_month, billing_year, total_amount, status) VALUES (?, ?, ?, ?, ?, 'UNPAID')";
                int invoiceId = -1;
                try (PreparedStatement psInv = conn.prepareStatement(sqlInvoice, Statement.RETURN_GENERATED_KEYS)) {
                    psInv.setInt(1, aptId);
                    psInv.setString(2, "Hóa đơn tháng " + month + "/" + year);
                    psInv.setInt(3, month);
                    psInv.setInt(4, year);
                    psInv.setDouble(5, totalAmount);
                    psInv.executeUpdate();
                    
                    try (ResultSet rs = psInv.getGeneratedKeys()) {
                        if (rs.next()) {
                            invoiceId = rs.getInt(1);
                        } else {
                            conn.rollback();
                            return false;
                        }
                    }
                }
                
                if (invoiceId == -1) {
                    conn.rollback();
                    return false;
                }
                
                // 3.3 Đưa các dòng dịch vụ chi tiết vào bảng invoice_details dùng addBatch()
                String sqlDetail = "INSERT INTO invoice_details (invoice_id, service_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    // Dòng 1: Phí quản lý
                    psDetail.setInt(1, invoiceId);
                    psDetail.setInt(2, 1); // ID 1
                    psDetail.setDouble(3, area);
                    psDetail.setDouble(4, priceManage);
                    psDetail.addBatch();
                    
                    // Dòng 2: Phí Nước
                    psDetail.setInt(1, invoiceId);
                    psDetail.setInt(2, 2); // ID 2
                    psDetail.setDouble(3, waterUsed);
                    psDetail.setDouble(4, priceWater);
                    psDetail.addBatch();
                    
                    // Dòng 3: Gửi xe máy (Nếu có)
                    if (motorbikeCount > 0) {
                        psDetail.setInt(1, invoiceId);
                        psDetail.setInt(2, 3); // ID 3
                        psDetail.setDouble(3, motorbikeCount);
                        psDetail.setDouble(4, priceMoto);
                        psDetail.addBatch();
                    }
                    
                    // Dòng 4: Gửi ô tô (Nếu có)
                    if (carCount > 0) {
                        psDetail.setInt(1, invoiceId);
                        psDetail.setInt(2, 4); // ID 4
                        psDetail.setDouble(3, carCount);
                        psDetail.setDouble(4, priceCar);
                        psDetail.addBatch();
                    }
                    
                    psDetail.executeBatch();
                }
                
                // TẤT CẢ THÀNH CÔNG -> Commit xuống CSDL
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                // Bắt Exception: Nếu có bất kỳ lỗi nào, rollback() ngăn dữ liệu bị mất toàn vẹn
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
