<!--#include file="Top.asp" -->
<%
IF CxGame.GetInfo(0,"form","Act")="R" Then
	Session("Deposits")=Empty	
	Session("money")=Empty
	Response.Redirect Request.ServerVariables("HTTP_REFERER")
End IF	
Set CxGame=Nothing
%>
</body>
</html>
