<%
Dim sql_Injdata,sql_inj,sql_post,sql_data,sql_get
sql_Injdata = Lcase("'|and|exec|insert|update|count|chr")
sql_inj = split(sql_Injdata,"|")

If Request.Form<>"" Then
    For Each sql_post In Request.Form
        For sql_data=0 To Ubound(sql_inj)
            IF Instr(Lcase(Request.Form(sql_post)),sql_inj(sql_data))>0 Then
                Response.Write "<Script Language=JavaScript>alert('SQLͨ�÷�ע��ϵͳ��ʾ��\n\n�벻Ҫ�ڲ����а����Ƿ��ַ�����ע�룡\n\n  ');history.back(-1)</Script>"
                Response.end
            END IF
        Next
    Next
END IF

If Request.QueryString<>"" Then
    For Each sql_get In Request.QueryString
        For sql_data=0 To Ubound(sql_inj)
            IF Instr(Lcase(Request.QueryString(sql_get)),sql_inj(sql_data))>0 Then
                Response.Write "<Script Language=JavaScript>alert('SQLͨ�÷�ע��ϵͳ��ʾ��\n\n�벻Ҫ�ڲ����а����Ƿ��ַ�����ע�룡\n\n ');history.back(-1)</Script>"
                Response.end
            END IF
        Next
    Next
End If


Dim DbAcc,Dbname,DbAccConn,DbAccConnStr,fileSys
Dbname="qpgame.config"  '��̨�������ݿ�
DbAcc=GetDbAccPath(Dbname)

Set DbAccConn = Server.CreateObject("ADODB.Connection")
DbAccConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &DbAcc
DbAccConn.Open DbAccConnStr

If Err Then
	err.Clear
	Set DbAccConn = Nothing
	Response.Write "��̨���ݿ����ӳ������������ִ���"
	Response.End
End If

Rem �ر�����
Sub CloseDbAccConn()
    IF IsObject(DbAccConn) Then
    DbAccConn.Close
    Set DbAccConn=nothing
    End IF
End Sub

Rem ���ݿ��ַ
Function GetDbAccPath(db_name)
    Dim accPath
    accPath=Server.Mappath("data/") & "\"&db_name  '��̨
    Set fileSys=Createobject("scripting.filesystemobject")

    IF fileSys.FileExists(accPath)=false Then 
     accPath=Server.mappath("../data/") & "\"&db_name  '����ϵͳ
    End IF
    GetDbAccPath=accPath
End Function

Rem IP ���ݿ�����
Dim IPDbAccConn,ipDbname,ipDbAcc,ipDbAccConnStr
ipDbname="QQWry.mdb"
ipDbAcc=GetDbAccPath(ipDbname)

Set IPDbAccConn = Server.CreateObject("ADODB.Connection")
ipDbAccConnStr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" &ipDbAcc
IPDbAccConn.Open ipDbAccConnStr

If Err Then
	err.Clear
	Set IPDbAccConn = Nothing
	Response.Write "IP��ַ���ݿ����ӳ������������ִ���"
	Response.End
End If

Rem ��ѯIP��ַ
Function GetCityFromIP(lIPStr)
Dim IPRs,IPStrArray,IpLong,IPStr
	If lIpStr="" Or IsNull(lIpStr) Then
		GetCityFromIP = "û��IP��¼"
		Exit Function
	End If
	IPStrArray = Split(lIPStr, ".")
	If Ubound(IPStrArray)=3 Then
		IpLong = CLng(IPStrArray(0))*256*256*256+cint(IPStrArray(1))*256*256+cint(IPStrArray(2))*256+cint(IPStrArray(3))-1
		Set IpRs = IPDbAccConn.execute("select * from ip where StartIP<="&IpLong&" and EndIP>="&IpLong)
		If Not IpRs.Eof Then
			IpStr = IpRs("pos")&"  "&IpRs("Detail")
		Else
			IpStr = "δ֪��ַ"
		End If
		IpRs.Close
		Set IpRs = Nothing		    
	Else
		IpStr = "δ֪��ַ"
	End If
	'IF IsObject(IPDbAccConn) Then
     '   IPDbAccConn.Close
     '   Set IPDbAccConn=nothing
    'End IF 
GetCityFromIP = IpStr
End Function

Rem ��ȡ���ƹ����̨����
Function GetQPAdminSiteName()
    Dim qpSitenameRs,qpSitename
    Set qpSitenameRs=DbAccConn.execute("select top 1 SiteName from QPAdminSiteInfo")
    If Not qpSitenameRs.Eof Then
        qpSitename=qpSitenameRs(0)
    Else
        qpSitename="��������ƽ̨�����̨"
    End If
    qpSitenameRs.Close
    Set qpSitenameRs=Nothing
GetQPAdminSiteName= qpSitename   
End Function

%>
