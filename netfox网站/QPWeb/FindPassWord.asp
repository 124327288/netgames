<!--#include file="Top.asp" -->
<%CxGame.FindPassWord()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
          <tr> 
            <td height="35" colspan="2" id="err" background="img/index_title_bg.gif"><strong>�����ҵ����� 
              </strong></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">�û���:</div></td>
            <td><input name="username" type="text" class="input" id="getcode"> 
              <a href="Passwordprotection.Asp">�������������뱣��</a></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="100"> <div align="center">�����������:</div></td>
            <td> <input name="PassWord" type="password" class="input" id="PassWord2"> 
              <span class="box2">������Ҫ����ĵ�������! </span></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������������:</div></td>
            <td><div align="left"> 
                <input name="BankPassWord" type="password" class="input" id="BankPassWord2">
                <span class="box2">������Ҫ�������������! </span></div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2" valign="bottom"><div align="left" class="box2" id="codeid"> 
                �����û���������뱣��,������ͨ���˲�����������!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">���밲ȫ��:</div></td>
            <td> <div align="left"> 
                <input name="code" type="password" class="input" id="code">
              </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">��֤��:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode2" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="rlogin" type="hidden" id="login2" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="�����ҵ�����"> </td>
          </tr>
        </table>
        <div align="center"><br>
          <br>
        </div>
      </form></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
