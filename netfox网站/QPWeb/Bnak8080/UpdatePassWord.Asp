<!--#include file="Inc/Config.asp" -->
<!--#include file="Inc/md5VB.asp" -->
<%CxGame.UpdatePassWord("InsurePass")%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<link href="css.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" scroll="no">
<script language="javascript" src="passwordstrength.js"></script>
<table width="380" height="240" cellpadding="5" cellspacing="0">
<tr>
<form name="form1" method="post" action="">
      <td height="239"> 
        <fieldset style="width:370;height=220" align="center">
        <legend>修改密码 安全的密码应该是:数字+字母+符号(括号#@等)</legend>
        <table width="95%" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td width="77"> <div align="center" id="userid">银行原密码:</div></td>
            <td width="232"> <input name="UserName" type="password" class="input" id="UserName"> 
            </td>
          </tr>
          <tr> 
            <td width="77">
<div align="center">您的密码度:</div></td>
            <td><div align="left">
	<script language="javascript">
		var ps = new PasswordStrength();
		ps.setSize("220","20");
		ps.setMinLength(1);
	</script>
</div></td>
          </tr>
          <tr> 
            <td width="77"> <div align="center">银行新密码:</div></td>
            <td> <input name="PassWord" type="password"  id="pwd" class="input" onKeyUp="ps.update(this.value);"></td>
          </tr>
          <tr> 
            <td width="77"> <div align="center">确定新密码:</div></td>
            <td><input name="PassWord2" type="password" class="input" id="PassWord22"> 
              <input name="login" type="hidden" id="login2" value="true"></td>
          </tr>
          <tr> 
            <td colspan="2"> <div align="center"> 
                <input name="Submit" type="submit" class="bsys2" value="修改银行密码">
              </div></td>
          </tr>
          <tr> 
            <td colspan="2"><div align="center"><a href="http://www.5250k.com/Passwordprotection.Asp" target="_blank">为了您的密码安全,点这里申请密码保护</a></div></td>
          </tr>
        </table>
      </fieldset><br><br>
        <div align="center">提示:银行密码请不要和登入密码设成一样</div></td>
</form>
</tr>

</table>
</body>
</html>
