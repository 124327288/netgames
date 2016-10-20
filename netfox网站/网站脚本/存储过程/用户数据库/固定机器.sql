

USE [QPGameUserDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_MoorMachine]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_MoorMachine]
GO

CREATE PROCEDURE [GSP_GP_MoorMachine]
	@dwUserID INT,
	@strProtectAnsw NVARCHAR(50),	
	@dwMoorMachine TINYINT
WITH ENCRYPTION AS

DECLARE @answ NVARCHAR(50)
DECLARE @PassWordCode NVARCHAR(50)
DECLARE @Nullity BIT

BEGIN
	SELECT @Nullity=Nullity, @answ=C_PROTECTANSW,@PassWordCode=PassWordCode FROM AccountsInfo WHERE UserID=@dwUserID

	IF @Nullity=1
	BEGIN
		SELECT '错误信息:您的帐号已经被冻结!'
		return 2
	END

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

	UPDATE AccountsInfo SET MoorMachine=@dwMoorMachine	WHERE UserID=@dwUserID

	IF @dwMoorMachine>0	
		SELECT '成功信息:申请固定机器成功!'
	ELSE
		SELECT '成功信息:撤销固定机器成功!'
	
END
return 0
go