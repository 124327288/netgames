<!--#include file="Top.asp" -->
<script language="javascript" src="passwordstrength.js"></script>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#FFFFFF" ><form name="form1"  method="post" action="" >
        <table width="730" border="0" align="center"  cellpadding="5" cellspacing="0" class="boxlogin" style="margin:10px auto 0 auto;">
          <tr> 
            <td height="35" colspan="2" id="err" background="img/index_title_bg.gif"><strong><font color="#000000">�����û�����������е���</font></strong> 
              <%CxGame.CheckLogin()%>
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> <div align="center" id="userid">�� ��:</div></td>
            <td width="287"> <input name="UserName" type="text" class="user" id="UserName">
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> 
              <div align="center">�� ��:</div></td>
            <td> <input name="PassWord" type="password" class="user" id="PassWord"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="center" class="box4"> ������ָ��������,������������,��ע��! 
              </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="93"> 
              <div align="center">��֤��:</div></td>
            <td> <input name="getcode" type="text" class="user" id="GetCode" style="ime-mode:disabled" onKeyDown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="login" type="hidden" id="login" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="�û�����"></td>
          </tr>
        </table>
        <p align="center"><a href="Reg.asp">������ע���ʺ�</a></p>
    </form></td>
  </tr>
</table>
<script>
function fff(){
f.innerHTML="<img src=ff/1_"+form1.ff.value+".jpg border=0>";
}
</script>

<!--#include file="copy.asp" -->
