USE Ramen_Shop
GO

--Answer of 10 Cases 

--1 
SELECT msr.RamenID, RamenName, [Total Ingredient] = CAST(COUNT(rcd.IngredientID) AS varchar(10)) + ' Ingredients'
FROM MsRamen msr 
JOIN RecipeDetail rcd
ON msr.RamenID = rcd.RamenID
JOIN MsIngredient msi 
ON rcd.IngredientID = msi.IngredientID
WHERE msi.IngredientStock < 25
GROUP BY msr.RamenID, RamenName
HAVING COUNT(rcd.IngredientID) > 1

--2
SELECT [Number Of Sales] = COUNT(SalesTransactionID), CustomerName, Gender = SUBSTRING(CustomerGender,1,1), StaffName
FROM HeaderSalesTransaction hst
JOIN MsCustomer msc
ON hst.CustomerID = msc.CustomerID
JOIN MsStaff mst 
ON hst.StaffID = mst.StaffID
WHERE StaffGender = 'Female' AND ABS(DATEDIFF(YEAR, StaffDoB, CustomerDoB)) > 5
GROUP BY CustomerName, CustomerGender, StaffName

--3
SELECT [Purchase Date] = CONVERT(VARCHAR(10), PurchaseTransactionDate , 103), StaffName, SupplierName, [Total Ingredient] = COUNT(IngredientID), [Total Quantity] = SUM(IngredientQty)
FROM HeaderPurchaseTransaction hpt
JOIN MsStaff mst 
ON hpt.StaffID = mst.StaffID
JOIN MsSupplier msp
ON hpt.SupplierID = msp.SupplierID
JOIN DetailPurchaseTransaction dst
ON hpt.PurchaseTransactionID = dst.PurchaseTransactionID
WHERE YEAR(PurchaseTransactionDate) = 2016 AND LEN(SupplierName) < 15
GROUP BY PurchaseTransactionDate, StaffName, SupplierName

--4
SELECT CustomerName, CustomerPhoneNumber, [Sales Day] = DATENAME(WEEKDAY, SalesTransactionDate), [Variant Ramen Sold] = COUNT(RamenID)
FROM MsCustomer msc
JOIN HeaderSalesTransaction hst
ON msc.CustomerID = hst.CustomerID
JOIN DetailSalesTransaction dst
ON hst.SalesTransactionID = dst.SalesTransactionID
WHERE DAY(SalesTransactionDate) = 3
GROUP BY CustomerName, CustomerPhoneNumber, SalesTransactionDate
HAVING SUM(RamenQty) > 10

--RIGHT ANSWER

SELECT CustomerName, CustomerPhoneNumber, hst.SalesTransactionDate, [Variant Ramen Sold] = COUNT(RamenID)
FROM MsCustomer msc
JOIN HeaderSalesTransaction hst
ON msc.CustomerID = hst.CustomerID
JOIN DetailSalesTransaction dst
ON hst.SalesTransactionID = dst.SalesTransactionID
WHERE MONTH(SalesTransactionDate) = 3
GROUP BY CustomerName, CustomerPhoneNumber, SalesTransactionDate
HAVING SUM(RamenQty) > 10

--5
SELECT hpt.PurchaseTransactionID, IngredientName, IngredientQty, StaffName, [Staff Phone] = STUFF(StaffPhoneNumber,1,1,'+62'), [Staff Salary] = 'Rp.' + CAST(mst.StaffSalary AS varchar(15))
FROM HeaderPurchaseTransaction hpt
JOIN MsStaff mst
ON hpt.StaffID = mst.StaffID
JOIN DetailPurchaseTransaction dpt
ON hpt.PurchaseTransactionID = dpt.PurchaseTransactionID
JOIN MsIngredient msi 
ON dpt.IngredientID = msi.IngredientID,
(SELECT AVG(StaffSalary) AS AVGStaffSalary FROM MsStaff) AS X
WHERE YEAR(hpt.PurchaseTransactionDate) = 2017 AND StaffSalary > X.AVGStaffSalary

--6 
SELECT StaffID = STUFF(mst.StaffID,1,2,'Staff '), StaffName, [Sales Transaction Date] = CONVERT(varchar(10), SalesTransactionDate, 107), RamenQty
FROM MsStaff mst
JOIN HeaderSalesTransaction hst 
ON mst.StaffID = hst.StaffID
JOIN DetailSalesTransaction dst
ON hst.SalesTransactionID = dst.SalesTransactionID,
(SELECT AVG(StaffSalary) AS AVGStaffSalary FROM MsStaff) AS X
WHERE StaffSalary < X.AVGStaffSalary AND StaffName LIKE '% % %'	

--7(REVISI DATA GAK ADA OUTPUT)
SELECT [Ramen Sold] = COUNT(RamenID), [Customer Last Name] = REVERSE(SUBSTRING(REVERSE(CustomerName),1,CHARINDEX(' ',REVERSE(CustomerName)))), StaffName, hst.SalesTransactionDate
FROM DetailSalesTransaction dst 
JOIN MsCustomer msc
ON dst.RamenID = dst.RamenID
JOIN HeaderSalesTransaction hst
ON dst.SalesTransactionID = hst.SalesTransactionID
JOIN MsStaff mst 
ON hst.StaffID = mst.StaffID,
(SELECT AVG(RamenQty) AS AVGRamenQty FROM DetailSalesTransaction) AS X
WHERE RamenQty < X.AVGRamenQty AND LEN(CustomerName) > 15
GROUP BY CustomerName, StaffName, SalesTransactionDate 

--8
SELECT SalesID = hst.SalesTransactionID, CustomerName, Gender = SUBSTRING(CustomerGender,1,1), RamenName, [Total Price] = CAST(SUM(RamenPrice) AS varchar(15)) + ' IDR'
FROM HeaderSalesTransaction hst
JOIN MsCustomer msc
ON hst.CustomerID = msc.CustomerID
JOIN DetailSalesTransaction dst
ON hst.SalesTransactionID = dst.SalesTransactionID
JOIN MsRamen msr
ON dst.RamenID = msr.RamenID,
(SELECT MIN(RamenPrice) AS MINRamenPrice FROM MsRamen) AS X 
WHERE RamenPrice > X.MINRamenPrice AND ABS(DATEDIFF(YEAR, CustomerDoB, GETDATE())) < 17
GROUP BY hst.SalesTransactionID, CustomerName, CustomerGender, RamenName

--9 
GO
CREATE VIEW ViewSales
AS
	SELECT  CustomerName, [Number of Sales] = COUNT(DISTINCT(hst.SalesTransactionID)), [Total Price] = SUM(RamenPrice * RamenQty)
	FROM MsCustomer msc
	JOIN HeaderSalesTransaction hst
	ON msc.CustomerID = hst.CustomerID
	JOIN DetailSalesTransaction dst
	ON hst.SalesTransactionID = dst.SalesTransactionID
	JOIN MsRamen msr
	ON dst.RamenID = msr.RamenID
	WHERE YEAR(hst.SalesTransactionDate) < 2017 AND CustomerAddress LIKE 'Pasar%' 
	GROUP BY CustomerName

--10
GO 
CREATE VIEW PurchaseDetail 
AS 
	SELECT [Item Purchased] = CAST(SUM(IngredientQty) AS VARCHAR(5)) + ' Pcs', [Number of Transaction] = COUNT(DISTINCT(hpt.PurchaseTransactionID)), SupplierName, StaffName 
	FROM DetailPurchaseTransaction dpt
	JOIN HeaderPurchaseTransaction hpt
	ON dpt.PurchaseTransactionID = hpt.PurchaseTransactionID
	JOIN MsSupplier mss 
	ON hpt.SupplierID = mss.SupplierID
	JOIN MsStaff mst
	ON hpt.StaffID = mst.StaffID
	WHERE YEAR(PurchaseTransactionDate) = 2016 AND StaffGender = 'Male'
	GROUP BY SupplierName, StaffName

