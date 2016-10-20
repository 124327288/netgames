<!--#include file="Top.asp" -->
<!--#include file="GamePass/BasPassWordClass.Asp" -->

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
    <td width="560">
<div align="center"> 
        <form name="form1" method="post" action="">
          <br>
          <table width="400" border="0" align="center" cellpadding="5" cellspacing="0" class="box">
            <tr> 
              <td height="28" colspan="2" id="err" background="img/q03.jpg"><font color="#FFFFFF"><strong>修改银行密码</strong></font> 
                <%CxGame.UpdatePassWord("InsurePass")%>
              </td>
            </tr>
            <tr bgcolor="#FFFFFF"> 
              <td width="93"> <div align="center" id="userid">银行原密码:</div></td>
              <td width="287" align="left"> <input name="UserName" type="password" class="input" id="UserName"> 
              </td>
            </tr>
            <tr bgcolor="#FFFFFF"> 
              <td> <div align="center">银行新密码:</div></td>
              <td align="left"> <input name="PassWord" type="password" class="input" id="PassWord3"></td>
            </tr>
            <tr bgcolor="#FFFFFF"> 
              <td><div align="center">确定新密码:</div></td>
              <td align="left"><input name="PassWord2" type="password" class="input" id="PassWord22"></td>
            </tr>
            <tr bgcolor="#FFFFFF"> 
              <td> <div align="center">验证码:</div></td>
              <td align="left"> <input name="getcode" type="text" class="input" id="getcode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
                <%CxGame.Vcode()%>
              <input name="UpPass" type="hidden" id="UpPass" value="true"></td>
            </tr>
            <tr bgcolor="#FFFFFF"> 
              <td> <div align="center"> </div></td>
              <td align="left"><input name="imageField" type="image" src="img/uppass.jpg" width="150" height="34" border="0"></td>
            </tr>
          </table>
          <br>
          <div align="center"> 
            <p><a href="UpdatePassWord.asp"><img src="img/password.jpg" width="180" height="34" border="0"></a></p>
            <p><br>
            </p>
          </div>
        </form>
      </div></td>
  </tr>
</table>
<!--#include file="Copy.asp" -->
</body>
</html>
