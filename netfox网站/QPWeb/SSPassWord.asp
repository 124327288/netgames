<!--#include file="Top.asp" -->
<%
IF Request.Cookies("passwordsh")("reg")="abbabb" Then
	Response.Write "<div align=""center""><font color=""#FF0000"" size=""+2"">�Բ���,����Ϸ����һ��IPһ��ֻ����������!</font></div>"
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
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong><a href="SSPassWord.asp"><font color="#FF0000">��������</font></a></strong> 
              | <a href="SSSelect.asp"><font color="#FF0000"><strong>���߽����ѯ</strong></font></a></td>
          </tr>
          <tr> 
            <td height="35" colspan="2" background="img/index_title_bg.gif" id="err"><strong>��������(�������߲����ܱ�֤һ�����һ���������,��������������뱣���������<a href="FindPassWord.asp">��������</a>)</strong></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="usernameerr">������Ϸ����ע��ʱ����д������</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="167"><div align="center">��Ϸ�����û���:</div></td>
            <td width="342"> <input name="UserName" type="text" class="input" id="UserName2" maxlength="20">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">ע��ʱ�õ�����:</div></td>
            <td><input name="Nmail" type="text" class="input" id="Nmail">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">ע��ʱ�õ����֤:</div></td>
            <td><input name="Ncode" type="text" class="input" id="Ncode">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">ע��ʱ�õĵ�ַ:</div></td>
            <td><input name="Nadd" type="text" class="input" id="Nadd">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������ʾ����:</div></td>
            <td><input name="PassW" type="text" class="input" id="PassW">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������ʾ��:</div></td>
            <td><input name="PassD" type="text" class="input" id="Ncode32">
              * ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������ϵ��ʽ:</div></td>
            <td><input name="Tel" type="text" class="input" id="Tel">
              ����������,�ֻ�,�绰* ����</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center"> 
                <p>����:<br>
                  (����д��ϣ�����ĵ�����,����һЩת�ʼ�¼,ע��ʱ�������) </p>
              </div></td>
            <td><textarea name="Txt" cols="40" rows="5" id="PassD"></textarea> 
              <br>
              ��700��</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="codeerr">��֤��:���������������ұߵ�����!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">��֤��:</div></td>
            <td> <input name="getcode" type="text" class="input" id="getcode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode2()%>
              <input name="sspassword" type="hidden" id="login2" value="true"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="ȷ������"></td>
          </tr>
        </table>
        <br>
        <br>
      </form><%CxGame.PassWordSS()%></td>
  </tr>
</table>
<!--#include file="copy.asp" -->
