<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",10,")<=0  Then
call  RLWriteSuccessMsg("������", "û�й���Ȩ��!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
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
      <td height='22' colspan='2' align='center'><strong>IP ��ַ���ƹ���</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp;<a href='?confinetype=1'>�����û�</a>&nbsp;| <a href="?confinetype=2">�����û�</a> | <a href="User_IpConfine.asp">ȫ���û��б�</a> | <a href="User_IpConfine_List.asp">��������IP</a></td>
</tr>
</table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action"))  
    case "addconfine"
    call addConfineIp()
    case "delconfine" 
    call delConfineIp() 
    case else
    call main()
End Select
Call CloseGame()

Sub delConfineIp()
Dim ipAddr,fname
fname="myform"  '������
ipAddr=GetInfo(0,fname,"ip")
    If InStr(Session("AdminSet"), ",10,")>0 Then
       call delConfineIp2(ipAddr)
    Else
        call  RLWriteSuccessMsg("������", "��û�н���IP ��ַ���Ƶ�Ȩ��!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub addConfineIp()
Dim ipAddr,fname
fname="myform"  '������
ipAddr=GetInfo(0,fname,"ip")
    If InStr(Session("AdminSet"), ",10,")>0 Then      
        call addConfineIp2(ipAddr)
    Else
        call  RLWriteSuccessMsg("������", "��û�н���IP ��ַ���Ƶ�Ȩ��!")
        Response.End      
    End If
    
    Response.Redirect("?page="&Request("page"))
End Sub

Function addConfineIp2(ipAddr)
    IF Not IsConfineIp(ipAddr) Then
        GameConn.execute  "Insert ConfineAddress(AddrString,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&Trim(ipAddr)&"',1,1,GETDATE()+1)"
    End IF
End Function

Function delConfineIp2(ipAddr)
    GameConn.execute  "Delete From ConfineAddress Where AddrString='"&Trim(ipAddr)&"'"
End Function

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")

For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("rdConfine")
		Case "addConfine"
		  addConfineIp2(typeIDArray(lLoop))
		Case "cancelConfine"
			delConfineIp2(Trim(typeIDArray(lLoop)))
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
    disp_ip.title=  obj.responseText;  
    disp_ip.innerText="�鿴��������";
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

OrderStr="UserID desc"
'��ѯ����
IF request("search")>"" Then
    Select case Request("swhat")
	    Case "1"
		    queryCondition = " Accounts='"&sqlcheckStr(request("search"))& "' OR RegAccounts='"&sqlcheckStr(request("search"))& "'"		    
        Case "5"
		    queryCondition = " gameid='"&sqlcheckStr(request("search"))& "'"	  
        Case "7"
		    queryCondition = " UserID='"&sqlcheckStr(request("search"))& "'"
		Case "8"
		    queryCondition = " LastLogonIP='"&sqlcheckStr(request("search"))& "'"
    End Select
End IF

IF request("confinetype")>"" Then
    Select case request("confinetype")
        Case "1"
           queryCondition=" LastLogonIP IN (Select AddrString FROM ConfineAddress(NOLOCK))" 
        Case "2"
            queryCondition=" LastLogonIP NOT IN (Select AddrString FROM ConfineAddress(NOLOCK))" 
    End Select
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
	.Field="UserID,GameID,Accounts,RegAccounts,LastLogonIP"	'�ֶ�
	.Table="AccountsInfo"				'����
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
<br />
    <table width='100%'>
        <tr>
        <td align='left'>�����ڵ�λ�ã�<a href="User_IpConfine.asp">IP ��ַ���ƹ���</a>&gt;&gt;<a href="User_IpConfine.asp">&nbsp;�����û���Ա�б�</a></td>
        <td align='right'>���ҵ�  <label class="findUser"><%=lCount%></label> ���û�</td>
        </tr></table>
     <form id='myform' method='Post' action='?action=edit&page=<%=Request("page") %>' onsubmit="return confirm('ȷ��Ҫִ��ѡ���Ĳ�����');">	
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr><td>	  
     <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'><strong>ѡ��</strong></td>
            <td width='33' align='center'><strong>ID</strong></td>
            <td width='85' height='21' align='center'><strong>�û���</strong></td>
             <td width='85' height='21' align='center'><strong>ԭʼ�û���</strong></td>          
             <td width='250' height='21' align='left'><strong>IP ��ַ</strong></td>
            <td width='130' height='21' align='center'><strong> ����</strong></td>
          </tr>
          <%
		    Dim UserID,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���κ���Ϣ!<br><br></td></tr>")
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
            <td width='250'>
                <a href="?Search=<%=rs(4,i)%>&swhat=8" title="�鿴����� IP ��ַ��¼�����û�"><%=rs(4,i)%></a>
               <span id="disp_ip_<%=index %>" class="ml">���ڲ�ѯIP...</span><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=rs(4,i) %>')",800*<%=index %>);</script> 
            </td>            
            <td width='130' align='center'>
            <% IF IsConfineIp(rs(4,i)) Then %>
                <a href="?action=delconfine&ip=<%=rs(4,i)%>&page=<%=Request("page") %>" style="color:Red;">ȡ������</a>
               <a href="User_IpConfine_List.asp?Search=<%=rs(4,i)%>&swhat=8">�鿴��ϸ����</a>  
            <% Else %>
                <a href="?action=addconfine&ip=<%=rs(4,i)%>&page=<%=Request("page") %>">����</a>
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
             <label for="chkAll2"> ѡ�б�ҳ���г�Ա</label>
              </td>
            <td width="574">
            <div align="left"><strong>������ </strong>
                <input name='rdConfine' type='radio' value='addConfine' />���� IP
				<input name='rdConfine' type='radio' value='cancelConfine' checked="checked" />ȡ������							
                <input type='submit' name='Submit' value=' ִ �� '/>
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
<td width='120'><strong>�û���ѯ:</strong></td>
<td >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='30' maxlength='64'>
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">���û���</option>   
    <option value="5">����ϷID</option>  
    <option value="8">��IP ��ַ</option> 
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>
<%
End sub
%>

<div>
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>

</body>
</html>


