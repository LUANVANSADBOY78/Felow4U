# Hướng Dẫn Kiểm Tra API Bằng Postman cho Fellow4U 🚀

Tài liệu này cung cấp danh sách đầy đủ tất cả các API của hệ thống **Fellow4U** và hướng dẫn chi tiết cách sử dụng file Postman Collection được cấu hình sẵn để kiểm tra (test) các API này.

---

## 📌 Các bước chuẩn bị nhanh
1. **Khởi động Backend Server**:
   Mở terminal tại thư mục `backend` và chạy lệnh sau để khởi động server:
   ```bash
   npm run dev
   # hoặc: node server.js
   ```
   Server sẽ chạy tại địa chỉ mặc định: `http://localhost:5000`

2. **Nhập (Import) Collection vào Postman**:
   - Mở ứng dụng **Postman**.
   - Nhấp vào nút **Import** ở góc trên cùng bên trái.
   - Chọn file `Fellow4U_Postman_Collection.json` nằm trong thư mục `backend/` của dự án.
   - Postman sẽ tự động tạo một thư mục Collection tên là **"Fellow4U Mock API"** với đầy đủ các request mẫu và biến môi trường `{{base_url}}`.

---

## 🛠️ Danh Sách API Chi Tiết

### 1. Nhóm Xác Thực (Authentication)
Quản lý đăng ký, đăng nhập và thông tin người dùng.

*   **Đăng ký tài khoản (Register User)**:
    *   **Method**: `POST`
    *   **URL**: `http://localhost:5000/api/auth/register`
    *   **Headers**: `Content-Type: application/json`
    *   **Body (JSON)**:
        ```json
        {
          "firstName": "Luan",
          "lastName": "Van",
          "email": "vanluan78@gmail.com",
          "password": "12345678",
          "country": "Vietnam",
          "avatar": "https://i.pravatar.cc/150?u=vanluan"
        }
        ```
    *   **Phản hồi (Response)**: Mã `201 Created` kèm thông tin tài khoản vừa tạo (bao gồm `id`).

*   **Đăng nhập (Login User)**:
    *   **Method**: `POST`
    *   **URL**: `http://localhost:5000/api/auth/login`
    *   **Headers**: `Content-Type: application/json`
    *   **Body (JSON)**:
        ```json
        {
          "email": "vanluan78@gmail.com",
          "password": "12345678"
        }
        ```
    *   **Phản hồi (Response)**: Mã `200 OK` kèm thông tin của người dùng nếu thông tin chính xác.

*   **Danh sách tất cả người dùng (Get All Users)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/users`

---

### 2. Khám Phá & Hướng Dẫn Viên (Explore & Guides)
Lấy dữ liệu trang chủ, các chuyến đi nổi bật, hướng dẫn viên, tin tức du lịch.

*   **Lấy dữ liệu trang chủ Explore (Get Explore Data)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/explore`
    *   *Trả về danh mục (categories), hành trình nổi bật (topJourneys), hướng dẫn viên hàng đầu (topGuides), trải nghiệm gần đây (recentExperiences), và tin tức du lịch (travelNews).*

*   **Danh sách Hướng dẫn viên (Get All Guides)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/guides`

---

### 3. Quản Lý Chuyến Đi (Trips)
Xem danh sách tour du lịch và thông tin chi tiết từng chuyến đi.

*   **Danh sách tất cả chuyến đi (Get All Trips)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/trips`

*   **Chi tiết một chuyến đi (Get Single Trip Details)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/trips/:id` *(Ví dụ: `http://localhost:5000/api/trips/1`)*

---

### 4. Đặt Tour (Bookings)
Quản lý các lượt đặt tour/chuyến đi từ người dùng.

*   **Danh sách tất cả lượt đặt (Get All Bookings)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/bookings`

*   **Tạo mới một lượt đặt tour (Create Booking)**:
    *   **Method**: `POST`
    *   **URL**: `http://localhost:5000/api/bookings`
    *   **Headers**: `Content-Type: application/json`
    *   **Body (JSON)**:
        ```json
        {
          "userId": "1",
          "tripId": "1",
          "status": "pending"
        }
        ```

---

### 5. Thông Báo (Notifications)
Xem và cập nhật thông báo của người dùng.

*   **Lấy danh sách thông báo (Get All Notifications)**:
    *   **Method**: `GET`
    *   **URL**: `http://localhost:5000/api/notifications`

*   **Tạo thông báo mới (Create Notification)**:
    *   **Method**: `POST`
    *   **URL**: `http://localhost:5000/api/notifications`
    *   **Headers**: `Content-Type: application/json`
    *   **Body (JSON)**:
        ```json
        {
          "type": "booking_success",
          "title": "Booking Successful",
          "content": "Your booking has been confirmed.",
          "tripId": "1",
          "guideId": "g1"
        }
        ```

*   **Cập nhật trạng thái thông báo (Đã đọc/Đọc lại) (Update Notification Read Status)**:
    *   **Method**: `PATCH`
    *   **URL**: `http://localhost:5000/api/notifications/:id` *(Ví dụ: `http://localhost:5000/api/notifications/1`)*
    *   **Headers**: `Content-Type: application/json`
    *   **Body (JSON)**:
        ```json
        {
          "read": true
        }
        ```

---

## 💡 Lưu ý về Biến (Variable) trong Postman
Trong file Collection đã khai báo sẵn một biến toàn cục tên là `base_url` với giá trị mặc định là `http://localhost:5000`. 
Nếu bạn chạy backend ở cổng khác (ví dụ `3000`), bạn chỉ cần:
1. Nhấp vào tên Collection **"Fellow4U Mock API"** trong Postman.
2. Chọn tab **Variables**.
3. Sửa giá trị của `base_url` thành `http://localhost:3000` (hoặc domain Render/Heroku của bạn nếu đã deploy).
4. Nhấn **Save**.

Chúc bạn kiểm thử thành công! Nếu có câu hỏi hoặc gặp lỗi nào, hãy nói cho tôi biết nhé! ☀️
