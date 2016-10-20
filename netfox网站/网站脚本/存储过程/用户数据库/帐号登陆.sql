

USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_IsLogin]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_IsLogin]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [dbo].[GSP_GP_IsLogin]
	@Accounts 	[varchar](32),
	@PassWord1 	[char](32),
	@PassWord2  [char](32),
	@RegisterIP [varchar](15)	
WITH ENCRYPTION AS
BEGIN

	IF (SELECT OlePassWord FROM AccountsInfo WHERE Accounts=@Accounts)=@PassWord2
	BEGIN
		SELECT 1
		Update AccountsInfo Set LogonPass=@PassWord1,IsCheckPassWord=1,RegisterIP=@RegisterIP,LastLogonIP=@RegisterIP Where Accounts=@Accounts
		RETURN
	END
	Else
		BEGIN
		SELECT 0
		End


END
return 0
go