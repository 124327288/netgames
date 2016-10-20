marqueesHeight=38;
stopscroll=false;
with(makewing){
	  style.width=0;
	  style.height=marqueesHeight;
	  style.overflowX="visible";
	  style.overflowY="hidden";
	  noWrap=true;
	  onmouseover=new Function("stopscroll=true");
	  onmouseout=new Function("stopscroll=false");
  }
  preTop=0; currentTop=marqueesHeight; stoptime=0;
  makewing.innerHTML+=makewing.innerHTML;
  

function init_srolltext(){
  makewing.scrollTop=0;
  setInterval("scrollUp()",1);
}init_srolltext();

function scrollUp(){
  if(stopscroll==true) return;
  currentTop+=1;
  if(currentTop==marqueesHeight+1)
  {
  	stoptime+=1;
  	currentTop-=1;
  	if(stoptime==600) 
  	{
  		currentTop=0;
  		stoptime=0;  		
  	}
  }
  else {  	
	  preTop=makewing.scrollTop;
	  makewing.scrollTop+=1;
	  if(preTop==makewing.scrollTop){
	    makewing.scrollTop=marqueesHeight;
	    makewing.scrollTop+=1;
	    
	  }
  }

}
init_srolltext();