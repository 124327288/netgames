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
'函数名：gotTopic
'作  用：截字符串，汉字一个算两个字符，英文算一个字符
'参  数：str   ----原字符串
'       strlen ----截取长度
'返回值：截取后的字符串
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
		strTemp=strTemp & "…"
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
'函数名：IsObjInstalled
'作  用：检查组件是否已经安装
'参  数：strClassString ----组件名
'返回值：True  ----已经安装
'       False ----没有安装
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
'函数名：SendMail
'作  用：用Jmail组件发送邮件
'参  数：MailtoAddress  ----收信人地址
'MailtoName    -----收信人姓名
'Subject       -----主题
'MailBody      -----信件内容
'FromName      -----发信人姓名
'MailFrom      -----发信人地址
'Priority      -----信件优先级
'返回值：错误信息
'**************************************************
function SendMail(MailtoAddress,MailtoName,Subject,MailBody,FromName,MailFrom,Priority)
	on error resume next
	Dim JMail
	Set JMail=Server.CreateObject("JMail.Message")
	if err then
		SendMail= "<br><li>没有安装JMail组件</li>"
		err.clear
		exit function
	end if
	JMail.Charset="gb2312"  '邮件编码
	JMail.silent=true
	JMail.ContentType = "text/html"     '邮件正文格式
	'JMail.ServerAddress=MailServer     '用来发送邮件的SMTP服务器
   	'如果服务器需要SMTP身份验证则还需指定以下参数
	JMail.MailServerUserName = MailServerUserName    '登录用户名
   	JMail.MailServerPassWord = MailServerPassword'登录密码
  	JMail.MailDomain = MailDomain       '域名（如果用“name@domain.com”这样的用户名登录时，请指明domain.com
	JMail.AddRecipient MailtoAddress,MailtoName     '收信人
	JMail.Subject=Subject '主题
	JMail.HMTLBody=MailBody       '邮件正文（HTML格式）
	JMail.Body=MailBody  '邮件正文（纯文本格式）
	JMail.FromName=FromName '发信人姓名
	JMail.From = MailFrom '发信人Email
	JMail.Priority=Priority      '邮件等级，1为加急，3为普通，5为低级
	JMail.Send(MailServer)
	SendMail =JMail.ErrorMessage
	JMail.Close
	Set JMail=nothing
	SendMail=""
end function


sub WriteErrMsg(errmsg)
	dim strErr
	strErr=strErr & "<html><head><title>错误信息</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
	strErr=strErr & "<link href='" & strInstallDir & "Admin_Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbcrlf
	strErr=strErr & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbcrlf
	strErr=strErr & "  <tr align='center' class='title'><td height='22'><strong>错误信息</strong></td></tr>" & vbcrlf
	strErr=strErr & "  <tr class='tdbg'><td height='100' valign='top'><b>产生错误的可能原因：</b>" & errmsg &"</td></tr>" & vbcrlf
	strErr=strErr & "  <tr align='center' class='tdbg'><td>"
	if ComeUrl<>"" then
		strErr=strErr & "<a href='javascript:history.go(-1)'>&lt;&lt; 返回上一页</a>"
	else
		strErr=strErr & "<a href='javascript:window.close();'>【关闭】</a>"
	end if
	strErr=strErr & "</td></tr>" & vbcrlf
	strErr=strErr & "</table>" & vbcrlf
	strErr=strErr & "</body></html>" & vbcrlf
	response.write strErr
end sub

sub WriteSuccessMsg(SuccessMsg)
	dim strSuccess
	strSuccess=strSuccess & "<html><head><title>成功信息</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
	strSuccess=strSuccess & "<link href='" & strInstallDir & "Admin_Style.css' rel='stylesheet' type='text/css'></head><body><br><br>" & vbcrlf
	strSuccess=strSuccess & "<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>" & vbcrlf
	strSuccess=strSuccess & "  <tr align='center' class='title'><td height='22'><strong>恭喜你！</strong></td></tr>" & vbcrlf
	strSuccess=strSuccess & "  <tr class='tdbg'><td height='100' valign='top'><br>" & SuccessMsg &"</td></tr>" & vbcrlf
	strSuccess=strSuccess & "  <tr align='center' class='tdbg'><td>"
	if ComeUrl<>"" then
		strSuccess=strSuccess & "<a href='" & ComeUrl & "'>&lt;&lt; 返回上一页</a>"
	else
		strSuccess=strSuccess & "<a href='javascript:window.close();'>【关闭】</a>"
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
		strTemp=strTemp & "共 <b>" & totalnumber & "</b> " & strUnit & "&nbsp;&nbsp;"
	end if
	strUrl=JoinChar(sfilename)
  	if CurrentPage<2 then
    	strTemp=strTemp & "首页 上一页&nbsp;"
  	else
    	strTemp=strTemp & "<a href='" & strUrl & "page=1'>首页</a>&nbsp;"
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & (CurrentPage-1) & "'>上一页</a>&nbsp;"
  	end if

  	if CurrentPage>=TotalPage then
    	strTemp=strTemp & "下一页 尾页"
  	else
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & (CurrentPage+1) & "'>下一页</a>&nbsp;"
    	strTemp=strTemp & "<a href='" & strUrl & "page=" & TotalPage & "'>尾页</a>"
  	end if
   	strTemp=strTemp & "&nbsp;页次：<strong><font color=red>" & CurrentPage & "</font>/" & TotalPage & "</strong>页 "
    strTemp=strTemp & "&nbsp;<b>" & maxperpage & "</b>" & strUnit & "/页"
	if ShowAllPages=True then
		strTemp=strTemp & "&nbsp;&nbsp;转到第<input type='text' name='page' size='3' maxlength='5' value='" & CurrentPage & "' onKeyPress=""if (event.keyCode==13) window.location='" & strUrl & "page=" & "'+this.value;""'>页"
		'strTemp=strTemp & "&nbsp;转到：<select name='page' size='1' onchange=""javascript:window.location='" & strUrl & "page=" & "'+this.options[this.selectedIndex].value;"">"
    	'for i = 1 to TotalPage  
    	'	strTemp=strTemp & "<option value='" & i & "'"
		'	if cint(CurrentPage)=cint(i) then strTemp=strTemp & " selected "
		'	strTemp=strTemp & ">第" & i & "页</option>"   
	    'next
		'strTemp=strTemp & "</select>"
	end if
	strTemp=strTemp & "</td></tr></table>"
	ShowPage=strTemp
end function

'**************************************************
'函数名：IsValidEmail
'作  用：检查Email地址合法性
'参  数：email ----要检查的Email地址
'返回值：True  ----Email地址合法
'       False ----Email地址不合法
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