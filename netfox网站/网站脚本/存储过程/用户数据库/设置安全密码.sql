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
		SELECT '������Ϣ:�����ʺ��Ѿ�������!'
	END
	Else
	BEGIN
		IF (Select LogonPass From AccountsInfo WHERE UserID=@UserID)<>@LogonPass
			BEGIN
				SELECT '������Ϣ:���ĵ������벻��ȷ!'
			END
		ELSE
		BEGIN
			IF (Select InsurePass From AccountsInfo WHERE UserID=@UserID)<>@InsurePass
				BEGIN
					SELECT '������Ϣ:�����������벻��ȷ!'
				END
			ELSE
			BEGIN
				IF (Select LogonPass From AccountsInfo WHERE UserID=@UserID)=@PassWordCode2
					BEGIN
						SELECT '������Ϣ:��ȫ�벻�������������ͬ!'
					END
				ELSE
				BEGIN
					IF (Select InsurePass From AccountsInfo WHERE UserID=@UserID)=@PassWordCode2
					BEGIN
						SELECT '������Ϣ:��ȫ�벻��������������ͬ!'
					END
					ELSE
					BEGIN
						Update [AccountsInfo] Set PassWordCode=@PassWordCode Where UserID=@UserID
						SELECT '�ɹ���Ϣ:��ȫ�����óɹ�!'		
					END
				END
			END
		END
	END

END
return 0
go