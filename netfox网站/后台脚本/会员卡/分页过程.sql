


/*----------------------------------------------------------------------
-- ��Ȩ��2009,�����������Ƽ����޹�˾
-- ʱ�䣺2009-04-10
-- ���ߣ�guoshulang@foxmail.com
--
-- ��;����ҳ����
-- ����ֵ:
----------------------------------------------------------------------*/


----------------------------------------------------------------------------------------------------

use QPTreasureDB
go

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[WEB_PageView]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[WEB_PageView]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON 
GO

CREATE PROC WEB_PageView
	@ntxtSql         ntext,     --Ҫִ�е�sql���
	@dwPageCurrent int=1,     --Ҫ��ʾ��ҳ��
	@dwPageSize    int=10,    --ÿҳ�Ĵ�С
	@dwRowCount   int OUTPUT --��ҳ��
WITH ENCRYPTION AS

SET NOCOUNT ON

BEGIN

	DECLARE @p1 int
	--��ʼ����ҳ�α�
	EXEC sp_cursoropen 
		@cursor=@p1 OUTPUT,
		@stmt=@ntxtSql,
		@scrollopt=1,
		@ccopt=1,
		@rowcount=@dwRowCount OUTPUT

	--������ҳ��
	IF ISNULL(@dwPageSize,0)<1
	BEGIN
		SET @dwPageSize=10
	END

	DECLARE @dwPageCount INT
	SET @dwPageCount=(@dwRowCount+@dwPageSize-1)/@dwPageSize
	IF ISNULL(@dwPageCurrent,0)<1 OR ISNULL(@dwPageCurrent,0)>@dwPageCount
	BEGIN
		SET @dwPageCurrent=1
	END
	ELSE
	BEGIN
		SET @dwPageCurrent=(@dwPageCurrent-1)*@dwPageSize+1
	END

--��ʾָ��ҳ������
EXEC sp_cursorfetch @p1,16,@dwPageCurrent,@dwPageSize

--�رշ�ҳ�α�
EXEC sp_cursorclose @p1

END
GO
