USE [QPTreasureDB]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ServeWealth]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ServeWealth]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


CREATE PROCEDURE [dbo].[GSP_GP_ServeWealth]
	@UserID 	INT,
	@money 		BIGINT,
	@Cip		VARCHAR(15)	
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- �û�����
DECLARE @GameID INT
DECLARE @Accounts NVARCHAR(31)

BEGIN

	SELECT @GameID=GameID,@Accounts=Accounts
	FROM QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo WHERE UserID=@UserID

	IF EXISTS (SELECT UserID FROM GameScoreLocker WHERE UserID=@UserID)
	BEGIN
		SELECT '������Ϣ:��Ŀǰ��������Ϸ����,���ܽ������в���!'
	END
	Else
		BEGIN
		IF (SELECT Score FROM GameScoreInfo WHERE UserID=@UserID)>=@money
			BEGIN
				DECLARE @Cbnak BIGINT
				DECLARE @CScore INT
				SET @Cbnak=(SELECT InsureScore FROM GameScoreInfo WHERE UserID=@UserID)
				
				UPDATE [GameScoreInfo] SET Score=Score-@money WHERE [UserID]=@UserID
				
				UPDATE [GameScoreInfo] 
				SET  InsureScore= InsureScore+@money WHERE [UserID]=@UserID And Score>=0
				
				--SET @CScore=(SELECT Score FROM GameScoreInfo WHERE UserID=@UserID)
				
				INSERT RecordInsure (SourceUserID,SourceGameID,SourceAccounts,InsureScore,SwapScore,TradeType,ClientIP)
				VALUES (@UserID,@GameID,@Accounts,@Cbnak,@money,1,@Cip)

				SELECT '�ɹ���Ϣ:�������ӳɹ�'
			END
		ELSE
			BEGIN
				SELECT '������Ϣ:���Ĵ�������������������е�������!'
			END
		END

END

SET NOCOUNT OFF

RETURN 0
GO