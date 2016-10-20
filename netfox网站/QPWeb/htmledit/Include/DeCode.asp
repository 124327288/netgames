<%
'������������������������������������
'��                                                                  ��
'��                eWebEditor - eWebSoft�����ı��༭��               ��
'��                                                                  ��
'��  ��Ȩ����: eWebSoft.com                                          ��
'��                                                                  ��
'��  ��������: eWeb�����Ŷ�                                          ��
'��            email:webmaster@webasp.net                            ��
'��            QQ:589808                                             ��
'��                                                                  ��
'��  �����ַ: [��Ʒ����]http://www.eWebSoft.com/Product/eWebEditor/ ��
'��            [֧����̳]http://bbs.eWebSoft.com/                    ��
'��                                                                  ��
'��  ��ҳ��ַ: http://www.eWebSoft.com/   eWebSoft�ŶӼ���Ʒ         ��
'��            http://www.webasp.net/     WEB������Ӧ����Դ��վ      ��
'��            http://bbs.webasp.net/     WEB����������̳            ��
'��                                                                  ��
'������������������������������������
%>

<%
'================================================
' ��ʾ���ͺ��������ظ��ݲ���������ʾ�ĸ�ʽ�ַ�����������÷����ɴӺ�̨������
' ���������
'	s_Content	:	Ҫת���������ַ���
'	s_Filters	:	Ҫ���˵��ĸ�ʽ�����ö��ŷָ����
'================================================
Function eWebEditor_DeCode(s_Content, sFilters)
	Dim a_Filter, i, s_Result, s_Filters
	eWebEditor_Decode = ""
	If IsNull(s_Content) Then Exit Function
	If s_Content = "" Then Exit Function
	s_Result = s_Content
	s_Filters = sFilters

	' ����Ĭ�Ϲ���
	If sFilters = "" Then s_Filters = "script,object"

	a_Filter = Split(s_Filters, ",")
	For i = 0 To UBound(a_Filter)
		s_Result = eWebEditor_DecodeFilter(s_Result, a_Filter(i))
	Next
	eWebEditor_DeCode = s_Result
End Function

%>

<Script Language=JavaScript RunAt=Server>
//===============================================
// ��������
// ���������
//	s_Content	:	Ҫת���������ַ���
//	s_Filter	:	Ҫ���˵��ĵ�����ʽ
//===============================================
function eWebEditor_DecodeFilter(html, filter){
	switch(filter.toUpperCase()){
	case "SCRIPT":		// ȥ�����пͻ��˽ű�javascipt,vbscript,jscript,js,vbs,event,...
		html = eWebEditor_execRE("</?script[^>]*>", "", html);
		html = eWebEditor_execRE("(javascript|jscript|vbscript|vbs):", "$1��", html);
		html = eWebEditor_execRE("on(mouse|exit|error|click|key)", "<I>on$1</I>", html);
		html = eWebEditor_execRE("&#", "<I>&#</I>", html);
		break;
	case "TABLE":		// ȥ�����<table><tr><td><th>
		html = eWebEditor_execRE("</?table[^>]*>", "", html);
		html = eWebEditor_execRE("</?tr[^>]*>", "", html);
		html = eWebEditor_execRE("</?th[^>]*>", "", html);
		html = eWebEditor_execRE("</?td[^>]*>", "", html);
		break;
	case "CLASS":		// ȥ����ʽ��class=""
		html = eWebEditor_execRE("(<[^>]+) class=[^ |^>]*([^>]*>)", "$1 $2", html) ;
		break;
	case "STYLE":		// ȥ����ʽstyle=""
		html = eWebEditor_execRE("(<[^>]+) style=\"[^\"]*\"([^>]*>)", "$1 $2", html);
		break;
	case "XML":			// ȥ��XML<?xml>
		html = eWebEditor_execRE("<\\?xml[^>]*>", "", html);
		break;
	case "NAMESPACE":	// ȥ�������ռ�<o:p></o:p>
		html = eWebEditor_execRE("<\/?[a-z]+:[^>]*>", "", html);
		break;
	case "FONT":		// ȥ������<font></font>
		html = eWebEditor_execRE("</?font[^>]*>", "", html);
		break;
	case "MARQUEE":		// ȥ����Ļ<marquee></marquee>
		html = eWebEditor_execRE("</?marquee[^>]*>", "", html);
		break;
	case "OBJECT":		// ȥ������<object><param><embed></object>
		html = eWebEditor_execRE("</?object[^>]*>", "", html);
		html = eWebEditor_execRE("</?param[^>]*>", "", html);
		html = eWebEditor_execRE("</?embed[^>]*>", "", html);
		break;
	default:
	}
	return html;
}

// ============================================
// ִ��������ʽ�滻
// ============================================
function eWebEditor_execRE(re, rp, content) {
	oReg = new RegExp(re, "ig");
	r = content.replace(oReg, rp);
	return r; 
}

</Script>