

USE [QPServerInfoDB]
GO

ALTER TABLE [dbo].[GameKindItem] ADD	
	[GzUrl] [nvarchar](512) NOT NULL CONSTRAINT [DF_GameKindItem_GzUrl]  DEFAULT (N'')
GO