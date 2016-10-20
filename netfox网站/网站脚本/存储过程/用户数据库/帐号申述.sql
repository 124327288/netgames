USE [QPGameUserDB]
GO



IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GetPassWord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GetPassWord]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO




CREATE PROCEDURE [dbo].[GetPassWord]
	 @UserID_1 	[nvarchar](50),
	 @Email_2 	[nvarchar](50),
	 @Passw_3 	[nvarchar](50),
	 @Passd_4 	[nvarchar](50),
	 @Code_5 	[nvarchar](50),
	 @Adder_6 	[nvarchar](50),
	 @TelMail_8	[nvarchar](50),
	 @Txt_9 	[nvarchar](800),
	 @PASSOWRD	[nvarchar](50)	
WITH ENCRYPTION AS
BEGIN

	IF EXISTS (select ID from PassWordList Where UserID=@UserID_1 And IsCut=0)
	BEGIN
	Delete From PassWordList Where UserID=@UserID_1 And IsCut=0
	END

	INSERT INTO [PassWordList] 
		 ( 
		 [UserID],
		 [Email],
		 [Passw],
		 [Passd],
		 [Code],
		 [Adder],
		 [TelMail],
		 [Txt],[password]) 
	 
	VALUES 
		( @UserID_1,
		 @Email_2,
		 @Passw_3,
		 @Passd_4,
		 @Code_5,
		 @Adder_6,
		 @TelMail_8,
		 @Txt_9, @PASSOWRD)

END
return 0
go