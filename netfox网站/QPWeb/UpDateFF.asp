<!--#include file="Top.asp" -->
<%CxGame.UpdateFF()%>
<script language="javascript" src="passwordstrength.js"></script>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form1" method="post" action="">
        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
          <tr> 
            <td height="35" colspan="3" id="err" background="img/index_title_bg.gif"><font color="#000000"><strong>修改我的头像</strong></font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="100"> <div align="center">更换我的头像:</div></td>
            <td width="62"><select name="ff" id="ff" onChange="fff()">
                <%
					Dim Y
					for Y=0 To 247 
					%>
                <option value="<%=y%>"><%=y%></option>
                <%
					Next
					%>
              </select></td>
            <td width="256"><div align="left" id="f"></div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">验证码:</div></td>
            <td colspan="2"> <input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode()%>
              <input name="login" type="hidden" id="login" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td colspan="2"><input type="submit" name="Submit" value="更换我的头像"> 
            </td>
          </tr>
        </table>
        <div align="center"><br>
          <br>
        </div>
      </form>
    </td>
  </tr>
</table>
<script>
function fff(){
f.innerHTML="<img src=ff/face"+form1.ff.value+".gif border=0>";
}
</script>

<!--#include file="copy.asp" -->
