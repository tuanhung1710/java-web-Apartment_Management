package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Resident;

public class ResidentDAO extends DBContext {

    public List<Resident> getAllResidents() {
        List<Resident> list = new ArrayList<>();
        // Lấy thông tin Cư dân, kết nối bảng apartments để lấy mã căn hộ, users để lấy username
        String sql = "SELECT r.*, a.apartment_code, u.username as email " +
                     "FROM residents r " +
                     "JOIN apartments a ON r.apartment_id = a.apartment_id " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "ORDER BY a.apartment_code ASC, r.is_representative DESC";
        
        try (Connection conn = this.connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Resident res = new Resident();
                res.setId(rs.getInt("resident_id"));
                res.setApartmentId(rs.getInt("apartment_id"));
                res.setUserId(rs.getInt("user_id"));
                res.setFullName(rs.getString("full_name"));
                res.setPhone(rs.getString("phone"));
                res.setCccd(rs.getString("cccd"));
                res.setRelationship(rs.getString("relationship"));
                res.setRepresentative(rs.getBoolean("is_representative"));
                
                // Set transient properties
                res.setApartmentCode(rs.getString("apartment_code"));
                res.setEmail(rs.getString("email"));
                
                list.add(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addResident(model.User user, Resident resident) {
        String sqlUser = "INSERT INTO users (username, password, role, status) VALUES (?, ?, ?, ?)";
        String sqlResident = "INSERT INTO residents (apartment_id, user_id, full_name, phone, cccd, relationship, is_representative) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = this.connection) {
            conn.setAutoCommit(false);

            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, java.sql.Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psRes = conn.prepareStatement(sqlResident)) {

                // 1. Insert User
                psUser.setString(1, user.getUsername());
                psUser.setString(2, user.getPassword());
                psUser.setString(3, user.getRole());
                psUser.setString(4, user.getStatus());
                psUser.executeUpdate();

                try (ResultSet rsUser = psUser.getGeneratedKeys()) {
                    if (rsUser.next()) {
                        resident.setUserId(rsUser.getInt(1));
                    } else {
                        conn.rollback();
                        return false;
                    }
                }

                // 2. Insert Resident
                psRes.setInt(1, resident.getApartmentId());
                psRes.setInt(2, resident.getUserId());
                psRes.setString(3, resident.getFullName());
                psRes.setString(4, resident.getPhone());
                psRes.setString(5, resident.getCccd());
                psRes.setString(6, resident.getRelationship());
                psRes.setBoolean(7, resident.isRepresentative());
                psRes.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
