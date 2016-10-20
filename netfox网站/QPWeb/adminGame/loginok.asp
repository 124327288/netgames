<!--#include file="../inc/conn.asp"-->
<%
if session("tak")<>"" or request.cookies("tak")="chak" then
response.write("系统认定你是不怀好意的攻击者,登陆权限对你永久终止")
response.end
end if
if instr(request.form("password"),"'")>0 and instr(request.form("password"),"or")>0 then
session("tak")=1
response.write("系统认定你是不怀好意的攻击者,登陆权限对你永久终止")
response.Cookies("tak")="chak"
response.Cookies("tak").expires=date+365
response.end
end if
session("adminadminchen")=""
session("chenruofanfan")=""
session("user")=""
function cheng(crf) 
crf=trim(crf) 
crf=replace(crf," ","&amp;nbsp;") 
crf=replace(crf,"'","&amp;#39;") 
crf=replace(crf,"""","&amp;quot;") 
crf=replace(crf,"&lt;","&amp;lt;") 
crf=replace(crf,"&gt;","&amp;gt;")
crf=replace(crf,"or","") 
cheng=crf 
end function 
user=cheng(trim(request.Form("admin")))
pass=cheng(trim(request.form("password")))
chen=1
set rs=server.createobject("adodb.recordset")
sql="select * from admin where admin='"&user&"'"
rs.open sql,conn,1,1
if rs.eof then
chen=0
else
  if rs("password")<>pass then
  chen=0
  end if
end if
if chen=0 then
response.write "<script language=JavaScript>" & chr(13) & "alert(' 用户名或密码错误 ');" & "history.back()" & "</script>"
response.end
end if
if chen=1 then
session("adminadminchen")=rs("admin")
session("chenruofanfan")="chenruofanfan112233"
session("user")=rs("classcode")
session("admin2")=rs("classname")
response.redirect "index.asp"
end if
rs.close
set rs=nothing
%>