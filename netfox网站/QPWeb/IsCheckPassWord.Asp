<!--#include file="Inc/Config.asp" -->
<!--#include file="Inc/md5VB.asp" -->
<!--#include file="GamePass/BasPassWordClass.Asp" -->
<%
Rem 定义变量与获得数据
Dim PassWord1,PassWord2,Cip,UserName1
PassWord1=Replace(Trim(Request.QueryString("PassWord")),"'","''")
Password2=SetPassword(PassWord1)
Cip=Replace(Trim(Request.QueryString("Ip")),"'","''")
UserName1=Replace(Trim(Request.QueryString("UserName")),"'","''")
Set md5= New MD5obj
PassWord1=md5.calcMD5(PassWord1)
Set Md5=Nothing

Rem 操作逻辑
CxGame.DbConn("WhGameUserDb")
Set Rs=Conn.Execute("Exec GSP_GP_IsLogin '"& UserName1 &"','"& PassWord1 &"','"& PassWord2 &"','"& CIp &"'")
Response.Write Rs(0)
CxGame.RsClose:CxGame.DbClose
%>


