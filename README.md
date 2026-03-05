# 🌳 NỀN TẢNG GIA PHẢ ONLINE ĐA NGƯỜI DÙNG
## Tích hợp Ảnh, Video và Livestream thời gian thực

![Java](https://img.shields.io/badge/Java-8-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.0.9-brightgreen)
![MySQL](https://img.shields.io/badge/Database-MySQL-blue)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED)
![AWS EC2](https://img.shields.io/badge/Deploy-AWS%20EC2-232F3E)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF)

> Một hệ thống gia phả online được xây dựng để vận hành thực tế: quản lý cây gia đình nhiều thế hệ, cộng tác nhiều người dùng, lưu trữ tư liệu số và tổ chức livestream cho dòng họ.

---

## 🔗 Demo

- **Trang chủ:** http://18.143.147.205:8080/trang-chu

---

## 👋 Dành cho mọi người (không cần biết kỹ thuật)

### Dự án này dùng để làm gì?

Hệ thống giúp dòng họ lưu trữ và quản lý thông tin gia phả trên nền tảng online, thay cho cách ghi chép rời rạc bằng giấy hoặc file cá nhân.

### Người dùng có thể làm gì?

- Xem cây gia phả theo nhiều đời, nhiều chi nhánh.
- Cập nhật thông tin thành viên theo quyền được cấp.
- Lưu và xem ảnh/video tư liệu gia đình.
- Tham gia livestream các sự kiện (họp họ, lễ giỗ, gặp mặt).

### Lợi ích thực tế

- Dễ chia sẻ cho nhiều thế hệ trong gia đình.
- Dữ liệu tập trung, có tổ chức, dễ tra cứu.
- Có phân quyền rõ ràng để hạn chế chỉnh sửa sai.
- Phù hợp cho cả người ở xa nhờ tính năng livestream.

---

## 🎯 Mục tiêu dự án

- Xây dựng sản phẩm chạy thật trên Internet.
- Đáp ứng các nhóm chức năng chính: gia phả, người dùng/phân quyền, media, livestream.
- Hướng tới khả năng phục vụ nhiều người truy cập đồng thời.
- Đảm bảo yếu tố quản lý an toàn thông tin trong vận hành.

---

## ⚙️ Chức năng chính

### 1) Quản lý cây gia phả

- Mô hình gia phả nhiều đời: cha/mẹ/con, vợ/chồng.
- Quản lý theo chi nhánh dòng họ.
- Tạo, cập nhật, xóa thành viên theo quy tắc nghiệp vụ.
- Hiển thị cây gia phả trực quan, có lọc theo đời/chi.

### 2) Người dùng và phân quyền

- Vai trò hệ thống:
  - `MANAGER` (quản trị)
  - `EDITOR` (biên tập)
  - `USER` (thành viên)
  - Guest (khách chưa đăng nhập)
- Kiểm soát quyền truy cập theo vai trò cho từng trang và API.

### 3) Quản lý Ảnh, Video, Audio

- Upload nhiều tệp cùng lúc.
- Gắn media với thành viên, chi nhánh, người tải lên.
- Hỗ trợ preview, tải xuống và xóa theo quyền.
- Phân mức xem:
  - `PUBLIC`: thành viên thông thường có thể xem
  - `PRIVATE`: chỉ `MANAGER/EDITOR` xem được

### 4) Livestream thời gian thực

- Tạo phòng livestream theo chi nhánh.
- Tham gia phòng qua link có `livestreamId`.
- Chia sẻ màn hình, bật/tắt camera, microphone.
- Chat realtime và hiển thị người tham gia realtime.
- Kết thúc livestream theo quyền host/quản trị.

---

## 🏗️ Kiến trúc hệ thống (tóm tắt)

```text
Client Browser
   -> Nginx (HTTPS, reverse proxy, websocket upgrade)
      -> Spring Boot App (Tomcat 9, Docker, AWS EC2)
         -> Aiven MySQL (database production)

Livestream:
Host Browser <-> Viewer Browser (WebRTC media)
Signaling qua WebSocket: /ws/live
```

---

## 🧱 Công nghệ sử dụng

### Backend

- Java 8
- Spring Boot 2.0.9
- Spring Data JPA + Hibernate
- Spring Security
- Spring WebSocket
- JSP + JSTL + SiteMesh
- Maven

### Hạ tầng & DevOps

- Docker hóa ứng dụng (WAR chạy trên Tomcat 9)
- GitHub Actions CI/CD:
  - Build Docker image
  - Push Docker Hub
  - SSH deploy lên AWS EC2
- Database production tách rời trên Aiven MySQL

---

## 🔌 API tiêu biểu

### Gia phả

- `GET /api/person/root`
- `POST /api/person`
- `POST /api/person/{id}/spouse`
- `POST /api/person/{id}/child`
- `PUT /api/person/{id}`
- `DELETE /api/person/{id}`

### Media

- `POST /api/media/upload`
- `GET /api/media/{id}/download`
- `GET /api/media/file/{fileName}`
- `DELETE /api/media/{id}`

### Livestream

- `POST /api/livestream/start`
- `GET /api/livestream/watch`
- `GET /api/livestream/live`
- `PUT /api/livestream/{id}/end`

---

## 🔒 An toàn thông tin (QLATTT)

### Đã triển khai

- Xác thực đăng nhập + phân quyền theo vai trò.
- Mật khẩu lưu dưới dạng mã hóa BCrypt.
- Ghi nhật ký các hành vi quan trọng:
  - đăng nhập thành công/thất bại
  - đăng xuất
  - truy cập bị từ chối
  - thay đổi dữ liệu qua API
- Dashboard Security Audit cho quản trị viên theo dõi rủi ro.

### Hướng cải tiến thực tế

- Bổ sung rate-limit/CAPTCHA chống brute-force.
- Chuẩn hóa backup/restore định kỳ.
- Tăng cường quản lý secrets và xoay vòng thông tin nhạy cảm.

---

## 🚀 Triển khai production

### Pipeline CI/CD

Khi push lên `main`, hệ thống tự động:

1. Build Docker image
2. Push image lên Docker Hub
3. SSH vào EC2, pull image mới và chạy container

### Livestream Internet

- Dùng Nginx để reverse proxy + websocket upgrade.
- Khuyến nghị triển khai TURN server (coturn) để đảm bảo kết nối WebRTC ổn định trên mạng thực.
- Cấu hình tham khảo trong thư mục `deploy/`.

---

## 🧪 Chạy local nhanh

### Yêu cầu

- JDK 8
- Maven 3.x
- MySQL 8

### Các bước

1. Import database:

```bash
mysql -u root -p < database/family_tree_db.sql
```

2. Cấu hình datasource ở profile local (`application-dev.properties` hoặc `application-uat.properties`).

3. Khởi chạy ứng dụng:

```bash
mvn clean package -DskipTests
mvn spring-boot:run
```

4. Truy cập:

- `http://localhost:8080/trang-chu`
- `http://localhost:8080/login`

---

## 👤 Tài khoản demo

- **Admin / MANAGER**
  - Username: `nguyenvana`
  - Password: `123456`
- **Editor**
  - Username: `nguyenvanb`
  - Password: `123456`

---

## 📁 Cấu trúc dự án (rút gọn)

```text
.
├── .github/workflows/ci-cd.yml
├── database/family_tree_db.sql
├── deploy/
├── src/main/java/com/javaweb/
├── src/main/resources/
├── src/main/webapp/WEB-INF/views/
├── Dockerfile
└── pom.xml
```

---

## ✅ Tóm tắt giá trị dự án

Đây là một dự án thể hiện năng lực xây dựng sản phẩm **end-to-end**:

- Có bài toán thực tế rõ ràng.
- Có kiến trúc, bảo mật và phân quyền.
- Có tính năng realtime (livestream).
- Có quy trình triển khai production bằng CI/CD.

Phù hợp để trình bày với cả người dùng phổ thông, giảng viên và nhà tuyển dụng kỹ thuật.
