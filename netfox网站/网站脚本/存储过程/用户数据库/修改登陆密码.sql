

USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UpdatePassWord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UpdatePassWord]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [dbo].[GSP_GP_UpdatePassWord]
	@UserID 	[int],
	@LogonPass 	[char](32),
	@LogonPass2 	[char](32),
	@Typ[nvarchar](50)
WITH ENCRYPTION AS
BEGIN

	IF @TYP='LogonPass'
	BEGIN
		IF EXISTS (SELECT UserID FROM AccountsInfo WHERE UserID=@UserID And LogonPass=@LogonPass)
		BEGIN
			UPDATE [AccountsInfo] 
			SET  LogonPass	 = @LogonPass2 WHERE ( [UserID]	 = @UserID)
			SELECT '�ɹ���Ϣ:�޸ĵ�������ɹ�!'
		END
		ELSE
		BEGIN
			SELECT '����ԭ�����������!'
		END
	END

	IF @TYP='InsurePass'
	BEGIN
		IF EXISTS (SELECT UserID FROM AccountsInfo WHERE UserID=@UserID And InsurePass=@LogonPass)
		BEGIN
			UPDATE [AccountsInfo] 
			SET  InsurePass	 = @LogonPass2 WHERE ( [UserID]	 = @UserID)
			SELECT '�ɹ���Ϣ:�޸���������ɹ�!'
		END
		ELSE
		BEGIN
			SELECT '��������ԭ�����������!'
		END
	END

END
return 0
go