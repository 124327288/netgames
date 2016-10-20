<!--#include file="Top.asp" -->
<%
CxGame.IsCheckLogin()
%>

<table width="750" border="0" align="center" cellpadding="5" cellspacing="0">
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
    <td width="580" valign="top">
      <form name="form1" method="post" action="">
        <table width="600" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td height="28"  background="img/q03.jpg"><font color="#FFFFFF"><strong>我的卡充值记录 
              提示:只显示最近的50条充值记录!<a href="ChongzhiLog.Asp">点这里查看我的卡充值记录</a></strong></font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
                <tr> 
                  <td width="17%" bgcolor="#FFFFFF"><div align="center">电话</div></td>
                  <td width="9%" bgcolor="#FFFFFF"><div align="center">金额</div></td>
                  <td width="19%" bgcolor="#FFFFFF"><div align="center">梦幻币</div></td>
                  <td width="33%" bgcolor="#FFFFFF"><div align="center">状态</div></td>
                  <td width="22%" bgcolor="#FFFFFF"><div align="center">时间</div></td>
                </tr>
                <%
				CxGame.DbConn("QPTreasureDb")
				Set Rs=Conn.Execute("Select Top 50 Tel,Price,Yz,Info,PostTime From TelLog Where UserID="&Session("UserID")&" Order By ID Desc")
				Do While Not Rs.Eof
				%>
                <tr> 
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(0)%></div></td>
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(1)%> 元</div></td>
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(2)%> 两</div></td>
                  <td bgcolor="#FFFFFF"><div align="left"></div>
                    <%=Rs(3)%></td>
                  <td bgcolor="#FFFFFF"><div align="center"><%=Rs(4)%></div></td>
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
