

-- ��������
-- ��ÿ����Ϸ�����и��洢����:Gsp_Cls 
-- ����������,��������������Gsp_Cls�� 

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_Cls]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_Cls]
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [GSP_Cls]
(
@UserID 	[Int]
)
As

IF Not EXISTS (select UserID from GameScoreInfo Where UserID=@UserID)
BEGIN
	Select '�Բ���,���ķֱ�����Ϊ��,��������!'
	RETURN
End

IF EXISTS (select UserID from GameScoreInfo Where UserID=@UserID And Score = 0 And WinCount = 0 And LostCount = 0 And DrawCount = 0 And FleeCount = 0)
BEGIN
	Select '�Բ���,���ķֱ�����Ϊ��,��������!'
	RETURN
End

IF (select Score from GameScoreInfo Where UserID=@UserID)>0
BEGIN
	Select '���ķֲ����Ǹ���,��������!'
	RETURN
End

IF (Select InsureScore From QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo Where UserID=@UserID)<100000
BEGIN
	Select '�Բ���,�������д���10��,����Ϊ������!'
	RETURN
END
Select '����ɹ�,�۳�������10��������!'
UPDATE GameScoreInfo SET Score = 0, WinCount = 0, LostCount = 0, DrawCount = 0, FleeCount = 0, PlayTimeCount = 0, AllLogonTimes = 0 where userid=@userid
Update QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo Set InsureScore=InsureScore-100000 Where UserID=@UserID
INSERT INTO QPGameUserDBLink.QPGameUserDB.dbo.Cls_Log([UserID],[Game]) VALUES (@UserID,'������')
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO  
