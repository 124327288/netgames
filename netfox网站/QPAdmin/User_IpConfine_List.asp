<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",10,")<=0  Then
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
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name='form1' action='' method='get'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>IP 地址限制管理</strong></td>
</tr>
<tr class='tdbg'>
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp;<a href='?confinetype=2'>禁用时间过期用户</a>&nbsp;| <a href="?confinetype=3">禁用时间有效用户</a> | <a href="User_IpConfine_List.asp">所有受限 IP 地址</a> | <a href="User_IpConfine.asp">全部用户列表</a></td>
</tr>
</form>
</table>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action"))   
    case "addconfine"
    call addConfineIp()    
    call main()
    case "delconfine" 
    call delConfineIp()    
    case "chgconfine"
    call GetConfineIp()
    case "saveconfine"
    call SaveConfineIp()
    call main()  
    case else
    call main()
End Select
Call CloseGame()

'保存 IP 地址限制
Sub SaveConfineIp()
Dim fname,sqlText,ipAddr,enjoinLogon,enjoinRegister,enjoinOverDate,collectNote
fname="myform"  '表单名称
ipAddr=GetInfo(0,fname,"ip")
enjoinLogon=GetInfo(0,fname,"in_enjoinLogon")
enjoinRegister=GetInfo(0,fname,"in_enjoinRegister")
enjoinOverDate=SqlCheckStr(Request("in_EnjoinOverDate"))
collectNote=Left(GetInfo(0,fname,"in_CollectNote"),32)

If enjoinOverDate="" Then
    enjoinOverDate=Now()  
End If
    If InStr(Session("AdminSet"), ",9,")>0 Then
        sqlText="Update ConfineAddress Set enjoinLogon="&enjoinLogon&", enjoinRegister="&enjoinRegister&",enjoinOverDate='"&enjoinOverDate&"',collectNote=N'"&collectNote&"'"&" Where AddrString='"&ipAddr&"'"
        GameConn.execute  sqlText
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有修改IP 地址限制的权限!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub delConfineIp()
Dim ipAddr,fname
fname="myform"  '表单名称
ipAddr=GetInfo(0,fname,"ip")
    If InStr(Session("AdminSet"), ",10,")>0 Then
        GameConn.execute  "Delete From ConfineAddress Where AddrString='"&ipAddr&"'"
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行IP 地址限制的权限!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub addConfineIp()
Dim ipAddr,fname
fname="myform"  '表单名称
ipAddr=GetInfo(0,fname,"ip")
    If InStr(Session("AdminSet"), ",10,")>0 Then
        GameConn.execute  "Insert ConfineAddress(AddrString,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&ipAddr&"',1,1,'"&DateAdd("d",1,Now)&"')"
    Else
        call  RLWriteSuccessMsg("错误啦", "您没有进行机器码限制的权限!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub main()
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
    disp_ip.title=  obj.responseText;  
    disp_ip.innerText="查看归属地区";
    disp_ip.className="s14_bg";
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

OrderStr="CollectDate desc"
'查询条件
IF request("search")>"" Then
    Select case Request("swhat")      
		Case "8"
		    queryCondition = " AddrString='"&sqlcheckStr(request("search"))& "'"
    End Select
End IF

IF request("confinetype")>"" Then
    Select Case request("confinetype")
        Case "2"
            queryCondition=" EnjoinOverDate<='"&Now()&"'"
         Case "3"
            queryCondition=" EnjoinOverDate>'"&Now()&"'"
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
	.Pkey="AddrString"						'主键
	.Field="AddrString,EnjoinLogon,EnjoinRegister,EnjoinOverDate,CollectDate,CollectNote"	'字段
	.Table="ConfineAddress"				'表名
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
        <td align='left'>您现在的位置：<a href="User_IpConfine.asp">IP 地址限制管理</a>&gt;&gt;<a href="User_IpConfine_List.asp">&nbsp;所有受限IP 地址列表</a></td>
        <td align='right'>共找到 <font color="red"><%=lCount%></font> 个用户</td>
        </tr></table>
      <form name='myform' method='Post' action='?'>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>      
    <td>	  
    <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>           
            <td width='250' align='center'><strong>IP 地址</strong></td>
            <td width='85' height='21' align='center'><strong>用户登录</strong></td>
             <td width='85' height='21' align='center'><strong>用户注册</strong></td>          
             <td width='115' height='21' align='left'><strong>失效时间</strong></td>
             <td width='115' height='21' align='left'><strong>记录日期</strong></td>
             <td width='150' height='21' align='left'><strong>说明</strong></td>
            <td width='85' height='21' align='center'><strong> 操作</strong></td>
          </tr>
          <%
		    Dim ipAddr2,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>没有任何信息!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            ipAddr2 = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='250'>
            <% If rs(3,i)<=Now() Then %>
            <span class="fontDash" title="禁止时间已经失效，点击【取消限制】删除！"><%=ipAddr2 %></span>
            <% Else %>
            <%=ipAddr2 %>
            <% End If %>
            <span id="disp_ip_<%=index %>" class="ml">正在查询IP...</span><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=ipAddr2 %>')",800*<%=index %>);</script> 
            </td>
            <td width='85' align='center'>
                <% If rs(1,i) Then %>
                    <label style="color:red; font-weight:600;">禁止</label> 
               <% Else %>
               <label style="color:Green;font-weight:bold;">允许</label>
              <% End If %> 
            </td>
            <td width='85' align='center'>
             <% If rs(2,i) Then %>
                    <label style="color:red; font-weight:600;">禁止</label> 
               <% Else %>
                <label style="color:Green;font-weight:bold;">允许</label>
              <% End If %> 
            </td>           
            <td width='115'><%=rs(3,i)%></td>
            <td width='115'><%=rs(4,i)%></td>           
            <td width='150'><%=rs(5,i)%></td> 
            <td width='85' align='center'>
              <% IF IsConfineIp(ipAddr2) Then %>
                <a href="?action=delconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>" style="color:Red;">取消限制</a>
            <% Else %>
                <a href="?action=addconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>">限制</a>            
            <% End IF %>
                <a href="?action=chgconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>">修改</a>        
            </td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
	      
</td>
</tr></table>
    </form> 

<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>

<form id='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>用户查询:</strong></td>
<td >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='30' maxlength='64' />
  <select name="swhat" id="swhat">    
    <option value="8">按IP 地址</option> 
  </select> 
<input type='submit' name='Submit2' value=' 查 询 ' />
</td>
<td>若为空，则查询所有用户</td>
</tr></table>
</form>
<%
End sub

Rem IP 地址权限设置
Sub GetConfineIp()
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  ConfineAddress(nolock)  where AddrString='"&request("ip")&"'"
rs.Open sql,GameConn,1,3
%>
<br />
<form id='myform' action='?action=saveconfine&ip=<%=request("ip")%>&page=<%=Request("page") %>' method='post'>
 <table width='100%'>
        <tr>
        <td align='left'>您现在的位置：<a href="User_IpConfine.asp">IP 地址限制管理</a>&gt;&gt;<a href="User_IpConfine_List.asp">&nbsp;所有受限IP 地址列表</a>&gt;&gt;&nbsp;IP 地址权限设置</td>
        <td align='right'></td>
        </tr></table>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr>
      <td colspan="2" class='title'>IP 地址权限设置</td>
    </tr>
	<tr class='tdbg'>
      <td class="txtrem">IP 地址：</td>
      <td>
       <span class="fontDash"><%=rs("AddrString") %></span> 
      <a href="User_IpConfine.asp?Search=<%=rs("AddrString") %>&swhat=8" class="detiallink ml">查看在这个 IP 地址下登录过的用户</a> 
     <br />
     <label class="msg errmsg" style=" width:250px;"><%=GetCityFromIP(rs("AddrString")) %>  </label>
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">用户登录：</td>
      <td>
      <% If rs("EnjoinLogon") Then %>
      <input name="in_enjoinLogon" type="radio" id="radio1" value="1" checked="checked" /><label for="radio1" style="color:Red;font-weight:bold;">禁止</label>
      <input name="in_enjoinLogon" type="radio" id="radio2" value="0" /><label for="radio2" style="color:Green;font-weight:bold;">允许</label>
	  <% Else %>
      <input name="in_enjoinLogon" type="radio" id="radio3" value="1" /><label for="radio3" style="color:Red;font-weight:bold;">禁止</label>
      <input name="in_enjoinLogon" type="radio" id="radio4" value="0" checked="checked" /><label for="radio4" style="color:Green;font-weight:bold;">允许</label>
	  <% End If %>            
      </td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">用户注册：</td>
      <td>
      <% If rs("EnjoinRegister") Then %>
      <input name="in_enjoinRegister" type="radio" id="radio5" value="1" checked="checked" /><label for="radio5" style="color:Red;font-weight:bold;">禁止</label>
      <input name="in_enjoinRegister" type="radio" id="radio6" value="0" /><label for="radio6" style="color:Green;font-weight:bold;">允许</label>
	  <% Else %>
      <input name="in_enjoinRegister" type="radio" id="radio7" value="1" /><label for="radio7" style="color:Red;font-weight:bold;">禁止</label>
      <input name="in_enjoinRegister" type="radio" id="radio8" value="0" checked="checked" /><label for="radio8" style="color:Green;font-weight:bold;">允许</label>
	  <% End If %>            
      </td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">失效时间：</td>
      <td> 
      <input name='in_EnjoinOverDate' id="in_EnjoinOverDate" type='text' value="<%=rs("EnjoinOverDate") %>"  size='30' maxlength='30' />
        <img src="images/DatePicker/skin/datePicker.gif" alt="日期" width="16" height="22" style="cursor:hand;" onClick="new WdatePicker(myform.in_EnjoinOverDate,null,false,'whyGreen')" />
      </td>
    </tr> 
     <tr class='tdbg2'> 
      <td class="txtrem">说明：</td>
      <td>
        <textarea name="in_CollectNote" cols="50" rows="5" class="input"><%=Trim(Rs("CollectNote")) %></textarea> 
     </td>
    </tr>  
    <tr class='tdbg'> 
        <td></td>
        <td height='40' align='left'>
        <input name="Submit2"   type="submit" id='Submit2' class="button_on mr" value='保存修改结果' /> 
        <a href="User_IpConfine_List.asp?action=delconfine&ip=<%=rs("AddrString") %>&page=<%=request("page") %>"  class="button_on mr ml" title="对这个 IP 地址的限制失效">取消限制</a>
        <input id="btnEsc" type="button" class="button_on ml" value="取消修改" onclick="javascript:history.back(-1);" />
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

