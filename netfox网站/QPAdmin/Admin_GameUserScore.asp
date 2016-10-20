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
      <td height='22' colspan='2' align='center'><strong>游戏用户管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp; <a href="Admin_GameUserScore.asp">所有用户</a> | <a href="?usertype=4">积分排名</a>| <a href="?usertype=1">比赛用户</a>| <a href="?usertype=3">按登陆次数排序</a>| <a href="?usertype=2">游戏管理员</a></td>
</tr>
</form>
</table>
<%

Dim dname,kindID,istrea,trea,curDname,KindName,curKindName
kindID=SqlCheckNum(Trim(Request("kindID")))
istrea=false
dname="QPGameScoreDB"
KindName="积分"

IF kindID<=0 Then
    dname="QPGameScoreDB"
    KindName="积分"
Else
    dname=GetDbNameByKindID(kindID)
    KindName=GetKindNameByKindID(kindID)
    IF IsNull(dname) OR dname="" Then
        dname="QPGameScoreDB"
        KindName="积分"
    Else        
        Session("db_name_qp")=dname
        Session("kind_name_qp")=KindName
    End IF
End IF

'当前操作库判断
curDname=Session("db_name_qp")
curKindName=Session("kind_name_qp")
IF kindD>0 OR IsNull(curDname) OR curDname="" Then
    Session("db_name_qp")=dname
    Session("kind_name_qp")=KindName
Elseif kindID<=0 Then
    dname=curDname
    KindName=curKindName
End IF

'Response.Write KindName
'Response.Write dname


Call ConnectGame(dname)
    select case lcase(request("action"))
    case "add"
    call add()
    case "modifyl"
    case "del"
    call del(cint(trim(request("id"))))
    call main()
    case "savemodifyl"
    case "saveadd"
    call saveadd()
    case "userinfo"
    call userinfo()
    case "saveuserinfo"
    call saveuserinfo()
    call main()
    case "update"
    call UpdateUser()
    case "doupdate"
    call doupdate()
    case else
    call main()
    end select
Call CloseGame()

'==================================================================================================
'保存金币信息
Sub saveuserinfo()
Dim UserRight, UserRightArr, MasterRight, MasterRightArr,fname
fname="myform" '表单
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from GameScoreInfo where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
' 关键字段
IF InStr(Session("AdminSet"), ",7,")>0 Then
    rs("Score") = SqlCheckNum(Request("in_Score"))
    
    IF istrea=true Then
        rs("Revenue") = SqlCheckNum(Request("in_Revenue"))
        rs("InsureScore") = SqlCheckNum(Request("in_InsureScore"))
    End IF
End IF

'权限判断
IF InStr(Session("AdminSet"), ",8,")>0 Then
    UserRightArr = Split(SqlCheckStr(Request("in_UserRight")), ",")
    UserRight = 0
    For RL_i=0 To Ubound(UserRightArr)
    UserRight = UserRight Or SqlCheckNum(UserRightArr(RL_i))
    Next
    rs("UserRight") = UserRight
    MasterRightArr = Split(SqlCheckStr(Request("in_MasterRight")), ",")
    MasterRight = 0
    For RL_i=0 To Ubound(MasterRightArr)
    MasterRight = MasterRight Or SqlCheckNum(MasterRightArr(RL_i))
    Next
    rs("MasterRight") = MasterRight
    rs("MasterOrder")= CLng(GetInfo(1,fname,"in_MasterOrder"))
End IF

'输赢记录
rs("WinCount") = SqlCheckNum(Request("in_WinCount"))
rs("LostCount") = SqlCheckNum(Request("in_LostCount"))
rs("DrawCount") = SqlCheckNum(Request("in_DrawCount"))
rs("FleeCount") = SqlCheckNum(Request("in_FleeCount"))

'游戏日志
rs("AllLogonTimes") = SqlCheckNum(Request("in_AllLogonTimes"))
rs("PlayTimeCount") = SqlCheckNum(Request("in_PlayTimeCount"))
rs("OnLineTimeCount") = SqlCheckNum(Request("in_OnLineTimeCount"))
rs("LastLogonDate") = SqlCheckStr(Trim(Request("in_LastLogonDate")))
rs("LastLogonIP") = GetInfo(0,fname,"in_LastLogonIP")

rs.update

Response.Redirect("?page="&Request("page"))
End Sub

'======================================================================================
'删除用户
Sub del(lID)
Dim ID, ClubName
ID = lID
If InStr(Session("AdminSet"), ",4,")>0 Then
    GameConn.execute  "delete from GameScoreInfo where UserID="&ID
End If
End Sub

'=================================================================================
'列表用户
Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")
For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("Action")
		Case "Delselect"
			Call del(SqlCheckNum(typeIDArray(lLoop)))
		Case "normal"
			GameConn.Execute("update GameScoreInfo set LogonNullity=0 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
		Case "suoding"
			GameConn.Execute("update GameScoreInfo set LogonNullity=1 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
	End Select
Next
%>

<script type="text/javascript" src="inc/ajaxrequest.js"></script>
<script type="text/javascript">
var ajax=new AJAXRequest();
var disp_ip;

function ShowIP(ip_lable,ip) {
    disp_ip=document.getElementById(ip_lable);
    ajax.get("Ajax_IPAddress.asp?ipaddr="+ip,ShowIPCallback);
}

function ShowIPCallback(obj) {        
    disp_ip.title=obj.responseText;
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

OrderStr="UserID desc"

IF Request("search")>"" Then
    Select case Request("swhat")
	    Case "1"
		    queryCondition = " Userid=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(request("search"))& "')"	
	    Case "2"
		    queryCondition = " AllLogonTimes>='"&SqlCheckNum(Request("search"))& "'"
	    Case "3"
		    queryCondition = " AllLogonTimes<'"&SqlCheckNum(Request("search"))& "'"
	    Case "4"
		    queryCondition = " LastLogonIP='"&sqlcheckStr(Request("search"))& "'"
        Case "5"
		    queryCondition = " score>='"&SqlCheckNum(Request("search"))& "'"
		Case "6"
		    queryCondition = " score<'"&SqlCheckNum(Request("search"))& "'"
    End Select
END IF

If request("usertype")<>"" Then
    select case request("usertype")
	    case "1"
		    queryCondition=" UserRight=268435456"
	    case "2"
		    queryCondition=" MasterOrder>0"
	    case "3"
		    OrderStr=" AllLogonTimes DESC"
	    case "4"
		    OrderStr=" Score DESC"
    End Select
End If

Dim fields
fields="UserID,Score,Revenue,InsureScore,WinCount,LostCount,DrawCount,FleeCount,PlayTimeCount,AllLogonTimes,LastLogonIP"

IF istrea=false Then 
fields="UserID,Score,Score AS Revenue,Score AS InsureScore,WinCount,LostCount,DrawCount,FleeCount,PlayTimeCount,AllLogonTimes,LastLogonIP"
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
	.Field=fields	'字段
	.Table="GameScoreInfo"				'表名
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
    <td align='left'>您现在的位置：<a href="Admin_GameUserScore.asp"><%=KindName %>管理</a>&gt;&gt;<a href="Admin_GameUserScore.asp">&nbsp;所有成员列表</a></td>
<td align='right'>共找到 <font color=red><%=lCount%></font> 个用户</td>
</tr></table>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'><tr>
    <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('确定要执行选定的操作吗？');">
      <td>
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td width='108' align='center'><strong>用户名</strong></td>
            <td width='85' height='21' align='center'><strong>积分数</strong></td>
            
            <% IF istrea=true Then  %>
            <td width='85' height='21' align='center'><strong>上缴税收</strong></td>
            <td width='85' height='21' align='center'><strong>银行存款</strong></td>
            <% End IF %>
            
            <td width='108' align='center'><strong>赢局</strong></td>
            <td width='138' align='center'><strong>输局</strong></td>
            <td width='108' align='center'><strong>和局</strong></td>
            <td width='108' align='center'><strong>逃跑</strong></td>
            <td width='138' align='center'><strong>游戏时间</strong></td>
            <td width='138' align='center'><strong>登陆次数</strong></td>           
            <td width='138' align='center'><strong>登陆IP</strong></td>
            <td width='248' height='21' align='center'><strong> 操作</strong></td>
          </tr>
          <%
		    Dim UserID,index
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有找到相关信息!<br><br></td></tr>") 
             Else
            index=1
            
            For i=0 To Ubound(rs,2)
                UserID = Rs(0,i)
            %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
           <td width='108'><a href="?action=userinfo&id=<%=UserID%>"><%=GetAccountsByUserID(UserID)%></a></td>
            <td width='85'><%=FormatNumber(rs(1,i),0)%></td>
            
            <% IF istrea=true Then  %>
            <td width='85'><%=FormatNumber(rs(2,i),0)%></td>
            <td width='85'><%=FormatNumber(rs(3,i),0)%></td>
            <% End IF %>
            
            <td width='108' align='center'><%=rs(4,i)%></td>
            <td width='138' align='center'><%=rs(5,i)%></td>
            <td width='108' align='center'><%= Rs(6,i) %></td>
            <td width='108' align='center'><%=rs(7,i)%></td>
            <td width='138' align='center'><%=rs(8,i)%></td>
            <td width='138' align='center'><%=rs(9,i)%></td>            
            <td width='138'><label id="disp_ip_<%=index %>" title="正在查询IP归属..."><%=rs(10,i)%></label><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=rs(10,i) %>')",800*<%=index %>);</script></td>
            <td width='248' align='center'><a href="?action=userinfo&id=<%=UserID%>&page=<%=Request("page") %>">详细信息</a></td>
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
</tr>
</table>

<form id="search_request" method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>用户查询:</strong></td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='search' type='text' id="search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">按用户名</option>    
    <option value="4">按登陆IP</option>
    <option value="5">按金币大于</option>
    <option value="6">按金币小于</option>
    <option value="2">按登陆次数大于</option>
    <option value="3">按登陆次数小于</option>
  </select> 
<input type='submit' name='submit2' value=' 查 询 ' />
<span class="ml">若为空，则查询所有用户</span>
</td>
</tr></table>
</form>

<%
End Sub

'====================================================================================
'保存玩家金币
Sub userinfo() 
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  GameScoreInfo  where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
%>
<form name='myform' action='?action=saveuserinfo&id=<%=Request("id") %>&page=<%=Request("page") %>' method='post'>

<table width='100%'><tr>
    <td align='left'>您现在的位置：<a href="Admin_GameUserScore.asp?page=<%=Request("page") %>"><%=KindName %>管理</a>&gt;&gt;&nbsp;修改用户积分</td>
<td align='right'></td>
</tr></table>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr class='title'> 
      <td height=22 colspan=2 align='center'> <b>修改用户积分</b></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">用户名：</td>
      <td> <%=GetAccountsByUserID(rs("UserID")) %>
        <a class="ml detiallink" href="Admin_GameUser.asp?action=userinfo&id=<%=rs("UserID") %>">查看用户基本资料</a> 
      </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">游戏ID：</td>
        <td><%=GetGameIDByUserID(rs("UserID")) %></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">积分数：</td>
      <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
        <td> <%= rs("Score") %></td>
      <%Else%>
        <td><input name='in_Score' id="in_Score" type='text' value="<%= rs("Score") %>"  size='30' maxlength='30' /></td>
       <%End IF%>
     </tr>
     
     <% IF istrea=true Then %>     
        <tr class="tdbg2">
            <td class="txtrem">上缴税收：</td>      
             <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
                <td> <%= rs("Revenue") %></td>
            <%Else%>
            <td><input name='in_Revenue' id="in_Revenue" type='text' value="<%= rs("Revenue") %>"  size='30' maxlength='30' /></td>
           <%End IF%>      
        </tr> 
         <tr class="tdbg">
            <td class="txtrem">银行存款：</td>
            <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
                <td> <%= rs("InsureScore") %></td>
            <%Else%>
            <td><input name='in_InsureScore' id="in_InsureScore" type='text' value="<%= rs("InsureScore") %>"  size='30' maxlength='30' /></td>
           <%End IF%>   
        </tr>
    <% End IF %>
	<tr class='tdbg2'> 
      <td class="txtrem">赢局：</td>
      <td> <input name='in_WinCount' id="in_WinCount" type='text' value="<%=rs("WinCount")%>"  size='30' maxlength='30' /></td>
     </tr> 
	<tr class='tdbg'> 
      <td class="txtrem">输局：</td>
      <td> <input name='in_LostCount' id="in_LostCount" type='text' value="<%=rs("LostCount")%>"  size='30' maxlength='30' /></td>
     </tr>
	<tr class='tdbg'> 
      <td class="txtrem">和局：</td>
      <td><input name='in_DrawCount' id="in_DrawCount" type='text' value="<%= Rs("DrawCount") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">逃跑：</td>
      <td><input name='in_FleeCount' id="in_FleeCount" type='text' value="<%=rs("FleeCount")%>"  size='30' maxlength='30' /></td>
    </tr>
    <tr class="tdbg2">
        <td colspan="2" style=" height:30px;"></td>
    </tr>
    <!--#include file="inc/userpower.asp"-->
    <tr class="tdbg2">
        <td colspan="2" style=" height:30px;"></td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">总登陆次数：</td>
      <td> <input name='in_AllLogonTimes' id="in_AllLogonTimes" type='text' value="<%=rs("AllLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>    
	<tr class='tdbg'> 
      <td class="txtrem">累计游戏时间(单位:秒)：</td>
      <td><input name='in_PlayTimeCount' type='text' id="in_PlayTimeCount" value="<%= rs("PlayTimeCount") %>"  size='30' maxlength='30' /></td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">累计在线时间(单位:秒)：</td>
      <td> <input name='in_OnLineTimeCount' id="in_OnLineTimeCount" type='text' value="<%=rs("OnLineTimeCount") %>"  size='30' maxlength='30' /></td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">最后登陆时间：</td>
      <td>
      <input name='in_LastLogonDate' id="in_LastLogonDate" type='text' value="<%=rs("LastLogonDate")%>"  size='30' maxlength='30' /></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">最后登陆IP：</td>
      <td>
      <input name='in_LastLogonIP' type='text' id="in_LastLogonIP" value="<%=rs("LastLogonIP")%>"  size='30' maxlength='30' /><span class="ml"><%=GetCityFromIP(rs("LastLogonIP")) %></span></td>
    </tr>
    <tr class='tdbg'> 
      <td height='40' colspan='2' align='center'> <input name="Submit3"   type="submit" id='Submit3' value='保存修改结果' class="button_on" /> 
      </td>
    </tr>
  </table>
</form>
<%
rs.close
Set rs=nothing
End Sub
%>

<div>
<%endtime=timer()%>本页面执行时间：<%=FormatNumber((endtime-startime)*1000,3)%>毫秒
</div>

</body>
</html>



