<%
'网站数据库
AdminName=replace(trim(session("AdminName")),"'","")
AdminPassword=replace(trim(session("AdminPassword")),"'","")
if AdminName="" or adminpassword="" then
	response.redirect "Admin_login.asp"
end if

Function SqlCheckNum(lInStr)
	If lInStr<>"" And Not IsNull(lInStr) And IsNumeric(lInStr) Then
		SqlCheckNum = CCur(lInStr)
	Else
		SqlCheckNum = 0
	End If
End Function

Function SqlCheckStr(lInStr)
	If lInStr<>"" And Not IsNull(lInStr) Then
		SqlCheckStr = Replace(lInStr, "'", "''")
	Else
		SqlCheckStr = ""
	End If
End Function 

Public Function CheckSqlstr(Str)
	If Isnull(Str) Then
		CheckSqlstr = ""
		Exit Function 
	End If
	Str = Replace(Str,Chr(0),"")
	CheckSqlstr = Replace(Str,"'","''")
	CheckSqlStr=Replace(CheckSqlstr,"　","")
	CheckSqlStr=Replace(CheckSqlstr," ","")
End Function
		
Function GetInfo(Typ,GetType,FormName)'[1|0][form|session|app]
	GetInfo=CheckSqlstr(Trim(Request(FormName)))
	If Typ=1 Then
		IF Not Isnumeric(GetInfo) Then
			GetInfo=1
		Else
			GetInfo=Clng(GetInfo)
		End IF
	End IF	
End Function

Sub RLWriteSuccessMsg(lTitle,lMsg)

Response.Write("<html><head><title>"&lTitle&"</title><meta http-equiv='Content-Type' content='text/html; charset=gb2312'>")
Response.Write("<link href='Admin_Style.css' rel='stylesheet' type='text/css'></head><body><br><br>")
Response.Write("<table cellpadding=2 cellspacing=1 border=0 width=400 class='border' align=center>")
Response.Write("  <tr align='center' class='title'><td height='22'><strong>"&lTitle&"</strong></td></tr>")
Response.Write("  <tr class='tdbg'><td height='100' valign='top'><br>"&lMsg&"</td></tr>")
Response.Write("  <tr align='center' class='tdbg'><td><a href='javascript:history.back(-1);'>&lt;&lt; 返回上一页</a></td></tr>")
Response.Write("</table>")
Response.Write("</body></html>")
End Sub

Rem 查询IP地址

Rem 用户帐号
Function GetAccountsByUserID(userid)
Dim Accounts
Accounts=""

IF IsEmpty(userid) OR IsNull(userid) OR Vartype(userid)=8 Then
    'Response.Write userid
    userid=0  
    GetAccountsByUserID=Accounts
    Exit Function
Else
    userid=CInt(userid)
End IF

Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Accounts from  AccountsInfo(nolock)  where UserID="&userid
'Response.Write sql
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    Accounts=rs(0)
End If 
rs.close
set rs=nothing
GetAccountsByUserID=Accounts
End Function

Rem 游戏ID
Function GetGameIDByUserID(userid)
    Dim GameID
    GameID=0
    Call ConnectGame("QPGameUserDB")
    Set rs=Server.CreateObject("Adodb.RecordSet")
    sql="select GameID from  AccountsInfo(nolock)  where UserID="&userid
    rs.Open sql,GameConn,1,3
    If Not rs.eof Then    
        GameID=rs("GameID")
    End If 
    rs.close
    set rs=nothing
    GetGameIDByUserID=GameID
End Function

Rem 游戏名称
Function GetKindNameByKindID(kindid)
Dim KindName
KindName=""
Call ConnectGame("QPServerInfoDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  GameKindItem(nolock)  where KindID="&kindid
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    KindName=rs("KindName")
End If 
rs.close
set rs=nothing
CloseGame()
GetKindNameByKindID=KindName
End Function

Rem 游戏使用数据库
Function GetDbNameByKindID(kindid)
Dim DbName
DbName="QPGameScoreDB"
Call ConnectGame("QPServerInfoDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select * from  GameKindItem(nolock)  where KindID="&kindid
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    DbName=rs("DataBaseName")
End If 
rs.close
set rs=nothing
CloseGame()
GetDbNameByKindID=DbName
End Function

Rem 获取游戏列表
Function GetGameList() 
    Dim pageUrl,rs
    pageUrl="Admin_GameUserScore.asp?kindID="
    Call ConnectGame("QPServerInfoDB")
    sql="select KindID,KindName from  GameKindItem(nolock) Where DataBaseName<>'QPTreasureDB' AND Nullity=0 Order by KindID "
    
    Set rs=GameConn.Execute(sql)
  
    Do While Not rs.Eof    
        Response.Write("<tr><td height='20'>")
        Response.Write("<a href='")
        Response.Write(pageUrl)
        Response.Write(rs("KindID"))
        Response.Write("' target='main'>")
        Response.Write(rs("KindName"))
        Response.Write("</a>")
        Response.Write("</td></tr>")
    rs.MoveNext
	Loop 
    rs.close
    set rs=nothing  
    CloseGame()
End Function

Rem 推广业绩
Function GetSpreadCount(SpreaderID)
    Dim spreadCount
    spreadCount=0
    Call ConnectGame("QPGameUserDB")
    Set rs=Server.CreateObject("Adodb.RecordSet")
    sql="SELECT Count(UserID) As SpreaderCount FROM [AccountsInfo](nolock) where SpreaderID="&SpreaderID
    rs.Open sql,GameConn,1,3
    If Not rs.eof Then    
        spreadCount=rs(0)
    End If 
    rs.close
    set rs=nothing
    GetSpreadCount=spreadCount
End Function

Rem 推广员人数
Function GetSpreadUserCount()
    Dim spreadCount
    spreadCount=0
    Call ConnectGame("QPGameUserDB")
    Set rs=Server.CreateObject("Adodb.RecordSet")
    sql="SELECT COUNT(DISTINCT [SpreaderID]) As SpreaderCount FROM AccountsInfo(nolock) WHERE [SpreaderID]<>0"
    rs.Open sql,GameConn,1,3
    If Not rs.eof Then    
        spreadCount=rs(0)
    End If 
    rs.close
    set rs=nothing
    GetSpreadUserCount=spreadCount
End Function

Rem 机器码限制
Function IsConfineMachine(machineSerial)
Dim hasConfine
hasConfine=False
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select MachineSerial from  ConfineMachine(nolock)  where MachineSerial='"&Trim(machineSerial)&"'"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    hasConfine=True
End If 
rs.close
set rs=nothing
IsConfineMachine=hasConfine
End Function

Rem IP 地址限制
Function IsConfineIp(ipAddr)
Dim hasConfine
hasConfine=False
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select AddrString from  ConfineAddress(nolock)  where AddrString='"&Trim(ipAddr)&"'"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    hasConfine=True
End If 
rs.close
set rs=nothing
IsConfineIp=hasConfine
End Function

Rem 用户名限制
Function IsConfineUsername(username)
Dim hasConfine
hasConfine=False
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select String from  ConfineContent(nolock)  where String='"&Trim(username)&"'"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    hasConfine=True
End If 
rs.close
set rs=nothing
IsConfineUsername=hasConfine
End Function

Rem 卡线用户
Function GetGameScoreLocker()
Dim lockerUser
lockerUser=0
Call ConnectGame("QPTreasureDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Count(UserID) from  GameScoreLocker(nolock)"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    lockerUser=rs(0)
End If 
rs.close
set rs=nothing
GetGameScoreLocker=lockerUser
End Function

Rem 注册用户总数
Function GetGameUserCount()
Dim lockerUser
lockerUser=0
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Count(UserID) from  AccountsInfo(nolock)"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    lockerUser=rs(0)
End If 
rs.close
set rs=nothing
GetGameUserCount=lockerUser
End Function

Rem 停权用户总数
Function GetGameUserNullityCount()
Dim lockerUser
lockerUser=0
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Count(UserID) from  AccountsInfo(nolock) WHERE Nullity=1"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    lockerUser=rs(0)
End If 
rs.close
set rs=nothing
GetGameUserNullityCount=lockerUser
End Function

Rem 会员用户总数
Function GetGameMemberUserCount()
Dim lockerUser
lockerUser=0
Call ConnectGame("QPGameUserDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Count(UserID) from  AccountsInfo(nolock) WHERE MemberOrder>0 AND MemberOverDate>=GETDATE()"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    lockerUser=rs(0)
End If 
rs.close
set rs=nothing
GetGameMemberUserCount=lockerUser
End Function

Rem 金币总额
Function GetGameScoreStat()
Dim lockerUser
lockerUser=0
Call ConnectGame("QPTreasureDB")
Set rs=Server.CreateObject("Adodb.RecordSet")
sql="select Sum(Score)+Sum(InsureScore) from  GameScoreInfo(nolock) where Score>0"
rs.Open sql,GameConn,1,3
If Not rs.eof Then    
    lockerUser=rs(0)
Else
    lockerUser=0    
End If 
rs.close
set rs=nothing
IF IsEmpty(lockerUser) Then
    lockerUser=0
End IF
GetGameScoreStat=lockerUser
End Function


%>