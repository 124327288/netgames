<!--#include file="Top.asp" -->
<%
CxGame.IsCheckLogin()
%>

<table width="770" border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="170" valign="top"> <table border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">
        <tr> 
          <td width="174"><div align="center"><a href="BankPass.asp"><img src="img/bank1.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><div align="center"><a href="ServeWealth.Asp"><img src="img/bank2.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><div align="center"><a href="ReceiveWealth.Asp"><img src="img/bank3.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><div align="center"><a href="Transfers.Asp"><img src="img/bank4.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><div align="center"><a href="TransfersLog.Asp"><img src="img/bank5.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><div align="center"><a href="Pay.asp"><img src="img/bank7.jpg" width="170" height="34" border="0"></a></div></td>
        </tr>
        <tr> 
          <td><a href="ChongzhiLog.Asp"><img src="img/bank6.jpg" width="170" height="34" border="0"></a></td>
        </tr>
      </table></td>
    <td width="560" valign="top">
      <form name="form1" method="post" action="">
        <table width="560" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td height="28"  background="img/q03.jpg"><font color="#FFFFFF"><strong>我的卡充值记录 
              提示:只显示最近的50条充值记录!</strong></font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#CCCCCC">
                <tr> 
                  <td width="22%" bgcolor="#FFFFFF"><div align="center">数额</div></td>
                  <td width="27%" bgcolor="#FFFFFF"><div align="center">卡号</div></td>
                  <td width="18%" bgcolor="#FFFFFF"><div align="center">时间</div></td>
                </tr>
                <%
				CxGame.DbConn("QPTreasureDB")
				Set Rs=Conn.Execute("Select Top 50 CardNo,(SELECT Score from GameCardTypeInfo where CardID=CardTypeID) AS Score,UseDate From GameCardNoInfo(NOLOCK) Where UserID="&Session("UserID")&" Order By UseDate Desc")
				Do While Not Rs.Eof
				%>
                <tr> 
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(1)%></div></td>
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(0)%></div></td>
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(2)%></div></td>
                </tr>
                <%
				Rs.MoveNext
				Loop
				CxGame.RsClose:CxGame.DbClose
				%>
              </table></td>
          </tr>
        </table>
      </form> </td>
  </tr>
</table>
<!--#include file="Copy.asp" -->
</body>
</html>
