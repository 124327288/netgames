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
    <td height="55" bgcolor="#cfdded" class="txt"> <div align="center" class="unnamed3"><strong>后台管理系统</strong></div></td>
    <td width="2" rowspan="12" bgcolor="#FFFFFF" class="txt">&nbsp; </td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"><div align="center"><a href="classedit.asp" target="main">网站分类管理</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="newsadd.asp" target="main">新增文章信息</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="newsedit.asp" target="main">文章信息管理</a></div></td>
  </tr>
  <!--<%if len(session("user"))=1 then%>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="../guestbook/GB_VIEW.ASP" target="main">留言管理</a></div></td>
  </tr>
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="../htmledit/Admin_UploadFile.asp" target="main">管理上传图片</a></div></td>
  </tr>
  <%end if%>-->
 <!-- <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="user.asp" target="main">后台用户管理</a></div></td>
  </tr>-->
  <tr> 
    <td height="38" bgcolor="#f0f5f9" class="txt"> <div align="center"><a href="logout.asp" target="main">退出后台管理</a></div></td>
  </tr>
  <tr> 
    <td height="150" bgcolor="#cfdded" class="txt"> <div align="center"> 
        <%if len(session("user"))>1 then%>
        你好,你是<font color="#FF0000">[<%=session("admin2")%>]</font>类的管理员 <br>
        你拥有此分类及此分类下所有<br>
        子分类的:文章\评论\分类\管理员<br>
        的增,修,删权限<br>
        <%else%>
        你好,<font color="#FF0000">超级管理员</font><br>
        您对本系统有完全控制权限<br>
        <%end if%>
        <br>
        <br>
      </div></td>
  </tr>
</table>
</body>
</html>