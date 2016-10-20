<!--#include file="conn.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<!--#include file="function.asp"-->
<%


If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteErrMsg("没有系统管理权限!")
Response.End
End If 

'声明待检测数组
Dim ObjTotest(26,4)
ObjTotest(0,0) = "MSWC.AdRotator"
ObjTotest(1,0) = "MSWC.BrowserType"
ObjTotest(2,0) = "MSWC.NextLink"
ObjTotest(3,0) = "MSWC.Tools"
ObjTotest(4,0) = "MSWC.Status"
ObjTotest(5,0) = "MSWC.Counters"
ObjTotest(6,0) = "IISSample.ContentRotator"
ObjTotest(7,0) = "IISSample.PageCounter"
ObjTotest(8,0) = "MSWC.PermissionChecker"
ObjTotest(9,0) = "Scripting.FileSystemObject"
ObjTotest(9,1) = "(FSO 文本文件读写)"
ObjTotest(10,0) = "adodb.connection"
ObjTotest(10,1) = "(ADO 数据对象)"
	
ObjTotest(11,0) = "SoftArtisans.FileUp"
ObjTotest(11,1) = "(SA-FileUp 文件上传)"
ObjTotest(12,0) = "SoftArtisans.FileManager"
ObjTotest(12,1) = "(SoftArtisans 文件管理)"
ObjTotest(13,0) = "LyfUpload.UploadFile"
ObjTotest(13,1) = "(刘云峰的文件上传组件)"
ObjTotest(14,0) = "Persits.Upload.1"
ObjTotest(14,1) = "(ASPUpload 文件上传)"
ObjTotest(15,0) = "w3.upload"
ObjTotest(15,1) = "(Dimac 文件上传)"

ObjTotest(16,0) = "JMail.SmtpMail"
ObjTotest(16,1) = "(Dimac JMail 邮件收发) <a href='http://www.ajiang.net'>中文手册下载</a>"
ObjTotest(17,0) = "CDONTS.NewMail"
ObjTotest(17,1) = "(虚拟 SMTP 发信)"
ObjTotest(18,0) = "Persits.MailSender"
ObjTotest(18,1) = "(ASPemail 发信)"
ObjTotest(19,0) = "SMTPsvg.Mailer"
ObjTotest(19,1) = "(ASPmail 发信)"
ObjTotest(20,0) = "DkQmail.Qmail"
ObjTotest(20,1) = "(dkQmail 发信)"
ObjTotest(21,0) = "Geocel.Mailer"
ObjTotest(21,1) = "(Geocel 发信)"
ObjTotest(22,0) = "IISmail.Iismail.1"
ObjTotest(22,1) = "(IISmail 发信)"
ObjTotest(23,0) = "SmtpMail.SmtpMail.1"
ObjTotest(23,1) = "(SmtpMail 发信)"
	
ObjTotest(24,0) = "SoftArtisans.ImageGen"
ObjTotest(24,1) = "(SA 的图像读写组件)"
ObjTotest(25,0) = "W3Image.Image"
ObjTotest(25,1) = "(Dimac 的图像读写组件)"

public IsObj,VerObj

'检查预查组件支持情况及版本

dim i
for i=0 to 25
	on error resume next
	IsObj=false
	VerObj=""
	dim TestObj
	set TestObj=server.CreateObject(ObjTotest(i,0))
	If -2147221005 <> Err then		
		IsObj = True
		VerObj = TestObj.version
		if VerObj="" or isnull(VerObj) then VerObj=TestObj.about
	end if
	ObjTotest(i,2)=IsObj
	ObjTotest(i,3)=VerObj
next

'检查组件是否被支持及组件版本的子程序
sub ObjTest(strObj)
	on error resume next
	IsObj=false
	VerObj=""
	dim TestObj
	set TestObj=server.CreateObject (strObj)
	If -2147221005 <> Err then		
		IsObj = True
		VerObj = TestObj.version
		if VerObj="" or isnull(VerObj) then VerObj=TestObj.about
	end if	
End sub
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="Admin_Style.css">
<TITLE>服务器信息</TITLE>
<style>
<!--
BODY
{
	FONT-FAMILY: 宋体;
	FONT-SIZE: 9pt
}
TD
{
	FONT-SIZE: 9pt
}
A
{
	COLOR: #000000;
	TEXT-DECORATION: none
}
A:hover
{
	COLOR: #009286;
	TEXT-DECORATION: underline
}
.input
{
	BORDER: #009286 1px solid;
	FONT-SIZE: 9pt;
	BACKGROUND-color: #F8FFF0
}
.backs
{
	BACKGROUND-COLOR: #009286;
	COLOR: #ffffff;

}
.backq
{
	BACKGROUND-COLOR: #E1F4EE;
}
.backc
{
	BACKGROUND-COLOR: #009286;
	BORDER: medium none;
	COLOR: #ffffff;
	HEIGHT: 18px;
	font-size: 9pt
}
.fonts
{
	COLOR: red
}
-->
</STYLE>
</HEAD>
<body leftmargin="2" topmargin="0" marginwidth="0" marginheight="0">
<div align="center">
  <table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
    <tr align="center">
      <td height=25 class="topbg"><strong><%=SiteName%>----服务器信息</strong>  
    </tr>
    <tr>
      <td height=23 class="tdbg">
        <font class=fonts>是否支持ASP</font> <br>
出现以下情况即表示您的空间不支持ASP： <br>
1、访问本文件时提示下载。 <br>
2、访问本文件时看到类似“&lt;%@ Language="VBScript" %&gt;”的文字。 </td>
    </tr>
  </table>
</div>
<br>

<font class=fonts>服务器的有关参数</font>
  <table border=0 width=100% cellspacing=0 cellpadding=0 bgcolor="#ffffff">
<tr><td>

	<table width=100% border=0 cellpadding=3 cellspacing=1 class="border">
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器名</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_NAME")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器IP</td>
		<td>&nbsp;<%=Request.ServerVariables("LOCAL_ADDR")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器端口</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_PORT")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器时间</td>
		<td>&nbsp;<%=now%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;IIS版本</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_SOFTWARE")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;脚本超时时间</td>
		<td>&nbsp;<%=Server.ScriptTimeout%> 秒</td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;本文件路径</td>
		<td>&nbsp;<%=server.mappath(Request.ServerVariables("SCRIPT_NAME"))%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器CPU数量</td>
		<td>&nbsp;<%=Request.ServerVariables("NUMBER_OF_PROCESSORS")%> 个</td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器解译引擎</td>
		<td>&nbsp;<%=ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;服务器操作系统</td>
		<td>&nbsp;<%=Request.ServerVariables("OS")%></td>
	  </tr>
	</table>

</td></tr>
</table>
<br>
<font class=fonts>组件支持情况</font>
<%
Dim strClass
	strClass = Trim(Request.Form("classname"))
	If "" <> strClass then
	Response.Write "<br>您指定的组件的检查结果："
	ObjTest(strClass)
	  If Not IsObj then 
		Response.Write "<br><font color=red>很遗憾，该服务器不支持 " & strclass & " 组件！</font>"
	  Else
		Response.Write "<br><font class=fonts>恭喜！该服务器支持 " & strclass & " 组件。该组件版本是：" & VerObj & "</font>"
	  End If
	  Response.Write "<br>"
	end if
	%>


<br>■ IIS自带的ASP组件
<table width=100% border="0" cellpadding="0" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=470>组 件 名 称</td><td width=300>支持及版本</td></tr>
	<%For i=0 to 10%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>×</b></font>"
		Else
			Response.Write "<font class=fonts><b>√</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>■ 常见的文件上传和管理组件
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>组 件 名 称</td><td width=300>支持及版本</td></tr>
	<%For i=11 to 15%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>×</b></font>"
		Else
			Response.Write "<font class=fonts><b>√</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>■ 常见的收发邮件组件
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>组 件 名 称</td><td width=300>支持及版本</td></tr>
	<%For i=16 to 23%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>×</b></font>"
		Else
			Response.Write "<font class=fonts><b>√</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>■ 图像处理组件
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>组 件 名 称</td><td width=300>支持及版本</td></tr>
	<%For i=24 to 25%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>×</b></font>"
		Else
			Response.Write "<font class=fonts><b>√</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>
<font class=fonts>其他组件支持情况检测</font><br>
在下面的输入框中输入你要检测的组件的ProgId或ClassId。
<table width=100% border="0" cellpadding="0" cellspacing="0" class="border" style="border-collapse: collapse">
<FORM action=<%=Request.ServerVariables("SCRIPT_NAME")%> method=post id=form1 name=form1>
	<tr height="18" class=backq>
		
      <td height=30 align="center">&nbsp; 
        <input class=input type=text value="" name="classname" size=40>
<INPUT type=submit value=" 确 定 " class=backc id=submit1 name=submit1>
<INPUT type=reset value=" 重 填 " class=backc id=reset1 name=reset1> 
</td>
    </tr>
</FORM>
</table>
<br>
<font class=fonts>ASP脚本解释和运算速度测试</font><br>
我们让服务器执行50万次“1＋1”的计算，记录其所使用的时间。
<table class=border border="0" cellpadding="3" cellspacing="1" style="border-collapse: collapse" width=100%>
  <tr height=18 class=backs align=center>
	<td width=458>服&nbsp;&nbsp;&nbsp;务&nbsp;&nbsp;&nbsp;器</td><td width=300>完成时间</td></tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;中国频道虚拟主机（2002-08-06 9:29）</td><td>&nbsp;610.9 毫秒</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;西部数码west263主机（2002-08-06 9:29）</td><td>&nbsp;357.8 毫秒</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;商务中国虚拟主机（2002-08-06 9:29）</td><td>&nbsp;353.1 毫秒</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;顶尖科技tonydns主机（2002-10-13 14:19）</td><td>&nbsp;303.2 毫秒</td>
  </tr>
  <form action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method=post>
<%

	'感谢网际同学录 http://www.5719.net 推荐使用timer函数
	'因为只进行50万次计算，所以去掉了是否检测的选项而直接检测
	
	dim t1,t2,lsabc,thetime
	t1=timer
	for i=1 to 500000
		lsabc= 1 + 1
	next
	t2=timer

	thetime=cstr(int(( (t2-t1)*10000 )+0.5)/10)
%>
  <tr class="backq" height=18>
	<td align=left>&nbsp;<font color=red>您正在使用的这台服务器</font>&nbsp;</td><td>&nbsp;<font color=red><%=thetime%> 毫秒</font></td>
  </tr>
  </form>
</table>
<br>
<div align="center"><a href="Admin_Index_Main.asp">【返回管理首页】</a></div>
</BODY>
</HTML>
