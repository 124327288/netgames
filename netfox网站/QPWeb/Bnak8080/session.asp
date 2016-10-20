<!--#include file="Inc/Config.asp" -->
<%
Session("UserID")=Empty
Session("UserName")=Empty
Session("Deposits")=Empty	
Session("money")=Empty
CxGame.IsLogin()
%>
