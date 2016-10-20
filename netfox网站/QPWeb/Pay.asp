<!--#include file="Top.asp" -->
<%CxGame.Pay()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="170" valign="top"><table border="0" align="center" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">
      <tr>
        <td width="174"><div align="center"><a href="BankPass.asp"><img src="img/bank1.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><div align="center"><a href="ServeWealth.Asp"><img src="img/bank2.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><div align="center"><a href="ReceiveWealth.Asp"><img src="img/bank3.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><div align="center"><a href="Transfers.Asp"><img src="img/bank4.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><div align="center"><a href="TransfersLog.Asp"><img src="img/bank5.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><div align="center"><a href="Pay.asp"><img src="img/bank7.jpg" width="170" height="34" border="0" /></a></div></td>
      </tr>
      <tr>
        <td><a href="ChongzhiLog.Asp"><img src="img/bank6.jpg" width="170" height="34" border="0" /></a></td>
      </tr>
    </table></td>
    <td width="580" valign="top"><br />
        <br />
<form name="form1" method="post" action="">
        <table width="450" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td height="28" colspan="2" id="err" background="img/q03.jpg"><font color="#FFFFFF"><strong>请输入您的卡号和密码进行充值</strong></font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="100"> <div align="center">这里输入卡号:</div></td>
            <td> <input name="CardCode" type="text" class="input2" id="CardCode"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">这里输入密码:</div></td>
            <td><div align="left"> 
                <input name="CardPass" type="text" class="input2" id="CardPass">
              </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="login" type="hidden" id="login2" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input name="imageField" type="image" src="img/pay.jpg" width="150" height="34" border="0"> 
            </td>
          </tr>
        </table>
</form></td>
  </tr>
</table>
<!--#include file="Copy.asp" -->

</body>
</html>
