<%
dim UserLogined,UserName,UserLevel,ChargeType,UserPoint,ValidDays,UserReceive,ValidDaysType
dim Action,FoundErr,ErrMsg,ComeUrl
dim strInstallDir,HtmlDir
dim strHTML
dim ObjInstalled_FSO,fso
dim strChannel,sqlChannel,rsChannel,ChannelName,ChannelShortName,ChannelDir,SheetName,ShowChannelName
dim EnableCheck,DefaultAddPurview,DefaultCommentPurview,ModuleType,ModuleName,Template_Index,UseCreateHTML
dim ShowMyStyle,ShowClassTreeGuide,ShowAllClass,DaysOfNew,HitsOfHot,MaxPerLine,DefaultSkinID,TopMenuType,ClassGuideType
ComeUrl=trim(request.ServerVariables("HTTP_REFERER"))
ObjInstalled_FSO=IsObjInstalled(objName_FSO)
if ObjInstalled_FSO=True then
	set fso=Server.CreateObject(objName_FSO)
end if

Action=trim(request("Action"))
FoundErr=False
ErrMsg=""
if right(InstallDir,1)<>"/" then
	strInstallDir=InstallDir & "/"
else
	strInstallDir=InstallDir
end if
'**************************************************
'��������gotTopic
'��  �ã����ַ���������һ���������ַ���Ӣ����һ���ַ�
'��  ����str   ----ԭ�ַ���
'       strlen ----��ȡ����
'����ֵ����ȡ����ַ���
'**************************************************
function gotTopic(ByVal str,ByVal strlen)
	if str="" then
		gotTopic=""
		exit function
	end if
	dim l,t,c, i,strTemp
	str=replace(replace(replace(replace(str,"&nbsp;"," "),"&quot;",chr(34)),"&gt;",">"),"&lt;","<")
	l=len(str)
	t=0
	strTemp=str
	strlen=Clng(strLen)
	for i=1 to l
		c=Abs(Asc(Mid(str,i,1)))
		if c>255 then
			t=t+2
		else
			t=t+1
		end if
		if t>=strlen then
			strTemp=left(str,i)
			exit for
		end if
	next
	if strTemp<>str then
		strTemp=strTemp & "��"
	end if
	gotTopic=replace(replace(replace(replace(strTemp," ","&nbsp;"),chr(34),"&quot;"),">","&gt;"),"<","&lt;")
end function

function JoinChar(ByVal strUrl)
	if strUrl="" then
		JoinChar=""
		exit function
	end if
	if InStr(strUrl,"?")<len(strUrl) then 
		if InStr(strUrl,"?")>1 then
			if InStr(strUrl,"&")<len(strUrl) then 
				JoinChar=strUrl & "&"
			else
				JoinChar=strUrl
			end if
		else
			JoinChar=strUrl & "?"
		end if
	else
		JoinChar=strUrl
	end if
end function

'**************************************************
'��������IsObjInstalled
'��  �ã��������Ƿ��Ѿ���װ
'��  ����strClassString ----�����
'����ֵ��True  ----�Ѿ���װ
'       False ----û�а�װ
'**************************************************
Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function


'**************************************************
'��������SendMail
'��  �ã���Jmail��������ʼ�
'��  ����MailtoAddress  ----�����˵�ַ
'MailtoName    -----����������
'Subject       -----����
'MailBody      -----�ż�����
'FromName      -----����������
'MailFrom      -----�����˵�ַ
'Priority      -----�ż����ȼ�
'����ֵ��������Ϣ
'**************************************************
function SendMail(MailtoAddress,MailtoName,Subject,MailBody,FromName,MailFrom,Priority)
	on error resume next
	Dim JMail
	Set JMail=Server.CreateObject("JMail.Message")
	if err then
		SendMail= "<br><li>û�а�װJMail���</li>"
		err.clear
		exit function
	end if
	JMail.Charset="gb2312"  '�ʼ�����
	JMail.silent=true
	JMail.ContentType = "text/html"     '�ʼ����ĸ�ʽ
	'JMail.ServerAddress=MailServer     '���������ʼ���SMTP������
   	'�����������ҪSMTP�����֤����ָ�����²���
	JMail.MailServerUserName = MailServerUserName    '��¼�û���
   	JMail.MailServerPassWord = MailServerPassword'��¼����
  	JMail.MailDomain = MailDomain       '����������á�name@domain.com���������û�����¼ʱ����ָ��domain.com
	JMail.AddRecipient MailtoAddress,MailtoName     '������
	JMail.Subject=Subject '����
	JMail.HMTLBody=MailBody       '�ʼ����ģ�HTML��ʽ��
	JMail.Body=MailBody  '�ʼ����ģ����ı���ʽ��
	JMail.FromName=FromName '����������
	JMail.From = MailFrom '������Email
	JMail.Priority=Priority      '�ʼ��ȼ���1Ϊ�Ӽ���3Ϊ��ͨ��5Ϊ�ͼ�
	JMail.Send(MailServer)
	SendMail =JMail.ErrorMessage
	JMail.Close
	Set JMail=nothing
	SendMail=""
end function


sub WriteErrMsg(errmsg)
	dim strErr
	strErr=strErr & "<html><head><title>������Ϣ</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
	strErr=strErr & "<link href='" & strInstallDir & "Admin_Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbcrlf
	strErr=strErr & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbcrlf
	strErr=strErr & "  <tr align='center' class='title'><td height='22'><strong>������Ϣ</strong></td></tr>" & vbcrlf
	strErr=strErr & "  <tr class='tdbg'><td height='100' valign='top'><b>��������Ŀ���ԭ��</b>" & errmsg &"</td></tr>" & vbcrlf
	strErr=strErr & "  <tr align='center' class='tdbg'><td>"
	if ComeUrl<>"" then
		strErr=strErr & "<a href='javascript:history.go(-1)'>&lt;&lt; ������һҳ</a>"
	else
		strErr=strErr & "<a href='javascript:window.close();'>���رա�</a>"
	end if
	strErr=strErr & "</td></tr>" & vbcrlf
	strErr=strErr & "</table>" & vbcrlf
	strErr=strErr & "</body></html>" & vbcrlf
	response.write strErr
end sub

sub WriteSuccessMsg(SuccessMsg)
	dim strSuccess
	strSuccess=strSuccess & "<html><head><title>�ɹ���Ϣ</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
	strSuccess=strSuccess & "<link href='" & strInstallDir & "Admin_Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbcrlf
	strSuccess=strSuccess & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbcrlf
	strSuccess=strSuccess & "  <tr align='center' class='title'><td height='22'><strong>��ϲ�㣡</strong></td></tr>" & vbcrlf
	strSuccess=strSuccess & "  <tr class='tdbg'><td height='100' valign='top'><br>" & SuccessMsg &"</td></tr>" & vbcrlf
	strSuccess=strSuccess & "  <tr align='center' class='tdbg'><td>"
	if ComeUrl<>"" then
		strSuccess=strSuccess & "<a href='" & ComeUrl & "'>&lt;&lt; ������һҳ</a>"
	else
		strSuccess=strSuccess & "<a href='javascript:window.close();'>���رա�</a>"
	end if
	strSuccess=strSuccess & "</td></tr>" & vbcrlf
	strSuccess=strSuccess & "</table>" & vbcrlf
	strSuccess=strSuccess & "</body></html>" & vbcrlf
	response.write strSuccess
end sub

function ShowPage(sFileName,TotalNumber,MaxPerPage,ShowTotal,ShowAllPages,strUnit)
	dim TotalPage,strTemp,strUrl,i

	if TotalNumber=0 or MaxPerPage=0 or isNull(MaxPerPage) then
		ShowPage=""
		exit function
	end if
	if totalnumber mod maxperpage=0 then
    	TotalPage= totalnumber \ maxperpage
  	else
    	TotalPage= totalnumber \ maxperpage+1
  	end if
	if CurrentPage>TotalPage then CurrentPage=TotalPage
		
  	strTemp= "<table align='center'><tr><td>"
	if ShowTotal=true then 
		strTemp=strTemp & "�� <b>" & totalnumber & "</b> " & strUnit & "&nbsp;&nbsp;"
	end if
	strUrl=JoinChar(sfilename)
  	if CurrentPage<2 then
    	strTemp=strTemp & "��ҳ ��һҳ&nbsp;"
  	else
    	strTemp=strTemp & "<a href='" & strUrl & "page=1'>��ҳ</a>&nbsp;"
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & (CurrentPage-1) & "'>��һҳ</a>&nbsp;"
  	end if

  	if CurrentPage>=TotalPage then
    	strTemp=strTemp & "��һҳ βҳ"
  	else
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & (CurrentPage+1) & "'>��һҳ</a>&nbsp;"
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & TotalPage & "'>βҳ</a>"
  	end if
   	strTemp=strTemp & "&nbsp;ҳ�Σ�<strong><font color=red>" & CurrentPage & "</font>/" & TotalPage & "</strong>ҳ "
    strTemp=strTemp & "&nbsp;<b>" & maxperpage & "</b>" & strUnit & "/ҳ"
	if ShowAllPages=True then
		strTemp=strTemp & "&nbsp;&nbsp;ת����<input type='text' name='page' size='3' maxlength='5' value='" & CurrentPage & "' onKeyPress=""if (event.keyCode==13) window.location='" & strUrl & "page=" & "'+this.value;""'>ҳ"
		'strTemp=strTemp & "&nbsp;ת����<select name='page' size='1' onchange=""javascript:window.location='" & strUrl & "page=" & "'+this.options[this.selectedIndex].value;"">"
    	'for i = 1 to TotalPage  
    	'	strTemp=strTemp & "<option value='" & i & "'"
		'	if cint(CurrentPage)=cint(i) then strTemp=strTemp & " selected "
		'	strTemp=strTemp & ">��" & i & "ҳ</option>"   
	    'next
		'strTemp=strTemp & "</select>"
	end if
	strTemp=strTemp & "</td></tr></table>"
	ShowPage=strTemp
end function

'**************************************************
'��������IsValidEmail
'��  �ã����Email��ַ�Ϸ���
'��  ����email ----Ҫ����Email��ַ
'����ֵ��True  ----Email��ַ�Ϸ�
'       False ----Email��ַ���Ϸ�
'**************************************************
function IsValidEmail(email)
	dim names, name, i, c
	IsValidEmail = true
	names = Split(email, "@")
	if UBound(names) <> 1 then
	   IsValidEmail = false
	   exit function
	end if
	for each name in names
		if Len(name) <= 0 then
			IsValidEmail = false
    		exit function
		end if
		for i = 1 to Len(name)
		    c = Lcase(Mid(name, i, 1))
			if InStr("abcdefghijklmnopqrstuvwxyz_-.", c) <= 0 and not IsNumeric(c) then
		       IsValidEmail = false
		       exit function
		     end if
	   next
	   if Left(name, 1) = "." or Right(name, 1) = "." then
    	  IsValidEmail = false
	      exit function
	   end if
	next
	if InStr(names(1), ".") <= 0 then
		IsValidEmail = false
	   exit function
	end if
	i = Len(names(1)) - InStrRev(names(1), ".")
	if i <> 2 and i <> 3 then
	   IsValidEmail = false
	   exit function
	end if
	if InStr(email, "..") > 0 then
	   IsValidEmail = false
	end if
end function
%>