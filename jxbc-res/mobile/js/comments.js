$(function(){
	/*切换公司*/
	var count=1;
	$("#companyTitle").click(function(){
		if(count%2){
		   $(this).children("svg").css({"transform":"rotate(180deg)"});
		}else{
		   $(this).children("svg").css({"transform":"rotate(360deg)"});
		}
		count++;
		$(this).children(".zhezhao").slideToggle();
	})
	/*切换公司名称*/
	$(".pulldrow li").click(function(){
		var name=$(this).find("a").html();
		$("#companyTitle strong").text(name);
	})
	
	/*星星评分*/
	var num=finalnum = tempnum= 0;
	var lis = $(".companyScore li");
	//num:传入点亮星星的个数
	//finalnum:最终点亮星星的个数
	//tempnum:一个中间值
	function fnShow(num) {
		 finalnum= num || tempnum;//如果传入的num为0，则finalnum取tempnum的值
		 for (var i = 0; i < lis.length; i++) {
		  lis[i].className = i < finalnum? "light" : "";//点亮星星就是加class为light的样式
		 }
	}
	for (var i = 1; i <= lis.length; i++) {
		lis[i - 1].index = i;
		lis[i - 1].onclick = function() { //鼠标点击,同时会调用onmouseout,改变tempnum值点亮星星  	
		  	tempnum= this.index;	
		  	fnShow(tempnum);
		  	$(".fenshu").val(tempnum);
		  	$(".showBlock").slideDown();
		  	if(tempnum<=2){
		  	  $(".showBlock").find(".no").addClass("selected").siblings("em").removeClass("selected");
		  	}else{
		  	  $(".showBlock").find(".no").prev().addClass("selected").siblings("em").removeClass("selected");
		  	}
		  	var selected=$(".selected").attr("data-value");
	 	    $(".selected").siblings("input").val(selected);
		}
	}
	/*切换星星标签*/
	 $(".showBlock em").click(function(){
	 	$(this).addClass("selected").siblings("em").removeClass("selected");
	 	var selected=$(this).attr("data-value");
	 	$(this).siblings("input").val(selected);
	 })
	 
	/*自动演示动画*/
	function shandong(){
		var starNum=1;
		var aa=true;
		timer=setInterval(function(){
			if(aa){
				fnShow(starNum);
				starNum++;
				if(starNum>5){
	            	aa=false;
					starNum=5;
                }
			}else{
				fnShow(starNum);
				starNum--;
				if(starNum<0){
                   clearInterval(timer);
                }
			} 
		},100)
	}
	shandong();
	
	/*切换公司标签*/
    var values = [];
    function clickAdd(){
    	$(".companyTip span").unbind().bind("click",function(){
			if ($(this).hasClass("active")){
				$(this).removeClass("active");
				for(var i=0;i<values.length;i++){
					if(values.indexOf($(this).html())==i){
						values.splice(i,1);
					}
				}
			}else{
				var length=values.length;
				if(length<5){
					$(this).addClass("active");
				   values.push($(this).html());
				}else{
					$('#error').show().text('最多选择5个标签');
						setTimeout(function(){
							$('#error').hide();
					},2000);
				}
			}
			$("#reputationLabels").val(values.join(","));
			var inp = $("#reputationLabels").val().split(",");
			$(".companyTip span").each(function() {
				var personId = $(this).html();
				for (var i = 0; i < inp.length; i++) {
					if (inp[i] == personId){
						$(this).addClass("active");
					}
					   
			    }
			})
		})
    }
	clickAdd();
	
	/*更多标签点击*/
	$("#more").click(function(){
		$(".comments").add('#pageHead').add(".head").hide();
		$(".moreLable").show();
		$("#companyLabel span").each(function(){
	    	 $(this).removeClass("active");
	    })
		var inp = $("#reputationLabels").val().split(",");
		$(".companyTip span").each(function() {
			var personId = $(this).html();
			for (var i = 0; i < inp.length; i++) {
				if (inp[i] == personId){
					$(this).addClass("active");
				}
				   
		    }
		})
	})
	
	
	/*更多标签页  添加标签*/
	$(".labelTitle b svg").click(function(){
		var length=values.length;
		if(length>=5){
		 	$('#error').show().text('最多选择5个标签');
				setTimeout(function(){
					$('#error').hide();
			},2000);
		}else{
			$(".addLabel input").val("");
		    $(".loader-bg").removeClass("hidden");
		}
		
		
	})
	/*点击添加按钮添加标签*/
	$("#add").click(function(){
	 	var label=$.trim($(".addLabel input").val());
	  	 if(label==""){
	  	 	$(".loader-bg").addClass("hidden");
	  	 }else if(label.length>5){
	  	 	$('#error').show().text('请输入5个字以内的标签');
			setTimeout(function(){
				$('#error').hide();
			},2000);
	  	 }else{
	  	 	$('<span>' + label + '</span>').addClass("active").appendTo(".tipInner");
	  	 	values.push(label);
	  	    $(".loader-bg").addClass("hidden");
	  	 }
	 })
	
	$(".addLabel input").bind("input propertychange",function(){
		var num = $.trim($(this).val()).length;
		$("#wordNum1").html(num);
	    if ($("#wordNum1").text() >6) {
	    	setTimeout(function(){
	    		$('#error').show().text('请输入5个字以内的标签');
				setTimeout(function(){
					$('#error').hide();
				},2000);
	    	},1000)
				
	    }	
    })
	
	/*关闭添加点评弹窗*/
	$("#close").click(function(){
		$(".loader-bg").addClass("hidden");
	})
		
		
	/*返回添加点评*/
    $("#back").click(function(){
   	    $(".comments").add('#pageHead').add(".head").show();
	    $(".moreLable").hide();
	     
	    //点返回时清空后面标签
	    $(".tipInner span").each(function(){
	    	 $(this).removeClass("active");
	    })
	    for (var i = 0; i < values.length; i++) {
	    	 $("#companyLabel span").each(function(){
	    	 	if($(this).html()==values[i])
	    	       $(this).remove()
	         })
			$('<span>' + values[i] + '</span>').addClass("active").prependTo("#companyLabel");
		}

	    var arrLength=$("#companyLabel span").length;
	    if(arrLength>5)
	    	$("#companyLabel span:gt(4)").hide();
	   
	    clickAdd();
    })
	
	
	
	/*公司评价字数限制*/
	$(".commentContent").bind("input propertychange",function(){
		var num = $.trim($(this).val()).length;
		var str=$.trim($(this).val());
		if (num >500) {
			$(this).css({"color":"red"});
			$('#error').show().text('点评文字不能多于500个字哦');
				setTimeout(function(){
					$('#error').hide();
			},2000);	
		}else{
			$(this).css({"color":"#000"});
		}
		$("#wordNum").html(num);
	})
	
	
	/*加载动画*/
	window.alertLoading=function () {
		$('.loader-bg').removeClass("hidden");
		$('.addLabel').hide();
		$('#loadingPic').show()
    }
    window.removeLoading=function () {
        $('.loader-bg').addClass("hidden");
        $('.addLabel').show();
        $('#loadingPic').hide()
    }
    
	
})
/*在职时间*/
var a1=[];
var a2=[];
var str1="<option value='1'>年</option>";

biaodan(2017);
var op2=document.getElementById("opation2");
function biaodan(year){
	var nov=new Date().getFullYear();
	for(var i=year;i>=2006;i--){
		a1.push(i);
		str1+="<option value='"+i+"'>"+i+"</option>";
	}
	var op1=document.getElementById("opation1");
	op1.innerHTML=str1;

	for(i in a1){
		a2[i]=a1[i];
	}

}
function change(obj){
	var str2="<option value='1'>年</option>";
	for(i in a1){
		a2[i]=a1[i];
	}
	var ye=parseInt(obj.value);
	hye=a2.indexOf(ye);
	var a3=["至今"];
	var a3=a3.concat(a2.splice(0,hye+1));
	for(var i in a3){
		str2+="<option value='"+a3[i]+"'>"+a3[i]+"</option>";
	}
	op2.innerHTML=str2;
}
    