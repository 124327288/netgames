<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<%
newstitle=trim(request.Form("newstitle"))
newscu=trim(request.Form("newscu"))
classcode=trim(request.Form("classcode"))
newszz=trim(request.Form("newszz"))
newsdate=request.Form("newsdate")
newsinfo=request.form("newsinfo")
pl=request.form("pl")
keyword=trim(request.form("keyword"))
gd=request.form("gd")
down=request.form("select")
if down<>"" then
  down="../htmledit/UploadFile/"&down
end if
top2=request.form("top")
if not isdate(newsdate) then
  response.write "<script language=JavaScript>" & chr(13) & "alert('��������ȷ��ʱ���ʽ');" & "history.back()" & "</script>"
  Response.End
end if
newsdate=cdate(newsdate)
set rs=server.createobject("adodb.recordset")
sql="select * from news"
rs.open sql,conn,1,3
rs.addnew
rs("newstitle")=newstitle
rs("newscu")=newscu
rs("classcode")=classcode
rs("newszz")=newszz
rs("newsdate")=newsdate
rs("newsinfo")=newsinfo
rs("pl")=pl
rs("keyword")=keyword
rs("ts")=now()
rs("down")=down
rs.update
rs.close
set rs=nothing
Response.Write "<script language=JavaScript1.1>alert('�������³ɹ� ');" 
Response.Write " document.location='newsadd.asp';</script>" 
Response.End
%>
