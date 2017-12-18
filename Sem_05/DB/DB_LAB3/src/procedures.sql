use Supply
GO

-- 1. �������� ��������� � �����������--
DROP PROCEDURE SupplyInfo
GO

CREATE PROCEDURE dbo.SupplyInfo (@MinCount int)
AS
SELECT s.WearNo, s.ShopNo, s.StorageNo, w.[Type], w.[Color], st.[Type] as 'Type of storage', [Count]
FROM Supply AS s
			INNER JOIN Wear as w ON s.WearNo = w.WearNo
			INNER JOIN Shops as sh ON sh.ShopNo = s.ShopNo
			INNER JOIN Storages as st ON st.StorageNo = s.StorageNo
WHERE s.[Count] >= @MinCount
ORDER BY [Count]
GO

EXECUTE dbo.SupplyInfo 50
GO

----------------------------------------------------------------------------------------------
--2. �������� ��������� � ����������� OTB --
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
CREATE PROCEDURE dbo.BonusWear
AS
WITH BonusTable(WearBonus, WearNo, [Type], Material, Level)
AS
(
	SELECT w.BonusNo, w.WearNo, w.[Type], w.Material, 0 AS Level
	FROM Wear3 AS w
	WHERE BonusNo IS NULL
	UNION ALL

	SELECT w.BonusNo, w.WearNo, w.[Type], w.Material, Level + 1
	FROM Wear3 AS w INNER JOIN BonusTable AS b ON w.BonusNo = b.WearNo
)
SELECT WearBonus, WearNo, [Type], Material, Level
FROM BonusTable 
ORDER BY Level
GO

--DROP PROCEDURE BonusWear

EXECUTE dbo.BonusWear


----------------------------------------------------------------------------------------------
--3. �������� ��������� � �������� --
DROP PROCEDURE ViewSupplyInfo
GO

CREATE PROCEDURE dbo.ViewSupplyInfo
AS
BEGIN
	DECLARE @Num int = 1, @WearType nvarchar(50), @WearColor nvarchar(50), @WearCount int, @StNo int, @ShNo int;
	DECLARE SupCursor CURSOR FOR
	SELECT w.[Type], w.Color, s.[Count], s.StorageNo, s.ShopNo
	FROM Supply AS s INNER JOIN Wear as w ON s.WearNo = w.WearNo
	WHERE [Count] > 50
	ORDER BY [Count] DESC
	
	PRINT '���������� � ������� ���������:'
	OPEN SupCursor
	FETCH NEXT FROM SupCursor INTO @WearType,  @WearColor, @WearCount, @StNo, @ShNo 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT '�������� �' + CAST(@Num as varchar) + ': ' + '�����: ' + @WearType + '. ����: ' + @WearColor + '. � ����������: ' +
			+ CAST(@WearCount as varchar) + ' ��. �� ������ �' + CAST(@StNo as varchar)  + ' � ������� �' +CAST(@ShNo as varchar) + ';'
		FETCH NEXT FROM SupCursor INTO @WearType,  @WearColor, @WearCount, @StNo, @ShNo
		SELECT @Num = @Num + 1 
	END;
	CLOSE SupCursor;
	DEALLOCATE SupCursor;
END;
GO

EXECUTE dbo.ViewSupplyInfo
GO
----------------------------------------------------------------------------------------------
--4. �������� ��������� ������� � ����������. ������� 13--
/*������� �������� ��������� � �������� ����������, ������� ������� ������ ���� � ����������
���� ��������� SQL ������� ������������ (������� ���� 'FN') � ������� ���� ������. 
����� ������� ��� ���������� �� ��������. ����� � ������ ���������� ������ ����������
� ���� ������. �������� �������� ���������� ���������� ��������� �������.

������������.
1. ���������� �� �������� ���� ������ ����� ������� �� ���������� ������������� sys.objects.
2. ���������� � ���������� �������� ����� ������� �� ���������� ������������� sys.parameters. */

DROP PROCEDURE ScalarFuncInfo
GO

CREATE PROCEDURE dbo.ScalarFuncInfo @Count int OUTPUT
AS
BEGIN 
	
	SELECT @Count = 0
	DECLARE @Name varchar(50), @Type varchar(10), @List varchar(50)
	DECLARE FNCursor CURSOR FOR
	SELECT name, type
	FROM sys.objects

	OPEN FNCursor
	FETCH NEXT FROM FNCursor INTO @Name, @Type
	while @@FETCH_STATUS = 0
	BEGIN
		if(@type = 'FN')
		BEGIN
			SET @List = ''
			
			/* ����� ���������� ��� ������� �������*/
			SELECT @List = @List  + p.name + '  '
			FROM sys.objects AS o INNER JOIN sys.parameters AS p ON o.object_id = p.object_id
			WHERE o.object_id = OBJECT_ID(@Name)
			
			/*���� ���� ���������, ������� ���������� � �������*/
			if(@List > '')
			BEGIN
				PRINT '������� ' + @Name + ' c �����������:' + @List 
			END
			
			SELECT @COUNT = @COUNT + 1
		END

		FETCH NEXT FROM FNCursor INTO @Name, @Type
	END
	
	CLOSE FNCursor
	DEALLOCATE FNCursor
END;
GO

/*������� ������� ��� ������������ */
CREATE FUNCTION dbo.TestFunc ()
RETURNS int
WITH RETURNS NULL ON NULL INPUT
AS BEGIN
	RETURN 1
END; 
GO

CREATE FUNCTION dbo.TestFunc2 (@PARAM1 int, @PARAM2 int, @PARAM3 int)
RETURNS int
WITH RETURNS NULL ON NULL INPUT
AS BEGIN
	RETURN @PARAM1+@PARAM2+@PARAM3
END;
GO

DROP FUNCTION TestFunc
DROP FUNCTION TestFunc2

/* ��������� ��������*/
DECLARE @Count int
PRINT 'C�������� ���������������� ������� � �����������:'
EXECUTE dbo.ScalarFuncInfo @Count OUTPUT
PRINT '���������� ������� ���� "FN": ' + CAST(@Count as varchar)

