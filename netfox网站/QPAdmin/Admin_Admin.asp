<!--#include file="conn.asp"-->
<!--#include file="function.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<% 
If InStr(Session("AdminSet"), ",4,")<=0 Then
    Call  WriteErrMsg("û��ϵͳ����Ȩ��!")
    Response.End
End If
 %>
<html>
<head>
<title></title>
<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
<link href='Admin_Style.css' rel='stylesheet' type='text/css'>
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
<td height='22' colspan='2' align='center'><strong>�� �� Ա �� ��</strong></td>
</tr>
<tr class='tdbg'> 
<td width='70' height='30'><strong>��������</strong></td>
<td height='30'><a href='Admin_Admin.asp'>����Ա������ҳ</a>&nbsp;|&nbsp;<%if InStr(Session("AdminSet"), ",6,")<=0 then%><%else%><a href='Admin_Admin.asp?Action=Add'>��������Ա</a> | <a href='Admin_Admin.asp?action=modifysitename'>�޸ı�������</a><%end if%></td>
</tr>
</table>
<br />
<% 
select case lcase(request("action"))
    case "add"
        call  add()
    case "modifyl"
        call Modifyl()
    case "del"
        call del()
    case "modifypwd"
        call ModifyPwd()
    case "saveadd"
        call saveadd()
    case "savemodifyl"
        call saveModifyl()
    case "savemodifysitename"
        Call saveModifySitename()
    case "modifysitename"
         Call ModifySitename()
    case else
        call main()
end select

sub saveadd()
    If InStr(Session("AdminSet"), ",4,")<=0 Then
    call  WriteSuccessMsg("û��ϵͳȨ��!")
    Response.End
    End If

    Dim AdminSet
    AdminSet = Request("adminset")
    AdminSet = Trim(Replace(AdminSet, " ", ""))
    If AdminSet<>"" Then
	    AdminSet = "," & AdminSet & ","
    End If
    set rs=server.createobject("adodb.recordset")
    sql="select * from QQ_admin  where Username='"&Replace(request("Username"), "'", "''")&"'"
    rs.open sql,DbAccConn,3,2
    if rs.eof then
    rs.addnew
    rs("Username")=request("Username")
    rs("Password")=md5((trim(request("Password"))),32)
    rs("AdminSet")=AdminSet
    rs.update
    call WriteSuccessMsg("����¹���Ա�ɹ�!")
    else
    call  WriteErrMsg("�Ѿ����ڸ��û�����!")
    response.End()
    end if
end sub

sub  saveModifyl()
    Dim AdminSet
    AdminSet = Trim(Request("adminset"))
    AdminSet = Trim(Replace(AdminSet, " ", ""))
    If AdminSet<>"" Then
	    AdminSet = "," & AdminSet & ","
    End If
    If Request("checkPassword")<>Request("Password") Then
	    WriteErrMsg("ȷ���������")
	    Response.End()
    End If
    set rs=server.createobject("adodb.recordset")
    sql="select * from QQ_admin  where  id="&CLng(request("id"))
    rs.open sql,DbAccConn,3,2
    if rs.eof then 
    call  WriteErrMsg("�����ڸ��û�����")
    response.End()
    end if
    If request("Password")<>"" Then
    rs("Password")=md5((trim(request("Password"))),32)
    End If
    rs("AdminSet")=AdminSet
    rs.update
    call WriteSuccessMsg("�޸Ĺ���Ա���ϳɹ�")
end sub

sub del()
    If InStr(Session("AdminSet"), ",4,")<=0 Then
    call  WriteSuccessMsg("û��ϵͳȨ��!")
    Response.End
    End If
    set rs=server.createobject("adodb.recordset")
    sql="delete from QQ_admin where id="&request("id")
    rs.open sql,DbAccConn,3,2
    call  WriteSuccessMsg("�ù���Ա��Ϣ�Ѿ�ɾ��!")
end sub

Rem �޸�ƽ̨����
Sub saveModifySitename()
    Dim sitename,sqlText,rs
    sitename=Trim(Request("in_sitename"))
    If sitename="" And Trim(Request("view"))="xg" Then
        Call  WriteSuccessMsg("������������Ϊ��!")
        Response.End
    End If
    
    IF Trim(Request("view"))="xg" Then
        Set rs=server.createobject("adodb.recordset")
        sqlText="select top 1 * from QPAdminSiteInfo "
        rs.open sqlText,DbAccConn,1,3
        If rs.eof then 
            rs.addnew
            rs("SiteName")=sitename
            rs.update
            Call WriteSuccessMsg("�޸ı���������ɣ�")           
        Else
            rs("SiteName")=sitename
            rs.update
            Call WriteSuccessMsg("�޸ı���������ɣ�")          
        End If  
    End If
End Sub
%>
<br />
<% sub main() 
If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteSuccessMsg("û��ϵͳȨ��!")
Response.End
End If
%>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr> 
<form name='myform' method='Post' action='Admin_Admin.asp' onsubmit="return confirm('ȷ��Ҫɾ��ѡ�еĹ���Ա��');">
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr align='center' class='title'> 
<td  width='47' height='22'><strong>���</strong></td>
<td width="128" height='22'><strong> �� �� ��</strong></td>
<td  width='113' height='22'><strong>Ȩ ��</strong></td>
<td width='125'><strong>����¼IP</strong></td>
<td width='117'><strong>����¼ʱ��</strong></td>
<td  width='75'><strong>��¼����</strong></td>
<td  width='122' height='22'><strong>�� ��</strong></td>
</tr>
<% 
set rs=server.createobject("adodb.recordset")
sql="select * from QQ_Admin"
rs.open sql,DbAccConn,1,1
if rs.eof then response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���κι���Ա��Ϣ��¼!<br><br></td></tr>")
do until rs.eof
%>
<tr align='center' class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
<td width='47'><%= rs("id")%></td>
<td><font color=red><%= rs("username")%></font></td>
<td width='113'><font color="blue">��������Ա<strong> </strong></font></td>
<td width='125'><%= rs("LastLoginIP")%></td>
<td width='117'><%= rs("LastLogintime")%></td>
<td width='75'><%= rs("LoginTimes")%></td>
<td width='122'><%if InStr(Session("AdminSet"), ",6,")<=0 then%><%else%><a href='Admin_Admin.asp?Action=ModifyPwd&ID=<%= rs("id")%>'>�޸�����</a><%end if%>&nbsp;&nbsp;&nbsp<a href='?Action=Del&ID=<%= rs("id") %>' onClick='return confirm("ȷ��Ҫɾ��ô?");'>ɾ���û�</a></td>
</tr>
<%
rs.movenext
loop
%>
</table></td>
</form>
</tr>
</table>
<% end  sub %>
<%sub  add()

If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteSuccessMsg("û��ϵͳȨ��!")
Response.End
End If
%>
<script type="text/javascript">
function CheckForm() {
var username= admin.username.value;
var Password= admin.Password.value;
var checkPassword= admin.Password.value;
if (username=="") {
alert('�������û�����');return false;
}
if (username.length<3)
{
alert('�û���̫�̣�������Ҫ3λ!');return false;
}
if (Password =="")
{
alert('����Ϊ�գ������޸����룡');return true;
}
if (Password.length<4)
{
alert('�������̫���ˣ����ٵ� 4λ��!');return false;
}
if (Password !=checkPassword)
{
alert('��������������벻һ�������飡');return false;
}
}
</script>
<form method='POST'  name='admin'   action=?action=saveadd  target='_self' onsubmit="return  CheckForm()">
<table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='title'> 
<td height='22' colspan='2' align='center'><strong> �� �� �� �� �� Ա</strong></td>
</tr>
<tr class='tdbg'> 
<td width="36%" align='right'><strong>�û���</strong>��</td>
<td width="64%"><input name='username' type='text' id='username' size='30'> 
</td>
</tr>
<tr class='tdbg'> 
<td align='right'><b>����</b>��</td>
<td> <input name='Password' type='text' id='Password' size='30'> </td>
</tr>
<tr class='tdbg'> 
<td align='right'><b>ȷ��������</b>��</td>
<td> <input name='checkPassword' type='text' id='checkPassword' size='30'> 
</td>
</tr>
<tr class='tdbg'>
  <td align='right'><b>Ȩ��</b>��</td>
  <td>
  <input name="adminset" type="checkbox" value="4"  />��վ��̨���� 
    <input name="adminset" type="checkbox" value="1"  />�û�����    
    <input name="adminset" type="checkbox" value="2"  />�޸��û�����     
    <input name="adminset" type="checkbox" value="3"  />ɾ���û�
    <br />
    <input name="adminset" type="checkbox" value="6"  />��Ϸ����
    <input name="adminset" type="checkbox" value="7"  />�޸Ľ��
    <input name="adminset" type="checkbox" value="8"  />���ù���Ա
    <br />
    <input name="adminset" type="checkbox" value="9"  />����������
    <input name="adminset" type="checkbox" value="10"  />IP��ַ����
    <input name="adminset" type="checkbox" value="11"  />�û�������
    </td>   
    
    
</tr>    
<tr class='tdbg'>     
<td align='right'>������</td>    
<td>     
<input type='submit' name='Submit2' value=' �� �� '> </td>    
</tr>    
<tr class='tdbg'>     
<td height='40' colspan='2' align='center'>&nbsp; </td>    
</tr>    
</table>    
</form>    
<%end   sub%>    
<%    
sub  ModifyPwd()    
If InStr(Session("AdminSet"), ",4,")<=0 Then    
call  WriteSuccessMsg("û��ϵͳȨ��!")    
Response.End    
End If    
    
set rs=server.createobject("adodb.recordset")    
sql="select *  from  qq_admin where  id="&request("id")    
rs.open sql,DbAccConn,3,2    
if  rs.eof  then    
response.write "<script language=javascript>alert('���Ѿ����ڸ�����')</script>"    
response.End()    
end  if    
%>    
<script type="text/javascript">    
function CheckForm() {    
var Password			= admin.Password.value;    
var checkPassword		= admin.Password.value;    
if (Password =="")    
{    
alert('����Ϊ�գ������޸����룡');return true;    
}    
if (Password.length<4)    
{    
alert('�������̫���ˣ����ٵ� 4λ��!');return false;    
}    
if (Password !=checkPassword)    
{    
alert('��������������벻һ�������飡');return false;    
}    
}    
</script>    
<form method='POST'  name='admin' action="?action=savemodifyl&id=<%= request("id") %>"  target='_self' onsubmit="return  CheckForm()">      
<table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>    
<tr class='title'>     
<td height='22' colspan='2' align='center'><strong>�� �� �� �� Ա �� ��</strong></td>    
</tr>    
<tr class='tdbg'>     
<td width="36%" align='right'><strong>�û���</strong>��</td>    
<td width="64%"> <% =rs("Username") %></td>    
</tr>    
<tr class='tdbg'>     
<td align='right'><b>������</b>��</td>    
<td><input name='Password' type='text' id='DefaultPoint3' size='30'>     
</td>    
</tr>    
<tr class='tdbg'>     
<td align='right'><b>ȷ��������</b>��</td>    
<td>     
<input name='checkPassword' type='text' id='checkPassword' size='30'>     
</td>    
</tr>    
<tr class='tdbg'>    
  <td align='right'><b>Ȩ��</b>��</td>    
  <td>    
    <input name="adminset" type="checkbox" value="4" <% If InStr(rs("AdminSet"), ",4,")>0 Then %>checked<% End If %> />��վ��̨���� 
    <input name="adminset" type="checkbox" value="1" <% If InStr(rs("AdminSet"), ",1,")>0 Then %>checked<% End If %> />�û�����    
    <input name="adminset" type="checkbox" value="2" <% If InStr(rs("AdminSet"), ",2,")>0 Then %>checked<% End If %> />�޸��û�����     
    <input name="adminset" type="checkbox" value="3" <% If InStr(rs("AdminSet"), ",3,")>0 Then %>checked<% End If %> />ɾ���û�
    <br />
    <input name="adminset" type="checkbox" value="6" <% If InStr(rs("AdminSet"), ",6,")>0 Then %>checked<% End If %> />��Ϸ����
    <input name="adminset" type="checkbox" value="7" <% If InStr(rs("AdminSet"), ",7,")>0 Then %>checked<% End If %> />�޸Ľ��
    <input name="adminset" type="checkbox" value="8" <% If InStr(rs("AdminSet"), ",8,")>0 Then %>checked<% End If %> />���ù���Ա
    <br />
    <input name="adminset" type="checkbox" value="9" <% If InStr(rs("AdminSet"), ",9,")>0 Then %>checked<% End If %> />����������
    <input name="adminset" type="checkbox" value="10" <% If InStr(rs("AdminSet"), ",10,")>0 Then %>checked<% End If %> />IP ��ַ����
    <input name="adminset" type="checkbox" value="11" <% If InStr(rs("AdminSet"), ",11,")>0 Then %>checked<% End If %> />�û�������
    </td>
</tr>    
<tr class='tdbg'>     
<td align='right'>������</td>    
<td> <input type='submit' name='Submit2' value=' �� �� '> </td>
</tr>    
<tr class='tdbg'>     
<td height='40' colspan='2' align='center'>&nbsp; </td>
</tr>
</table>
</form>

<%
End Sub

sub ModifySitename()
    If InStr(Session("AdminSet"), ",4,")<=0 Then    
    call  WriteSuccessMsg("û��ϵͳȨ��!")    
    Response.End    
    End If
    
    Dim sitename
    set rs=server.createobject("adodb.recordset")    
    sql="select top 1 *  from  QPAdminSiteInfo"   
    rs.open sql,DbAccConn,3,2    
    if  rs.eof  then    
        sitename="��������ƽ̨�����̨"
    else
        sitename=rs(1)
    end  if 
 %>

<script type="text/javascript">
    function CheckForm() {  
        var sitename=admin.in_sitename.value;
        if (sitename=="") {
            alert("�����ǰ����Ϊ�գ�����ƽ̨������ʹ��Ĭ�ϵġ���������ƽ̨�����̨��");
            return false;
        }
        return true;
    }
</script> 
 
<form method="post"  name="admin" action="?action=savemodifysitename&view=xg"  target='_self' onsubmit="return CheckForm()">   
    <table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>    
    <tr class='title'>     
    <td height='22' colspan='2' align='center'><strong>���ù����̨��������</strong></td>    
    </tr>    
    <tr class='tdbg'>     
    <td align='right'><strong>��������</strong>��</td>    
    <td><input name='in_sitename' type="text" id='in_sitename' size='60' value="<%=sitename %>" maxlength="32" /></td>    
    </tr> 
    <tr class='tdbg'>     
    <td align='right'>������</td>    
    <td> <input type='submit' name='Submit2' value=' �� �� '> </td>
    </tr>    
    <tr class='tdbg'>     
    <td height='40' colspan='2' align='center'>&nbsp; </td>
    </tr>
    </table>
</form>
    
<%
End   Sub
Call CloseDbAccConn() 
%>    

</body>
</html>