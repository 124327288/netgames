

USE [QPTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ReceiveWealth]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ReceiveWealth]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [dbo].[GSP_GP_ReceiveWealth]
	@UserID 	[int],
	@money 		[bigint],
	@PassWord	[char](32),
	@Cip		[VARCHAR](15)
	
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 用户属性
DECLARE @GameID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @Nullity BIT

BEGIN

	SELECT @GameID=GameID,@Accounts=Accounts,@Nullity=Nullity
	FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@UserID

	IF @Nullity=1
	BEGIN
		SELECT '错误信息:您的帐号已经被冻结!'
	END
	Else
	Begin
		IF (Select InsurePass From QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@UserID)<>@PassWord
			BEGIN
				SELECT '错误信息:您的银行密码不正确!'
			END
		ELSE
			BEGIN
				IF EXISTS (SELECT UserID FROM GameScoreLocker WHERE UserID=@UserID)
					BEGIN
						SELECT '错误信息:您目前在银子游戏房间,不能进行银行操作!'
					END
				Else
					BEGIN
						IF (SELECT InsureScore FROM GameScoreInfo WHERE UserID=@UserID)>=@money
						BEGIN
							DECLARE @Cbnak [bigint]			

							SET @Cbnak=(SELECT InsureScore FROM GameScoreInfo WHERE UserID=@UserID)

							UPDATE GameScoreInfo
							SET  InsureScore=InsureScore-@money WHERE ( [UserID] = @UserID)
							
							UPDATE GameScoreInfo
							SET  Score=Score+@money WHERE ( [UserID]= @UserID)	
							
							INSERT RecordInsure (SourceUserID,SourceGameID,SourceAccounts,InsureScore,SwapScore,TradeType,ClientIP)
							VALUES (@UserID,@GameID,@Accounts,@Cbnak,@money,2,@Cip)
		
							SELECT '成功信息:取出银子成功'
							END
						ELSE
							BEGIN
								SELECT '错误信息:您的银行余额少于您要取的银子数!'
							END
					END
			END
	End

END

SET NOCOUNT OFF

RETURN 0
GO