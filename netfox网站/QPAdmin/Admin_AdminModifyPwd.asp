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
	ErrMsg=ErrMsg & "<br><li>�����ڴ��û���</li>"
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

Rem �޸�����
Sub ModifyPwd()
	Dim password,PwdConfirm
	password=trim(Request("Password"))
	PwdConfirm=trim(request("PwdConfirm"))
	if password="" then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>�����벻��Ϊ�գ�</li>"
	end if
	if PwdConfirm<>Password then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>ȷ�������������������ͬ��</li>"
		exit sub
	end if
	UserName=rs("UserName")
	If rs("password")<>md5((Trim(Request("oldpassword"))),32) then
		FoundErr=True
		ErrMsg=ErrMsg & "<br><li>ԭ���������</li>"
		exit sub
	end if
	if Password<>"" then
		rs("password")=md5((password),32)
	end if
   	rs.update
	Call WriteSuccessMsg("�޸�����ɹ����´ε�¼ʱ�ǵû���������Ŷ��")
END SUB

Sub main()
%>
<html>
<head>
<title>�޸Ĺ���Ա��Ϣ</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link href="Admin_Style.css" rel="stylesheet" type="text/css">
<script language=javascript>
function check()
{
  if(document.form1.Password.value=="")
    {
      alert("���벻��Ϊ�գ�");
	  document.form1.Password.focus();
      return false;
    }
    
  if((document.form1.Password.value)!=(document.form1.PwdConfirm.value))
    {
      alert("��ʼ������ȷ�����벻ͬ��");
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
      <td height="22" colspan="2"> <div align="center"><strong>�� �� �� �� Ա �� ��</strong></div></td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>�� �� ����</strong></td>
      <td class="tdbg"><%=rs("UserName")%></td>
    </tr>
	<tr> 
      <td width="100" align="right" class="tdbg"><strong>�� �� �룺</strong></td>
      <td class="tdbg"><input type="password" name="oldpassword"> </td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>�� �� �룺</strong></td>
      <td class="tdbg"><input type="password" name="Password"> </td>
    </tr>
    <tr> 
      <td width="100" align="right" class="tdbg"><strong>ȷ�����룺</strong></td>
      <td class="tdbg"><input type="password" name="PwdConfirm"> </td>
    </tr>
    <tr> 
      <td height="40" colspan="2" align="center" class="tdbg"><input name="Action" type="hidden" id="Action" value="Modify"> 
        <input  type="submit" name="Submit" value=" ȷ �� " style="cursor:hand;"> 
        &nbsp; <input name="Cancel" type="button" id="Cancel" value=" ȡ �� " onClick="window.location.href='Admin_Index_Main.asp'" style="cursor:hand;"></td>
    </tr>
  </table>
  </form>
</body>
</html>
<%
End Sub

%>