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
<meta http-equiv='Content-Type' content='text/html; charset=gb2312' />
<link href='Admin_Style.css' rel='stylesheet' type='text/css' />
<!--#include file="inc/links.asp"-->
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<form name='form1' action='' method='get'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>游戏用户管理</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'>&nbsp;&nbsp; <a href="Admin_GameUser.asp">所有用户列表</a> |&nbsp;&nbsp;<a href='Admin_GameUser.asp'>新进用户</a>&nbsp;| <a href="Admin_GameUser.asp?usertype=1">会员用户</a> | <a href="Admin_GameUser.asp?usertype=2">管理人员</a> | <a href="?usertype=6">推广人员</a>| <a href="Admin_GameUser.asp?usertype=3">经验排名</a>| <a href="Admin_GameUser.asp?usertype=5" ><span style=" color:Red; text-decoration:line-through; font-weight:bold;">停权用户</span></a> | <a href="Admin_GameUserMoney.asp?usertype=4">金币排行</a> | <a href="?usertype=7"><span style="color:#ad0000; font-weight:bold;">魅力排行</span></a></td>
</tr>
</table>
</form>
<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border' style="margin-top:4px;">
<tr class='tdbg'>    
<td width='100'><strong>用户查询:</strong></td>
<td width='687'>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Text1"  size='20' maxlength='30'>
  <select name="swhat">
    <option value="1" selected="selected">按用户名</option>   
    <option value="5">按游戏ID</option>
    <option value="3">按注册IP</option>
    <option value="4">按登陆IP</option>    
  </select> 
<input type='submit' name='Submit2' value=' 查 询 ' />
</td>
<td>若为空，则查询所有用户</td>
</tr></table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action"))
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
End Select
Call CloseGame()

Sub saveuserinfo()
Dim UserRight, UserRightArr, MasterRight, MasterRightArr,fname
fname="myform"  '表单名称
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from AccountsInfo where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3

' 用户名
If InStr(Session("AdminSet"), ",2,")>0 Then
    rs("Accounts") = Left(Trim(GetInfo(0,fname,"in_Accounts")),31)
    
    IF Trim(request("in_password1"))<>"" Then
        rs("LogonPass") = md5(Trim(request("in_password1")),32)
    End IF
    
    IF Trim(request("in_password2"))<>"" then
        rs("InsurePass") = md5(Trim(request("in_password2")),32)
    End IF
End If

'帐号安全
rs("Gender") = GetInfo(1,fname,"in_Gender")
rs("Nullity") = SqlCheckNum(Request("in_Nullity"))
rs("StunDown")=SqlCheckNum(Request("in_StunDown"))
rs("MoorMachine")= CLng(SqlCheckNum(Request("in_MoorMachine")))
rs("MachineSerial")= Left(GetInfo(0,fname,"in_MachineSerial"),32)

'权限分配
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

'个性化资料
If IsNumeric(Request("in_FaceID")) And Request("in_FaceID")<>"" Then
    rs("FaceID") = CLng(Request("in_FaceID"))
Else
    rs("FaceID") = 0
End If
If FaceID>247 Then
    rs("FaceID") = 0
End If
rs("UnderWrite") = Left(GetInfo(0,fname,"in_UnderWrite"),63)

'会员资料
rs("MemberOrder") = SqlCheckNum(Request("in_MemberOrder"))
rs("MemberOverDate") = CDate(LTrim(RTrim(SqlCheckStr(Request("in_MemberOverDate")))))
rs("Experience") = SqlCheckNum(Request("in_Experience"))

'登录日志
rs("WebLogonTimes") = GetInfo(0,fname,"in_WebLogonTimes")
rs("GameLogonTimes") = GetInfo(0,fname,"in_GameLogonTimes")
rs("RegisterDate") = SqlCheckStr(Request("in_RegisterDate"))
rs("LastLogonDate") = SqlCheckStr(Request("in_LastLogonDate"))
rs("RegisterIP") = SqlCheckStr(Request("in_RegisterIP"))
rs("LastLogonIP") = SqlCheckStr(Request("in_LastLogonIP"))
rs.update

Response.Redirect("?page="&Request("page"))
End Sub

Sub del(lID)
Dim ID, ClubName
ID = lID
    If InStr(Session("AdminSet"), ",3,")>0 Then
        GameConn.execute  "delete from AccountsInfo where UserID="&ID       
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有删除用户的权限!")
        Response.End      
    End If
End Sub

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")
For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("Action")
		Case "Delselect"
			Call del(SqlCheckNum(typeIDArray(lLoop)))
		Case "normal"
			GameConn.Execute("update AccountsInfo set Nullity=0 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
		Case "suoding"
			GameConn.Execute("update AccountsInfo set Nullity=1 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
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
    disp_ip.innerText=obj.responseText;
    disp_ip.title=disp_ip.title+"\n"+obj.responseText;
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

Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr

OrderStr="UserID desc"
'查询条件
IF request("search")>"" Then
    Select case Request("swhat")
	    Case "1"
		    queryCondition = " Accounts='"&sqlcheckStr(request("search"))& "'"	
	    Case "3"
		    queryCondition = " RegisterIP='"&sqlcheckStr(request("search"))& "'"
	    Case "4"
		    queryCondition = " LastLogonIP='"&sqlcheckStr(request("search"))& "'"
        Case "5"
		    queryCondition = " gameid='"&SqlCheckNum(request("search"))& "'"
	     Case "6"
		    queryCondition = " SpreaderID='"&sqlcheckStr(request("search"))& "'"
        Case "7"
		    queryCondition = " UserID='"&sqlcheckStr(request("search"))& "'"	
    End Select
End IF

If request("usertype")<>"" Then
    Select case request("usertype")
	    case "1"	
	        queryCondition =" MemberOrder>0 "	  
		    OrderStr=" MemberOrder desc"
	    case "2"
		    queryCondition=" MasterOrder>0"
	    case "3"
		    OrderStr=" Experience DESC"
	    case "4"
		    OrderStr=" GameLogonTimes DESC"
        case "5"
		    queryCondition=" nullity=1 "
	    case "6"
		    queryCondition=" UserID IN (select SpreaderID from AccountsInfo(nolock)) "	
		Rem 魅力排行
		case "7"
		    OrderStr=" Loveliness DESC"
    End Select
End If

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
	.Field="UserID,GameID,Accounts,Gender,Nullity,FaceID,MemberOrder,MemberOverDate,RegisterDate,RegisterIP,Experience,MasterOrder,Loveliness"	'字段
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
        <td align='left'>您现在的位置：<a href="Admin_GameUser.asp">用户管理</a>&gt;&gt;&nbsp;<a href="Admin_GameUser.asp">所有成员列表</a>
                    <% IF Trim(Request("action")="normal")  THEN %>
                        <span class="hit">批量取消停权用户完成！ </span>
                   <% 
                    END IF 
                    IF Trim(Request("action")="suoding")  THEN %> 
                     <span class="hit">批量停权用户完成！ </span> 
                   <% 
                  END IF 
                   IF Trim(Request("action")="Delselect")  THEN %>
                     <span class="hit">批量删除用户完成！  </span> 
                  <% END IF %> 
        </td>
        <td align='right'>共找到 <font color=red><%=lCount%></font> 个用户</td>
        </tr></table>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('确定要执行选定的操作吗？');">	  <td>	  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'><strong>选中</strong></td>
            <td width='33' align='center'><strong>ID</strong></td>
            <td width='85' height='21' align='center'><strong>用户名</strong></td>
            <td width='50' align='center'><strong>性别</strong></td>
            <td width='80' align='center'><strong>用户状态</strong></td>
            <% If Request("usertype")="3" Then %>
                <td width='60' align='center'><strong>用户经验</strong></td>
            <% End If %> 
            <% If Request("usertype")="7" Then %>
                <td width='60' align='center'><strong>魅力值</strong></td>
            <% End If %> 
            <td width='60' align='center'><strong>头 像</strong></td>
            
             <% If Request("usertype")="2" Then %>
                <td width='60' align='center'><strong>管理级别</strong></td>
             <% Else %> 
                <td width='60' align='center'><strong>会员级别</strong></td>
             <% End If %>
            <td width='138' align='center'><strong>会员到期日期</strong></td>
            <td width='138' align='center'><strong>注册日期</strong></td>
            <td width='138' align='center'><strong>注册地址</strong></td>
            <td width='70' height='21' align='center'><strong> 操作</strong></td>
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
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=UserID%>'></td>
            <td width='33' align='center'><%=rs(1,i)%></td>
            <td width='85'><a href='?action=userinfo&id=<%=UserID%>' title="用户：<%=rs(2,i)%> 经验值：<%=rs(10,i) %>">
                <% IF rs(6,i)=0 Then%>
                    <%=rs(2,i)%>          
                <% ELSEIF rs(6,i)=1 THEN %>  
                <span style="color:#ff0000;font-weight:bold;"><%=rs(2,i)%></span> 
                <% ELSEIF rs(6,i)=2 THEN %>  
                <span style="color:#105399;font-weight:bold;"><%=rs(2,i)%></span>   
                <% ELSEIF rs(6,i)=3 THEN %>  
                    <span style="color:#cd6a00; font-weight:bold;"><%=rs(2,i)%></span> 
                <% ELSEIF rs(6,i)=4 THEN %>  
                    <span style="color:#ad0000; font-weight:bold;"><%=rs(2,i)%></span> 
               <% END IF %> 
            </a> 
            </td>
            <td width='50' align='center'>
			<% If rs(3,i)=0 Then %>
			保密
			<% Elseif rs(3,i)=1 Then%>
			男		
			<% Else %>
			女
			<% End If %>
			</td>
            <td width='80' align='center'><% If rs(4,i)=True Then %><span style="color:Red; text-decoration:line-through; font-weight:bold;">禁止</span><% Else %><span style="color:green;">正常</span><% End If %></td>
            
             <% If Request("usertype")="3" Then %>
                <td width='60' align='center'><%=rs(10,i) %></td>
            <% End If %> 
            
             <% If Request("usertype")="7" Then %>
                <td width='60' align='center'><%=rs(12,i) %></td>
            <% End If %> 
            
            <td width='60' align='center'><img width="25" height="25" src="gamepic/face<%=Rs(5,i) %>.gif" alt="" /></td>
            
             <% If Request("usertype")="2" Then %>
                <td width='60' align='center'>
                    <% IF rs(11,i)=0 Then%>
                        普通会员             
                    <% ELSEIF rs(11,i)=1 THEN %>  
                    <span style="color:#105399;font-weight:bold;">内部网管</span> 
                    <% ELSEIF rs(11,i)=2 THEN %>  
                    <span style="color:#cd6a00;font-weight:bold;">外部网管</span> 
                   <% END IF %> 
                </td>
            <% Else %> 
                <td width='60' align='center'>
                    <% IF rs(6,i)=0 Then%>
                        普通会员             
                    <% ELSEIF rs(6,i)=1 THEN %>  
                    <span style="color:#ff0000;font-weight:bold;">红钻</span> 
                    <% ELSEIF rs(6,i)=2 THEN %>  
                    <span style="color:#105399;font-weight:bold;">蓝钻</span>   
                    <% ELSEIF rs(6,i)=3 THEN %>  
                        <span style="color:#cd6a00; font-weight:bold;">黄钻</span>
                   <% ELSEIF rs(6,i)=4 THEN %>  
                        <span style="color:#ad0000; font-weight:bold;">紫钻</span>  
                   <% END IF %> 
                </td>
            <% End If %>
            <td width='138' align='center'><%=rs(7,i)%></td>
            <td width='138' align='center'><%=rs(8,i)%></td>            
			<td width='138'><span id="disp_ip_<%=index %>" class="ipblock" title="<%=rs(9,i) %>">正在查询IP...</span><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=rs(9,i) %>')",800*<%=index %>);</script></td>
            <td width='70' align='center'><a href='?action=userinfo&id=<%=UserID%>&page=<%=Request("page") %>'>详细信息</a></td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
		
        <table width='100%' border='0' cellpadding='0' cellspacing='0' style="margin-top:4px;">
        <tr> 
            <td width='191' height='23'> 
              <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' />选中本页所有成员</td>
            <td width="574">
            <div align="left"><strong>操作： </strong>
                <%IF InStr(Session("AdminSet"), ",6,")>0 Then%>
                <input name='Action' type='radio' value='Delselect' />删除会员
				<% End If %>
				<input name='Action' type='radio' value='normal' checked="checked" />取消停权
				<input name='Action' type='radio' value='suoding' />停权用户				
                <input type='submit' name='Submit' value=' 执 行 '/>
                </div>
         </td></tr></table>

</td>
</form>  
</tr></table>

<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>用户查询:</strong></td>
<td width='350'>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='20' maxlength='30'>
  <select name="swhat">
    <option value="1" selected="selected">按用户名</option>   
    <option value="5">按游戏ID</option>
    <option value="3">按注册IP</option>
    <option value="4">按登陆IP</option>    
  </select> 
<input type='submit' name='Submit2' value=' 查 询 ' />
</td>
<td>若为空，则查询所有用户</td>
</tr></table>
</form>
<%
End sub

Rem 用户资料
Sub userinfo()
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  AccountsInfo(nolock)  where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
%>
<script type="text/javascript">
     function GetDate(days){
        var objDate = new Date(new Date()-0+days*86400000); 
        var year=objDate.getFullYear();
        var month=objDate.getMonth()+1;
        var date=objDate.getDate();
        var day=objDate.getDay();
        
        return ""+year+"-"+month+"-"+(day);
    }
    function OnMemberOrderChange(mOrder) {
       // alert(memberOrder);       
       // alert(mOrder);      
        var days=document.getElementById("in_MemberOverDate");
        switch (mOrder){
            case 1:
                days.value=GetDate(30);
                break;
            case 2:
            days.value=GetDate(30);
            break;
            case 3:
            days.value=GetDate(60);
            break;
            case 4:
            days.value=GetDate(90);
            break;
            case 0:
            default:
            days.value="1982-01-01";
            break;
        }
        
        //alert(days.value);
    }
</script>
<form name='myform' action='?action=saveuserinfo&id=<%=request("id") %>&page=<%=Request("page") %>' method='post'>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr> 
      <td colspan="2" class='title'>修改用户信息</td>
    </tr>
	<tr class='tdbg'>
      <td class="txtrem">游戏ID：</td>
      <td> <%= rs("GameID") %>
        <span class="username mr">原用户名：<%=rs("RegAccounts") %></span> 
        <a class="ml detiallink" href="Admin_GameUserMoney.asp?action=userinfo&id=<%=rs("UserID") %>">查看用户金币</a>
        <a class="ml detiallink" href="Admin_RecordUserEnter.asp?swhat=5&search=<%=rs("UserID") %>">查看用户进入房间记录</a>
        <a class="ml detiallink" href="Admin_RecordUserLeave.asp?swhat=5&search=<%=rs("UserID") %>">查看用户退出房间记录</a>
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">用户名：</td>
      <td>
      <input name='in_Accounts' id="in_Accounts" type='text' value="<%=rs("Accounts") %>"  size='30' maxlength='31' />     
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">登录密码：</td>
      <td><input name='in_password1' id="in_password1"  type='text' size='30' maxlength='30' /> 留空不修改</td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">银行密码：</td>
      <td><input name='in_password2' id="in_password2"  type='text' size='30' maxlength='30' class="input" /> 留空不修改</td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">性别：</td>
      <td>
           <input name="in_Gender" type="radio" value="0"<% If rs("Gender")=0 Then %> checked<% End If %> />保密
           <input name="in_Gender" type="radio" value="1"<% If rs("Gender")=1 Then %> checked<% End If %> /><img src="Images/boy.gif" alt="男性" />GG
          <input name="in_Gender" type="radio" value="2"<% If rs("Gender")=2 Then %> checked<% End If %> /><img src="Images/girl.gif" alt="女性" />MM 
       </td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">密码保护：</td>
        <td></td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">禁止服务：</td>
      <td>
          <input name="in_Nullity" type="radio" value="0"<% If rs("Nullity")=0 Then %> checked<% End If %> />正常
          <input name="in_Nullity" type="radio" value="1"<% If rs("Nullity")=True Then %> checked<% End If %> />锁定
      </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">帐号安全关闭：</td>
        <td>
            <input name="in_StunDown" type="radio" value="0"<% If rs("StunDown")=0 Then %> checked<% End If %> />正常
            <input name="in_StunDown" type="radio"  value="1"<% If rs("StunDown")=True Then %> checked<% End If %> />安全关闭
        </td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">固定机器：</td>
        <td>
            <input name="in_MoorMachine" type="radio"  value="0"<% If rs("MoorMachine")=0 Then %> checked<% End If %> />未启用
            <input name="in_MoorMachine" type="radio"  value="1"<% If rs("MoorMachine")=1 Then %> checked<% End If %> /><span class="green">使用中</span>
            <input name="in_MoorMachine" type="radio"  value="2"<% If rs("MoorMachine")=2 Then %> checked<% End If %> />正等待玩家进入客户端
        </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">机器码：</td>
        <td><input name="in_MachineSerial" type="text"  value="<%=Trim(rs("MachineSerial")) %>" maxlength="32" size='36' class="input" /></td>
    </tr>
    <tr class="tdbg2">
    <td colspan="2" style="height:30px;"></td>
    </tr> 
    <tr class='tdbg'> 
      <td class="txtrem">用户等级(赠送会员)：</td>
     <td> 
    	<input name="in_MemberOrder" id="in_MemberOrder0" type="radio" value="0"<% If rs("MemberOrder")=0 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(0);" /><label for="in_MemberOrder0">普通会员</label>
        <input name="in_MemberOrder" id="in_MemberOrder1"type="radio" value="1"<% If rs("MemberOrder")=1 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(1);"/> <label for="in_MemberOrder1" style="color:#ff0000;font-weight:bold;">红钻</label>
        <input name="in_MemberOrder" id="in_MemberOrder2"type="radio" value="2"<% If rs("MemberOrder")=2 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(2);"/> <label for="in_MemberOrder2" style="color:#105399;font-weight:bold;">蓝钻</label>
        <input name="in_MemberOrder" id="in_MemberOrder3"type="radio" value="3"<% If rs("MemberOrder")=3 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(3);"/><label for="in_MemberOrder3" style="color:#cd6a00; font-weight:bold;">黄钻</label>
        <input name="in_MemberOrder" id="in_MemberOrder4"type="radio" value="4"<% If rs("MemberOrder")=4 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(4);"/><label for="in_MemberOrder4" style="color:#ad0000; font-weight:bold;">紫钻</label>
    </td></tr>
    <tr class='tdbg'> 
      <td class="txtrem">会员过期时间：</td>
      <td> 
      <input name='in_MemberOverDate' id="in_MemberOverDate" type='text' value="<%=rs("MemberOverDate") %>"  size='30' maxlength='30' />
        <img src="images/DatePicker/skin/datePicker.gif" alt="日期" width="16" height="22" style="cursor:hand;" onClick="new WdatePicker(myform.in_MemberOverDate,null,false,'whyGreen')" />
      </td>
    </tr>   
	<!--#include file="inc/userpower.asp"-->	 
	<tr class='tdbg'> 
      <td class="txtrem">用户头像：</td>
      <td><img width="32" height="32" name="in_FaceID" id="in_FaceID" src="gamepic/face<%= Rs("FaceID") %>.gif" />
			  <select name="in_FaceID" size="1" onChange="document.images.in_FaceID.src='gamepic/face'+this.value+'.gif';" class="input" ID="Select1">
			  <% For RL_i=0 To 247 %>           
			  <option value="<%=RL_i%>">头像<%= RL_i+1 %></option>
              <% Next %>
			  </select>
	  </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">个性签名：</td>
        <td>
        <textarea name="in_UnderWrite" cols="50" rows="5" class="input"><%=Trim(Rs("UnderWrite")) %></textarea>
        </td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">玩家经验：</td>
      <td> <input name='in_Experience' id="in_Experience" type='text' value="<%= rs("Experience") %>"  size='30' maxlength='30'></td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">推广员：</td>
        <td>
            <% Dim spreader
                spreader=GetAccountsByUserID(rs("SpreaderID")) 
               IF spreader<>"" Then
                   Response.Write("<a class='detiallink' href='?swhat=7&search="&rs("SpreaderID")&"'>"&spreader&"</a>") 
               End IF   
            %>
        </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">推广业绩：</td>
        <td>
        <% Dim spreadCount
            spreadCount=GetSpreadCount(rs("UserID"))
            IF spreadCount>0 Then
                Response.Write("<span class='green'>"&spreadCount&"</span> 人 <a class='detiallink' href='?swhat=6&search="&rs("UserID")&"'>详细情况</a>")             
            End IF
        %>        
        </td>
    </tr>
    <tr class="tdbg2">
    <td colspan="2" style="height:30px;"></td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">网站登陆次数：</td>
      <td> <input name='in_WebLogonTimes' id="in_WebLogonTimes" type='text' value="<%= rs("WebLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">大厅登陆次数：</td>
      <td> <input name='in_GameLogonTimes' id="in_GameLogonTimes" type='text' value="<%= rs("GameLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">注册时间：</td>
      <td> <input name='in_RegisterDate' id="in_RegisterDate" type='text' value="<%= rs("RegisterDate") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">最后登陆时间：</td>
      <td><input name='in_LastLogonDate' id="in_LastLogonDate" type='text' value="<%= rs("LastLogonDate") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">注册IP：</td>
      <td> <input name='in_RegisterIP' id="in_RegisterIP" type='text' value="<%= rs("RegisterIP") %>"  size='30' maxlength='30' class="mr"><%= GetCityFromIP(rs("RegisterIP")) %></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">最后登陆IP：</td>
      <td> <input name='in_LastLogonIP' id="in_LastLogonIP" type='text' value="<%= rs("LastLogonIP") %>"  size='30' maxlength='30' class="mr"><%=GetCityFromIP(rs("LastLogonIP")) %></td>
    </tr>    
    <tr class='tdbg'> 
      <td height='40' colspan='2' align='center'> <input name="Submit2"   type="submit" id='Submit2' class="button_on" value='保存修改结果'> 
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

