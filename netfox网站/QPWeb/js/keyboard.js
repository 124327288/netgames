//���嵱ǰ�Ƿ��д��״̬
var CapsLockValue=0;
var curEditName;

var check;
function setVariables() {
tablewidth=630;  // logo width, in pixels
tableheight=20;  // logo height, in pixels
if (navigator.appName == "Netscape") {
horz=".left";
vert=".top";
docStyle="document.";
styleDoc="";
innerW="window.innerWidth";
innerH="window.innerHeight";
offsetX="window.pageXOffset";
offsetY="window.pageYOffset";
}
else {
horz=".pixelLeft";
vert=".pixelTop";
docStyle="";
styleDoc=".style";
innerW="document.body.clientWidth";
innerH="document.body.clientHeight";
offsetX="document.body.scrollLeft";
offsetY="document.body.scrollTop";
   }
}
function checkLocation() {
if (check) {
objectXY="softkeyboard";
var availableX=eval(innerW);
var availableY=eval(innerH);
var currentX=eval(offsetX);
var currentY=eval(offsetY);
x=availableX-tablewidth+currentX;
//y=availableY-tableheight+currentY;
y=currentY;

evalMove();
}
setTimeout("checkLocation()",0);
}
function evalMove() {
//eval(docStyle + objectXY + styleDoc + horz + "=" + x);
eval(docStyle + objectXY + styleDoc + vert + "=" + y);
}


	self.onError=null;
	currentX = currentY = 0;  
	whichIt = null;           
	lastScrollX = 0; lastScrollY = 0;
	NS = (document.layers) ? 1 : 0;
	IE = (document.all) ? 1: 0;
	function heartBeat() {
		if(IE) { diffY = document.body.scrollTop; diffX = document.body.scrollLeft; }
	    if(NS) { diffY = self.pageYOffset; diffX = self.pageXOffset; }
		if(diffY != lastScrollY) {
	                percent = .1 * (diffY - lastScrollY);
	                if(percent > 0) percent = Math.ceil(percent);
	                else percent = Math.floor(percent);
					if(IE) document.all.softkeyboard.style.pixelTop += percent;
					if(NS) document.softkeyboard.top += percent; 
	                lastScrollY = lastScrollY + percent;}
		if(diffX != lastScrollX) {
			percent = .1 * (diffX - lastScrollX);
			if(percent > 0) percent = Math.ceil(percent);
			else percent = Math.floor(percent);
			if(IE) document.all.softkeyboard.style.pixelLeft += percent;
			if(NS) document.softkeyboard.left += percent;
			lastScrollX = lastScrollX + percent;	}		}
	function checkFocus(x,y) { 
	        stalkerx = document.softkeyboard.pageX;
	        stalkery = document.softkeyboard.pageY;
	        stalkerwidth = document.softkeyboard.clip.width;
	        stalkerheight = document.softkeyboard.clip.height;
	        if( (x > stalkerx && x < (stalkerx+stalkerwidth)) && (y > stalkery && y < (stalkery+stalkerheight))) return true;
	        else return false;}
	function grabIt(e) {
	    check = false;
		if(IE) {
			whichIt = event.srcElement;
			while (whichIt.id.indexOf("softkeyboard") == -1) {
				whichIt = whichIt.parentElement;
				if (whichIt == null) { return true; } }
			whichIt.style.pixelLeft = whichIt.offsetLeft;
		    whichIt.style.pixelTop = whichIt.offsetTop;
			currentX = (event.clientX + document.body.scrollLeft);
	   		currentY = (event.clientY + document.body.scrollTop); 	
		} else { 
	        window.captureEvents(Event.MOUSEMOVE);
	        if(checkFocus (e.pageX,e.pageY)) { 
	                whichIt = document.softkeyboard;
	                StalkerTouchedX = e.pageX-document.softkeyboard.pageX;
	                StalkerTouchedY = e.pageY-document.softkeyboard.pageY;} }
	    return true;	}
	function moveIt(e) {
		if (whichIt == null) { return false; }
		if(IE) {
		    newX = (event.clientX + document.body.scrollLeft);
		    newY = (event.clientY + document.body.scrollTop);
		    distanceX = (newX - currentX);    distanceY = (newY - currentY);
		    currentX = newX;    currentY = newY;
		    whichIt.style.pixelLeft += distanceX;
		    whichIt.style.pixelTop += distanceY;
			if(whichIt.style.pixelTop < document.body.scrollTop) whichIt.style.pixelTop = document.body.scrollTop;
			if(whichIt.style.pixelLeft < document.body.scrollLeft) whichIt.style.pixelLeft = document.body.scrollLeft;
			if(whichIt.style.pixelLeft > document.body.offsetWidth - document.body.scrollLeft - whichIt.style.pixelWidth - 20) whichIt.style.pixelLeft = document.body.offsetWidth - whichIt.style.pixelWidth - 20;
			if(whichIt.style.pixelTop > document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5) whichIt.style.pixelTop = document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5;
			event.returnValue = false;
		} else { 
			whichIt.moveTo(e.pageX-StalkerTouchedX,e.pageY-StalkerTouchedY);
	        if(whichIt.left < 0+self.pageXOffset) whichIt.left = 0+self.pageXOffset;
	        if(whichIt.top < 0+self.pageYOffset) whichIt.top = 0+self.pageYOffset;
	        if( (whichIt.left + whichIt.clip.width) >= (window.innerWidth+self.pageXOffset-17)) whichIt.left = ((window.innerWidth+self.pageXOffset)-whichIt.clip.width)-17;
	        if( (whichIt.top + whichIt.clip.height) >= (window.innerHeight+self.pageYOffset-17)) whichIt.top = ((window.innerHeight+self.pageYOffset)-whichIt.clip.height)-17;
	        return false;}
	    return false;	}
	function dropIt() {whichIt = null;
	    if(NS) window.releaseEvents (Event.MOUSEMOVE);
	    return true;	}
	if(NS) {window.captureEvents(Event.MOUSEUP|Event.MOUSEDOWN);
		window.onmousedown = grabIt;
	 	window.onmousemove = moveIt;
		window.onmouseup = dropIt;	}
	if(IE) {
		document.onmousedown = grabIt;
	 	document.onmousemove = moveIt;
		document.onmouseup = dropIt;	}
	if(NS || IE) action = window.setInterval("heartBeat()",1);



document.write ('    <DIV align=center id=\"softkeyboard\" name=\"softkeyboard\" style=\"position:absolute; left:280px; top:173px; width:490px; z-index:180;display:none\" title=\"�������϶�λ��\">');
document.write ('  <table width=\"340\" border=\"0\" align=\"center\" cellpadding=\"1\" cellspacing=\"1\" background=\"imagesBlank/Backbg.gif\" bgcolor=\"#DDDDDD\">');
document.write ('    <FORM name=Calc action=\"\" method=post autocomplete=\"off\">');
document.write ('      <INPUT type=hidden value=ok name=action2>');
document.write ('      <tr> ');
document.write ('        <td align=\"left\" background=\"imagesBlank/Backbg.gif\" align=\"center\"> <INPUT class=button type=password size=20 value=\"\" name=userpass> ');
document.write ('          <INPUT class=button type=button value=������� name=\"Submit13\" onclick=\"OverInput(curEditName);\"> <INPUT class=button type=reset value=�������� name=\"Submit23\"> ');
document.write ('          <input class=button type=button value=\"�ر�\" name=\"Submit222\" onclick=\"closekeyboard(curEditName);\"> </td>');
document.write ('      </tr>');
document.write ('      <tr> ');
document.write ('        <td align=\"center\" bgcolor=\"#FFFFFF\" align=\"center\"> <table align=\"center\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">');
document.write ('            <tr align=\"left\" valign=\"middle\"> ');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'1\');\" value=\" 1 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'2\');\" value=\" 2 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'3\');\" value=\" 3 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'4\');\" value=\" 4 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'5\');\" value=\" 5 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'6\');\" value=\" 6 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'7\');\" value=\" 7 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'8\');\" value=\" 8 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'9\');\" value=\" 9 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'0\');\" value=\" 0 \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'-\');\" value=\" - \"></td>');
document.write ('              <td><input name=\"button10\" type=button value=\" BackSpace\" onclick=\"setpassvalue();\"> ');
document.write ('              </td>');
document.write ('              <td>&nbsp;</td>');
document.write ('            </tr>');
document.write ('            <tr align=\"left\" valign=\"middle\"> ');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'q\');\" value=\" q \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'w\');\" value=\" w \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'e\');\" value=\" e \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'r\');\" value=\" r \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'t\');\" value=\" t \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'y\');\" value=\" y \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'u\');\" value=\" u \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'i\');\" value=\" i \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'o\');\" value=\" o \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'p\');\" value=\" p \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button6\" type=button onClick=\"addValue(\':\');\" value=\" : \"></td>');
document.write ('              <td><input name=\"button12\" type=button onclick=\"OverInput(curEditName);\" value=\"   Enter  \"> ');
document.write ('              </td>');
document.write ('              <td> ');
document.write ('                </td>');
document.write ('            </tr>');
document.write ('            <tr align=\"left\" valign=\"middle\"> ');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'a\');\" value=\" a \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'s\');\" value=\" s \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'d\');\" value=\" d \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'f\');\" value=\" f \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'g\');\" value=\" g \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'h\');\" value=\" h \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'j\');\" value=\" j \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'k\');\" value=\" k \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'l\');\" value=\" l \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button8\" type=button onClick=\"addValue(\'[\');\" value=\" [ \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button9\" type=button onClick=\"addValue(\']\');\" value=\" ] \"></td>');
document.write ('              <td colspan=\"2\"><input name=\"button9\" type=button onClick=\"setCapsLock();\" value=\"�л���Сд\"></td>');
document.write ('            </tr>');
document.write ('            <tr align=\"left\" valign=\"middle\"> ');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'z\');\" value=\" z \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'x\');\" value=\" x \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'c\');\" value=\" c \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'v\');\" value=\" v \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'b\');\" value=\" b \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'n\');\" value=\" n \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'m\');\" value=\" m \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button3\" type=button onClick=\"addValue(\'<\');\" value=\" < \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button4\" type=button onClick=\"addValue(\'>\');\" value=\" > \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button5\" type=button onClick=\"addValue(\'(\');\" value=\" ( \"></td>');
document.write ('              <td> ');
document.write ('                <input name=\"button7\" type=button onClick=\"addValue(\')\');\" value=\" ) \"></td>');
document.write ('              <td colspan=\"2\"> ');
document.write ('                <input name=\"showCapsLockValue\" type=reset  value=\"��ǰ��Сд\"></td>');
document.write ('            </tr>');
document.write ('            <tr align=\"left\" valign=\"middle\"> ');
document.write ('              <td> ');
document.write ('                <input name=\"button2\" type=button onClick=\"addValue(\',\');\" value=\" , \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'~\');\" value=\" ~ \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'!\');\" value=\" ! \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'@\');\" value=\" @ \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'#\');\" value=\" # \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'$\');\" value=\" $ \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'%\');\" value=\" % \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'^\');\" value=\" ^ \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'*\');\" value=\" * \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'|\');\" value=\" | \"></td>');
document.write ('              <td> ');
document.write ('                <input type=button onclick=\"addValue(\'?\');\" value=\" ? \"></td>');
document.write ('              <td colspan=\"2\"><input name=\"button\" type=button onClick=\"addValue(\'=\');\" value=\"    =     \"></td>');
document.write ('            </tr>');
document.write ('          </table></td>');
document.write ('      </tr>');
document.write ('    </FORM>');
document.write ('  </table>');
document.write ('</DIV>');

//�����������������ֵ
	function addValue(newValue)
	{
		if (CapsLockValue==0)
		{
			Calc.userpass.value += newValue;
		}
		else
		{
			Calc.userpass.value += newValue.toUpperCase();
		}
	}
//ʵ��BackSpace���Ĺ���
	function setpassvalue()
	{
		var longnum=Calc.userpass.value.length;
		var num
		num=Calc.userpass.value.substr(0,longnum-1);
		Calc.userpass.value=num;
	}
//�������
	function OverInput(theForm)
	{
		eval("var theForm="+theForm+";");
		//m_pass.mempass.value=Calc.userpass.value;
		theForm.value=Calc.userpass.value;
			//alert(theForm.value);
		//theForm.value=m_pass.mempass.value;
		softkeyboard.style.display="none";
		Calc.userpass.value="";
	}
//�ر������
	function closekeyboard(theForm)
	{
		//eval("var theForm="+theForm+";");
		//theForm.value="";
		softkeyboard.style.display="none";
		//Calc.userpass.value="";

	}
//��ʾ�����
	function showkeyboard(x)
	{  
	    curEditName=x;
		softkeyboard.style.display="block";
	}

//�����Ƿ��д��ֵ
function setCapsLock()
{
	if (CapsLockValue==0)
	{
		CapsLockValue=1
		Calc.showCapsLockValue.value="��ǰ�Ǵ�д";
	}
	else 
	{
		CapsLockValue=0
		Calc.showCapsLockValue.value="��ǰ��Сд";
	}
}