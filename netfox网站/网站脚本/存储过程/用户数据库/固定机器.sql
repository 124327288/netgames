

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
		SELECT '������Ϣ:�����ʺ��Ѿ�������!'
		return 2
	END

	IF @PassWordCode IS NULL OR @PassWordCode=''
	BEGIN
		SELECT '������Ϣ:����û���������뱣��!'
		return 3
	END

	IF @answ<>@strProtectAnsw 
	BEGIN
		SELECT '������Ϣ:��������ܱ��𰸴���!'
		return 1
	END

	UPDATE AccountsInfo SET MoorMachine=@dwMoorMachine	WHERE UserID=@dwUserID

	IF @dwMoorMachine>0	
		SELECT '�ɹ���Ϣ:����̶������ɹ�!'
	ELSE
		SELECT '�ɹ���Ϣ:�����̶������ɹ�!'
	
END
return 0
go