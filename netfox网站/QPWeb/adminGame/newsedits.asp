<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../inc/Page.asp" -->
<link href="csss.css" rel="stylesheet" type="text/css">
<link href="../inc/STYLE.CSS" rel="stylesheet" type="text/css">
<body bgcolor="#5578b8" leftmargin="0" topmargin="0">
<script language="javascript" type="text/javascript">
<!--
function lo()
{
document.location="newsadd.asp";
}

function CheckOthers(form)
{
     for (var i=0;i<form.elements.length;i++)
     {
           var e = form.elements[i];
                 if (e.checked==false)
                 {
                       e.checked = true;
                 }
                 else
                 {
                       e.checked = false;
                 }
     }
}
function CheckAll(form)
{
     for (var i=0;i<form.elements.length;i++)
     {
           var e = form.elements[i];
                 e.checked = true
     }
}
function ConfirmDel()
{
   if(confirm("ȷ��Ҫɾ����ѡ�е����¼����������е�������һ��ɾ�������ָܻ���"))
     return true;
   else
     return false;
	 
}
//-->
</script>
<%
classcode=session("user")
act=request("act")
if act="t" then
url=Request.ServerVariables("HTTP_REFERER")
classcode=request("class")
newid=request("id")
ts=request("ts")
set rs=server.CreateObject("adodb.recordset")
sql="select top 1 ts from news where classcode like '"&classcode&"%' and ts> #"&ts&"# order by ts"
rs.open sql,conn,1,3
if rs.eof and rs.bof then
Response.Write "<script language=JavaScript1.1>alert('�Բ���,�Ѿ��Ǹ������������������ǰһ���������� ');" 
Response.Write " document.location='"&url&"';</script>" 
Response.End
end if
ts2=rs("ts")
rs("ts")=ts
rs.update
set rs=server.CreateObject("adodb.recordset")
sql="update news set ts='"&ts2&"' where id="&newid
rs.open sql,conn,1,3
Response.Write "<script language=JavaScript1.1>document.location='"&url&"';</script>" 
response.end
rs.close
end if
if act="del" then
id=request.form("id")
if id="" then
Response.Write "<script language=JavaScript1.1>alert('�Բ���,��û��ѡ��Ҫɾ�������� ');" 
Response.Write " document.location='newsedit.asp';</script>" 
Response.End
end if
set del=server.CreateObject("adodb.recordset")
delsql="delete from news where id in ("&id&")"
del.open delsql,conn,1,3

set del2=server.CreateObject("adodb.recordset")
delsql2="delete from newshf where newsid in ("&id&")"
del2.open delsql2,conn,1,3

Response.Write "<script language=JavaScript1.1>alert(' ɾ�����³ɹ� ');" 
Response.Write " document.location='newsedit.asp';</script>" 
Response.End
end if
%>
<form name="form1" method="post" action="newsedit.asp?act=del">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td bgcolor="#999999"><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#cfdded" class="txt"> 
            <td width="36" height="24"> <div align="center">ѡ��</div></td>
            <td width="312" height="24"> <div align="center">���±���</div></td>
            <td width="215" height="24"> <div align="center">���³���</div></td>
            <td width="169" height="24"> <div align="center">����ʱ��</div></td>
            <td width="77" height="24"> <div align="center">��������</div></td>
            <%if request("class")<>"" then%>
            <%end if%>
            <td width="64" height="24"> <div align="center">�޸�</div></td>
          </tr>
          <%
sql="select * from news where top2=1 order by id desc"
set rs=server.createobject("adodb.recordset")
rs.open sql,conn,1,3					
rs.PageSize =20
result_n=rs.RecordCount
if result_n<=0 then
	word="�Բ���,û���κ�����!"
else
	maxpage=rs.PageCount 
	page=request("page")	
	if Not IsNumeric(page) or page="" then
		page=1
	else
		page=cint(page)
	end if
	
	if page<1 then
		page=1
	elseif  page>maxpage then
		page=maxpage
	end if	
	rs.AbsolutePage=Page
end if

		  if rs.bof and rs.eof then
		  %>
          <tr bgcolor="#FFFFFF" class="txt"> 
            <td height="24" colspan="6"><div align="center">�Բ���,û���ҵ��κ�����</div></td>
          </tr>
          <%
		response.end
		end if 
		for i=1 to rs.PageSize
		%>
          <tr bgcolor="#f0f5f9" class="txt"> 
            <td height="24"> <div align="center"> 
                <input name="id" type="checkbox" id="id" value="<%=rs("id")%>">
              </div></td>
            <td height="24"> <div align="center"><%=rs("newstitle")%></div></td>
            <td height="24"> <div align="center"><%=rs("newscu")%></div></td>
            <td height="24"> <div align="center"><%=rs("newsdate")%></div></td>
            <td height="24"> <div align="center"><a href="newspl.asp?id=<%=rs("id")%>">��������</a></div></td>
            <%if newsclass<>"" then%>
            <%end if%>
            <td height="24"> <div align="center"><a href="newsmm.asp?id=<%=rs("id")%>">�༩</a></div></td>
          </tr>
          <%
		  rs.movenext
		  if rs.eof then exit for
		  next
		  %>
          <tr bgcolor="#FFFFFF" class="txt"> 
            <td height="32" colspan="6"> <div align="center"></div>
              <div align="center"></div>
              <div align="center"></div>
              <div align="center"> 
                <INPUT name=ddd type=button class="in" onclick=CheckAll(this.form) value=ȫѡ>
                &nbsp;&nbsp;&nbsp; 
                <INPUT name=cccc type=button class="in" onclick=CheckOthers(this.form) value=��ѡ>
                &nbsp;&nbsp;&nbsp; 
                <input name="Submit" type="reset" class="in" value="��ѡ">
                &nbsp;&nbsp;&nbsp; 
                <INPUT name=cccc2 type=submit class="in" value=ɾ�� onClick="return ConfirmDel();">
                &nbsp;&nbsp;&nbsp; 
                <INPUT name=cccc22 type=button class="in" value=���� onClick="lo();">
              </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td height="24" colspan="6" class="txt"> <div align="center"></div>
              <div align="center"> 
                <%call goPage(result_n,page,20)%>
              </div></td>
          </tr>
        </table></td>
  </tr>
</table>
</form>

