@echo off

TITLE �������ݿ⡾Ver6.5�� �����ű�������... [�ڼ�����ر�]

md D:\���ݿ�

Rem ��վ���ݿ⽨��
set rootPath=���ݿ�ű�\
osql -E -i "%rootPath%�û����ݿ�.sql"
osql -E -i "%rootPath%ƽ̨���ݿ�.sql"
osql -E -i "%rootPath%��վ���ݿ�.sql"


Rem �洢����
set rootPath=�洢����\�û����ݿ�\
osql -E -i "%rootPath%���ð�ȫ����.sql"
osql -E -i "%rootPath%�޸ĵ�½����.sql"
osql -E -i "%rootPath%�޸���������.sql"
osql -E -i "%rootPath%�ʺŵ�½.sql"
osql -E -i "%rootPath%�ʺ�����.sql"
osql -E -i "%rootPath%�ʺ�ע��.sql"
osql -E -i "%rootPath%�ʺŶ���.sql"
osql -E -i "%rootPath%�һ�����.sql"
osql -E -i "%rootPath%�޸�����.sql"
osql -E -i "%rootPath%�̶�����.sql"

set rootPath=�洢����\������ݿ�\
osql -E -i "%rootPath%��Ҵ��.sql"
osql -E -i "%rootPath%���ȡ��.sql"
osql -E -i "%rootPath%���ת��.sql"
osql -E -i "%rootPath%���߳�ֵ.sql"

set rootPath=�洢����\�������ݿ�\
osql -E -i "%rootPath%��������.sql"

pause

set rootPath=���ݽű�\
osql -E  -i "%rootPath%��վ����.sql"

COLOR 0A
CLS
@echo off
cls
echo ---------------------------------------------------------
echo.
echo	��վ���ݿ⽨����ɣ�������Լ�ƽ̨�Ļ�����Ϸִ�� 
echo.
echo	���洢����\�������ݿ�\��������.sql���ű��ļ�
echo.
echo	�������ҵĸ������������
echo.
echo	��Ȩ���У� �����������Ƽ����޹�˾
echo --------------------------------------------------------

pause

