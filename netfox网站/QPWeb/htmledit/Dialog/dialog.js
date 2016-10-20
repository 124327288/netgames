// ȡͨ��URL�������Ĳ��� (��ʽ�� ?Param1=Value1&Param2=Value2)
var URLParams = new Object() ;
var aParams = document.location.search.substr(1).split('&') ;
for (i=0 ; i < aParams.length ; i++) {
	var aParam = aParams[i].split('=') ;
	URLParams[aParam[0]] = aParam[1] ;
}

// ������������ͬ��������Ϣ
var config;
try{
	config = dialogArguments.config;
}
catch(e){
}


// ȥ�ո�left,right,all��ѡ
function BaseTrim(str){
	  lIdx=0;rIdx=str.length;
	  if (BaseTrim.arguments.length==2)
	    act=BaseTrim.arguments[1].toLowerCase()
	  else
	    act="all"
      for(var i=0;i<str.length;i++){
	  	thelStr=str.substring(lIdx,lIdx+1)
		therStr=str.substring(rIdx,rIdx-1)
        if ((act=="all" || act=="left") && thelStr==" "){
			lIdx++
        }
        if ((act=="all" || act=="right") && therStr==" "){
			rIdx--
        }
      }
	  str=str.slice(lIdx,rIdx)
      return str
}

// ������Ϣ��ʾ���õ����㲢ѡ��
function BaseAlert(theText,notice){
	alert(notice);
	theText.focus();
	theText.select();
	return false;
}

// �Ƿ���Ч��ɫֵ
function IsColor(color){
	var temp=color;
	if (temp=="") return true;
	if (temp.length!=7) return false;
	return (temp.search(/\#[a-fA-F0-9]{6}/) != -1);
}

// ֻ������������
function IsDigit(){
  return ((event.keyCode >= 48) && (event.keyCode <= 57));
}

// ѡ��ɫ
function SelectColor(what){
	var dEL = document.all("d_"+what);
	var sEL = document.all("s_"+what);
	var url = "selcolor.htm?color="+encodeURIComponent(dEL.value);
	var arr = showModalDialog(url,window,"dialogWidth:280px;dialogHeight:250px;help:no;scroll:no;status:no");
	if (arr) {
		dEL.value=arr;
		sEL.style.backgroundColor=arr;
	}
}

// ѡ����ͼ
function SelectImage(){
	showModalDialog("backimage.htm?action=other",window,"dialogWidth:350px;dialogHeight:210px;help:no;scroll:no;status:no");
}

// ����������ֵ��ָ��ֵƥ�䣬��ѡ��ƥ����
function SearchSelectValue(o_Select, s_Value){
	for (var i=0;i<o_Select.length;i++){
		if (o_Select.options[i].value == s_Value){
			o_Select.selectedIndex = i;
			return true;
		}
	}
	return false;
}

// תΪ�����ͣ�����ǰ��0������ת�򷵻�""
function ToInt(str){
	str=BaseTrim(str);
	if (str!=""){
		var sTemp=parseFloat(str);
		if (isNaN(sTemp)){
			str="";
		}else{
			str=sTemp;
		}
	}
	return str;
}

// �Ƿ���Ч������
function IsURL(url){
	var sTemp;
	var b=true;
	sTemp=url.substring(0,7);
	sTemp=sTemp.toUpperCase();
	if ((sTemp!="HTTP://")||(url.length<10)){
		b=false;
	}
	return b;
}

// �Ƿ���Ч����չ��
function IsExt(url, opt){
	var sTemp;
	var b=false;
	var s=opt.toUpperCase().split("|");
	for (var i=0;i<s.length ;i++ ){
		sTemp=url.substr(url.length-s[i].length-1);
		sTemp=sTemp.toUpperCase();
		s[i]="."+s[i];
		if (s[i]==sTemp){
			b=true;
			break;
		}
	}
	return b;
}

// ���·��תΪ����ʽ·��
function relativePath2rootPath(url){
	if (url.substring(0,1)=="../") return url;

	var sWebEditorPath = getWebEditorRootPath();
	while(url.substr(0,3)=="../"){
		url = url.substr(3);
		sWebEditorPath = sWebEditorPath.substring(0,sWebEditorPath.lastIndexOf("../"));
	}
	return "../" + url;
}

// ���·����·��ģʽתΪ��Ӧ�ĸ�ʽ
function relativePath2setPath(url){
	switch(config.BaseUrl){
	case "0":
		return baseHref2editorPath(url);
		break;
	case "1":
		return relativePath2rootPath(url);
		break;
	case "2":
		return getSitePath() + relativePath2rootPath(url);
		break;
	}
}

// ��ʾ·�����༭��·�������ʽ
function baseHref2editorPath(url){
	var editorPath = getWebEditorRootPath() + "../";
	var baseHref = config.BaseHref;
	//baseHref = baseHref.substr(0, baseHref.length-1);
	var editorLen = editorPath.length;
	var baseLen = baseHref.length;
	var nMinLen = 0;
	if (editorLen>baseLen){
		nMinLen = baseLen;
	}else{
		nMinLen = editorLen;
	}
	var n = 0;
	for (var i=1; i<=nMinLen; i++){
		n = i;
		if (editorPath.substr(0,i).toLowerCase()!=baseHref.substr(0,i).toLowerCase()){
			break;
		}
	}	
	var str = editorPath.substr(0, n);
	str = str.substring(0,str.lastIndexOf("/")+1);
	n = str.length;
	editorPath = editorPath.substr(n);
	baseHref = baseHref.substr(n);
	var arr = baseHref.split("/");
	var result = "";
	for (var i=1; i<=arr.length-1; i++){
		result += "../";
	}
	result = result + editorPath + url;
	return result;
}

// ȡ�༭���ڸ�·��
function getWebEditorRootPath(){
	var url = "../" + document.location.pathname;
	return url.substring(0,url.lastIndexOf("/dialog/"));
}

// ȡվ��·��
function getSitePath(){
	var sSitePath = document.location.protocol + "//" + document.location.host;
	if (sSitePath.substr(sSitePath.length-3) == ":80"){
		sSitePath = sSitePath.substring(0,sSitePath.length-3);
	}
	return sSitePath;
}