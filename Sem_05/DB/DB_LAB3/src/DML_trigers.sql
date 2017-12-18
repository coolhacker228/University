USE Supply
GO

--1. ������� AFTER --
/*�������� ������ �� ������� �������� ��� �������� ������ � ���� �� ������� ����� */
DROP TRIGGER AfterDeleteWear
DROP TABLE Supply2
DROP TABLE Wear2
GO

CREATE TRIGGER AfterDeleteWear
ON Wear2
AFTER DELETE
AS
BEGIN
	DELETE FROM Supply2
	WHERE WearNo NOT IN 
		(
			SELECT WearNo
			FROM Wear2
		)
END;
GO

SELECT *
INTO Wear2
FROM Wear

SELECT *
INTO Supply2
FROM Supply

SELECT *
FROM Supply2
WHERE WearNo = 2


/* ��������� ������ �������� */ 
DELETE FROM Wear2 WHERE WearNo = 2
DELETE FROM Wear2 WHERE WearNo = 6

SELECT *
FROM Supply2
WHERE WearNo = 2

SELECT *
FROM Supply2
ORDER BY WearNo

--2. ������� INSTEAD OF --
DROP TRIGGER NoDelete
GO

CREATE TRIGGER NoDelete ON Supply
INSTEAD OF DELETE
AS
BEGIN
	RAISERROR('�������� �� ������� �������� ���������!',0,0)
END;

DELETE 
FROM Supply
WHERE WearNo = 2

SELECT *
FROM Supply