<!--#include file="Top.asp" -->
<!--#include file="GamePass/BasPassWordClass.Asp" -->
<%
CxGame.Transfers()
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
    <td width="580" valign="top"><br>
      <br>
      <form name="form1" method="post" action="">
        <table width="450" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
          <tr> 
            <td height="28" colspan="2"  background="img/q03.jpg"><font color="#FFFFFF"><strong>转帐服务 
              </strong></font> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="117"> <div align="center">现有银行存款:</div></td>
            <td width="311"> <input name="Deposits" type="text" class="input" id="Deposits" value="<%=Session("Deposits")%>" readonly="true">
              <a href="R.asp?Act=R">刷新银子</a></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">收款人用户名:</div></td>
            <td> <input name="UserName" type="text" class="input" id="UserName">
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td valign="top">
<div align="center">收款人ID号:</div></td>
            <td><div align="left">
                <input name="UserID" type="text" class="input" id="UserID"  style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"></div>
                
              <div align="left" class="box2">为防止转错帐ID号必须与收款人用户名匹配!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">转帐数额:</div></td>
            <td><input name="money2" type="text" class="input" id="money2" value="0" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9">
              注意切换到英文输入法输入</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">银行密码:</div></td>
            <td><input name="password" type="password" class="input" id="getcode"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode3" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="login" type="hidden" id="login4" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input name="imageField" type="image" src="img/Wealth3.jpg" width="150" height="34" border="0"></td>
          </tr>
        </table>
      </form> </td>
  </tr>
</table>
<!--#include file="Copy.asp" -->
</body>
</html>
