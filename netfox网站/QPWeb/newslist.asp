<!--#include file="Top.asp" -->
<%CxGame.ReOk()%>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"> <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="boxlogin">
        <tr> 
          <td height="35" background="img/index_title_bg.gif" id="err"><strong><%=Request("ClassName")%></strong></td>
        </tr>
        <tr> 
          <td height="35" id="err"> 
            <%CxGame.NewsList Request("ClassCode"),15%>
          </td>
        </tr>
      </table>

  </td>
  </tr>
</table>
<!--#include file="copy.asp" -->
