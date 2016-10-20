<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>网站管理中心</TITLE>
<META content=xs20.cn name=author>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
<STYLE>.navPoint {
	FONT-SIZE: 9pt; CURSOR: hand; COLOR: white; FONT-FAMILY: Webdings
}
P {
	FONT-SIZE: 9pt
}
</STYLE>

<SCRIPT>
function switchSysBar(){
	if (switchPoint.innerText==3){
		switchPoint.innerText=4
		document.all("frmTitle").style.display="none"
	}
	else{
		switchPoint.innerText=3
		document.all("frmTitle").style.display=""
	}
}
</SCRIPT>

<META content="MSHTML 6.00.3790.0" name=GENERATOR></HEAD>
<BODY style="MARGIN: 0px" scroll=no>
<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
    <TD id=frmTitle vAlign=center noWrap align=middle name="frmTitle"><IFRAME 
      id=BoardTitle style="VISIBILITY: inherit; WIDTH: 180px; HEIGHT: 100%" 
      border=false name=BoardTitle src="left.asp" 
      frameBorder=0 scrolling=no 2 Z-INDEX: ;></IFRAME>
    <TD style="WIDTH: 8pt" bgColor=#cccccc>
      <TABLE height="100%" cellSpacing=0 cellPadding=0 border=0>
        <TBODY>
        <TR>
          <TD style="HEIGHT: 100%" onclick=switchSysBar()><SPAN class=navPoint 
            id=switchPoint title=关闭/打开左栏><FONT 
        color=#000000>3</FONT></SPAN></TD></TR></TBODY></TABLE></TD>
    <TD style="WIDTH: 100%" vAlign=top><IFRAME id=main 
      style="Z-INDEX: 1; VISIBILITY: inherit; WIDTH: 100%; HEIGHT: 100%" 
      border=false name=main src="info.asp" 
      frameBorder=0 scrolling=yes></IFRAME></TD></TR></TBODY></TABLE></BODY></HTML>
