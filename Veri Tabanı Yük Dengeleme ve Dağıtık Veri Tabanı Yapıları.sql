 -- Kaynak veritaban�
CREATE DATABASE ReplicationSourceDB; 
GO

-- Hedef veritaban�
CREATE DATABASE ReplicationTargetDB;  
GO

-- Kaynak veritaban�nda "ReplicatedTable" adl� tabloyu olu�tur
USE ReplicationSourceDB;
GO
CREATE TABLE ReplicatedTable (
    ID INT PRIMARY KEY,
    DataValue NVARCHAR(100),
    LastUpdated DATETIME DEFAULT GETDATE()
);
GO

-- Hedef veritaban�nda ayn� yap�da "ReplicatedTable" olu�tur 
USE ReplicationTargetDB;
GO
CREATE TABLE ReplicatedTable (
    ID INT PRIMARY KEY,
    DataValue NVARCHAR(100),
    LastUpdated DATETIME
);
GO

-- Kaynak tabloya �� sat�r �rnek veri eklenir
USE ReplicationSourceDB;
GO
INSERT INTO ReplicatedTable (ID, DataValue)
VALUES 
(1, 'Deneme Veri 1'),
(2, 'Deneme Veri 2'),
(3, 'Deneme Veri 3');
GO

-- Hedef tabloya sadece kaynakta olup hedefte olmayan kay�tlar eklenir
USE ReplicationTargetDB;
GO
INSERT INTO ReplicatedTable (ID, DataValue, LastUpdated)
SELECT src.ID, src.DataValue, src.LastUpdated
FROM ReplicationSourceDB.dbo.ReplicatedTable src
LEFT JOIN ReplicationTargetDB.dbo.ReplicatedTable tgt
    ON src.ID = tgt.ID
WHERE tgt.ID IS NULL;
GO

-- �rne�in kaynak veritaban� yerine hedef kullan�l�r
SELECT * FROM ReplicationTargetDB.dbo.ReplicatedTable;
GO

-- Log tablosu olu�turulur; her istek burada kay�t alt�na al�nacakt�r
USE ReplicationSourceDB;
GO
CREATE TABLE LoadBalancerLog (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AccessTime DATETIME DEFAULT GETDATE(),
    ServerName NVARCHAR(50)
);
GO

-- Server1�e gelen istek �rne�i
INSERT INTO LoadBalancerLog (ServerName) VALUES ('Server1');

-- Server2�ye gelen istek �rne�i
INSERT INTO LoadBalancerLog (ServerName) VALUES ('Server2');

-- Log tablosu �zerinden y�k da��l�m� analiz edilir
SELECT ServerName, COUNT(*) AS RequestCount
FROM LoadBalancerLog
GROUP BY ServerName;
GO
