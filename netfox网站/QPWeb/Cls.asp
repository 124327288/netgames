<!--#include file="Top.asp" -->
<%CxGame.GameCls()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"> <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
        <tr> 
          <td height="35" background="img/index_title_bg.gif" id="err"><strong>��������--ÿ��������۳�����100�λñ�!</strong></td>
        </tr>
        <tr> 
          <td height="35" id="err"><form name="form1" method="post" action="">
              <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td width="20%"><div align="center">ѡ��������Ϸ:</div></td>
                  <td width="80%"><select name="GameDb" id="GameDb">
                      <option value="WHCXLandDB" selected>��Ϫ������</option>
                      <option value="WHLandDB">������</option>
                      <option value="WHGoBangDB">������</option>
                      <option value="WHChinaChessDB">�й�����</option>
                      <option value="LLShow_Cx">������</option>
                    </select></td>
                </tr>
                <tr>
                  <td><div align="center">������֤��:</div></td>
                  <td><input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
                    <%CxGame.Vcode()%>
                    <input name="cls" type="hidden" id="cls" value="true"> 
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><input type="submit" name="Submit" value="ȷ����������"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="box3">
<div align="center">���渺�����㽫��ʼ�����Ļ���/ʤ������/���ܴ���,����һ����۳�����100�λñ�!</div></td>
                </tr>
              </table>
            </form> </td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>
<!--#include file="copy.asp" -->
