<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0  Then
call  RLWriteSuccessMsg("������", "û�й���Ȩ��!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
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
      <td height='22' colspan='2' align='center'><strong>��Ϸ�û�����</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp; <a href="Admin_GameUserScore.asp">�����û�</a> | <a href="?usertype=4">��������</a>| <a href="?usertype=1">�����û�</a>| <a href="?usertype=3">����½��������</a>| <a href="?usertype=2">��Ϸ����Ա</a></td>
</tr>
</form>
</table>
<%

Dim dname,kindID,istrea,trea,curDname,KindName,curKindName
kindID=SqlCheckNum(Trim(Request("kindID")))
istrea=false
dname="QPGameScoreDB"
KindName="����"

IF kindID<=0 Then
    dname="QPGameScoreDB"
    KindName="����"
Else
    dname=GetDbNameByKindID(kindID)
    KindName=GetKindNameByKindID(kindID)
    IF IsNull(dname) OR dname="" Then
        dname="QPGameScoreDB"
        KindName="����"
    Else        
        Session("db_name_qp")=dname
        Session("kind_name_qp")=KindName
    End IF
End IF

'��ǰ�������ж�
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
'��������Ϣ
Sub saveuserinfo()
Dim UserRight, UserRightArr, MasterRight, MasterRightArr,fname
fname="myform" '��
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from GameScoreInfo where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
' �ؼ��ֶ�
IF InStr(Session("AdminSet"), ",7,")>0 Then
    rs("Score") = SqlCheckNum(Request("in_Score"))
    
    IF istrea=true Then
        rs("Revenue") = SqlCheckNum(Request("in_Revenue"))
        rs("InsureScore") = SqlCheckNum(Request("in_InsureScore"))
    End IF
End IF

'Ȩ���ж�
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

'��Ӯ��¼
rs("WinCount") = SqlCheckNum(Request("in_WinCount"))
rs("LostCount") = SqlCheckNum(Request("in_LostCount"))
rs("DrawCount") = SqlCheckNum(Request("in_DrawCount"))
rs("FleeCount") = SqlCheckNum(Request("in_FleeCount"))

'��Ϸ��־
rs("AllLogonTimes") = SqlCheckNum(Request("in_AllLogonTimes"))
rs("PlayTimeCount") = SqlCheckNum(Request("in_PlayTimeCount"))
rs("OnLineTimeCount") = SqlCheckNum(Request("in_OnLineTimeCount"))
rs("LastLogonDate") = SqlCheckStr(Trim(Request("in_LastLogonDate")))
rs("LastLogonIP") = GetInfo(0,fname,"in_LastLogonIP")

rs.update

Response.Redirect("?page="&Request("page"))
End Sub

'======================================================================================
'ɾ���û�
Sub del(lID)
Dim ID, ClubName
ID = lID
If InStr(Session("AdminSet"), ",4,")>0 Then
    GameConn.execute  "delete from GameScoreInfo where UserID="&ID
End If
End Sub

'=================================================================================
'�б��û�
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
'��ѯ����
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
'ִ�в�ѯ����

Set Page = new Cls_Page				'��������
Set Page.Conn = GameConn				'�õ����ݿ����Ӷ���
With Page
	.PageSize = 20					'ÿҳ��¼����
	.PageParm = "page"					'ҳ����
	'.PageIndex = 10				'��ǰҳ����ѡ������һ�������ɾ�̬ʱ��Ҫ
	.Database = "mssql"				'���ݿ�����,ACΪaccess,MSSQLΪsqlserver2000�洢���̰�,MYSQLΪmysql,PGSQLΪPostGreSql
	.Pkey="UserID"						'����
	.Field=fields	'�ֶ�
	.Table="GameScoreInfo"				'����
	.Condition=queryCondition					'����,����Ҫwhere
	.OrderBy=OrderStr						'����,����Ҫorder by,��Ҫasc����desc
	.RecordCount = 0				'�ܼ�¼���������ⲿ��ֵ��0�����棨�ʺ���������-1��Ϊsession��-2��Ϊcookies��-3��Ϊapplacation

	.NumericJump = 5 '��������ҳ��������ѡ������Ĭ��Ϊ3������Ϊ��ת������0Ϊ��ʾ����
	.Template = "�ܼ�¼����{$RecordCount} ��ҳ����{$PageCount} ÿҳ��¼����{$PageSize} ��ǰҳ����{$PageIndex} {$FirstPage} {$PreviousPage} {$NumericPage} {$NextPage} {$LastPage} {$InputPage} {$SelectPage}" '����ģ�壬��ѡ��������Ĭ��ֵ
	.FirstPage = "��ҳ" '��ѡ��������Ĭ��ֵ
	.PreviousPage = "��һҳ" '��ѡ��������Ĭ��ֵ
	.NextPage = "��һҳ" '��ѡ��������Ĭ��ֵ
	.LastPage = "βҳ" '��ѡ��������Ĭ��ֵ
	.NumericPage = " {$PageNum} " '���ַ�ҳ����ģ�壬��ѡ��������Ĭ��ֵ
End With

rs = Page.ResultSet() '��¼��
lCount = Page.RowCount() '��ѡ������ܼ�¼��
nav = Page.Nav() '��ҳ��ʽ

Page = Null
Set Page = Nothing

'==============================================================================================================

%>
<br><table width='100%'><tr>
    <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUserScore.asp"><%=KindName %>����</a>&gt;&gt;<a href="Admin_GameUserScore.asp">&nbsp;���г�Ա�б�</a></td>
<td align='right'>���ҵ� <font color=red><%=lCount%></font> ���û�</td>
</tr></table>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'><tr>
    <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('ȷ��Ҫִ��ѡ���Ĳ�����');">
      <td>
      <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td width='108' align='center'><strong>�û���</strong></td>
            <td width='85' height='21' align='center'><strong>������</strong></td>
            
            <% IF istrea=true Then  %>
            <td width='85' height='21' align='center'><strong>�Ͻ�˰��</strong></td>
            <td width='85' height='21' align='center'><strong>���д��</strong></td>
            <% End IF %>
            
            <td width='108' align='center'><strong>Ӯ��</strong></td>
            <td width='138' align='center'><strong>���</strong></td>
            <td width='108' align='center'><strong>�;�</strong></td>
            <td width='108' align='center'><strong>����</strong></td>
            <td width='138' align='center'><strong>��Ϸʱ��</strong></td>
            <td width='138' align='center'><strong>��½����</strong></td>           
            <td width='138' align='center'><strong>��½IP</strong></td>
            <td width='248' height='21' align='center'><strong> ����</strong></td>
          </tr>
          <%
		    Dim UserID,index
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���ҵ������Ϣ!<br><br></td></tr>") 
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
            <td width='138'><label id="disp_ip_<%=index %>" title="���ڲ�ѯIP����..."><%=rs(10,i)%></label><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=rs(10,i) %>')",800*<%=index %>);</script></td>
            <td width='248' align='center'><a href="?action=userinfo&id=<%=UserID%>&page=<%=Request("page") %>">��ϸ��Ϣ</a></td>
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
<td width='120'><strong>�û���ѯ:</strong></td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='search' type='text' id="search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">���û���</option>    
    <option value="4">����½IP</option>
    <option value="5">����Ҵ���</option>
    <option value="6">�����С��</option>
    <option value="2">����½��������</option>
    <option value="3">����½����С��</option>
  </select> 
<input type='submit' name='submit2' value=' �� ѯ ' />
<span class="ml">��Ϊ�գ����ѯ�����û�</span>
</td>
</tr></table>
</form>

<%
End Sub

'====================================================================================
'������ҽ��
Sub userinfo() 
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  GameScoreInfo  where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
%>
<form name='myform' action='?action=saveuserinfo&id=<%=Request("id") %>&page=<%=Request("page") %>' method='post'>

<table width='100%'><tr>
    <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUserScore.asp?page=<%=Request("page") %>"><%=KindName %>����</a>&gt;&gt;&nbsp;�޸��û�����</td>
<td align='right'></td>
</tr></table>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr class='title'> 
      <td height=22 colspan=2 align='center'> <b>�޸��û�����</b></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">�û�����</td>
      <td> <%=GetAccountsByUserID(rs("UserID")) %>
        <a class="ml detiallink" href="Admin_GameUser.asp?action=userinfo&id=<%=rs("UserID") %>">�鿴�û���������</a> 
      </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">��ϷID��</td>
        <td><%=GetGameIDByUserID(rs("UserID")) %></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">��������</td>
      <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
        <td> <%= rs("Score") %></td>
      <%Else%>
        <td><input name='in_Score' id="in_Score" type='text' value="<%= rs("Score") %>"  size='30' maxlength='30' /></td>
       <%End IF%>
     </tr>
     
     <% IF istrea=true Then %>     
        <tr class="tdbg2">
            <td class="txtrem">�Ͻ�˰�գ�</td>      
             <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
                <td> <%= rs("Revenue") %></td>
            <%Else%>
            <td><input name='in_Revenue' id="in_Revenue" type='text' value="<%= rs("Revenue") %>"  size='30' maxlength='30' /></td>
           <%End IF%>      
        </tr> 
         <tr class="tdbg">
            <td class="txtrem">���д�</td>
            <%IF InStr(Session("AdminSet"), ",7,")<=0 Then %>
                <td> <%= rs("InsureScore") %></td>
            <%Else%>
            <td><input name='in_InsureScore' id="in_InsureScore" type='text' value="<%= rs("InsureScore") %>"  size='30' maxlength='30' /></td>
           <%End IF%>   
        </tr>
    <% End IF %>
	<tr class='tdbg2'> 
      <td class="txtrem">Ӯ�֣�</td>
      <td> <input name='in_WinCount' id="in_WinCount" type='text' value="<%=rs("WinCount")%>"  size='30' maxlength='30' /></td>
     </tr> 
	<tr class='tdbg'> 
      <td class="txtrem">��֣�</td>
      <td> <input name='in_LostCount' id="in_LostCount" type='text' value="<%=rs("LostCount")%>"  size='30' maxlength='30' /></td>
     </tr>
	<tr class='tdbg'> 
      <td class="txtrem">�;֣�</td>
      <td><input name='in_DrawCount' id="in_DrawCount" type='text' value="<%= Rs("DrawCount") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">���ܣ�</td>
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
      <td class="txtrem">�ܵ�½������</td>
      <td> <input name='in_AllLogonTimes' id="in_AllLogonTimes" type='text' value="<%=rs("AllLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>    
	<tr class='tdbg'> 
      <td class="txtrem">�ۼ���Ϸʱ��(��λ:��)��</td>
      <td><input name='in_PlayTimeCount' type='text' id="in_PlayTimeCount" value="<%= rs("PlayTimeCount") %>"  size='30' maxlength='30' /></td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">�ۼ�����ʱ��(��λ:��)��</td>
      <td> <input name='in_OnLineTimeCount' id="in_OnLineTimeCount" type='text' value="<%=rs("OnLineTimeCount") %>"  size='30' maxlength='30' /></td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">����½ʱ�䣺</td>
      <td>
      <input name='in_LastLogonDate' id="in_LastLogonDate" type='text' value="<%=rs("LastLogonDate")%>"  size='30' maxlength='30' /></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">����½IP��</td>
      <td>
      <input name='in_LastLogonIP' type='text' id="in_LastLogonIP" value="<%=rs("LastLogonIP")%>"  size='30' maxlength='30' /><span class="ml"><%=GetCityFromIP(rs("LastLogonIP")) %></span></td>
    </tr>
    <tr class='tdbg'> 
      <td height='40' colspan='2' align='center'> <input name="Submit3"   type="submit" id='Submit3' value='�����޸Ľ��' class="button_on" /> 
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
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>

</body>
</html>



