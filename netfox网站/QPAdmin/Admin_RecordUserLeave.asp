<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->

<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0 Then
call  RLWriteSuccessMsg("错误啦", "没有城市管理权限!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0 Then
call  RLWriteSuccessMsg("错误啦", "没有用户管理权限!")
Response.End
End If
 %>

<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
<link href='Admin_Style.css' rel='stylesheet' type='text/css'>
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name='form1' action='' method='get'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>游戏用户管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'><a href="Admin_RecordUserEnter.asp">进入房间记录</a> |<a href="Admin_RecordUserLeave.asp"> 退出房间记录</a> |  <!--<a href="Admin_RecordGameScore.asp">输赢记录</a> |--></td>
</tr>
</form>
</table>
<%
Call ConnectGame("QPTreasureDB")
Select case lcase(request("action"))
    case else
    call main()
End Select
Call CloseGame()


Sub main()
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
'====================================================================================
'查询条件
Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr
Dim LeaveTime1

OrderStr=" LeaveTime desc"

IF Request("search")>"" Then
    Select case Request("swhat")
        Case "1"
            queryCondition=" UserID in (select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("search"))& "')"
        Case "2"
            queryCondition=" KindID="&SqlCheckNum(Request("search"))
        Case "3"
            queryCondition=" ServerID="&SqlCheckNum(Request("search"))
        Case "4"
            IF IsDate(SqlCheckStr(Request("search"))) Then
                LeaveTime1=CDate(SqlCheckStr(Request("search")))
                queryCondition=" LeaveTime>='"&LeaveTime1&"' AND LeaveTime<'"&DateAdd("d",1,LeaveTime1)&"'"
            End IF
        Case "5"
            queryCondition=" UserID="&SqlCheckNum(Request("search"))      
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
	.Pkey="RecordID"						'主键
	.Field="UserID,Score,Revenue,KindID,ServerID,PlayTimeCount,OnLineTimeCount,LeaveTime"	'字段
	.Table="RecordUserLeave"				'表名
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
<br /><table width='100%'><tr>
    <td align='left'>您现在的位置：<a href="Admin_RecordUserLeave.asp">金币管理</a>&gt;&gt;<a href=Admin_RecordUserLeave.asp>&nbsp;退出房间记录</a></td>
<td align='right'>共找到 <font color=red><%=lCount %></font> 个记录</td>
</tr></table><table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('确定要执行选定的操作吗？');">	  <td>	  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td width='100' height='21' align='center'><strong>用户名</strong></td>
            <td width='85' align='center'><strong>金币</strong></td>         
            <td width='85' align='center'><strong>税收</strong></td>
            <td width='138' align='center'><strong>游戏类别</strong></td>
            <td width='76' align='center'><strong>房间</strong></td>
            <td width='138' align='center'><strong>游戏时间</strong></td>
            <td width='138' align='center'><strong>在线时间</strong></td>
            <td width='200' align='center'><strong>退房时间</strong></td>          
          </tr>
  <%
     Dim UserID,index,GameName
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有找到相关信息!<br><br></td></tr>") 
             Else
            index=1
            
            For i=0 To Ubound(rs,2)
                UserID = Rs(0,i) 
                GameName=GetKindNameByKindID(Rs(3,i))

%>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            
            <td width='100' align='center'><a title="查看用户资料" href="Admin_GameUser.asp?action=userinfo&id=<%=UserID%>"><%=GetAccountsByUserID(UserID) %></a></td>
            <td width='85' align='center'><%= Rs(1,i) %></td>         
            <td width='85' align='center'><%= Rs(2,i) %></td>           
             <td width='138' align='center'><label title="KindID是 <%=Rs(3,i) %>"><%=GameName%></label></td>
                                
	        <td width='38' align='center'><%=Rs(4,i)%></td>
	        <td width='38' align='center'><%=Rs(5,i)%></td>
	        <td width='38' align='center'><%=Rs(6,i)%></td>
	        <td width='200' align='center'><%=Rs(7,i)%></td>            
          </tr>
 <%
          index=index+1
          Next
          End IF
          %>
        </table>
		

</td>
</form>  </tr></table>
<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr></table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120' class="txtrem">用户查询:</td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='Search' type='text' id="Search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">按用户名</option>
    <option value="2">按KindID</option>
    <option value="3">按房间</option>
    <option value="4">按退房时间(天)</option>
  </select> 
<input type='submit' name='Submit2' value=' 查 询 ' />
<span class="ml">若为空，则查询所有用户</span>
   </td>
</tr></table></form>
<%
End Sub
%>




<div>
<%endtime=timer()%>本页面执行时间：<%=FormatNumber((endtime-startime)*1000,3)%>毫秒
</div>

</body>
</html>

 