/*
*������������������������������������
*��                                                                  ��
*��                eWebEditor - eWebSoft�����ı��༭��               ��
*��                                                                  ��
*��  ��Ȩ����: eWebSoft.com                                          ��
*��                                                                  ��
*��  ��������: eWeb�����Ŷ�                                          ��
*��            email:webmaster@webasp.net                            ��
*��            QQ:589808                                             ��
*��                                                                  ��
*��  �����ַ: [��Ʒ����]http://www.eWebSoft.com/Product/eWebEditor/ ��
*��            [֧����̳]http://bbs.eWebSoft.com/                    ��
*��                                                                  ��
*��  ��ҳ��ַ: http://www.eWebSoft.com/   eWebSoft�ŶӼ���Ʒ         ��
*��            http://www.webasp.net/     WEB������Ӧ����Դ��վ      ��
*��            http://bbs.webasp.net/     WEB����������̳            ��
*��                                                                  ��
*������������������������������������
*/


// �˵�����
var sMenuHr="<tr><td align=center valign=middle height=2><TABLE border=0 cellpadding=0 cellspacing=0 width=128 height=2><tr><td height=1 class=HrShadow><\/td><\/tr><tr><td height=1 class=HrHighLight><\/td><\/tr><\/TABLE><\/td><\/tr>";
var sMenu1="<TABLE border=0 cellpadding=0 cellspacing=0 class=Menu width=150><tr><td width=18 valign=bottom align=center style='background:url(sysimage/contextmenu.gif);background-position:bottom;'><\/td><td width=132 class=RightBg><TABLE border=0 cellpadding=0 cellspacing=0>";
var sMenu2="<\/TABLE><\/td><\/tr><\/TABLE>";
// �˵�
var oPopupMenu = null;
if (BrowserInfo.IsIE55OrMore){
	oPopupMenu = window.createPopup();
}

// ȡ�˵���
function getMenuRow(s_Disabled, s_Event, s_Image, s_Html) {
	var s_MenuRow = "";
	s_MenuRow = "<tr><td align=center valign=middle><TABLE border=0 cellpadding=0 cellspacing=0 width=132><tr "+s_Disabled+"><td valign=middle height=20 class=MouseOut onMouseOver=this.className='MouseOver'; onMouseOut=this.className='MouseOut';";
	if (s_Disabled==""){
		s_MenuRow += " onclick=\"parent."+s_Event+";parent.oPopupMenu.hide();\"";
	}
	s_MenuRow += ">"
	if (s_Image !=""){
		s_MenuRow += "&nbsp;<img border=0 src='ButtonImage/"+config.StyleDir+"/"+s_Image+"' width=20 height=20 align=absmiddle "+s_Disabled+">&nbsp;";
	}else{
		s_MenuRow += "&nbsp;";
	}
	s_MenuRow += s_Html+"<\/td><\/tr><\/TABLE><\/td><\/tr>";
	return s_MenuRow;

}

// ȡ��׼��format�˵���
function getFormatMenuRow(menu, html, image){
	var s_Disabled = "";
	if (!eWebEditor.document.queryCommandEnabled(menu)){
		s_Disabled = "disabled";
	}
	var s_Event = "format('"+menu+"')";
	var s_Image = menu+".gif";
	if (image){
		s_Image = image;
	}
	return getMenuRow(s_Disabled, s_Event, s_Image, html)
}

// ȡ���˵���
function getTableMenuRow(what){
	var s_Menu = "";
	var s_Disabled = "disabled";
	switch(what){
	case "TableInsert":
		if (!isTableSelected()) s_Disabled="";
		s_Menu += getMenuRow(s_Disabled, "TableInsert()", "TableInsert.gif", "������...")
		break;
	case "TableProp":
		if (isTableSelected()||isCursorInTableCell()) s_Disabled="";
		s_Menu += getMenuRow(s_Disabled, "TableProp()", "TableProp.gif", "�������...")
		break;
	case "TableCell":
		if (isCursorInTableCell()) s_Disabled="";
		s_Menu += getMenuRow(s_Disabled, "TableCellProp()", "TableCellProp.gif", "��Ԫ������...")
		s_Menu += getMenuRow(s_Disabled, "TableCellSplit()", "TableCellSplit.gif", "��ֵ�Ԫ��...")
		s_Menu += sMenuHr;
		s_Menu += getMenuRow(s_Disabled, "TableRowProp()", "TableRowProp.gif", "���������...")
		s_Menu += getMenuRow(s_Disabled, "TableRowInsertAbove()", "TableRowInsertAbove.gif", "�����У����Ϸ���");
		s_Menu += getMenuRow(s_Disabled, "TableRowInsertBelow()", "TableRowInsertBelow.gif", "�����У����·���");
		s_Menu += getMenuRow(s_Disabled, "TableRowMerge()", "TableRowMerge.gif", "�ϲ��У����·���");
		s_Menu += getMenuRow(s_Disabled, "TableRowSplit(2)", "TableRowSplit.gif", "�����");
		s_Menu += getMenuRow(s_Disabled, "TableRowDelete()", "TableRowDelete.gif", "ɾ����");
		s_Menu += sMenuHr;
		s_Menu += getMenuRow(s_Disabled, "TableColInsertLeft()", "TableColInsertLeft.gif", "�����У�����ࣩ");
		s_Menu += getMenuRow(s_Disabled, "TableColInsertRight()", "TableColInsertRight.gif", "�����У����Ҳࣩ");
		s_Menu += getMenuRow(s_Disabled, "TableColMerge()", "TableColMerge.gif", "�ϲ��У����Ҳࣩ");
		s_Menu += getMenuRow(s_Disabled, "TableColSplit(2)", "TableColSplit.gif", "�����");
		s_Menu += getMenuRow(s_Disabled, "TableColDelete()", "TableColDelete.gif", "ɾ����");
		break;
	}
	return s_Menu;
}

// �Ҽ��˵�
function showContextMenu(event){
	if (!bEditMode) return false;

	var width = 150;
	var height = 0;
	var lefter = event.clientX;
	var topper = event.clientY;

	var oPopDocument = oPopupMenu.document;
	var oPopBody = oPopupMenu.document.body;

	var sMenu="";
	
	sMenu += getFormatMenuRow("cut", "����");
	sMenu += getFormatMenuRow("copy", "����");
	sMenu += getFormatMenuRow("paste", "����ճ��");
	sMenu += getFormatMenuRow("delete", "ɾ��");
	sMenu += getFormatMenuRow("selectall", "ȫѡ");
	sMenu += sMenuHr;
	height += 102;

	if (isCursorInTableCell()){
		sMenu += getTableMenuRow("TableProp");
		sMenu += getTableMenuRow("TableCell");
		sMenu += sMenuHr;
		height += 286;
	}

	if (isControlSelected("TABLE")){
		sMenu += getTableMenuRow("TableProp");
		sMenu += sMenuHr;
		height += 22;
	}

	if (isControlSelected("IMG")){
		sMenu += getMenuRow("", "ShowDialog('dialog/img.htm', 350, 315, true)", "img.gif", "ͼƬ����...");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "zIndex('forward')", "forward.gif", "����һ��");
		sMenu += getMenuRow("", "zIndex('backward')", "backward.gif", "����һ��");
		sMenu += sMenuHr;
		height += 64;
	}

	sMenu += getMenuRow("", "findReplace()", "findreplace.gif", "�����滻...");
	height += 20;

	sMenu = sMenu1 + sMenu + sMenu2;

	oPopDocument.open();
	oPopDocument.write(config.StyleMenuHeader+sMenu);
	oPopDocument.close();

	height+=2;
	if(lefter+width > document.body.clientWidth) lefter=lefter-width;
	//if(topper+height > document.body.clientHeight) topper=topper-height;

	oPopupMenu.show(lefter, topper, width, height, eWebEditor.document.body);
	return false;

}

// �������˵�
function showToolMenu(menu){
	if (!bEditMode) return false;
	var sMenu = ""
	var width = 150;
	var height = 0;

	var lefter = event.clientX;
	var leftoff = event.offsetX
	var topper = event.clientY;
	var topoff = event.offsetY;

	var oPopDocument = oPopupMenu.document;
	var oPopBody = oPopupMenu.document.body;

	switch(menu){
	case "font":		// ����˵�
		sMenu += getFormatMenuRow("bold", "����", "bold.gif");
		sMenu += getFormatMenuRow("italic", "б��", "italic.gif");
		sMenu += getFormatMenuRow("underline", "�»���", "underline.gif");
		sMenu += getFormatMenuRow("strikethrough", "�л���", "strikethrough.gif");
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("superscript", "�ϱ�", "superscript.gif");
		sMenu += getFormatMenuRow("subscript", "�±�", "subscript.gif");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "ShowDialog('dialog/selcolor.htm?action=forecolor', 280, 250, true)", "forecolor.gif", "������ɫ");
		sMenu += getMenuRow("", "ShowDialog('dialog/selcolor.htm?action=backcolor', 280, 250, true)", "backcolor.gif", "���屳��ɫ");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "insert('big')", "tobig.gif", "��������");
		sMenu += getMenuRow("", "insert('small')", "tosmall.gif", "�����С");
		height = 206;
		break;
	case "paragraph":	// ����˵�
		sMenu += getFormatMenuRow("JustifyLeft", "�����", "JustifyLeft.gif");
		sMenu += getFormatMenuRow("JustifyCenter", "���ж���", "JustifyCenter.gif");
		sMenu += getFormatMenuRow("JustifyRight", "�Ҷ���", "JustifyRight.gif");
		sMenu += getFormatMenuRow("JustifyFull", "���˶���", "JustifyFull.gif");
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("insertorderedlist", "���", "insertorderedlist.gif");
		sMenu += getFormatMenuRow("insertunorderedlist", "��Ŀ����", "insertunorderedlist.gif");
		sMenu += getFormatMenuRow("indent", "����������", "indent.gif");
		sMenu += getFormatMenuRow("outdent", "����������", "outdent.gif");
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("insertparagraph", "�������", "insertparagraph.gif");
		sMenu += getMenuRow("", "insert('br')", "br.gif", "���뻻�з�");
		height = 204;
		break;
	case "edit":		// �༭�˵�
		var s_Disabled = "";
		if (history.data.length <= 1 || history.position <= 0) s_Disabled = "disabled";
		sMenu += getMenuRow(s_Disabled, "goHistory(-1)", "undo.gif", "����")
		if (history.position >= history.data.length-1 || history.data.length == 0) s_Disabled = "disabled";
		sMenu += getMenuRow(s_Disabled, "goHistory(1)", "redo.gif", "�ָ�")
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("Cut", "����", "cut.gif");
		sMenu += getFormatMenuRow("Copy", "����", "copy.gif");
		sMenu += getFormatMenuRow("Paste", "����ճ��", "paste.gif");
		sMenu += getMenuRow("", "PasteText()", "pastetext.gif", "���ı�ճ��");
		sMenu += getMenuRow("", "PasteWord()", "pasteword.gif", "��Word��ճ��");
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("delete", "ɾ��", "delete.gif");
		sMenu += getFormatMenuRow("RemoveFormat", "ɾ�����ָ�ʽ", "removeformat.gif");
		sMenu += sMenuHr;
		sMenu += getFormatMenuRow("SelectAll", "ȫ��ѡ��", "selectall.gif");
		sMenu += getFormatMenuRow("Unselect", "ȡ��ѡ��", "unselect.gif");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "findReplace()", "findreplace.gif", "�����滻");
		height = 248;
		break;
	case "object":		// ����Ч���˵�
		sMenu += getMenuRow("", "ShowDialog('dialog/selcolor.htm?action=bgcolor', 280, 250, true)", "bgcolor.gif", "���󱳾���ɫ");
		sMenu += getMenuRow("", "ShowDialog('dialog/backimage.htm', 350, 210, true)", "bgpic.gif", "����ͼƬ");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "absolutePosition()", "abspos.gif", "���Ի����λ��");
		sMenu += getMenuRow("", "zIndex('forward')", "forward.gif", "����һ��");
		sMenu += getMenuRow("", "zIndex('backward')", "backward.gif", "����һ��");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "showBorders()", "showborders.gif", "��ʾ����ָ������");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "insert('quote')", "quote.gif", "������ʽ");
		sMenu += getMenuRow("", "insert('code')", "code.gif", "������ʽ");
		height = 166;
		break;
	case "component":	// ����˵�
		sMenu += getMenuRow("", "ShowDialog('dialog/img.htm', 350, 315, true)", "img.gif", "������޸�ͼƬ");
		sMenu += getMenuRow("", "ShowDialog('dialog/flash.htm', 350, 200, true)", "flash.gif", "����Flash����");
		sMenu += getMenuRow("", "ShowDialog('dialog/media.htm', 350, 200, true)", "media.gif", "�����Զ�����ý��");
		sMenu += getMenuRow("", "ShowDialog('dialog/file.htm', 350, 150, true)", "file.gif", "���������ļ�");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "remoteUpload()", "remoteupload.gif", "Զ���Զ��ϴ�");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "ShowDialog('dialog/fieldset.htm', 350, 170, true)", "fieldset.gif", "������޸���Ŀ��");
		sMenu += getMenuRow("", "ShowDialog('dialog/iframe.htm', 350, 200, true)", "iframe.gif", "������޸���ҳ֡");
		sMenu += getFormatMenuRow("InsertHorizontalRule", "����ˮƽ��", "inserthorizontalrule.gif");
		sMenu += getMenuRow("", "ShowDialog('dialog/marquee.htm', 395, 150, true)", "marquee.gif", "������޸���Ļ");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "createLink()", "createlink.gif", "������޸ĳ�����");
		sMenu += getMenuRow("", "ShowDialog('dialog/anchor.htm', 270, 220, true)", "anchor.gif", "��ǩ����");
		sMenu += getMenuRow("", "mapEdit()", "map.gif", "ͼ���ȵ�����");
		sMenu += getFormatMenuRow("UnLink", "ȡ�������ӻ��ǩ", "unlink.gif");
		height = 266;
		break;
	case "tool":		// ���߲˵�
		sMenu += getMenuRow("", "ShowDialog('dialog/symbol.htm', 350, 220, true)", "symbol.gif", "���������ַ�");
		sMenu += getMenuRow("", "insert('excel')", "excel.gif", "����Excel���");
		sMenu += getMenuRow("", "ShowDialog('dialog/emot.htm', 300, 180, true)", "emot.gif", "�������ͼ��");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "insert('nowdate')", "date.gif", "���뵱ǰ����");
		sMenu += getMenuRow("", "insert('nowtime')", "time.gif", "���뵱ǰʱ��");
		height = 102;
		break;
	case "file":		// �ļ���ͼ�˵�
		sMenu += getMenuRow("", "format('Refresh')", "refresh.gif", "�½�");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "setMode('CODE')", "modecodebtn.gif", "����״̬");
		sMenu += getMenuRow("", "setMode('EDIT')", "modeeditbtn.gif", "�༭״̬");
		sMenu += getMenuRow("", "setMode('TEXT')", "modetextbtn.gif", "�ı�״̬");
		sMenu += getMenuRow("", "setMode('VIEW')", "modeviewbtn.gif", "Ԥ��״̬");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "sizeChange(300)", "sizeplus.gif", "���߱༭��");
		sMenu += getMenuRow("", "sizeChange(-300)", "sizeminus.gif", "��С�༭��");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "format('Print')", "print.gif", "��ӡ");
		sMenu += sMenuHr;
		sMenu += getMenuRow("", "ShowDialog('dialog/help.htm','400','300')", "help.gif", "�鿴ʹ�ð���");
		sMenu += getMenuRow("", "ShowDialog('dialog/about.htm','400','220')", "about.gif", "����eWebEditor");
		sMenu += getMenuRow("", "window.open('http://ewebeditor.webasp.net')", "site.gif", "eWebEditorվ��");
		height = 228;
		break;
	case "table":		// ���˵�
		sMenu += getTableMenuRow("TableInsert");
		sMenu += getTableMenuRow("TableProp");
		sMenu += sMenuHr;
		sMenu += getTableMenuRow("TableCell");
		height = 306;
		break;
	case "form":		// ���˵�
		sMenu += getFormatMenuRow("InsertInputText", "���������", "FormText.gif");
		sMenu += getFormatMenuRow("InsertTextArea", "����������", "FormTextArea.gif");
		sMenu += getFormatMenuRow("InsertInputRadio", "���뵥ѡť", "FormRadio.gif");
		sMenu += getFormatMenuRow("InsertInputCheckbox", "���븴ѡť", "FormCheckBox.gif");
		sMenu += getFormatMenuRow("InsertSelectDropdown", "����������", "FormDropdown.gif");
		sMenu += getFormatMenuRow("InsertButton", "���밴ť", "FormButton.gif");
		height = 120;
		break;
	case "zoom":		// ���Ų˵�
		for (var i=0; i<aZoomSize.length; i++){
			if (aZoomSize[i]==nCurrZoomSize){
				sMenu += getMenuRow("", "doZoom("+aZoomSize[i]+")", "checked.gif", aZoomSize[i]+"%");
			}else{
				sMenu += getMenuRow("", "doZoom("+aZoomSize[i]+")", "space.gif", aZoomSize[i]+"%");
			}
			height += 20;
		}
		break;
	}
	
	sMenu = sMenu1 + sMenu + sMenu2;
	
	oPopDocument.open();
	oPopDocument.write(config.StyleMenuHeader+sMenu);
	oPopDocument.close();

	height+=2;
	if(lefter+width > document.body.clientWidth) lefter=lefter-width;
	//if(topper+height > document.body.clientHeight) topper=topper-height;

	oPopupMenu.show(lefter - leftoff - 2, topper - topoff + 22, width, height, document.body);

	return false;
}

