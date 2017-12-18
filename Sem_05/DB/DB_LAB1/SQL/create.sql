CREATE DATABASE Supply
GO

USE Supply

/*�������� ������� ��������� Shops*/
CREATE TABLE [dbo].[Shops](
	[ShopNo] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[HouseNo] [int] NOT NULL
)

/*�������� ������� ������� Storages*/
CREATE TABLE [dbo].[Storages](
	[StorageNo] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Street] [nvarchar](50) NOT NULL,
	[HouseNo] [int] NOT NULL,
	[Type] [char](20) NULL
)

/*�������� ������� ����� Wear*/
CREATE TABLE [dbo].[Wear](
	[WearNo] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](20) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Material] [nvarchar](50) NOT NULL,
	[Size] [int] NOT NULL,
	[Color] [nvarchar](50) NULL
)

/*�������� �������� �������*/
CREATE TABLE [dbo].[Supply](
	[ShopNo] [int] NOT NULL,
	[WearNo] [int] NOT NULL,
	[StorageNo] [int] NOT NULL,
	[Count] [int] NULL
)
GO

