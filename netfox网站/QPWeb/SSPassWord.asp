<!--#include file="Top.asp" -->
<%
IF Request.Cookies("passwordsh")("reg")="abbabb" Then
	Response.Write "<div align=""center""><font color=""#FF0000"" size=""+2"">对不起,本游戏中心一个IP一天只能申诉两次!</font></div>"
	Response.End
End IF
%>
<script language="javascript" src="passwordstrength.js"></script>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="boxlogin">
          <tr>
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong><a href="SSPassWord.asp"><font color="#FF0000">密码申诉</font></a></strong> 
              | <a href="SSSelect.asp"><font color="#FF0000"><strong>申诉结果查询</strong></font></a></td>
          </tr>
          <tr> 
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong>密码申诉(密码申诉并不能保证一定能找回您的密码,如果你申请了密码保护请点这里<a href="FindPassWord.asp">重设密码</a>)</strong></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="usernameerr">您在游戏中心注册时所填写的资料</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="167"><div align="center">游戏中心用户名:</div></td>
            <td width="342"> <input name="UserName" type="text" class="input" id="UserName2" maxlength="20">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">注册时用的邮箱:</div></td>
            <td><input name="Nmail" type="text" class="input" id="Nmail">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">注册时用的身份证:</div></td>
            <td><input name="Ncode" type="text" class="input" id="Ncode">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">注册时用的地址:</div></td>
            <td><input name="Nadd" type="text" class="input" id="Nadd">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">密码提示问题:</div></td>
            <td><input name="PassW" type="text" class="input" id="PassW">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">密码提示答案:</div></td>
            <td><input name="PassD" type="text" class="input" id="Ncode32">
              * 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">您的联系方式:</div></td>
            <td><input name="Tel" type="text" class="input" id="Tel">
              可以是邮箱,手机,电话* 必填</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center"> 
                <p>描述:<br>
                  (可填写你希望更改的密码,您的一些转帐记录,注册时间等资料) </p>
              </div></td>
            <td><textarea name="Txt" cols="40" rows="5" id="PassD"></textarea> 
              <br>
              限700字</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="codeerr">验证码:输入您所看到的右边的数字!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode2()%>
              <input name="sspassword" type="hidden" id="login2" value="true"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="确定申诉"></td>
          </tr>
        </table>
        <br>
        <br>
      </form><%CxGame.PassWordSS()%></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
