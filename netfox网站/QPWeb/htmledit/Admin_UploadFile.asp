<%
if session("adminadminchen")="" or session("chenruofanfan")<>"chenruofanfan112233" or len(session("user"))>1 then
%>
<script language="JavaScript1.1">
alert('�Բ���,û��Ȩ��')
parent.document.location="login.asp"
</script> 
<%end if%>
<link href="../inc/STYLE.CSS" rel="stylesheet" type="text/css"> 
<%
Dim sAction, sPosition
sAction = UCase(Trim(Request.QueryString("action")))
Sub Footer()
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 width=100% align=center height=23>"
	Response.Write "<table border=0 cellpadding=0 cellspacing=3 align=center>"
	Response.Write "</body></html>"
End Sub
sPosition = sPosition & "�ϴ��ļ�����"
Call Content()
Call Footer()
Sub Content()
	If IsObjInstalled("Scripting.FileSystemObject") = False Then
		Response.Write "�˹���Ҫ�������֧���ļ�ϵͳ����FSO�������㵱ǰ�ķ�������֧�֣�"
		Exit Sub
	End If
	Select Case sAction
	Case "DELALL"
		Call DoDelAll()
	Case "DEL"
		Call DoDel()
	End Select
	Call ShowList()
End Sub
Sub ShowList()
	Response.Write "<p align=center><b>���¼�UploadFileĿ¼�µ������ļ��б�</b></p>"
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 class=list1>" & _
		"<form action='?action=del' method=post name=myform>" & _
		"<tr align=center>" & _
			"<th width=140>����ͼ</th>" & _
			"<th width=100>��С</th>" & _
			"<th width=130>������</th>" & _
			"<th width=130>�ϴ�����</th>" & _
			"<th width=30>ɾ��</th>" & _
		"</tr>"
	Dim sCurrPage, nCurrPage, nFileNum, nPageNum, nPageSize
	sCurrPage = Trim(Request("page"))
	nPageSize = 20
	If sCurrpage = "" Or Not IsNumeric(sCurrPage) Then
		nCurrPage = 1
	Else
		nCurrPage = CLng(sCurrPage)
	End If
	Dim oFSO, oUploadFolder, oUploadFiles, oUploadFile, sFileName
	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	Set oUploadFolder = oFSO.GetFolder(Server.MapPath("uploadfile\"))
	Set oUploadFiles = oUploadFolder.Files
	nFileNum = oUploadFiles.Count
	nPageNum = Int(nFileNum / nPageSize)
	If nFileNum Mod nPageSize > 0 Then
		nPageNum = nPageNum+1
	End If
	If nCurrPage > nPageNum Then
		nCurrPage = 1
	end If
	Dim i
	i = 0
	For Each oUploadFile In oUploadFiles
		i = i + 1
		If i > (nCurrPage - 1) * nPageSize And i <= nCurrPage * nPageSize Then
			sFileName = oUploadFile.Name
			Response.Write "<tr align=center>" & _
				"<td align=center><a href=""uploadfile/" & sFileName & """ target=_blank><img src=uploadfile/" & sFileName & " height=40 border=0></a></td>" & _
				"<td>" & oUploadFile.size & " B </td>" & _
				"<td>" & oUploadFile.datelastaccessed & "</td>" & _
				"<td>" & oUploadFile.datecreated & "</td>" & _
				"<td><input type=checkbox name=delfilename value=""" & sFileName & """></td></tr><tr><td height=10></td></tr>"
		Elseif i > nCurrPage * nPageSize Then
			Exit For
		End If
	Next
	Set oUploadFolder = Nothing
	Set oUploadFiles = Nothing
	If nFileNum <= 0 Then
		Response.Write "<tr><td colspan=6>UploadFileĿ¼�����ڻ�û���ļ���</td></tr>"
	End If
	Response.Write "</table>"
	If nFileNum > 0 Then
		' ��ҳ
		Response.Write "<table border=0 cellpadding=3 cellspacing=0 width='100%'><tr><td>"
		If nCurrPage > 1 Then
			Response.Write "<a href='?page=1'>��ҳ</a>&nbsp;&nbsp;<a href='?page="& nCurrPage - 1 & "'>��һҳ</a>&nbsp;&nbsp;"
		Else
			Response.Write "��ҳ&nbsp;&nbsp;��һҳ&nbsp;&nbsp;"
		End If
		If nCurrPage < i / nPageSize Then
			Response.Write "<a href='?page=" & nCurrPage + 1 & "'>��һҳ</a>&nbsp;&nbsp;<a href='?page=" & nPageNum & "'>βҳ</a>"
		Else
			Response.Write "��һҳ&nbsp;&nbsp;βҳ"
		End If
		Response.Write "&nbsp;&nbsp;&nbsp;&nbsp;��<b>" & nFileNum & "</b>��&nbsp;&nbsp;ҳ��:<b><span class=highlight2>" & nCurrPage & "</span>/" & nPageNum & "</b>&nbsp;&nbsp;<b>" & nPageSize & "</b>���ļ�/ҳ"
		Response.Write "</td></tr></table>"
	End If
	Response.Write "<p align=center><input type=submit name=b value='ɾ��' class=in> <input type=button name=b1 value='���' class=in onclick=""javascript:if (confirm('��ȷ��Ҫ��������ļ���')) {location.href='admin_uploadfile.asp?action=delall';}""></p></form>"
End Sub
Sub DoDel()
	Dim sFileName, oFSO, sMapFileName
	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	For Each sFileName In Request.Form("delfilename")
		sMapFileName = Server.MapPath("uploadfile/" & sFileName)
		If oFSO.FileExists(sMapFileName) Then
			oFSO.DeleteFile(sMapFileName)
		End If
	Next
	Set oFSO = Nothing
End Sub
Sub DoDelAll()
	On Error Resume Next
	Dim sFileName, oFSO, sMapFileName, oFolder, oFiles, oFile
	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	Set oFolder = oFSO.GetFolder(Server.MapPath("uploadfile\"))
	Set oFiles = oFolder.Files
	For Each oFile In oFiles
		sFileName = oFile.Name
		sMapFileName = Server.MapPath("uploadfile/" & sFileName)
		If oFSO.FileExists(sMapFileName) Then
			oFSO.DeleteFile(sMapFileName)
		End If
	Next
	Set oFile = Nothing
	Set oFolder = Nothing
	Set oFSO = Nothing
End Sub
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
Function FileName2Pic(sFileName)
	Dim sExt, sPicName
	sExt = UCase(Mid(sFileName, InstrRev(sFileName, ".")+1))
	Select Case sExt
	Case "TXT"
		sPicName = "txt.gif"
	Case "CHM", "HLP"
		sPicName = "hlp.gif"
	Case "DOC"
		sPicName = "doc.gif"
	Case "PDF"
		sPicName = "pdf.gif"
	Case "MDB"
		sPicName = "mdb.gif"
	Case "GIF", "JPG", "PNG", "BMP"
		sPicName = "pic.gif"
	Case "ASP", "JSP", "JS", "PHP", "PHP3", "ASPX"
		sPicName = "code.gif"
	Case "HTM", "HTML", "SHTML"
		sPicName = "htm.gif"
	Case "ZIP", "RAR"
		sPicName = "zip.gif"
	Case "EXE"
		sPicName = "exe.gif"
	Case "AVI", "MPG", "MPEG", "ASF"
		sPicName = "mp.gif"
	Case "RA", "RM"
		sPicName = "rm.gif"
	Case "MID", "WAV", "MP3", "MIDI"
		sPicName = "audio.gif"
	Case "XLS"
		sPicName = "xls.gif"
	Case "PPT", "PPS"
		sPicName = "ppt.gif"
	Case Else
		sPicName = "unknow.gif"
	End Select
	FileName2Pic = "<img border=0 src='sysimage/file/" & sPicName & "'>"
End Function
%>