USE Ramen_Shop
GO

--DML FOR SIMULATE SALES TRANSACTION
--INSERT SALES TRANSACTION DATA 
BEGIN TRANSACTION
INSERT INTO HeaderSalesTransaction VALUES 
('SL017','ST001','CU001',GETDATE())
INSERT INTO DetailSalesTransaction VALUES 
('SL017','RA001',1),
('SL017','RA002',2),
('SL017','RA003',1)
--UPDATE STOCK 
UPDATE MsIngredient
SET IngredientStock = IngredientStock - (IngredientQty * RamenQty)
FROM MsIngredient msi 
JOIN RecipeDetail rcd
ON msi.IngredientID = rcd.IngredientID
JOIN DetailSalesTransaction dst
ON rcd.RamenID = dst.RamenID
WHERE SalesTransactionID = 'SL017'
ROLLBACK

--DML FOR SIMULATE PURCHASE TRANSACTION
--INSERT PURCHASE TRANSACTION DATA
BEGIN TRANSACTION
INSERT INTO HeaderPurchaseTransaction VALUES
('PU016','ST001','SP001',GETDATE())
INSERT INTO DetailPurchaseTransaction VALUES 
('PU016','RI001',15),
('PU016','RI002',20),
('PU016','RI014',30)
--UPDATE STOCK
UPDATE MsIngredient
SET IngredientStock = IngredientStock + IngredientQty 
FROM MsIngredient msi 
JOIN DetailPurchaseTransaction dpt
ON msi.IngredientID = dpt.IngredientID
WHERE PurchaseTransactionID ='PU016'
ROLLBACK 