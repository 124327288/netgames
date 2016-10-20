<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0 Then
call  RLWriteSuccessMsg("错误啦", "没有金币管理权限!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0 Then
call  RLWriteSuccessMsg("错误啦", "没有用户管理权限!")
Response.End
End If
 %>

<html>
<meta http-equiv='Content-Type' content='text/html; charset=gb2312' />
<link href='Admin_Style.css' rel='stylesheet' type='text/css'>

<style type="text/css">
.time_header,.addr_header, .user_header,.tradeType_header ,.insure_header,.kind_header,.server_header{ font-weight:bold;}

.time_header ,.time_item { width:130px; text-align:center;}
.addr_hader,.addr_item {width:85px; text-align:center;}
.user_header,.user_item {width:85px; text-align:left;padding-left:10px;}
.tradeType_header,.tradeType_item { width:65px; text-align:center;}
.insure_header,.insure_item {width:85px; text-align:right; padding-right:2px;}
.kind_header,.kind_item { width:130px; text-align:center;}
.server_header,.server_item {width:85px;text-align:center;}
</style>

</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name='form1' action='' method='get'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>游戏用户管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'><a href="Gold_RecordUserInsure.asp?tradeType=1">存</a> |<a href="Gold_RecordUserInsure.asp?tradeType=2"> 取</a> |  <a href="Gold_RecordUserInsure.asp?tradeType=3">转</a> | <a href="Gold_RecordUserInsure.asp">全部</a> </td>
</tr>
</form>
</table>
<%
Call ConnectGame("QPTreasureDB")

Select case lcase(request("action"))
    Case else
    Call main()
End Select

Call CloseGame()

'===============================================================================
'记录查询
Sub main()

%>
<script type="text/javascript" src="inc/ajaxrequest.js"></script>
<script type="text/javascript">
var ajax=new AJAXRequest();
var disp_ip;

ajax.timeout=60000;

function ShowIP(ip_lable,ip) {
    disp_ip=document.getElementById(ip_lable);
    ajax.get("Ajax_IPAddress.asp?ipaddr="+ip,ShowIPCallback);
}

function ShowIPCallback(obj) {        
    disp_ip.innerText=obj.responseText;
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
</script>
<%
'====================================================================================
'查询条件
Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr
Dim enterTime1

OrderStr=" InsureID desc"
queryCondition=""

IF Request("search")>"" Then
    Select case Request("swhat")
        Case "1"
            queryCondition =" SourceAccounts=N'"&sqlcheckStr(Request("search"))& "'"
         Case "2"
            queryCondition =" TargetAccounts=N'"&sqlcheckStr(Request("search"))& "'"
        Case "7"
            queryCondition =" SourceGameID="&sqlcheckStr(Request("search"))& " "
        Case "8"
            queryCondition =" TargetGameID="&sqlcheckStr(Request("search"))& " "
        Case "3"
            queryCondition =" KindID="&SqlCheckNum(Request("search"))
        Case "4"
            queryCondition =" ServerID="&SqlCheckNum(Request("search"))
        Case "5"
            IF IsDate(SqlCheckStr(Request("search"))) Then
                enterTime1=CDate(SqlCheckStr(Request("search")))
                queryCondition =" CollectDate>='"&enterTime1&"' AND CollectDate<'"&DateAdd("d",1,enterTime1)&"'"
            End IF        
        Case "6"
            queryCondition =" ClientIP='"&SqlCheckStr(Request("search"))&"'"
    End Select
End IF    

IF queryCondition<>"" Then
    queryCondition = queryCondition & " AND "
End IF

Select Case Request("tradeType")    
    Case "1"            
        queryCondition = queryCondition & " TradeType=1 "
   Case "2"            
        queryCondition = queryCondition & " TradeType=2 "
   Case "3"            
        queryCondition = queryCondition & " TradeType=3 " 
   Case "0"
        queryCondition=queryCondition & " 1=1 "
               
End Select

'Response.write queryCondition

'==============================================================================================================
'执行查询过程

Set Page = new Cls_Page				'创建对象
Set Page.Conn = GameConn				'得到数据库连接对象
With Page
	.PageSize = 20					'每页记录条数
	.PageParm = "page"					'页参数
	'.PageIndex = 10				'当前页，可选参数，一般是生成静态时需要
	.Database = "mssql"				'数据库类型,AC为access,MSSQL为sqlserver2000存储过程版,MYSQL为mysql,PGSQL为PostGreSql
	.Pkey="InsureID"						'主键
	.Field="InsureID,KindID,ServerID,SourceAccounts,TargetAccounts,InsureScore,SwapScore,Revenue,TradeType,ClientIP,CollectDate,SourceUserID,TargetUserID,IsGamePlaza"	'字段
	.Table="RecordInsure"				'表名
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
<br><table width='100%'><tr>
    <td align='left'>您现在的位置：<a href="Admin_GameUserMoney.asp">金币管理</a>&gt;&gt;<a href="Gold_RecordUserInsure.asp">&nbsp;银行记录</a></td>
<td align='right'>共找到 <font color=red><%=lCount %></font> 个记录</td>
</tr></table><table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  
<form name='myform' method='post' action=''>	
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td class="time_header">时间</td>
            <td class="addr_header">地点</td> 
            <td class="user_header">汇款人</td>
            <td class="user_header">收款人</td>
            <td class="tradeType_header">交易类别</td>            
            <td class="insure_header">银行金币</td>            
            <td class="insure_header">交易金币</td>
            <td class="insure_header">税收</td>      
            <td class="server_header">场所</td>    
            <td class="kind_header">游戏种类</td>
            <td class="server_header">游戏房间</td>
          </tr>
          <%          
          Dim srcUserID,dstUserID,index,GameName
          Dim srcAccounts,dstAccounts
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有找到相关信息!<br><br></td></tr>") 
             Else
            index=1
            
            For i=0 To Ubound(rs,2)
                srcUserID = Rs(11,i) 
                dstUserID=Rs(12,i)
                srcAccounts=Rs(3,i)
                dstAccounts=Rs(4,i)
                GameName=GetKindNameByKindID(Rs(1,i))
                
                IF GameName="" Or GameName=null Or IsNull(GameName) Then
                    GameName="N/A"
                End IF
                
                IF srcAccounts="" Or srcAccounts=null or IsNull(srcAccounts) Then
                    srcAccounts=GetAccountsByUserID(srcUserID)
                End IF
                
                IF dstAccounts="" Or dstAccounts=null or IsNull(dstAccounts) Then
                    dstAccounts=GetAccountsByUserID(dstUserID)
                End IF
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td class="time_item"><%=Rs(10,i) %></td>
            <td class="addr_item"><%=Rs(9,i) %></td>
            <td class="user_item"><a title="查看用户资料" href="Admin_GameUser.asp?action=userinfo&id=<%=srcUserID%>"><%=srcAccounts %></a></td>
            <td class="user_item"><a title="查看用户资料" href="Admin_GameUser.asp?action=userinfo&id=<%=dstUserID%>"><%=dstAccounts %></a></td>
            <td class="tradeType_item">
                <% IF Rs(8,i)=0 Then %>N/A<% End IF %>
                <% IF Rs(8,i)=1 Then %>存<% End IF %>
                <% IF Rs(8,i)=2 Then %>取<% End IF %>
                <% IF Rs(8,i)=3 Then %>转<% End IF %>
            </td>
            <td class="insure_item"><%=Rs(5,i) %></td>
            <td class="insure_item"><%=Rs(6,i) %></td>
            <td class="insure_item"><%=Rs(7,i) %></td>
      
            <td class="server_item">
                <% IF Rs(13,i)=0 Then %>网页<% End IF %>
                <% IF Rs(13,i)=1 Then %>大厅<% End IF %>
            </td>
   
            <td class="kind_item"><label title="KindID是 <%=Rs(1,i) %>"><%=GameName%></label></td>
	        <td class="server_item"><%=Rs(2,i)%></td>
          </tr>
          <%
          index=index+1
          Next
          End IF
          %>
        </table>
</td>
</form></tr></table>
<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr></table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  
<tr class='tdbg'>    
<td width='120' align="right"><strong>用户查询:</strong></td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='search' type='text' id="search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">按汇款人</option>
    <option value="2">按收款人</option>
    <option value="7">按汇款人ID</option>
    <option value="8">按收款人ID</option>
    <option value="3">按KindID</option>
    <option value="4">按房间</option>
    <option value="5">按交易时间(天)</option>
    <option value="6">按交易IP</option>
  </select>
  <select name="tradeType" id="tradeType">
    <option value="0" selected="selected">交易类别</option>
    <option value="1">存</option>
    <option value="2">取</option>
    <option value="3">转</option>
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




 