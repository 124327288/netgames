<%
Dim NewsConn,NewsRs
Class NewsObj()
	Public Sub DbConn()
		Set NewsConn=Server.Createobject("ADODB.CONNECTION")
		NewsConn.Open "DBQ="+Server.Mappath("../data/gameserver##zxip.mdb")+";DRIVER={Microsoft Access Driver (*.mdb)};"
	End Sub
	
	Rem ���÷�ʽ NewsObj.NewsTop "100",10,15,"CssName"
	Public Sub NewsTop(ClassCode,Top,TitleLen,Css)
		Response.Write "<ul class="""& Css &""">"
		DBConn("News")
		Dim Title
		Set NewsRs=NewsConn("Select Top "& Top &" Id,Newstitle,Newsdate From News Where ClassCode Like '"& ClassCode &"%' Order By ID DESC")
		Do While Not NewsRs.Eof
			Title=NewsRs(1)
			IF Len(Title)>TitleLen Then
				Title=Left(Title,TitleLen) & ".."
			End IF
			Response.Write "<li><a href=""show.asp?id="& NewsRs(0) &""" title="""& Rs(1) &""">"& Title &"</li>"
		NewsRs.MoveNext
		Loop
		NewsRs.Close:Set NewsRs=Nothing
		NewsConn.Close:Set NewsConn=Nothing
		Response.Write "</ul>"
	End Sub
	
	Rem ���÷�ʽ NewsObj.NewsShow
	Public Sub NewsShow()
		Dim ID,Show
		ID=Request("ID")
		IF Not Isnumeric(ID) then
			Response.Write "�Ƿ�ID��!"
			Response.End
		End if
		DBConn("News")
		Set NewsRs=NewsConn("Select Newstitle,Newsinfo,Newsdate From News Where ID="& ID &"")
		IF Not NewsRs.Eof Then
			Show=NewsRs("Newsinfo")
			Response.write "<h1>"&NewsRs("newstitle")&"</h1>"
			Response.write "<div id=""show"" style=""width: 600px;float: left;overflow-x : auto;overflow:hidden;"">"& Show &"</div>"
		End if
		NewsRs.Close:Set NewsRs=Nothing
		NewsConn.Close:Set NewsConn=Nothing	
	End Sub
	
	Public Sub goPage(pagecount,page)
		Dim query, a, x, temp
		action = Request.ServerVariables("SCRIPT_NAME")
		query = Split(Request.ServerVariables("QUERY_STRING"), "&")
		For Each x In query
			a = Split(x, "=")
			If StrComp(a(0), "page", vbTextCompare) <> 0 Then
				temp = temp & a(0) & "=" & a(1) & "&"
			End If
		Next
		Response.Write("<table " & Table_style & ">" & vbCrLf )		
		Response.Write("<form method=get onsubmit=""document.location = '" & action & "?" & temp & "Page='+ this.page.value;return false;""><TR>" & vbCrLf )
		Response.Write("<TD align=right>" & vbCrLf )
		Response.Write(font_style & vbCrLf )	
		if page<=1 then
			Response.Write ("[��ҳ] " & vbCrLf)		
			Response.Write ("[��ҳ] " & vbCrLf)
		else		
			Response.Write("[<A HREF=" & action & "?" & temp & "Page=1>��ҳ</A>] " & vbCrLf)
			Response.Write("[<A HREF=" & action & "?" & temp & "Page=" & (Page-1) & ">��ҳ</A>] " & vbCrLf)
		end if
		if page>=pagecount then
			Response.Write ("[��ҳ] " & vbCrLf)
			Response.Write ("[βҳ]" & vbCrLf)			
		else
			Response.Write("[<A HREF=" & action & "?" & temp & "Page=" & (Page+1) & ">��ҳ</A>] " & vbCrLf)
			Response.Write("[<A HREF=" & action & "?" & temp & "Page=" & pagecount & ">βҳ</A>]" & vbCrLf)			
		end if
		Response.Write(" ��" & "<INPUT TYEP=TEXT NAME=page SIZE=2 Maxlength=5 VALUE=" & page & " style=""font-size: 9pt"">" & "ҳ"  & vbCrLf & "<INPUT type=submit style=""font-size: 7pt"" value=GO>")
		Response.Write(" �� " & pageCount & " ҳ" &  vbCrLf)			'pageCount�ǵ���ҳ���и�ֵ��ҳ��
		Response.Write("</TD>" & vbCrLf )				
		Response.Write("</TR></form>" & vbCrLf )		
		Response.Write("</table>" & vbCrLf )		
	End Sub
	Rem ���÷�ʽ NewsObj.NewsList "100",20
	Public NewsList(ClassCode,Top)
		DBConn("News")
		IF ClassCode="" Then
			ClassCODE=Request("ClassCode")
		End IF
		IF Not Isnumeric(ClassCODE) Then
			ClassCODE=1
		End IF
		Set NewsRs=Server.Createobject("Adodb.Recordset")
		NewsRs.Open "Select Top "& Top &" ID,ClassCode,NewsTitle,NewsDate",NewsConn,1,1
		NewsRs.PageSize =Top
		Dim Result_n
		Result_n=NewsRs.RecordCount 
		Response.Write "<table width=""96%"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""1"">"
		If Result_n>0 then
			Maxpage=NewsRs.PageCount 
			Page=Request("page")	
			If Not IsNumeric(Page) or Page="" then
				Page=1
			Else
				Page=cint(Page)
			End if
			If page<1 then
				page=1
			Elseif  page>maxpage then
				page=maxpage
			End if	
			NewsRs.AbsolutePage=Page
			Response.Write "<tr><td height=""26""><table width=""98%"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""1"">"
		Else
			NewsRs.Close:Set NewsRs=Nothing
			NewsConn.Close:Set NewsConn=Nothing	
			Response.Write "<tr><td height=""26"" bgcolor=""ffffff"">�Բ���,û���κ���Ϣ!</td></tr></table>"
			Response.End
		End IF
		For i=1 to Top
			Response.Write "<tr>"
			Response.Write "<td width=""5%"" height=26><div align=""center""><img src=""img/fsa3.jpg"" width=""3"" height=""10""></div></td>"
			Response.Write "<td width=""95%""><a href=show.asp?id="& NewsRs("id") & "classcode="& NewsRs("classcode") &">"& NewsRs("newstitle") & "</a>  ["& NewsRs("newsdate")& "]</td>"
			Response.Write "</tr>"
			NewsRs.MoveNext
			IF NewsRs.Eof Then Exit For
		Next
		Response.Write "</table>"
		NewsRs.Close:Set NewsRs=Nothing
		NewsConn.Close:Set NewsConn=Nothing	
		Response.Write "</td></tr>"
		Response.Write "<tr>"
		Response.Write "<td height=""26""><div align=""right"">"& call goPage(maxpage,page) &"</div></td>"
		Response.Write "</tr></table>"
	End Sub
	
	Public Sub ReOk()
		DBConn("News")
		NewsConn.Execute("INSERT INTO [Re]([UserName],[ATxt],[Act]) VALUES (1,1,0)")
		
	
	
	End Sub
End Class

Dim NewsObj
Set NewsObj=New NewsClass
%>
 
