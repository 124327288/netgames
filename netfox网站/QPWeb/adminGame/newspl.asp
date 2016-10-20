<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<%
act=request("act")
if act="del" then
id=request("id")
set rs=server.CreateObject("adodb.recordset")
sql="delete from newshf where id="&id
rs.open sql,conn,1,3
rs.close
set rs=nothing
end if
id=request("id")
set rs=server.CreateObject("adodb.recordset")
sql="select * from newshf where newsid="&id
rs.open sql,conn,1,1
if rs.eof and rs.bof then
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>此新闻没有任何评论</td>
  </tr>
</table>
<%
response.end
end if
%>
<link href="../inc/STYLE.CSS" rel="stylesheet" type="text/css">
<body bgcolor="#5578b8" leftmargin="0" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#cfdded" class="txt"> 
    <td width="0" height="28"> 
      <div align="center" class="txt">评论内容</div></td>
    <td width="120"> 
      <div align="center">评论者邮箱</div></td>
    <td width="120"> 
      <div align="center">评论者IP</div></td>
    <td width="30"> 
      <div align="center">操作</div></td>
  </tr>
  <%
do while rs.eof=false
%>
  <tr bgcolor="#FFFFFF" class="txt"> 
    <td> 
      <div align="center"> <font color="#FFFFFF"><%=rs("newsinfo")%></font></div></td>
    <td> 
      <div align="center"><font color="#FFFFFF"><%=rs("ip")%></font></div></td>
    <td> 
      <div align="center"><font color="#FFFFFF"><%=rs("mail")%></font></div></td>
    <td height="20"> 
      <div align="center" class="txt"><font color="#FFFFFF"><a href="newspl.asp?act=del&id=<%=rs("id")%>">删除</a></font></div></td>
  </tr>
  <%
rs.movenext
loop
rs.close
set rs=nothing
conn.close:set rs=nothing
%>
</table>
