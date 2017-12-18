USE Supply

--1. ������������� ��������� ���������--
SELECT *
FROM Wear
WHERE Size > 40
ORDER BY Size DESC

--2. �������� BETWEEN --
SELECT Name, Street, HouseNo
FROM Shops
WHERE City = '������' AND Street = '��������' AND HouseNo BETWEEN '1' AND '70'
ORDER BY HouseNo ASC

--3. �������� LIKE--
SELECT [Type], Country, Material, Size, Color, Supply.ShopNo, Supply.StorageNo, Supply.[Count]
FROM Wear JOIN Supply ON Wear.WearNo = Supply.WearNo
WHERE Color LIKE '%����%' 

--4. �������� IN � ��������� �����������--
SELECT *
FROM Wear As w 
WHERE w.WearNo IN
	(
		SELECT WearNo
		FROM Supply
		WHERE Count > 90
	)	

--5. �������� EXISTS � ��������� �����������--
SELECT *
FROM Supply AS otable
WHERE EXISTS
	 (
		SELECT *
		FROM Storages AS itable
		WHERE [Type] = 'A' and itable.StorageNo = otable.StorageNo
	 )
ORDER BY StorageNo

--6. �������� ��������� � ���������--
SELECT *
FROM Storages
WHERE HouseNo > ALL
	(
		SELECT HouseNo
		FROM Storages
		WHERE City = '������'
	) 


--7.���������� SELECT, ������������ ���������� ������� � ���������� ��������. --
SELECT AVG(Size) AS 'Average Size', MAX(Size) AS 'Max Size',
SUM(Size)/ COUNT(Size) AS 'Calculated Average'
FROM Wear
Where [type] = '������' and Color = '�����'

-- 8.���������� SELECT, ������������ ��������� ���������� � ���������� ��������.--
SELECT *, 
	(
		SELECT Avg(Size)
		FROM Wear
		WHERE [type] =  
			( SELECT [type]
				FROM Wear
				WHERE Wear.WearNo = Supply.WearNo
			)

	) As 'Average Size'
FROM Supply
WHERE [Count] > 70		

--9.���������� SELECT, ������������ ������� ��������� CASE. --
SELECT Name, COUNT(Name) AS 'Count of shops',
	CASE Name
		WHEN 'Mexx' THEN 'Good wear'
		WHEN '���' THEN 'Worse shop'
		WHEN 'Uniclo' THEN '������������ ����� � ������'
 	END AS 'Note'
FROM Shops
GROUP BY Name
ORDER BY [Note] DESC

--10. ��������� ��������� CASE--
SELECT [Type], Country, Material, Size,
	CASE
		WHEN Size <= 42 THEN 'S'
		WHEN Size BETWEEN 43 AND 46 THEN 'M'
		WHEN Size BETWEEN 47 AND 50 THEN 'L'
		ELSE 'XL'
	END AS NewSize
FROM Wear
ORDER BY Size

--11.�������� ����� ��������� ��������� ������� �� ��������������� ������ ������ ���������� SELECT. --
SELECT  City, COUNT(Street) AS 'Count of Storages', MIN([Type]) AS 'Best Type', MAX([type]) AS 'Worst Type'
INTO CitysStoragesInfo
FROM Storages
WHERE [Type] IS NOT NULL
GROUP BY City
ORDER BY [Count of Storages] DESC

/*
SELECT *
FROM CitysStoragesInfo

DROP TABLE CitysStoragesInfo
*/


--12.���������� SELECT, ������������ ��������� ��������������� ���������� � �������� ����������� ������ � ����������� FROM.--
--13.���������� SELECT, ������������ ��������� ���������� � ������� ����������� 3.--
SELECT *
FROM Supply
WHERE StorageNo IN
(
	SELECT StorageNo
	FROM Storages
	WHERE City IN
	(
		Select City
		FROM (
				SELECT TOP 5 City, COUNT(City) As 'Count'
				FROM Shops
				WHERE Name = 'InCity'
				GROUP BY City
		    	ORDER BY [Count] DESC
			 ) AS CityShop
	)
)

SELECT Name, City
FROM Shops
ORDER BY Name

--14.���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY, �� ��� ����������� HAVING.--
SELECT  City, Street, COUNT(Street) AS 'Count of Storages', MIN([Type]) AS 'Best Type', MAX([type]) AS 'Worst Type'
FROM Storages
WHERE [Type] IS NOT NULL
GROUP BY City, Street
ORDER BY City, [Count of Storages]

--15.���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY �  ����������� HAVING.--
SELECT  City, Street, COUNT(Street) AS 'Count of Storages', MIN([Type]) AS 'Best Type', MAX([type]) AS 'Worst Type'
FROM Storages
WHERE [Type] IS NOT NULL
GROUP BY City, Street
HAVING MAX([Type]) < 'D'
ORDER BY City, [Count of Storages]

--16. ������������ ���������� INSERT--
INSERT Storages (Name, City, Street, HouseNo) 
VALUES ('CoCoCompany', '������', '��������', 11)

SELECT *
FROM Storages

--17.	������������� ���������� INSERT, ����������� ������� � ������� ��������������� ������ ������ ���������� ����������.-- 
INSERT Storages (Name, City, Street, HouseNo)
SELECT ('CoCoCompany'), City, Street, HouseNo
FROM Shops
WHERE City = '������' and Name = 'Mexx'

 --18. ������� ���������� UPDATE --
 UPDATE Storages
 SET [Type] = 'C'
 WHERE [Type] is NULL

 --19.���������� UPDATE �� ��������� ����������� � ����������� SET. --
UPDATE Shops
SET HouseNo = 
	(
		SELECT MIN(HouseNo)
		FROM Shops
		WHERE City = '���������' AND Name = 'Mexx' AND Street = '��������'
	)
WHERE City = '���������' AND Name = 'Mexx' AND Street = '��������'


SELECT *
FROM Shops
WHERE Name = 'Mexx' And City = '���������' AND Street = '��������'

 --20. ������� ���������� delete--
 DELETE Storages
 WHERE City = '������'

 DELETE Storages
 WHERE StorageNo > 1000

 --21.���������� DELETE � ��������� ��������������� ����������� � ����������� WHERE.--
 DELETE FROM Supply
 WHERE StorageNo IN
	(
		Select DISTINCT Storages.StorageNo
		FROM Storages JOIN Supply ON Storages.StorageNo = Supply.StorageNo
		WHERE City = '���������'
	)
GO

 --22.���������� SELECT, ������������ ������� ���������� ��������� ���������.--
 WITH NewWear ([Type], CountWear)
 AS
 (
	SELECT [Type], Count(*) As CountWear
	FROM Wear
	WHERE Color = '������'
	GROUP BY [Type]
 )
 SELECT AVG(CountWear) AS '������� ���������� ����� ������� �����'
 FROM NewWear

 --23.���������� SELECT, ������������ ����������� ���������� ��������� ���������.--

 /*�������� ������� ����� Wear3*/
DROP TABLE Wear3
 
CREATE TABLE [dbo].[Wear3](
	[WearNo] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](20) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Material] [nvarchar](50) NOT NULL,
	[BonusNo] [int] NULL  /* ����� ����, � ������� ���� � �������*/
	CONSTRAINT PK_Wear3 PRIMARY KEY CLUSTERED (WearNo ASC) 
)
GO

INSERT Wear3 ([Type], Country, Material, BonusNo)
VALUES
('������', '������', '������', NULL),
('������', '������', '���������', 1),
('�����', '�������', '�����', 2),
('��������', '�����', '�����', 2),
('�������', '������', '������', 4),
('�����', '�������', '������', 2),
('�������', '�������', '�����', 3),
('�������', '�������', '������', 3)
GO

-- ����������� ���
WITH BonusTable(WearBonus, WearNo, [Type], Material, Level)
AS
(
-- ����������� ������������� ��������
SELECT w.BonusNo, w.WearNo, w.[Type], w.Material, 0 AS Level
FROM Wear3 AS w
WHERE BonusNo IS NULL
UNION ALL
-- ����������� ������������ ��������
SELECT w.BonusNo, w.WearNo, w.[Type], w.Material, Level + 1
FROM Wear3 AS w INNER JOIN BonusTable AS b ON w.BonusNo = b.WearNo
)
-- ����������, ������������ ���
SELECT WearBonus, WearNo, [Type], Material, Level
FROM BonusTable ;
GO

SELECT *
FROM Wear3


 --24. ������������� �������� PIVOT--

SELECT [Type], [52], [50], [48]
FROM 
(
	SELECT [Type], Size
	FROM Wear
) as SourceT
PIVOT 
(
	Count(Size) for Size in ([52], [50], [48])
) AS MaxLargeTable


 --25. ���������� MERGE--
 -- ������� ������� Wear2 � �������������� �� � �������� Wear1
SELECT *
INTO Wear2
FROM Wear
GO

--DROP TABLE Wear2

SELECT *
FROM Wear2

UPDATE Wear2
SET Color = '����'
WHERE WearNo BETWEEN 950 AND 1000

INSERT Wear2 ([Type], Country, Material, Size, Color)
VALUES
('������', '������', '�����', 52, '�����'),
('������', '������', '�����', 52, '�������')

MERGE Wear2
USING Wear
ON (Wear2.WearNo = Wear.WearNo)
WHEN MATCHED  THEN
	UPDATE SET Wear2.Color = Wear.Color
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;  /*������� ������ �� ������� ��� ������������ ������ */

DROP TABLE Wear2


