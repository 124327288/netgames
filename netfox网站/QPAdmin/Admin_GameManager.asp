<!--#include file="CommonFun.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Conn.asp"-->
<!--#include file="Cls_Page.asp"-->
<!--#include file="md5.asp"-->
<% 
Dim startime,endtime
startime=timer()

If InStr(Session("AdminSet"), ",6,")<=0  Then
call  RLWriteSuccessMsg("������", "û�й���Ȩ��!")
Response.End
End If

If InStr(Session("AdminSet"), ",1,")<=0  Then
call  RLWriteSuccessMsg("������", "û���û�����Ȩ��!")
Response.End
End If
 %>

<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
<link href='Admin_Style.css' rel='stylesheet' type='text/css'>
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<form name='form1' action='' method='get'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>�����û�����</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'>
        <%
            Dim pageUrl,rs
            pageUrl="?swhat=2&search="
            Call ConnectGame("QPServerInfoDB")
            sql="select KindID,KindName from  GameKindItem(nolock) Where Nullity=0 Order by KindID "
            
            Set rs=GameConn.Execute(sql)
          
            Do While Not rs.Eof  
                Response.Write("<a href='")
                Response.Write(pageUrl)
                Response.Write(rs("KindID"))
                Response.Write("'  style='margin-right:10px;'>")
                Response.Write(rs("KindName"))
                Response.Write("</a>")             
            rs.MoveNext
	        Loop 
            rs.close
            set rs=nothing  
            CloseGame()
         %> 
         <br />
         <a href="Admin_GameManager.asp" style=" text-decoration:underline;">ȫ�������û�</a>
      </td>
</tr>
</form>
</table> 

<%
Call ConnectGame("QPTreasureDB")

Select case lcase(request("action"))
    case "del"
        call del(trim(request("typeID")))
        call main()
    Case else
    Call main()
End Select

Call CloseGame()

'===============================================================================
Sub del(lID)
Dim ID, ClubName
ID = lID
    If InStr(Session("AdminSet"), ",3,")>0 Then
        GameConn.execute  "delete from GameScoreLocker where UserID in ("&ID&")"      
    Else
        call  RLWriteSuccessMsg("������", "��û�п��������Ȩ��!")
        Response.End      
    End If
End Sub

'��¼��ѯ
Sub main()

%>
<script type="text/javascript">
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
</script>

<%
'====================================================================================
'��ѯ����
Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr
Dim enterTime1

OrderStr=" CollectDate desc"

IF Request("search")>"" Then
    Select case Request("swhat")
        Case "1"
            queryCondition=" UserID in (select userid from QPGameUserDBLink.QPGameUserDB.dbo.AccountsInfo where accounts='"&sqlcheckStr(Request("search"))& "')"
        Case "2"
            queryCondition=" KindID="&SqlCheckNum(Request("search"))
        Case "3"
            queryCondition=" ServerID="&SqlCheckNum(Request("search"))
        Case "4"
            IF IsDate(SqlCheckStr(Request("search"))) Then
                enterTime1=CDate(SqlCheckStr(Request("search")))
                queryCondition=" CollectDate>='"&enterTime1&"' AND CollectDate<'"&DateAdd("d",1,enterTime1)&"'"
            End IF
        Case "5"
            queryCondition=" UserID="&SqlCheckNum(Request("search"))    
    End Select
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
	.Pkey="UserID"						'����
	.Field="UserID,KindID,ServerID,CollectDate"	'�ֶ�
	.Table="GameScoreLocker"				'����
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
    <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUserMoney.asp">��ҹ���</a>&gt;&gt;<a href="Admin_GameManager.asp">&nbsp;���߹���</a>
             <% IF lcase(request("action"))="del" Then %> 
               <span class="hit">�����û��Ѵ���</span> 
              <% END IF %> 
    </td>
    <td align='right'>���ҵ� <span style="color:Red;"><%=lCount %></span> ����¼</td>
</tr>
</table>
<form name='myform' method='post' action=''>	
<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<tr>
<td><table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'>   
            <td width='38' align='center'><strong>ѡ��</strong></td>           
            <td width='100' height='21' align='center'><strong>�û�</strong></td>          
            <td width='138' align='center'><strong>��Ϸ</strong></td>
            <td width='38' align='center'><strong>����</strong></td>
            <td width='200' align='center'><strong>����ʱ��</strong></td>    
            <td width="38" align="center"><strong>����</strong></td>
          </tr>
          <%          
          Dim UserID,index,GameName
             IF IsNull(rs) Then
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���ҵ������Ϣ!<br><br></td></tr>") 
             Else
            index=1
            
            For i=0 To Ubound(rs,2)
                UserID = Rs(0,i) 
                GameName=GetKindNameByKindID(Rs(1,i))
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=UserID%>' /></td>
            <td width='100'><a title="�鿴�û�����" href="Admin_GameUser.asp?action=userinfo&id=<%=UserID%>"><%=GetAccountsByUserID(UserID) %></a></td>
            <td width='138' align='center'><label title="KindID�� <%=Rs(1,i) %>"><%=GameName%></label></td>
	        <td width='38' align='center'><%=Rs(2,i)%></td>
	        <td width='200' align='center'><%=Rs(3,i)%></td>
	        <td width='60'  align='center'><a href="?action=del&typeID=<%=UserID %>&page=<%=request("page") %>">���û�����</a></td>
          </tr>
          <%
          index=index+1
          Next
          End IF
          %>
        </table>
        
         <table width='100%' border='0' cellpadding='0' cellspacing='0' style=" margin-top:4px;">
        <tr> 
            <td width='191' height='23'> 
              <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' />ѡ�б�ҳ���г�Ա</td>
            <td width="574">
            <div align="left"><strong>������ </strong>
                <%IF InStr(Session("AdminSet"), ",6,")>0 Then%>
               <input name="action"  type="hidden" value="del" />
                <input type='submit' name='Submit' value=" �����������û� "/>
				<% End If %>		
                </div>
         </td></tr></table>
</td>
</tr></table>
</form>
<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr></table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  
<tr class='tdbg'>    
<td width='120' align="right"><strong>�û���ѯ:</strong></td>
<td align="left">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 
<input name='search' type='text' id="search"  size='20' maxlength='30' />
  <select name="swhat" id="swhat">
    <option value="1" selected="selected">���û���</option>
    <option value="2">��KindID</option>
    <option value="3">������</option>
    <option value="4">������ʱ��(��)</option>  
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
<span class="ml">��Ϊ�գ����ѯ�����û�</span>
</td>
</tr></table></form>
<%
End Sub
%>

<div>
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>


</body>
</html>
