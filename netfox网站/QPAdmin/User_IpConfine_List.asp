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
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name='form1' action='' method='get'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>IP ��ַ���ƹ���</strong></td>
</tr>
<tr class='tdbg'>
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'> &nbsp;&nbsp;<a href='?confinetype=2'>����ʱ������û�</a>&nbsp;| <a href="?confinetype=3">����ʱ����Ч�û�</a> | <a href="User_IpConfine_List.asp">�������� IP ��ַ</a> | <a href="User_IpConfine.asp">ȫ���û��б�</a></td>
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

'���� IP ��ַ����
Sub SaveConfineIp()
Dim fname,sqlText,ipAddr,enjoinLogon,enjoinRegister,enjoinOverDate,collectNote
fname="myform"  '������
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
        call  RLWriteSuccessMsg("������", "��û���޸�IP ��ַ���Ƶ�Ȩ��!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub delConfineIp()
Dim ipAddr,fname
fname="myform"  '������
ipAddr=GetInfo(0,fname,"ip")
    If InStr(Session("AdminSet"), ",10,")>0 Then
        GameConn.execute  "Delete From ConfineAddress Where AddrString='"&ipAddr&"'"
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
        GameConn.execute  "Insert ConfineAddress(AddrString,EnjoinLogon,EnjoinRegister,EnjoinOverDate) Values('"&ipAddr&"',1,1,'"&DateAdd("d",1,Now)&"')"
    Else
        call  RLWriteSuccessMsg("������", "��û�н��л��������Ƶ�Ȩ��!")
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

OrderStr="CollectDate desc"
'��ѯ����
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
'ִ�в�ѯ����

Set Page = new Cls_Page				'��������
Set Page.Conn = GameConn				'�õ����ݿ����Ӷ���
With Page
	.PageSize = 20					'ÿҳ��¼����
	.PageParm = "page"					'ҳ����
	'.PageIndex = 10				'��ǰҳ����ѡ������һ�������ɾ�̬ʱ��Ҫ
	.Database = "mssql"				'���ݿ�����,ACΪaccess,MSSQLΪsqlserver2000�洢���̰�,MYSQLΪmysql,PGSQLΪPostGreSql
	.Pkey="AddrString"						'����
	.Field="AddrString,EnjoinLogon,EnjoinRegister,EnjoinOverDate,CollectDate,CollectNote"	'�ֶ�
	.Table="ConfineAddress"				'����
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
        <td align='left'>�����ڵ�λ�ã�<a href="User_IpConfine.asp">IP ��ַ���ƹ���</a>&gt;&gt;<a href="User_IpConfine_List.asp">&nbsp;��������IP ��ַ�б�</a></td>
        <td align='right'>���ҵ� <font color="red"><%=lCount%></font> ���û�</td>
        </tr></table>
      <form name='myform' method='Post' action='?'>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>      
    <td>	  
    <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>           
            <td width='250' align='center'><strong>IP ��ַ</strong></td>
            <td width='85' height='21' align='center'><strong>�û���¼</strong></td>
             <td width='85' height='21' align='center'><strong>�û�ע��</strong></td>          
             <td width='115' height='21' align='left'><strong>ʧЧʱ��</strong></td>
             <td width='115' height='21' align='left'><strong>��¼����</strong></td>
             <td width='150' height='21' align='left'><strong>˵��</strong></td>
            <td width='85' height='21' align='center'><strong> ����</strong></td>
          </tr>
          <%
		    Dim ipAddr2,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���κ���Ϣ!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            ipAddr2 = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='250'>
            <% If rs(3,i)<=Now() Then %>
            <span class="fontDash" title="��ֹʱ���Ѿ�ʧЧ�������ȡ�����ơ�ɾ����"><%=ipAddr2 %></span>
            <% Else %>
            <%=ipAddr2 %>
            <% End If %>
            <span id="disp_ip_<%=index %>" class="ml">���ڲ�ѯIP...</span><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=ipAddr2 %>')",800*<%=index %>);</script> 
            </td>
            <td width='85' align='center'>
                <% If rs(1,i) Then %>
                    <label style="color:red; font-weight:600;">��ֹ</label> 
               <% Else %>
               <label style="color:Green;font-weight:bold;">����</label>
              <% End If %> 
            </td>
            <td width='85' align='center'>
             <% If rs(2,i) Then %>
                    <label style="color:red; font-weight:600;">��ֹ</label> 
               <% Else %>
                <label style="color:Green;font-weight:bold;">����</label>
              <% End If %> 
            </td>           
            <td width='115'><%=rs(3,i)%></td>
            <td width='115'><%=rs(4,i)%></td>           
            <td width='150'><%=rs(5,i)%></td> 
            <td width='85' align='center'>
              <% IF IsConfineIp(ipAddr2) Then %>
                <a href="?action=delconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>" style="color:Red;">ȡ������</a>
            <% Else %>
                <a href="?action=addconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>">����</a>            
            <% End IF %>
                <a href="?action=chgconfine&ip=<%=ipAddr2%>&page=<%=Request("page") %>">�޸�</a>        
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
<td width='120'><strong>�û���ѯ:</strong></td>
<td >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='30' maxlength='64' />
  <select name="swhat" id="swhat">    
    <option value="8">��IP ��ַ</option> 
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>
<%
End sub

Rem IP ��ַȨ������
Sub GetConfineIp()
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  ConfineAddress(nolock)  where AddrString='"&request("ip")&"'"
rs.Open sql,GameConn,1,3
%>
<br />
<form id='myform' action='?action=saveconfine&ip=<%=request("ip")%>&page=<%=Request("page") %>' method='post'>
 <table width='100%'>
        <tr>
        <td align='left'>�����ڵ�λ�ã�<a href="User_IpConfine.asp">IP ��ַ���ƹ���</a>&gt;&gt;<a href="User_IpConfine_List.asp">&nbsp;��������IP ��ַ�б�</a>&gt;&gt;&nbsp;IP ��ַȨ������</td>
        <td align='right'></td>
        </tr></table>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr>
      <td colspan="2" class='title'>IP ��ַȨ������</td>
    </tr>
	<tr class='tdbg'>
      <td class="txtrem">IP ��ַ��</td>
      <td>
       <span class="fontDash"><%=rs("AddrString") %></span> 
      <a href="User_IpConfine.asp?Search=<%=rs("AddrString") %>&swhat=8" class="detiallink ml">�鿴����� IP ��ַ�µ�¼�����û�</a> 
     <br />
     <label class="msg errmsg" style=" width:250px;"><%=GetCityFromIP(rs("AddrString")) %>  </label>
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">�û���¼��</td>
      <td>
      <% If rs("EnjoinLogon") Then %>
      <input name="in_enjoinLogon" type="radio" id="radio1" value="1" checked="checked" /><label for="radio1" style="color:Red;font-weight:bold;">��ֹ</label>
      <input name="in_enjoinLogon" type="radio" id="radio2" value="0" /><label for="radio2" style="color:Green;font-weight:bold;">����</label>
	  <% Else %>
      <input name="in_enjoinLogon" type="radio" id="radio3" value="1" /><label for="radio3" style="color:Red;font-weight:bold;">��ֹ</label>
      <input name="in_enjoinLogon" type="radio" id="radio4" value="0" checked="checked" /><label for="radio4" style="color:Green;font-weight:bold;">����</label>
	  <% End If %>            
      </td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">�û�ע�᣺</td>
      <td>
      <% If rs("EnjoinRegister") Then %>
      <input name="in_enjoinRegister" type="radio" id="radio5" value="1" checked="checked" /><label for="radio5" style="color:Red;font-weight:bold;">��ֹ</label>
      <input name="in_enjoinRegister" type="radio" id="radio6" value="0" /><label for="radio6" style="color:Green;font-weight:bold;">����</label>
	  <% Else %>
      <input name="in_enjoinRegister" type="radio" id="radio7" value="1" /><label for="radio7" style="color:Red;font-weight:bold;">��ֹ</label>
      <input name="in_enjoinRegister" type="radio" id="radio8" value="0" checked="checked" /><label for="radio8" style="color:Green;font-weight:bold;">����</label>
	  <% End If %>            
      </td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">ʧЧʱ�䣺</td>
      <td> 
      <input name='in_EnjoinOverDate' id="in_EnjoinOverDate" type='text' value="<%=rs("EnjoinOverDate") %>"  size='30' maxlength='30' />
        <img src="images/DatePicker/skin/datePicker.gif" alt="����" width="16" height="22" style="cursor:hand;" onClick="new WdatePicker(myform.in_EnjoinOverDate,null,false,'whyGreen')" />
      </td>
    </tr> 
     <tr class='tdbg2'> 
      <td class="txtrem">˵����</td>
      <td>
        <textarea name="in_CollectNote" cols="50" rows="5" class="input"><%=Trim(Rs("CollectNote")) %></textarea> 
     </td>
    </tr>  
    <tr class='tdbg'> 
        <td></td>
        <td height='40' align='left'>
        <input name="Submit2"   type="submit" id='Submit2' class="button_on mr" value='�����޸Ľ��' /> 
        <a href="User_IpConfine_List.asp?action=delconfine&ip=<%=rs("AddrString") %>&page=<%=request("page") %>"  class="button_on mr ml" title="����� IP ��ַ������ʧЧ">ȡ������</a>
        <input id="btnEsc" type="button" class="button_on ml" value="ȡ���޸�" onclick="javascript:history.back(-1);" />
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

