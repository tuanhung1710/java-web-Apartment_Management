package controller;

import dao.ApartmentDAO;
import model.Apartment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/bql/apartment/list")
public class ApartmentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ApartmentDAO dao = new ApartmentDAO();
        List<Apartment> list = dao.getAllApartments();
        
        request.setAttribute("apartmentList", list);
        request.getRequestDispatcher("/views/bql/apartment-list.jsp").forward(request, response);
    }
}
