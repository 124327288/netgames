<!--#include file="Top.asp" -->
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="boxlogin">
          <tr> 
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong>�������߽����ѯ</strong></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="usernameerr">���߽����ѯ</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">�û���:</div></td>
            <td><input name="UserName" type="text" class="input" id="code"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="104"> <div align="center">������:</div></td>
            <td width="398"> <input name="code" type="text" class="input" id="code2" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <input type="submit" name="Submit" value=" ��ѯ���߽�� "> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">��֤��: </div></td>
            <td><input name="getcode" type="text" class="input" id="getcode2" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="ssselect" type="hidden" id="login2" value="true"></td>
          </tr>
        </table>
        <br>
        <br>
        <%CxGame.SSSelect()%>
        <br>
      </form></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
