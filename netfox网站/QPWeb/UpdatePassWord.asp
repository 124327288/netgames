<!--#include file="Top.asp" -->
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
          <tr> 
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong>修改登入密码</strong> 
              <%CxGame.UpdatePassWord("LogonPass")%>
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> <div align="center" id="userid">登陆原密码:</div></td>
            <td width="287"> <input name="UserName" type="password" class="input" id="UserName2"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> 
              <div align="center">登陆新密码:</div></td>
            <td> <input name="PassWord" type="password" class="input" id="PassWord3"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93">
<div align="center">确定新密码:</div></td>
            <td><input name="PassWord2" type="password" class="input" id="PassWord22"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> 
              <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="UpPass" type="hidden" id="login2" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> 
              <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="修改密码"></td>
          </tr>
        </table>
        <br>
        <br>
      </form></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
