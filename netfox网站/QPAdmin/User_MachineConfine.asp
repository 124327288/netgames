<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",9,")<=0  Then
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
      <td height='22' colspan='2' align='center'><strong>���������ƹ���</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp;<a href='?confinetype=1'>�����û�</a>&nbsp;| <a href="?confinetype=2">�����û�</a> | <a href="User_MachineConfine.asp">ȫ���û��б�</a> | <a href="User_MachineConfine_List.asp">�������޻���</a></td>
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
fname="myform"  '������
machineSerial=GetInfo(0,fname,"machineSerial")
    If InStr(Session("AdminSet"), ",9,")>0 Then
        GameConn.execute  "Delete From ConfineMachine Where MachineSerial='"&machineSerial&"'"
    Else
        call  RLWriteSuccessMsg("������", "��û�н��л��������Ƶ�Ȩ��!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub addConfineMachine()
Dim machineSerial,fname
fname="myform"  '������
machineSerial=GetInfo(0,fname,"machineSerial")
    If InStr(Session("AdminSet"), ",9,")>0 Then
        addConfineMachine2(machineSerial)
        'GameConn.execute  "Insert ConfineMachine(MachineSerial,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&machineSerial&"',1,1,'"&DateAdd("d",1,Now)&"')"
    Else
        call  RLWriteSuccessMsg("������", "��û�н��л��������Ƶ�Ȩ��!")
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
'ִ�в�ѯ����

Set Page = new Cls_Page				'��������
Set Page.Conn = GameConn				'�õ����ݿ����Ӷ���
With Page
	.PageSize = 20					'ÿҳ��¼����
	.PageParm = "page"					'ҳ����
	'.PageIndex = 10				'��ǰҳ����ѡ������һ�������ɾ�̬ʱ��Ҫ
	.Database = "mssql"				'���ݿ�����,ACΪaccess,MSSQLΪsqlserver2000�洢���̰�,MYSQLΪmysql,PGSQLΪPostGreSql
	.Pkey="UserID"						'����
	.Field="UserID,GameID,Accounts,RegAccounts,MachineSerial"	'�ֶ�
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
        <td align='left'>�����ڵ�λ�ã�<a href="User_MachineConfine.asp">���������ƹ���</a>&gt;&gt;<a href="User_MachineConfine.asp">&nbsp;�����û���Ա�б�</a></td>
        <td align='right'>���ҵ�  <label class="findUser"><%=lCount%></label> ���û�</td>
        </tr></table>
     <form name='myform' method='Post' action='?action=edit&page=<%=Request("page") %>' onsubmit="return confirm('ȷ��Ҫִ��ѡ���Ĳ�����');">	
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr><td>	  
     <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'><strong>ѡ��</strong></td>
            <td width='33' align='center'><strong>ID</strong></td>
            <td width='85' height='21' align='center'><strong>�û���</strong></td>
             <td width='85' height='21' align='center'><strong>ԭʼ�û���</strong></td>          
             <td width='150' height='21' align='left'><strong>������</strong></td>
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
            <td width='150'>
                <a href="?Search=<%=rs(4,i)%>&swhat=8" title="�鿴ʹ����̨������¼�����û�"><%=rs(4,i)%></a>
            </td>            
            <td width='130' align='center'>
            <% IF IsConfineMachine(rs(4,i)) Then %>
                <a href="?action=delconfine&machineSerial=<%=rs(4,i)%>&page=<%=Request("page") %>" style="color:Red;">ȡ������</a>
               <a href="User_MachineConfine_List.asp?Search=<%=rs(4,i)%>&swhat=8">�鿴��ϸ����</a>  
            <% Else %>
                <a href="?action=addconfine&machineSerial=<%=rs(4,i)%>&page=<%=Request("page") %>">����</a>
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
                <input name='rdConfine' type='radio' value='addConfine' />���ƻ���
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
    <option value="8">��������</option> 
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

