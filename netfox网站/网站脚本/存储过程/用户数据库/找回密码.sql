USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_FindPassWord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_FindPassWord]
GO


CREATE PROCEDURE [dbo].[GSP_GP_FindPassWord]
	@UserName [char](32),
	@LogonPass 	 [char](32),
	@InsurePass  [char](32),
	@PassWordCode[nvarchar](50)	
WITH ENCRYPTION AS
BEGIN

	IF (Select Nullity From [AccountsInfo] WHERE Accounts=@UserName)=1
	BEGIN
		SELECT '错误信息:您的帐号已经被冻结!'
	END
	Else
	BEGIN
		IF (Select PassWordCode From [AccountsInfo] WHERE Accounts=@UserName) Is Null
		BEGIN
			SELECT '错误信息:您还没有申请密码保护!'
		End
		ELSE
		BEGIN
			IF (Select PassWordCode From AccountsInfo WHERE Accounts=@UserName)<>@PassWordCode
				BEGIN
					SELECT '错误信息:您的安全码不正确!'
				END
			ELSE
				BEGIN
					Update [AccountsInfo] Set LogonPass=@LogonPass,InsurePass=@InsurePass WHERE Accounts=@UserName
					SELECT '成功信息:您的密码已成功重设!'
				END
		END
	END

END
return 0
go