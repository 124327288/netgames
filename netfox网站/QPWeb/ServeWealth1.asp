<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<style type="text/css">
<!--
body {
	font-size: 13px;
}
td {
	font-size: 13px;
}
-->
</style>
</head>

<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0">
<table width="360" height="240" cellpadding="5" cellspacing="0">
  <tr>
<form name="form1" method="post" action="">
<td>
<fieldset style="width:350;height=130" align="center"><legend>以下是您的财务信息</legend>
      <table width="100%" border="0" align="center" cellpadding="10" cellspacing="0" class="box">
        <tr> 
          <td width="66"> <div align="center" id="userid">银行存款:</div></td>
          <td width="232"> <input name="Deposits" type="text" class="input" id="Deposits" readonly="true"> 
            <a href="R.asp?Act=R">刷新银子</a> </td>
        </tr>
        <tr> 
          <td> <div align="center">现有银子:</div></td>
          <td> <input name="money" type="text" class="input" id="money" readonly="true"></td>
        </tr>
      </table>
      </fieldset>
<br>
<fieldset style="width:350;height=100" align="center"><legend>存入银子</legend>
        <table width="100%" border="0" align="center" cellpadding="10" cellspacing="0" class="box">
          <tr> 
            <td width="66"> <div align="center">存入银子:</div></td>
            <td width="232"> <input name="money2" type="text" class="input" id="money23" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <input name="login" type="hidden" id="login4" value="true"> </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td><input type="submit" name="Submit" value="确定存入银子"></td>
          </tr>
        </table>
        </fieldset>
</td>
</form>
</tr>

</table>
</body>
</html>
