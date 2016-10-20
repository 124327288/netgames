<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",9,")<=0  Then
call  RLWriteSuccessMsg("错误啦", "没有管理权限!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
call  RLWriteSuccessMsg("错误啦", "没有用户管理权限!")
Response.End
End If
 %>
<html>
<head> 
<meta http-equiv='Content-Type' content='text/html; charset=gb2312' />
<link href='Admin_Style.css' rel='stylesheet' type='text/css' />
<!--#include file="inc/links.asp"-->
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<form name='form1' action='' method='get'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>机器码限制管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp;<a href='?confinetype=1'>受限用户</a>&nbsp;| <a href="?confinetype=2">正常用户</a> | <a href="User_MachineConfine.asp">全部用户列表</a> | <a href="User_MachineConfine_List.asp">所有受限机器</a></td>
</tr>
</table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action")) 
    case "addconfine"
    call addConfineMachine()    
    call main()
    case "delconfine" 
    call delConfineMachine()  
    call main() 
    case else
    call main()
End Select
Call CloseGame()

Sub delConfineMachine()
Dim machineSerial,fname
fname="myform"  '表单名称
machineSerial=GetInfo(0,fname,"machineSerial")
    If InStr(Session("AdminSet"), ",9,")>0 Then
        GameConn.execute  "Delete From ConfineMachine Where MachineSerial='"&machineSerial&"'"
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行机器码限制的权限!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub addConfineMachine()
Dim machineSerial,fname
fname="myform"  '表单名称
machineSerial=GetInfo(0,fname,"machineSerial")
    If InStr(Session("AdminSet"), ",9,")>0 Then
        addConfineMachine2(machineSerial)
        'GameConn.execute  "Insert ConfineMachine(MachineSerial,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&machineSerial&"',1,1,'"&DateAdd("d",1,Now)&"')"
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行机器码限制的权限!")
        Response.End      
    End If
    
    Response.Redirect("?page="&Request("page"))
End Sub

Function addConfineMachine2(machineSerial)
    IF Not IsConfineMachine(machineSerial) Then
        GameConn.execute  "Insert ConfineMachine(MachineSerial,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&Trim(machineSerial)&"',1,1,GETDATE()+1)"
    End IF
End Function

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")

For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("rdConfine")
		Case "addConfine"
		  addConfineMachine2(typeIDArray(lLoop))
		Case "cancelConfine"
			GameConn.execute  "Delete From ConfineMachine Where MachineSerial='"&Trim(typeIDArray(lLoop))&"'"
	End Select
Next
%>
<script type="text/javascript">
function unselectall(){
if(document.myform.chkAll.checked){
document.myform.chkAll.checked = document.myform.chkAll.checked&0;
}
}
function CheckAll(form){
for (var i=0;i<form.elements.length;i++){
var e = form.elements[i];
if (e.Name != 'chkAll'&&e.disabled==false)
e.checked = form.chkAll.checked;
}
}
</script>
<%

Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr

OrderStr="UserID desc"
'查询条件
IF request("search")>"" Then
    Select case Request("swhat")
	    Case "1"
		    queryCondition = " Accounts='"&sqlcheckStr(request("search"))& "' OR RegAccounts='"&sqlcheckStr(request("search"))& "'"		    
        Case "5"
		    queryCondition = " gameid='"&sqlcheckStr(request("search"))& "'"	  
        Case "7"
		    queryCondition = " UserID='"&sqlcheckStr(request("search"))& "'"
		Case "8"
		    queryCondition = " MachineSerial='"&sqlcheckStr(request("search"))& "'"
    End Select
End IF

IF request("confinetype")>"" Then
    Select case request("confinetype")
        Case "1"
           queryCondition=" MachineSerial IN (Select MachineSerial FROM ConfineMachine(NOLOCK))" 
        Case "2"
            queryCondition=" MachineSerial NOT IN (Select MachineSerial FROM ConfineMachine(NOLOCK))" 
    End Select
End IF

'==============================================================================================================
'执行查询过程

Set Page = new Cls_Page				'创建对象
Set Page.Conn = GameConn				'得到数据库连接对象
With Page
	.PageSize = 20					'每页记录条数
	.PageParm = "page"					'页参数
	'.PageIndex = 10				'当前页，可选参数，一般是生成静态时需要
	.Database = "mssql"				'数据库类型,AC为access,MSSQL为sqlserver2000存储过程版,MYSQL为mysql,PGSQL为PostGreSql
	.Pkey="UserID"						'主键
	.Field="UserID,GameID,Accounts,RegAccounts,MachineSerial"	'字段
	.Table="AccountsInfo"				'表名
	.Condition=queryCondition					'条件,不需要where
	.OrderBy=OrderStr						'排序,不需要order by,需要asc或者desc
	.RecordCount = 0				'总记录数，可以外部赋值，0不保存（适合搜索），-1存为session，-2存为cookies，-3存为applacation

	.NumericJump = 5 '数字上下页个数，可选参数，默认为3，负数为跳转个数，0为显示所有
	.Template = "总记录数：{$RecordCount} 总页数：{$PageCount} 每页记录数：{$PageSize} 当前页数：{$PageIndex} {$FirstPage} {$PreviousPage} {$NumericPage} {$NextPage} {$LastPage} {$InputPage} {$SelectPage}" '整体模板，可选参数，有默认值
	.FirstPage = "首页" '可选参数，有默认值
	.PreviousPage = "上一页" '可选参数，有默认值
	.NextPage = "下一页" '可选参数，有默认值
	.LastPage = "尾页" '可选参数，有默认值
	.NumericPage = " {$PageNum} " '数字分页部分模板，可选参数，有默认值
End With

rs = Page.ResultSet() '记录集
lCount = Page.RowCount() '可选，输出总记录数
nav = Page.Nav() '分页样式

Page = Null
Set Page = Nothing

'==============================================================================================================

%>
<br />
    <table width='100%'>
        <tr>
        <td align='left'>您现在的位置：<a href="User_MachineConfine.asp">机器码限制管理</a>&gt;&gt;<a href="User_MachineConfine.asp">&nbsp;所有用户成员列表</a></td>
        <td align='right'>共找到  <label class="findUser"><%=lCount%></label> 个用户</td>
        </tr></table>
     <form name='myform' method='Post' action='?action=edit&page=<%=Request("page") %>' onsubmit="return confirm('确定要执行选定的操作吗？');">	
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr><td>	  
     <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'><strong>选中</strong></td>
            <td width='33' align='center'><strong>ID</strong></td>
            <td width='85' height='21' align='center'><strong>用户名</strong></td>
             <td width='85' height='21' align='center'><strong>原始用户名</strong></td>          
             <td width='150' height='21' align='left'><strong>机器码</strong></td>
            <td width='130' height='21' align='center'><strong> 操作</strong></td>
          </tr>
          <%
		    Dim UserID,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有任何信息!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            UserID = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=rs(4,i) %>' /></td>
            <td width='33' align='center'><%=rs(1,i)%></td>
            <td width='85'><a href='?action=userinfo&id=<%=UserID%>' title="<%=rs(2,i)%>"><%=rs(2,i)%></a></td>           
            <td width='85'><%=rs(3,i)%></td>
            <td width='150'>
                <a href="?Search=<%=rs(4,i)%>&swhat=8" title="查看使用这台机器登录过的用户"><%=rs(4,i)%></a>
            </td>            
            <td width='130' align='center'>
            <% IF IsConfineMachine(rs(4,i)) Then %>
                <a href="?action=delconfine&machineSerial=<%=rs(4,i)%>&page=<%=Request("page") %>" style="color:Red;">取消限制</a>
               <a href="User_MachineConfine_List.asp?Search=<%=rs(4,i)%>&swhat=8">查看详细限制</a>  
            <% Else %>
                <a href="?action=addconfine&machineSerial=<%=rs(4,i)%>&page=<%=Request("page") %>">限制</a>
            <% End IF %>
            </td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
		
        <table width='100%' border='0' cellpadding='0' cellspacing='0'>
        <tr> 
            <td width='191' height='23'> 
              <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' />
             <label for="chkAll2"> 选中本页所有成员</label>
              </td>
            <td width="574">
            <div align="left"><strong>操作： </strong>
                <input name='rdConfine' type='radio' value='addConfine' />限制机器
				<input name='rdConfine' type='radio' value='cancelConfine' checked="checked" />取消限制							
                <input type='submit' name='Submit' value=' 执 行 '/>
                </div>
         </td></tr></table>

</td></tr></table>
</form> 

<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>用户查询:</strong></td>
<td >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='30' maxlength='64'>
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">按用户名</option>   
    <option value="5">按游戏ID</option>  
    <option value="8">按机器码</option> 
  </select> 
<input type='submit' name='Submit2' value=' 查 询 ' />
</td>
<td>若为空，则查询所有用户</td>
</tr></table>
</form>
<%
End sub
%>

<div>
<%endtime=timer()%>本页面执行时间：<%=FormatNumber((endtime-startime)*1000,3)%>毫秒
</div>

</body>
</html>

