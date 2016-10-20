<!--#include file="Top.asp" -->
<%
CxGame.DbConn60("WHGameMatchDB")
Dim MuserID
MuserID=CxGame.GetInfo(1,"form","UserID")
Set Rs=Conn.Execute("Select Top 1 us.Accounts,Us.Userid,GameScore.Score,GameScore.WinCount,GameScore.LostCount,GameScore.DrawCount From WHGameUserDBServer.WHGameUserDB.dbo.UserAccounts As Us,GameScore Where GameScore.UserID="& MUserID &" And Us.UserID=GameScore.UserID")
IF Not Rs.Eof Then
%>
<table width="400" border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC" bgcolor="#FFFFFF">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="116"><div align="center">用户名:</div></td>
    <td width="266"><%=Rs(0)%></td>
  </tr>
  <tr> 
    <td><div align="center">ID号:</div></td>
    <td><%=Rs(1)%></td>
  </tr>
  <tr> 
    <td><div align="center">积分:</div></td>
    <td><%=Rs(2)%></td>
  </tr>
  <tr> 
    <td><div align="center">胜局:</div></td>
    <td><%=Rs(3)%></td>
  </tr>
  <tr> 
    <td><div align="center">负局:</div></td>
    <td><%=Rs(4)%></td>
  </tr>
</table>
<%
End IF
Rs.Close:Set Rs=Nothing
%>
<!--#include file="copy.asp" -->
