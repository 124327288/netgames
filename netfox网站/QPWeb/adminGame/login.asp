<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>用户登陆</title>
<script>
<!--
function sf(){document.form1.admin.focus();}
// -->
</script>

<style type="text/css">
<!--
.txt {
	font-family: "宋体";
	font-size: 14px;
	text-decoration: none;
}
input {
	font-size: 9pt;
	color: #000000;
	text-decoration: none;
	background-color: #FFFFFF;
	border: 1px solid #999999;
}
-->
</style>
<style type="text/css">
<!--
a:link {
	font-size: 9pt;
	color: #0000FF;
	text-decoration: none;
}
a:hover {
	font-size: 12px;
	color: #FF0000;
	text-decoration: none;
}
a:active {
	font-size: 12px;
	color: #0000CC;
	text-decoration: none;
}
a:visited {
	font-size: 12px;
	color: #0000FF;
	text-decoration: none;
}
-->
</style>
<link href="usercss.css" rel="stylesheet" type="text/css">
</head>

<body onload=sf() bgcolor="#5578b8">
<form name="form1" method="post" action="loginok.asp">
  <p>&nbsp;</p>
  <p align="center">&nbsp;</p>
  <p align="center">&nbsp;</p>
  <table width="360" border="0" align="center" cellpadding="0" cellspacing="1">
    <tr> 
      <td bgcolor="#666666"> <div align="center"> 
          <table width="100%" border="1" cellpadding="3" cellspacing="0" bordercolor="#f1f5fe" bordercolorlight="#f0f4fe">
            <tr bgcolor="#cfdded" class="txt"> 
              <td height="40" colspan="3"> <div align="center"><font color="#000000">管理员请从下面进入</font></div></td>
            </tr>
            <tr bgcolor="#f0f5f9" class="txt"> 
              <td width="25%" height="30" bgcolor="#f0f5f9" class="txt"> <div align="center" class="txt">用户名:</div></td>
              <td width="55%" bgcolor="#f0f5f9"> <div align="center"> 
                  <input name="admin" type="text" id="admin" style="width:150px; height:18px; z-index:1" autocomplete=off>
                </div></td>
              <td width="20%" height="30" bgcolor="#f0f5f9"> <div align="center">　 
                </div></td>
            </tr>
            <tr bgcolor="#f0f5f9" class="txt"> 
              <td height="30" bgcolor="#f0f5f9" class="txt"> <div align="center" class="txt">密 
                  码:</div></td>
              <td> <div align="center"> 
                  <input name="password" type="password" id="password" style="width:150px; height:18px; z-index:1">
                </div></td>
              <td height="30"> <div align="center">　</div></td>
            </tr>
            <tr bgcolor="#e3ecf5" class="txt"> 
              <td height="30" colspan="3"> <div align="center"> 
                  <input type="submit" name="Submit" value="提交">
                  　 
                  <input type="reset" name="Submit2" value="重置">
                </div></td>
            </tr>
          </table>
        </div></td>
    </tr>
  </table>
  <p align="center">&nbsp;</p>
</form>
</body>
</html>
