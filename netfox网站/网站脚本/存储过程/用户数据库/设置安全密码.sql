USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ProCode]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ProCode]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [dbo].[GSP_GP_ProCode]
	@UserID 	 [int],
	@LogonPass 	 [char](32),
	@InsurePass  [char](32),
	@PassWordCode[nvarchar](50),
	@PassWordCode2[char](32)
WITH ENCRYPTION AS
BEGIN

	IF (Select Nullity From [AccountsInfo] WHERE UserID=@UserID)=1
	BEGIN
		SELECT '错误信息:您的帐号已经被冻结!'
	END
	Else
	BEGIN
		IF (Select LogonPass From AccountsInfo WHERE UserID=@UserID)<>@LogonPass
			BEGIN
				SELECT '错误信息:您的登入密码不正确!'
			END
		ELSE
		BEGIN
			IF (Select InsurePass From AccountsInfo WHERE UserID=@UserID)<>@InsurePass
				BEGIN
					SELECT '错误信息:您的银行密码不正确!'
				END
			ELSE
			BEGIN
				IF (Select LogonPass From AccountsInfo WHERE UserID=@UserID)=@PassWordCode2
					BEGIN
						SELECT '错误信息:安全码不能与登入密码相同!'
					END
				ELSE
				BEGIN
					IF (Select InsurePass From AccountsInfo WHERE UserID=@UserID)=@PassWordCode2
					BEGIN
						SELECT '错误信息:安全码不能与银行密码相同!'
					END
					ELSE
					BEGIN
						Update [AccountsInfo] Set PassWordCode=@PassWordCode Where UserID=@UserID
						SELECT '成功信息:安全码设置成功!'		
					END
				END
			END
		END
	END

END
return 0
go