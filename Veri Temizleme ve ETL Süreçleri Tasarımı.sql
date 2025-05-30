-- Veritaban� olu�turma
CREATE DATABASE ETL_ExampleDB;
GO

-- Olu�turdu�umuz veritaban�na ge�i� yapal�m
USE ETL_ExampleDB;
GO

-- �rnek tablo olu�turma
CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate NVARCHAR(20), -- Bilerek yanl�� formatta (string olarak)
    Amount DECIMAL(10,2)
);
GO

-- �rnek veri ekleme (baz� hatalarla)
INSERT INTO dbo.Orders (OrderID, CustomerName, OrderDate, Amount) VALUES
(1, 'Ahmet Y�lmaz', '2023-01-15', 250.00),
(2, 'Ay�e Demir', '15/02/2023', 180.50),  -- Tarih format� farkl�
(3, 'Mehmet �elik', NULL, 300.00),       -- Eksik tarih
(4, NULL, '2023-03-01', 150.00),          -- Eksik m��teri ad�
(5, 'Fatma Kaya', '2023-03-05', NULL);    -- Eksik tutar
GO


SELECT * FROM dbo.Orders;


-- Eksik veya hatal� verileri bulma
SELECT
    OrderID,
    CustomerName,
    OrderDate,
    Amount,
    CASE
        WHEN CustomerName IS NULL THEN 'Eksik M��teri Ad�'
        WHEN OrderDate IS NULL THEN 'Eksik Tarih'
        WHEN Amount IS NULL THEN 'Eksik Tutar'
        WHEN TRY_CONVERT(DATE, OrderDate, 23) IS NULL THEN 'Ge�ersiz Tarih Format�'
        ELSE 'Ge�erli Kay�t'
    END AS Durum
FROM dbo.Orders;


-- Hatal� tarih format�n� d�zeltmek i�in yeni bir kolon olu�turup g�ncelleme yapaca��z

-- 1. Yeni kolon ekle (temizlenmi� tarih)
ALTER TABLE dbo.Orders
ADD CleanOrderDate DATE;
GO

-- 2. Tarih format� do�ru olanlar� direkt d�n��t�relim
UPDATE dbo.Orders
SET CleanOrderDate = TRY_CONVERT(DATE, OrderDate, 23) -- 23 = yyyy-mm-dd format�
WHERE TRY_CONVERT(DATE, OrderDate, 23) IS NOT NULL;
GO

-- 3. DD/MM/YYYY format�ndaki tarihleri d�n��t�relim
UPDATE dbo.Orders
SET CleanOrderDate = TRY_CONVERT(DATE, 
    SUBSTRING(OrderDate, 7, 4) + '-' + SUBSTRING(OrderDate, 4, 2) + '-' + SUBSTRING(OrderDate, 1, 2), 23)
WHERE TRY_CONVERT(DATE, OrderDate, 23) IS NULL 
  AND OrderDate IS NOT NULL;
GO

-- Sonu�lar� kontrol et
SELECT OrderID, OrderDate, CleanOrderDate FROM dbo.Orders;


-- Eksik m��teri adlar�n� "Bilinmiyor" olarak g�ncelle
UPDATE dbo.Orders
SET CustomerName = 'Bilinmiyor'
WHERE CustomerName IS NULL;
GO

-- Eksik tutarlar� 0 olarak g�ncelle
UPDATE dbo.Orders
SET Amount = 0
WHERE Amount IS NULL;
GO

-- G�ncellenmi� veriyi kontrol edelim
SELECT OrderID, CustomerName, Amount FROM dbo.Orders;



-- Temizlenmi� veri i�in yeni tablo olu�tur
CREATE TABLE dbo.CleanOrders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate DATE,
    Amount DECIMAL(10,2)
);
GO

-- Temizlenmi� veriyi yeni tabloya aktar
INSERT INTO dbo.CleanOrders (OrderID, CustomerName, OrderDate, Amount)
SELECT OrderID, CustomerName, CleanOrderDate, Amount
FROM dbo.Orders;
GO

-- Yeni tabloyu kontrol et
SELECT * FROM dbo.CleanOrders;


SELECT
    COUNT(*) AS ToplamKay�t,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS EksikTarihSayisi,
    SUM(CASE WHEN CustomerName = 'Bilinmiyor' THEN 1 ELSE 0 END) AS EksikMusteriSayisi,
    SUM(CASE WHEN Amount = 0 THEN 1 ELSE 0 END) AS EksikTutarSayisi
FROM dbo.CleanOrders;





	
