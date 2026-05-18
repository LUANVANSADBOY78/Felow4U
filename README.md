# ✈️ Fellow4U - Ứng Dụng Hướng Dẫn & Đặt Tour Du Lịch

Ứng dụng kết nối du khách và hướng dẫn viên du lịch (Guides) thời gian thực, đem lại những trải nghiệm du lịch bản địa tuyệt vời nhất. 

👉 **TRẢI NGHIỆM BẢN DEMO WEB TRỰC TIẾP TẠI ĐÂY:** **[https://luanvansadboy78.github.io/Felow4U/](https://luanvansadboy78.github.io/Felow4U/)** 🚀

---

## 🛠️ Công Nghệ Sử Dụng

### 1. Frontend (Flutter Mobile & Web)
* **Framework**: Flutter (Dart)
* **State Management**: Provider / Local States
* **UI/UX**: Thiết kế hiện đại lấy cảm hứng từ Figma, sử dụng Google Fonts (Inter, Outfit), bo góc mềm mại, đổ bóng cao cấp và các hiệu ứng chuyển động mượt mà.
* **Hỗ trợ chạy Offline/Static**: Tích hợp cơ chế tự động chuyển sang local Mock Data khi không kết nối được server, giúp ứng dụng chạy mượt mà ngay trên GitHub Pages mà không cần server thật.

### 2. Backend (Node.js & Express)
* **Runtime**: Node.js
* **Framework**: Express.js
* **Database**: MongoDB (Mongoose ORM)
* **Auth**: JWT (JSON Web Tokens) & Bcrypt mật mã hóa.
* **APIs**: Đầy đủ các đầu API phục vụ Đăng ký, Đăng nhập, Explore tours, Quản lý đặt chuyến đi, Tin nhắn và Thông báo.

---

## 📂 Cấu Trúc Thư Mục Dự Án

```text
Fellow-4U/
├── Fellow-4U-main/       # Mã nguồn Frontend (Flutter App)
│   ├── lib/              # Logic chính (Screens, Services, Models)
│   └── web/              # Cấu hình build Web-app
├── backend/              # Mã nguồn Backend (Node.js REST API)
│   ├── config/           # Cấu hình cơ sở dữ liệu MongoDB
│   ├── controllers/      # Bộ điều khiển xử lý logic nghiệp vụ
│   ├── models/           # Định nghĩa schemas dữ liệu
│   ├── routes/           # Định nghĩa các endpoints API
│   └── server.js         # Khởi chạy server Express
└── mockapi_data.json     # Dữ liệu Mock API mẫu
```

---

## 🚀 Hướng Dẫn Chạy Dự Án Dưới Local

### 1. Khởi Chạy Backend (Node.js)
1. Di chuyển vào thư mục backend:
   ```bash
   cd backend
   ```
2. Cài đặt các thư viện dependencies:
   ```bash
   npm install
   ```
3. Tạo file cấu hình môi trường `.env` ở thư mục `backend/` với nội dung:
   ```env
   PORT=5000
   MONGO_URI=mongodb://localhost:27017/fellow4u
   JWT_SECRET=your_jwt_secret_key
   ```
4. Khởi chạy server:
   ```bash
   npm start
   ```
   *(Server sẽ chạy tại `http://localhost:5000`)*

### 2. Khởi Chạy Frontend (Flutter)
1. Di chuyển vào thư mục frontend:
   ```bash
   cd Fellow-4U-main
   ```
2. Tải các package cần thiết:
   ```bash
   flutter pub get
   ```
3. Khởi chạy ứng dụng:
   * **Chạy trên Web**:
     ```bash
     flutter run -d chrome
     ```
   * **Chạy trên Android/iOS**: Mở trình giả lập và chạy:
     ```bash
     flutter run
     ```

---

## 🔒 Bản Quyền & Phát Triển
Được thực hiện và phát triển bởi **LUANVANSADBOY78**. Mọi quyền được bảo lưu. 

*Hy vọng ứng dụng mang lại trải nghiệm tuyệt vời cho chuyến đi của bạn!*
