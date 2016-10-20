

USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserReg]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserReg]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [dbo].[GSP_GP_UserReg]
	@Accounts   [varchar](32),
	@LogonPass  [char](32),
	@InsurePass [char](32),
	@Gender     [bit],
	@FaceID     [int],
	@RegisterIP [varchar](15),
	@Ncode		[nvarchar](50),
	@Nmail		[nvarchar](50),
	@Nadd		[nvarchar](50),
	@PassW		[nvarchar](50),
	@PassD		[nvarchar](50)

WITH ENCRYPTION AS
BEGIN

	DECLARE @UserID [Int]
	-- ��չ��Ϣ
	DECLARE @GameID INT
	DECLARE @ErrorDescribe AS NVARCHAR(128)
	IF EXISTS (SELECT UserID FROM AccountsInfo WHERE Accounts=@Accounts)
	BEGIN
		SELECT 0, '�û��Ѵ��ڣ��뻻��һ�û����ֳ����ٴ�ע�ᣡ'
		RETURN 1
	END

	INSERT INTO [AccountsInfo]( [Accounts],[RegAccounts],[LogonPass],[InsurePass],[Gender],[FaceID],[RegisterIP],[LastLogonIP],[C_IDNO],[C_ADDRESS],[C_EMAIL],[C_PROTECTQUES],[C_PROTECTANSW]) 	VALUES (@Accounts,@Accounts,@LogonPass,@InsurePass,@Gender,@FaceID,@RegisterIP,@RegisterIP,@Ncode,@Nadd,@Nmail,@PassW,@PassD)

	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@Accounts

	-- �����ʶ
	SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@UserID
	IF @GameID IS NULL 
	BEGIN
		SET @GameID=0
		SET @ErrorDescribe=N'�û�ע��ɹ�����δ�ɹ���ȡ��Ϸ ID ���룬ϵͳ�Ժ󽫸������䣡'
	END
	ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@UserID

	--Set @UserID=@@IDENTITY
	--INSERT INTO  WHTreasureDBServer.WHTreasureDB.dbo.GameScore(UserID) VALUES (@UserID)

	IF @@ERROR<>0
	BEGIN
		SELECT 0, '�û��Ѵ��ڣ��뻻��һ�û����ֳ����ٴ�ע�ᣡ'
		RETURN 2
	END
	Else
	BEGIN
		Select 1,'ע��ɹ�!', @GameID AS GameID
	End

END
return 0
go