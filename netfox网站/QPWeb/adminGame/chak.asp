<%
if session("adminadminchen")="" or session("chenruofanfan")<>"chenruofanfan112233" then
%>
<script language="JavaScript1.1">
alert('�Բ���,�����̫��û�в���,����û�е�½,Ϊ��ȫ��,�����µ�½.')
parent.document.location="login.asp"
</script> 
<%end if%>
