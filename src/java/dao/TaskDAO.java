package dao;

import dao.DBContext;
import model.RequestDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO extends DBContext {

    /**
     * Lấy danh sách yêu cầu đang được giao cho nhân viên (staff)
     * Ưu tiên việc tạo trước lên đầu (ORDER BY created_at ASC)
     */
    public List<RequestDTO> getAssignedTasks(int staffId) {
        List<RequestDTO> list = new ArrayList<>();
        // Bắt buộc dùng JOIN với bảng apartments để lấy apartment_code
        String sql = "SELECT r.request_id, a.apartment_code, r.title, r.description, r.created_at " +
                     "FROM requests r " +
                     "JOIN apartments a ON r.apartment_id = a.id " +
                     "WHERE r.assigned_to = ? AND r.status = 'PROCESSING' " +
                     "ORDER BY r.created_at ASC";
                     
        // Dùng try-with-resources để tự động đóng Connection, Statement, ResultSet
        try (Connection conn = this.connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RequestDTO dto = new RequestDTO();
                    dto.setRequestId(rs.getInt("request_id"));
                    dto.setApartmentCode(rs.getString("apartment_code"));
                    dto.setTitle(rs.getString("title"));
                    dto.setDescription(rs.getString("description"));
                    
                    Timestamp ca = rs.getTimestamp("created_at");
                    if (ca != null) {
                        dto.setCreatedAt(ca.toLocalDateTime());
                    }
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cập nhật tiến độ xử lý Yêu cầu (Ghi nhận Database Transaction)
     */
    public boolean updateTaskStatus(int requestId, int staffId, String newStatus, String resolutionNote) {
        String sqlUpdate = "UPDATE requests SET status = ?, resolution_note = ? WHERE request_id = ? AND assigned_to = ?";
        String sqlHistory = "INSERT INTO request_histories (request_id, action_by, new_status, note) VALUES (?, ?, ?, ?)";

        try (Connection conn = this.connection) {
            // Yêu cầu xử lý Database Transaction: Tắt auto-commit
            conn.setAutoCommit(false);
            
            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                 PreparedStatement psHistory = conn.prepareStatement(sqlHistory)) {
                 
                // Lệnh 1: Cập nhật status và resolution_note vào bảng requests
                psUpdate.setString(1, newStatus);
                psUpdate.setString(2, resolutionNote);
                psUpdate.setInt(3, requestId);
                psUpdate.setInt(4, staffId); // Xác nhận đúng staff_id đang được giao việc mới cho phép update
                
                int rowsAffected = psUpdate.executeUpdate();
                if (rowsAffected == 0) {
                    // Nếu số dòng update = 0 nghĩa là không tồn tại hoặc đã bị đổi assigned_to -> Rollback
                    conn.rollback();
                    return false;
                }
                
                // Lệnh 2: Lưu lịch sử thao tác vào request_histories
                psHistory.setInt(1, requestId);
                psHistory.setInt(2, staffId);
                psHistory.setString(3, newStatus);
                psHistory.setString(4, "Cập nhật tiến độ: " + resolutionNote);
                psHistory.executeUpdate();
                
                // Cả 2 lệnh đều OK -> Xác nhận Transaction
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                // Bắt Exception và conn.rollback() nếu có bất kỳ lỗi nào trong quá trình thực thi
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
