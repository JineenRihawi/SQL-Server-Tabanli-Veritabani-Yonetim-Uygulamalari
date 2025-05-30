CREATE DATABASE OrnekDB;
GO



USE OrnekDB;
GO



CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50),
    Soyad NVARCHAR(50),
    Email NVARCHAR(100)
);
GO




INSERT INTO Kullanicilar (Ad, Soyad, Email)
VALUES 
('Ahmet', 'Yýlmaz', 'ahmet.yilmaz@example.com'),
('Ayþe', 'Demir', 'ayse.demir@example.com'),
('Mehmet', 'Kaya', 'mehmet.kaya@example.com');
GO
BACKUP DATABASE OrnekDB
TO DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak'
WITH FORMAT,
     MEDIANAME = 'OrnekDBYedekMedya',
     NAME = 'OrnekDB Tam Yedek';



RESTORE HEADERONLY 
FROM DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak';

BACKUP DATABASE OrnekDB
TO DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak'
WITH INIT;

SELECT @@SERVERNAME AS SunucuAdi;

RESTORE HEADERONLY 
FROM DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak';


RESTORE FILELISTONLY 
FROM DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak';


IF EXISTS (SELECT name FROM sys.databases WHERE name = 'OrnekDB_Yedek')
BEGIN
    ALTER DATABASE OrnekDB_Yedek SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE OrnekDB_Yedek;
END
GO

-- Yedeði yeni veritabaný olarak geri yükle
RESTORE DATABASE OrnekDB_Yedek
FROM DISK = 'C:\SQLYedekler\OrnekDB_Yedek.bak'
WITH 
    MOVE 'OrnekDB' TO 'C:\SQLYedekler\OrnekDB_Yedek.mdf',
    MOVE 'OrnekDB_log' TO 'C:\SQLYedekler\OrnekDB_Yedek_log.ldf',
    REPLACE;
