<!--#include file="Inc/Config.asp" -->
<!--#include file="Inc/md5VB.asp" -->
<%CxGame.Login()%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<link href="css.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" scroll="no">
<table width="380" height="240" cellpadding="5" cellspacing="0">
  <tr>
<form name="form1" method="post" action="">
<td>
<fieldset style="width:370;height=150" align="center"><legend>������ID��������е���</legend>
        <table width="100%" border="0" align="center" cellpadding="10" cellspacing="0" class="box">
          <tr> 
            <td width="66"> <div align="center" id="userid">�û�ID:</div></td>
            <td width="232"> <input name="UserID" type="text" class="input" id="UserID"> 
            </td>
          </tr>
          <tr> 
            <td> <div align="center">�� ��:</div></td>
            <td> <input name="PassWord" type="password" class="input" id="PassWord"  value="">
              <input name="login" type="hidden" id="login4" value="true"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td><input type="submit" name="Submit" value=" ���� "></td>
          </tr>
        </table>
      </fieldset>
</td>
</form>
</tr>

</table>
</body>
</html>
