<!--#include file="conn.asp"-->
<!--#include file="md5.asp"-->
<%
dim Action,FoundErr,ErrMsg
Action=trim(request("Action"))
if Action="Login" then
	call ChkLogin()
elseif Action="Logout" then
	call Logout()
else
	call main()
end if
if FoundErr=True then
	call WriteErrMsg()
end if

sub main()
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>管理员登录</title>
<link rel="stylesheet" href="Admin_Style.css">
<script type="text/javascript">
<!--
function SetFocus()
{
if (document.Login.UserName.value=="")
	document.Login.UserName.focus();
else
	document.Login.UserName.select();
}
function CheckForm()
{
	if(document.Login.UserName.value=="")
	{
		alert("请输入用户名！");
		document.Login.UserName.focus();
		return false;
	}
	if(document.Login.Password.value == "")
	{
		alert("请输入密码！");
		document.Login.Password.focus();
		return false;
	}

}

function CheckBrowser() 
{
  var app=navigator.appName;
  var verStr=navigator.appVersion;
  if (app.indexOf('Netscape') != -1) {
    alert("<%=SiteName%>提示你,你使用的是Netscape浏览器，可能会导致无法使用后台的部分功能。建议您使用 IE6.0 或以上版本。");
  } 
  else if (app.indexOf('Microsoft') != -1) {
    if (verStr.indexOf("MSIE 3.0")!=-1 || verStr.indexOf("MSIE 4.0") != -1 || verStr.indexOf("MSIE 5.0") != -1 || verStr.indexOf("MSIE 5.1") != -1)
      alert("<%=SiteName%>提示你,您的浏览器版本太低，可能会导致无法使用后台的部分功能。建议您使用 IE6.0 或以上版本。");
  }
}
//-->
</script>
</head>
<body>
<p>&nbsp;</p>
<p>&nbsp;</p>
<form name="Login" action="Admin_Login.asp" method="post" target="_parent" onSubmit="return CheckForm();">
  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2"><img src="Images/Admin_Login1.gif" width="600" height="126"></td>
    </tr>
    <tr>
      <td width="508" valign="top" background="Images/Admin_Login2.gif"><table width="510" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td height="37" colspan="7" width="506">&nbsp;</td>
          </tr>
          <tr> 
            <td width="69" rowspan="2">&nbsp;</td>
            <td width="125"><font color="#043BC9">用户名称：</font></td>
            <td width="36" rowspan="2">&nbsp;</td>
            <td width="130"><font color="#043BC9">用户密码：</font></td>
            <td width="32">&nbsp;</td>
            <td width="56"><font color="#043BC9">&nbsp;验证码：</font></td>
          </tr>
          <tr> 
            <td width="125"><input name="UserName"  type="text"  id="UserName" maxlength="20" style="width:110px; BORDER-RIGHT: #F7F7F7 0px solid; BORDER-TOP: #F7F7F7 0px solid; FONT-SIZE: 9pt; BORDER-LEFT: #F7F7F7 0px solid; BORDER-BOTTOM: #c0c0c0 1px solid; HEIGHT: 16px; BACKGROUND-COLOR: #F7F7F7" onmouseover="this.style.background='#ffffff';" onmouseout="this.style.background='#F7F7F7'" onFocus="this.select(); "></td>
            <td width="130"><input name="Password"  type="password" maxlength="20" style="width:110px; BORDER-RIGHT: #F7F7F7 0px solid; BORDER-TOP: #F7F7F7 0px solid; FONT-SIZE: 9pt; BORDER-LEFT: #F7F7F7 0px solid; BORDER-BOTTOM: #c0c0c0 1px solid; HEIGHT: 16px; BACKGROUND-COLOR: #F7F7F7" onmouseover="this.style.background='#ffffff';" onmouseout="this.style.background='#F7F7F7'" onFocus="this.select(); "></td>
            <td width="32">&nbsp;</td>
            <td width="56">
<input  name="code" type="text" id="code"  maxlength="4" style="width: 46; font-size: 9pt; height: 16; background-color: #F7F7F7; border-left: 0px solid #F7F7F7; border-right: 0px solid #F7F7F7; border-top: 0px solid #F7F7F7; border-bottom: 1px solid #c0c0c0" onmouseover="this.style.background='#ffffff';" onmouseout="this.style.background='#F7F7F7'" onFocus="this.select(); " size="20">
</td>
            <td width="48"><img src="code_img.asp"></td>
          </tr>
        </table></td>
      <td><input type='hidden' name='Action' value='Login'>
        <input type="image" name="Submit" src="Images/Admin_Login3.gif" style="width:92px; HEIGHT: 126px;"></td>
    </tr>
  </table>
  </form>
<script language="JavaScript" type="text/JavaScript">
CheckBrowser();
SetFocus(); 
</script>
</body>
</html>
<%
end sub

sub ChkLogin()
	dim sql,rs
	dim username,password,CheckCode,RndPassword
	
	If Session("GetCode")<>Request("code") Then
		FoundErr=True
		Session("GetCode") = "scsc"
		ErrMsg=ErrMsg & "验证码不对，请正确输入验证码"
	End If

	Session("GetCode")="cscs"
	username=replace(trim(request("username")),"'","")
	password=replace(trim(Request("password")),"'","")
	CheckCode=replace(trim(Request("CheckCode")),"'","")
	if UserName="" then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>用户名不能为空！</li>"
	end if
	if Password="" then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>密码不能为空！</li>"
	end if

	if FoundErr=True then
		exit sub
	end if
	password=md5((password),32)
	set rs=server.createobject("adodb.recordset")
	sql="select * from qq_Admin where password='"&password&"' and username='"&username&"'"
	rs.open sql,DbAccConn,1,3
	if rs.bof and rs.eof then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>用户名或密码错误！！！</li>"
	else
		if password<>rs("password") then
			FoundErr=True
			ErrMsg=ErrMsg & "<br><li>用户名或密码错误！！！</li>"
		end if
	end if
	if FoundErr=True then
		session("AdminName")=""
		session("AdminPassword")=""
		rs.close
		set rs=nothing
		exit sub
	end if
	rs("LastLoginIP")=Request.ServerVariables("REMOTE_ADDR")
	rs("LastLoginTime")=now()
	rs("LoginTimes")=rs("LoginTimes")+1
	rs.update
	session("AdminName")=rs("username")
	session("AdminPassword")=rs("Password")
	session("AdminSet")=rs("AdminSet")
	
    Response.Cookies("QPAdminUserID")= rs("username")
    Response.Cookies("QPAdminUserPasswd")=rs("Password")
    
	rs.close
	set rs=nothing
	Response.Redirect "Admin_Index.asp"
end sub

sub Logout()
	session("AdminName")=""
	session("AdminPassword")=""
	
	Response.Cookies("QPAdminUserID")= ""
    Response.Cookies("QPAdminUserPasswd")=""
    Response.Cookies("QPAdminUserID").Expires = DateAdd("m",-1,now())
    Response.Cookies("QPAdminUserPasswd").Expires = DateAdd("m",-1,now())
    
	Response.Redirect "../Index.asp"
end sub

sub WriteErrMsg()
	dim strErr
	strErr=strErr & "<html><head><title>错误信息</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
	strErr=strErr & "<link href='Admin_Style.css' rel='stylesheet' type='text/css'></head><body>" & vbcrlf
	strErr=strErr & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbcrlf
	strErr=strErr & "  <tr align='center'><td height='22' class='title'><strong>错误信息</strong></td></tr>" & vbcrlf
	strErr=strErr & "  <tr><td height='100' class='tdbg' valign='top'><b>产生错误的可能原因：</b><br>" & errmsg &"</td></tr>" & vbcrlf
	strErr=strErr & "  <tr align='center'><td class='tdbg'><a href='Admin_Login.asp'>&lt;&lt; 返回登录页面</a></td></tr>" & vbcrlf
	strErr=strErr & "</table>" & vbcrlf
	strErr=strErr & "</body></html>" & vbcrlf
	response.write strErr
end sub
%>
