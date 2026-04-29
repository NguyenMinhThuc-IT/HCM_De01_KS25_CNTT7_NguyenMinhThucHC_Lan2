-- ==========================================================
-- PHẦN 2: ĐỊNH NGHĨA DỮ LIỆU (DDL)
-- ==========================================================

-- Tạo cơ sở dữ liệu
CREATE DATABASE SalesManagement;
USE SalesManagement;

-- 1. Tạo bảng Product (Sản phẩm)
CREATE TABLE Product (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    Manufacturer VARCHAR(50),
    UnitPrice DECIMAL(15, 2),
    StockQuantity INT
);

-- 2. Tạo bảng Customer (Khách hàng)
CREATE TABLE Customer (
    CustomerID VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address VARCHAR(255)
);

-- 3. Tạo bảng Order (Đơn hàng)
CREATE TABLE `Order` (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    TotalAmount DECIMAL(15, 2),
    CustomerID VARCHAR(10),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- 4. Tạo bảng Order_Detail (Chi tiết đơn hàng)
CREATE TABLE Order_Detail (
    OrderID VARCHAR(10),
    ProductID VARCHAR(10),
    Quantity INT,
    CurrentPrice DECIMAL(15, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 5. Thêm cột Ghi chú (Note) vào bảng Order
ALTER TABLE `Order` ADD COLUMN Note TEXT;

-- 6. Đổi tên cột Manufacturer thành Brand (Nha San Xuat)
ALTER TABLE Product RENAME COLUMN Manufacturer TO Brand;

-- Thêm dữ liệu mẫu vào bảng Sản phẩm (Gom chung vào 1 lệnh)
INSERT INTO Product (ProductID, ProductName, Brand, UnitPrice, StockQuantity) VALUES 
('SP01', 'MacBook Air M2', 'Apple', 28000000, 10),
('SP02', 'Logitech G502 Mouse', 'Logitech', 1200000, 50),
('SP03', 'AKKO Mechanical Keyboard', 'AKKO', 1500000, 20),
('SP04', 'Dell Ultrasharp Monitor', 'Dell', 12000000, 5),
('SP05', 'iPhone 15 Pro', 'Apple', 25000000, 15);

-- Thêm dữ liệu khách hàng (Có ông khách KH02 không có số điện thoại)
INSERT INTO Customer (CustomerID, FullName, Email, PhoneNumber, Address) VALUES 
('KH01', 'Nguyen Van A', 'a@gmail.com', '0912345678', 'Ha Noi'),
('KH02', 'Tran Thi B', 'b@gmail.com', NULL, 'Da Nang'),
('KH03', 'Le Van C', 'c@gmail.com', '0988888888', 'TP HCM'),
('KH04', 'Pham Van D', 'd@gmail.com', '0977777777', 'Can Tho'),
('KH05', 'Hoang Thi E', 'e@gmail.com', '0966666666', 'Hai Phong');

-- Thêm dữ liệu đơn hàng
INSERT INTO `Order` (OrderID, OrderDate, TotalAmount, CustomerID) VALUES 
('DH001', '2026-04-20', 29200000, 'KH01'),
('DH002', '2026-04-21', 1200000, 'KH03'),
('DH003', '2026-04-22', 28000000, 'KH04'),
('DH004', '2026-04-23', 1500000, 'KH05'),
('DH005', '2026-04-24', 12000000, 'KH01');

-- Thêm dữ liệu chi tiết đơn hàng
INSERT INTO Order_Detail (OrderID, ProductID, Quantity, CurrentPrice) VALUES 
('DH001', 'SP01', 1, 28000000),
('DH001', 'SP02', 1, 1200000),
('DH002', 'SP02', 1, 1200000),
('DH003', 'SP01', 1, 28000000),
('DH004', 'SP03', 1, 1500000);

SET SQL_SAFE_UPDATES = 0;

-- Cập nhật: Tăng giá sản phẩm Apple thêm 10%
UPDATE Product 
SET UnitPrice = UnitPrice * 1.1 
WHERE Brand = 'Apple';

SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
-- Xóa: Khách hàng nào không để lại số điện thoại (NULL)
DELETE FROM Customer 
WHERE PhoneNumber IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- 1. Tìm sản phẩm giá từ 10 triệu đến 20 triệu
SELECT * FROM Product 
WHERE UnitPrice BETWEEN 10000000 AND 20000000;

-- 2. Liệt kê tên sản phẩm trong đơn hàng 'DH001'
SELECT Product.ProductName
FROM Order_Detail
JOIN Product ON Order_Detail.ProductID = Product.ProductID
WHERE Order_Detail.OrderID = 'DH001';

-- 3. Tìm khách hàng đã mua 'MacBook Air M2'
-- Dùng DISTINCT để nếu khách mua 2 lần thì tên chỉ hiện ra 1 lần cho gọn
SELECT DISTINCT Customer.FullName, Customer.Email, Customer.PhoneNumber
FROM Customer
JOIN `Order` ON Customer.CustomerID = `Order`.CustomerID
JOIN Order_Detail ON `Order`.OrderID = Order_Detail.OrderID
JOIN Product ON Order_Detail.ProductID = Product.ProductID
WHERE Product.ProductName = 'MacBook Air M2';