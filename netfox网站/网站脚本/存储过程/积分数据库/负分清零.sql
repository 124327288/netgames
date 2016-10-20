

-- 负分清零
-- 在每个游戏库里有个存储过程:Gsp_Cls 
-- 比如五子棋,就在五子棋库里的Gsp_Cls里 

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
	Select '对不起,您的分本来就为零,不必清零!'
	RETURN
End

IF EXISTS (select UserID from GameScoreInfo Where UserID=@UserID And Score = 0 And WinCount = 0 And LostCount = 0 And DrawCount = 0 And FleeCount = 0)
BEGIN
	Select '对不起,您的分本来就为零,不必清零!'
	RETURN
End

IF (select Score from GameScoreInfo Where UserID=@UserID)>0
BEGIN
	Select '您的分并不是负数,不必清零!'
	RETURN
End

IF (Select InsureScore From QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo Where UserID=@UserID)<100000
BEGIN
	Select '对不起,您的银行存款不足10万,不能为您清零!'
	RETURN
END
Select '清零成功,扣除您银行10万两银子!'
UPDATE GameScoreInfo SET Score = 0, WinCount = 0, LostCount = 0, DrawCount = 0, FleeCount = 0, PlayTimeCount = 0, AllLogonTimes = 0 where userid=@userid
Update QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo Set InsureScore=InsureScore-100000 Where UserID=@UserID
INSERT INTO QPGameUserDBLink.QPGameUserDB.dbo.Cls_Log([UserID],[Game]) VALUES (@UserID,'五子棋')
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO  
