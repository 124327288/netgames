<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="conn.asp"-->
<!--#include file="function.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<%
Dim theInstalledObjects(5)
theInstalledObjects(0) = "Scripting.FileSystemObject"
theInstalledObjects(1) = "adodb.connection"
theInstalledObjects(2) = "JMail.SMTPMail"
theInstalledObjects(3) = "CDONTS.NewMail"
%>
<html>
<head>
<title><%=SiteName & "--������ҳ"%></title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="Admin_Style.css">
</head>
<body leftmargin="2" topmargin="0" marginwidth="0" marginheight="0">
<table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
<tr align="center">
    <td height=25 colspan=2 class="topbg"><strong><%=SiteName%>----������ҳ</strong></tr>
<tr>
    <td width="100" class="tdbg" height=23><strong>�����ݷ�ʽ��</strong></td>
    <td class="tdbg">
      | <a href="Admin_GameUser.asp">��ҹ���</a>  | <a href="Admin_Admin.asp">����Ա����</a> | <a href='Admin_Admin.asp?action=modifysitename'>�޸ı�������</a></td>
</tr>
</table>
<br>
<table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
  <tr align="center"> 
    <td height=25 colspan=2 class="topbg"><strong>�� �� �� �� Ϣ</strong> 
  <tr> 
    <td width="38%"  class="tdbg" height=23>ע���û�������<%=GetGameUserCount() %> ��</td>
    <td width="62%" class="tdbg">����ܶ�(�ֽ�+����)��<%=FormatNumber(GetGameScoreStat()) %></td>
  </tr> 
  <tr> 
    <td width="38%"  class="tdbg" height=23>�ƹ�Ա������<%=GetSpreadUserCount() %> ��</td>
    <td width="62%" class="tdbg">�����û���<%=GetGameScoreLocker() %> ��</td>
  </tr> 
 <tr> 
    <td width="38%"  class="tdbg" height=23>ͣȨ�û�������<%=GetGameUserNullityCount() %> ��</td>
    <td width="62%" class="tdbg">��Ա�û��� <%=GetGameMemberUserCount() %> ��</td>
  </tr>    
  <tr> 
    <td class="tdbg" height=23></td>
    <td align="right" class="tdbg"><a href="Admin_ServerInfo.asp">��˲鿴����ϸ�ķ�������Ϣ&gt;&gt;&gt;</a></td>
  </tr>
</table>

<form name='search_request' method='get' action='Admin_GameUser.asp'>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>���ٲ�ѯ��Ϸ�û�:</strong></td>
<td width='350'> <input name='search' type='text' id="search"  size='20' maxlength='30' onclick="Javascript:this.value='';" value='����ʹ���û�����ѯ'>
   <select name="swhat" id="swhat">
    <option value="1" selected="selected">���û���</option>   
    <option value="5">����ϷID</option>
    <option value="3">��ע��IP</option>
    <option value="4">����½IP</option>    
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>

<form name='search_money_request' method='get' action='Admin_GameUserMoney.asp'>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>���ٲ�ѯ�û����:</strong></td>
<td align="left"> <input name='search' type='text' id="Text1"  size='20' maxlength='30' onclick="Javascript:this.value='';" value='����ʹ���û�����ѯ'>
   <select name="swhat" id="Select1">
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

</body>
</html>