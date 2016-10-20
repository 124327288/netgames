<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",11,")<=0  Then
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
<form name='myform1' action='' method='get'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>保留用户名限制管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'>
        <a href="User_UsernameConfine.asp">全部保留用户名</a>
      </td>
</tr>
</table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action")) 
    case "addconfine"
    call addConfineContent()    
    call main()
    case "delconfine" 
    call delConfineContent()  
    call main() 
    case else
    call main()
End Select
Call CloseGame()

Sub delConfineContent()
Dim machineSerial,fname
fname="myform"  '表单名称
content=GetInfo(0,fname,"username")
    If InStr(Session("AdminSet"), ",11,")>0 Then
        delConfineContent2(content)
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行保留用户名限制的权限!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub delConfineContent2(content)
    GameConn.execute  "Delete From ConfineContent Where String='"&content&"'"
End Sub

Sub addConfineContent()
Dim content,fname
fname="myform"  '表单名称
content=GetInfo(0,fname,"Search")
    If InStr(Session("AdminSet"), ",11,")>0 Then
        addConfineContent2(content)
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行保留用户名的权限!")
        Response.End      
    End If
    
    Response.Redirect("?page="&Request("page"))
End Sub

Function addConfineContent2(content)
    IF Not IsConfineUsername(content) Then
        GameConn.execute  "Insert ConfineContent(String) Values('"&Trim(content)&"')"
    Else
         call  RLWriteSuccessMsg("错误啦", content&"，保留用户名已经存在!")
        Response.End   
    End IF
End Function

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")

 If Request("action")="cancelConfine" AND Trim(Request("typeID"))="" Then
    call  RLWriteSuccessMsg("错误啦", "请选中要删除的保留用户名!")
    Response.End      
End IF

For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("action")		
		Case "cancelConfine"		   
			delConfineContent2(Trim(typeIDArray(lLoop)))
	End Select
Next
%>
<script type="text/javascript">
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
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

function confine(optype){
    var opVal=document.getElementById("in_optype");
    var username=document.getElementById("Search").value;
   
    if (optype=="add"){
        opVal.value="addconfine";
        if (username.trim()=="") {
            alert("请输入需要保留的用户名！");
            return;
        }
    }
    if (optype=="del")
        opVal.value="cancelConfine";
    
    document.myform.action="User_UsernameConfine.asp?action="+opVal.value;
    document.myform.submit();
}
</script>
<%

Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr

OrderStr="String asc"
'查询条件
IF request("search")>"" Then  
   queryCondition = " String like '%"&sqlcheckStr(request("search"))& "%'"
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
	.Pkey="String"						'主键
	.Field="String,CollectDate"	'字段
	.Table="ConfineContent"				'表名
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
        <td align='left'>您现在的位置：<a href="User_UsernameConfine.asp">保留用户名管理</a>&gt;&gt;<a href="User_UsernameConfine.asp">&nbsp;所有保留用户名列表</a></td>
        <td align='right'>共找到  <label class="findUser"><%=lCount%></label> 个用户名</td>
        </tr></table>
     <form name='myform' method='Post' action='?page=<%=Request("page") %>'>	
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr><td>	  
     <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'>
            <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' title="选中本页所有成员" />
            </td>          
            <td width='120' height='21' align='center'><strong>用户名</strong></td>                 
             <td width='150' height='21' align='left'><strong>收集日期</strong></td>
            <td width='70' height='21' align='center'><strong> 操作</strong></td>
          </tr>
          <%
		    Dim content,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有任何信息!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            content = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=content %>' /></td>
            <td width='120'><%=content %></td>           
            <td width='150'><%=rs(1,i)%></td>          
            <td width='70' align='center'>
            <a href="?action=delconfine&username=<%=content %>">删除</a>
            </td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
      

</td></tr></table>


<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>


<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>用户查询:</strong></td>
<td >
<input name='Search' type='text' id="Search"  size='30' maxlength='64' /> 
<input type='submit' name='Submit2' value=' 查 询 ' class="btn" />
<input type='button' id="btn_add" value=' 添 加 ' class="btn" onclick="confine('add');" />
<input type='button' id="btn_del" value=' 批量删除 ' class="btn" onclick="confine('del');" title="请选中需要删除的保留用户名" />
 <input id="in_optype" type="hidden" />
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

