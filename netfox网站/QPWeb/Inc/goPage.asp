<%
Sub goPage(pagecount,page)
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
%>