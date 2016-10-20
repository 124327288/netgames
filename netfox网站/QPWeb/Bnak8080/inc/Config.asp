<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%
Option explicit
Response.Buffer=True
Response.Charset="gb2312" 
Session.CodePage=936
dim startime
startime=timer()

Dim Conn,SqlConnectionString,Rs,MD5,RLWebDBPrefix
Rem 数据库头名称
RLWebDBPrefix = "QP"

Rem 游戏网页操作类开始

Class GameObj
	Private Money,ErrInfo,BPassWord,AMoney,UserName,PassWordTo,BankPassWordTo,BankPassWord,UserID
	Private BMoney,CMoney,DMoney,EMoney,CheckPassWordArr,CheckPassWord,CheckUserNameArr,GetPassWord
	Private GameID,GameName,PassWord,ProCode2,ProCodes,CheckI,Ip,Sex,F,CheckUserName,CardCode,CardPass
	Private Ncode,Nmail,Nadd,PassW,PassD,CIP
	
	Private Sub Class_Terminate()

	End Sub 
	
	Private Sub Class_Initialize() 
		BMoney=1000'银行必须存底数额
		CMoney=0.002'转帐服务费百分比
		DMoney=1000'低于多少的不收服务费
		EMoney=1000000000'一天最多能转多少银子
		CheckPassWord="112233,444444,123456,222222,111111,aaaaaa,bbbbbb,888888,666666,123123,555555,cccccc,aabbcc,333333,999999,12345678,654321"
		CheckUserName="管理员,游戏中心,客服,系统,乱泡,乱虫,乱子"
		CIP = Left(Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'",""),18)
		If CIP = "" Then CIP = Request.ServerVariables("REMOTE_ADDR") 
	End Sub 
	
	Private Function IsCheckPassWord(Str)
		CheckPassWordArr=Split(CheckPassWord,",")
		IsCheckPassWord=True
		For CheckI=0 To Ubound(CheckPassWordArr)
			IF Str=CheckPassWordArr(CheckI) Then
				IsCheckPassWord=False
				EXIT Function
			End IF
		Next
	End Function
	
	Private Function IsCheckUserName(Str)
		CheckUserNameArr=Split(CheckUserName,",")
		IsCheckUserName=True
		For CheckI=0 To Ubound(CheckUserNameArr)
			IF instr(Str,CheckUserNameArr(CheckI))>0 Then
				IsCheckUserName=False
				EXIT Function
			End IF
		Next
	End Function
	
	Public Sub BakErr(Info,Url)
		IF Url="" Then
			Url=Request.ServerVariables("HTTP_REFERER")
		End IF
		IF Info="" Then
			Info="不可知错误,返回!"
		End IF
		Response.Write "<script language=JavaScript1.1>alert('"& Info &"');" 
		Response.Write " document.location='"& Url &"';</script>" 
		Response.End
	End Sub
	
	Public Function CheckSqlstr(Str)
		If Isnull(Str) Then
			CheckSqlstr = ""
			Exit Function 
		End If
		Str = Replace(Str,Chr(0),"")
		CheckSqlstr = Replace(Str,"'","''")
	End Function
	
	
	Public Function GetInfo(Typ,GetType,FormName)'[1|0][form|session|app]
		GetInfo=CheckSqlstr(Trim(Request(FormName)))
		If Typ=1 Then
			IF Not Isnumeric(GetInfo) Then
				GetInfo=100
			Else
				GetInfo=Clng(GetInfo)
			End IF
		End IF	
	End Function
	
	
	Public Sub DbConn(GameDb)
		SqlConnectionString="DRIVER={SQL Server};SERVER=(local);UID=sa;PWD=sa;DATABASE="& GameDb &";"
		Set Conn= Server.CreateObject("ADODB.Connection")
		Conn.Open SqlConnectionString
	End Sub
	
	Public Sub DbClose()
		IF IsObject(Conn) Then
			Conn.Close:Set Conn=Nothing
		End IF
	End Sub

	Public Sub RsClose()
		IF IsObject(Rs) Then
			Rs.Close:Set Rs=Nothing
		End IF
	End Sub

	Public Function IsLogin()
		IsLogin=False
		IF Not IsEmpty(Session("UserID")) And Session("UserID")<>"" Then
			IsLogin=True
		End IF
	End Function
	
	Public Function Login()
		IF GetInfo(0,"form","login")="true" Then
			UserID=GetInfo(1,"form","GameID")
			PassWord=GetInfo(0,"form","PassWord")
			Set md5= New MD5obj
			PassWord=md5.calcMD5(PassWord)
			Set Md5=Nothing
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Select UserID,GameID,Accounts From AccountsInfo Where GameID="& UserID &" And LogonPass='"& PassWord &"'")
			IF Not RS.EOF THEN
				Session("UserID")=Rs(0)
				Session("GameID")=Rs(1)
				Session("UserName")=RS(2)
				RsClose:DbClose
				BakErr "登入成功!","ServeWealth.Asp"
			ELSE
				RsClose:DbClose
				BakErr "对不起,您的用户名和密码错误!","Login.asp"
			END IF
		End IF
	End Function
	
	Public Function IsCheckLogin()
		IF Not IsLogin Then
			BakErr "您还没有登入,请登入后再行操作!","Login.asp"
		End IF
	End Function
		
	Public Sub UpdatePassWord(Typ)'[LogonPass|InsurePass]
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF GetInfo(0,"form","password")<>GetInfo(0,"form","password2") Then
				BakErr "两次输入的密码不相同!",""
				Exit Sub
			Else
				IF GetInfo(0,"form","password")="" Or GetInfo(0,"form","password")="123456" Or GetInfo(0,"form","password")="888888" Then
					BakErr "您输入的银行密码过于简单!",""
					Exit Sub
				End IF
				DbConn(RLWebDBPrefix&"GameUserDb")
				Set md5= New MD5obj
				Set Rs=Conn.Execute("Exec GSP_GP_UpdatePassWord "& Session("UserID") &",'"& md5.calcMD5(GetInfo(0,"form","UserName")) &"','"& md5.calcMD5(GetInfo(0,"form","PassWord")) &"','"&Typ&"'")
				Errinfo=Rs(0)
				Set Md5=Nothing
				RsClose:DBClose
				BakErr Errinfo,""
				Exit Sub
			End IF
		End IF
	End Sub
	
	Private Function IsWealthGame()
		DbConn(RLWebDBPrefix&"TreasureDb")
		Set Rs=Conn.Execute("Select UserID From GameScoreInfo Where UserID="& Session("UserID") &"")
		IF Not Rs.Eof Then
			RsClose:DbClose
			Response.Redirect("Error.asp?Error=对不起,您目前正在银子类游戏房间<br>(如梭哈,麻奖等)中!不能进行银行操作!")
			Response.End
		End IF
	End Function
	
	Public Sub ServeWealthShow()
		IF Session("Deposits")="" Or IsEmpty(Session("Deposits")) Then
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set Rs=Conn.Execute("Select Score,InsureScore From GameScoreInfo Where UserID="& Session("UserID") &"")
			IF Not Rs.Eof Then
				Session("Deposits")=Rs(1)	
				Session("money")=Rs(0)	
			End IF
			RsClose:DbClose
		End IF
	End Sub
	
	Public Sub ServeWealth()
		IsCheckLogin()
		IsWealthGame()
		ServeWealthShow()
		IF GetInfo(0,"form","login")="true" Then
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "存入的银子必须为整数,并且不能大于现有银子!",""
				Exit Sub
			End IF
			Money=GetInfo(1,"form","money2")
			IF Money<1000 Then
				BakErr "对不起,存银子最少1000两!",""
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set Rs=Conn.Execute("Exec GSP_GP_ServeWealth "& Session("UserID") &","& Money &",'"& Cip &"'")
			Errinfo=RS(0)
			RsClose:DbClose
			IF Left(Errinfo,4)="成功信息" Then
				Session("Deposits")=Empty	
				Session("money")=Empty	
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow()
	End Sub	
	
	Public Sub ReceiveWealth()
		IsCheckLogin()
		IsWealthGame()
		ServeWealthShow()
		IF GetInfo(0,"form","login")="true" Then
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "存入的银子必须为整数,并且不能大于现有银子!",""
				Exit Sub
			End IF
			money=GetInfo(1,"form","money2")
			IF Money<1 Then
				BakErr "您的取的银子为零!不能进行取银子操作",""
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set md5= New MD5obj
			BPassWord=md5.calcMD5(GetInfo(0,"form","PassWord"))
			Set Md5=Nothing
			Set Rs=Conn.Execute("Exec GSP_GP_ReceiveWealth "& Session("UserID") &","& money &",'"& BPassWord &"','"& CIP &"'")
			Errinfo=RS(0)
			RsClose:DbClose
			IF Left(Errinfo,4)="成功信息" Then
				Session("Deposits")=Empty	
				Session("money")=Empty
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow()
	End Sub
	
	Public Sub Transfers()
		IsCheckLogin()
		ServeWealthShow()
		IF GetInfo(0,"form","login")="true" Then
			GameID=GetInfo(1,"form","UserID")
			GameName=GetInfo(0,"form","UserName")
			IF Session("UserID")=GameID Then
				BakErr "不能对自已转帐!",""
				Exit Sub
			End If
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "转帐的银子必须为整数,并且不能大于现有银子!",""
				Exit Sub
			End IF
			Money=GetInfo(1,"form","money2")
			IF Money<1000 Then
				BakErr "对不起,转帐最少1000两!",""
				Exit Sub
			End IF
			IF Clng(Session("Deposits"))<Money Or (Clng(Session("Deposits"))-Money)<BMoney Then
				BakErr "银行必须有"& BMoney &"两银子留底!",""
				Exit Sub
			End IF
			IF Money>EMoney Then
				BakErr "对不起,您一天最多只能转"& EMoney &" 两银子!",""
				Exit Sub
			End IF
			IF Money>DMoney Then
				AMoney=Clng(Money*CMoney)
			Else
				AMoney=0
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set md5= New MD5obj
			BPassWord=md5.calcMD5(GetInfo(0,"form","PassWord"))
			Set Md5=Nothing
			Set Rs=Conn.Execute("Exec GSP_GP_Transfers "&Session("UserID")&",'"&Session("UserName")&"','"& BPassWord &"',"&GameID&",'"&GameName&"',"& BMoney &","& AMoney &","& Money &","& EMoney &",'"& Cip &"'")
			Errinfo=RS(0)
			RsClose:DbClose
			Errinfo=Replace(Errinfo,Chr(13),"")
			Errinfo=Replace(Errinfo,Chr(10),"")
			Errinfo=Replace(Errinfo,"@DMoney",EMoney)
			Errinfo=Replace(Errinfo,"@GameName",GameName)
			Errinfo=Replace(Errinfo,"@money",Money)
			Errinfo=Replace(Errinfo,"@amoney",AMoney)
			Errinfo=Replace(Errinfo,"@Bmoney",BMoney)
			IF Left(Errinfo,4)="成功信息" Then
				Session("Deposits")=Empty	
				Session("money")=Empty
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow()
	End Sub
	
	Public Sub Pay()
		IsCheckLogin()
		IsWealthGame()
			IF GetInfo(0,"form","login")="true" Then
				CardCode=GetInfo(0,"form","CardCode")
				CardPass=GetInfo(0,"form","CardPass")
				IF Not Isnumeric(CardCode) Or Not Isnumeric(CardPass) Then
					BakErr "对不起,你的卡号或密码错误!",""
					Exit Sub
				End IF
				DbConn("CxGameTreasureDb")
				Set Rs=Conn.Execute("Exec CxGamePty "& CardCode &",'"& CardPass &"',"& Session("UserID") &"")
				Errinfo=Rs(0)
				RsClose:DbClose
				IF Left(Errinfo,4)="成功信息" Then
					Session("Deposits")=Empty	
					Session("money")=Empty
				End IF
				BakErr Errinfo,""
				Exit Sub
			End IF
	End Sub
	
End Class

Rem 建立类对象
Dim CxGame
Set CxGame=New GameObj
%>