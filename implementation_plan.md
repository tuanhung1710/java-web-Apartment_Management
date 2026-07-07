# Xây dựng Bộ lọc Bảo mật (Authentication Filter) & Change Password Flow

Tính năng này sẽ thiết lập một lớp khiên bảo vệ toàn bộ ứng dụng, đảm bảo không có bất kỳ endpoint nào bị lộ mà không có quyền truy cập, đồng thời ép người dùng mới đổi mật khẩu.

## User Review Required

> [!WARNING]
> Việc áp dụng Security Filter `/*` sẽ ảnh hưởng đến toàn bộ ứng dụng. Tôi đã đưa vào danh sách trắng (whitelist) các đường dẫn tĩnh (`/css`, `/js`, `/images`) và public (`/login`, `/logout`, `/index.jsp`, `/test-users.jsp`). Vui lòng xác nhận xem ứng dụng của bạn còn thư mục public nào khác (như `/assets`, `/vendors`) cần được loại trừ không?

## Proposed Changes

### Tầng Security & Controller

#### [NEW] [SecurityFilter.java](file:///d:/S4/PRJ301/Assigment/Apartment_Management/src/java/filter/SecurityFilter.java)
- Tạo mới class implement `jakarta.servlet.Filter`.
- Áp dụng annotation `@WebFilter("/*")`.
- Logic kiểm tra Session và Điều hướng dựa trên Role (ADMIN/MANAGER -> `/bql/`, RESIDENT -> `/resident/`, STAFF -> `/staff/`).
- Bắt buộc tài khoản có status `REQUIRE_PASSWORD_CHANGE` chuyển hướng về `/auth/change-password`.

#### [NEW] [ChangePasswordServlet.java](file:///d:/S4/PRJ301/Assigment/Apartment_Management/src/java/controller/ChangePasswordServlet.java)
- URL Mapping: `/auth/change-password`
- **GET**: Forward về trang `change-password.jsp`.
- **POST**: Validate dữ liệu (độ dài mật khẩu, xác nhận mật khẩu), hash SHA-256 cho mật khẩu mới, gọi DAO để update DB. Cập nhật lại session.

### Tầng DAO

#### [MODIFY] [UserDAO.java](file:///d:/S4/PRJ301/Assigment/Apartment_Management/src/java/dao/UserDAO.java)
- Thêm phương thức `boolean changePassword(int userId, String oldPass, String newPass)` (Có sử dụng cơ chế hash SHA-256 cho cả oldPass và newPass để tương thích với cơ sở dữ liệu).

### Tầng View (Frontend)

#### [NEW] [change-password.jsp](file:///d:/S4/PRJ301/Assigment/Apartment_Management/web/views/auth/change-password.jsp)
- Tạo giao diện Bootstrap 5 chuyên nghiệp với cảnh báo màu vàng yêu cầu đổi mật khẩu.
- Chức năng ẩn/hiện mật khẩu bằng JavaScript.
- Hiển thị JSTL alert cho các thông báo lỗi.

## Verification Plan
- Chạy thử web app.
- Truy cập thẳng vào `/bql/dashboard` khi chưa login -> Kỳ vọng: Bị đá về `/login`.
- Đăng nhập bằng một tài khoản có status `REQUIRE_PASSWORD_CHANGE` -> Kỳ vọng: Bị ép sang `/auth/change-password`.
- Cố tình truy cập `/resident/home` bằng tài khoản `MANAGER` -> Kỳ vọng: Nhận trang lỗi 403.
- Thực hiện đổi mật khẩu: Nhập sai mật khẩu cũ, nhập mật khẩu mới quá ngắn -> Báo lỗi.
- Đổi mật khẩu thành công -> status thành `ACTIVE` và tự chuyển về dashboard tương ứng.
