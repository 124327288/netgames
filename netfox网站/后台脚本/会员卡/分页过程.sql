


/*----------------------------------------------------------------------
-- 版权：2009,深圳市网狐科技有限公司
-- 时间：2009-04-10
-- 作者：guoshulang@foxmail.com
--
-- 用途：分页过程
-- 返回值:
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
	@ntxtSql         ntext,     --要执行的sql语句
	@dwPageCurrent int=1,     --要显示的页码
	@dwPageSize    int=10,    --每页的大小
	@dwRowCount   int OUTPUT --总页数
WITH ENCRYPTION AS

SET NOCOUNT ON

BEGIN

	DECLARE @p1 int
	--初始化分页游标
	EXEC sp_cursoropen 
		@cursor=@p1 OUTPUT,
		@stmt=@ntxtSql,
		@scrollopt=1,
		@ccopt=1,
		@rowcount=@dwRowCount OUTPUT

	--计算总页数
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

--显示指定页的数据
EXEC sp_cursorfetch @p1,16,@dwPageCurrent,@dwPageSize

--关闭分页游标
EXEC sp_cursorclose @p1

END
GO
