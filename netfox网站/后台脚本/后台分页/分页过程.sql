if exists (select * from dbo.sysobjects where id = object_id(N'[sp_Util_Page]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [sp_Util_Page]
GO

----------------------------------------------------------------------------
-- 分页
-- 1.0.20071016.f By http://www.ye.vg
-- exec sp_Util_Page '字段1,字段2','表','条件','排序','主键',0,10,100,''
----------------------------------------------------------------------------
CREATE PROCEDURE sp_Util_Page
(
	@sField nvarchar(1000),		--字段(不可为空)
	@sTable nvarchar(1000),		--表名(不可为空)
	@sWhere nvarchar(1000),		--条件(可以为空,需要where)
	@sOrderby nvarchar(1000),	--排序(可以为空,需要order by,需要asc和desc字符)
	@sPkey nvarchar(50),		--主键(可以为空)
	@iPageIndex int,		--当前页数
	@iPageSize int,			--每页记录数
	@iRecordCount int OUTPUT,	--输出总记录条数(若<1则执行count)
	@sOutsql nvarchar(4000) OUTPUT	--输出sql语句
)
AS
BEGIN
	DECLARE @iRC int, @sSQL nvarchar(4000), @sW nvarchar(1000), @sOB nvarchar(1000), @sT nvarchar(100)
	SELECT @iRC = @iRecordCount, @sSQL = '', @sW = ' WHERE 1=1 ', @sOB = ''

	--判断条件
	IF RTRIM(@sWhere) != '' AND @sWhere IS NOT NULL
		BEGIN
			SET @sW=' ' + @sWhere + ' '
		END

	--判断总记录数
	IF @iRC<1
		BEGIN
			SET @sSQL='SELECT @iRC=Count(*) FROM ' + @sTable + @sW
			EXEC sp_executesql @sSQL,N'@iRC int OUT',@iRC OUT
		END

	--判断页数是否超出范围
	SELECT @iPageIndex=(CASE WHEN @iRC<(@iPageIndex-1)*@iPageSize THEN CEILING(@iRC/@iPageSize) WHEN @iPageIndex<1 THEN 1 ELSE @iPageIndex END)

	--判断排序
	IF RTRIM(@sOrderby) != '' AND @sOrderby IS NOT NULL
		BEGIN
			SELECT @sOB=' ' + @sOrderby + ' '
		END

	--如果是第一页
	IF @iPageIndex=1
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+@sOB
			GOTO step4
		END

	--看有否主键
	IF RTRIM(@sPkey) = '' OR @sPkey IS NULL
		GOTO step1
	ELSE
		--看是否按主键排序
		BEGIN
			DECLARE @sOB1 nvarchar(1000), @sPkey1 nvarchar(50)
			SELECT @sOB1 = UPPER(@sOrderby), @sPkey1 = UPPER(@sPkey)
			IF CHARINDEX(@sPkey1 + ' ASC', @sOB1)>0
				BEGIN
					SET @sT='>(SELECT MAX('
					GOTO step2
				END
			IF CHARINDEX(@sPkey1 + ' DESC', @sOB1)>0
				BEGIN
					SET @sT='<(SELECT MIN('
					GOTO step2
				END
			GOTO step3
		END

	--如果无主键
	step1:
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW + ' AND EXISTS (SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+@sOB+')'+@sOB+')'
			GOTO step4
		END
	--纯按主键排序
	step2:
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+' AND '+@sPkey+@sT+@sPkey+') FROM (SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW+@sOB+') AS tbTemp)'+@sOB
			GOTO step4
		END
	--不纯按主键排序
	step3:
		BEGIN
			SET @sSQL='SELECT '+@sField+' FROM '+@sTable+@sW + ' AND ' + @sPkey+' IN (SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW + ' AND ' + @sPkey+' NOT IN(SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW+@sOB+')'+@sOB+')'+@sOB
			GOTO step4
		END
	--输出最终执行的分页sql语句并执行
	step4:
		SELECT @sOutsql = @sSQL, @iRecordCount = @iRC
		--print(@sSQL)
		EXEC(@sSQL)
END
GO