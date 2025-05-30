-- Veritabaný oluþturuluyor
CREATE DATABASE KutuphaneDB;
GO

-- Kullanýlacak veritabaný seçiliyor
USE KutuphaneDB;
GO

CREATE TABLE Authors (                -- 1. Yazarlar tablosu
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,       
    FullName NVARCHAR(100),                        
    Country NVARCHAR(50),                         
    BirthDate DATE,                                
    Gender NVARCHAR(10)                            
);
GO

USE KutuphaneDB;
GO
-- 2. Kitaplar tablosu
CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,          
    Title NVARCHAR(255),                           
    AuthorName NVARCHAR(100),                      
    PublishDate DATE,                              
    Genre NVARCHAR(50)                             
);
GO

USE KutuphaneDB;
GO
CREATE TABLE Readers (        -- 3. Okuyucular tablosu
    ReaderID INT IDENTITY(1,1) PRIMARY KEY,        
    FullName NVARCHAR(100),                        
    Address NVARCHAR(255),                        
    Email NVARCHAR(100),                           
    Phone NVARCHAR(50)                             
);
GO

USE KutuphaneDB;
GO
CREATE TABLE Borrowings (             -- 4. Ödünç alma kayýtlarý tablosu
    BorrowingID INT IDENTITY(1,1) PRIMARY KEY,     
    BookID INT FOREIGN KEY REFERENCES Books(BookID),  -- Ödünç alýnan kitap ID'si
    ReaderID INT FOREIGN KEY REFERENCES Readers(ReaderID), -- Ödünç alan okuyucu ID'si
    BorrowDate DATE,                               
    ReturnDate DATE                                
);
GO

INSERT INTO Authors (FullName, Country, BirthDate, Gender)
VALUES
('Nicholas Mcguire', 'USA', '1975-03-12', 'Male'),
('James Salas', 'UK', '1980-07-25', 'Male'),
('Michael Olson', 'Canada', '1968-11-09', 'Male'),
('Raven Carpenter', 'USA', '1990-02-18', 'Female'),
('David Fowler', 'Germany', '1973-10-01', 'Male'),
('Lisa Richards', 'France', '1988-12-04', 'Female'),
('Amanda Fox', 'Italy', '1983-06-30', 'Female'),
('Stephen Sanders', 'Australia', '1979-04-22', 'Male'),
('Megan Terry', 'Spain', '1992-08-11', 'Female'),
('Gary Hicks', 'Mexico', '1985-01-15', 'Male'),
('Emily Sullivan', 'USA', '1991-05-05', 'Female'),
('Daniel Vargas', 'Portugal', '1976-09-17', 'Male'),
('Isabelle Leonard', 'France', '1984-03-22', 'Female'),
('Henry Morrison', 'Ireland', '1977-06-29', 'Male'),
('Patricia Bishop', 'Canada', '1982-11-13', 'Female'),
('Caleb Yates', 'Germany', '1989-07-02', 'Male'),
('Olivia Becker', 'Austria', '1993-10-25', 'Female'),
('John Lee', 'USA', '1986-01-09', 'Male'),
('Angela Barnes', 'UK', '1990-09-03', 'Female'),
('Ryan Cox', 'USA', '1981-02-14', 'Male');

INSERT INTO Books (Title, AuthorName, PublishDate, Genre)
VALUES
('Focused bandwidth-monitored standardization', 'Nicholas Mcguire', '2022-01-20', 'Fiction'),
('Public-key fresh-thinking project', 'James Salas', '2015-05-31', 'Fiction'),
('Synergized neutral emulation', 'Michael Olson', '2022-10-24', 'Fantasy'),
('Expanded modular toolset', 'Raven Carpenter', '2021-08-26', 'Science'),
('Synergistic clear-thinking pricing structure', 'David Fowler', '2021-12-29', 'History'),
('Exclusive client-sensitive paradigm', 'Lisa Richards', '2023-04-10', 'Philosophy'),
('Ergonomic mobile migration', 'Amanda Fox', '2020-11-03', 'Romance'),
('Sharable static application', 'Stephen Sanders', '2019-06-14', 'Adventure'),
('Implemented grid-enabled installation', 'Megan Terry', '2022-07-19', 'Biography'),
('Intuitive tangible core', 'Gary Hicks', '2017-03-08', 'Fantasy'),
('Extended background internet solution', 'Emily Sullivan', '2021-05-11', 'Poetry'),
('Compatible national instruction set', 'Daniel Vargas', '2020-09-23', 'Science'),
('Integrated mission-critical open system', 'Isabelle Leonard', '2022-02-17', 'Drama'),
('Organized system-worthy infrastructure', 'Henry Morrison', '2023-03-30', 'Fiction'),
('Distributed dynamic projection', 'Patricia Bishop', '2019-01-05', 'Thriller'),
('Streamlined well-modulated neural-net', 'Caleb Yates', '2021-10-10', 'Children'),
('Multi-layered neutral neural-net', 'Olivia Becker', '2018-12-12', 'Technology'),
('Configurable executive interface', 'John Lee', '2016-08-04', 'Poetry'),
('Switchable 6th generation initiative', 'Angela Barnes', '2020-02-22', 'Self-Help'),
('Automated cohesive orchestration', 'Ryan Cox', '2023-06-07', 'History');

INSERT INTO Readers (FullName, Email, Phone, Address)
VALUES
('Aylin Demir', 'aylin.demir@example.com', '+905321112233', 'Kadýköy, Ýstanbul'),
('Mehmet Yýldýz', 'mehmet.yildiz@example.com', '+905324445566', 'Beþiktaþ, Ýstanbul'),
('Zeynep Kaya', 'zeynep.kaya@example.com', '+905326778899', 'Çankaya, Ankara'),
('Ahmet Kurt', 'ahmet.kurt@example.com', '+905329990011', 'Beylikdüzü, Ýstanbul'),
('Elif Öz', 'elif.oz@example.com', '+905321223344', 'Ataþehir, Ýstanbul'),
('Cem Karaca', 'cem.karaca@example.com', '+905325556677', 'Kýzýlay, Ankara'),
('Buse Tan', 'buse.tan@example.com', '+905328889900', 'Üsküdar, Ýstanbul'),
('Deniz Arslan', 'deniz.arslan@example.com', '+905321234567', 'Þiþli, Ýstanbul'),
('Selin Doðan', 'selin.dogan@example.com', '+905322345678', 'Fatih, Ýstanbul'),
('Emir Koç', 'emir.koc@example.com', '+905323456789', 'Kadýköy, Ýstanbul'),
('Nazlý Þahin', 'nazli.sahin@example.com', '+905324567890', 'Çankaya, Ankara'),
('Berk Yýlmaz', 'berk.yilmaz@example.com', '+905325678901', 'Pendik, Ýstanbul'),
('Derya Acar', 'derya.acar@example.com', '+905326789012', 'Kartal, Ýstanbul'),
('Okan Güneþ', 'okan.gunes@example.com', '+905327890123', 'Keçiören, Ankara'),
('Ýrem Polat', 'irem.polat@example.com', '+905328901234', 'Ümraniye, Ýstanbul'),
('Ali Vural', 'ali.vural@example.com', '+905329012345', 'Göztepe, Ýstanbul'),
('Mert Eren', 'mert.eren@example.com', '+905321098765', 'Mecidiyeköy, Ýstanbul'),
('Pelin Ceylan', 'pelin.ceylan@example.com', '+905322198765', 'Sarýyer, Ýstanbul'),
('Barýþ Aksoy', 'baris.aksoy@example.com', '+905323298765', 'Beyoðlu, Ýstanbul'),
('Sevgi Kaplan', 'sevgi.kaplan@example.com', '+905324398765', 'Eskiþehir Yolu, Ankara');

INSERT INTO Borrowings (ReaderID, BookID, BorrowDate, ReturnDate)
VALUES
(1, 3, '2023-03-01', '2023-03-15'),
(2, 5, '2023-04-10', '2023-04-25'),
(3, 7, '2022-11-12', '2022-11-26'),
(4, 1, '2021-09-05', '2021-09-20'),
(5, 8, '2023-06-18', NULL),
(6, 4, '2020-02-10', '2020-02-24'),
(7, 10, '2022-01-14', '2022-01-28'),
(8, 2, '2023-07-19', NULL),
(9, 6, '2021-05-03', '2021-05-17'),
(10, 9, '2020-12-25', '2021-01-08'),
(11, 12, '2023-01-02', '2023-01-16'),
(12, 13, '2022-04-09', '2022-04-23'),
(13, 14, '2023-02-11', NULL),
(14, 15, '2022-09-07', '2022-09-21'),
(15, 11, '2021-07-15', '2021-07-29'),
(16, 16, '2020-03-20', '2020-04-03'),
(17, 18, '2021-10-12', '2021-10-26'),
(18, 17, '2022-05-23', NULL),
(19, 19, '2023-03-30', NULL),
(20, 20, '2023-04-14', NULL);

SELECT TABLE_SCHEMA, TABLE_NAME    -- Kütüphane veritabanýndaki tüm 
FROM INFORMATION_SCHEMA.TABLES     --temel (base) tablolarý listeler
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- En çok CPU kullanan 20 sorguyu listeler (ortalama CPU zamaný baz alýnarak)
SELECT TOP 20
    qs.execution_count,                                      -- Sorgunun kaç kez çalýþtýðý
    qs.total_worker_time,                                    -- Toplam CPU süresi (mikrosaniye)
    qs.total_worker_time / NULLIF(qs.execution_count, 0) AS Avg_CPU_Time, -- Ortalama CPU süresi
    SUBSTRING(qt.text, 
        (qs.statement_start_offset / 2) + 1, 
        ((CASE qs.statement_end_offset 
            WHEN -1 THEN DATALENGTH(qt.text) 
            ELSE qs.statement_end_offset 
        END - qs.statement_start_offset) / 2) + 1) AS QueryText -- Sorgu metni
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
WHERE qs.execution_count > 0
ORDER BY Avg_CPU_Time DESC;

-- En az kullanýlan indeksleri tespit eder (arama, tarama, lookup sayýsýna göre)
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,     
    i.name AS IndexName,                       
    i.index_id,                                
    s.user_seeks, s.user_scans,                -- Arama ve tarama sayýsý
    s.user_lookups, s.user_updates             
FROM sys.indexes AS i
LEFT JOIN sys.dm_db_index_usage_stats AS s 
    ON i.object_id = s.object_id AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1            -- Sadece kullanýcý tablolarý
  AND i.name IS NOT NULL																								
ORDER BY (ISNULL(s.user_seeks, 0) + ISNULL(s.user_scans, 0) + ISNULL(s.user_lookups, 0)) ASC;

-- Kullanýlmadýðý tespit edilen bir indeksin tanýmýna bak
EXEC sp_helpindex 'dbo.Books';

-- OkuyucuId ve KitapId üzerinde aramalarý hýzlandýrmak için yeni bir indeks
CREATE NONCLUSTERED INDEX IX_Borrowings_ReaderId_BookId
ON Borrowings (ReaderId, BookId); -- Borrowings tablosunda

-- Ortalama çalýþtýrma süresi en yüksek olan sorgularý getir
SELECT TOP 5
    total_elapsed_time / execution_count AS AvgTime, -- Ortalama süre
    execution_count,                                 -- Çalýþma sayýsý
    total_elapsed_time,                              -- Toplam süre
    SUBSTRING(qt.text, 
        (qs.statement_start_offset / 2) + 1, 
        ((CASE qs.statement_end_offset                                                             
            WHEN -1 THEN DATALENGTH(qt.text) 
            ELSE qs.statement_end_offset 
        END - qs.statement_start_offset) / 2) + 1) AS QueryText -- Sorgu metni
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY AvgTime DESC;

-- Tablolarýn disk kullaným bilgilerini ve satýr sayýlarýný getirir
SELECT 
    t.name AS TableName,                         
    SUM(p.rows) AS RowCounts,                    
    SUM(a.total_pages) * 8 AS TotalSpaceKB,      
    SUM(a.used_pages) * 8 AS UsedSpaceKB         
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY t.name
ORDER BY TotalSpaceKB DESC; -- En fazla yer kaplayanlar önce gelir

-- Yeni kullanýcý için login oluþtur
CREATE LOGIN Ceninkullanici1 WITH PASSWORD = 'Password23'; -- Güvenli þifre

-- Kütüphane veritabaný için kullanýcý oluþtur
CREATE USER Ceninkullanici1 FOR LOGIN Ceninkullanici1;


-- Sadece okuma yetkisi ver (db_datareader rolüne ekleme)
EXEC sp_addrolemember 'db_datareader', 'Ceninkullanici1';

EXEC sp_helpuser 'Ceninkullanici1'

-- Kullanýcý bilgilerini görüntüleme
SELECT name, type_desc 
FROM sys.database_principals 
WHERE name = 'Ceninkullanici1'; -- Kullanýcýnýn adý

-- Þifre güncelleme
ALTER LOGIN testuser WITH PASSWORD = 'YeniGuvenliSifre123';
