-- SampleDB Veritabanýný Oluþturma
CREATE DATABASE SampleDB;
GO

-- SampleDB Veritabanýna Employees Tablosu Ekleme
USE SampleDB;
GO
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);
GO

-- Employees Tablosuna Örnek Veriler Ekleme
INSERT INTO Employees (FirstName, LastName, Department, HireDate, Salary)
VALUES 
    ('Ali', 'Yýlmaz', 'IT', '2023-01-15', 7500.00),
    ('Ayþe', 'Demir', 'HR', '2022-06-20', 6500.00),
    ('Mehmet', 'Kara', 'Finance', '2021-03-10', 8000.00),
    ('Fatma', 'Çelik', 'Marketing', '2024-02-01', 7000.00),
    ('Ahmet', 'Þahin', 'IT', '2023-11-12', 7200.00);
GO

-- Orijinal Yedekleme ve Geri Yükleme Komutlarý

-- SampleDB için Tam Yedekleme
-- SampleDB veritabanýnýn tam yedeðini belirtilen dosya yoluna alýr.
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Full Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB için Fark Yedekleme
-- SampleDB veritabanýnda tam yedekten sonra deðiþen verilerin fark yedeðini alýr.
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_DiffBackup.bak'
WITH DIFFERENTIAL,
     NOFORMAT, NOINIT,
     NAME = N'SampleDB-Differential Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

--Veritabanýnýn Kurtarma Modelini FULL Olarak Deðiþtirme:
ALTER DATABASE SampleDB SET RECOVERY FULL;
GO

-- Tam Yedekleme Yapma:
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Full Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB için Artýk (Transaction Log) Yedekleme
-- SampleDB veritabanýnýn transaction log'larýný yedekler, veri deðiþikliklerinin kaydýný tutar.
BACKUP LOG SampleDB
TO DISK = N'C:\Backup\SampleDB_LogBackup.trn'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Transaction Log Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB için Point-in-Time Restore Senaryosu

-- Tek Kullanýcý Moduna Al
-- Veritabanýný tek kullanýcý moduna alýr, tüm aktif baðlantýlarý keser.
USE master
ALTER DATABASE SampleDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Transaction Log Yedeði Alma (Log kuyruðunu yedekler)
-- Veritabanýnýn log kuyruðunu yedekler, mevcut loglarý korur.
BACKUP LOG SampleDB
TO DISK = N'C:\Backup\SampleDB_TailLogBackup.trn'
WITH NORECOVERY;
GO

-- Full Backup Geri Yükle (NORECOVERY)
-- Tam yedeði geri yükler, ancak iþlemi tamamlamaz, sonraki yedeklerin uygulanmasý için bekler.
RESTORE DATABASE SampleDB
FROM DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NORECOVERY;
GO

-- Fark Yedeði Geri Yükle (Varsa, NORECOVERY)
-- Fark yedeðini geri yükler, yine iþlemi tamamlamaz, log yedeði için bekler.
RESTORE DATABASE SampleDB
FROM DISK = N'C:\Backup\SampleDB_DiffBackup.bak'
WITH NORECOVERY;
GO

-- Log Yedeði Geri Yükle (Belirli Zamana Kadar, RECOVERY)
-- Transaction log yedeðini belirlenen zamana kadar geri yükler ve iþlemi tamamlar (veritabaný açýlýr).
RESTORE LOG SampleDB
FROM DISK = N'C:\Backup\SampleDB_LogBackup.trn'
WITH STOPAT = '2025-05-26T21:15:42.500',
     RECOVERY;
GO

--Veritabanýný Çok Kullanýcý Moduna Geri Alma
ALTER DATABASE SampleDB SET MULTI_USER;
GO

--Geri yüklenen verileri kontrol et: Employees tablosundaki verileri görüntüle
SELECT * FROM Employees;

--Veritabanýndaki tüm kullanýcý tablolarýný listele
SELECT name 
FROM sys.tables;

--Tam yedek dosyasýnýn içerdiði dosyalarý ve detaylarýný listele
RESTORE FILELISTONLY 
FROM DISK = 'C:\Backup\SampleDB_FullBackup.bak';

--Log yedek dosyasýnýn baþlýk bilgilerini kontrol et
RESTORE HEADERONLY 
FROM DISK = 'C:\Backup\SampleDB_LogBackup.trn';

--Geri yükleme iþlemi sýrasýnda %10'luk ilerleme göstergesiyle takip et 
RESTORE DATABASE SampleDB
FROM DISK = 'C:\Backup\SampleDB_FullBackup.bak'
WITH NORECOVERY, STATS = 10;

;