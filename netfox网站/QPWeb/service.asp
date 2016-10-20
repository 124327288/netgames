<!--#include file="Top.asp" -->
<%CxGame.ReOk()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"> <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
        <tr> 
          <td height="35" background="img/index_title_bg.gif" id="err"><strong>常见问题</strong></td>
        </tr>
        <tr> 
          <td height="35" id="err"> 
            <%CxGame.NewsTop "104",10,18,"NewsTop"%>
          </td>
        </tr>
      </table>
      <br>
      <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
        <tr> 
          <td width="100" height="35" background="img/index_title_bg.gif" id="err"><strong>提问</strong></td>
        </tr>
        <tr> 
          <td height="35" id="err"><form name="form1" method="post" action="">
              <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td width="28%"><div align="center">提问内容:</div></td>
                  <td width="72%"><textarea name="txt" cols="40" rows="5" id="txt"></textarea></td>
                </tr>
                <tr bgcolor="#FFFFFF" class="boxlogin"> 
                  <td> <div align="center">验证码:</div></td>
                  <td> <input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
                    <%CxGame.Vcode()%>
                    <input name="add" type="hidden" id="add" value="ok"> </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><input type="submit" name="Submit" value="我要提问">(重复提交问题者一率不予回复)</td>
                </tr>
              </table>
            </form></td>
        </tr>
      </table>
      <br>
	  <%cxgame.ReList()%>
  </td>
  </tr>
</table>
<!--#include file="copy.asp" -->
</body>
</html>
