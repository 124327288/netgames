<!--#include file="Inc/Config.asp" -->
<!--#include file="Inc/md5VB.asp" -->
<%CxGame.Pay()%>
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
      <td height="239"> 
        <fieldset style="width:370;height=160" align="center">
        <legend>请输入卡号和密码进行充值</legend>
	<br>
        <table width="95%" border="0" align="center" cellpadding="7" cellspacing="0" class="box">
          <tr> 
            <td width="92"> <div align="center">这里输入卡号:</div></td>
            <td width="211"> <input name="CardCode" type="text" class="input2" id="CardCode" size="29"> 
            </td>
          </tr>
          <tr> 
            <td><div align="center">这里输入密码:</div></td>
            <td><div align="left"> 
                <input name="CardPass" type="text" class="input2" id="CardPass" size="29">
                <input name="login" type="hidden" id="login3" value="true">
              </div></td>
          </tr>
          <tr> 
            <td colspan="2"> <div align="center"> 
                <input name="Submit" type="submit" class="bsys2" value="确定进行充值">
              </div></td>
          </tr>
          <tr> 
            <td colspan="2"><div align="center"><a href="http://www.5250k.com/payhelp.asp" target="_blank">点这里查看相关充值帮助</a></div></td>
          </tr>
        </table>
      </fieldset>
</td>
</form>
</tr>

</table>
</body>
</html>
