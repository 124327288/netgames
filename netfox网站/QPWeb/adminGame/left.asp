<!--#include file="chak.asp"-->
<html>
<head>
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=gb2312">
<link rel=stylesheet href=css.css type="text/css">

<style type="text/css">
<!--
a:link {
	color: #000000;
	text-decoration: none;
}
-->
</style>
<style type="text/css">
<!--
a:visited {
	color: #000000;
	text-decoration: none;
}
-->
</style>
</head>
<body leftmargin=0 topmargin=0 bgcolor="#5578b8">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="55" bgcolor="#cfdded" class="txt"> <div align="center" class="unnamed3"><strong>��̨����ϵͳ</strong></div></td>
    <td width="2" rowspan="12" bgcolor="#FFFFFF" class="txt">&nbsp; </td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"><div align="center"><a href="classedit.asp" target="main">��վ�������</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="newsadd.asp" target="main">����������Ϣ</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="newsedit.asp" target="main">������Ϣ����</a></div></td>
  </tr>
  <!--<%if len(session("user"))=1 then%>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="../guestbook/GB_VIEW.ASP" target="main">���Թ���</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="../htmledit/Admin_UploadFile.asp" target="main">�����ϴ�ͼƬ</a></div></td>
  </tr>
  <%end if%>-->
 <!-- <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="user.asp" target="main">��̨�û�����</a></div></td>
  </tr>-->
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="logout.asp" target="main">�˳���̨����</a></div></td>
  </tr>
  <tr> 
    <td height="150" bgcolor="#cfdded" class="txt"> <div align="center"> 
        <%if len(session("user"))>1 then%>
        ���,����<font color="#FF0000">[<%=session("admin2")%>]</font>��Ĺ���Ա <br>
        ��ӵ�д˷��༰�˷���������<br>
        �ӷ����:����\����\����\����Ա<br>
        ����,��,ɾȨ��<br>
        <%else%>
        ���,<font color="#FF0000">��������Ա</font><br>
        ���Ա�ϵͳ����ȫ����Ȩ��<br>
        <%end if%>
        <br>
        <br>
      </div></td>
  </tr>
</table>
</body>
</html>