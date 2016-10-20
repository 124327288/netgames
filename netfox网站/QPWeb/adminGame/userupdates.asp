<!--#include file="chak.asp"-->
<!--#include file="../inc/conn.asp"-->
<!--#include file="../inc/goPage.asp" -->
<link href="../inc/STYLE.CSS" rel="stylesheet" type="text/css">
<body leftmargin="0" topmargin="0">
<script language="javascript" type="text/javascript">
<!--
function CheckOthers(form)
{
     for (var i=0;i<form.elements.length;i++)
     {
           var e = form.elements[i];
//            if (e.name != 'chkall')
                 if (e.checked==false)
                 {
                       e.checked = true;// form.chkall.checked;
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
//            if (e.name != 'chkall')
                 e.checked = true// form.chkall.checked;
     }
}
function ConfirmDel()
{
   if(confirm("确定要删除您选中的产品吗？一旦删除将不能恢复！"))
     return true;
   else
     return false;
	 
}
//-->
</script>
<%
if request.form("ACT")="ok" Then
		xm=replace(trim(request("xm")),"'","")
		nc=replace(trim(request("nc")),"'","")
		xl=replace(trim(request("xl")),"'","")
		sf=replace(trim(request("sf")),"'","")
		nl=replace(trim(request("nl")),"'","")
		tz=replace(trim(request("tz")),"'","")
		sg=replace(trim(request("sg")),"'","")
		xz=replace(trim(request("xz")),"'","")
		dh=replace(trim(request("dh")),"'","")
		ad=replace(trim(request("ad")),"'","")
		mail=replace(trim(request("mail")),"'","")
		qq=replace(trim(request("qq")),"'","")
		zy=replace(trim(request("zy")),"'","")
		add=replace(trim(request("add")),"'","")
		classs=replace(trim(request("class")),"'","")
		info=replace(trim(request("info")),"'","")
		SID=REQUEST.FORM("ID")
		if xm="" or nc="" or sf="" or nl="" or tz="" or sg="" or xz="" or dh="" or ad="" or mail="" or qq="" or zy="" or add="" or Info="" Then 
			response.write "<script language=JavaScript>" & chr(13) & "alert('每项为必项，不能为空！');" & "history.back()" & "</script>"
			response.end
		End if
	set rs=server.CreateObject("adodb.recordset")
	rs.open "select * from [user] WHERE ID="&SID&"",conn,1,3
	rs("xm")=xm
	rs("nc")=nc
	rs("sf")=sf
	rs("nl")=nl
	rs("tz")=tz
	rs("xl")=xl
	rs("sg")=sg
	rs("xz")=xz
	rs("dh")=dh
	rs("ad")=ad
	rs("mail")=mail
	rs("qq")=qq
	rs("zy")=zy
	rs("add")=add
	rs("class")=classs
	rs("info")=info
	rs.update
	rs.close
	set rs=nothing
	url=Request.ServerVariables("HTTP_REFERER")
	Response.Write "<script language=JavaScript1.1>alert('修改用户成功！');" 
	Response.Write " document.location='"&url&"';</script>" 
	Response.End
End if

id=request.QueryString("id")
set rs=conn.execute("select * from user Where id="&id&"")

%>
  <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td bgcolor="#999999"><table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            <td height="29" bgcolor="#0099CC"> <div align="center"><font color="#FFFFFF">用</font><font color="#FFFFFF">户管理</font></div></td>
          </tr>
        </table></td>
  </tr>
</table>
<form name="form1" method="post" action="">
  <table width="85%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td bgcolor="#CC9966"><table width="100%" border="0" align="center" cellpadding="5" cellspacing="1" class="lh13">
          <tr bgcolor="F7EFE4"> 
            <td height="40" colspan="2" class="lh15"> <div align="center"><strong>修改用户基本资料 
                <font color="#FF0000" size="+3"><%=errs%> 
                <input name="id" type="hidden" id="id" value="<%=rs("id")%>">
                <input name="act" type="hidden" id="act" value="ok">
                </font></strong></div></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td width="24%"><div align="right">真实姓名：</div></td>
            <td width="76%"><input name="xm" type="text" id="xm" value="<%=rs("xm")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">昵称：</div></td>
            <td width="76%"><input name="nc" type="text" id="nc" value="<%=rs("nc")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">学历：</div></td>
            <td width="76%"><input name="xl" type="text" id="xl2" value="<%=rs("xl")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">姓别：</div></td>
            <td>男 
              <input name="sex" type="radio" value="男" checked>
              女 
              <input type="radio" name="sex" value="女"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">婚否：</div></td>
            <td>未婚 
              <input name="hf" type="radio" value="未婚" checked>
              已婚 
              <input type="radio" name="hf" value="已婚">
              离异 
              <input type="radio" name="hf" value="离异">
              丧偶 
              <input type="radio" name="hf" value="丧偶"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">身份证号码：</div></td>
            <td width="76%"><input name="sf" type="text" id="sf2" value="<%=rs("sf")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">年龄：</div></td>
            <td width="76%"><input name="nl" type="text" id="nl" value="<%=rs("nl")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">体重：</div></td>
            <td><input name="tz" type="text" id="tz" value="<%=rs("tz")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">身高：</div></td>
            <td><input name="sg" type="text" id="sg" value="<%=rs("sg")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">星座：</div></td>
            <td><input name="xz" type="text" id="xz" value="<%=rs("xz")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">来自：</div></td>
            <td><input name="ad" type="text" id="ad" value="<%=rs("ad")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">电话：</div></td>
            <td><input name="dh" type="text" id="dh" value="<%=rs("dh")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">E-mail：</div></td>
            <td><input name="mail" type="text" id="mail" value="<%=rs("mail")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">QQ:</div></td>
            <td><input name="qq" type="text" id="qq" value="<%=rs("qq")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">主页：</div></td>
            <td><input name="zy" type="text" id="zy" value="<%=rs("zy")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">详细地址：</div></td>
            <td><input name="add" type="text" id="add" value="<%=rs("add")%>"></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">希望加入：</div></td>
            <td><select name="class" id="class">
                <option value="单身男女" <%if rs("class")="单身男女" Then%>selected<%end if%>>单身男女</option>
                <option value="知心朋友" <%if rs("class")="知心朋友" Then%>selected<%end if%>>知心朋友</option>
                <option value="工作朋友" <%if rs("class")="工作朋友" Then%>selected<%end if%>>工作朋友</option>
                <option value="生意朋友" <%if rs("class")="生意朋友" Then%>selected<%end if%>>生意朋友</option>
                <option value="兴趣朋友" <%if rs("class")="兴趣朋友" Then%>selected<%end if%>>兴趣朋友</option>
              </select></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td><div align="right">自我介绍：</div></td>
            <td><textarea name="info" cols="50" rows="20" id="info"><%=rs("info")%></textarea></td>
          </tr>
          <tr bgcolor="F7EFE4"> 
            <td colspan="2"> <div align="center"> 
                <input type="submit" name="Submit" value="提交">
              </div></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<%rs.close:Set rs=nothing
conn.close:set conn=nothing%>