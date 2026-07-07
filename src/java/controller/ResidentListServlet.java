package controller;

import dao.ResidentDAO;
import model.Resident;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/bql/resident/list")
public class ResidentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ResidentDAO dao = new ResidentDAO();
        List<Resident> list = dao.getAllResidents();
        
        request.setAttribute("residentList", list);
        request.getRequestDispatcher("/views/bql/resident-list.jsp").forward(request, response);
    }
}
