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
		SELECT '������Ϣ:�����ʺ��Ѿ�������!'
	END
	Else
	BEGIN
		IF (Select PassWordCode From [AccountsInfo] WHERE Accounts=@UserName) Is Null
		BEGIN
			SELECT '������Ϣ:����û���������뱣��!'
		End
		ELSE
		BEGIN
			IF (Select PassWordCode From AccountsInfo WHERE Accounts=@UserName)<>@PassWordCode
				BEGIN
					SELECT '������Ϣ:���İ�ȫ�벻��ȷ!'
				END
			ELSE
				BEGIN
					Update [AccountsInfo] Set LogonPass=@LogonPass,InsurePass=@InsurePass WHERE Accounts=@UserName
					SELECT '�ɹ���Ϣ:���������ѳɹ�����!'
				END
		END
	END

END
return 0
go