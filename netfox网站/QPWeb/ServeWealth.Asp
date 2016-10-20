<!--#include file="Top.asp" -->
<%CxGame.ServeWealth%>
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
    <td width="580" valign="top"><br>
      <br>
      <form name="form1" method="post" action="">
        <table width="430" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td height="28" colspan="2" id="err" background="img/q03.jpg"><font color="#FFFFFF"><strong>存入银子</strong></font> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> <div align="center" id="userid">银行存款:</div></td>
            <td width="287"> <input name="Deposits" type="text" class="input" id="Deposits" value="<%=Session("Deposits")%>" readonly="true">
              <a href="R.asp?Act=R">刷新银子</a> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">现有银子:</div></td>
            <td> <input name="money" type="text" class="input" id="money" value="<%=Session("money")%>" readonly="true"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">存入银子:</div></td>
            <td><input name="money2" type="text" class="input" id="money2" value="<%=Session("money")%>" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9">
              注意切换到英文输入法输入</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode3" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="login" type="hidden" id="login4" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input name="imageField" type="image" src="img/Wealth1.jpg" width="150" height="34" border="0"></td>
          </tr>
        </table>
      </form> </td>
  </tr>
</table>
<!--#include file="Copy.asp" -->
</body>
</html>
