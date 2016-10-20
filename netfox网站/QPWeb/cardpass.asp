<!--#include file="GamePass/BasPassWordClass.Asp" -->
<%
DIM PASSWORD
IF Request.Form("PassWord")<>"" tHEN
PassWord=Trim(Request.Form("PassWord"))
Password=SetPassword(PassWord)
END IF
%>
<form name="form1" method="post" action="">
  ÊהÈכÃÜÂכ 
  <input name="password" type="text" id="password">
  <input type="submit" name="Submit" value="Ìב½»">
  <input name="textfield" type="text" value="<%=PassWord%>">
</form>
