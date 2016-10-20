<!--#include file="CommonFun.asp"-->
<!--#include file="conn.asp"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=GetQPAdminSiteName() %></title>
</head>
<frameset rows="*" cols="181,*" framespacing="0" frameborder="1" border="false" id="frame" scrolling="yes">
  <frame name="left" scrolling="auto" marginwidth="0" marginheight="0" src="Admin_Index_Left.asp">
  <frameset framespacing="0" border="false" rows="35,*" frameborder="0" scrolling="yes">
    <frame name="top" scrolling="no" src="Admin_Index_Top.asp">
    <frame name="main" scrolling="auto" src="Admin_Index_Main.asp">
  </frameset>
</frameset>
<noframes>
  <body leftmargin="2" topmargin="0" marginwidth="0" marginheight="0">
  <p>你的浏览器版本过低！！！本系统要求IE5及以上版本才能使用本系统。</p>
  </body>
</noframes>
</html>
