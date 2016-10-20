<%
SqlConnectionString="DRIVER={SQL Server};SERVER=(local);UID=sa;PWD=sa;DATABASE=news;"
Set Conn= Server.CreateObject("ADODB.Connection")
Conn.Open SqlConnectionString
%>