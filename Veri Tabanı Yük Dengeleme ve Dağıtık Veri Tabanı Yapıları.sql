 -- Kaynak veritabaný
CREATE DATABASE ReplicationSourceDB; 
GO

-- Hedef veritabaný
CREATE DATABASE ReplicationTargetDB;  
GO

-- Kaynak veritabanýnda "ReplicatedTable" adlý tabloyu oluþtur
USE ReplicationSourceDB;
GO
CREATE TABLE ReplicatedTable (
    ID INT PRIMARY KEY,
    DataValue NVARCHAR(100),
    LastUpdated DATETIME DEFAULT GETDATE()
);
GO

-- Hedef veritabanýnda ayný yapýda "ReplicatedTable" oluþtur 
USE ReplicationTargetDB;
GO
CREATE TABLE ReplicatedTable (
    ID INT PRIMARY KEY,
    DataValue NVARCHAR(100),
    LastUpdated DATETIME
);
GO

-- Kaynak tabloya üç satýr örnek veri eklenir
USE ReplicationSourceDB;
GO
INSERT INTO ReplicatedTable (ID, DataValue)
VALUES 
(1, 'Deneme Veri 1'),
(2, 'Deneme Veri 2'),
(3, 'Deneme Veri 3');
GO

-- Hedef tabloya sadece kaynakta olup hedefte olmayan kayýtlar eklenir
USE ReplicationTargetDB;
GO
INSERT INTO ReplicatedTable (ID, DataValue, LastUpdated)
SELECT src.ID, src.DataValue, src.LastUpdated
FROM ReplicationSourceDB.dbo.ReplicatedTable src
LEFT JOIN ReplicationTargetDB.dbo.ReplicatedTable tgt
    ON src.ID = tgt.ID
WHERE tgt.ID IS NULL;
GO

-- Örneðin kaynak veritabaný yerine hedef kullanýlýr
SELECT * FROM ReplicationTargetDB.dbo.ReplicatedTable;
GO

-- Log tablosu oluþturulur; her istek burada kayýt altýna alýnacaktýr
USE ReplicationSourceDB;
GO
CREATE TABLE LoadBalancerLog (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    AccessTime DATETIME DEFAULT GETDATE(),
    ServerName NVARCHAR(50)
);
GO

-- Server1’e gelen istek örneði
INSERT INTO LoadBalancerLog (ServerName) VALUES ('Server1');

-- Server2’ye gelen istek örneði
INSERT INTO LoadBalancerLog (ServerName) VALUES ('Server2');

-- Log tablosu üzerinden yük daðýlýmý analiz edilir
SELECT ServerName, COUNT(*) AS RequestCount
FROM LoadBalancerLog
GROUP BY ServerName;
GO
