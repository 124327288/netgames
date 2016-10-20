

USE [QPTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Web_FilledLivCard]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Web_FilledLivCard]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [dbo].[Web_FilledLivCard]
	@strCardNo   VARCHAR(31),
	@strCardPass VARCHAR(32),
	@dwUserID    INT
WITH ENCRYPTION AS

-- ������Ϣ
DECLARE @ACardTypeID INT
DECLARE @GrantScore INT
DECLARE @OverDate INT
DECLARE @IsPresent BIT
DECLARE @MemberOrder INT
DECLARE @Accounts VARCHAR(31)

-- ������Ϣ
DECLARE @CardID INT
DECLARE @CardNo VARCHAR(31)
DECLARE @CardPass VARCHAR(32)
DECLARE @CardTypeID INT
DECLARE @Nullity BIT
DECLARE @UserID INT

-- ��Ա����
DECLARE @CurMemberOrder INT
DECLARE @MaxMemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @MemberCount INT
DECLARE @UpMemberOverDate DATETIME

BEGIN
	-- ��ҷ���
	IF EXISTS (SELECT UserID FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID)
	BEGIN
		SELECT [ErrorDescribe]= '������Ϣ����Ŀǰ��������Ϸ����,���ܽ������в�����'
		RETURN 1
	END

	-- �û���ѯ
	SELECT  @Accounts=Accounts FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- ������֤
	SELECT @CardID=[ID],@CardNo=CardNo,@CardPass=CardPass,@CardTypeID=CardTypeID,@Nullity=Nullity,@UserID=UserID
	FROM GameCardNoInfo(NOLOCK) WHERE CardNo=@strCardNo

	IF @CardID IS NULL
	BEGIN
		SELECT [ErrorDescribe]= '������Ϣ��������Ŀ��ź����벻��ȷ��'
		RETURN 1
	END

	IF (@UserID IS NOT NULL AND @UserID >0) OR  @Nullity<>0
	BEGIN
		SELECT [ErrorDescribe]= '������Ϣ���ÿ����Ѿ�����ֵ��'
		RETURN 1
	END

	IF @CardPass<>@strCardPass
	BEGIN
		SELECT [ErrorDescribe]= '������Ϣ��������Ŀ��Ż��������'
		RETURN 1
	END

	-- ������֤
	SELECT @ACardTypeID=CardID,@GrantScore=Score,@OverDate=OverDate,@IsPresent=IsPresent,@MemberOrder=MemberOrder
	FROM GameCardTypeInfo(NOLOCK) WHERE CardID=@CardTypeID

	IF @ACardTypeID IS NULL
	BEGIN
		SELECT [ErrorDescribe]= '������Ϣ��������Ŀ��Ż��������'
		RETURN 1
	END

	-- ����ʹ��
	UPDATE GameCardNoInfo SET UseDate=GETDATE(),UserID=@dwUserID,Accounts=@Accounts,Nullity=1
	WHERE [ID]=@CardID 

	-- ���ӽ��
	UPDATE GameScoreInfo SET Score=Score+@GrantScore WHERE UserID=@dwUserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT GameScoreInfo ([UserID],[Score],[RegisterIP],[LastLogonIP])
		VALUES (@dwUserID,@GrantScore,'127.0.0.1','127.0.0.1')
	END

	-- ���ӻ�Ա
	IF @IsPresent<>0
	BEGIN
		---------------------------== Ϊ�û��󶨻�Ա��Ϣ begin ==-----------------------------
		SET @CurMemberOrder=@MemberOrder

		--------------------------------------------------------------
		-- ��������
		SELECT @MemberCount=COUNT(UserID)
		FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID
		
		-- �״ι���
		IF @MemberCount IS NULL OR @MemberCount<=0
		BEGIN
			INSERT QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo (UserID,MemberOrder,MemberOverDate)
			VALUES (@dwUserID,@CurMemberOrder,DATEADD(dd, @OverDate, GETDATE()))
		END
		ELSE 
		BEGIN	
			-- �ϼ���Ա
			SELECT @UpMemberOverDate=MAX(MemberOverDate)
			FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID AND MemberOrder>=@CurMemberOrder		

			-- ���ϼ���Ա
			IF @UpMemberOverDate IS NULL SET @UpMemberOverDate=GETDATE()	 
			IF @MemberOverDate IS NULL SET @MemberOverDate=GETDATE()
			
			-- �ϼ���Ա����ʱ��С
			IF @UpMemberOverDate<@MemberOverDate SET @UpMemberOverDate=@MemberOverDate
			
			-- ����ͬ�����Ա
			UPDATE QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo SET MemberOverDate=DATEADD(dd, @OverDate, @UpMemberOverDate)
			WHERE UserID=@dwUserID AND MemberOrder=@CurMemberOrder

			IF @@ROWCOUNT=0
			BEGIN
				INSERT QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo (UserID,MemberOrder,MemberOverDate)
				VALUES (@dwUserID,@CurMemberOrder,DATEADD(dd, @OverDate, GETDATE()))
			END		

			-- �����¼���Ա
			UPDATE QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo SET MemberOverDate=DATEADD(dd, @OverDate, MemberOverDate)
			WHERE UserID=@dwUserID AND MemberOrder<@CurMemberOrder
		END		
		--------------------------------------------------------------

		-- �󶨻�Ա,(��Ա�������л�ʱ��)
		SELECT @MaxMemberOrder=MAX(MemberOrder),@MemberOverDate=MAX(MemberOverDate)
		FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID	

		-- ���ӻ�Ա��Ϣ
		UPDATE QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo
		SET MemberOrder=@MaxMemberOrder,MemberOverDate=@MemberOverDate
		WHERE UserID=@dwUserID
		---------------------------== Ϊ�û��󶨻�Ա��Ϣ end ==-------------------------------
	END

	SELECT [ErrorDescribe]= '�ɹ���Ϣ����ֵ�ɹ���',@MaxMemberOrder AS MemberOrder

END
RETURN 0
GO