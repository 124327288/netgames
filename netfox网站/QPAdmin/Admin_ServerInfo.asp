<!--#include file="conn.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<!--#include file="function.asp"-->
<%


If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteErrMsg("û��ϵͳ����Ȩ��!")
Response.End
End If 

'�������������
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
ObjTotest(9,1) = "(FSO �ı��ļ���д)"
ObjTotest(10,0) = "adodb.connection"
ObjTotest(10,1) = "(ADO ���ݶ���)"
	
ObjTotest(11,0) = "SoftArtisans.FileUp"
ObjTotest(11,1) = "(SA-FileUp �ļ��ϴ�)"
ObjTotest(12,0) = "SoftArtisans.FileManager"
ObjTotest(12,1) = "(SoftArtisans �ļ�����)"
ObjTotest(13,0) = "LyfUpload.UploadFile"
ObjTotest(13,1) = "(���Ʒ���ļ��ϴ����)"
ObjTotest(14,0) = "Persits.Upload.1"
ObjTotest(14,1) = "(ASPUpload �ļ��ϴ�)"
ObjTotest(15,0) = "w3.upload"
ObjTotest(15,1) = "(Dimac �ļ��ϴ�)"

ObjTotest(16,0) = "JMail.SmtpMail"
ObjTotest(16,1) = "(Dimac JMail �ʼ��շ�) <a href='http://www.ajiang.net'>�����ֲ�����</a>"
ObjTotest(17,0) = "CDONTS.NewMail"
ObjTotest(17,1) = "(���� SMTP ����)"
ObjTotest(18,0) = "Persits.MailSender"
ObjTotest(18,1) = "(ASPemail ����)"
ObjTotest(19,0) = "SMTPsvg.Mailer"
ObjTotest(19,1) = "(ASPmail ����)"
ObjTotest(20,0) = "DkQmail.Qmail"
ObjTotest(20,1) = "(dkQmail ����)"
ObjTotest(21,0) = "Geocel.Mailer"
ObjTotest(21,1) = "(Geocel ����)"
ObjTotest(22,0) = "IISmail.Iismail.1"
ObjTotest(22,1) = "(IISmail ����)"
ObjTotest(23,0) = "SmtpMail.SmtpMail.1"
ObjTotest(23,1) = "(SmtpMail ����)"
	
ObjTotest(24,0) = "SoftArtisans.ImageGen"
ObjTotest(24,1) = "(SA ��ͼ���д���)"
ObjTotest(25,0) = "W3Image.Image"
ObjTotest(25,1) = "(Dimac ��ͼ���д���)"

public IsObj,VerObj

'���Ԥ�����֧��������汾

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

'�������Ƿ�֧�ּ�����汾���ӳ���
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
<TITLE>��������Ϣ</TITLE>
<style>
<!--
BODY
{
	FONT-FAMILY: ����;
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
      <td height=25 class="topbg"><strong><%=SiteName%>----��������Ϣ</strong>  
    </tr>
    <tr>
      <td height=23 class="tdbg">
        <font class=fonts>�Ƿ�֧��ASP</font> <br>
���������������ʾ���Ŀռ䲻֧��ASP�� <br>
1�����ʱ��ļ�ʱ��ʾ���ء� <br>
2�����ʱ��ļ�ʱ�������ơ�&lt;%@ Language="VBScript" %&gt;�������֡� </td>
    </tr>
  </table>
</div>
<br>

<font class=fonts>���������йز���</font>
  <table border=0 width=100% cellspacing=0 cellpadding=0 bgcolor="#ffffff">
<tr><td>

	<table width=100% border=0 cellpadding=3 cellspacing=1 class="border">
	  <tr class="backq" height=18>
		<td align=left>&nbsp;��������</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_NAME")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;������IP</td>
		<td>&nbsp;<%=Request.ServerVariables("LOCAL_ADDR")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;�������˿�</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_PORT")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;������ʱ��</td>
		<td>&nbsp;<%=now%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;IIS�汾</td>
		<td>&nbsp;<%=Request.ServerVariables("SERVER_SOFTWARE")%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;�ű���ʱʱ��</td>
		<td>&nbsp;<%=Server.ScriptTimeout%> ��</td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;���ļ�·��</td>
		<td>&nbsp;<%=server.mappath(Request.ServerVariables("SCRIPT_NAME"))%></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;������CPU����</td>
		<td>&nbsp;<%=Request.ServerVariables("NUMBER_OF_PROCESSORS")%> ��</td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;��������������</td>
		<td>&nbsp;<%=ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></td>
	  </tr>
	  <tr class="backq" height=18>
		<td align=left>&nbsp;����������ϵͳ</td>
		<td>&nbsp;<%=Request.ServerVariables("OS")%></td>
	  </tr>
	</table>

</td></tr>
</table>
<br>
<font class=fonts>���֧�����</font>
<%
Dim strClass
	strClass = Trim(Request.Form("classname"))
	If "" <> strClass then
	Response.Write "<br>��ָ��������ļ������"
	ObjTest(strClass)
	  If Not IsObj then 
		Response.Write "<br><font color=red>���ź����÷�������֧�� " & strclass & " �����</font>"
	  Else
		Response.Write "<br><font class=fonts>��ϲ���÷�����֧�� " & strclass & " �����������汾�ǣ�" & VerObj & "</font>"
	  End If
	  Response.Write "<br>"
	end if
	%>


<br>�� IIS�Դ���ASP���
<table width=100% border="0" cellpadding="0" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=470>�� �� �� ��</td><td width=300>֧�ּ��汾</td></tr>
	<%For i=0 to 10%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>��</b></font>"
		Else
			Response.Write "<font class=fonts><b>��</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>�� �������ļ��ϴ��͹������
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>�� �� �� ��</td><td width=300>֧�ּ��汾</td></tr>
	<%For i=11 to 15%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>��</b></font>"
		Else
			Response.Write "<font class=fonts><b>��</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>�� �������շ��ʼ����
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>�� �� �� ��</td><td width=300>֧�ּ��汾</td></tr>
	<%For i=16 to 23%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>��</b></font>"
		Else
			Response.Write "<font class=fonts><b>��</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>�� ͼ�������
<table width=100% border="0" cellpadding="3" cellspacing="1" class="border" style="border-collapse: collapse">
	<tr height=18 class=backs align=center><td width=473>�� �� �� ��</td><td width=300>֧�ּ��汾</td></tr>
	<%For i=24 to 25%>
	<tr height="18" class=backq>
		<td align=left>&nbsp;<%=ObjTotest(i,0) & "<font color=#009286>&nbsp;" & ObjTotest(i,1)%></font></td>
		<td align=left>&nbsp;<%
		If Not ObjTotest(i,2) Then 
			Response.Write "<font color=red><b>��</b></font>"
		Else
			Response.Write "<font class=fonts><b>��</b></font> <a title='" & ObjTotest(i,3) & "'>" & left(ObjTotest(i,3),11) & "</a>"
		End If%></td>
	</tr>
	<%next%>
</table>

<br>
<font class=fonts>�������֧��������</font><br>
��������������������Ҫ���������ProgId��ClassId��
<table width=100% border="0" cellpadding="0" cellspacing="0" class="border" style="border-collapse: collapse">
<FORM action=<%=Request.ServerVariables("SCRIPT_NAME")%> method=post id=form1 name=form1>
	<tr height="18" class=backq>
		
      <td height=30 align="center">&nbsp; 
        <input class=input type=text value="" name="classname" size=40>
<INPUT type=submit value=" ȷ �� " class=backc id=submit1 name=submit1>
<INPUT type=reset value=" �� �� " class=backc id=reset1 name=reset1> 
</td>
    </tr>
</FORM>
</table>
<br>
<font class=fonts>ASP�ű����ͺ������ٶȲ���</font><br>
�����÷�����ִ��50��Ρ�1��1���ļ��㣬��¼����ʹ�õ�ʱ�䡣
<table class=border border="0" cellpadding="3" cellspacing="1" style="border-collapse: collapse" width=100%>
  <tr height=18 class=backs align=center>
	<td width=458>��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</td><td width=300>���ʱ��</td></tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;�й�Ƶ������������2002-08-06 9:29��</td><td>&nbsp;610.9 ����</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;��������west263������2002-08-06 9:29��</td><td>&nbsp;357.8 ����</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;�����й�����������2002-08-06 9:29��</td><td>&nbsp;353.1 ����</td>
  </tr>
  <tr class="backq" height=18>
	<td align=left>&nbsp;����Ƽ�tonydns������2002-10-13 14:19��</td><td>&nbsp;303.2 ����</td>
  </tr>
  <form action="<%=Request.ServerVariables("SCRIPT_NAME")%>" method=post>
<%

	'��л����ͬѧ¼ http://www.5719.net �Ƽ�ʹ��timer����
	'��Ϊֻ����50��μ��㣬����ȥ�����Ƿ����ѡ���ֱ�Ӽ��
	
	dim t1,t2,lsabc,thetime
	t1=timer
	for i=1 to 500000
		lsabc= 1 + 1
	next
	t2=timer

	thetime=cstr(int(( (t2-t1)*10000 )+0.5)/10)
%>
  <tr class="backq" height=18>
	<td align=left>&nbsp;<font color=red>������ʹ�õ���̨������</font>&nbsp;</td><td>&nbsp;<font color=red><%=thetime%> ����</font></td>
  </tr>
  </form>
</table>
<br>
<div align="center"><a href="Admin_Index_Main.asp">�����ع�����ҳ��</a></div>
</BODY>
</HTML>
