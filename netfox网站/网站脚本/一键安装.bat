@echo off

TITLE 棋牌数据库【Ver6.5】 建立脚本启动中... [期间请勿关闭]

md D:\数据库

Rem 网站数据库建立
set rootPath=数据库脚本\
osql -E -i "%rootPath%用户数据库.sql"
osql -E -i "%rootPath%平台数据库.sql"
osql -E -i "%rootPath%网站数据库.sql"


Rem 存储过程
set rootPath=存储过程\用户数据库\
osql -E -i "%rootPath%设置安全密码.sql"
osql -E -i "%rootPath%修改登陆密码.sql"
osql -E -i "%rootPath%修改银行密码.sql"
osql -E -i "%rootPath%帐号登陆.sql"
osql -E -i "%rootPath%帐号申述.sql"
osql -E -i "%rootPath%帐号注册.sql"
osql -E -i "%rootPath%帐号冻结.sql"
osql -E -i "%rootPath%找回密码.sql"
osql -E -i "%rootPath%修改资料.sql"
osql -E -i "%rootPath%固定机器.sql"

set rootPath=存储过程\金币数据库\
osql -E -i "%rootPath%金币存款.sql"
osql -E -i "%rootPath%金币取款.sql"
osql -E -i "%rootPath%金币转账.sql"
osql -E -i "%rootPath%在线充值.sql"

set rootPath=存储过程\积分数据库\
osql -E -i "%rootPath%负分清零.sql"

pause

set rootPath=数据脚本\
osql -E  -i "%rootPath%网站数据.sql"

COLOR 0A
CLS
@echo off
cls
echo ---------------------------------------------------------
echo.
echo	网站数据库建立完成，请根据自己平台的积分游戏执行 
echo.
echo	“存储过程\积分数据库\负分清零.sql”脚本文件
echo.
echo	以完成玩家的负分清零操作！
echo.
echo	版权所有： 深圳市网狐科技有限公司
echo --------------------------------------------------------

pause

