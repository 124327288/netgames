<%
if session("adminadminchen")="" or session("chenruofanfan")<>"chenruofanfan112233" then
%>
<script language="JavaScript1.1">
alert('对不起,你可能太久没有操作,或是没有登陆,为了全安,请重新登陆.')
parent.document.location="login.asp"
</script> 
<%end if%>
