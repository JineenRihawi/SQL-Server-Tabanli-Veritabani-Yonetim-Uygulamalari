-- Veritabaný oluþturma
CREATE DATABASE ETL_ExampleDB;
GO

-- Oluþturduðumuz veritabanýna geçiþ yapalým
USE ETL_ExampleDB;
GO

-- Örnek tablo oluþturma
CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate NVARCHAR(20), -- Bilerek yanlýþ formatta (string olarak)
    Amount DECIMAL(10,2)
);
GO

-- Örnek veri ekleme (bazý hatalarla)
INSERT INTO dbo.Orders (OrderID, CustomerName, OrderDate, Amount) VALUES
(1, 'Ahmet Yýlmaz', '2023-01-15', 250.00),
(2, 'Ayþe Demir', '15/02/2023', 180.50),  -- Tarih formatý farklý
(3, 'Mehmet Çelik', NULL, 300.00),       -- Eksik tarih
(4, NULL, '2023-03-01', 150.00),          -- Eksik müþteri adý
(5, 'Fatma Kaya', '2023-03-05', NULL);    -- Eksik tutar
GO


SELECT * FROM dbo.Orders;


-- Eksik veya hatalý verileri bulma
SELECT
    OrderID,
    CustomerName,
    OrderDate,
    Amount,
    CASE
        WHEN CustomerName IS NULL THEN 'Eksik Müþteri Adý'
        WHEN OrderDate IS NULL THEN 'Eksik Tarih'
        WHEN Amount IS NULL THEN 'Eksik Tutar'
        WHEN TRY_CONVERT(DATE, OrderDate, 23) IS NULL THEN 'Geçersiz Tarih Formatý'
        ELSE 'Geçerli Kayýt'
    END AS Durum
FROM dbo.Orders;


-- Hatalý tarih formatýný düzeltmek için yeni bir kolon oluþturup güncelleme yapacaðýz

-- 1. Yeni kolon ekle (temizlenmiþ tarih)
ALTER TABLE dbo.Orders
ADD CleanOrderDate DATE;
GO

-- 2. Tarih formatý doðru olanlarý direkt dönüþtürelim
UPDATE dbo.Orders
SET CleanOrderDate = TRY_CONVERT(DATE, OrderDate, 23) -- 23 = yyyy-mm-dd formatý
WHERE TRY_CONVERT(DATE, OrderDate, 23) IS NOT NULL;
GO

-- 3. DD/MM/YYYY formatýndaki tarihleri dönüþtürelim
UPDATE dbo.Orders
SET CleanOrderDate = TRY_CONVERT(DATE, 
    SUBSTRING(OrderDate, 7, 4) + '-' + SUBSTRING(OrderDate, 4, 2) + '-' + SUBSTRING(OrderDate, 1, 2), 23)
WHERE TRY_CONVERT(DATE, OrderDate, 23) IS NULL 
  AND OrderDate IS NOT NULL;
GO

-- Sonuçlarý kontrol et
SELECT OrderID, OrderDate, CleanOrderDate FROM dbo.Orders;


-- Eksik müþteri adlarýný "Bilinmiyor" olarak güncelle
UPDATE dbo.Orders
SET CustomerName = 'Bilinmiyor'
WHERE CustomerName IS NULL;
GO

-- Eksik tutarlarý 0 olarak güncelle
UPDATE dbo.Orders
SET Amount = 0
WHERE Amount IS NULL;
GO

-- Güncellenmiþ veriyi kontrol edelim
SELECT OrderID, CustomerName, Amount FROM dbo.Orders;



-- Temizlenmiþ veri için yeni tablo oluþtur
CREATE TABLE dbo.CleanOrders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate DATE,
    Amount DECIMAL(10,2)
);
GO

-- Temizlenmiþ veriyi yeni tabloya aktar
INSERT INTO dbo.CleanOrders (OrderID, CustomerName, OrderDate, Amount)
SELECT OrderID, CustomerName, CleanOrderDate, Amount
FROM dbo.Orders;
GO

-- Yeni tabloyu kontrol et
SELECT * FROM dbo.CleanOrders;


SELECT
    COUNT(*) AS ToplamKayýt,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS EksikTarihSayisi,
    SUM(CASE WHEN CustomerName = 'Bilinmiyor' THEN 1 ELSE 0 END) AS EksikMusteriSayisi,
    SUM(CASE WHEN Amount = 0 THEN 1 ELSE 0 END) AS EksikTutarSayisi
FROM dbo.CleanOrders;





	
