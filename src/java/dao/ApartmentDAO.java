package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import dao.DBContext;
import model.Apartment;
import model.Resident;
import model.User;

public class ApartmentDAO extends DBContext {

    public List<Apartment> getAllApartments() {
        List<Apartment> list = new ArrayList<>();
        String sql = "SELECT apartment_id as id, apartment_code, area, status FROM apartments ORDER BY apartment_code ASC";
        try (Connection conn = this.connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Apartment apt = new Apartment();
                apt.setId(rs.getInt("id"));
                apt.setApartmentCode(rs.getString("apartment_code"));
                apt.setArea(rs.getDouble("area"));
                apt.setStatus(rs.getString("status"));
                list.add(apt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Viết hàm createApartmentWithOwner(...) nhận vào 3 object User, Apartment, Resident.
    public boolean createApartmentWithOwner(User user, Apartment apartment, Resident resident) {
        String sqlUser = "INSERT INTO users (username, password, role, status) VALUES (?, ?, ?, ?)";
        String sqlApartment = "INSERT INTO apartments (apartment_code, area, status) VALUES (?, ?, ?)";
        String sqlResident = "INSERT INTO residents (apartment_id, user_id, full_name, phone, cccd, relationship, is_representative) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = this.connection) {
            conn.setAutoCommit(false);

            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
                    PreparedStatement psApt = conn.prepareStatement(sqlApartment, Statement.RETURN_GENERATED_KEYS);
                    PreparedStatement psRes = conn.prepareStatement(sqlResident)) {

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

                psApt.setString(1, apartment.getApartmentCode());
                psApt.setDouble(2, apartment.getArea());
                psApt.setString(3, apartment.getStatus());
                psApt.executeUpdate();

                try (ResultSet rsApt = psApt.getGeneratedKeys()) {
                    if (rsApt.next()) {
                        resident.setApartmentId(rsApt.getInt(1));
                    } else {
                        conn.rollback();
                        return false;
                    }
                }

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
