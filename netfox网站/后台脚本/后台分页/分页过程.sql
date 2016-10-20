if exists (select * from dbo.sysobjects where id = object_id(N'[sp_Util_Page]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [sp_Util_Page]
GO

----------------------------------------------------------------------------
-- ��ҳ
-- 1.0.20071016.f By http://www.ye.vg
-- exec sp_Util_Page '�ֶ�1,�ֶ�2','��','����','����','����',0,10,100,''
----------------------------------------------------------------------------
CREATE PROCEDURE sp_Util_Page
(
	@sField nvarchar(1000),		--�ֶ�(����Ϊ��)
	@sTable nvarchar(1000),		--����(����Ϊ��)
	@sWhere nvarchar(1000),		--����(����Ϊ��,��Ҫwhere)
	@sOrderby nvarchar(1000),	--����(����Ϊ��,��Ҫorder by,��Ҫasc��desc�ַ�)
	@sPkey nvarchar(50),		--����(����Ϊ��)
	@iPageIndex int,		--��ǰҳ��
	@iPageSize int,			--ÿҳ��¼��
	@iRecordCount int OUTPUT,	--����ܼ�¼����(��<1��ִ��count)
	@sOutsql nvarchar(4000) OUTPUT	--���sql���
)
AS
BEGIN
	DECLARE @iRC int, @sSQL nvarchar(4000), @sW nvarchar(1000), @sOB nvarchar(1000), @sT nvarchar(100)
	SELECT @iRC = @iRecordCount, @sSQL = '', @sW = ' WHERE 1=1 ', @sOB = ''

	--�ж�����
	IF RTRIM(@sWhere) != '' AND @sWhere IS NOT NULL
		BEGIN
			SET @sW=' ' + @sWhere + ' '
		END

	--�ж��ܼ�¼��
	IF @iRC<1
		BEGIN
			SET @sSQL='SELECT @iRC=Count(*) FROM ' + @sTable + @sW
			EXEC sp_executesql @sSQL,N'@iRC int OUT',@iRC OUT
		END

	--�ж�ҳ���Ƿ񳬳���Χ
	SELECT @iPageIndex=(CASE WHEN @iRC<(@iPageIndex-1)*@iPageSize THEN CEILING(@iRC/@iPageSize) WHEN @iPageIndex<1 THEN 1 ELSE @iPageIndex END)

	--�ж�����
	IF RTRIM(@sOrderby) != '' AND @sOrderby IS NOT NULL
		BEGIN
			SELECT @sOB=' ' + @sOrderby + ' '
		END

	--����ǵ�һҳ
	IF @iPageIndex=1
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+@sOB
			GOTO step4
		END

	--���з�����
	IF RTRIM(@sPkey) = '' OR @sPkey IS NULL
		GOTO step1
	ELSE
		--���Ƿ���������
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

	--���������
	step1:
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW + ' AND EXISTS (SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+@sOB+')'+@sOB+')'
			GOTO step4
		END
	--������������
	step2:
		BEGIN
			SET @sSQL='SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sField+' FROM '+@sTable+@sW+' AND '+@sPkey+@sT+@sPkey+') FROM (SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW+@sOB+') AS tbTemp)'+@sOB
			GOTO step4
		END
	--��������������
	step3:
		BEGIN
			SET @sSQL='SELECT '+@sField+' FROM '+@sTable+@sW + ' AND ' + @sPkey+' IN (SELECT TOP '+CAST(@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW + ' AND ' + @sPkey+' NOT IN(SELECT TOP '+CAST((@iPageIndex-1)*@iPageSize AS nvarchar)+' '+@sPkey+' FROM '+@sTable+@sW+@sOB+')'+@sOB+')'+@sOB
			GOTO step4
		END
	--�������ִ�еķ�ҳsql��䲢ִ��
	step4:
		SELECT @sOutsql = @sSQL, @iRecordCount = @iRC
		--print(@sSQL)
		EXEC(@sSQL)
END
GO