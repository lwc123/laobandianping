

function dargclick() {
    $(".drag_bg_click").click(function(ev){

        ev= ev||window.event;
        var x=ev.offsetX-13;
        if(x>=538){
            x=538;
        }else if (x<=0){
            x=0
        }
		/*条长度*/
        $(this).parent().children('div').width(x);
		/*球的位置*/
        $(this).parent().children('span').css("left",x+"px");

		/*分数*/
        var xx = x/538;
        var yyy=Math.round(xx*100);
        if(yyy<=29){
            $(this).parent().prev().text("极差");
        }else if(yyy<=59){
            $(this).parent().prev().text("差");
        }else if(yyy<=79){
            $(this).parent().prev().text("一般");
        }else if(yyy<=89){
            $(this).parent().prev().text("良好");
        }else{
            $(this).parent().prev().text("很优秀");
        }
        $(this).parent().children('span').children("span").text(yyy);
		$(this).parent().parent().children('input').val(yyy);
    });
}
dargclick();



scale = function (btn, bar, title, grade,txt,e) {

	this.btn = document.getElementById(btn);
	this.bar = document.getElementById(bar);
	this.title = document.getElementById(title);
	this.grade=document.getElementById(grade);
	this.txt=document.getElementById(txt);
	if(null != this.bar){
		this.step = this.bar.getElementsByTagName("div")[0];
	this.init();
	};

};
scale.prototype = {
	init: function () {
		var f = this, g = document, b = window, m = Math;
		f.btn.onmousedown = function (e) {
            console.info("onmousedown");
			var x = (e || b.event).clientX;
			var l = this.offsetLeft;
			var max = f.bar.offsetWidth - this.offsetWidth;
			g.onmousemove = function (e) {
				var thisX = (e || b.event).clientX;
				var to = m.min(max, m.max(-2, l + (thisX - x)));
				f.btn.style.left = to + 'px';
				f.ondrag(m.round(m.max(0, to / max) * 100), to);
				b.getSelection ? b.getSelection().removeAllRanges() : g.selection.empty();

			};
			g.onmouseup = function () {
                this.onmousemove=null;
            }


		};
	},
	ondrag: function (pos, x) {
        console.info("ondrag");
		this.step.style.width = Math.max(0, x) + 'px';
		this.title.innerHTML = pos + '';
		if(this.title.innerHTML<=29){
			this.grade.innerHTML="极差";
		}else if(this.title.innerHTML<=59){
			this.grade.innerHTML="差";
		}else if(this.title.innerHTML<=79){
			this.grade.innerHTML="一般";
		}else if(this.title.innerHTML<=89){
			this.grade.innerHTML="良好";
		}else{
			this.grade.innerHTML="很优秀";
		}
		var title=this.title.innerHTML;
		this.txt.value=title;
	}

}
new scale('btn0', 'bar0', 'title0','ev','txt0');
new scale('btn1', 'bar1', 'title1','ev1','txt1');
new scale('btn2', 'bar2', 'title2','ev2','txt2');
new scale('btn3', 'bar3', 'title3','ev3','txt3');
new scale('btn4', 'bar4', 'title4','ev4','txt4');
new scale('btn5', 'bar5', 'title5','ev5','txt5');
