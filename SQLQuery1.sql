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



