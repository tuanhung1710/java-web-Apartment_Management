package model;

public class Apartment {
    private int id;
    private String apartmentCode;
    private double area;
    private String status;

    public Apartment() {
    }

    public Apartment(int id, String apartmentCode, double area, String status) {
        this.id = id;
        this.apartmentCode = apartmentCode;
        this.area = area;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getApartmentCode() {
        return apartmentCode;
    }

    public void setApartmentCode(String apartmentCode) {
        this.apartmentCode = apartmentCode;
    }

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
