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
<title><%=SiteName & "--管理首页"%></title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="Admin_Style.css">
</head>
<body leftmargin="2" topmargin="0" marginwidth="0" marginheight="0">
<table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
<tr align="center">
    <td height=25 colspan=2 class="topbg"><strong><%=SiteName%>----管理首页</strong></tr>
<tr>
    <td width="100" class="tdbg" height=23><strong>管理快捷方式：</strong></td>
    <td class="tdbg">
      | <a href="Admin_GameUser.asp">玩家管理</a>  | <a href="Admin_Admin.asp">管理员管理</a> | <a href='Admin_Admin.asp?action=modifysitename'>修改标题署名</a></td>
</tr>
</table>
<br>
<table cellpadding="2" cellspacing="1" border="0" width="100%" class="border" align=center>
  <tr align="center"> 
    <td height=25 colspan=2 class="topbg"><strong>服 务 器 信 息</strong> 
  <tr> 
    <td width="38%"  class="tdbg" height=23>注册用户总数：<%=GetGameUserCount() %> 人</td>
    <td width="62%" class="tdbg">金币总额(现金+银行)：<%=FormatNumber(GetGameScoreStat()) %></td>
  </tr> 
  <tr> 
    <td width="38%"  class="tdbg" height=23>推广员人数：<%=GetSpreadUserCount() %> 人</td>
    <td width="62%" class="tdbg">卡线用户：<%=GetGameScoreLocker() %> 人</td>
  </tr> 
 <tr> 
    <td width="38%"  class="tdbg" height=23>停权用户总数：<%=GetGameUserNullityCount() %> 人</td>
    <td width="62%" class="tdbg">会员用户： <%=GetGameMemberUserCount() %> 人</td>
  </tr>    
  <tr> 
    <td class="tdbg" height=23></td>
    <td align="right" class="tdbg"><a href="Admin_ServerInfo.asp">点此查看更详细的服务器信息&gt;&gt;&gt;</a></td>
  </tr>
</table>

<form name='search_request' method='get' action='Admin_GameUser.asp'>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>快速查询游戏用户:</strong></td>
<td width='350'> <input name='search' type='text' id="search"  size='20' maxlength='30' onclick="Javascript:this.value='';" value='建议使用用户名查询'>
   <select name="swhat" id="swhat">
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

<form name='search_money_request' method='get' action='Admin_GameUserMoney.asp'>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>快速查询用户金币:</strong></td>
<td align="left"> <input name='search' type='text' id="Text1"  size='20' maxlength='30' onclick="Javascript:this.value='';" value='建议使用用户名查询'>
   <select name="swhat" id="Select1">
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

</body>
</html>