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
<meta http-equiv='Content-Type' content='text/html; charset=gb2312' />
<link href='Admin_Style.css' rel='stylesheet' type='text/css' />
<!--#include file="inc/links.asp"-->
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<form name='form1' action='' method='get'>
<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
<tr class='topbg'> 
      <td height='22' colspan='2' align='center'><strong>��Ϸ�û�����</strong></td>
</tr>
<tr class='tdbg'> 
      <td width='100' height='30'><strong>���ٲ��ң�</strong></td>
      <td width='687' height='30'>&nbsp;&nbsp; <a href="Admin_GameUser.asp">�����û��б�</a> |&nbsp;&nbsp;<a href='Admin_GameUser.asp'>�½��û�</a>&nbsp;| <a href="Admin_GameUser.asp?usertype=1">��Ա�û�</a> | <a href="Admin_GameUser.asp?usertype=2">������Ա</a> | <a href="?usertype=6">�ƹ���Ա</a>| <a href="Admin_GameUser.asp?usertype=3">��������</a>| <a href="Admin_GameUser.asp?usertype=5" ><span style=" color:Red; text-decoration:line-through; font-weight:bold;">ͣȨ�û�</span></a> | <a href="Admin_GameUserMoney.asp?usertype=4">�������</a> | <a href="?usertype=7"><span style="color:#ad0000; font-weight:bold;">��������</span></a></td>
</tr>
</table>
</form>
<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border' style="margin-top:4px;">
<tr class='tdbg'>    
<td width='100'><strong>�û���ѯ:</strong></td>
<td width='687'>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Text1"  size='20' maxlength='30'>
  <select name="swhat">
    <option value="1" selected="selected">���û���</option>   
    <option value="5">����ϷID</option>
    <option value="3">��ע��IP</option>
    <option value="4">����½IP</option>    
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>
<%
Call ConnectGame("QPGameUserDB")
Select case lcase(request("action"))
    case "add"
    call add()
    case "modifyl"
    case "del"
    call del(cint(trim(request("id"))))
    call main()
    case "savemodifyl"
    case "saveadd"
    call saveadd()
    case "userinfo"
    call userinfo()
    case "saveuserinfo"
    call saveuserinfo()
    call main()
    case "update"
    call UpdateUser()
    case "doupdate"
    call doupdate()
    case else
    call main()
End Select
Call CloseGame()

Sub saveuserinfo()
Dim UserRight, UserRightArr, MasterRight, MasterRightArr,fname
fname="myform"  '������
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from AccountsInfo where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3

' �û���
If InStr(Session("AdminSet"), ",2,")>0 Then
    rs("Accounts") = Left(Trim(GetInfo(0,fname,"in_Accounts")),31)
    
    IF Trim(request("in_password1"))<>"" Then
        rs("LogonPass") = md5(Trim(request("in_password1")),32)
    End IF
    
    IF Trim(request("in_password2"))<>"" then
        rs("InsurePass") = md5(Trim(request("in_password2")),32)
    End IF
End If

'�ʺŰ�ȫ
rs("Gender") = GetInfo(1,fname,"in_Gender")
rs("Nullity") = SqlCheckNum(Request("in_Nullity"))
rs("StunDown")=SqlCheckNum(Request("in_StunDown"))
rs("MoorMachine")= CLng(SqlCheckNum(Request("in_MoorMachine")))
rs("MachineSerial")= Left(GetInfo(0,fname,"in_MachineSerial"),32)

'Ȩ�޷���
IF InStr(Session("AdminSet"), ",8,")>0 Then
    UserRightArr = Split(SqlCheckStr(Request("in_UserRight")), ",")
    UserRight = 0
    For RL_i=0 To Ubound(UserRightArr)
    UserRight = UserRight Or SqlCheckNum(UserRightArr(RL_i))
    Next
    rs("UserRight") = UserRight
    MasterRightArr = Split(SqlCheckStr(Request("in_MasterRight")), ",")
    MasterRight = 0
    For RL_i=0 To Ubound(MasterRightArr)
    MasterRight = MasterRight Or SqlCheckNum(MasterRightArr(RL_i))
    Next
    rs("MasterRight") = MasterRight
    rs("MasterOrder")= CLng(GetInfo(1,fname,"in_MasterOrder"))
End IF

'���Ի�����
If IsNumeric(Request("in_FaceID")) And Request("in_FaceID")<>"" Then
    rs("FaceID") = CLng(Request("in_FaceID"))
Else
    rs("FaceID") = 0
End If
If FaceID>247 Then
    rs("FaceID") = 0
End If
rs("UnderWrite") = Left(GetInfo(0,fname,"in_UnderWrite"),63)

'��Ա����
rs("MemberOrder") = SqlCheckNum(Request("in_MemberOrder"))
rs("MemberOverDate") = CDate(LTrim(RTrim(SqlCheckStr(Request("in_MemberOverDate")))))
rs("Experience") = SqlCheckNum(Request("in_Experience"))

'��¼��־
rs("WebLogonTimes") = GetInfo(0,fname,"in_WebLogonTimes")
rs("GameLogonTimes") = GetInfo(0,fname,"in_GameLogonTimes")
rs("RegisterDate") = SqlCheckStr(Request("in_RegisterDate"))
rs("LastLogonDate") = SqlCheckStr(Request("in_LastLogonDate"))
rs("RegisterIP") = SqlCheckStr(Request("in_RegisterIP"))
rs("LastLogonIP") = SqlCheckStr(Request("in_LastLogonIP"))
rs.update

Response.Redirect("?page="&Request("page"))
End Sub

Sub del(lID)
Dim ID, ClubName
ID = lID
    If InStr(Session("AdminSet"), ",3,")>0 Then
        GameConn.execute  "delete from AccountsInfo where UserID="&ID       
    Else
        call  RLWriteSuccessMsg("������", "��û��ɾ���û���Ȩ��!")
        Response.End      
    End If
End Sub

Sub main()
Dim typeIDArray, lLoop
typeIDArray = Split(Request("typeID"), ",")
For lLoop = 0 To Ubound(typeIDArray)
	Select Case Request("Action")
		Case "Delselect"
			Call del(SqlCheckNum(typeIDArray(lLoop)))
		Case "normal"
			GameConn.Execute("update AccountsInfo set Nullity=0 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
		Case "suoding"
			GameConn.Execute("update AccountsInfo set Nullity=1 where UserID="&SqlCheckNum(typeIDArray(lLoop))&"")
	End Select
Next
%>
<script type="text/javascript" src="inc/ajaxrequest.js"></script>
<script type="text/javascript">
var ajax=new AJAXRequest();
var disp_ip;

function ShowIP(ip_lable,ip) {
    disp_ip=document.getElementById(ip_lable);
    ajax.get("Ajax_IPAddress.asp?ipaddr="+ip,ShowIPCallback);
}

function ShowIPCallback(obj) {        
    disp_ip.innerText=obj.responseText;
    disp_ip.title=disp_ip.title+"\n"+obj.responseText;
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
</script>
<%

Dim rs,nav,Page,i
Dim lCount, queryCondition, OrderStr

OrderStr="UserID desc"
'��ѯ����
IF request("search")>"" Then
    Select case Request("swhat")
	    Case "1"
		    queryCondition = " Accounts='"&sqlcheckStr(request("search"))& "'"	
	    Case "3"
		    queryCondition = " RegisterIP='"&sqlcheckStr(request("search"))& "'"
	    Case "4"
		    queryCondition = " LastLogonIP='"&sqlcheckStr(request("search"))& "'"
        Case "5"
		    queryCondition = " gameid='"&SqlCheckNum(request("search"))& "'"
	     Case "6"
		    queryCondition = " SpreaderID='"&sqlcheckStr(request("search"))& "'"
        Case "7"
		    queryCondition = " UserID='"&sqlcheckStr(request("search"))& "'"	
    End Select
End IF

If request("usertype")<>"" Then
    Select case request("usertype")
	    case "1"	
	        queryCondition =" MemberOrder>0 "	  
		    OrderStr=" MemberOrder desc"
	    case "2"
		    queryCondition=" MasterOrder>0"
	    case "3"
		    OrderStr=" Experience DESC"
	    case "4"
		    OrderStr=" GameLogonTimes DESC"
        case "5"
		    queryCondition=" nullity=1 "
	    case "6"
		    queryCondition=" UserID IN (select SpreaderID from AccountsInfo(nolock)) "	
		Rem ��������
		case "7"
		    OrderStr=" Loveliness DESC"
    End Select
End If

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
	.Field="UserID,GameID,Accounts,Gender,Nullity,FaceID,MemberOrder,MemberOverDate,RegisterDate,RegisterIP,Experience,MasterOrder,Loveliness"	'�ֶ�
	.Table="AccountsInfo"				'����
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
        <td align='left'>�����ڵ�λ�ã�<a href="Admin_GameUser.asp">�û�����</a>&gt;&gt;&nbsp;<a href="Admin_GameUser.asp">���г�Ա�б�</a>
                    <% IF Trim(Request("action")="normal")  THEN %>
                        <span class="hit">����ȡ��ͣȨ�û���ɣ� </span>
                   <% 
                    END IF 
                    IF Trim(Request("action")="suoding")  THEN %> 
                     <span class="hit">����ͣȨ�û���ɣ� </span> 
                   <% 
                  END IF 
                   IF Trim(Request("action")="Delselect")  THEN %>
                     <span class="hit">����ɾ���û���ɣ�  </span> 
                  <% END IF %> 
        </td>
        <td align='right'>���ҵ� <font color=red><%=lCount%></font> ���û�</td>
        </tr></table>
    <table width='100%' border='0' cellpadding='0' cellspacing='0'>  <tr>  <form name='myform' method='Post' action='?command=edit' onsubmit="return confirm('ȷ��Ҫִ��ѡ���Ĳ�����');">	  <td>	  <table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' class='border'>
          <tr class='title'> 
            <td width='38' align='center'><strong>ѡ��</strong></td>
            <td width='33' align='center'><strong>ID</strong></td>
            <td width='85' height='21' align='center'><strong>�û���</strong></td>
            <td width='50' align='center'><strong>�Ա�</strong></td>
            <td width='80' align='center'><strong>�û�״̬</strong></td>
            <% If Request("usertype")="3" Then %>
                <td width='60' align='center'><strong>�û�����</strong></td>
            <% End If %> 
            <% If Request("usertype")="7" Then %>
                <td width='60' align='center'><strong>����ֵ</strong></td>
            <% End If %> 
            <td width='60' align='center'><strong>ͷ ��</strong></td>
            
             <% If Request("usertype")="2" Then %>
                <td width='60' align='center'><strong>������</strong></td>
             <% Else %> 
                <td width='60' align='center'><strong>��Ա����</strong></td>
             <% End If %>
            <td width='138' align='center'><strong>��Ա��������</strong></td>
            <td width='138' align='center'><strong>ע������</strong></td>
            <td width='138' align='center'><strong>ע���ַ</strong></td>
            <td width='70' height='21' align='center'><strong> ����</strong></td>
          </tr>
          <%
		    Dim UserID,index
            IF IsNull(rs) Then 
                Response.Write("<tr class='tdbg'><td colspan='20' align='center'><br>û���κ���Ϣ!<br><br></td></tr>")
            Else
            index=1
            
            For i=0 To Ubound(rs,2)
            UserID = Rs(0,i)
          %>
          <tr class='tdbg' onmouseout="this.style.backgroundColor=''" onmouseover="this.style.backgroundColor='#BFDFFF'"> 
            <td width='38' height="24" align='center'> <input name='typeID' type='checkbox' onclick="unselectall()" value='<%=UserID%>'></td>
            <td width='33' align='center'><%=rs(1,i)%></td>
            <td width='85'><a href='?action=userinfo&id=<%=UserID%>' title="�û���<%=rs(2,i)%> ����ֵ��<%=rs(10,i) %>">
                <% IF rs(6,i)=0 Then%>
                    <%=rs(2,i)%>          
                <% ELSEIF rs(6,i)=1 THEN %>  
                <span style="color:#ff0000;font-weight:bold;"><%=rs(2,i)%></span> 
                <% ELSEIF rs(6,i)=2 THEN %>  
                <span style="color:#105399;font-weight:bold;"><%=rs(2,i)%></span>   
                <% ELSEIF rs(6,i)=3 THEN %>  
                    <span style="color:#cd6a00; font-weight:bold;"><%=rs(2,i)%></span> 
                <% ELSEIF rs(6,i)=4 THEN %>  
                    <span style="color:#ad0000; font-weight:bold;"><%=rs(2,i)%></span> 
               <% END IF %> 
            </a> 
            </td>
            <td width='50' align='center'>
			<% If rs(3,i)=0 Then %>
			����
			<% Elseif rs(3,i)=1 Then%>
			��		
			<% Else %>
			Ů
			<% End If %>
			</td>
            <td width='80' align='center'><% If rs(4,i)=True Then %><span style="color:Red; text-decoration:line-through; font-weight:bold;">��ֹ</span><% Else %><span style="color:green;">����</span><% End If %></td>
            
             <% If Request("usertype")="3" Then %>
                <td width='60' align='center'><%=rs(10,i) %></td>
            <% End If %> 
            
             <% If Request("usertype")="7" Then %>
                <td width='60' align='center'><%=rs(12,i) %></td>
            <% End If %> 
            
            <td width='60' align='center'><img width="25" height="25" src="gamepic/face<%=Rs(5,i) %>.gif" alt="" /></td>
            
             <% If Request("usertype")="2" Then %>
                <td width='60' align='center'>
                    <% IF rs(11,i)=0 Then%>
                        ��ͨ��Ա             
                    <% ELSEIF rs(11,i)=1 THEN %>  
                    <span style="color:#105399;font-weight:bold;">�ڲ�����</span> 
                    <% ELSEIF rs(11,i)=2 THEN %>  
                    <span style="color:#cd6a00;font-weight:bold;">�ⲿ����</span> 
                   <% END IF %> 
                </td>
            <% Else %> 
                <td width='60' align='center'>
                    <% IF rs(6,i)=0 Then%>
                        ��ͨ��Ա             
                    <% ELSEIF rs(6,i)=1 THEN %>  
                    <span style="color:#ff0000;font-weight:bold;">����</span> 
                    <% ELSEIF rs(6,i)=2 THEN %>  
                    <span style="color:#105399;font-weight:bold;">����</span>   
                    <% ELSEIF rs(6,i)=3 THEN %>  
                        <span style="color:#cd6a00; font-weight:bold;">����</span>
                   <% ELSEIF rs(6,i)=4 THEN %>  
                        <span style="color:#ad0000; font-weight:bold;">����</span>  
                   <% END IF %> 
                </td>
            <% End If %>
            <td width='138' align='center'><%=rs(7,i)%></td>
            <td width='138' align='center'><%=rs(8,i)%></td>            
			<td width='138'><span id="disp_ip_<%=index %>" class="ipblock" title="<%=rs(9,i) %>">���ڲ�ѯIP...</span><script type="text/javascript">setTimeout("ShowIP('disp_ip_<%=index %>', '<%=rs(9,i) %>')",800*<%=index %>);</script></td>
            <td width='70' align='center'><a href='?action=userinfo&id=<%=UserID%>&page=<%=Request("page") %>'>��ϸ��Ϣ</a></td>
          </tr>
          <%
            index=index+1
           Next
           End IF           
        %>
        </table>
		
        <table width='100%' border='0' cellpadding='0' cellspacing='0' style="margin-top:4px;">
        <tr> 
            <td width='191' height='23'> 
              <input name='chkAll' type='checkbox' id='chkAll2' onclick='CheckAll(this.form)' value='checkbox' />ѡ�б�ҳ���г�Ա</td>
            <td width="574">
            <div align="left"><strong>������ </strong>
                <%IF InStr(Session("AdminSet"), ",6,")>0 Then%>
                <input name='Action' type='radio' value='Delselect' />ɾ����Ա
				<% End If %>
				<input name='Action' type='radio' value='normal' checked="checked" />ȡ��ͣȨ
				<input name='Action' type='radio' value='suoding' />ͣȨ�û�				
                <input type='submit' name='Submit' value=' ִ �� '/>
                </div>
         </td></tr></table>

</td>
</form>  
</tr></table>

<table align='center' width="100%"><tr>
<td class="page" align="right"><%Response.Write nav%></td>
</tr>
</table>

<form name='search_request' method='get' action=''>
<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>  <tr class='tdbg'>    
<td width='120'><strong>�û���ѯ:</strong></td>
<td width='350'>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input name='Search' type='text' id="Search"  size='20' maxlength='30'>
  <select name="swhat">
    <option value="1" selected="selected">���û���</option>   
    <option value="5">����ϷID</option>
    <option value="3">��ע��IP</option>
    <option value="4">����½IP</option>    
  </select> 
<input type='submit' name='Submit2' value=' �� ѯ ' />
</td>
<td>��Ϊ�գ����ѯ�����û�</td>
</tr></table>
</form>
<%
End sub

Rem �û�����
Sub userinfo()
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  AccountsInfo(nolock)  where UserID="&SqlCheckNum(request("id"))
rs.Open sql,GameConn,1,3
%>
<script type="text/javascript">
     function GetDate(days){
        var objDate = new Date(new Date()-0+days*86400000); 
        var year=objDate.getFullYear();
        var month=objDate.getMonth()+1;
        var date=objDate.getDate();
        var day=objDate.getDay();
        
        return ""+year+"-"+month+"-"+(day);
    }
    function OnMemberOrderChange(mOrder) {
       // alert(memberOrder);       
       // alert(mOrder);      
        var days=document.getElementById("in_MemberOverDate");
        switch (mOrder){
            case 1:
                days.value=GetDate(30);
                break;
            case 2:
            days.value=GetDate(30);
            break;
            case 3:
            days.value=GetDate(60);
            break;
            case 4:
            days.value=GetDate(90);
            break;
            case 0:
            default:
            days.value="1982-01-01";
            break;
        }
        
        //alert(days.value);
    }
</script>
<form name='myform' action='?action=saveuserinfo&id=<%=request("id") %>&page=<%=Request("page") %>' method='post'>
  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>
    <tr> 
      <td colspan="2" class='title'>�޸��û���Ϣ</td>
    </tr>
	<tr class='tdbg'>
      <td class="txtrem">��ϷID��</td>
      <td> <%= rs("GameID") %>
        <span class="username mr">ԭ�û�����<%=rs("RegAccounts") %></span> 
        <a class="ml detiallink" href="Admin_GameUserMoney.asp?action=userinfo&id=<%=rs("UserID") %>">�鿴�û����</a>
        <a class="ml detiallink" href="Admin_RecordUserEnter.asp?swhat=5&search=<%=rs("UserID") %>">�鿴�û����뷿���¼</a>
        <a class="ml detiallink" href="Admin_RecordUserLeave.asp?swhat=5&search=<%=rs("UserID") %>">�鿴�û��˳������¼</a>
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">�û�����</td>
      <td>
      <input name='in_Accounts' id="in_Accounts" type='text' value="<%=rs("Accounts") %>"  size='30' maxlength='31' />     
      </td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">��¼���룺</td>
      <td><input name='in_password1' id="in_password1"  type='text' size='30' maxlength='30' /> ���ղ��޸�</td>
    </tr>
    <tr class='tdbg'> 
      <td class="txtrem">�������룺</td>
      <td><input name='in_password2' id="in_password2"  type='text' size='30' maxlength='30' class="input" /> ���ղ��޸�</td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">�Ա�</td>
      <td>
           <input name="in_Gender" type="radio" value="0"<% If rs("Gender")=0 Then %> checked<% End If %> />����
           <input name="in_Gender" type="radio" value="1"<% If rs("Gender")=1 Then %> checked<% End If %> /><img src="Images/boy.gif" alt="����" />GG
          <input name="in_Gender" type="radio" value="2"<% If rs("Gender")=2 Then %> checked<% End If %> /><img src="Images/girl.gif" alt="Ů��" />MM 
       </td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">���뱣����</td>
        <td></td>
    </tr>
	<tr class='tdbg2'> 
      <td class="txtrem">��ֹ����</td>
      <td>
          <input name="in_Nullity" type="radio" value="0"<% If rs("Nullity")=0 Then %> checked<% End If %> />����
          <input name="in_Nullity" type="radio" value="1"<% If rs("Nullity")=True Then %> checked<% End If %> />����
      </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">�ʺŰ�ȫ�رգ�</td>
        <td>
            <input name="in_StunDown" type="radio" value="0"<% If rs("StunDown")=0 Then %> checked<% End If %> />����
            <input name="in_StunDown" type="radio"  value="1"<% If rs("StunDown")=True Then %> checked<% End If %> />��ȫ�ر�
        </td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">�̶�������</td>
        <td>
            <input name="in_MoorMachine" type="radio"  value="0"<% If rs("MoorMachine")=0 Then %> checked<% End If %> />δ����
            <input name="in_MoorMachine" type="radio"  value="1"<% If rs("MoorMachine")=1 Then %> checked<% End If %> /><span class="green">ʹ����</span>
            <input name="in_MoorMachine" type="radio"  value="2"<% If rs("MoorMachine")=2 Then %> checked<% End If %> />���ȴ���ҽ���ͻ���
        </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">�����룺</td>
        <td><input name="in_MachineSerial" type="text"  value="<%=Trim(rs("MachineSerial")) %>" maxlength="32" size='36' class="input" /></td>
    </tr>
    <tr class="tdbg2">
    <td colspan="2" style="height:30px;"></td>
    </tr> 
    <tr class='tdbg'> 
      <td class="txtrem">�û��ȼ�(���ͻ�Ա)��</td>
     <td> 
    	<input name="in_MemberOrder" id="in_MemberOrder0" type="radio" value="0"<% If rs("MemberOrder")=0 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(0);" /><label for="in_MemberOrder0">��ͨ��Ա</label>
        <input name="in_MemberOrder" id="in_MemberOrder1"type="radio" value="1"<% If rs("MemberOrder")=1 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(1);"/> <label for="in_MemberOrder1" style="color:#ff0000;font-weight:bold;">����</label>
        <input name="in_MemberOrder" id="in_MemberOrder2"type="radio" value="2"<% If rs("MemberOrder")=2 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(2);"/> <label for="in_MemberOrder2" style="color:#105399;font-weight:bold;">����</label>
        <input name="in_MemberOrder" id="in_MemberOrder3"type="radio" value="3"<% If rs("MemberOrder")=3 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(3);"/><label for="in_MemberOrder3" style="color:#cd6a00; font-weight:bold;">����</label>
        <input name="in_MemberOrder" id="in_MemberOrder4"type="radio" value="4"<% If rs("MemberOrder")=4 Then %> checked="checked"<% End If %> onclick="OnMemberOrderChange(4);"/><label for="in_MemberOrder4" style="color:#ad0000; font-weight:bold;">����</label>
    </td></tr>
    <tr class='tdbg'> 
      <td class="txtrem">��Ա����ʱ�䣺</td>
      <td> 
      <input name='in_MemberOverDate' id="in_MemberOverDate" type='text' value="<%=rs("MemberOverDate") %>"  size='30' maxlength='30' />
        <img src="images/DatePicker/skin/datePicker.gif" alt="����" width="16" height="22" style="cursor:hand;" onClick="new WdatePicker(myform.in_MemberOverDate,null,false,'whyGreen')" />
      </td>
    </tr>   
	<!--#include file="inc/userpower.asp"-->	 
	<tr class='tdbg'> 
      <td class="txtrem">�û�ͷ��</td>
      <td><img width="32" height="32" name="in_FaceID" id="in_FaceID" src="gamepic/face<%= Rs("FaceID") %>.gif" />
			  <select name="in_FaceID" size="1" onChange="document.images.in_FaceID.src='gamepic/face'+this.value+'.gif';" class="input" ID="Select1">
			  <% For RL_i=0 To 247 %>           
			  <option value="<%=RL_i%>">ͷ��<%= RL_i+1 %></option>
              <% Next %>
			  </select>
	  </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">����ǩ����</td>
        <td>
        <textarea name="in_UnderWrite" cols="50" rows="5" class="input"><%=Trim(Rs("UnderWrite")) %></textarea>
        </td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">��Ҿ��飺</td>
      <td> <input name='in_Experience' id="in_Experience" type='text' value="<%= rs("Experience") %>"  size='30' maxlength='30'></td>
    </tr>
    <tr class="tdbg">
        <td class="txtrem">�ƹ�Ա��</td>
        <td>
            <% Dim spreader
                spreader=GetAccountsByUserID(rs("SpreaderID")) 
               IF spreader<>"" Then
                   Response.Write("<a class='detiallink' href='?swhat=7&search="&rs("SpreaderID")&"'>"&spreader&"</a>") 
               End IF   
            %>
        </td>
    </tr>
    <tr class="tdbg2">
        <td class="txtrem">�ƹ�ҵ����</td>
        <td>
        <% Dim spreadCount
            spreadCount=GetSpreadCount(rs("UserID"))
            IF spreadCount>0 Then
                Response.Write("<span class='green'>"&spreadCount&"</span> �� <a class='detiallink' href='?swhat=6&search="&rs("UserID")&"'>��ϸ���</a>")             
            End IF
        %>        
        </td>
    </tr>
    <tr class="tdbg2">
    <td colspan="2" style="height:30px;"></td>
    </tr>
    <tr class='tdbg2'> 
      <td class="txtrem">��վ��½������</td>
      <td> <input name='in_WebLogonTimes' id="in_WebLogonTimes" type='text' value="<%= rs("WebLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">������½������</td>
      <td> <input name='in_GameLogonTimes' id="in_GameLogonTimes" type='text' value="<%= rs("GameLogonTimes") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">ע��ʱ�䣺</td>
      <td> <input name='in_RegisterDate' id="in_RegisterDate" type='text' value="<%= rs("RegisterDate") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">����½ʱ�䣺</td>
      <td><input name='in_LastLogonDate' id="in_LastLogonDate" type='text' value="<%= rs("LastLogonDate") %>"  size='30' maxlength='30'></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">ע��IP��</td>
      <td> <input name='in_RegisterIP' id="in_RegisterIP" type='text' value="<%= rs("RegisterIP") %>"  size='30' maxlength='30' class="mr"><%= GetCityFromIP(rs("RegisterIP")) %></td>
    </tr>
	<tr class='tdbg'> 
      <td class="txtrem">����½IP��</td>
      <td> <input name='in_LastLogonIP' id="in_LastLogonIP" type='text' value="<%= rs("LastLogonIP") %>"  size='30' maxlength='30' class="mr"><%=GetCityFromIP(rs("LastLogonIP")) %></td>
    </tr>    
    <tr class='tdbg'> 
      <td height='40' colspan='2' align='center'> <input name="Submit2"   type="submit" id='Submit2' class="button_on" value='�����޸Ľ��'> 
      </td>
    </tr>
  </table>
</form>
<%
rs.close
Set rs=nothing
End Sub
%>


<div>
<%endtime=timer()%>��ҳ��ִ��ʱ�䣺<%=FormatNumber((endtime-startime)*1000,3)%>����
</div>

</body>
</html>

