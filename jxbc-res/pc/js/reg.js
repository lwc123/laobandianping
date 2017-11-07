
window.onresize=r;
window.onload=function(){
//window.getHeight= function(){
    if(window.innerHeight!= undefined){ 
        return window.innerHeight;  
    }
    else{ 
        return document.documentElement.clientHeight;              	
    }  
}
function r(resizeNum){
//	var height=window.getHeight();
	var height=window.onload();
    var comBody = document.getElementById("com-body");
    if(comBody){
        comBody.style.height=height+"px";
        if(height>window.screen.height&&resizeNum<=0){
            setTimeout(function(){
                r(++resizeNum);
            },100);
         }
    };
};
setTimeout(r(0),100);

//button样式变换
	$("button:not(.reg-button button),.batch_load-in_employe").bind("mouseenter click",function(){
		$(this).addClass("btn-background");
	})
	$("button:not(.reg-button button),.batch_load-in_employe").mouseleave(function(){
		$(this).removeClass("btn-background");
	})
