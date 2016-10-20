<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<% 
If InStr(Session("AdminSet"), ",6,")<=0 Then
call  RLWriteSuccessMsg("错误啦", "没有管理权限!")
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
      <td height='22' colspan='2' align='center'><strong>统计资料</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>快速查找：</strong></td>
      <td width='687' height='30'>&nbsp; </td>
</tr>
</form>
</table>
<% 
call main()
sub main()
Dim bollSum, UserCount, TotalMoney, Deposit, TotalRevenue, StockMoney, AllMoney, EachMoney
Dim StatInsureScore,StatScore
Call ConnectGame("QPGameUserDB")
	set rs=GameConn.Execute("select count(UserID) from AccountsInfo(nolock) ")
GameUser = Rs(0)
rs.close
set rs=nothing
Call CloseGame()

Call ConnectGame("QPTreasureDB")	
	set rs=GameConn.Execute("select sum(Score),Sum(InsureScore),Sum(Score)+Sum(InsureScore) from GameScoreInfo(nolock)")
GameMoney = Rs(0)
StatInsureScore=Rs(1)
StatScore=Rs(2)
rs.close
set rs=nothing

set rs=GameConn.Execute("select sum(Revenue) from GameScoreInfo(nolock) ")
TotalRevenue = Rs(0)
rs.close
set rs=nothing
Call CloseGame()

IF IsEmpty(GameMoney) Then
    GameMoney=0
End IF

IF IsEmpty(TotalRevenue) Then
    TotalRevenue=0
End IF

%>
<br><table width='100%'><tr>
    <td align='left'>您现在的位置：<a href="admin_Static.asp">资料统计</a></td>
<td align='right'></td>
</tr></table><table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>   <td>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr class='title'> 
      <td height=22 colspan=2 align='center'><strong>统计资料</strong></td>
    </tr>
    <tr class='tdbg'> 
      <td width='37%'><div align="right"><strong>注册用户总数</strong></div></td>
      <td width='63%'><%= GameUser %>  人</td>
    </tr>
         
     <tr class='tdbg'> 
      <td><div align="right"><strong>游戏币总额(现金)</strong></div></td>
      <td> <%= FormatNumber(GameMoney) %> </td>
    </tr>
    <tr class="tdbg">
        <td><div align="right"><strong>银行总额</strong></div></td>
      <td> <%= FormatNumber(StatInsureScore) %> </td>
    </tr>
     <tr class="tdbg">
        <td><div align="right"><strong>银行+现金总额</strong></div></td>
      <td> <%= FormatNumber(StatScore) %> </td>
    </tr>
     <tr class='tdbg'> 
      <td><div align="right"><strong>游戏税收总额</strong></div></td>
      <td> <%=FormatNumber(TotalRevenue) %> </td>
    </tr>
     
    <tr class='tdbg'> 
      <td height='40' colspan='2' align='center'>&nbsp;      </td>
    </tr>
  </table>
</td>
 </tr></table>
<%end sub
%>

