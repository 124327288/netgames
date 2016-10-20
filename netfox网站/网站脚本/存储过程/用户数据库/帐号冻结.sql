

USE [QPGameUserDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_StunDown]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_StunDown]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ReStunDown]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ReStunDown]
GO

CREATE PROCEDURE [GSP_GP_StunDown]
	@dwUserID INT,
	@strProtectAnsw NVARCHAR(50),	
	@bitStunDown BIT
WITH ENCRYPTION AS

DECLARE @answ NVARCHAR(50)
DECLARE @PassWordCode NVARCHAR(50)

BEGIN
	SELECT @answ=C_PROTECTANSW,@PassWordCode=PassWordCode FROM AccountsInfo WHERE UserID=@dwUserID

	IF @PassWordCode IS NULL OR @PassWordCode=''
	BEGIN
		SELECT '错误信息:您还没有申请密码保护!'
		return 3
	END

	IF @answ<>@strProtectAnsw 
	BEGIN
		SELECT '错误信息:您输入的密保答案错误!'
		return 1
	END

	UPDATE AccountsInfo SET StunDown=@bitStunDown	WHERE UserID=@dwUserID

	IF @bitStunDown=0	
		SELECT '成功信息:解冻帐号成功!'
	ELSE
		SELECT '成功信息:冻结帐号成功!'
	
END
return 0
go

CREATE PROCEDURE [GSP_GP_ReStunDown]
	@strAccounts NVARCHAR(31),
	@strLogonPass NCHAR(32), 
	@strProtectAnsw NVARCHAR(50),
	@strPassWordCode NVARCHAR(50),	
	@bitStunDown BIT
WITH ENCRYPTION AS

DECLARE @LogonPass NCHAR(32)
DECLARE @answ NVARCHAR(50)
DECLARE @PassWordCode NVARCHAR(50)

BEGIN
	SELECT @LogonPass=LogonPass,@answ=C_PROTECTANSW,@PassWordCode=PassWordCode FROM AccountsInfo WHERE Accounts=@strAccounts

	IF @LogonPass<>@strLogonPass
	BEGIN
		SELECT '错误信息:您输入的登陆密码错误!'
		return 4
	END

	IF @PassWordCode IS NULL OR @PassWordCode=''
	BEGIN
		SELECT '错误信息:您还没有申请密码保护!'
		return 3
	END
	ELSE IF @PassWordCode<>@strPassWordCode
	BEGIN
		SELECT '错误信息:您输入的安全码错误!'
		return 5
	END

	IF @answ<>@strProtectAnsw 
	BEGIN
		SELECT '错误信息:您输入的密保答案错误!'
		return 1
	END

	UPDATE AccountsInfo SET StunDown=@bitStunDown	WHERE Accounts=@strAccounts

	IF @bitStunDown=0	
		SELECT '成功信息:解冻帐号成功!'
	ELSE
		SELECT '成功信息:冻结帐号成功!'
	
END
return 0
go