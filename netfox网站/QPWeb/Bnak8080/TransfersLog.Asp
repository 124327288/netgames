<!--#include file="Inc/Config.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title></title>
<link href="css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.bian {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #999999;
}
-->
</style>
<STYLE type=text/css>
body { 
SCROLLBAR-FACE-COLOR: ##CCCCCC ; 
SCROLLBAR-HIGHLIGHT-COLOR: #F0F0F0; 
SCROLLBAR-SHADOW-COLOR: #434343; 
SCROLLBAR-3DLIGHT-COLOR: #434343; 
SCROLLBAR-ARROW-COLOR: #434343; 
SCROLLBAR-TRACK-COLOR: #F0F0F0;
SCROLLBAR-DARKSHADOW-COLOR: #F0F0F0
}
</STYLE> 
</head>
<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0">
<table width="360" height="240" cellpadding="5" cellspacing="0">
  <tr>
<form name="form1" method="post" action="">
      <td valign="top"> 
        <fieldset style="width:350;height=240" align="center"><legend>以下是您的转帐明细(最近20条)</legend>
        <table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr> 
            <td width="18%" bgcolor="#efefef"> 
              <div align="center">数额</div></td>
            <td width="22%" bgcolor="#efefef"> 
              <div align="center">支付人</div></td>
            <td width="18%" bgcolor="#efefef"> 
              <div align="center">收款人</div></td>
            <td width="18%" bgcolor="#efefef"> 
              <div align="center">手续费</div></td>
            <td width="24%" bgcolor="#efefef"> 
              <div align="center">时间</div></td>
          </tr>
          <%
				CxGame.IsCheckLogin()
				CxGame.DbConn("WhTreasureDb")
				Set Rs=Conn.Execute("Select Top 20  SourceAccounts,TargetAccounts,SwapScore,Revenue,CollectDate From RecordInsure Where (SourceUserID="&Session("UserID")&" Or SourceGameID="&Session("UserID")&") AND TradeType=3 Order By DateTime Desc")
				Do While Not Rs.Eof
				%>
          <tr class="bian"> 
            <td class="bian"> 
              <div align="center"><%=Rs(2)%></div></td>
            <td class="bian"> 
              <div align="center"><%=Rs(0)%></div></td>
            <td class="bian"> 
              <div align="center"><%=Rs(1)%></div></td>
            <td class="bian"> 
              <div align="center"><%=Rs(3)%></div></td>
            <td class="bian"> 
              <div align="center"><%=Rs(4)%></div></td>
          </tr>
          <%
				Rs.MoveNext
				Loop
				CxGame.RsClose:CxGame.DbClose
				%>
        </table>
        </fieldset>
</td>
</form>
</tr>

</table>
</body>
</html>
