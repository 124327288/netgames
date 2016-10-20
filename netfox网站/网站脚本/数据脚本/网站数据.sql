

use News
GO

if exists (select * from sysobjects where id = OBJECT_ID('[admin]') and OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [admin]

CREATE TABLE [admin] (
[id] [int]  IDENTITY (1, 1)  NOT NULL,
[admin] [nvarchar]  (100) NULL,
[password] [nvarchar]  (100) NULL,
[classcode] [nvarchar]  (100) NULL,
[classname] [nvarchar]  (100) NULL)

ALTER TABLE [admin] WITH NOCHECK ADD  CONSTRAINT [PK_admin] PRIMARY KEY  NONCLUSTERED ( [id] )SET IDENTITY_INSERT [admin] ON

INSERT [admin] ([id],[admin],[password],[classcode],[classname]) VALUES ( 1,'admin','123456','1','超级管理员')

SET IDENTITY_INSERT [admin] OFF



if exists (select * from sysobjects where id = OBJECT_ID('[class]') and OBJECTPROPERTY(id, 'IsUserTable') = 1) 
DROP TABLE [class]

CREATE TABLE [class] (
[id] [int]  IDENTITY (1, 1)  NOT NULL,
[classcode] [nvarchar]  (100) NULL,
[classname] [nvarchar]  (100) NULL,
[classpic] [nvarchar]  (100) NULL)

ALTER TABLE [class] WITH NOCHECK ADD  CONSTRAINT [PK_class] PRIMARY KEY  NONCLUSTERED ( [id] )SET IDENTITY_INSERT [class] ON

INSERT [class] ([id],[classcode],[classname]) VALUES ( 1,'100','热点新闻')
INSERT [class] ([id],[classcode],[classname]) VALUES ( 2,'101','游戏公告')

SET IDENTITY_INSERT [class] OFF

