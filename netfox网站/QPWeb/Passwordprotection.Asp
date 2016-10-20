<!--#include file="Top.asp" -->
<%CxGame.ProCode()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
          <tr> 
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><font color="#000000"><strong>申请密码保护</strong></font> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="100"> <div align="center">登入密码:</div></td>
            <td> <input name="PassWord" type="password" class="input" id="PassWord"> 
              <span class="box2">输入您的登入密码! </span></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">银行密码:</div></td>
            <td><div align="left"> 
                <input name="BankPassWord" type="password" class="input" id="BankPassWord">
                <span class="box2">输入您的银行密码! </span></div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td valign="top"> <div align="center">请设定安全码:</div></td>
            <td valign="top"> <div align="left"> 
                <input name="code" type="password" class="input" id="PassWord3" maxlength="40">
              </div>
              <div align="left" class="box2" id="codeid"> 安全码一旦设定,将不可更改,安全码的作用是找回用户密码的终极依据!建议用字母+数字混合组成!6位以上<br>
                <br>
                注意:不能与登入密码和银行密码相同! </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">确定安全码:</div></td>
            <td><input name="code2" type="password" class="input" id="code2" maxlength="40"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="loginsev" type="hidden" id="loginsev" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="确定申请密码保护"></td>
          </tr>
        </table>
        <br>
        <br>
        <br>
        <br>
      </form></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
