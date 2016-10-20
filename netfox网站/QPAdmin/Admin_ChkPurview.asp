<%
'***************************************
'х╗оч╪Л╡И
'***************************************
Dim AdminSet,AdminName,AdminPassword
AdminName=Replace(Trim(Session("AdminName")),"'","")
AdminPassword=Replace(Trim(Session("AdminPassword")),"'","")

IF AdminName="" OR adminpassword="" Then
	Response.Redirect "Admin_login.asp"
End IF

Dim sqlGetAdmin,rsGetAdmin
sqlGetAdmin="select * from qq_Admin where UserName='" & AdminName & "' and Password='" & AdminPassword & "'"
Set rsGetAdmin=Server.CreateObject("adodb.recordset")
rsGetAdmin.open sqlGetAdmin,DbAccConn,1,1

IF  rsGetAdmin.Eof Then
	rsGetAdmin.close
	Set rsGetAdmin=Nothing
	Call CloseDbAccConn()
	Response.Redirect "Admin_login.asp"
END IF
%>