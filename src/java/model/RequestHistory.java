package model;

public class RequestHistory {
    private int historyId;
    private int requestId;
    private int actionBy;
    private String oldStatus;
    private String newStatus;
    private String note;

    public RequestHistory() {
    }

    public RequestHistory(int historyId, int requestId, int actionBy, String oldStatus, String newStatus, String note) {
        this.historyId = historyId;
        this.requestId = requestId;
        this.actionBy = actionBy;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.note = note;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getActionBy() {
        return actionBy;
    }

    public void setActionBy(int actionBy) {
        this.actionBy = actionBy;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
