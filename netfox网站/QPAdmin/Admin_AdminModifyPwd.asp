<!--#include file="conn.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<!--#include file="function.asp"-->
<!--#include file="md5.asp"-->
<%
Dim rs,sql
sql="Select * from qq_admin where UserName='" & AdminName & "'"
Set rs=Server.CreateObject("Adodb.RecordSet")
rs.Open sql,DbAccConn,1,3

IF rs.Bof AND rs.EOF Then
	FoundErr=True
	ErrMsg=ErrMsg & "<br><li>不存在此用户！</li>"
Else
	IF Action="Modify" then
		Call ModifyPwd()
	Else
		Call main()
	END IF
END IF
rs.close

Set rs=Nothing
If FoundErr=True Then
	Call WriteErrMsg()
END IF
Call CloseDbAccConn()

Rem 修改密码
Sub ModifyPwd()
	Dim password,PwdConfirm
	password=trim(Request("Password"))
	PwdConfirm=trim(request("PwdConfirm"))
	if password="" then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>新密码不能为空！</li>"
	end if
	if PwdConfirm<>Password then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>确认密码必须与新密码相同！</li>"
		exit sub
	end if
	UserName=rs("UserName")
	If rs("password")<>md5((Trim(Request("oldpassword"))),32) then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>原来密码错误！</li>"
		exit sub
	end if
	if Password<>"" then
		rs("password")=md5((password),32)
	end if
   	rs.update
	Call WriteSuccessMsg("修改密码成功！下次登录时记得换用新密码哦！")
END SUB

Sub main()
%>
<html>
<head>
<title>修改管理员信息</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link href="Admin_Style.css" rel="stylesheet" type="text/css">
<script language=javascript>
function check()
{
  if(document.form1.Password.value=="")
    {
      alert("密码不能为空！");
	  document.form1.Password.focus();
      return false;
    }
    
  if((document.form1.Password.value)!=(document.form1.PwdConfirm.value))
    {
      alert("初始密码与确认密码不同！");
	  document.form1.PwdConfirm.select();
	  document.form1.PwdConfirm.focus();	  
      return false;
    }
}
</script>
</head>
<body>
<form method="post" action="Admin_AdminModifyPwd.asp" name="form1" onsubmit="javascript:return check();">
  <br>
  <br>
  <table width="300" border="0" align="center" cellpadding="2" cellspacing="1" class="border" >
    <tr class="title"> 
      <td height="22" colspan="2"> <div align="center"><strong>修 改 管 理 员 密 码</strong></div></td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>用 户 名：</strong></td>
      <td class="tdbg"><%=rs("UserName")%></td>
    </tr>
	<tr> 
      <td width="100" align="right" class="tdbg"><strong>旧 密 码：</strong></td>
      <td class="tdbg"><input type="password" name="oldpassword"> </td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>新 密 码：</strong></td>
      <td class="tdbg"><input type="password" name="Password"> </td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>确认密码：</strong></td>
      <td class="tdbg"><input type="password" name="PwdConfirm"> </td>
    </tr>
    <tr> 
      <td height="40" colspan="2" align="center" class="tdbg"><input name="Action" type="hidden" id="Action" value="Modify"> 
        <input  type="submit" name="Submit" value=" 确 定 " style="cursor:hand;"> 
        &nbsp; <input name="Cancel" type="button" id="Cancel" value=" 取 消 " onClick="window.location.href='Admin_Index_Main.asp'" style="cursor:hand;"></td>
    </tr>
  </table>
  </form>
</body>
</html>
<%
End Sub

%>