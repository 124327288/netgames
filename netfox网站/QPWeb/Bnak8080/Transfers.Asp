<!--#include file="Inc/Config.asp" -->
<!--#include file="Inc/md5VB.asp" -->
<%

IF CxGame.GetInfo(0,"form","Submit")="刷新银子" Then
	Session("Deposits")=Empty	
	Session("money")=Empty
	Response.Redirect Request.ServerVariables("HTTP_REFERER")
	Response.End
End IF	
CxGame.Transfers()
%>

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
<fieldset style="width:370;height=60" align="center"><legend>以下是您的财务信息</legend>
        <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="box">
          <tr> 
            <td width="66"> 
              <div align="center" id="userid">银行存款:</div></td>
            <td> <input name="Deposits" type="text" id="Deposits2" value="<%=Session("Deposits")%>" class="xu" size="14" readonly="true">
            </td>
          </tr>
          <tr> 
            <td width="66">
<div align="center">现有银子:</div></td>
            <td><input name="money" type="text" id="money" value="<%=Session("money")%>" size="14" class="xu" readonly="true">
              <input name="Submit" type="submit" class="bsys" id="Submit" value="刷新银子"> </td>
          </tr>
        </table>
      </fieldset>
<fieldset style="width:370;height=170" align="center">
<br>
        <legend>转帐服务</legend>
		<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" class="box">
          <tr> 
            <td width="50"> <div align="center" id="userid">收款人:</div></td>
            <td> <input name="UserName" type="text" size="12"> 
            </td>
            <td width="70">收款人ID:</td>
            <td> <input name="UserID" type="text" id="UserID" size="12"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFCC"> 
            <td colspan="4"> <div align="center"><font color="#990000">注意:为了防止您转错帐,收款人与收款人ID必须匹配!</font></div></td>
          </tr>
        </table>
        <table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" class="box">
          <tr> 
            <td width="66"> <div align="center">转帐金额:</div></td>
            <td width="232"> <input name="money2" type="text" class="input" id="money23" value="0" style="ime-mode:disabled" onKeyDown="if(event.keyCode==13)event.keyCode=9"> 
              <input name="login" type="hidden" id="login" value="true"> </td>
          </tr>
          <tr> 
            <td width="66">
<div align="center">银行密码:</div></td>
            <td><input name="password" type="password" class="input" id="password2"></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td><input name="Submit" type="submit" class="bsys" value="确定转帐"></td>
          </tr>
        </table>
        </fieldset>
</td>
</form>
</tr>

</table>
</body>
</html>
