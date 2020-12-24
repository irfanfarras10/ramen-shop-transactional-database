CREATE DATABASE Ramen_Shop
GO
USE Ramen_Shop

--DDL for Create Master Table 
CREATE TABLE MsCustomer(
	CustomerID char(5) NOT NULL, 
	CustomerName varchar(100),
	CustomerDoB date, 
	CustomerGender varchar(6),
	CustomerAddress varchar(100),
	CustomerPhoneNumber varchar(13),
	PRIMARY KEY (CustomerID),
	CONSTRAINT checkCustomerID CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CONSTRAINT checkCustomerGender CHECK (CustomerGender IN ('Male','Female')),
	CONSTRAINT checkCustomerAddress CHECK (CustomerAddress LIKE '%Street')
)

CREATE TABLE MsStaff(
	StaffID char(5) NOT NULL,
	StaffName varchar(100),
	StaffGender varchar(6),
	StaffDoB date,
	StaffPhoneNumber varchar(13),
	StaffAddress varchar(100),
	StaffSalary numeric(11,2),
	PRIMARY KEY (StaffID),
	CONSTRAINT checkStaffID CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	CONSTRAINT checkStaffGender CHECK (StaffGender IN ('Male','Female')),
	CONSTRAINT checkStaffAddress CHECK (StaffAddress LIKE '%Street'),
	CONSTRAINT checkStaffSalary CHECK (StaffSalary BETWEEN 1500000 AND 3500000)
)

CREATE TABLE MsSupplier(
	SupplierID char(5) NOT NULL, 
	SupplierName varchar(100), 
	SupplierAddress varchar(100),
	SupplierPhoneNumber varchar(13),
	PRIMARY KEY (SupplierID),
	CONSTRAINT checkSupplierID CHECK (SupplierID LIKE 'SP[0-9][0-9][0-9]'),
	CONSTRAINT checkSupplierAddress CHECK (SupplierAddress LIKE '%Street'),
	CONSTRAINT checkSupplierName CHECK (LEN(SupplierName) BETWEEN 5 AND 50)
)

CREATE TABLE MsRamen(
	RamenID char(5) NOT NULL, 
	RamenName varchar(100),
	RamenPrice numeric(11,2),
	PRIMARY KEY (RamenID),
	CONSTRAINT checkRamenID CHECK (RamenID LIKE 'RA[0-9][0-9][0-9]'),
	CONSTRAINT checkRamenName CHECK (RamenName LIKE '% %')
)

CREATE TABLE MsIngredient(
	IngredientID char(5) NOT NULL, 
	IngredientName varchar(100),
	IngredientStock int,
	PRIMARY KEY (IngredientID),
	CONSTRAINT checkIngredientID CHECK (IngredientID LIKE 'RI[0-9][0-9][0-9]')
)

--DDL for Create Transaction Table
CREATE TABLE HeaderSalesTransaction(
	SalesTransactionID char(5) NOT NULL, 
	StaffID char(5),
	CustomerID char(5),
	SalesTransactionDate date
	PRIMARY KEY (SalesTransactionID),
	FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID),
	FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID),
	CONSTRAINT checkSalesTransactionID CHECK (SalesTransactionID LIKE 'SL[0-9][0-9][0-9]') 
)

CREATE TABLE HeaderPurchaseTransaction(
	PurchaseTransactionID char(5) NOT NULL, 
	StaffID char(5),
	SupplierID char(5),
	PurchaseTransactionDate date, 
	PRIMARY KEY (PurchaseTransactionID),
	FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID),
	FOREIGN KEY (SupplierID) REFERENCES MsSupplier(SupplierID),
	CONSTRAINT checkPurchaseTransactionID CHECK (PurchaseTransactionID LIKE 'PU[0-9][0-9][0-9]')
)

--DDL for Create Transaction Detail Table
CREATE TABLE DetailSalesTransaction(
	SalesTransactionID char(5),
	RamenID char(5),
	RamenQty int,
	PRIMARY KEY (SalesTransactionID, RamenID),
	FOREIGN KEY (SalesTransactionID) REFERENCES HeaderSalesTransaction(SalesTransactionID),
	FOREIGN KEY (RamenID) REFERENCES MsRamen(RamenID)
) 

CREATE TABLE DetailPurchaseTransaction(
	PurchaseTransactionID char(5),
	IngredientID char(5),
	IngredientQty int,
	PRIMARY KEY (PurchaseTransactionID, IngredientID),
	FOREIGN KEY (PurchaseTransactionID) REFERENCES HeaderPurchaseTransaction(PurchaseTransactionID),
	FOREIGN KEY (IngredientID) REFERENCES MsIngredient(IngredientID)
) 

CREATE TABLE RecipeDetail(
	RamenID char(5) NOT NULL, 
	IngredientID char(5) NOT NULL, 
	IngredientQty int, 
	PRIMARY KEY (RamenID, IngredientID),
	FOREIGN KEY (RamenID) REFERENCES MsRamen(RamenID),
	FOREIGN KEY (IngredientID) REFERENCES MsIngredient(IngredientID)
)

