<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<% dim clsssname,rs,re,yy,xx,list,classcode,classcoden,codeq
id=request("id")
classpic=trim(request.form("classpic"))
classname=trim(request.form("classname"))
code=request.form("code")
class_=request.form("class_")
'������֤
if code=class_ then
  response.write "<script language=JavaScript>" & chr(13) & "alert('���಻�����򱾷���ת�ƻ��߷�������߲��ܸı����Χ�����ϼ��ķ���');" & "history.back()" & "</script>"
  Response.End
end if

if classname="" then
  response.write "<script language=JavaScript>" & chr(13) & "alert('����������Ϊ��');" & "history.back()" & "</script>"
  Response.End
end if

if code<>left(class_,len(class_)-3) then
'�Զ���Ȿ������ϼ�������ӷ������һ��CLASSCODE,��û��,����:&100,����,ȡ�������λ��1Ȼ���CODEȥ�������λ�������¼ӵ������λ
codeq=len(code)+3
set re=server.createobject("adodb.recordset")
sqe="select top 1 * from class where len(classcode)="&codeq&" and classcode like '"&code&"%' order by classcode desc"
re.open sqe,conn,1,1
if re.eof and re.bof then
  classcode=code&"100"
else
  classcode=re("classcode")
  x=len(classcode)
  y=mid(classcode,x-2)
  y=y+1
  w=mid(classcode,1,x-3)
  classcode=w&y
end if
'ȡ�ñ�����ԭ����CLASSCODE
set rs=server.createobject("adodb.recordset")
sql="select * from class where id="&id
rs.open sql,conn,1,3
classcoden=rs("classcode")
xx=len(classcoden)
zz=len(code)
if xx<zz and left(code,xx)=classcoden then
  response.write "<script language=JavaScript>" & chr(13) & "alert('���಻���򱾷�����κ��¼��ӷ���ת��');" & "history.back()" & "</script>"
  Response.End
end if
'�����ӷ���CLASSCODE
set rs2=server.createobject("adodb.recordset")
list="select classcode from class where classcode like '"&classcoden&"%'"
rs2.open list,conn,1,3
do while not rs2.eof
  yy=mid(rs2("classcode"),xx+1)
  rs2("classcode")=classcode&yy
  rs2.update
  rs2.movenext
loop
rs2.close
'��������CLASSCODE
set rs2=server.createobject("adodb.recordset")
list="select classcode from news where classcode like '"&classcoden&"%'"
rs2.open list,conn,1,3
if not rs2.eof then
do while not rs2.eof
  yy=mid(rs2("classcode"),xx+1)
  rs2("classcode")=classcode&yy
  rs2.update
  rs2.movenext
loop
rs2.close
end if
'���¹���Աclasscode
set rs2=server.createobject("adodb.recordset")
list="select classcode from admin where classcode like '"&classcoden&"%'"
rs2.open list,conn,3,3
if not rs2.eof then
do while not rs2.eof
  yy=mid(rs2("classcode"),xx+1)
  rs2("classcode")=classcode&yy
  rs2.update
  rs2.movenext
loop
rs2.close
end if
'���±�����CLASSCODE
classcode=cstr(classcode)
rs("classcode")=classcode
rs("classpic")=classpic
rs("classname")=classname
rs.update
rs.close
re.close
set rs=nothing
set re=nothing
Response.Write "<script language=JavaScript1.1>alert('�޸ķ���ɹ� ');" 
Response.Write " document.location='classedit.asp';</script>" 
Response.End
else
set rs=server.CreateObject("adodb.recordset")
sql="select * from class where id="&id
rs.open sql,conn,1,3
rs("classname")=classname
rs("classpic")=classpic
rs.update
rs.close
set rs=nothing
Response.Write "<script language=JavaScript1.1>alert('�޸ķ���ɹ� ');" 
Response.Write " document.location='classedit.asp';</script>" 
Response.End
end if
%>