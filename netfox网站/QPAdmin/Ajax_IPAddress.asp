<!--#include file="Conn.asp"-->

<%
Dim IpAddr
IpAddr=Trim(Request.QueryString("ipaddr"))

IF IsNull(IpAddr) OR IpAddr="" Then
   Response.Write("没有记录")
Else
    Response.Write(GetCityFromIP(IpAddr))
End IF
Response.End()
%>