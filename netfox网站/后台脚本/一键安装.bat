@echo off

TITLE �������ݿ⡾Ver6.5�� �����ű�������... [�ڼ�����ر�]



Rem ��Ա��
set rootPath=��Ա��\
osql -E -i "%rootPath%��ҳ����.sql"
osql -E -i "%rootPath%����ṹ.sql"
osql -E -i "%rootPath%��������.sql"


Rem ��̨��ҳ�洢����
set rootPath=��̨��ҳ\
echo �û����ݿ�
osql -E -d -i QPGameUserDB -i "%rootPath%��ҳ����.sql"

echo ������ݿ�
osql -E -d -i QPTreasureDB -i "%rootPath%��ҳ����.sql"

echo �������ݿ�
osql -E -d -i QPGameScoreDB -i "%rootPath%��ҳ����.sql"

pause

COLOR 0A
CLS
@echo off
cls
echo ---------------------------------------------------------
echo.
echo	��Ϸ��̨���ݿ�������ɣ�������Լ�ƽ̨�Ļ�����Ϸִ�� 
echo.
echo	����̨��ҳ\��ҳ����.sql���ű��ļ�
echo.
echo	Ϊ�˱�֤���к�̨��ʾ����.�������ÿ���������ݿ�ִ�д��ļ�
echo.
echo	��Ȩ���У� �����������Ƽ����޹�˾
echo --------------------------------------------------------

pause

