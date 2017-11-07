$(function(){
	
	/*分享*/
	$("#pageHead svg:last-child").click(function(){
		$("#share").slideToggle();
	})
	/*判断是否显示头部*/
	var headCode=$("#hasCode").val();
	if(headCode==""){
		$(".opinionDetail").css({"margin-top":"0"})
	}else{
		$(".opinionDetail").css({"margin-top":"1.16rem"})
	}
   /*显示分数*/
	  function star(){
	  	$(".showStar span").each(function(){
	    	var num=$(this).attr("tip");
	    	$(this).parent(".showStar").children("a:lt("+num+")").addClass("showBg");
	    	$(this).parents(".userScore").children("b").text(num+"分");
	    })
	  }
    star();
    
	/*显示分数(含半颗星)*/
	$(".orangStar span").each(function(){
		var num=$(this).attr("tip");
		if(num.length>1){
			var decimal=parseInt(num.charAt(num.length - 1));
	        if(decimal<3){
	        	num=Math.floor(num);
	        	$(this).parent(".orangStar").children('a:lt('+num+')').addClass("showBg");
	        }else if(decimal>=3&&decimal<=9){
	        	num=Math.floor(num);
	        	$(this).parent(".orangStar").children('a:lt('+num+')').addClass("showBg");
	        	$(this).parent(".orangStar").children('a:eq('+num+')').addClass("showHalfBg");
	        }else{
	        	num=Math.ceil(num);
	        	$(this).parent(".orangStar").children('a:lt('+num+')').addClass("showBg");
	        }
		}else{
			$(this).parent(".orangStar").children('a:lt('+num+')').addClass("showBg");
		}
	})
})
