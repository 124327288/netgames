<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",11,")<=0  Then
call  RLWriteSuccessMsg("������", "û�й���Ȩ��!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
Response.End
End If
 %>
<html>
<head> 
<meta http-equiv='Content-Type' content='text/html; charset=gb2312' />
<link href='Admin_Style.css' rel='stylesheet' type='text/css' />
<!--#include file="inc/links.asp"-->
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<form name='myform1' action='' method='get'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>�����û������ƹ���</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'>
        <a href="User_UsernameConfine.asp">ȫ�������û���</a>
      </td>
</tr>
</table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action")) 
    case "addconfine"
    call addConfineContent()    
    call main()
    case "delconfine" 
    call delConfineContent()  
    call main() 
    case else
    call main()
End Select
Call CloseGame()

Sub delConfineContent()
Dim machineSerial,fname
fname="myform"  '������
content=GetInfo(0,fname,"username")
    If InStr(Session("AdminSet"), ",11,")>0 Then
        delConfineContent2(content)
    Else
        call  RLWriteSuccessMsg("������", "��û�н��б����û������Ƶ�Ȩ��!")
        Response.End      
    End If    
    Response.Redirect("?page="&Request("page"))
End Sub

Sub delConfineContent2(content)
    GameConn.execute  "Delete From ConfineContent Where String='"&content&"'"
End Sub

Sub addConfineContent()
Dim content,fname
fname="myform"  '������
content=GetInfo(0,fname,"Search")
    If InStr(Session("AdminSet"), ",11,")>0 Then
        addConfineContent2(content)
    Else
        call  RLWriteSuccessMsg("������", "��û�н��б����û�����Ȩ��!")
        Response.End      
    End If
    
    Response.Redirect("?page="&Request("page"))
End Sub

Function addConfineContent2(content)
    IF Not IsConfineUsername(content) Then
        GameConn.execute  "Insert ConfineContent(String) Values('"&Trim(content)&"')"
    Else
         call  RLWriteSuccessMsg("������", content&"�������û����Ѿ�����!")
        Response.End   
    End IF
End Function

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")

 If Request("action")="cancelConfine" AND Trim(Request("typeID"))="" Then
    call  RLWriteSuccessMsg("������", "��ѡ��Ҫɾ���ı����û���!")
    Response.End      
End IF

For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("action")		
		Case "cancelConfine"		   
			delConfineContent2(Trim(typeIDArray(lLoop)))
	End Select
Next
%>
<script type="text/javascript">
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
function unselectall(){
    if(document.myform.chkAll.checked){
        document.myform.chkAll.checked = document.myform.chkAll.checked&0;
    }
}
function CheckAll(form){
    for (var i=0;i<form.elements.length;i++){
        var e = form.elements[i];
        if (e.Name != 'chkAll'&&e.disabled==false)
            e.checked = form.chkAll.checked;
    }
}

function confine(optype){
    var opVal=document.getElementById("in_optype");
    var username=document.getElementById("Search").value;
   
    if (optype=="add"){
        opVal.value="addconfine";
        if (username.trim()=="") {
            alert("��������Ҫ�������û�����");
            return;
        }
    }
    if (optype=="del")
        opVal.value="cancelConfine";
    
    document.myform.action="User_UsernameConfine.asp?action="+opVal.value;
    document.myform.submit();
}
</script>
<%

Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr

OrderStr="String asc"
'��ѯ����
IF request("search")>"" Then  
   queryCondition = " String like '%"&sqlcheckStr(request("search"))& "%'"
End IF

'==============================================================================================================
'ִ�в�ѯ����

Set Page = new Cls_Page				'��������
Set Page.Conn = GameConn				'�õ����ݿ����Ӷ���
With Page
	.PageSize = 20					'ÿҳ��¼����
	.PageParm = "page"					'ҳ����
	'.PageIndex = 10				'��ǰҳ����ѡ������һ�������ɾ�̬ʱ��Ҫ
	.Database = "mssql"				'���ݿ�����,ACΪaccess,MSSQLΪsqlserver2000�洢���̰�,MYSQLΪmysql,PGSQLΪPostGreSql
	.Pkey="String"						'����
	.Field="String,CollectDate"	'�ֶ�
	.Table="ConfineContent"				'����
	.Condition=queryCondition					'����,����Ҫwhere
	.OrderBy=OrderStr						'����,����Ҫorder by,��Ҫasc����desc
	.RecordCount = 0				'�ܼ�¼���������ⲿ��ֵ��0�����棨�ʺ���������-1��Ϊsession��-2��Ϊcookies��-3��Ϊapplacation

	.NumericJump = 5 '��������ҳ��������ѡ������Ĭ��Ϊ3������Ϊ��ת������0Ϊ��ʾ����
	.Template = "�ܼ�¼����{$RecordCount} ��ҳ����{$PageCount} ÿҳ��¼����{$PageSize} ��ǰҳ����{$PageIndex} {$FirstPage} {$PreviousPage} {$NumericPage} {$NextPage} {$LastPage} {$InputPage} {$SelectPage}" '����ģ�壬��ѡ��������Ĭ��ֵ
	.FirstPage = "��ҳ" '��ѡ��������Ĭ��ֵ
	.PreviousPage = "��һҳ" '��ѡ��������Ĭ��ֵ
	.NextPage = "��һҳ" '��ѡ��������Ĭ��ֵ
	.LastPage = "βҳ" '��ѡ��������Ĭ��ֵ
	.NumericPage = " {$PageNum} " '���ַ�ҳ����ģ�壬��ѡ��������Ĭ��ֵ
End With

rs = Page.ResultSet() '��¼��
lCount = Page.RowCount() '��ѡ������ܼ�¼��
nav = Page.Nav() '��ҳ��ʽ

Page = Null
Set Page = Nothing

'==============================================================================================================

%>
<br />
    <table width='100%'>
        <tr>
        <td align='left'>�����ڵ�λ�ã�<a href="User_UsernameConfine.asp">�����û�������</a>&gt;&gt;<a href="User_UsernameConfine.asp">&nbsp;���б����û����б�</a></td>
        <td align='right'>���ҵ�  <label class="findUser"><%=lCount%></label> ���û���</td>
        </tr></table>
     <form name='myform' method='Post' action='?page=<%=Request("page") %>'>	
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>
    <tr><td>	  
     <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'>
            <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' title="ѡ�б�ҳ���г�Ա" />
            </td>          
            <td width='120' height='21' align='center'><strong>�û���</strong></td>                 
             <td width='150' height='21' align='left'><strong>�ռ�����</strong></td>
            <td width='70' height='21' align='center'><strong> ����</strong></td>
          </tr>
          <%
		    Dim content,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���κ���Ϣ!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            content = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=content %>' /></td>
            <td width='120'><%=content %></td>           
            <td width='150'><%=rs(1,i)%></td>          
            <td width='70' align='center'>
            <a href="?action=delconfine&username=<%=content %>">ɾ��</a>
            </td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
      

</td></tr></table>


<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>


<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>�û���ѯ:</strong></td>
<td >
<input name='Search' type='text' id="Search"  size='30' maxlength='64' /> 
<input type='submit' name='Submit2' value=' �� ѯ ' class="btn" />
<input type='button' id="btn_add" value=' �� �� ' class="btn" onclick="confine('add');" />
<input type='button' id="btn_del" value=' ����ɾ�� ' class="btn" onclick="confine('del');" title="��ѡ����Ҫɾ���ı����û���" />
 <input id="in_optype" type="hidden" />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>
<%
End sub
%>

<div>
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>

</body>
</html>

