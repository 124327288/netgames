<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0 Then
call  RLWriteSuccessMsg("������", "û�н�ҹ���Ȩ��!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0 Then
call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
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
      <td height='22' colspan='2' align='center'><strong>��Ϸ�û�����</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'><a href="Gold_RecordUserInsure.asp?tradeType=1">��</a> |<a href="Gold_RecordUserInsure.asp?tradeType=2"> ȡ</a> |  <a href="Gold_RecordUserInsure.asp?tradeType=3">ת</a> | <a href="Gold_RecordUserInsure.asp">ȫ��</a> </td>
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
'��¼��ѯ
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
'��ѯ����
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
'ִ�в�ѯ����

Set Page = new Cls_Page				'��������
Set Page.Conn = GameConn				'�õ����ݿ����Ӷ���
With Page
	.PageSize = 20					'ÿҳ��¼����
	.PageParm = "page"					'ҳ����
	'.PageIndex = 10				'��ǰҳ����ѡ������һ�������ɾ�̬ʱ��Ҫ
	.Database = "mssql"				'���ݿ�����,ACΪaccess,MSSQLΪsqlserver2000�洢���̰�,MYSQLΪmysql,PGSQLΪPostGreSql
	.Pkey="InsureID"						'����
	.Field="InsureID,KindID,ServerID,SourceAccounts,TargetAccounts,InsureScore,SwapScore,Revenue,TradeType,ClientIP,CollectDate,SourceUserID,TargetUserID,IsGamePlaza"	'�ֶ�
	.Table="RecordInsure"				'����
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
    <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUserMoney.asp">��ҹ���</a>&gt;&gt;<a href="Gold_RecordUserInsure.asp">&nbsp;���м�¼</a></td>
<td align='right'>���ҵ� <font color=red><%=lCount %></font> ����¼</td>
</tr></table><table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  
<form name='myform' method='post' action=''>	
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td class="time_header">ʱ��</td>
            <td class="addr_header">�ص�</td> 
            <td class="user_header">�����</td>
            <td class="user_header">�տ���</td>
            <td class="tradeType_header">�������</td>            
            <td class="insure_header">���н��</td>            
            <td class="insure_header">���׽��</td>
            <td class="insure_header">˰��</td>      
            <td class="server_header">����</td>    
            <td class="kind_header">��Ϸ����</td>
            <td class="server_header">��Ϸ����</td>
          </tr>
          <%          
          Dim srcUserID,dstUserID,index,GameName
          Dim srcAccounts,dstAccounts
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���ҵ������Ϣ!<br><br></td></tr>") 
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
            <td class="user_item"><a title="�鿴�û�����" href="Admin_GameUser.asp?action=userinfo&id=<%=srcUserID%>"><%=srcAccounts %></a></td>
            <td class="user_item"><a title="�鿴�û�����" href="Admin_GameUser.asp?action=userinfo&id=<%=dstUserID%>"><%=dstAccounts %></a></td>
            <td class="tradeType_item">
                <% IF Rs(8,i)=0 Then %>N/A<% End IF %>
                <% IF Rs(8,i)=1 Then %>��<% End IF %>
                <% IF Rs(8,i)=2 Then %>ȡ<% End IF %>
                <% IF Rs(8,i)=3 Then %>ת<% End IF %>
            </td>
            <td class="insure_item"><%=Rs(5,i) %></td>
            <td class="insure_item"><%=Rs(6,i) %></td>
            <td class="insure_item"><%=Rs(7,i) %></td>
      
            <td class="server_item">
                <% IF Rs(13,i)=0 Then %>��ҳ<% End IF %>
                <% IF Rs(13,i)=1 Then %>����<% End IF %>
            </td>
   
            <td class="kind_item"><label title="KindID�� <%=Rs(1,i) %>"><%=GameName%></label></td>
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
<td width='120' align="right"><strong>�û���ѯ:</strong></td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='search' type='text' id="search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">�������</option>
    <option value="2">���տ���</option>
    <option value="7">�������ID</option>
    <option value="8">���տ���ID</option>
    <option value="3">��KindID</option>
    <option value="4">������</option>
    <option value="5">������ʱ��(��)</option>
    <option value="6">������IP</option>
  </select>
  <select name="tradeType" id="tradeType">
    <option value="0" selected="selected">�������</option>
    <option value="1">��</option>
    <option value="2">ȡ</option>
    <option value="3">ת</option>
  </select>
<input type='submit' name='Submit2' value=' �� ѯ ' />
<span class="ml">��Ϊ�գ����ѯ�����û�</span>
</td>
</tr></table></form>
<%
End Sub
%>

<div>
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>


</body>
</html>




 