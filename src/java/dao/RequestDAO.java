package dao;

import dao.DBContext;
import model.Request;
import model.RequestDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class RequestDAO extends DBContext {

    public boolean createRequest(Request req, int userId) {
        String sqlRequest = "INSERT INTO requests (apartment_id, requester_id, request_type, title, description, scheduled_time, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlHistory = "INSERT INTO request_histories (request_id, action_by, old_status, new_status, note) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = this.connection) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement psReq = conn.prepareStatement(sqlRequest, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psHis = conn.prepareStatement(sqlHistory)) {
                 
                psReq.setInt(1, req.getApartmentId());
                psReq.setInt(2, req.getRequesterId());
                psReq.setString(3, req.getRequestType());
                psReq.setString(4, req.getTitle());
                psReq.setString(5, req.getDescription());
                
                if (req.getScheduledTime() != null) {
                    psReq.setTimestamp(6, Timestamp.valueOf(req.getScheduledTime()));
                } else {
                    psReq.setNull(6, java.sql.Types.TIMESTAMP);
                }
                
                psReq.setString(7, req.getStatus());
                psReq.executeUpdate();
                
                int generatedRequestId = -1;
                try (ResultSet rs = psReq.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedRequestId = rs.getInt(1);
                        req.setRequestId(generatedRequestId);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
                
                psHis.setInt(1, generatedRequestId);
                psHis.setInt(2, userId); 
                psHis.setString(3, null); 
                psHis.setString(4, "PENDING"); 
                psHis.setString(5, "Cư dân tạo yêu cầu mới"); 
                psHis.executeUpdate();
                
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<RequestDTO> getRequestsByStatus(String status) {
        List<RequestDTO> list = new ArrayList<>();
        // Bắt buộc dùng JOIN với bảng apartments và users. Có ORDER BY created_at DESC
        String sql = "SELECT r.request_id, a.apartment_code, u.username as requester_name, " +
                     "r.title, r.description, r.scheduled_time, r.status, r.request_type, r.created_at " +
                     "FROM requests r " +
                     "JOIN apartments a ON r.apartment_id = a.id " +
                     "JOIN users u ON r.requester_id = u.user_id " +
                     "WHERE r.status = ? " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection conn = this.connection;
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RequestDTO dto = new RequestDTO();
                    dto.setRequestId(rs.getInt("request_id"));
                    dto.setApartmentCode(rs.getString("apartment_code"));
                    dto.setRequesterName(rs.getString("requester_name"));
                    dto.setTitle(rs.getString("title"));
                    dto.setDescription(rs.getString("description"));
                    
                    Timestamp st = rs.getTimestamp("scheduled_time");
                    if (st != null) {
                        dto.setScheduledTime(st.toLocalDateTime());
                    }
                    
                    dto.setStatus(rs.getString("status"));
                    dto.setRequestType(rs.getString("request_type"));
                    
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

    public boolean assignTask(int requestId, int staffId, int managerId) {
        String sql1 = "UPDATE requests SET status = 'PROCESSING', assigned_to = ? WHERE request_id = ? AND status = 'PENDING'";
        String sql2 = "INSERT INTO request_histories (request_id, action_by, new_status, note) VALUES (?, ?, 'PROCESSING', 'BQL đã giao việc cho nhân viên')";
        
        try (Connection conn = this.connection) {
            conn.setAutoCommit(false); // Transaction
            
            try (PreparedStatement ps1 = conn.prepareStatement(sql1);
                 PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                 
                ps1.setInt(1, staffId);
                ps1.setInt(2, requestId);
                
                int rowsAffected = ps1.executeUpdate();
                // Nếu executeUpdate trả về 0 (không tồn tại hoặc không phải PENDING)
                if (rowsAffected == 0) {
                    conn.rollback();
                    return false;
                }
                
                ps2.setInt(1, requestId);
                ps2.setInt(2, managerId);
                ps2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
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
