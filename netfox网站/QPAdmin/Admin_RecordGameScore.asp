<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="md5.asp"-->
<!--#include file="Conn.asp"-->
<% 
'If InStr(Session("AdminSet"), ",6,")<=0 Then
'call  RLWriteSuccessMsg("������", "û�г��й���Ȩ��!")
'Response.End
'End If

'If InStr(Session("AdminSet"), ",1,")<=0 Then
'call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
'Response.End
'End If
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
      <td width='687' height='30'><a href="Admin_RecordUserEnter.asp">���뷿���¼</a> |<a href="Admin_RecordUserLeave.asp"> �˳������¼</a> |<!-- <a href="Admin_RecordGameScore.asp">��Ӯ��¼</a> |--></td>
</tr>
</form>
</table>
<%
Call ConnectGame("QPTreasureDB")
select case lcase(request("action"))

case else
call main()
end select
Call CloseGame()

if IsObject(conn) then
conn.close
set conn=nothing
end if

sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")

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
Dim UserID
sqltype="select * from dbo.RecordGameScore "
If Request("Search")<>"" Then	
	sqltype=sqltype & " where UserID1=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype & " OR UserID2=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID3=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID4=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID5=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID6=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID7=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"
	sqltype=sqltype&" OR UserID8=(select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("Search"))& "')"   
End If

sqltype=sqltype&" order by RecordDate DESC "
'Response.Write sqltype

Set rs=Server.CreateObject("Adodb.RecordSet")
rs.Open sqltype,GameConn,1,1
rs.PageSize = 20
pgnum=rs.Pagecount
page=request("page")
if page="" or clng(page)<1 then page=1
if clng(page) > pgnum then page=pgnum
if pgnum>0 then rs.AbsolutePage=page
%>
<br><table width='100%'><tr>
    <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUserMoney.asp">��ҹ���</a>&gt;&gt;<a href="Admin_RecordGameScore.asp">&nbsp;��Ӯ��¼</a></td>
<td align='right'>���ҵ� <font color=red><%=rs.recordcount%></font> ����¼</td>
</tr></table><table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('ȷ��Ҫִ��ѡ���Ĳ�����');">	  <td>	  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>             
            <td width='200' align='center'><strong>��Ϸ���</strong></td>
            <td width='138' align='center'><strong>����</strong></td>
            <td width='138' align='center'><strong>����</strong></td>
            <td width='200' align='center'><strong>����</strong></td>
            <td width='200' align='center'><strong>˰��</strong></td>
            <td width='200' align='center'><strong>��Ϸʱ��</strong></td>
            
            <td width='100' height='21' align='center'><strong>�û���1</strong></td>
            <td width='200' align='center'><strong>���1</strong></td>
            <td width='100' height='21' align='center'><strong>�û���2</strong></td>
            <td width='200' align='center'><strong>���2</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���3</strong></td>
            <td width='200' align='center'><strong>���3</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���4</strong></td>
            <td width='200' align='center'><strong>���4</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���5</strong></td>
            <td width='200' align='center'><strong>���5</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���6</strong></td>
            <td width='200' align='center'><strong>���6</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���7</strong></td>
            <td width='200' align='center'><strong>���7</strong></td>   
            <td width='100' height='21' align='center'><strong>�û���8</strong></td>
            <td width='200' align='center'><strong>���8</strong></td>   
            <td width='200' align='center'><strong>��¼ʱ��</strong></td>           
          </tr>
  <%
if rs.eof then response.Write("<tr class='tdbg'><td colspan='23' align='center'><br>û���κ���Ϣ!<br><br></td></tr>")
do until rs.eof or i>=rs.pagesize 
UserID = Rs("UserID")
GameName=GetKindNameByKindID(Rs("KindID"))
%>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
         
            <td width='200' align='center'><%=GameName%></td>
            <td width='138' align='center'><%=Rs("ServerID")%></td>
            <td width='138' align='center'><%=Rs("TableID")%></td>
            
            <td width='200' align='center'><%= Rs("WasteCount") %></td>
            <td width='200' align='center'><%= Rs("RevenueCount") %></td>            
            <td width='200' align='center'><%= Rs("PlayTimeCount") %></td>
            
            <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID1")) %></td>
            <td width='200' align='center'><%= Rs("GameScore1") %></td>
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID2")) %></td>
            <td width='200' align='center'><%= Rs("GameScore2") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID3")) %></td>
            <td width='200' align='center'><%= Rs("GameScore3") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID4")) %></td>
            <td width='200' align='center'><%= Rs("GameScore4") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID5")) %></td>
            <td width='200' align='center'><%= Rs("GameScore5") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID6")) %></td>
            <td width='200' align='center'><%= Rs("GameScore6") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID7")) %></td>
            <td width='200' align='center'><%= Rs("GameScore7") %></td>   
             <td width='100' align='center'><%=GetAccountsByUserID(Rs("UserID8")) %></td>
            <td width='200' align='center'><%= Rs("GameScore8") %></td>             
                                
	       
	        <td width='200' align='center'><%=Rs("RecordDate")%></td>           
          </tr>
          <%i=i+1
rs.movenext
loop
%>
        </table>
		
<table width='100%' border='0' cellpadding='0' cellspacing='0'>

</table> 


</td>
</form>  </tr></table><table align='center'><tr>
<td>
<%if  page-1>0 then %>
<a href=?Page=<%=page-1%>&usertype=<%=request("usertype")%>&Keyword=<%=request("Keyword") %>&Search=<%= Request("Search") %>&swhat=<%= Request("swhat") %>>��һҳ</a>&nbsp;&nbsp; 
<% else 
response.Write("��һҳ")
end if
%>
<%if  page+1=< pgnum then %>
<a href=?Page=<%=page+1%>&usertype=<%=request("usertype")%>&Keyword=<%=request("Keyword") %>&Search=<%= Request("Search") %>&swhat=<%= Request("swhat") %>>��һҳ</a> 
<% else 
response.Write("��һҳ")
end if%></a>
ת�� 
<select name=userlist id="userlist"   onChange="window.location.href=this.options[this.selectedIndex].value">
<%for i=1 to rs.pagecount %>
<option value="?Page=<%=i%>&usertype=<%=request("usertype")%>&Keyword=<%=request("Keyword") %>&Search=<%= Request("Search") %>&swhat=<%= Request("swhat") %>"   <%if   cint(request("page")) =i  then response.write  "selected"  %>><%= i %></option>
<% next %>
</select>
ҳ
</td>
</tr></table>
<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>�û���ѯ:</strong></td>
<td width='350'>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='20' maxlength='30'>
  <select name="swhat" id="swhat">
    <option value="1" selected>����</option>
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ '>
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table></form>
<%end sub
%>





 