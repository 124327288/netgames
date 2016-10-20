function showhint(iconid, str)
{
	var imgUrl='../images/hint.gif';
	if (iconid != 0)
	{
		imgUrl = '../images/warning.gif';
	}
	document.write('<div style="background:url(' + imgUrl + ') no-repeat 20px 10px;border:1px dotted #DBDDD3; background-color:#FDFFF2; margin:10px; padding:10px 10px 10px 56px;">');
	document.write(str + '</div><div style="clear:both;"></div>');
}

function showloadinghint(divid, str)
{
	if (divid=='')
	{
		divid='PostInfo';
	}
	document.write('<div id="' + divid + ' " style="display:none;position:relative;border:1px dotted #DBDDD3; background-color:#FDFFF2; margin:auto;padding:10px" width="90%"  ><img border="0" src="../images/ajax_loading.gif" /> ' + str + '</div>');
}


function CheckByName(form,name,noname)
{
  for (var i=0;i<form.elements.length;i++)
    {
	    var e = form.elements[i];
	   
	    if(e.name.indexOf(name)>=0)
		{
		   if(noname!="")
           {
              if(e.name.indexOf(noname)>=0) ;
              else
              {
                 e.checked = form.chkall.checked;
                // alert(e.name+' '+form.chkall.checked);
              }
             
		   }	  
		   else
		   {
		      e.checked = form.chkall.checked;   
		   }
	    }
	}
}


function CheckAll(form)
  {
  for (var i=0;i<form.elements.length;i++)
    {
    var e = form.elements[i];
    if (e.name != 'chkall' && e.name !='deleteMode')
       e.checked = form.chkall.checked;
    }
}

function SH_SelectOne()
{
	var obj = window.event.srcElement;
	if( obj.checked == false)
	{
		document.getElementById('chkall').checked = obj.chcked;
		
	}
}

function changeDeleteModeState(item,form)
{
	switch(item)
	{
		case 1:
			document.getElementById("chkall").disabled = false;
			document.getElementById("deleteNum").disabled = document.getElementById("deleteFrom_deleteFrom").disabled = true;
			enableCheckBox(false,form);
			document.getElementById("deleteNum").value = "";
			document.getElementById("deleteFrom_deleteFrom").value = "";
			break;
		case 2:
			document.getElementById("deleteNum").disabled = false;
			document.getElementById("chkall").disabled = document.getElementById("deleteFrom_deleteFrom").disabled = true;
			enableCheckBox(true,form);
			document.getElementById("chkall").checked = false;			
			document.getElementById("deleteFrom_deleteFrom").value = "";
			break;
		case 3:
			document.getElementById("deleteFrom_deleteFrom").disabled = false;
			document.getElementById("chkall").disabled = document.getElementById("deleteNum").disabled = true;
			enableCheckBox(true,form);
			document.getElementById("chkall").checked = false;			
			document.getElementById("deleteNum").value = "";
			break;
	}
}  

function enableCheckBox(b,form)
{
	for (var i=0;i<form.elements.length;i++)
	{
		var e = form.elements[i];
		if (e.type == "checkbox")
		{
			e.disabled = b;
			e.checked = false;
		}
	}
} 