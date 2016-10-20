
//日期验证
function ValidDateTime(formDate){
var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/; 
var r = formDate.match(reg); 
var r2 = formDate.match(reg); 
if(r==null | r2 == null)
{
alert("日期输入错误");
return false; 
}
}

