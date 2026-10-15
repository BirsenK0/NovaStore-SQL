--BÖLÜm 1: Veri Tabanı Tasarımı
--CREATE DATABASE NovaStoreDB;
USE NovaStoreDB;
--Tablolar
CREATE TABLE Categories(
	CategoryID int IDENTITY(1,1) PRIMARY KEY,
	CategoryName varchar(50) NOT NULL
);

CREATE TABLE Customers(
	CustomerID int IDENTITY(1,1) PRIMARY KEY,
	FullName varchar(50),
	City varchar(20),
	Email varchar(100) UNIQUE
);

CREATE TABLE Products (
	ProductID int IDENTITY(1,1) PRIMARY KEY,
	ProductName varchar(100) NOT NULL,
	Price decimal(10,2),
	Stock int DEFAULT 0,
	CategoryID int FOREIGN KEY REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
	OrderID int IDENTITY(1,1) PRIMARY KEY,
	CustomerID int FOREIGN KEY REFERENCES Customers(CustomerID),
	OrderDate datetime DEFAULT GETDATE(),
	TotalAmount decimal(10,2)
);

CREATE TABLE OrderDetails(
	DetailID int IDENTITY(1,1) PRIMARY KEY,
	OrderID int FOREIGN KEY REFERENCES Orders(OrderID),
	ProductID int FOREIGN KEY REFERENCES Products(ProductID),
	Quantity int
);
--BOLUM 2: Veri Girişi
INSERT INTO Categories (CategoryName)
VALUES ('Elektronik'), ('Giyim'), ('Kitap'), ('Kozmetik'), ('Ev ve Yaşam');

--GOREV 2: Urunler
INSERT INTO Products (ProductName, Price, Stock,CategoryID)
VALUES
('Kablosuz Kulaklık', 899.90, 35, 1),
('Akıllı Saat', 1499.00, 12, 1),
('Powerbank', 349.50, 60, 1),
('Kot Pantolon', 599.99, 40, 2),
('Tişört', 149.90, 8, 2),
('Mont', 1299.00, 15, 2),
('Suç ve Ceza', 89.50, 50, 3),
('Sefiller', 120.00, 18, 3),
('Nemlendirici Krem', 219.90, 25, 4),
('Parfüm', 749.00, 10, 4),
('Nevresim Takımı', 450.00, 22, 5),
('Kahve Makinesi', 1899.00, 5, 5);

--GOREV 3: Musteriler(FullName, Cıty, Emaıl)
INSERT INTO Customers (FullName, City, Email)
VALUES 
('Birsen Küçük', 'İzmir', 'birsenkucuk2020@gmail.com'),
('Ayşe Demir', 'Ankara', 'ayse.demir@gmail.com'),
('Mehmet Kaya', 'İstanbul', 'mehmet.kaya@gmail.com'),
('Zeynep Çelik', 'İzmir', 'zeynep.celik@gmail.com'),
('Can Öztürk', 'Bursa', 'can.ozturk@gmail.com'),
('Elif Arslan', 'Antalya', 'elif.arslan@gmail.com');


--GÖREV 4: Siparişler(CustomerID, OrderDate, TotalAmount)
INSERT INTO Orders(CustomerID, OrderDate, TotalAmount)
VALUES
(1, '20260805', 1078.90),
(2, '20260812', 899.79),
(3, '20260820', 1499.00),
(1, '20260902', 968.90),
(4, '20260910', 1899.00),
(5, '20260918', 819.00),
(2, '20260925', 1749.00),
(6, '20261001', 239.40),
(3, '20261008', 1799.80),
(4, '20261012', 789.30);

--GOREV 4: Sipariş Detayları(OrderID, ProductID, Quantity)
INSERT INTO OrderDetails (OrderID,ProductID, Quantity)
VALUES
(1, 1, 1), (1, 7, 2),
(2, 4, 1), (2, 5, 2),
(3, 2, 1),
(4, 9, 1), (4, 10, 1),
(5, 12, 1),
(6, 3, 2), (6, 8, 1),
(7, 11, 1), (7, 6, 1),
(8, 7, 1), (8, 5, 1),
(9, 1, 2),
(10, 9, 2), (10, 3, 1);
SELECT * FROM CATEGORİES;
SELECT * FROM Products;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM ORDERDETAİLS;

--BOLUM 3: Soru 1
SELECT ProductName, Stock
FROM Products 
WHERE Stock<20
ORDER BY Stock DESC;

--BOLUM 3: Soru 2
SELECT c.FullName, c.City, o.OrderDate,o.TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID=o.CustomerID;

--BOLUM 3: Soru 3 ->Birsen Küçük aldığı ürünler
SELECT c.FullName, p.ProductName, p.Price, cat.CategoryName AS Kategori
FROM Customers c
INNER JOIN Orders o ON c.CustomerID= o.CustomerID
INNER JOIN OrderDetails od ON o.orderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Birsen Küçük';

--BOLUM 3: Soru 4
SELECT cat.CategoryName, COUNT(p.ProductID) AS UrunSayisi
FROM Categories cat 
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;

--BOLUM 3: Soru 5 -> Her Müşterinin toplam cirosu
SELECT c.CustomerID,c.FullName, SUM(o.TotalAmount) AS ToplamCiro
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.customerID, c.FullName
ORDER BY ToplamCiro DESC;

--BOLUM 3: Soru 6-> Siparişlerin kaç gün önce verildiği
SELECT OrderID, OrderDate, DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGun
FROM Orders
ORDER BY OrderDate DESC;


--BOLUM 4: Gorev 1 -> Siparis Ozeti View
GO
CREATE VIEW vw_SiparisOzet AS
SELECT c.FullName AS MusteriAdi, o.orderDate AS SiparisTarihi,
	   p.ProductName AS UrunAdi, od.Quantity AS Adet
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.orderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;
GO
SELECT * FROM vw_SiparisOzet;

--BOLUM 4: Gorev 2 -> Veri tabani yedegi
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak';