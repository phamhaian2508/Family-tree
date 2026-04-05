# Nền Tảng Quản Lý Gia Phả Trực Tuyến

Hệ thống quản lý gia phả trực tuyến cho nhiều người dùng, được phát triển bởi nhóm 2 thành viên nhằm số hóa dữ liệu gia đình theo hướng có cấu trúc, dễ tra cứu và dễ mở rộng. Trọng tâm của dự án là mô hình hóa cây gia phả nhiều thế hệ theo chi nhánh, kết hợp quản lý quan hệ cha mẹ, con cái và vợ chồng trên cùng một nền tảng.

## Tổng quan

Dự án tập trung giải quyết bài toán nghiệp vụ của cây gia phả thay vì chỉ dừng ở các thao tác CRUD cơ bản. Hệ thống cho phép tổ chức dữ liệu theo chi nhánh, dựng cây gia phả theo nhiều thế hệ, kiểm soát tính nhất quán của quan hệ gia đình và hỗ trợ quản trị tập trung trên môi trường web.

## Triển khai thực tế

- Website: `https://giaphaonline.id.vn/`

## Chức năng chính

- Quản lý cây gia phả theo chi nhánh và theo đời.
- Thêm thành viên, thêm vợ chồng, thêm con và cập nhật thông tin theo ràng buộc nghiệp vụ.
- Tra cứu, lọc và xem chi tiết thành viên trong cây gia phả.
- Kiểm tra và audit dữ liệu để phát hiện quan hệ sai hoặc thiếu nhất quán.
- Phân quyền người dùng theo các vai trò `MANAGER`, `EDITOR`, `USER`.
- Quản lý media gồm ảnh, video và audio gắn với thành viên hoặc nội dung liên quan.
- Hỗ trợ livestream và trao đổi realtime trong hệ thống.

## Công nghệ sử dụng

- Java 8
- Spring Boot 2.0.9
- Spring MVC, Spring Data JPA, Hibernate
- Spring Security
- Spring WebSocket
- JSP, JSTL, SiteMesh
- MySQL 8
- Maven
- Docker, Docker Compose
- GitHub Actions
- AWS EC2

## Kiến trúc tổng quát

```text
Trình duyệt
  -> Ứng dụng Spring Boot MVC
  -> MySQL

Livestream
  -> WebRTC
  -> WebSocket signaling
```

## Chạy local

### 1. Chạy bằng Docker Compose

Khởi động đồng thời ứng dụng và cơ sở dữ liệu:

```bash
docker compose up --build
```

Thông số mặc định:

- Ứng dụng: `http://localhost:8080`
- MySQL: `localhost:3309`
- Database: `family_tree_db`

### 2. Chạy bằng Maven

1. Tạo database `family_tree_db`.
2. Import dữ liệu mẫu:

```bash
mysql -u root -p family_tree_db < database/family_tree_db.sql
```

3. Kiểm tra cấu hình kết nối trong `src/main/resources/application-dev.properties`.
4. Khởi động ứng dụng:

```bash
mvn clean package -DskipTests
mvn spring-boot:run
```

Đường dẫn truy cập:

- Trang chủ: `http://localhost:8080/trang-chu`
- Đăng nhập: `http://localhost:8080/login`

Tài khoản demo:

- Username: `nguyenvana`
- Password: `123456`

## Cấu trúc dự án

```text
.
|-- .github/workflows/ci-cd.yml
|-- database/family_tree_db.sql
|-- deploy/
|-- src/main/java/com/javaweb/
|-- src/main/resources/
|-- src/main/webapp/
|-- docker-compose.yml
|-- Dockerfile
`-- pom.xml
```
