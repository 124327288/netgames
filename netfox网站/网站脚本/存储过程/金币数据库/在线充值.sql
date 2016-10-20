

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

-- 卡类信息
DECLARE @ACardTypeID INT
DECLARE @GrantScore INT
DECLARE @OverDate INT
DECLARE @IsPresent BIT
DECLARE @MemberOrder INT
DECLARE @Accounts VARCHAR(31)

-- 卡号信息
DECLARE @CardID INT
DECLARE @CardNo VARCHAR(31)
DECLARE @CardPass VARCHAR(32)
DECLARE @CardTypeID INT
DECLARE @Nullity BIT
DECLARE @UserID INT

-- 会员资料
DECLARE @CurMemberOrder INT
DECLARE @MaxMemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @MemberCount INT
DECLARE @UpMemberOverDate DATETIME

BEGIN
	-- 金币房间
	IF EXISTS (SELECT UserID FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID)
	BEGIN
		SELECT [ErrorDescribe]= '错误信息：您目前在银子游戏房间,不能进行银行操作！'
		RETURN 1
	END

	-- 用户查询
	SELECT  @Accounts=Accounts FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- 卡号验证
	SELECT @CardID=[ID],@CardNo=CardNo,@CardPass=CardPass,@CardTypeID=CardTypeID,@Nullity=Nullity,@UserID=UserID
	FROM GameCardNoInfo(NOLOCK) WHERE CardNo=@strCardNo

	IF @CardID IS NULL
	BEGIN
		SELECT [ErrorDescribe]= '错误信息：您输入的卡号和密码不正确！'
		RETURN 1
	END

	IF (@UserID IS NOT NULL AND @UserID >0) OR  @Nullity<>0
	BEGIN
		SELECT [ErrorDescribe]= '错误信息：该卡号已经被充值！'
		RETURN 1
	END

	IF @CardPass<>@strCardPass
	BEGIN
		SELECT [ErrorDescribe]= '错误信息：您输入的卡号或密码错误！'
		RETURN 1
	END

	-- 卡类验证
	SELECT @ACardTypeID=CardID,@GrantScore=Score,@OverDate=OverDate,@IsPresent=IsPresent,@MemberOrder=MemberOrder
	FROM GameCardTypeInfo(NOLOCK) WHERE CardID=@CardTypeID

	IF @ACardTypeID IS NULL
	BEGIN
		SELECT [ErrorDescribe]= '错误信息：您输入的卡号或密码错误！'
		RETURN 1
	END

	-- 卡被使用
	UPDATE GameCardNoInfo SET UseDate=GETDATE(),UserID=@dwUserID,Accounts=@Accounts,Nullity=1
	WHERE [ID]=@CardID 

	-- 附加金币
	UPDATE GameScoreInfo SET Score=Score+@GrantScore WHERE UserID=@dwUserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT GameScoreInfo ([UserID],[Score],[RegisterIP],[LastLogonIP])
		VALUES (@dwUserID,@GrantScore,'127.0.0.1','127.0.0.1')
	END

	-- 附加会员
	IF @IsPresent<>0
	BEGIN
		---------------------------== 为用户绑定会员信息 begin ==-----------------------------
		SET @CurMemberOrder=@MemberOrder

		--------------------------------------------------------------
		-- 期限推算
		SELECT @MemberCount=COUNT(UserID)
		FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID
		
		-- 首次购买
		IF @MemberCount IS NULL OR @MemberCount<=0
		BEGIN
			INSERT QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo (UserID,MemberOrder,MemberOverDate)
			VALUES (@dwUserID,@CurMemberOrder,DATEADD(dd, @OverDate, GETDATE()))
		END
		ELSE 
		BEGIN	
			-- 上级会员
			SELECT @UpMemberOverDate=MAX(MemberOverDate)
			FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID AND MemberOrder>=@CurMemberOrder		

			-- 无上级会员
			IF @UpMemberOverDate IS NULL SET @UpMemberOverDate=GETDATE()	 
			IF @MemberOverDate IS NULL SET @MemberOverDate=GETDATE()
			
			-- 上级会员过期时间小
			IF @UpMemberOverDate<@MemberOverDate SET @UpMemberOverDate=@MemberOverDate
			
			-- 更新同级别会员
			UPDATE QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo SET MemberOverDate=DATEADD(dd, @OverDate, @UpMemberOverDate)
			WHERE UserID=@dwUserID AND MemberOrder=@CurMemberOrder

			IF @@ROWCOUNT=0
			BEGIN
				INSERT QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo (UserID,MemberOrder,MemberOverDate)
				VALUES (@dwUserID,@CurMemberOrder,DATEADD(dd, @OverDate, GETDATE()))
			END		

			-- 更新下级会员
			UPDATE QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo SET MemberOverDate=DATEADD(dd, @OverDate, MemberOverDate)
			WHERE UserID=@dwUserID AND MemberOrder<@CurMemberOrder
		END		
		--------------------------------------------------------------

		-- 绑定会员,(会员期限与切换时间)
		SELECT @MaxMemberOrder=MAX(MemberOrder),@MemberOverDate=MAX(MemberOverDate)
		FROM QPGameUserDBLink.QPGameUserDB.dbo.MemberInfo WHERE UserID=@dwUserID	

		-- 附加会员信息
		UPDATE QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo
		SET MemberOrder=@MaxMemberOrder,MemberOverDate=@MemberOverDate
		WHERE UserID=@dwUserID
		---------------------------== 为用户绑定会员信息 end ==-------------------------------
	END

	SELECT [ErrorDescribe]= '成功信息：充值成功！',@MaxMemberOrder AS MemberOrder

END
RETURN 0
GO