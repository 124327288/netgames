<%
'游戏数据库
Const RLGameIsSql = 1
Dim GameConn

Sub ConnectGame(lDataBase)
Dim ConnStr,RLWebSqlNow
	If RLGameIsSql = 1 Then
		'sql数据库连接参数：数据库名、用户密码、用户名、连接名（本地用local，外地用IP）
		Dim SqlDatabaseName,SqlPassword,SqlUsername,SqlLocalName
		SqlDatabaseName = lDataBase
		SqlPassword = "sa"
		SqlUsername = "sa"
		SqlLocalName = "(local)"  
		ConnStr = "Provider = Sqloledb; User ID = " & SqlUsername & "; Password = " & SqlPassword & "; Initial Catalog = " & SqlDatabaseName & "; Data Source = " & SqlLocalName & ";"
		RLWebSqlNow = "GetDate()"
	Else
		'Access用户
		ConnStr = "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = " & Server.MapPath(RLDbPath & RLAccessDb)
		RLWebSqlNow = "Now()"
	End If
	On Error Resume Next
	Set GameConn = Server.CreateObject("ADODB.Connection")
	GameConn.open ConnStr
	If Err Then	
		
		Set GameConn = Nothing		
		Response.Write "数据库连接出错，请检查连接字串。"
		If Session("TcName")="admin" Then
			Response.Write Err.Description
		Else
			err.Clear
		End If
		Response.End
	End If
End Sub

Sub CloseGame()
IF Not IsEmpty(GameConn) Then
    Exit Sub
End IF
If IsObject(GameConn) Then
    IF GameConn.State<>0 Then
	    GameConn.Close
	    Set GameConn = Nothing
	End IF
End If
End Sub

%>