package model;

import java.time.LocalDateTime;

public class Request {
    private int requestId;
    private int apartmentId;
    private int requesterId;
    private String requestType;
    private String title;
    private String description;
    private LocalDateTime scheduledTime;
    private String status;

    public Request() {
    }

    public Request(int requestId, int apartmentId, int requesterId, String requestType, String title, String description, LocalDateTime scheduledTime, String status) {
        this.requestId = requestId;
        this.apartmentId = apartmentId;
        this.requesterId = requesterId;
        this.requestType = requestType;
        this.title = title;
        this.description = description;
        this.scheduledTime = scheduledTime;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getApartmentId() {
        return apartmentId;
    }

    public void setApartmentId(int apartmentId) {
        this.apartmentId = apartmentId;
    }

    public int getRequesterId() {
        return requesterId;
    }

    public void setRequesterId(int requesterId) {
        this.requesterId = requesterId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(LocalDateTime scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
