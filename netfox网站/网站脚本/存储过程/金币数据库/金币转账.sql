USE [QPTreasureDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_Transfers]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_Transfers]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [dbo].[GSP_GP_Transfers]
	@UserID   [int],
	@UserName [varchar](32),
	@PassWord [char](32),
	@GameID   [int],
	@GameName [varchar](32),
	@bmoney   [int],
	@AMoney   [int],
	@Money    [bigint],
	@DMoney   [int],
	@Cip      [VARCHAR](15)	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户属性
DECLARE @SourceUserID INT
DECLARE @SourceGameID INT
DECLARE @SourceAccounts NVARCHAR(31)
DECLARE @Nullity BIT
DECLARE @InsurePass NVARCHAR(32)

DECLARE @TargetUserID INT
DECLARE @TargetGameID INT
DECLARE @TargetAccounts NVARCHAR(31)

DECLARE @ErrorDescribe VARCHAR(128)

BEGIN
	
	SELECT @SourceUserID=UserID,@SourceGameID=GameID,@SourceAccounts=Accounts,@Nullity=Nullity,@InsurePass=InsurePass
	FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@UserID

	IF @Nullity=1
	BEGIN
		SELECT '错误信息:您的帐号已经被冻结!'
	END
	Else
	BEGIN
	IF EXISTS (SELECT UserID FROM GameScoreLocker WHERE UserID=@UserID)
		BEGIN
			SELECT '错误信息:您目前在银子游戏房间,不能进行银行操作!'
		END
	Else
		BEGIN
		
			IF @InsurePass<>@PassWord
				BEGIN
					SELECT '错误信息:您的银行密码不正确!'
				END
			ELSE
				BEGIN
					
					SELECT @TargetUserID=UserID,@TargetGameID=GameID,@TargetAccounts=Accounts
					FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo 
					WHERE GameID=@GameID And Accounts=@GameName
				
					IF @TargetUserID IS NOT NULL
					Begin
						IF NOT EXISTS (SELECT UserID FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID=@TargetUserID)
						BEGIN
							INSERT INTO QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo 
							([UserID],[Score],[RegisterIP],[LastLogonIP])
							VALUES (@TargetUserID,0,@Cip,@Cip)
						END

						IF (SELECT InsureScore FROM GameScoreInfo WHERE UserID=@UserID)>=(@money+@BMoney)
						BEGIN
							IF ((Select Sum(SwapScore) From [RecordInsure] Where [SourceUserID]=@UserID And Datediff(day,CollectDate,GETDATE())=0)+@money)>@DMoney
							BEGIN
							Set @ErrorDescribe='错误信息:同一用户一天转帐额不能超过@DMoney两银子!'
							SELECT [ErrorDescribe]=@ErrorDescribe
							End
							ELSE
							BEGIN

							DECLARE @Cbnak [bigint]
							DECLARE @Dbnak [bigint]
							SELECT  @Cbnak=InsureScore FROM GameScoreInfo WHERE UserID=@UserID
							SELECT @Dbnak=InsureScore FROM GameScoreInfo WHERE UserID=@TargetUserID
							
							UPDATE [GameScoreInfo] SET  InsureScore=InsureScore+(@money-@AMoney) WHERE UserID=@TargetUserID
							IF @@ERROR<>0
							BEGIN
								Set @ErrorDescribe='错误信息:由于未知的错误,转帐没有成功'
								SELECT [ErrorDescribe]=@ErrorDescribe
								RETURN
							END

							UPDATE [GameScoreInfo] SET InsureScore=InsureScore-@money WHERE [UserID]=@UserID

							INSERT RecordInsure (SourceUserID,SourceGameID,SourceAccounts,TargetUserID,TargetGameID,TargetAccounts,InsureScore,SwapScore,Revenue,TradeType,ClientIP)
							VALUES (@SourceUserID,@SourceGameID,@SourceAccounts,@TargetUserID,@TargetGameID,@TargetAccounts,@Cbnak,@money,@amoney,3,@Cip)
							
							Set @ErrorDescribe='成功信息:您成功转帐给@GameName银子: @money,收取服务费 @amoney两银子!'
							SELECT [ErrorDescribe]=@ErrorDescribe

							END					
						END
						ELSE
						BEGIN
							Set @ErrorDescribe='错误信息:您的银行余额不足!银行必须有@Bmoney两银子存底!'
							SELECT [ErrorDescribe]=@ErrorDescribe
						END
					End
					else
					Begin
						SELECT '错误信息:您输入的收款人用户名和收款人ID号不匹配!'
					End
				End
		END
	END

END
return 0
go