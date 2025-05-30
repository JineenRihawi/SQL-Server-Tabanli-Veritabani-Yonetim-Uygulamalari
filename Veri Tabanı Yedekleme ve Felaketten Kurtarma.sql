-- SampleDB Veritaban�n� Olu�turma
CREATE DATABASE SampleDB;
GO

-- SampleDB Veritaban�na Employees Tablosu Ekleme
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

-- Employees Tablosuna �rnek Veriler Ekleme
INSERT INTO Employees (FirstName, LastName, Department, HireDate, Salary)
VALUES 
    ('Ali', 'Y�lmaz', 'IT', '2023-01-15', 7500.00),
    ('Ay�e', 'Demir', 'HR', '2022-06-20', 6500.00),
    ('Mehmet', 'Kara', 'Finance', '2021-03-10', 8000.00),
    ('Fatma', '�elik', 'Marketing', '2024-02-01', 7000.00),
    ('Ahmet', '�ahin', 'IT', '2023-11-12', 7200.00);
GO

-- Orijinal Yedekleme ve Geri Y�kleme Komutlar�

-- SampleDB i�in Tam Yedekleme
-- SampleDB veritaban�n�n tam yede�ini belirtilen dosya yoluna al�r.
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Full Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB i�in Fark Yedekleme
-- SampleDB veritaban�nda tam yedekten sonra de�i�en verilerin fark yede�ini al�r.
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_DiffBackup.bak'
WITH DIFFERENTIAL,
     NOFORMAT, NOINIT,
     NAME = N'SampleDB-Differential Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

--Veritaban�n�n Kurtarma Modelini FULL Olarak De�i�tirme:
ALTER DATABASE SampleDB SET RECOVERY FULL;
GO

-- Tam Yedekleme Yapma:
BACKUP DATABASE SampleDB
TO DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Full Database Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB i�in Art�k (Transaction Log) Yedekleme
-- SampleDB veritaban�n�n transaction log'lar�n� yedekler, veri de�i�ikliklerinin kayd�n� tutar.
BACKUP LOG SampleDB
TO DISK = N'C:\Backup\SampleDB_LogBackup.trn'
WITH NOFORMAT, NOINIT,
     NAME = N'SampleDB-Transaction Log Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

-- SampleDB i�in Point-in-Time Restore Senaryosu

-- Tek Kullan�c� Moduna Al
-- Veritaban�n� tek kullan�c� moduna al�r, t�m aktif ba�lant�lar� keser.
USE master
ALTER DATABASE SampleDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Transaction Log Yede�i Alma (Log kuyru�unu yedekler)
-- Veritaban�n�n log kuyru�unu yedekler, mevcut loglar� korur.
BACKUP LOG SampleDB
TO DISK = N'C:\Backup\SampleDB_TailLogBackup.trn'
WITH NORECOVERY;
GO

-- Full Backup Geri Y�kle (NORECOVERY)
-- Tam yede�i geri y�kler, ancak i�lemi tamamlamaz, sonraki yedeklerin uygulanmas� i�in bekler.
RESTORE DATABASE SampleDB
FROM DISK = N'C:\Backup\SampleDB_FullBackup.bak'
WITH NORECOVERY;
GO

-- Fark Yede�i Geri Y�kle (Varsa, NORECOVERY)
-- Fark yede�ini geri y�kler, yine i�lemi tamamlamaz, log yede�i i�in bekler.
RESTORE DATABASE SampleDB
FROM DISK = N'C:\Backup\SampleDB_DiffBackup.bak'
WITH NORECOVERY;
GO

-- Log Yede�i Geri Y�kle (Belirli Zamana Kadar, RECOVERY)
-- Transaction log yede�ini belirlenen zamana kadar geri y�kler ve i�lemi tamamlar (veritaban� a��l�r).
RESTORE LOG SampleDB
FROM DISK = N'C:\Backup\SampleDB_LogBackup.trn'
WITH STOPAT = '2025-05-26T21:15:42.500',
     RECOVERY;
GO

--Veritaban�n� �ok Kullan�c� Moduna Geri Alma
ALTER DATABASE SampleDB SET MULTI_USER;
GO

--Geri y�klenen verileri kontrol et: Employees tablosundaki verileri g�r�nt�le
SELECT * FROM Employees;

--Veritaban�ndaki t�m kullan�c� tablolar�n� listele
SELECT name 
FROM sys.tables;

--Tam yedek dosyas�n�n i�erdi�i dosyalar� ve detaylar�n� listele
RESTORE FILELISTONLY 
FROM DISK = 'C:\Backup\SampleDB_FullBackup.bak';

--Log yedek dosyas�n�n ba�l�k bilgilerini kontrol et
RESTORE HEADERONLY 
FROM DISK = 'C:\Backup\SampleDB_LogBackup.trn';

--Geri y�kleme i�lemi s�ras�nda %10'luk ilerleme g�stergesiyle takip et 
RESTORE DATABASE SampleDB
FROM DISK = 'C:\Backup\SampleDB_FullBackup.bak'
WITH NORECOVERY, STATS = 10;

;