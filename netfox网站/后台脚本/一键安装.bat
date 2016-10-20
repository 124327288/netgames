@echo off

TITLE 棋牌数据库【Ver6.5】 建立脚本启动中... [期间请勿关闭]



Rem 会员卡
set rootPath=会员卡\
osql -E -i "%rootPath%分页过程.sql"
osql -E -i "%rootPath%卡表结构.sql"
osql -E -i "%rootPath%生产卡号.sql"


Rem 后台分页存储过程
set rootPath=后台分页\
echo 用户数据库
osql -E -d -i QPGameUserDB -i "%rootPath%分页过程.sql"

echo 金币数据库
osql -E -d -i QPTreasureDB -i "%rootPath%分页过程.sql"

echo 积分数据库
osql -E -d -i QPGameScoreDB -i "%rootPath%分页过程.sql"

pause

COLOR 0A
CLS
@echo off
cls
echo ---------------------------------------------------------
echo.
echo	游戏后台数据库升级完成，请根据自己平台的积分游戏执行 
echo.
echo	“后台分页\分页过程.sql”脚本文件
echo.
echo	为了保证所有后台显示正常.请务必在每个积分数据库执行此文件
echo.
echo	版权所有： 深圳市网狐科技有限公司
echo --------------------------------------------------------

pause

