<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->


<%
'response.write "�Բ�������Ȩ������" 
'response.end
%>
<SCRIPT language=javascript>
function ConfirmDel()
{
   if(confirm("ȷ��Ҫɾ���˷��༰�˷��������е��ӷ��༰������һ��ɾ�������ָܻ���"))
     return true;
   else
     return false;
	 
}
</SCRIPT>
<%
act=request("act")
if act="del" then
id=request("id")
set del=server.CreateObject("adodb.recordset")
delsql="delete from class where classcode like '"&id&"%'"
del.open delsql,conn,1,3
set del2=server.CreateObject("adodb.recordset")
delsql2="delete from news where classcode like '"&id&"%'"
del2.open delsql2,conn,1,3
set del3=server.CreateObject("adodb.recordset")
delsql3="delete from newshf where classcode like '"&id&"%'"
del3.open delsql3,conn,1,3
set del4=server.CreateObject("adodb.recordset")
delsql4="delete from admin where classcode like '"&id&"%'"
del4.open delsql4,conn,1,3
word="ɾ�����༰�˷��������е��ӷ��༰����,���۳ɹ�"
URL=Request.ServerVariables("HTTP_REFERER")
Response.Write "<script language=JavaScript1.1>alert(' "& word &" ');" 
Response.Write " document.location='"& URL&"';</script>" 
Response.End
end if
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<link href="css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
a:link {
	color: #FF0000;
	text-decoration: none;
	font-weight: normal;
}
a:active {
	color: #FF0000;
	text-decoration: none;
}
a:visited {
	color: #FF0000;
	text-decoration: none;
}
.qw {
	font-size: 13px;
	color: #000000;
	text-decoration: none;
	font-weight: normal;
}
-->
</style>
</head>

<body topmargin="30">
<form name="form1" method="post" action="classedit.asp?act=del">
  <table width="600" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td bgcolor="666666">
        <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td height="50" colspan="2" bgcolor="efefef"> 
              <div align="center"> 
                <p class="txt">�༩���·���<br>
                  <br>
                  (<font color="#FF0000">ע��:����������ƿ����޸Ĵ˷���,���[<font color="#0000FF">ɾ</font>]��ɾ���˷��༰�˷��������е��ӷ��༰����</font>) 
                  <br>
                  <br>
                  <font color="#FF0000">������Ա��,����Աֻ�ɹ��������µ��ӷ���</font></p>
              </div></td>
          </tr>
          <tr> 
            <td width="100" bgcolor="#FFFFFF" class="qw"> 
              <div align="center">�������νṹͼ:</div></td>
            <td width="412" bgcolor="#FFFFFF" class="qw"><br>
              <%
			  	  classcode=session("user")
				  set rt=server.CreateObject("adodb.recordset")
				  sqt="select * from class where classcode like '"&classcode&"%' order by classcode"
				  rt.open sqt,conn,1,1
				  do while not rt.eof
				  spr=""
				  for i=6 to len(rt("classcode")) step 3
				  spr=spr&"��   "
				  next
				  sizep=len(rt("classcode"))
				  %>
              &nbsp;&nbsp;&nbsp;&nbsp;<%=spr%>��<a href="classmm.asp?id=<%=rt("id")%>" title='ǰ̨���ŵ��ô���:class=<%=rt("classcode")%>'><%=rt("classname")%></a>
              <input type="text" class="inp" value="<%=rt("classcode")%>" size="<%=sizep%>">
              &nbsp;&nbsp;&nbsp;&nbsp;[<a href="classedit.asp?act=del&id=<%=rt("classcode")%>" onClick="return ConfirmDel();"><font color="#0000CC">ɾ</font></a>] 
              <br> 
              <%
				  rt.movenext
				  loop
				  %><br>
            </td>
          </tr>
          <tr> 
            <td height="28" colspan="2" bgcolor="#FFFFFF" class="qw"> <div align="center"><a href="classadd.asp">��������</a></div></td>
          </tr>
        </table>
      </td>
  </tr>
</table></form>
</body>
</html>
