<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<script language="JavaScript">
<!--
function checkForm()
{
	  	if (document.add.classcode.value=="") {
		alert("���������·���.");
		document.add.classcode.focus();
		return false;
	}
	if (document.add.newstitle.value=="") {
		alert("���������±���.");
		document.add.newstitle.focus();
		return false;
	}	
	return true
}
//-->
</script>
<%
id=request("id")
if id="" then
response.write("�Բ���,����û��ѡ��Ҫ�޸ĵ�����")
response.end
end if
set rs=server.createobject("adodb.recordset")
sql="select * from news where id="&id
rs.open sql,conn,1,1
code=rs("classcode")
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<link href="../inc/STYLE.CSS" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.hend {
	display: none;
}
-->
</style>
</head>
<body bgcolor="#5578b8" topmargin="0">
<form action="newsmmok.asp?id=<%=id%>" method="post" name=add id="add" onSubmit="return checkForm()">
  <table width="100%" height="587" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#575757" bordercolordark="#FFFFFF">
    <tr bgcolor="#cfdded"> 
      <td height="40" colspan="4"> 
        <p align="center"><strong><font color="#000000">�޸�����</font></strong></td>
    </tr>
    <tr> 
      <td width="145" height="40" bgcolor="#FFFFFF" class="txt"> <div align="center">���·���</div></td>
      <td colspan="3" bgcolor="#FFFFFF" class="txt"> �� 
        <select name="classcode" id="classcode">
          <option value="" selected>��ѡ�����·��ࡡ����������������������</option>
          <%
		          classcode=session("user")
				  set rt=server.CreateObject("adodb.recordset")
				  sqt="select * from class order by classcode"
				  rt.open sqt,conn,1,1
				  do while not rt.eof
				  spr=""
				  for i=6 to len(rt("classcode")) step 3
				  spr=spr&"��"
				  next
				  %>
          <option value="<%=rt("classcode")%>" <%if rt("classcode")=code then%> selected<%end if%>><%=spr%>��<%=rt("classname")%></option>
          <%
				  rt.movenext
				  loop
				  %>
        </select> <font color="#FF0000">*(������Ա��,����Աֻ�ɹ��������µ�����)</font></td>
    </tr>
    <tr> 
      <td height="40" bgcolor="#FFFFFF" class="txt"> <div align="center">���±���</div></td>
      <td colspan="3" bgcolor="#FFFFFF"> <div align="left"> �� 
          <input name="newstitle" type="text" id="pic43" value="<%=rs("newstitle")%>" size="40">
          <font color="#FF0000">* 
          <input name="keyword" type="hidden" id="keyword" value="<%=rs("keyword")%>">
          �Ƽ��� 
          <select name="pl" id="pl">
            <%if rs("pl")<>0 then%>
            <option value="1">��</option>
            <option value="0">��</option>
            <%else%>
            <option value="0">��</option>
            <option value="1">��</option>
            <%end if%>
          </select>
          </font></div></td>
    </tr>
    <tr class="hend"> 
      <td height="40" bgcolor="#FFFFFF"> 
        <div align="center">���³���</div></td>
      <td bgcolor="#FFFFFF"> 
        <div align="left"> �� 
          <input name="newscu" type="text" id="pic43" value="<%=rs("newscu")%>" size="20">
        </div></td>
      <td bgcolor="#FFFFFF"> 
        <div align="center"> 
          <p class="txt">�Ƿ���������</p>
        </div></td>
      <td bgcolor="#FFFFFF"> 
        <div align="center"> </div></td>
    </tr>
    <tr class="hend"> 
      <td height="40" bgcolor="#FFFFFF"> 
        <div align="center">��������</div></td>
      <td width="242" bgcolor="#FFFFFF"> 
        <div align="left"> �� 
          <input name="newszz" type="text" id="newszz" value="<%=rs("newszz")%>" size="20">
        </div></td>
      <td width="138" bgcolor="#FFFFFF"> 
        <div align="center"> 
          <p class="txt">����ʱ��</p>
        </div></td>
      <td width="166" bgcolor="#FFFFFF"> 
        <div align="center"> 
          <input name="newsdate" type="text" id="newsdate" value="<%=date()%>" size="20">
        </div></td>
    </tr>
    <tr bgcolor="#FFFFFF" class="hend"> 
      <td height="40"> 
        <div align="center"> 
          <p class="txt">�Ƿ�ӵ���ҳ�������ڣ�</p>
        </div></td>
      <td height="17" colspan="3" bgcolor="#FFFFFF"> 
        <div align="left"> �� 
          <input name="top" type="checkbox" id="id" value="1" <%if rs("top2")=true then%>checked<%end if%>>
        </div>
        <div align="center" class="txt"></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td height="35"><div align="center"> 
          <p class="txt">���ͼƬ</p>
        </div></td>
      <td height="35" colspan="3">�� 
        <input name="pic" type="text" id="pic" value="<%=rs("down")%>" size="60"></td>
    </tr>
    <tr bgcolor="#cfdded"> 
      <td height="35" colspan="4"> 
        <div align="center">�������ݣ�<font color="#FF0000">*</font></div></td>
    </tr>
    <tr> 
      <td height="200" colspan="4" valign="middle"><p align="center"> 
          <IFRAME ID="eWebEditor1" src="../htmledit/ewebeditor.asp?id=newsinfo&style=s_light&savefilename=myText2" frameborder="0" scrolling="no" width="100%" height="400"></IFRAME>
          <input name="newsinfo" type="hidden" id="newsinfo" value='<%=rs("newsinfo")%>'>
      </td>
    </tr>
    <tr> 
      <td height="35" colspan="4" bgcolor="#F7F7F7"> <p align="center"> 
          <input type="submit" value="ȷ ��" name="B1"  class=button>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
          <input type="reset" value="�� д" name="B2"  class=button>
      </td>
    </tr>
  </table>    
  </form>
</body>
</html>
<%rs.close
set rs=nothing
%>
