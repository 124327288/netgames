<!--#include file="CommonFun.asp"-->
<!--#include file="conn.asp"-->
<!--#include file="function.asp"-->
<!--#include file="GameConn.asp"-->
<!--#include file="Admin_ChkPurview.asp"-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title></title>
<style type="text/css">
html,body  {
padding:0px;
margin:0px;
background:#009286; font:12px ����;text-decoration: none;
scrollbar-face-color: #c6ebde;
scrollbar-highlight-color: #ffffff; 
scrollbar-shadow-color: #39867b;
scrollbar-3dlight-color: #39867b; 
scrollbar-arrow-color: #330000; 
scrollbar-track-color: #e2f3f1; 
scrollbar-darkshadow-color: #ffffff;}
table  { border:0px; }
td {font:12px ����;}
img  { vertical-align:bottom; border:0px; }
a  { font:normal 12px ����; color:#000000; text-decoration:none; }
a:hover  { color:#cc0000;text-decoration:underline; }
.sec_menu  { border-left:1px solid white; border-right:1px solid white; border-bottom:1px solid white; overflow:hidden; background:#C6EBDE; }
.menu_title  { }
.menu_title span  { position:relative; top:2px; left:8px; color:#39867B; font-weight:bold; }
.menu_title2  { }
.menu_title2 span  { position:relative; top:2px; left:8px; color:#cc0000; font-weight:bold; }
</style>
<script language="javascript1.2" type="text/javascript">
function showsubmenu(sid) {
    whichEl = eval("submenu" + sid);
    if (whichEl.style.display == "none") {
        eval("submenu" + sid + ".style.display='';");
    }
    else  {
        eval("submenu" + sid + ".style.display='none';");
    }
}
</script>
</head>
<body>

<div style="margin:0px; padding:0px; text-align:left;">
<table width="158" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td height="42" valign="bottom"><img src="Images/title.gif" width="158" height="38" /></td></tr>
</table>

<table cellpadding=0 cellspacing=0 width=158 align=center>
<tr>
    <td height=25 class="menu_title" onmouseover="this.className='menu_title2'"; onmouseout="this.className='menu_title'"; background="Images/title_bg_quit.gif" id="menuTitle0"> 
      <span><a href='Admin_Index_Main.asp' target='main'><b>������ҳ</b></a> | 
      <a href='Admin_Login.asp?Action=Logout' target='_top'><b>�˳�</b></a></span> 
    </td>
</tr>
<tr>
<td style="display:" id='submenu0'>
<div class="sec_menu" style="width:158; height:20px; padding:3px 0 0 10px; vertical-align:bottom;">
�û�����<%=AdminName%>
</div>
<div  style="width:158; height:20px;"></div>
</td>
</tr>
</table>

<table cellpadding=0 cellspacing=0 width=158 align=center>
<tr> 
        <td height=25 class=menu_title onmouseover=this.className='menu_title2'; onmouseout=this.className='menu_title'; background="Images/Admin_left_01.gif" id=menuTitle201 onclick="showsubmenu(201)" style="cursor:hand;"> 
          <span>ϵͳ����</span></td>
</tr>
<tr> 
<td style="display:none" id='submenu201'>
<div class="sec_menu" style="width:158"> 
        <table cellpadding="0" cellspacing="0" align="center" width="130">
          <tr>
            <td height="20"><a href="Admin_Admin.asp" target="main">����Ա����</a> | 
              <a href="Admin_AdminModifyPwd.asp" target="main">�޸�����</a></td>
          </tr> 
          <tr><td height="20">
          <a href="Livcard/GameCardCreator.aspx" target="main">�㿨����</a> |             
          <a href="Livcard/GameCardGridInfo.aspx" target="main">�㿨����</a></td></tr>
          <tr style=" background-color:#000; height:1px;"><td></td></tr>
          <!-- <tr><td height="20"><a href="Admin_GameKindItem.asp" target="main">��Ϸ����</a></td></tr> -->
        </table>
</div>
<div  style="width:158; height:20px;"></div>
</td></tr></table>       

<table cellpadding="0" cellspacing="0" width="158" align="center">
<tr> 
     <td height=25 class=menu_title onmouseover=this.className='menu_title2'; onmouseout=this.className='menu_title'; background="Images/Admin_left_03.gif" id="menuTitle208" onclick="showsubmenu(208)" style="cursor:hand;"> 
          <span>��Ա����</span> </td>
</tr>
<tr> 
<td style="display:none" id='submenu208'>
    <div class="sec_menu" style="width:158"> 
    <table cellpadding='0'cellspacing="0" align="center" width="130">
    <tr><td height="20"><a href="Admin_GameUser.asp" target="main">��ҹ���</a></td></tr>

    <!-- <tr><td height="20"><a href="User_AndroidUserManager.aspx" target="main">�����˹���</a></td></tr> -->
    <tr><td height="20"><a href="User_MachineConfine.asp" target="main">����������</a></td></tr>
    <tr><td height="20"><a href="User_IpConfine.asp" target="main">IP ��ַ����</a></td></tr>
    <tr><td height="20"><a href="User_UsernameConfine.asp" target="main">�����û���</a></td></tr>
    </table>
    </div>
    <div  style="width:158; height:20px;"></div>
</td>
</tr>
</table>

<table cellpadding=0 cellspacing=0 width=158 align=center>
<tr> 
       <td height=25 class=menu_title onmouseover=this.className='menu_title2'; onmouseout=this.className='menu_title'; background="Images/Admin_left_03.gif" id="menuTitle202" onclick="showsubmenu(202)" style="cursor:hand;"> 
          <span>��Ϸ����</span> </td>
</tr>
<tr> 
<td style="display:none" id='submenu202'>
    <div class="sec_menu" style="width:158">
    <table cellpadding=0 cellspacing=0 align=center width=130>
    <tr><td height="20"><a href="Admin_GameUserMoney.asp" target="main">��ҹ���</a></td></tr>
    <tr><td height="20"><a href="Admin_GameManager.asp" target="main">���߹���</a></td></tr>
    <tr><td height="20"><a href="Admin_RecordUserEnter.asp" target="main">��Ϸ��¼</a></td></tr>
    <tr><td height="20"><a href="Gold_RecordUserInsure.asp" target="main">���м�¼</a></td></tr>
    <tr><td height="20"><a href="Admin_Static.asp" target="main">����ͳ��</a></td></tr>
    </table>
    </div>
    <div  style="width:158; height:20px;"></div>
</td>
</tr>
</table>

<table cellpadding=0 cellspacing=0 width=158 align=center>
<tr> 
      <td height=25 class=menu_title onmouseover=this.className='menu_title2'; onmouseout=this.className='menu_title'; background="Images/Admin_left_03.gif" id=menuTitle204 onclick="showsubmenu(204)" style="cursor:hand;"> 
          <span>��Ϸ���а�</span> </td>
</tr>
<tr> 
<td style="display:none" id='submenu204'>
    <div class=sec_menu style="width:158"> 
    <table cellpadding=0 cellspacing=0 align=center width=130>
    <%=GetGameList() %>             
    </table>
    </div>
    <div  style="width:158"></div>
</td></tr></table>

<table cellpadding="0" cellspacing="0" width="158" align="center">
<tr>
        <td height=25 class=menu_title onmouseover=this.className='menu_title2'; onmouseout=this.className='menu_title'; background="Images/Admin_left_04.gif" id=Td1> 
          <span style="color:#cccccc;">ϵͳ��Ϣ</span></td>
</tr>
<tr>
<td>
<div class="sec_menu" style="width:158">
<table cellpadding=0 cellspacing=0 align=center width=130>
<tr><td height="35"><br />��Ȩ���У�&nbsp;<a href="http://www.foxuc.cn" target="_blank" Title="������չ������������">��������</a>
<br />
<span style=" margin-left:24px;">�汾��&nbsp;<%=Ver %></span>
</td></tr>
</table>
</div>
</td>
</tr>
</table>

</div>
</body>
</html>