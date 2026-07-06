package dao;

import dao.DBContext;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {
    
    public List<User> getStaffList() {
        List<User> list = new ArrayList<>();
        // Trong bảng users, ID là user_id và mật khẩu là password_hash
        String sql = "SELECT user_id, username, password_hash, role, status FROM users WHERE role IN ('TECHNICIAN', 'RECEPTIONIST', 'GUARD') AND status = 'ACTIVE'";
        
        try (Connection conn = this.connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
