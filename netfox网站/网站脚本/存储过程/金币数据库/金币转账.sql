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

-- ��������
SET NOCOUNT ON

-- �û�����
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
		SELECT '������Ϣ:�����ʺ��Ѿ�������!'
	END
	Else
	BEGIN
	IF EXISTS (SELECT UserID FROM GameScoreLocker WHERE UserID=@UserID)
		BEGIN
			SELECT '������Ϣ:��Ŀǰ��������Ϸ����,���ܽ������в���!'
		END
	Else
		BEGIN
		
			IF @InsurePass<>@PassWord
				BEGIN
					SELECT '������Ϣ:�����������벻��ȷ!'
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
							Set @ErrorDescribe='������Ϣ:ͬһ�û�һ��ת�ʶ�ܳ���@DMoney������!'
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
								Set @ErrorDescribe='������Ϣ:����δ֪�Ĵ���,ת��û�гɹ�'
								SELECT [ErrorDescribe]=@ErrorDescribe
								RETURN
							END

							UPDATE [GameScoreInfo] SET InsureScore=InsureScore-@money WHERE [UserID]=@UserID

							INSERT RecordInsure (SourceUserID,SourceGameID,SourceAccounts,TargetUserID,TargetGameID,TargetAccounts,InsureScore,SwapScore,Revenue,TradeType,ClientIP)
							VALUES (@SourceUserID,@SourceGameID,@SourceAccounts,@TargetUserID,@TargetGameID,@TargetAccounts,@Cbnak,@money,@amoney,3,@Cip)
							
							Set @ErrorDescribe='�ɹ���Ϣ:���ɹ�ת�ʸ�@GameName����: @money,��ȡ����� @amoney������!'
							SELECT [ErrorDescribe]=@ErrorDescribe

							END					
						END
						ELSE
						BEGIN
							Set @ErrorDescribe='������Ϣ:������������!���б�����@Bmoney�����Ӵ��!'
							SELECT [ErrorDescribe]=@ErrorDescribe
						END
					End
					else
					Begin
						SELECT '������Ϣ:��������տ����û������տ���ID�Ų�ƥ��!'
					End
				End
		END
	END

END
return 0
go