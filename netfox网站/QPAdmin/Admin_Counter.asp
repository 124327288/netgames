<!--#include file="conn.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<!--#include file="count/conn_counter.asp"-->
<!--#include file="function.asp"-->
<%

If InStr(Session("AdminSet"), ",4,")<=0 Then
call  WriteErrMsg("û��ϵͳ����Ȩ��!")
Response.End
End If 

const MaxPerPage=20
dim rs,sql
dim strFileName,totalPut,CurrentPage,TotalPages
dim Search,strGuide,TitleRight
dim QDay,QYear,QMonth,QWeek,SYear,SMonth
dim TotalNum,StatItem,Item,ItemNum,Percent,Barwidth,MaxWidth,Assay,Rows,i,DispRow
Set Rs=Server.CreateObject("ADODB.RECORDSET")

Action=Trim(request("Action"))
QDay=Request("QYear")&"-"&Request("QMonth")&"-"&Request("QDay")
QMonth=Request("QYear")&"-"&Request("QMonth")
QYear=Request("QYear")
Select Case Request("Type")
Case 1:
	Action="StatDay"
Case 2:
	Action="StatMonth"
Case 3:
	Action="StatYear"
end Select

strFileName="Admin_Counter.asp?Action=" & Action
if request("page")<>"" then
    currentPage=cint(request("page"))
else
	currentPage=1
end if

Maxwidth=220		'����ͳ�����ı��Ŀ��
TotalNum=0

strHTML=strHTML & "<html>" & vbcrlf
strHTML=strHTML & "<head>" & vbcrlf
strHTML=strHTML & "<title>��վͳ�ƹ���</title>" & vbcrlf
strHTML=strHTML & "<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & vbcrlf
strHTML=strHTML & "<link href='Admin_Style.css' rel='stylesheet' type='text/css'>" & vbcrlf
strHTML=strHTML & "<script>" & vbcrlf
strHTML=strHTML & "function change_type()" & vbcrlf
strHTML=strHTML & "{ " & vbcrlf
strHTML=strHTML & "	select_type=form1.type.options[form1.type.selectedIndex].text;" & vbcrlf
strHTML=strHTML & "	switch(select_type)" & vbcrlf
strHTML=strHTML & "	{ " & vbcrlf
strHTML=strHTML & "		case '�ձ���' :form1.qmonth.disabled=0;form1.qday.disabled=0;break;" & vbcrlf
strHTML=strHTML & "		case '�±���' :form1.qmonth.disabled=0;form1.qday.disabled=1;break;" & vbcrlf
strHTML=strHTML & "		case '�걨��' :form1.qmonth.disabled=1;form1.qday.disabled=1;break;" & vbcrlf
strHTML=strHTML & "	} " & vbcrlf
strHTML=strHTML & "} " & vbcrlf
strHTML=strHTML & "function change_it()" & vbcrlf
strHTML=strHTML & "{ " & vbcrlf
strHTML=strHTML & "	select_type=form1.type.options[form1.type.selectedIndex].text;" & vbcrlf
strHTML=strHTML & "	if (select_type=='�ձ���')" & vbcrlf
strHTML=strHTML & "	{" & vbcrlf
strHTML=strHTML & "		select_item_y=form1.qyear.options[form1.qyear.selectedIndex].text;" & vbcrlf
strHTML=strHTML & "		month29=select_item_y%4;" & vbcrlf
strHTML=strHTML & "		select_item_m=form1.qmonth.options[form1.qmonth.selectedIndex].text;" & vbcrlf
strHTML=strHTML & "		switch(select_item_m)" & vbcrlf
strHTML=strHTML & "		{ " & vbcrlf
strHTML=strHTML & "			case '2' :if (month29==0) {MD(29)}  else {MD(28)};break;" & vbcrlf
strHTML=strHTML & "			case '4' : " & vbcrlf
strHTML=strHTML & "			case '6' : " & vbcrlf
strHTML=strHTML & "			case '9' : " & vbcrlf
strHTML=strHTML & "			case '11' : MD(30);break; " & vbcrlf
strHTML=strHTML & "			default : MD(31);break; " & vbcrlf
strHTML=strHTML & "		}" & vbcrlf
strHTML=strHTML & "	}" & vbcrlf
strHTML=strHTML & "} " & vbcrlf
strHTML=strHTML & "function MD(days)" & vbcrlf
strHTML=strHTML & "{ " & vbcrlf
strHTML=strHTML & "	j=form1.qday.options.length; " & vbcrlf
strHTML=strHTML & "	for(k=0;k<j;k++) form1.qday.options.remove(0); " & vbcrlf
strHTML=strHTML & "	for(i=0;i<days;i++)" & vbcrlf
strHTML=strHTML & "	{ " & vbcrlf
strHTML=strHTML & "		var day=document.createElement('OPTION'); " & vbcrlf
strHTML=strHTML & "		form1.qday.options.add(day); " & vbcrlf
strHTML=strHTML & "		day.innerText=i+1; " & vbcrlf
strHTML=strHTML & "		form1.qday.selectedIndex=0" & vbcrlf
strHTML=strHTML & "	} " & vbcrlf
strHTML=strHTML & "} " & vbcrlf
strHTML=strHTML & "</script>" & vbcrlf
strHTML=strHTML & "</head>" & vbcrlf
strHTML=strHTML & "<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>"
strHTML=strHTML & "<table width='100%' border='0' align='center' cellpadding='2' cellspacing='1' Class='border'>"
strHTML=strHTML & "  <tr class='topbg'>"
strHTML=strHTML & "    <td height='22' colspan=2 align=center><strong>�� վ ͳ �� �� ��</strong></td>"
strHTML=strHTML & "  </tr>"
strHTML=strHTML & "  <tr class='tdbg'> "
strHTML=strHTML & "    <td width='70' height='30'><strong>��������</strong></td>"
strHTML=strHTML & "    <td height='30'>"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=Infolist'>�ۺ�ͳ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FVisitor'>���ʼ�¼</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FCounter'>���ʴ���</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatYear'>�� �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatAllYear'>ȫ �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatMonth'>�� �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatAllMonth'>ȫ �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatWeek'>�� �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatAllWeek'>ȫ �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatDay'>�� �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=StatAllDay'>ȫ �� ��</a>&nbsp;|<br>"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FIp'>IP �� ַ</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FArea'>��������</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FAddress'>��ַ����</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FTimezone'>ʱ������</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FWeburl'>������վ</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FReferer'>����ҳ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FSystem'>����ϵͳ</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FBrowser'>� �� ��</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FMozilla'>�ִ�����</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FScreen'>��Ļ��С</a>&nbsp;|"
strHTML=strHTML & "	<a href='Admin_Counter.asp?Action=FColor'>��Ļɫ��</a>&nbsp;|"
strHTML=strHTML & "	</td>"
strHTML=strHTML & "  </tr>"
strHTML=strHTML & "</table>"
strHTML=strHTML & "<br>"
response.write strHTML

if Action="Infolist" then
	call Infolist()
elseif Action="FVisitor" then
	call FVisitor()
elseif Action="FCounter" then
	call FCounter()
elseif Action="StatYear" then
	call StatYear()
elseif Action="StatAllYear" then
	call StatAllYear()
elseif Action="StatMonth" then
	call StatMonth()
elseif Action="StatAllMonth" then
	call StatAllMonth()
elseif Action="StatWeek" then
	call StatWeek()
elseif Action="StatAllWeek" then
	call StatAllWeek()
elseif Action="StatDay" then
	call StatDay()
elseif Action="StatAllDay" then
	call StatAllDay()
elseif Action="FIp" then
	call FIp()
elseif Action="FArea" then
	call FArea()
elseif Action="FAddress" then
	call FAddress()
elseif Action="FTimezone" then
	call FTimezone()
elseif Action="FWeburl" then
	call FWeburl()
elseif Action="FReferer" then
	call FReferer()
elseif Action="FSystem" then
	call FSystem()
elseif Action="FBrowser" then
	call FBrowser()
elseif Action="FMozilla" then
	call FMozilla()
elseif Action="FScreen" then
	call FScreen()
elseif Action="FColor" then
	call FColor()
elseif Action="Init" then
	call Init()
elseif Action="DoInit" then
	call DoInit()
else
	call Infolist()
end if

if not (Action="Init" or Action="DoInit") then
	call historylist()
end if
Set Rs=Nothing
call CloseConn_counter()

sub Infolist()
	dim StartDate,StatDayNum,AllNum,CountNum,AveDayNum,DayNum
	dim MonthMaxNum,MonthMaxDate,DayMaxNum,DayMaxDate,HourMaxNum,HourMaxTime,ZoneNum,ChinaNum,OtherNum
	dim MaxBrw,MaxBrwNum,MaxSys,MaxSysNum,MaxScr,MaxScrNum,MaxAre,MaxAreNum,MaxWeb,MaxWebNum,MaxColor,MaxColorNum
	strGuide="��վ�ۺ�ͳ����Ϣ"
	Sql="Select * From InfoList"
	Rs.Open Sql,conn_counter,1,1
	if not Rs.bof and not rs.eof then
		DayNum=Rs("DayNum")
		AllNum=Rs("TotalNum")
		MonthMaxNum=rs("MonthMaxNum")
		MonthMaxDate=Rs("MonthMaxDate")
		DayMaxNum=Rs("DayMaxNum")
		DayMaxDate=Rs("DayMaxDate")
		HourMaxNum=Rs("HourMaxNum")
		HourMaxTime=Rs("HourMaxTime")
		ChinaNum=Rs("ChinaNum")
		OtherNum=Rs("OtherNum")
		StartDate=Rs("StartDate")
		StatDayNum=DateDiff("D",StartDate,Date)+1
		if StatDayNum<=0 or isnumeric(StatDayNum)=0 then
		   AveDayNum=StatDayNum
		Else
		   AveDayNum=Cint(AllNum/StatDayNum)
		end if
	end if
	Rs.Close
	Sql="Select * From FVisit"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		for i=1 to 10
			CountNum=CountNum+Rs(""&i&"")
		Next
	Else
	  CountNum=0
	end if
	Rs.Close
	Sql="Select Top 1 * From FBrowser Order By TBrwNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxBrw=Rs("TBrowser")
		MaxBrwNum=Rs("TBrwNum")
	end if
	Rs.Close
	Sql="Select Top 1 * From FSystem Order By TSysNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxSys=Rs("TSystem")
		MaxSysNum=Rs("TSysNum")
	end if
	Rs.Close
	Sql="Select Top 1 * From FScreen Order By TScrNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxScr=Rs("TScreen")
		MaxScrNum=Rs("TScrNum")
	end if
	Rs.Close
	Sql="Select Top 1 * From FColor Order By TColNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxColor=Rs("TColor")
		MaxColorNum=Rs("TColNum")
	end if
	Rs.Close
	Sql="Select Top 1 * From FArea Order By TAreNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxAre=Rs("TArea")
		MaxAreNum=Rs("TAreNum")
	end if
	Rs.Close
	Sql="Select Top 1 * From FWeburl Order By TWebNum DESC"
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
		MaxWeb=Rs("TWeburl")
		MaxWebNum=Rs("TWebNum")
	end if
	Rs.Close
	TitleRight="��ʼͳ�����ڣ�<font color=blue>"&StartDate&"</font>"

	strHTML="<table width='100%'><tr><td align='left'>�����ڵ�λ�ã���վͳ�ƹ���&nbsp;&gt;&gt;&nbsp;" & Search & strGuide & "</td><td align='right'>" & TitleRight & "</td></tr></table>"
	strHTML=strHTML & "<table border=0 cellpadding=2 cellspacing=1 width='100%' bgcolor='#FFFFFF' class='border'>"
	strHTML=strHTML & "  <tr class='title' align='center'>"
	strHTML=strHTML & "    <td align=center width='20%' height='22'>ͳ����</td>"
	strHTML=strHTML & "    <td align=center width='30%'>ͳ������</td>"
	strHTML=strHTML & "    <td width='20%'>ͳ����</td>"
	strHTML=strHTML & "    <td align='center' width='30%'>ͳ������</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tbody>"
	strHTML=strHTML & "  <tr class='tdbg'>"
	strHTML=strHTML & "    <td align=center width='20%'>��ͳ������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & StatDayNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>����·���</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MonthMaxNum & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class=tdbg>"
	strHTML=strHTML & "    <td align=center width='20%'>�ܷ�����</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & AllNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>����·����·�</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MonthMaxDate & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class='tdbg'>"
	strHTML=strHTML & "    <td align=center width='20%'>�ܷ�������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & CountNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>����շ���</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & DayMaxNum & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class=tdbg>"
	strHTML=strHTML & "    <td align=center width='20%'>ƽ���շ���</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & AveDayNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>����շ�������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & DayMaxDate & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class='tdbg'>"
	strHTML=strHTML & "    <td align=center width='20%'>���շ�����</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & DayNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>���ʱ����</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & HourMaxNum & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class=tdbg>"
	strHTML=strHTML & "    <td align=center width='20%'>Ԥ�ƽ��շ�����</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & Int(DayNum*(24*60)/(hour(now)*60+minute(now))) & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>���ʱ����ʱ��</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & HourMaxTime & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr bgcolor='#39867B'>"
	strHTML=strHTML & "    <td align=center width='20%' height='1'></td>"
	strHTML=strHTML & "    <td align=center width='30%' height='1'></td>"
	strHTML=strHTML & "    <td align=center width='20%' height='1'></td>"
	strHTML=strHTML & "    <td align=center width='30%' height='1'></td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class=tdbg>"
	strHTML=strHTML & "    <td align=center width='20%'>���ڷ�������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & ChinaNum & "</td>"
	strHTML=strHTML & "    <td align=center width='20%'>�����������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & OtherNum & "</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class='tdbg'>"
	strHTML=strHTML & "    <td align=center width='20%'>���ò���ϵͳ</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MaxSys & " (" & MaxSysNum & ")</td>"
	strHTML=strHTML & "    <td align=center width='20%'>���������</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MaxBrw & " (" & MaxBrwNum & ")</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class=tdbg>"
	strHTML=strHTML & "    <td align=center width='20%'>������Ļ�ֱ���</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MaxScr & " (" & MaxScrNum & ")</td>"
	strHTML=strHTML & "    <td align=center width='20%'>������Ļ��ʾ��ɫ</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MaxColor & " (" & MaxColorNum & ")</td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  <tr class='tdbg'>"
	strHTML=strHTML & "    <td align=center width='20%'>�������ĵ���</td>"
	strHTML=strHTML & "    <td align=center width='30%'>" & MaxAre & " (" & MaxAreNum & ")</td>"
	strHTML=strHTML & "    <td align=center width='20%'>����������վ</td>"
	strHTML=strHTML & "    <td align=center width='30%'>"
	if MaxWeb="ֱ���������ǩ����" then
		strHTML=strHTML & "      " & Left(MaxWeb,40) & " (" & MaxWebNum & ")"
	else
		strHTML=strHTML & "      <a href='" & MaxWeb & "' target='_blank'>" & Left(MaxWeb,40) & "</a> (" & MaxWebNum & ")"
	end if
	strHTML=strHTML & "    </td>"
	strHTML=strHTML & "  </tr>"
	strHTML=strHTML & "  </tbody>"
	strHTML=strHTML & "</table>"
	response.write strHTML
end sub

Sub FVisitor()
	strGuide="������ʼ�¼"
	Sql="Select * From Visitor Order By Id DESC"
	Rs.Open Sql,conn_counter,1,1
	if Rs.Bof and Rs.Eof then
		strHTML="<li>ϵͳ�������ݣ�"
	else
    	totalPut=rs.recordcount
		TitleRight=TitleRight & "�� <font color=red>" & totalPut & "</font> �����ʼ�¼"
		if currentpage<1 then
			currentpage=1
		end if
		if (currentpage-1)*MaxPerPage>totalput then
			if (totalPut mod MaxPerPage)=0 then
				currentpage= totalPut \ MaxPerPage
			else
				currentpage= totalPut \ MaxPerPage + 1
			end if
		end if
		if currentPage>1 then
			if (currentPage-1)*MaxPerPage<totalPut then
				rs.move  (currentPage-1)*MaxPerPage
			else
				currentPage=1
			end if
		end if
		
		dim VisitorNum
		VisitorNum=0

		strHTML="<table width='100%'><tr><td align='left'>�����ڵ�λ�ã���վͳ�ƹ���&nbsp;&gt;&gt;&nbsp;" & Search & strGuide & "</td><td align='right'>" & TitleRight & "</td></tr></table>"
		strHTML=strHTML & "<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>"
		strHTML=strHTML & "  <tr class=title>"
		strHTML=strHTML & "    <td align=left nowrap height='22'>����ʱ��</td>"
		strHTML=strHTML & "    <td align=left nowrap>����ϵͳ�������</td>"
		strHTML=strHTML & "    <td align=left nowrap>��Ļ��С</td>"
		strHTML=strHTML & "    <td align=left nowrap>��ַ</td>"
		strHTML=strHTML & "    <td align=left nowrap>����ҳ��</td>"
		strHTML=strHTML & "  </tr>"
		do while not rs.eof
			strHTML=strHTML & "  <tr class='tdbg'>"
			strHTML=strHTML & "    <td align=left width='15%' nowrap>" & rs("VTime") & "</td>"
			strHTML=strHTML & "    <td align=left width='20%' nowrap>" & rs("System") & "&nbsp;" & rs("Browser") & "</td>"
			strHTML=strHTML & "    <td align=left width='10%' nowrap>" & rs("Screen") & "</td>"
			strHTML=strHTML & "    <td align=left width='25%' nowrap>" & rs("Address") & "</td>"
			strHTML=strHTML & "    <td align=left width='30%' nowrap>"
			if rs("Referer")="ֱ���������ǩ����" then
				strHTML=strHTML &  Left(rs("Referer"),40)
			else
				strHTML=strHTML & "<a href='" & rs("Referer") & "' title='" & rs("Referer") & "' target='_blank'>" & Left(rs("Referer"),40) & "</a>" 
			end if
			strHTML=strHTML & "    </td>"
			strHTML=strHTML & "  </tr>"
			VisitorNum=VisitorNum+1
			if VisitorNum>=MaxPerPage then exit do
			rs.movenext
		loop
		strHTML=strHTML & "</table>"
		if totalput>0 then
			strHTML=strHTML & showpage(strFileName,totalput,MaxPerPage,true,true,"�����ʼ�¼")
		end if
	end if
	rs.close
	set rs=nothing
	response.write strHTML
end sub



sub FCounter()
	Item=array("�״�","����","����","�Ĵ�","���","����","�ߴ�","�˴�","�Ŵ�","ʮ������")
	ItemNum=10
	strGuide="���ʴ���ͳ�Ʒ���"
	StatItem="��������"
	Sql="Select * From FVisit"
	call Stable()
end sub

sub StatYear()
	if Request("Type")="" then
	   QYear=Cstr(Year(Date))
	Else
	   Search="��ѯ�����"
	end if
	ItemNum=12
	ReDim Item(11)
	for I=0 to 11
	  Item(i)=QYear&"��"&i+1&"��"
	Next
	strGuide=QYear&"�����ͳ�Ʒ���"
	StatItem="�·�"
	Sql="Select * From StatYear Where TYear='"&QYear&"'"
	call Stable()
end sub

sub StatAllYear()
	ItemNum=12
	ReDim Item(ItemNum)
	for I=0 to ItemNum-1
	  Item(i)=i+1&"��"
	Next

	strGuide="ȫ�������ͳ�Ʒ���"
	StatItem="�·�"
	Sql="Select * From StatYear Where TYear='Total'"
	call Stable()
end sub

sub StatMonth()
	if Request("Type")="" then
	   QMonth=Cstr(Year(Date)&"-"&Month(Date))
	Else
	   Search="��ѯ�����"
	end if
	SYear=Mid(QMonth,1,Instr(QMonth,"-")-1)
	SMonth=Mid(QMonth,Instr(QMonth,"-")+1)
	Select Case Smonth
	Case "2"
		  if (SYear mod 4)=0 then
			 ItemNum=29
		  Else
			 ItemNum=28
		  end if
	Case "4"  ItemNum=30
	Case "6"  ItemNum=30
	Case "9"  ItemNum=30
	Case "11" ItemNum=30
	Case Else ItemNum=31
	end Select
	ReDim Item(ItemNum-1)
	for I=0 to ItemNum-1
	  Item(i)=SYear&"��"&SMonth&"��"&i+1&"��"
	Next
	strGuide=QMonth&"�·���ͳ�Ʒ���"
	StatItem="����"
	Sql="Select * From StatMonth Where TMonth='"&QMonth&"'"
	call Stable()
end sub

sub StatAllMonth()
	ItemNum=31
	ReDim Item(ItemNum)
	for I=0 to ItemNum-1
	  Item(i)=i+1&"��"
	Next
	strGuide="ȫ���·���ͳ�Ʒ���"
	StatItem="����"
	Sql="Select * From StatMonth Where TMonth='Total'"
	call Stable()
end sub

sub StatWeek()
	Item=array("������","����һ","���ڶ�","������","������","������","������")
	ItemNum=7
	strGuide="���ܷ���ͳ�Ʒ���"
	StatItem="����"
	Sql="Select * From StatWeek Where Tweek='Current'"
	call Stable()
end sub

sub StatAllWeek()
	Item=array("������","����һ","���ڶ�","������","������","������","������")
	ItemNum=7
	strGuide="ȫ���ܷ���ͳ�Ʒ���"
	StatItem="����"
	Sql="Select * From StatWeek Where Tweek='Total'"
	call Stable()
end sub

sub StatDay()
	if Request("Type")="" then
	   QDay=Cstr(Year(Date)&"-"&Month(Date)&"-"&Day(date))
	Else
	   Search="��ѯ�����"
	end if
	ItemNum=24
	ReDim Item(23)
	for I=0 to ItemNum-1
	  Item(i)=mid(i+100,2)&":00-"&mid(i+101,2)&":00"
	Next
	strGuide=QDay&"�շ���ͳ�Ʒ���"
	StatItem="Сʱ"
	Sql="Select * From StatDay Where TDay='"&QDay&"'"
	call Stable()
end sub

sub StatAllDay()
	ItemNum=24
	ReDim Item(ItemNum)
	for I=0 to ItemNum-1
	  Item(i)=mid(i+100,2)&":00-"&mid(i+101,2)&":00"
	Next
	strGuide="ȫ���շ���ͳ�Ʒ���"
	StatItem="Сʱ"
	Sql="Select * From StatDay Where TDay='Total'"
	call Stable()
end sub

sub FIp()
	Sql="Select * From FIp Order By TIpNum DESC"
	strGuide="������IP��ַ����"
	StatItem="IP��ַ"
	call Ftable()
end sub

sub FArea()
	Sql="Select * From FArea Order By TAreNum DESC"
	strGuide="������������������"
	StatItem="����"
	call Ftable()
end sub

sub FAddress()
	Sql="Select * From FAddress Order By TAddNum DESC"
	strGuide="���������ڵ�ַ����"
	StatItem="��ַ"
	call Ftable()
end sub

sub FTimezone()
	Sql="Select * From FTimezone Order By TtimNum DESC"
	strGuide="����������ʱ������"
	StatItem="ʱ��"
	call Ftable()
end sub

sub FWeburl()
	Sql="Select * From FWeburl Order By TWebNum DESC"
	strGuide="������������վ����"
	StatItem="������վ"
	call Ftable()
end sub

sub FReferer()
	Sql="Select * From FRefer Order By TRefNum DESC"
	strGuide="����������ҳ�����"
	StatItem="����ҳ��"
	call Ftable()
end sub

sub FSystem()
	Sql="Select * From FSystem Order By TSysNum DESC"
	strGuide="���������ò���ϵͳ����"
	StatItem="����ϵͳ"
	call Ftable()
end sub

sub FBrowser()
	Sql="Select * From FBrowser Order By TBrwNum DESC"
	strGuide="�������������������"
	StatItem="�����"
	call Ftable()
end sub

sub FMozilla()
	Sql="Select * From FMozilla Order By TMozNum DESC"
	strGuide="������HTTP_USER_AGENT�ַ�������"
	StatItem="USER_AGENT"
	call Ftable()
end sub

sub FScreen()
	Sql="Select * From FScreen Order By TScrNum DESC"
	strGuide="��������Ļ��С����"
	StatItem="��Ļ��С"
	call Ftable()
end sub

sub FColor()
	Sql="Select * From FColor Order By TColNum DESC"
	strGuide="��������Ļ��ʾ��ɫ����"
	StatItem="��Ļ��ʾ��ɫ"
	call Ftable()
end sub

sub Stable()
	Rs.Open Sql,conn_counter,1,1
	if Not Rs.Bof and Not Rs.Eof then
	   Assay=Rs.GetRows
	   Rows=ItemNum-1
	Else
	   Rows=-1
	end if
	Rs.Close
	for i=0 to Rows
		TotalNum=TotalNum+Assay(i,0)
	Next
	ReDim Percent(Rows)
	ReDim BarWidth(Rows)
	for i=0 to Rows
		if TotalNum>0 then
		   Percent(i)=FormatNumber(Int(Assay(i,0)/TotalNum*10000)/100,2,-1)&"%"
		   BarWidth(i)=Assay(i,0)/TotalNum*MaxWidth
		end if
	Next
	TitleRight="��Чͳ�ƣ�<font color=red>"&TotalNum&"</font>"
	if Rows<0 then 
		strHTML="<li>ϵͳ�������ݣ�"
	else
		strHTML="<table width='100%'><tr><td align='left'>�����ڵ�λ�ã���վͳ�ƹ���&nbsp;&gt;&gt;&nbsp;" & Search & strGuide & "</td><td align='right'>" & TitleRight & "</td></tr></table>"
		strHTML=strHTML & "<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>"
		strHTML=strHTML & "  <tr class=title>"
		strHTML=strHTML & "    <td align=left width='30%' nowrap height='22'>" & StatItem & "</td>"
		strHTML=strHTML & "    <td align=left width='20%' nowrap>��������</td>"
		strHTML=strHTML & "    <td align=left width='20%' nowrap>�ٷֱ�</td>"
		strHTML=strHTML & "    <td align=left width='30%' nowrap>ͼʾ</td>"
		strHTML=strHTML & "  </tr>"
		for i=0 to Rows
			strHTML=strHTML & "  <tr class='tdbg'>" 
			strHTML=strHTML & "    <td align=left>" & Item(i) & "</td>"
			strHTML=strHTML & "    <td align=left>&nbsp;&nbsp;" & Assay(i,0) & "</td>"
			strHTML=strHTML & "    <td align=left>" & Percent(i) & "</td>"
			strHTML=strHTML & "    <td align=left><img src='../Images/bar.gif' width='" & Barwidth(i) & "' height='10'></td>"
			strHTML=strHTML & "  </tr>"
		next
		strHTML=strHTML & "</table>"
	end if
	response.write strHTML
end sub

sub Ftable()
	Rs.Open Sql,conn_counter,1,1
	do while not rs.eof
		TotalNum=TotalNum+rs(1)
		rs.movenext
	loop
	Rs.Close
	Rs.Open Sql,conn_counter,1,1
	if Rs.Bof and Rs.Eof then
		strHTML="<li>ϵͳ�������ݣ�"
	else
		totalPut=rs.recordcount
		TitleRight=TitleRight & "��Чͳ�ƣ�<font color=red>"&TotalNum&"</font>"
		if currentpage<1 then
			currentpage=1
		end if
		if (currentpage-1)*MaxPerPage>totalput then
			if (totalPut mod MaxPerPage)=0 then
				currentpage= totalPut \ MaxPerPage
			else
				currentpage= totalPut \ MaxPerPage + 1
			end if
		end if
		if currentPage>1 then
			if (currentPage-1)*MaxPerPage<totalPut then
				rs.move  (currentPage-1)*MaxPerPage
			else
				currentPage=1
			end if
		end if
		
		dim StatItemNum
		StatItemNum=0
		strHTML="<table width='100%'><tr><td align='left'>�����ڵ�λ�ã���վͳ�ƹ���&nbsp;&gt;&gt;&nbsp;" & Search & strGuide & "</td><td align='right'>" & TitleRight & "</td></tr></table>"
		strHTML=strHTML & "<table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>"
		strHTML=strHTML & "  <tr class=title>"
		strHTML=strHTML & "    <td align=left width='30%' nowrap height='22'>" & StatItem & "</td>"
		strHTML=strHTML & "    <td align=left width='20%' nowrap>��������</td>"
		strHTML=strHTML & "    <td align=left width='20%' nowrap>�ٷֱ�</td>"
		strHTML=strHTML & "    <td align=left width='30%' nowrap>ͼʾ</td>"
		strHTML=strHTML & "  </tr>"
		do while not rs.eof
			strHTML=strHTML & "  <tr class='tdbg'>"
			strHTML=strHTML & "    <td align=left nowrap>"
			if (Action="FWeburl" or Action="FReferer") and rs(0)<>"ֱ���������ǩ����" then
				strHTML=strHTML & "<a href='"&rs(0)&"' title='"&rs(0)&"' target='_blank'>"&Left(rs(0),40)&"</a>"
			elseif Action="FMozilla" then
				strHTML=strHTML & "<a title='"&rs(0)&"'>"&Left(rs(0),40)&"</a>"
			else
				strHTML=strHTML & rs(0)
			end if
			strHTML=strHTML & "    </td>"
			strHTML=strHTML & "    <td align=left >&nbsp;&nbsp;" & rs(1) & "</td>"
			strHTML=strHTML & "    <td align=left >" & FormatNumber(Int(rs(1)/TotalNum*10000)/100,2,-1) & "%</td>"
			strHTML=strHTML & "    <td align=left ><img src='../Images/bar.gif' width='" & rs(1)/TotalNum*MaxWidth & "' height='12'></td>"
			strHTML=strHTML & "  </tr>"
			StatItemNum=StatItemNum+1
			if StatItemNum>=MaxPerPage then exit do
			rs.movenext
		loop
		strHTML=strHTML & "</table>"
		if totalput>0 then
			strHTML=strHTML & showpage(strFileName,totalput,MaxPerPage,true,true,"�����ʼ�¼")
		end if
	end if
	rs.close
	set rs=nothing
	response.write strHTML
end sub


Sub HistoryList()
	strHTML="<form name='form1' method='post' action='Admin_Counter.asp'>"
	strHTML=strHTML & "  <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>"
	strHTML=strHTML & "    <tr class='tdbg'>"
	strHTML=strHTML & "      <td width='120'><strong>��վͳ�Ʋ�ѯ��</strong></td>"
	strHTML=strHTML & "      <td>�������ͣ� "
	strHTML=strHTML & "        <select name='type' size='1' class='Select' onChange=change_type()>"
	strHTML=strHTML & "          <option value='1' selected>�ձ���</option>"
	strHTML=strHTML & "          <option value='2'>�±���</option>"
	strHTML=strHTML & "          <option value='3'>�걨��</option>"
	strHTML=strHTML & "        </select>"
	strHTML=strHTML & "        <select name='qyear' size='1' class='Select' onChange=change_it()>"
	for i=2003 to 2010
		if i=year(date) then
			strHTML=strHTML & "<option value='" & i & "' selected>" & i & "</option>"
		else
			strHTML=strHTML & "<option value='" & i & "'>" & i & "</option>"
		end if
	next
	strHTML=strHTML & "        </select>"
	strHTML=strHTML & "        ��"
	strHTML=strHTML & "        <select name='qmonth' size='1' onChange=change_it()>"
	for i=1 to 12
		if i=month(date) then
			strHTML=strHTML & "<option value='" & i & "' selected>" & i & "</option>"
		else
			strHTML=strHTML & "<option value='" & i & "'>" & i & "</option>"
		end if
	next
	strHTML=strHTML & "        </select>"
	strHTML=strHTML & "        ��"
	strHTML=strHTML & "        <select name='qday' size='1' >"
	dim year29,monthdays
	year29=Year(date) Mod 4
	Select Case Month(date)
		Case 2:If year29=0 then monthdays=29 Else monthdays=28 end if
		Case 4:monthdays=30
		Case 6:monthdays=30
		Case 9:monthdays=30
		Case 11:monthdays=30
		Case Else:monthdays=31
	end Select
	for i=1 to monthdays
		if i=day(date) then
			strHTML=strHTML & "<option  value='" & i & "' selected>" & i & "</option>"
		else
			strHTML=strHTML & "<option  value='" & i & "'>" & i & "</option>"
		end if
	next
	strHTML=strHTML & "        </select>"
	strHTML=strHTML & "        ��"
	strHTML=strHTML & "        <input type='submit' name='Search' value='��ѯ'>"
	strHTML=strHTML & "      </td>"
	strHTML=strHTML & "      <td width='120' align='center'><a href='Admin_Counter.asp?Action=Init'>ͳ�����ݳ�ʼ��</a></td>"
	strHTML=strHTML & "    </tr>"
	strHTML=strHTML & "  </table>"
	strHTML=strHTML & "</form>"
	response.write strHTML
end sub


Sub Init()
    strHTML = "<script language = 'JavaScript'>" & vbCrLf
    strHTML = strHTML & "function CheckForm(){" & vbCrLf
    strHTML = strHTML & "  if(confirm('ȷʵҪ���г�ʼ����һ��������޷��ָ���'))" & vbCrLf
    strHTML = strHTML & "    {" & vbCrLf
    strHTML = strHTML & "         return true;" & vbCrLf
    strHTML = strHTML & "    }" & vbCrLf
    strHTML = strHTML & "  else" & vbCrLf
    strHTML = strHTML & "    {" & vbCrLf
    strHTML = strHTML & "    return false;" & vbCrLf
    strHTML = strHTML & "    }" & vbCrLf
    strHTML = strHTML & "}" & vbCrLf
    strHTML = strHTML & "</script>" & vbCrLf
    strHTML = strHTML & "<br><table width='100%' border='0' cellspacing='1' cellpadding='2' class='border'>"
    strHTML = strHTML & "  <tr class='title'>"
    strHTML = strHTML & "    <td height='22' align='center'><strong> �� �� �� ʼ �� </strong></td>"
    strHTML = strHTML & "  </tr>"
    strHTML = strHTML & "  <tr class='tdbg'>"
    strHTML = strHTML & "    <td height='150'>"
    strHTML = strHTML & "<form name='myform' method='post' action='Admin_Counter.asp' onSubmit='return CheckForm();'>"
    strHTML = strHTML & "<p align='center'><font color='#FF0000'><b>�����ô˹��ܣ���Ϊһ��������޷��ָ���</b></font><br>�˲�����������ݿ��е�����ͳ�����ݣ�����ϵͳ��ʼ��ʱ����Ҫ����վ�ķ���ͳ�����ݽ�������ͳ��ʱʹ�á�</p>"
    strHTML = strHTML & "<p align='center'><input name='Action' type='hidden' id='Action' value='DoInit'>"
    strHTML = strHTML & "<input type='submit' name='Submit' value=' ͳ�����ݳ�ʼ�� '></p>"
    strHTML = strHTML & "</form>"
    strHTML = strHTML & "    </td>"
    strHTML = strHTML & "  </tr>"
    strHTML = strHTML & "</table>"
    Response.Write strHTML
End Sub

Sub DoInit()
	conn_counter.Execute ("delete from FAddress")
	conn_counter.Execute ("delete from FArea")
	conn_counter.Execute ("delete from FBrowser")
	conn_counter.Execute ("delete from FColor")
	conn_counter.Execute ("delete from FIp")
	conn_counter.Execute ("delete from FMozilla")
	conn_counter.Execute ("delete from FRefer")
	conn_counter.Execute ("delete from FScreen")
	conn_counter.Execute ("delete from FSystem")
	conn_counter.Execute ("delete from FTimezone")
	conn_counter.Execute ("delete from FVisit")
	conn_counter.Execute ("delete from FWeburl")
	conn_counter.Execute ("delete from InfoList")
	conn_counter.Execute ("delete from StatDay")
	conn_counter.Execute ("delete from StatMonth")
	conn_counter.Execute ("delete from StatWeek")
	conn_counter.Execute ("delete from StatYear")
	conn_counter.Execute ("delete from Visitor")
	conn_counter.Execute ("delete from InfoList")
	conn_counter.Execute ("delete from InfoList")
	conn_counter.Execute ("insert into InfoList (StartDate,OldDay) values ('" & Cstr(Year(Date)&"-"&Month(Date)&"-"&Day(date)) & "','" & Cstr(Year(Date)&"-"&Month(Date)&"-"&Day(date)) & "')")
    Call WriteSuccessMsg("ͳ�����ݳ�ʼ���ɹ���")
End Sub
%>