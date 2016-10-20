<!--#include file="Top.asp" -->
<%CxGame.GameCls()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"> <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
        <tr> 
          <td height="35" background="img/index_title_bg.gif" id="err"><strong>负分清零--每次清零需扣除银行100梦幻币!</strong></td>
        </tr>
        <tr> 
          <td height="35" id="err"><form name="form1" method="post" action="">
              <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td width="20%"><div align="center">选择清零游戏:</div></td>
                  <td width="80%"><select name="GameDb" id="GameDb">
                      <option value="WHCXLandDB" selected>慈溪斗地主</option>
                      <option value="WHLandDB">斗地主</option>
                      <option value="WHGoBangDB">五子棋</option>
                      <option value="WHChinaChessDB">中国象棋</option>
                      <option value="LLShow_Cx">连连看</option>
                    </select></td>
                </tr>
                <tr>
                  <td><div align="center">输入验证码:</div></td>
                  <td><input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
                    <%CxGame.Vcode()%>
                    <input name="cls" type="hidden" id="cls" value="true"> 
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td><input type="submit" name="Submit" value="确定负分清零"></td>
                </tr>
                <tr> 
                  <td colspan="2" class="box3">
<div align="center">警告负分清零将初始化您的积分/胜负次数/逃跑次数,清零一次需扣除银行100梦幻币!</div></td>
                </tr>
              </table>
            </form> </td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>
<!--#include file="copy.asp" -->
