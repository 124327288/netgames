<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<%
Option explicit
Response.Buffer=True
Response.Charset="gb2312" 
Session.CodePage=936
dim startime
startime=timer()

Dim Conn,SqlConnectionString,Rs,MD5,Maxpage,page,i,RLWebDBPrefix
Rem ���ݿ�ͷ����
RLWebDBPrefix = "QP"
'Response.write chr(-24159)
Rem ��Ϸ��ҳ�����࿪ʼ


Class GameObj
	Private Money,ErrInfo,BPassWord,AMoney,UserName,PassWordTo,BankPassWordTo,BankPassWord
	Private BMoney,CMoney,DMoney,EMoney,CheckPassWordArr,CheckPassWord,CheckUserNameArr,GetPassWord
	Private GameID,GameName,PassWord,ProCode2,ProCodes,CheckI,Ip,Sex,F,CheckUserName,CardCode,CardPass
	Private Ncode,Nmail,Nadd,PassW,PassD,CIP
	
	Private Sub Class_Terminate()

	End Sub 
	
	Private Sub Class_Initialize() 
		BMoney=1000'���б���������
		CMoney=0.002'ת�ʷ���Ѱٷֱ�
		DMoney=1000'���ڶ��ٵĲ��շ����
		EMoney=1000000000'һ�������ת��������
		CheckPassWord="112233,444444,123456,222222,111111,aaaaaa,bbbbbb,888888,666666,123123,555555,cccccc,aabbcc,333333,999999,12345678,654321"
		CheckUserName="����Ա,�ͷ�,ϵͳ,����,�ҳ�,����,��,��,fuck,����,��ȫ��,������,����,����,���,����,����,��Ϫ��,����,����,�Խ�,�ݺ�,Ц��,�侫,��ƨ,��,�,���,ƨ��,��,��,����,������,�����,������,����ȫ��,����,����,��С��,����,��Һ,����,����,ϵͳ,����,����,GM,ϵ�y,��ʾ,��Ϣ,��,����,������Ա,����,Ѳ��,�չ�,����,��,�齱,zxip,www,��,��,��,��,����,�绰,�ֻ�,��,9334,��������,7238,��,262,0806,yin,0566,6276,7687,��ͨ,8270,5885,5808,��ֵ,��,-,_,��,+,=,*,',~,`,!,#,@,$,%,^,&,(,),|,\,?,/,136,139,130,135,134,133,��Ϣ,����,��ʾ,��,��,��,��,��,��,��,��,����,����,����,Ѳ��,��,��,��ʾ,����,��ȫ��,��,��,��Ϸ"
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

                if instr(str,chr(32))>0 Or instr(str,chr(34))>0 Then
	        IsCheckUserName=False
	        EXIT Function
		End IF

                if instr(str,",")>0 Or instr(str,",")>0 Then
	        IsCheckUserName=False
	        EXIT Function
		End IF
	End Function
	
	Public Sub BakErr(Info,Url)
		IF Url="" Then
			Url=Request.ServerVariables("HTTP_REFERER")
		End IF
		IF Info="" Then
			Info="����֪����,����!"
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
		CheckSqlStr=Replace(CheckSqlstr,"��","")
		CheckSqlStr=Replace(CheckSqlstr," ","")
	End Function
	
	
	Public Function GetInfo(Typ,GetType,FormName)'[1|0][form|session|app]
		GetInfo=CheckSqlstr(Trim(Request(FormName)))
		If Typ=1 Then
			IF Not Isnumeric(GetInfo) Then
				GetInfo=1
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
	
	Public Sub DbConn60(GameDb)
		Set Conn= Server.CreateObject("ADODB.Connection")
		Conn.Open "DRIVER={SQL Server};SERVER=(local);UID=sa;PWD=sa;DATABASE="& GameDb &";"
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
	
	rem �����֤��
    Public Function Vcode()
        Vcode = "<img src=""Inc/GetCode.asp"" onclick=""this.src='Inc/GetCode.asp';"" alt=""�������û����������"" />"
    	Response.write Vcode
    End Function
	
    Public Function Vcode2()
        Vcode2 = "<img src=""Inc/GetCode2.asp"" onclick=""this.src='Inc/GetCode2.asp';"" alt=""�������û����������"" />"
    	Response.write Vcode2
    End Function
	
	rem ��֤����֤
	Public Function CodeIsTrue()
		Dim CodeStr
		CodeStr=Lcase(Trim(Request("getcode")))
		If CStr(Lcase(Session("GetCode")))=CStr(CodeStr) And CodeStr<>""  Then
			CodeIsTrue=True
			Session("GetCode")=empty
		Else
			CodeIsTrue=False
			Session("GetCode")=empty
		End If	
	End Function 
	
	rem ��½��֤
	Public Sub CheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>err.innerHTML='<strong><font color=#000000>��֤�����!</font></strong>'</script>"
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"GameUserDb")
			IF GetInfo(0,"form","id")="true" Then
				Set Rs=Conn.Execute("Select UserID,GameID,Accounts,LogonPass,Nullity,MemberOrder,IsBoxPassWord From AccountsInfo Where UserID="& Left(GetInfo(1,"form","username"),10) &"")
			Else
				Set Rs=Conn.Execute("Select UserID,GameID,Accounts,LogonPass,Nullity,MemberOrder,IsBoxPassWord From AccountsInfo Where Accounts='"& Left(GetInfo(0,"form","username"),20) &"'")
			End IF
			
			IF Rs.Eof Then
				Response.Write "<script>err.innerHTML='<strong><font color=#000000>�û������������!</font></strong>'</script>"
				RsClose:DbClose
				Exit Sub
			Else
				Set md5= New MD5obj
				If md5.calcMD5(GetInfo(0,"form","password"))<>Rs(3) Then
					Response.Write "<script>err.innerHTML='<strong><font color=#000000>�û������������!</font></strong>'</script>"
					Set Md5=Nothing
					RsClose:DbClose
					Exit Sub
				Else
					Set Md5=Nothing
					IF Rs(4)=True Then
						Response.Write "<script>err.innerHTML='<strong><font color=#000000>���ʺ��ѱ�����Ա����!</font></strong>'</script>"
						RsClose:DbClose
						Exit Sub
					Else
						Session("UserID")=Rs(0)
						Session("GameID")=Rs(1)
						Session("UserName")=Rs(2)
						Session("PassWord")=Rs(3)
						Session("Vip")=Rs(5)
						Session("IsBox")=Rs(6)
						RsClose:DbClose
						Response.Redirect "index.asp"
					End IF
				End IF
			End IF
		End IF
		IF GetInfo(0,"form","exit")="true" Then
			Session("UserID")=Empty
			Session("GameID")=Empty
			Session("UserName")=Empty
			Session("PassWord")=Empty
			Session("Vip")=Empty
			Session("Deposits")=Empty	
			Session("money")=Empty
			Session("IsBox")=Empty
			Response.Redirect "index.asp"
		End IF
	End Sub
	
	rem ����Ƿ��½
	Public Function IsLogin()
		IsLogin=False
		IF Not IsEmpty(Session("UserID")) And Session("UserID")<>"" Then
			IsLogin=True
		End IF
	End Function
	
	rem �û���½
	Public Sub LoginInfo()
		Response.Write "<table   width=""94%"" border=""0"" cellpadding=""0"" cellspacing=""0"">"
		IF IsLogin Then
			Dim Vip
			IF Session("Vip")=0 Then
				Vip="��ͨ"
			Else
				Vip="Vip"
			End IF
			CheckLogin()
			Response.Write "<tr><td valign=""top"">"
			Response.Write("&nbsp;����!<strong><font color=#ff0000>"& Session("UserName") &"</font></strong><br><br>&nbsp;����ID��Ϊ:<font color=#ff0000><strong>"& Session("GameID") &"</strong></font>,<br>&nbsp;���Ǳ�վ��"& Vip &"�û�,���ѳɹ���½! <br><br>[<a href=""?exit=true"">�˳�����</a>] [<a href=""UpdatePassWord.asp"">�޸�����</a>]<br><br><br><br><br><br>")
			Response.Write "</td></tr>"
		Else
			Response.Write "<form name=""form1"" method=""post"" action="""">"
			Response.Write "<tr><td width=""40%"" align=""center""><strong>��Ϸ�˺�</strong></td><td width=""60%""><input name=""UserName"" type=""text"" class=""user"" id=""UserName"" size=""10""></td>"
			Response.Write "</tr><tr><td align=""center""><strong>�ܡ�����</strong></td>"
			Response.Write "<td><input name=""PassWord"" type=""password"" class=""user"" id=""PassWord"" size=""10""></td>"
			Response.Write "</tr><tr><td align=""center""><strong>�� �� ��</strong></td>"
			Response.Write "<td><input height=""29"" name=""getcode"" type=""text"" class=""user"" id=""getcode"" size=""10""><input name=""login"" type=""hidden"" id=""login"" value=""true""><input name=""id"" type=""hidden"" id=""login"" value=""false"">"
			Response.Write "</td></tr><tr><td ></td><td >"
			Vcode()
			Response.Write "</td></tr><tr><td colspan=""2"" height=""69px"" align=""center""><input name=""imageField"" type=""image"" src=""images/login_button.jpg"" width=""98"" height=""33"" border=""0"">"
			Response.Write "</td></tr><tr><td colspan=""2"" id=""err"" align=""center"" style=""height:1px"">"
			CheckLogin()				
			Response.Write "</td></tr><tr><td colspan=""2""><table width=""100%"" border=""0"" align=""center"" cellpadding=""1"" cellspacing=""0"">"
			Response.Write "<tr><td><img src=""img/title_login_m2.gif"" width=""14"" height=""12""> <a href=""reg.asp"">ע���ʺ�</a></td><td>"
			Response.Write "<img src=""img/title_login_m3.gif"" width=""14"" height=""12"" border=""0""> <a href=""Passwordprotection.Asp"">���뱣��</a> </td></tr><tr><td>"
			Response.Write "<img src=""img/title_login_m1.gif"" width=""14"" height=""12""> <a href=""SSPassWord.asp"">��������</a></td>"
			
			Response.Write "</tr></table></td></tr>"
			Response.Write "</form>"
		End iF
		rem Response.Write "<tr><td colspan=""2""><div align=""center""><img src=""img/showbb.gif""><a href=""payhelp.asp""><img src=""img/logo_buyitem.gif"" width=""100"" height=""60"" border=""0""></a></div></td></tr>"
		Response.Write "</table>"
	End Sub
	
	rem ����Ƿ��½
	Public Function IsCheckLogin()
		IF Not IsLogin Then
		'response.Write IsLogin
			BakErr "����û�е���,���������в���!","Login.asp"
		End IF
	End Function

	rem �޸�����
	Public Sub UpdatePassWord(Typ)'[LogonPass|InsurePass]
	IsCheckLogin()
		IF GetInfo(0,"form","UpPass")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>alert('��֤�����!');</script>"
				Exit Sub
			End IF
			
			IF GetInfo(0,"form","password")<>GetInfo(0,"form","password2") Then
				Response.Write "<script>err.innerHTML='<strong><font color=#000000>������������벻��ͬ!</font></strong>'</script>"
				Exit Sub
			Else
				DbConn(RLWebDBPrefix&"GameUserDb")
				IF Typ="InsurePass" And Session("IsBox")=False Then
					Set md5= New MD5obj
					GetPassWord=SetPassword(GetInfo(0,"form","UserName"))
					Set Rs=Conn.Execute("Exec GSP_GP_UpdatePassWord2 "& Session("UserID") &",'"& GetPassWord &"','"& md5.calcMD5(GetInfo(0,"form","PassWord")) &"','"&Typ&"'")
					Response.Write "<script>err.innerHTML='<strong><font color=#000000>"& Rs(0) &"</font></strong>'</script>"
					IF Left(Rs(0),2)="�ɹ�" Then
						Session("IsBox")=True
					End IF
					Set Md5=Nothing
				Else
					Set md5= New MD5obj
					Set Rs=Conn.Execute("Exec GSP_GP_UpdatePassWord "& Session("UserID") &",'"& md5.calcMD5(GetInfo(0,"form","UserName")) &"','"& md5.calcMD5(GetInfo(0,"form","PassWord")) &"','"&Typ&"'")
					Response.Write "<script>err.innerHTML='<strong><font color=#000000>"& Rs(0) &"</font></strong>'</script>"
					Set Md5=Nothing
				End IF
				RsClose:DBClose:Exit Sub
			End IF
		End IF
	End Sub
	
	rem ����˺��Ƿ�����Ϸ��
	Private Function IsWealthGame(UserID)
		DbConn(RLWebDBPrefix&"TreasureDb")
		Set Rs=Conn.Execute("Select UserID From GameScoreLocker Where UserID="& UserID &"")
		IF Not Rs.Eof Then
			BakErr "�Բ���,��Ŀǰ������������Ϸ����(�����,�齱��)��!���ܽ������в���!","Bank.Asp"
		End IF
		RsClose:DbClose
	End Function
	
	Public Sub ServeWealthShow(UserID)
		IsWealthGame(UserID)
		IP = Left(Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'",""),18)
		If IP = "" Then IP = Request.ServerVariables("REMOTE_ADDR")
		
		IF Session("Deposits")="" Or IsEmpty(Session("Deposits")) Then
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set Rs=Conn.Execute("Select Score,InsureScore From GameScoreInfo Where UserID="& UserID &"")
			IF Not Rs.Eof Then
				Session("Deposits")=Rs(1)	
				Session("money")=Rs(0)
			Else 
				Conn.Execute("INSERT INTO GameScoreInfo(UserID,RegisterIP,LastLogonIP) VALUES ("&UserID&",'"& IP &"','"& IP &"')")
				Session("Deposits")=0	
				Session("money")=0	
			End IF
			RsClose:DbClose
		End IF
	End Sub
	
	Public Sub ServeWealth()
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "��������ӱ���Ϊ����,���Ҳ��ܴ�����������!",""
				Exit Sub
			End IF
			money=GetInfo(1,"form","money2")
			IF Money<1 Then
				BakErr "�����ֽ�Ϊ��!���ܽ��д����Ӳ���",""
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set Rs=Conn.Execute("Exec GSP_GP_ServeWealth "& Session("UserID") &","& money &",'"& Cip &"'")
			Errinfo=RS(0)
			RsClose:DbClose
			IF Left(Errinfo,4)="�ɹ���Ϣ" Then
				Session("Deposits")=Empty	
				Session("money")=Empty	
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow(Session("UserID"))
	End Sub	
	
	Public Sub ServeWealth222()
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "��������ӱ���Ϊ����,���Ҳ��ܴ�����������!",""
				Exit Sub
			End IF
			money=GetInfo(1,"form","money2")
			IF Money<1 Then
				BakErr "�����ֽ�Ϊ��!���ܽ��д����Ӳ���",""
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set Rs=Conn.Execute("Exec Wh_Serve "& Session("UserID") &","& money &"")
			Errinfo=RS(0)
			RsClose:DbClose
			IF Left(Errinfo,4)="�ɹ���Ϣ" Then
				Session("Deposits")=Empty	
				Session("money")=Empty	
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow(Session("UserID"))
	End Sub
	
	rem ���д�ȡ
	Public Sub ReceiveWealth()
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "��������ӱ���Ϊ����,���Ҳ��ܴ�����������!",""
				Exit Sub
			End IF
			money=GetInfo(1,"form","money2")
			IF Money<1 Then
				BakErr "����ȡ������Ϊ��!���ܽ���ȡ���Ӳ���",""
				Exit Sub
			End IF
			DbConn(RLWebDBPrefix&"TreasureDb")
			Set md5= New MD5obj
			BPassWord=md5.calcMD5(GetInfo(0,"form","PassWord"))
			Set Md5=Nothing
			
			IF Session("IsBox")=False Then
				GetPassWord=SetPassword(GetInfo(0,"form","PassWord"))			
				Set Rs=Conn.Execute("Exec GSP_GP_ReceiveWealth2 "& Session("UserID") &","& money &",'"& BPassWord &"','"& GetPassWord &"'")
			Else
				Set Rs=Conn.Execute("Exec GSP_GP_ReceiveWealth "& Session("UserID") &","& money &",'"& BPassWord &"','"& Cip &"'")
			End IF
			
			Errinfo=RS(0)
			RsClose:DbClose
			IF Left(Errinfo,4)="�ɹ���Ϣ" Then
				Session("Deposits")=Empty	
				Session("money")=Empty
				Session("IsBox")=True	
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow(Session("UserID"))
	End Sub
	
	rem ת��
	Public Sub Transfers()
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			GameID=GetInfo(1,"form","UserID")
			GameName=GetInfo(0,"form","UserName")
			
			IF Session("UserID")=GameID Then
				BakErr "���ܶ�����ת��!",""
				Exit Sub
			End If
			
			IF Not Isnumeric(GetInfo(0,"form","money2")) Or instr(GetInfo(0,"form","money2"),".")>0 Then
				BakErr "ת�ʵ����ӱ���Ϊ����,���Ҳ��ܴ�����������!",""
				Exit Sub
			End IF
			
			Money=GetInfo(1,"form","money2")
			IF Money<1 Then
				BakErr "����ת������Ϊ�����!���ܽ���ȡ���Ӳ���",""
				Exit Sub
			End IF
			IF Clng(Session("Deposits"))<Money Or (Clng(Session("Deposits"))-Money)<BMoney Then
				BakErr "���б�����"& BMoney &"����������!",""
				Exit Sub
			End IF
			
			IF Money>EMoney Then
				BakErr "�Բ���,��һ�����ֻ��ת"& EMoney &" ������!",""
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
			IF Session("IsBox")=False Then
				GetPassWord=SetPassword(GetInfo(0,"form","PassWord"))
				Set Rs=Conn.Execute("Exec GSP_GP_Transfers2 "&Session("UserID")&",'"&Session("UserName")&"','"& BPassWord &"',"&GameID&",'"&GameName&"',"& BMoney &","& AMoney &","& Money &","& EMoney &",'"& GetPassWord &"'")
			Else
				Set Rs=Conn.Execute("Exec GSP_GP_Transfers "&Session("UserID")&",'"&Session("UserName")&"','"& BPassWord &"',"&GameID&",'"&GameName&"',"& BMoney &","& AMoney &","& Money &","& EMoney &",'"&Cip&"'")
			End IF
			Errinfo=RS(0)
			RsClose:DbClose
			Errinfo=Replace(Errinfo,Chr(13),"")
			Errinfo=Replace(Errinfo,Chr(10),"")
			Errinfo=Replace(Errinfo,"@DMoney",EMoney)
			Errinfo=Replace(Errinfo,"@GameName",GameName)
			Errinfo=Replace(Errinfo,"@money",Money)
			Errinfo=Replace(Errinfo,"@amoney",AMoney)
			Errinfo=Replace(Errinfo,"@Bmoney",BMoney)
			IF Left(Errinfo,4)="�ɹ���Ϣ" Then
				Session("Deposits")=Empty	
				Session("money")=Empty
				Session("IsBox")=True	
			End IF
			BakErr Errinfo,""
			Exit Sub
		End IF
		ServeWealthShow(Session("UserID"))
	End Sub
	
	rem ���뱣��
	Public Sub ProCode()
		IsCheckLogin()
		DbConn(RLWebDBPrefix&"GameUserDb")
		Set Rs=Conn.Execute("Select PassWordCode From AccountsInfo Where UserID="& Session("UserID") &"")
		IF Not Rs.Eof Then
			If Not IsNull(Rs(0)) And Rs(0)<>"" Then
				Errinfo="�Բ���,���Ѿ����������뱣��!"
				BakErr Errinfo,""
				RsClose:DbClose
			End IF
		End IF
		IF GetInfo(0,"form","loginsev")="true" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			
			IF GetInfo(0,"form","Code")="" Or Len(GetInfo(0,"form","Code"))<6 Then
				BakErr "�Բ���!��ȫ�벻��Ϊ��,����������������6λ",""
				Exit Sub
			End IF
			
			IF GetInfo(0,"form","Code")=Session("UserName") Then
				BakErr "�Բ���,��ȫ�벻�ܺ��û�����ͬ!",""
				Exit Sub
			End IF
			IF Isnumeric(GetInfo(0,"form","Code")) Then
				BakErr "��ȫ�벻��Ϊ������!��������ĸ�����ֻ��,���Ҽ�����رʼǱ���!",""
				Exit Sub
			END if
			IF GetInfo(0,"form","Code")<>GetInfo(0,"form","Code2") Then
				BakErr "��������İ�ȫ�벻��ȷ!",""
				Exit Sub
			END if
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set md5= New MD5obj
			PassWord=md5.calcMD5(GetInfo(0,"form","PassWord"))
			BPassWord=md5.calcMD5(GetInfo(0,"form","BankPassWord"))
			ProCode2=md5.calcMD5(GetInfo(0,"form","Code"))
			ProCodes=GetInfo(0,"form","Code")
			Set Md5=Nothing
			Set Rs=Conn.Execute("Exec GSP_GP_ProCode "& Session("UserID") &",'"&PassWord&"','"&BPassWord&"','"&ProCodes&"','"& ProCode2 &"'")
			Errinfo=Rs(0)
			RsClose:DbClose
			BakErr Errinfo,"Index.asp"
			Exit Sub
		End IF
	End Sub
	
	rem �һ�����
	Public Sub FindPassWord()
		IF GetInfo(0,"form","rlogin")="true" Then
			IF Session("FindPassWordCount")="" Or IsEmpty(Session("FindPassWordCount")) Then
				Session("FindPassWordCount")=0
			End IF
			Session("FindPassWordCount")=Session("FindPassWordCount")+1
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			IF Session("FindPassWordCount")>=6 Then
				BakErr "�������Ĵ�������!","index.asp"
				Exit Sub
			End IF
			
			ProCodes=GetInfo(0,"form","Code")
			IF ProCodes="" Or Len(ProCodes)<6 Or IsNull(ProCodes) Then
				BakErr "��ȫ�����!",""
				Exit Sub
			End IF
			IF GetInfo(0,"form","PassWord")=ProCodes Or GetInfo(0,"form","BankPassWord")=ProCodes Then
				BakErr "��������벻�ܺͰ�ȫ����ͬ!","index.asp"
				Exit Sub
			End IF
			Set md5= New MD5obj
			PassWord=md5.calcMD5(GetInfo(0,"form","PassWord"))
			BPassWord=md5.calcMD5(GetInfo(0,"form","BankPassWord"))
			Set Md5=Nothing
			UserName=GetInfo(0,"form","UserName")
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Exec GSP_GP_FindPassWord '"& UserName &"','"&PassWord&"','"&BPassWord&"','"&ProCodes&"'")
			Errinfo=Rs(0)
			RsClose:DbClose
			BakErr Errinfo,"Index.asp"
		End IF
	End Sub
	
	rem ������ת
	Public Sub GameGuanze()
		DbConn(RLWebDBPrefix&"ServerInfoDb")
		Set Rs=Conn.Execute("Select GzUrl From GameKindItem Where KindID="& GetInfo(1,"form","KindID") &"")
		IF Not Rs.Eof Then
			Response.Redirect("/guizhi/"&Rs(0))
			RsClose:DbClose
			Response.End
		End IF
		RsClose:DbClose
	End Sub
	
	rem ������ת
	Public Sub GameDown()
		IF GetInfo(1,"form","KindID")=0 Then			
			Response.Redirect("/down/plaza.exe")			
			exit sub
			Response.End
		end if
		DbConn(RLWebDBPrefix&"ServerInfoDb")
		Set Rs=Conn.Execute("Select ProcessName From GameKindItem Where KindID="& GetInfo(1,"form","KindID") &"")
		IF Not Rs.Eof Then
			Response.Redirect("/down/"&Rs(0))
			RsClose:DbClose
			Response.End
		End IF
		RsClose:DbClose
	End Sub
	
	Public Sub PassWordSS ()
		IF GetInfo(0,"form","sspassword")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>codeerr.className='box4';codeerr.innerHTML='����:��֤�����,����������!';</script>"
				Exit Sub
			End IF
			Dim UTel,Txt,NNCODE
			UserName=GetInfo(0,"form","UserName")
			Ncode=GetInfo(0,"form","Ncode")
			Nmail=GetInfo(0,"form","Nmail")
			Nadd=GetInfo(0,"form","Nadd")
			PassW=GetInfo(0,"form","PassW")
			PassD=GetInfo(0,"form","PassD")
			UTel=GetInfo(0,"form","Tel")
			Txt=Left(GetInfo(0,"form","Txt"),350)
			IF UserName="" Or Ncode="" Or Nmail="" Or Nadd="" Or PassW="" Or PassD="" Or UTel="" Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='��������Ϊ����,����ϸ��д��ע��ʱ������';</script>"
				Exit Sub
			End IF
			Randomize Timer
			NNCODE=Int(1000000 * Rnd * Rnd * Rnd)
            NNCODE=Left(NNCODE,6)
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Select UserID From AccountsInfo Where Accounts='"& UserName &"'")
			IF Rs.Eof Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='��������û���������!';</script>"
				RsClose:DbClose
				Exit Sub
			End IF
			Conn.Execute("Exec GetPassWord '"& UserName &"','"& Nmail &"','"& PassW &"','"& PassD &"','"& Ncode &"','"& Nadd &"','"& UTel &"','"& Txt &"','"& NNCODE &"'")
			IF Request.Cookies("passwordsh")("reg")="abb" Then
				Response.Cookies("passwordsh")("reg")="abbabb"
			Else
				Response.Cookies("passwordsh")("reg")="abb"
			End IF
			Response.Cookies("passwordsh").Expires=date+1
			Response.Write "<form id=""forma"" action=""Ssshow.Asp"" method=""post"">"
			Response.Write "<input type=""hidden"" name=""nncode"" id=""nncode"" value="& nncode &"></form>"
			Response.Write "<script type=""text/javascript"">"
			Response.Write "forma.submit();"
			Response.Write "</script>"
		End IF
	End Sub
	
	Public Sub SSSelect()
		IF GetInfo(0,"form","ssselect")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:��֤�����,����������!';</script>"
				Exit Sub
			End IF
			UserName=GetInfo(0,"form","UserName")
			Ncode=GetInfo(0,"form","code")
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Select UserID,PassWord From PassWordList Where UserID='"& UserName &"' Order By ID Desc")
			IF RS.EOF THEN
				RsClose:DbClose
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:���û�û�����߻����������벻��ȷ!';</script>"
				Exit Sub
			Else
				IF Rs(1)<>Ncode Then
					RsClose:DbClose
					Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:���û�û�����߻����������벻��ȷ!';</script>"
					Exit Sub
				End IF
				'Session("UserNameUbb")=UserName
			End IF
			RsClose
			Dim U
			Response.Write "<table width=""100%"" border=""0"" cellpadding=""5"" cellspacing=""0"" class=""box"">"
        	Response.Write "<tr><td width=""13%"" background=""img/q03.jpg""> <div align=""center""><font color=""#FFFFFF"">�û���</font></div></td>"
            Response.Write "<td width=""19%"" background=""img/q03.jpg""> <div align=""center""><font color=""#FFFFFF"">����ʱ��</font></div></td>"
            Response.Write "<td width=""68%"" background=""img/q03.jpg""> <div align=""center""><font color=""#FFFFFF"">���߽��</font></div></td></tr>"
            Set Rs=Conn.Execute("Select Top 1 UserID,IsCut,SSDate,PassWord2 From PassWordList Where UserID='"& UserName &"' Order By ID Desc")
            Do While Not Rs.Eof
			IF Rs(1)=0 Then
				U="�ȴ�����..."
			End IF
			IF Rs(1)=1 Then
				U="���߳ɹ�:"
			End IF
			IF Rs(1)=2 Then
				U="����ʧ��:"
			End IF
          	Response.Write "<tr><td><div align=""center"">"& Rs(0) &"</div></td>"
			Response.Write "<td><div align=""center"">"& Rs(2) &"</div></td>"
			Response.Write "<td><div align=""center"">"& U & Rs(3) &"</div></td></tr>"
          	Rs.MoveNext
			Loop
			RsClose:DbClose
		    Response.Write "</table>"
		End IF
	End Sub
	
	rem �û�ע��
	Public Sub UserReg()
		IF GetInfo(0,"form","reg")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>codeerr.className='box4';codeerr.innerHTML='����:��֤�����,����������!';</script>"
				Exit Sub
			End IF
			UserName=GetInfo(0,"form","UserName")
			PassWord=Cstr(GetInfo(0,"form","PassWord"))
			PassWordTo=Cstr(GetInfo(0,"form","PassWord2"))
			BankPassWordTo=Cstr(GetInfo(0,"form","BankPassWord2"))
			BankPassWord=Cstr(GetInfo(0,"form","BankPassWord"))
			IF UserName="" Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û�������Ϊ��!';</script>"
				Exit Sub
			End IF
			IF Not IsCheckUserName(UserName) Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û������зǷ����ַ��뻻���û���!';</script>"
				Exit Sub
			End IF
			
			IF PassWord="" Or Len(PassWord)<6 Or Not IsCheckPassWord(PassWord) Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:���ĵ���������ڼ�,Ϊ�˷�ֹ���뱻��,���ȱ��볬��6λ,���Ҳ�Ҫ��123456,111111,888888,AAAAAA�ȼ��ַ���Ϊ��������!';</script>"
				Exit Sub
			End IF
			IF PassWord=UserName Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:�������벻�����û�����ͬ!';</script>"
				Exit Sub
			End IF
			IF PassWord<>PassWordTo Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:����������ĵ������벻һ��!';</script>"
				Exit Sub
			End IF
			
			IF BankPassWord="" Or Len(BankPassWord)<6 Or Not IsCheckPassWord(BankPassWord) Then
				Response.Write "<script>BankPassWorderr.className='box4';BankPassWorderr.innerHTML='����:��������������ڼ�,Ϊ�˷�ֹ���뱻��,���ȱ��볬��6λ,���Ҳ�Ҫ��123456,111111,888888,AAAAAA�ȼ��ַ���Ϊ��������!';</script>"
				Exit Sub
			End IF
			
			IF BankPassWord=UserName Then
				Response.Write "<script>BankPassWorderr.className='box4';BankPassWorderr.innerHTML='����:�������벻�����û�����ͬ!';</script>"
				Exit Sub
			End IF
			
			IF BankPassWord=PassWord Then
				Response.Write "<script>BankPassWorderr.className='box4';BankPassWorderr.innerHTML='����:�������벻�������������ͬ!';</script>"
				Exit Sub
			End IF
			
			IF BankPassWord<>BankPassWordTo Then
				Response.Write "<script>BankPassWorderr.className='box4';BankPassWorderr.innerHTML='����:������������������벻һ��!';</script>"
				Exit Sub
			End IF
			Sex=GetInfo(1,"form","Sex")
			F=GetInfo(1,"form","FF")
			Ncode=GetInfo(0,"form","Ncode")
			Nmail=GetInfo(0,"form","Nmail")
			Nadd=GetInfo(0,"form","Nadd")
			PassW=GetInfo(0,"form","PassW")
			PassD=GetInfo(0,"form","PassD")
			IF Ncode="" Or Nmail="" Or Nadd="" Or PassW="" Or PassD="" Then
				Response.Write "<script>getpass.className='box4';getpass.innerHTML='����:���������Ϊ����,����ַ��д,���ܻ�����һ������йؼ�����';</script>"
				Exit Sub
			End IF
			
			
			F=F-1
			IP = Left(Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'",""),18)
			If IP = "" Then IP = Request.ServerVariables("REMOTE_ADDR")
			Set md5= New MD5obj
			PassWord=md5.calcMD5(PassWord)
			BankPassWord=md5.calcMD5(BankPassWord)
			Set Md5=Nothing
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Exec GSP_GP_UserReg '"& UserName &"','"& PassWord &"','"& BankPassWord &"',"& Sex &","& F &",'"& IP &"','"& Ncode &"','"& Nmail &"','"& Nadd &"','"& PassW &"','"& PassD &"'")
			IF Rs(0)=0 Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û����ѱ�ע��!';</script>"
				RsClose:DbClose
				Exit Sub
			Else
				Response.Cookies("cxgame")("reg")="reok00"
				Response.Cookies("cxgame").Expires=date+1
				BakErr "���ѳɹ�ע��,����ID����:"&Rs(2),"EndReg.Asp?ID="&Rs(2)
				RsClose:DbClose
				Exit Sub
			End IF
			
		End IF
	End Sub
	
	Public Sub EyUserReg()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				Response.Write "<script>codeerr.className='box4';codeerr.innerHTML='����:��֤�����,����������!';</script>"
				Exit Sub
			End IF
			UserName=GetInfo(0,"form","UserName")
			PassWord=Cstr(GetInfo(0,"form","PassWord"))
			PassWordTo=Cstr(GetInfo(0,"form","PassWord2"))
			IF UserName="" Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û�������Ϊ��!';</script>"
				Exit Sub
			End IF
			IF Not IsCheckUserName(UserName) Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û����в����й���Ա,��Ϸ����,�ͷ����ַ�!';</script>"
				Exit Sub
			End IF
			
			IF PassWord="" Or Len(PassWord)<6 Or Not IsCheckPassWord(PassWord) Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:���ĵ���������ڼ�,Ϊ�˷�ֹ���뱻��,���ȱ��볬��6λ,���Ҳ�Ҫ��123456,111111,888888,AAAAAA�ȼ��ַ���Ϊ��������!';</script>"
				Exit Sub
			End IF
			IF PassWord=UserName Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:�������벻�����û�����ͬ!';</script>"
				Exit Sub
			End IF
			IF PassWord<>PassWordTo Then
				Response.Write "<script>passworderr.className='box4';passworderr.innerHTML='����:����������ĵ������벻һ��!';</script>"
				Exit Sub
			End IF
			
			Sex=GetInfo(1,"form","Sex")
			F=GetInfo(1,"form","FF")
			F=F-1
			IP = Left(Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'",""),18)
			If IP = "" Then IP = Request.ServerVariables("REMOTE_ADDR")
			Set md5= New MD5obj
			PassWord=md5.calcMD5(PassWord)
			BankPassWord=md5.calcMD5(BankPassWord)
			Set Md5=Nothing
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Exec GSP_GP_UserReg '"& UserName &"','"& PassWord &"','"& PassWord &"',"& Sex &","& F &",'"& IP &"'")
			IF Rs(0)=0 Then
				Response.Write "<script>usernameerr.className='box4';usernameerr.innerHTML='����:�û����ѱ�ע��!';</script>"
				RsClose:DbClose
				Exit Sub
			Else
				BakErr "���ѳɹ�ע��,����ID����:"&Rs(2),"EndReg.Asp?ID="&Rs(2)
				RsClose:DbClose
				Exit Sub
			End IF
			
		End IF
	End Sub
	
	
	rem ��ֵ
	Public Sub Pay()
	    Dim vip
		IsCheckLogin()
		IsWealthGame(Session("UserID"))
			IF GetInfo(0,"form","login")="true" Then
				IF Not CodeIsTrue Then
					BakErr "���������֤�벻��ȷ!",""
					Exit Sub
				End IF
				CardCode=GetInfo(0,"form","CardCode")
				CardPass=GetInfo(0,"form","CardPass")
				IF Not Isnumeric(CardCode) Or Not Isnumeric(CardPass) Then
					BakErr "�Բ���,��Ŀ��Ż��������!",""
					Exit Sub
				End IF
				
				Set md5= New MD5obj
			    CardPass=md5.calcMD5(CardPass)
			    
				DbConn("QPTreasureDB")
				Set Rs=Conn.Execute("Exec Web_FilledLivCard "& CardCode &",'"& CardPass &"',"& Session("UserID") &"")
				Errinfo=Rs(0)	
				
				IF Left(Errinfo,4)="�ɹ���Ϣ" Then
				    vip=Rs(1)
					Session("Deposits")=Empty	
					Session("money")=Empty
					Session("Vip")=vip
				End IF
				RsClose:DbClose
				BakErr Errinfo,""
				Exit Sub
			End IF
	End Sub
	
	rem ����ͷ��
	Public Sub UpdateFF()
		IsCheckLogin()
		IF GetInfo(0,"form","login")="true" Then
			IF Not CodeIsTrue Then
				BakErr "���������֤�벻��ȷ!",""
				Exit Sub
			End IF
			F=GetInfo(1,"form","FF")
			F=F-1
			DbConn(RLWebDBPrefix&"GameUserDb")
			Conn.Execute ("Update AccountsInfo Set FaceID="& F &" Where UserID="& Session("UserID") &"")
			DbClose
			BakErr "����ͷ��ɹ�!",""
		End IF
	End Sub
	
	rem ͷ������
	Rem ���÷�ʽ NewsObj.NewsTop "100",10,15,"CssName"
	Public Sub NewsTop(ClassCode,Top,TitleLen,Css)
		Response.Write "<ul>"
		DBConn("News")
		Dim Title
		
		Set Rs=Conn.Execute("Select Top "& Top &" Id,Newstitle,Newsdate From News Where ClassCode Like '"& ClassCode &"%' Order By ID DESC")
		Do While Not Rs.Eof
			Title=Rs(1)
			IF Len(Title)>TitleLen Then
				Title=Left(Title,TitleLen) & ".."
			End IF
			Response.Write "<li>.<a class="""& Css &""" href=""show.asp?id="& Rs(0) &""" title="""& Rs(1) &""">"& Title &"</a></li>"
		Rs.MoveNext
		Loop
		Rs.Close:Set Rs=Nothing
		Conn.Close:Set Conn=Nothing
		Response.Write "</ul>"
	End Sub
	
	rem ��ʾ��������
	Rem ���÷�ʽ NewsObj.NewsShow
	Public Sub NewsShow()
		Dim ID,Show
		ID=Request("ID")
		IF Not Isnumeric(ID) then
			Response.Write "�Ƿ�ID��!"
			Response.End
		End if
		DBConn("News")
		Set Rs=Conn.Execute("Select Newstitle,Newsinfo,Newsdate From News Where ID="& ID &"")
		IF Not Rs.Eof Then
			Show=Rs("Newsinfo")
			Response.write "<h1>"&Rs("newstitle")&"</h1>"
			Response.write "<div id=""show"">"& Show &"</div>"
		End if
		Rs.Close:Set Rs=Nothing
		Conn.Close:Set Conn=Nothing	
	End Sub
	
	rem ��ҳ
	Public Sub goPage(pagecount,page)
		Dim query, a, x, temp,action,Table_style,font_style
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
	
	Rem �����б�
	Rem ���÷�ʽ NewsObj.NewsList "100",20
	Public Sub NewsList(ClassCode,Top)
		DBConn("News")
		IF ClassCode="" Then
			ClassCODE=Request("ClassCode")
		End IF
		IF Not Isnumeric(ClassCODE) Then
			ClassCODE=1
		End IF
		
		Set Rs=Server.Createobject("Adodb.Recordset")
		Rs.Open "Select ID,ClassCode,NewsTitle,NewsDate From News Order By ID Desc",Conn,1,1
		Rs.PageSize =Top
		Dim Result_n
		Result_n=Rs.RecordCount 
		Response.Write "<table width=""96%"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""1"">"
		If Result_n>0 then
			Maxpage=Rs.PageCount 
			Page=Request("page")	
			If Not IsNumeric(Page) or Page="" then
				Page=1
			Else
				Page=cint(Page)
			End if
			'Response.write Result_n
			If page<1 then
				page=2
			Elseif  page>maxpage then
				page=maxpage
			End if	
			Rs.AbsolutePage=Page

			Response.Write "<tr><td height=""26""><table width=""98%"" border=""0"" align=""center"" cellpadding=""0"" cellspacing=""1"">"
		Else
			Rs.Close:Set Rs=Nothing
			Conn.Close:Set Conn=Nothing	
			Response.Write "<tr><td height=""26"" bgcolor=""ffffff"">�Բ���,û���κ���Ϣ!</td></tr></table>"

			Response.End
		End IF
		For i=1 to Top
			Response.Write "<tr>"
			Response.Write "<td width=""5%"" height=26><div align=""center"">.</div></td>"
			Response.Write "<td width=""95%""><a href=show.asp?id="& Rs("id") &">"& Rs("newstitle") & "</a>  ["& Rs("newsdate")& "]</td>"
			Response.Write "</tr>"
			Rs.MoveNext
			IF Rs.Eof Then Exit For
		Next
		Response.Write "</table>"
		Rs.Close:Set Rs=Nothing
		Conn.Close:Set Conn=Nothing	
		Response.Write "</td></tr>"
		Response.Write "<tr>"
		Response.Write "<td height=""26""><div align=""right"">"
                goPage maxpage,page
		Response.Write "</div></td>"
		Response.Write "</tr></table>"
	End Sub
	
	Public Sub ReOk()
		IF GetInfo(0,"form","add")="ok" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
		Dim Ip
		IP = Left(Replace(Request.ServerVariables("HTTP_X_FORWARDED_FOR"),"'",""),18)
		If IP = "" Then IP = Request.ServerVariables("REMOTE_ADDR") 
		IP=Replace(ip,"'","")
		
			DBConn("News")
			Conn.Execute("INSERT INTO [Re]([UserName],[ATxt],[Act]) VALUES ('"& IP &"','"& GetInfo(0,"form","txt") &"',0)")
			DbClose
			BakErr "���ʳɹ�,����Ա����һ��ʱ��������ظ�!",""
		End IF
	End Sub
	
	rem �ٱ�
	Public Sub JBOk()
		IF GetInfo(0,"form","add")="ok" Then
			IF Not CodeIsTrue Then
				BakErr "��֤�����!",""
				Exit Sub
			End IF
			DBConn("News")
			Conn.Execute("INSERT INTO [Re]([UserName],[ATxt],[Act]) VALUES ('������','"& GetInfo(0,"form","txt") &"',1)")
			DbClose
			BakErr "�ٱ��ɹ�,�ȴ�����Ա���!",""
		End IF
	End Sub
	
	rem �ͷ�
	Public Sub ReList()
		DBConn("News")
		Set Rs=Server.Createobject("Adodb.Recordset")
		Rs.Open "Select * From Re Where Act=0 And not Btxt Is Null Order By ID DESC",Conn,1,1
		Rs.PageSize =10
		Dim Result_n,Maxpage,page,i
		Result_n=Rs.RecordCount 
		If Result_n>0 then
			Maxpage=Rs.PageCount 
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
			Rs.AbsolutePage=Page
		Else
		   Response.Write "û���κ���Ϣ!"
		   Response.END
		End IF
		For i=1 to 10
			Response.Write "<table width=100% border=0 cellpadding=5 cellspacing=1 bgcolor=#CCCCCC>"
			Response.Write "<tr><td bgcolor=#FFFFFF class=tw><p>����:"& Rs("Atxt") &" </p></td></tr>"
			IF Rs("Btxt")<>"" Then
				Response.Write "<tr><td bgcolor=""#FFFFFF"" class=re>�ظ�:"& Rs("Btxt") &"</td></tr>"
			End IF
			Response.Write "</table>"
			Response.Write "<br>"
			Rs.MoveNext
			IF Rs.Eof Then Exit For
		Next
		'Response.write MaxPage
		goPage maxpage,page
		RsClose:DbClose
	End Sub
	
	Public Sub GameCls()
		IsCheckLogin()
		IF GetInfo(0,"form","cls")="true" Then
			IF Not CodeIsTrue Then
				BakErr "���������֤�벻��ȷ!",""
				Exit Sub
			End IF
			Dim DbName,ErrCls,IsGame
			DbName=Replace(GetInfo(0,"form","GameDb"),RLWebDBPrefix&"TreasureDB","")
			Select Case LCase(DbName)
				case LCase(RLWebDBPrefix&"CXLandDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"LandDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"ChinaChessDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"GoBangDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"UpGradeDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"PlaneDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"UncoverPigDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"WeiQiDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"FourEnsignDB"):
					IsGame=1
				case LCase(RLWebDBPrefix&"DouShouQiDB"):
					IsGame=1
				case LCase("llshow_cx"):
					IsGame=1
				case else:
					IsGame=0
			End Select
			
			IF DbName<>"" And IsGame=1 Then
				DbConn60(DbName)
				Set Rs=Conn.Execute("Exec Gsp_Cls "& Session("UserID") &"")
				ErrCls=Rs(0)
				RsClose:DbClose
				BakErr ErrCls,""
			End IF
		End IF
	End Sub
		
		
		
	Public Sub AddCahe(CaheName,CaheInfo)
        Application.Lock
        Application(CaheName)=CaheInfo
        Application.unLock
	End Sub
	Public Sub EmptyCahe(CaheName)
        Application.Lock
        Application(CaheName)=Empty
        Application.unLock
	End Sub
	
    Public Sub DelCahe(CaheName)
		Dim Arr,U
		Arr=Split(CaheName,"|")
        Application.Lock
			For U=0 To UBound(Arr)
				Application.Contents.Remove (Arr(U))
			Next
        Application.unLock
    End Sub
	
    Public Function Cahe(CaheName)
        Cahe=Application(CaheName)
    End Function
	
    Public Function IsCaheEmpty(CaheName)
		IsCaheEmpty=True
		IF IsEmpty(Application(CaheName)) Then
			IsCaheEmpty=False
		End IF
    End Function
	
    Public Function IsCaheArr(CaheName)
		IsCaheArr=False
		IF IsArray(Application(CaheName)) Then
			IsCaheArr=True
		End IF
    End Function

	Public Sub ScoreTop()
		Response.Write "<table width=""100%"" border=""0"" align=""center"" cellpadding=""5"" cellspacing=""0"" class=""boxlogin"">"
		Response.Write "<tr valign=""middle""><td height=""35"" colspan=""6"" bgcolor=""#FFFFFF"" background=""img/index_title_bg.gif""><strong>" & Request.QueryString("GameName") & " �������а�(ǰ50ǿ)</strong> �������а񲢲���ʵʱ��,��Լ���������һ����һ��</td>"
		Response.Write "</tr><tr bgcolor=""#efefef""><td width=""66"" valign=""top"">����</td><td width=""101"" valign=""top"">�û���</td><td width=""89"" valign=""top"">����</td>"
		Response.Write "<td width=""90"" valign=""top"">ʤ��</td><td width=""89"" valign=""top"">���</td><td width=""90"" valign=""top"">�;�</td></tr>"
		Dim GameDb,IsGame
		GameDB=GetInfo(0,"form","Game")
		GameDB=Replace(GameDB,"'","")
		GameDB=Replace(GameDB,";","")
		GameDB=Replace(GameDB,":","")
		Select Case LCase(GameDB)
			case LCase("CXLand"):
				IsGame=1
			case LCase("Land"):
				IsGame=1
			case LCase("ChinaChess"):
				IsGame=1
			case LCase("GoBang"):
				IsGame=1
			case LCase("UpGrade"):
				IsGame=1
			case LCase("Plane"):
				IsGame=1
			case LCase("UncoverPig"):
				IsGame=1
			case LCase("WeiQi"):
				IsGame=1
			case LCase("FourEnsign"):
				IsGame=1
			case LCase("DouShouQi"):
				IsGame=1
			case LCase("llshow_cx"):
				IsGame=1
			case else:
				IsGame=0
		End Select
		
		IF GameDB<>"" And IsGame=1 Then
			IF LCase(GameDB)<>"llshow_cx" Then
				GameDB=RLWebDBPrefix&""& GameDB &"DB"
			End IF
			IF Not IsCaheEmpty(GameDB) Then
				DbConn60(GameDB)
				Set Rs=Conn.Execute("Select Top 50 us.Accounts,GameScoreInfo.Score,GameScoreInfo.WinCount,GameScoreInfo.LostCount,GameScoreInfo.DrawCount From "&RLWebDBPrefix&"GameUserDBLink."&RLWebDBPrefix&"GameUserDB.dbo.AccountsInfo As Us,GameScoreInfo Where Us.UserID=GameScoreInfo.UserID Order by Score desc")
				IF NOT RS.EOF Then
					AddCahe GameDB,Rs.GetRows()
				End IF
				Rs.Close:Set Rs=Nothing
				Conn.Close:Set Conn=Nothing
			End IF
			
			IF IsCaheArr(GameDB) Then
				Dim J
				For J=0 to Ubound(Cahe(GameDB),2)
					Response.Write "<tr>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& J+1 &"</td>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& Cahe(GameDB)(0,j) &"</td>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& Cahe(GameDB)(1,j) &"</td>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& Cahe(GameDB)(2,j) &"</td>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& Cahe(GameDB)(3,j) &"</td>"
					Response.Write "<td  bgcolor=""#FFFFFF"" class=xbian>"& Cahe(GameDB)(4,j) &"</td>"
					Response.Write "</tr>"		
				Next
			End IF
			End IF
			Response.Write "</table>"
	End Sub
	
	Public Sub YYToCixi()
		IF GetInfo(0,"form","reg")="true" Then
			Dim NewUserName
			UserName=GetInfo(0,"form","UserName")
			NewUserName=GetInfo(0,"form","NewUserName")
			PassWord=Cstr(GetInfo(0,"form","PassWord"))
			BankPassWord=Cstr(GetInfo(0,"form","BnakPass"))
			IF UserName="" Then
				Response.Write "<script>username.className='box4';err.innerHTML='�Բ���,�û�������Ϊ��!';</script>"
				Exit Sub
			End IF
			
			IF NewUserName="" Then
				Response.Write "<script>newu.className='box4';err.innerHTML='�Բ���,�سƲ���Ϊ��!';</script>"
				Exit Sub
			End IF
			
			Ncode=GetInfo(0,"form","Ncode")
			Nmail=GetInfo(0,"form","Nmail")
			Nadd=GetInfo(0,"form","Nadd")
			PassW=GetInfo(0,"form","PassW")
			PassD=GetInfo(0,"form","PassD")
			IF Ncode="" Or Nmail="" Or Nadd="" Or PassW="" Or PassD="" Then
				Response.Write "<script>pbox.className='box4';err.innerHTML='��������д���뱣������,����Ϊ���ĺ��뱻�����ṩ���֤��!';</script>"
				Exit Sub
			End IF
			
			IF Not IsCheckUserName(NewUserName) Then
				Response.Write "<script>newu.className='box4';err.innerHTML='�����õ��س����зǷ��ַ�,���������������س�!';</script>"
				Exit Sub
			End IF
			Set md5= New MD5obj
			PassWord=md5.calcMD5(PassWord)
			BankPassWord=md5.calcMD5(BankPassWord)
			'Response.WRITE BankPassWord
			'Response.End
			Set Md5=Nothing
			DbConn(RLWebDBPrefix&"GameUserDb")
			Set Rs=Conn.Execute("Exec GSP_GP_YyToCixiGame '"& UserName &"','"& NewUserName &"','"& PassWord &"','"& BankPassWord &"','"& Ncode &"','"& Nmail &"','"& Nadd &"','"& PassW &"','"& PassD &"'")
			IF Rs(0)<>"true" Then
				IF Rs(1)="���û��Ѿ����������뱣������!" Then
					Response.Redirect("Downdd.Asp")
					Response.End
				End IF
				Response.Write "<script>"& Rs(0) &".className='box4';err.innerHTML='"& Rs(1) &"';</script>"
				RsClose:DbClose
				Exit Sub
			Else
				BakErr "��д���뱣���ɹ�!�����µ�ID����:"&Rs(2),"YYtoCixiOK.asp?ID="&Rs(2)&"&U="&NewUserName
				RsClose:DbClose
				Exit Sub
			End IF
		End IF
	End Sub
	
End Class

Rem ���������
Dim CxGame
Set CxGame=New GameObj
%>