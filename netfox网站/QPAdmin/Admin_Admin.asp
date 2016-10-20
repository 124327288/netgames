<!--#include file="conn.asp"-->
<!--#include file="function.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<% 
If InStr(Session("AdminSet"), ",4,")<=0 Then
    Call  WriteErrMsg("没有系统管理权限!")
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
<td height='22' colspan='2' align='center'><strong>管 理 员 管 理</strong></td>
</tr>
<tr class='tdbg'> 
<td width='70' height='30'><strong>管理导航：</strong></td>
<td height='30'><a href='Admin_Admin.asp'>管理员管理首页</a>&nbsp;|&nbsp;<%if InStr(Session("AdminSet"), ",6,")<=0 then%><%else%><a href='Admin_Admin.asp?Action=Add'>新增管理员</a> | <a href='Admin_Admin.asp?action=modifysitename'>修改标题署名</a><%end if%></td>
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
    call  WriteSuccessMsg("没有系统权限!")
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
    call WriteSuccessMsg("添加新管理员成功!")
    else
    call  WriteErrMsg("已经存在该用户数据!")
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
	    WriteErrMsg("确认密码错误")
	    Response.End()
    End If
    set rs=server.createobject("adodb.recordset")
    sql="select * from QQ_admin  where  id="&CLng(request("id"))
    rs.open sql,DbAccConn,3,2
    if rs.eof then 
    call  WriteErrMsg("不存在该用户数据")
    response.End()
    end if
    If request("Password")<>"" Then
    rs("Password")=md5((trim(request("Password"))),32)
    End If
    rs("AdminSet")=AdminSet
    rs.update
    call WriteSuccessMsg("修改管理员资料成功")
end sub

sub del()
    If InStr(Session("AdminSet"), ",4,")<=0 Then
    call  WriteSuccessMsg("没有系统权限!")
    Response.End
    End If
    set rs=server.createobject("adodb.recordset")
    sql="delete from QQ_admin where id="&request("id")
    rs.open sql,DbAccConn,3,2
    call  WriteSuccessMsg("该管理员信息已经删除!")
end sub

Rem 修改平台署名
Sub saveModifySitename()
    Dim sitename,sqlText,rs
    sitename=Trim(Request("in_sitename"))
    If sitename="" And Trim(Request("view"))="xg" Then
        Call  WriteSuccessMsg("标题署名不能为空!")
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
            Call WriteSuccessMsg("修改标题署名完成！")           
        Else
            rs("SiteName")=sitename
            rs.update
            Call WriteSuccessMsg("修改标题署名完成！")          
        End If  
    End If
End Sub
%>
<br />
<% sub main() 
If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteSuccessMsg("没有系统权限!")
Response.End
End If
%>
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr> 
<form name='myform' method='Post' action='Admin_Admin.asp' onsubmit="return confirm('确定要删除选中的管理员吗？');">
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr align='center' class='title'> 
<td  width='47' height='22'><strong>序号</strong></td>
<td width="128" height='22'><strong> 用 户 名</strong></td>
<td  width='113' height='22'><strong>权 限</strong></td>
<td width='125'><strong>最后登录IP</strong></td>
<td width='117'><strong>最后登录时间</strong></td>
<td  width='75'><strong>登录次数</strong></td>
<td  width='122' height='22'><strong>操 作</strong></td>
</tr>
<% 
set rs=server.createobject("adodb.recordset")
sql="select * from QQ_Admin"
rs.open sql,DbAccConn,1,1
if rs.eof then response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有任何管理员信息记录!<br><br></td></tr>")
do until rs.eof
%>
<tr align='center' class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
<td width='47'><%= rs("id")%></td>
<td><font color=red><%= rs("username")%></font></td>
<td width='113'><font color="blue">超级管理员<strong> </strong></font></td>
<td width='125'><%= rs("LastLoginIP")%></td>
<td width='117'><%= rs("LastLogintime")%></td>
<td width='75'><%= rs("LoginTimes")%></td>
<td width='122'><%if InStr(Session("AdminSet"), ",6,")<=0 then%><%else%><a href='Admin_Admin.asp?Action=ModifyPwd&ID=<%= rs("id")%>'>修改资料</a><%end if%>&nbsp;&nbsp;&nbsp<a href='?Action=Del&ID=<%= rs("id") %>' onClick='return confirm("确定要删除么?");'>删除用户</a></td>
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
call  WriteSuccessMsg("没有系统权限!")
Response.End
End If
%>
<script type="text/javascript">
function CheckForm() {
var username= admin.username.value;
var Password= admin.Password.value;
var checkPassword= admin.Password.value;
if (username=="") {
alert('请输入用户名！');return false;
}
if (username.length<3)
{
alert('用户名太短，至少需要3位!');return false;
}
if (Password =="")
{
alert('密码为空，将不修改密码！');return true;
}
if (Password.length<4)
{
alert('你得密码太短了，至少的 4位吧!');return false;
}
if (Password !=checkPassword)
{
alert('您两次输入的密码不一样，请检查！');return false;
}
}
</script>
<form method='POST'  name='admin'   action=?action=saveadd  target='_self' onsubmit="return  CheckForm()">
<table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='title'> 
<td height='22' colspan='2' align='center'><strong> 添 加 新 管 理 员</strong></td>
</tr>
<tr class='tdbg'> 
<td width="36%" align='right'><strong>用户名</strong>：</td>
<td width="64%"><input name='username' type='text' id='username' size='30'> 
</td>
</tr>
<tr class='tdbg'> 
<td align='right'><b>密码</b>：</td>
<td> <input name='Password' type='text' id='Password' size='30'> </td>
</tr>
<tr class='tdbg'> 
<td align='right'><b>确认新密码</b>：</td>
<td> <input name='checkPassword' type='text' id='checkPassword' size='30'> 
</td>
</tr>
<tr class='tdbg'>
  <td align='right'><b>权限</b>：</td>
  <td>
  <input name="adminset" type="checkbox" value="4"  />网站后台管理 
    <input name="adminset" type="checkbox" value="1"  />用户管理    
    <input name="adminset" type="checkbox" value="2"  />修改用户资料     
    <input name="adminset" type="checkbox" value="3"  />删除用户
    <br />
    <input name="adminset" type="checkbox" value="6"  />游戏管理
    <input name="adminset" type="checkbox" value="7"  />修改金币
    <input name="adminset" type="checkbox" value="8"  />设置管理员
    <br />
    <input name="adminset" type="checkbox" value="9"  />机器码限制
    <input name="adminset" type="checkbox" value="10"  />IP地址限制
    <input name="adminset" type="checkbox" value="11"  />用户名限制
    </td>   
    
    
</tr>    
<tr class='tdbg'>     
<td align='right'>操作：</td>    
<td>     
<input type='submit' name='Submit2' value=' 添 加 '> </td>    
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
call  WriteSuccessMsg("没有系统权限!")    
Response.End    
End If    
    
set rs=server.createobject("adodb.recordset")    
sql="select *  from  qq_admin where  id="&request("id")    
rs.open sql,DbAccConn,3,2    
if  rs.eof  then    
response.write "<script language=javascript>alert('不已经存在该类型')</script>"    
response.End()    
end  if    
%>    
<script type="text/javascript">    
function CheckForm() {    
var Password			= admin.Password.value;    
var checkPassword		= admin.Password.value;    
if (Password =="")    
{    
alert('密码为空，将不修改密码！');return true;    
}    
if (Password.length<4)    
{    
alert('你得密码太短了，至少的 4位吧!');return false;    
}    
if (Password !=checkPassword)    
{    
alert('您两次输入的密码不一样，请检查！');return false;    
}    
}    
</script>    
<form method='POST'  name='admin' action="?action=savemodifyl&id=<%= request("id") %>"  target='_self' onsubmit="return  CheckForm()">      
<table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>    
<tr class='title'>     
<td height='22' colspan='2' align='center'><strong>修 改 管 理 员 密 码</strong></td>    
</tr>    
<tr class='tdbg'>     
<td width="36%" align='right'><strong>用户名</strong>：</td>    
<td width="64%"> <% =rs("Username") %></td>    
</tr>    
<tr class='tdbg'>     
<td align='right'><b>新密码</b>：</td>    
<td><input name='Password' type='text' id='DefaultPoint3' size='30'>     
</td>    
</tr>    
<tr class='tdbg'>     
<td align='right'><b>确认新密码</b>：</td>    
<td>     
<input name='checkPassword' type='text' id='checkPassword' size='30'>     
</td>    
</tr>    
<tr class='tdbg'>    
  <td align='right'><b>权限</b>：</td>    
  <td>    
    <input name="adminset" type="checkbox" value="4" <% If InStr(rs("AdminSet"), ",4,")>0 Then %>checked<% End If %> />网站后台管理 
    <input name="adminset" type="checkbox" value="1" <% If InStr(rs("AdminSet"), ",1,")>0 Then %>checked<% End If %> />用户管理    
    <input name="adminset" type="checkbox" value="2" <% If InStr(rs("AdminSet"), ",2,")>0 Then %>checked<% End If %> />修改用户资料     
    <input name="adminset" type="checkbox" value="3" <% If InStr(rs("AdminSet"), ",3,")>0 Then %>checked<% End If %> />删除用户
    <br />
    <input name="adminset" type="checkbox" value="6" <% If InStr(rs("AdminSet"), ",6,")>0 Then %>checked<% End If %> />游戏管理
    <input name="adminset" type="checkbox" value="7" <% If InStr(rs("AdminSet"), ",7,")>0 Then %>checked<% End If %> />修改金币
    <input name="adminset" type="checkbox" value="8" <% If InStr(rs("AdminSet"), ",8,")>0 Then %>checked<% End If %> />设置管理员
    <br />
    <input name="adminset" type="checkbox" value="9" <% If InStr(rs("AdminSet"), ",9,")>0 Then %>checked<% End If %> />机器码限制
    <input name="adminset" type="checkbox" value="10" <% If InStr(rs("AdminSet"), ",10,")>0 Then %>checked<% End If %> />IP 地址限制
    <input name="adminset" type="checkbox" value="11" <% If InStr(rs("AdminSet"), ",11,")>0 Then %>checked<% End If %> />用户名限制
    </td>
</tr>    
<tr class='tdbg'>     
<td align='right'>操作：</td>    
<td> <input type='submit' name='Submit2' value=' 添 加 '> </td>
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
    call  WriteSuccessMsg("没有系统权限!")    
    Response.End    
    End If
    
    Dim sitename
    set rs=server.createobject("adodb.recordset")    
    sql="select top 1 *  from  QPAdminSiteInfo"   
    rs.open sql,DbAccConn,3,2    
    if  rs.eof  then    
        sitename="网狐棋牌平台管理后台"
    else
        sitename=rs(1)
    end  if 
 %>

<script type="text/javascript">
    function CheckForm() {  
        var sitename=admin.in_sitename.value;
        if (sitename=="") {
            alert("如果当前署名为空，管理平台标题则使用默认的“网狐棋牌平台管理后台”");
            return false;
        }
        return true;
    }
</script> 
 
<form method="post"  name="admin" action="?action=savemodifysitename&view=xg"  target='_self' onsubmit="return CheckForm()">   
    <table width='60%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>    
    <tr class='title'>     
    <td height='22' colspan='2' align='center'><strong>设置管理后台标题署名</strong></td>    
    </tr>    
    <tr class='tdbg'>     
    <td align='right'><strong>标题署名</strong>：</td>    
    <td><input name='in_sitename' type="text" id='in_sitename' size='60' value="<%=sitename %>" maxlength="32" /></td>    
    </tr> 
    <tr class='tdbg'>     
    <td align='right'>操作：</td>    
    <td> <input type='submit' name='Submit2' value=' 修 改 '> </td>
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