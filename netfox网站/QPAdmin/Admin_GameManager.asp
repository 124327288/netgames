<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0  Then
call  RLWriteSuccessMsg("错误啦", "没有管理权限!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
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
      <td height='22' colspan='2' align='center'><strong>卡线用户管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'>
        <%
            Dim pageUrl,rs
            pageUrl="?swhat=2&search="
            Call ConnectGame("QPServerInfoDB")
            sql="select KindID,KindName from  GameKindItem(nolock) Where Nullity=0 Order by KindID "
            
            Set rs=GameConn.Execute(sql)
          
            Do While Not rs.Eof  
                Response.Write("<a href='")
                Response.Write(pageUrl)
                Response.Write(rs("KindID"))
                Response.Write("'  style='margin-right:10px;'>")
                Response.Write(rs("KindName"))
                Response.Write("</a>")             
            rs.MoveNext
	        Loop 
            rs.close
            set rs=nothing  
            CloseGame()
         %> 
         <br />
         <a href="Admin_GameManager.asp" style=" text-decoration:underline;">全部卡线用户</a>
      </td>
</tr>
</form>
</table> 

<%
Call ConnectGame("QPTreasureDB")

Select case lcase(request("action"))
    case "del"
        call del(trim(request("typeID")))
        call main()
    Case else
    Call main()
End Select

Call CloseGame()

'===============================================================================
Sub del(lID)
Dim ID, ClubName
ID = lID
    If InStr(Session("AdminSet"), ",3,")>0 Then
        GameConn.execute  "delete from GameScoreLocker where UserID in ("&ID&")"      
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有卡线清理的权限!")
        Response.End      
    End If
End Sub

'记录查询
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
Dim enterTime1

OrderStr=" CollectDate desc"

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
                enterTime1=CDate(SqlCheckStr(Request("search")))
                queryCondition=" CollectDate>='"&enterTime1&"' AND CollectDate<'"&DateAdd("d",1,enterTime1)&"'"
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
	.Pkey="UserID"						'主键
	.Field="UserID,KindID,ServerID,CollectDate"	'字段
	.Table="GameScoreLocker"				'表名
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
    <td align='left'>您现在的位置：<a href="Admin_GameUserMoney.asp">金币管理</a>&gt;&gt;<a href="Admin_GameManager.asp">&nbsp;卡线管理</a>
             <% IF lcase(request("action"))="del" Then %> 
               <span class="hit">卡线用户已处理！</span> 
              <% END IF %> 
    </td>
    <td align='right'>共找到 <span style="color:Red;"><%=lCount %></span> 个记录</td>
</tr>
</table>
<form name='myform' method='post' action=''>	
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr>
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>   
            <td width='38' align='center'><strong>选中</strong></td>           
            <td width='100' height='21' align='center'><strong>用户</strong></td>          
            <td width='138' align='center'><strong>游戏</strong></td>
            <td width='38' align='center'><strong>房间</strong></td>
            <td width='200' align='center'><strong>卡线时间</strong></td>    
            <td width="38" align="center"><strong>操作</strong></td>
          </tr>
          <%          
          Dim UserID,index,GameName
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有找到相关信息!<br><br></td></tr>") 
             Else
            index=1
            
            For i=0 To Ubound(rs,2)
                UserID = Rs(0,i) 
                GameName=GetKindNameByKindID(Rs(1,i))
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=UserID%>' /></td>
            <td width='100'><a title="查看用户资料" href="Admin_GameUser.asp?action=userinfo&id=<%=UserID%>"><%=GetAccountsByUserID(UserID) %></a></td>
            <td width='138' align='center'><label title="KindID是 <%=Rs(1,i) %>"><%=GameName%></label></td>
	        <td width='38' align='center'><%=Rs(2,i)%></td>
	        <td width='200' align='center'><%=Rs(3,i)%></td>
	        <td width='60'  align='center'><a href="?action=del&typeID=<%=UserID %>&page=<%=request("page") %>">踢用户下线</a></td>
          </tr>
          <%
          index=index+1
          Next
          End IF
          %>
        </table>
        
         <table width='100%' border='0' cellpadding='0' cellspacing='0' style=" margin-top:4px;">
        <tr> 
            <td width='191' height='23'> 
              <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' />选中本页所有成员</td>
            <td width="574">
            <div align="left"><strong>操作： </strong>
                <%IF InStr(Session("AdminSet"), ",6,")>0 Then%>
               <input name="action"  type="hidden" value="del" />
                <input type='submit' name='Submit' value=" 批量清理卡线用户 "/>
				<% End If %>		
                </div>
         </td></tr></table>
</td>
</tr></table>
</form>
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
    <option value="1" selected="selected">按用户名</option>
    <option value="2">按KindID</option>
    <option value="3">按房间</option>
    <option value="4">按卡线时间(天)</option>  
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
