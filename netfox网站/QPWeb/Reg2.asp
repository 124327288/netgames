<!--#include file="Top.asp" -->
<%
IF Request.form("regok")<>"true" Then
	Response.Redirect("Reg.asp")
	Response.End
End IF
IF Request.Cookies("cxgame")("reg")="reok" Then
	Response.Write "<div align=""center""><font color=""#FF0000"" size=""+2"">�Բ���,����Ϸ����һ��IPһ��ֻ��ע��һ���û�!</font></div>"
	Response.End
End IF
%>
<script language="javascript" src="passwordstrength.js"></script>
<table width="770" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td width="240" valign="top" bgcolor="#FFFFFF"> 
      <!--#include file="left.asp" -->
    </td>
    <td width="588" valign="top" bgcolor="#FFFFFF"><form name="form2" method="post" action="reg2.asp">
        <table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="box3">
          <tr> 
            <td height="35" colspan="2" id="err" background="img/index_title_bg.gif"><font color="#000000"><strong>ע���û�</strong></font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="usernameerr">��½��Ϫ��Ϸ���ĵ��û��������֡���ĸ�����֡��»��ߵȶ���!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td width="104"><div align="center">�û���:</div></td>
            <td width="398"> <input name="UserName" type="text" class="input" id="UserName" value="<%=CxGame.GetInfo(0,"form","UserName")%>" maxlength="8"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="passworderr">�����������ĸ�����ֻ�����,6λ������,��ֹ����!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">����ǿ��:</div></td>
            <td><script language="javascript">
		var psa = new PasswordStrength();
		psa.setSize("220","20");
		psa.setMinLength(1);
	</script></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">��������:</div></td>
            <td> <input name="PassWord" type="password" class="input" id="PassWord" value="<%=CxGame.GetInfo(0,"form","PassWord")%>" maxlength="14" onKeyUp="psa.update(this.value);"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">�ظ�����:</div></td>
            <td> <input name="PassWord2" type="password" class="input" id="PassWord2" value="<%=CxGame.GetInfo(0,"form","PassWord2")%>" maxlength="14"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2" valign="top"><div align="left" class="box3" id="BankPassWorderr">��Ϸ��������,������ת��,ȡ����ʱ��Ҫ�õ���,�����벻Ҫ������������ɺ��û���������������ͬ�����������ĸ�����ֻ��</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td valign="top"><div align="center">����ǿ��:</div></td>
            <td valign="top"><script language="javascript">
		var ps = new PasswordStrength();
		ps.setSize("220","14");
		ps.setMinLength(1);
	</script></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td valign="top"> <div align="center">��Ϸ��������:</div></td>
            <td valign="top"> <div align="left"> 
                <input name="BankPassWord" type="password" class="input" id="PassWord3" value="<%=CxGame.GetInfo(0,"form","BankPassWord")%>" maxlength="20" onKeyUp="ps.update(this.value);">
              </div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">ȷ����������:</div></td>
            <td><input name="BankPassWord2" type="password" class="input" id="BankPassWord2" value="<%=CxGame.GetInfo(0,"form","BankPassWord2")%>" maxlength="20"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="center" class="box3" id="getpass">����Ϊ����,��������ȷ��д,���μ�,���ܻ�����Ժ��һ�������������</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">�����Ա�</div></td>
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="42%"> <select name="sex" id="select">
                      <option value="1" selected>��</option>
                      <option value="0">Ů</option>
                    </select>
                    ѡ��ͷ�� 
                    <select name="ff" id="ff" onChange="fff()">
                      <%
					Dim Y
					for Y=1 To 60 
					%>
                      <option value="<%=y%>"><%=y%></option>
                      <%
					Next
					%>
                    </select> </td>
                  <td width="58%"><div id="f"></div></td>
                </tr>
              </table></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">����:</div></td>
            <td><input name="Nmail" type="text" class="input" id="Nmail" value="<%=CxGame.GetInfo(0,"form","Nmail")%>"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">���֤:</div></td>
            <td><input name="Ncode" type="text" class="input" id="Ncode" value="<%=CxGame.GetInfo(0,"form","Ncode")%>"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">��ַ:</div></td>
            <td><input name="Nadd" type="text" class="input" id="Nadd" value="<%=CxGame.GetInfo(0,"form","Nadd")%>"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������ʾ����:</div></td>
            <td><input name="PassW" type="text" class="input" id="PassW" value="<%=CxGame.GetInfo(0,"form","PassW")%>"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td><div align="center">������ʾ��:</div></td>
            <td><input name="PassD" type="text" class="input" id="Ncode32" value="<%=CxGame.GetInfo(0,"form","PassD")%>"> 
            </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td colspan="2"><div align="left" class="box3" id="codeerr">��֤��:���������������ұߵ�����!</div></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center">��֤��:</div></td>
            <td> <input name="getcode" type="text" class="input" id="GetCode" style="ime-mode:disabled" onkeydown="if(event.keyCode==13)event.keyCode=9"> 
              <%CxGame.Vcode2():CxGame.UserReg()%>
              <input name="reg" type="hidden" id="reg" value="true"><input name="regok" type="hidden" id="regok" value="true"> </td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td> <div align="center"> </div></td>
            <td><input type="submit" name="Submit" value="ע���û�"></td>
          </tr>
        </table>
        <br>
        <br>
      </form> </td>
  </tr>
</table>
<script>
function fff(){
f.innerHTML="<img src=ff/1_"+form1.ff.value+".jpg border=0>";
}
</script>

<!--#include file="copy.asp" -->
