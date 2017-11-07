/**
 * Created by msi on 2017/1/5.
 */
window.onload=function(){
    var wrap = document.querySelector(".wrap");
    carouselFigure();
    downloadClose();
    logoBanner();
}
//下载页关闭
function downloadClose() {
    var close = document.getElementById('downloadClose');
    var header = document.getElementById('header');
    var content = document.getElementById('content');
    var shadow = document.getElementById('shadow');
    var shadowClose = document.querySelector(".shadow-close");
    close.addEventListener("click",function (ev) {
        header.style.display = "none";
        content.style.paddingTop=0;
        shadow.style.top = 0;
        shadowClose.style.display="block"
    })
}

//无缝滑屏
function carouselFigure(){
    var cssEl = document.createElement("style");
    document.head.appendChild(cssEl);

    var wrapEl = document.querySelector("#picWrap");
    var listEl = document.querySelector("#picList");
    listEl.innerHTML += listEl.innerHTML;
    var liEls = document.querySelectorAll("#picList li");
    var navEls = document.querySelectorAll("#picNav span");

    var cssText="#picList{width:"+liEls.length+"00%}";
    cssText +="#picList li{width:"+(1/liEls.length)*100+"%}"
    cssText +="#picWrap{height:"+liEls[0].offsetHeight+"px}";
    cssEl.innerHTML += cssText;

    //开始滑屏
    var startX = 0;
    var elementX = 0;
    var startY = 0;
    var elementY = 0;
    //清除定时器
    var claer = 0;
    //用来抽象图片的下标(即位置)
    var now = 0;

    var isX =true;
    var isFirst=true;
/*

    wrapEl.addEventListener("touchstart",function(ev){
        clearInterval(claer);

        now = Math.round(-css(listEl,"translateX")/wrapEl.clientWidth);
        if(now==0){
            now = navEls.length;
        }
        if(now==liEls.length-1){
            now = navEls.length-1;
        }
        css(listEl,"translateX",-now*wrapEl.clientWidth);
        css(listEl,"translateZ",0.0000001);

        listEl.style.transition = "none";
        var touch = ev.changedTouches[0];
        startX = touch.clientX;
        startY = touch.clientY;
        elementX=css(listEl,"translateX");
        elementY=css(listEl,"translateY");

        isX=true;
        isFirst=true;
    })

    wrapEl.addEventListener("touchmove",function(ev){
        if(!isX){
            return;
        }

        var touch = ev.changedTouches[0];
        var nowX = touch.clientX;
        var nowY = touch.clientY;
        var disX = nowX-startX;
        var disY = nowY-startY;


        if(isFirst){
            isFirst=false;
            if(Math.abs(disY)>Math.abs(disX)){
                isX=false;
                return;
            }
        }


        css(listEl,"translateX",elementX+disX);
        css(listEl,"translateZ",0.000001);
    })

    wrapEl.addEventListener("touchend",function(){

        now = Math.round(-css(listEl,"translateX")/wrapEl.clientWidth);
        if(now<0){
            now=0;
        }else if(now>liEls.length-1){
            now=liEls.length-1;
        }

        autoMove();
        auto();
    })

*/

    //自动轮播
    //			var autoFlag = 0;
    // auto();
    function auto(){//定时器的开关
        claer=setInterval(function(){

            if(now==liEls.length-1){
                listEl.style.transition = "none";
                now = navEls.length-1;
                css(listEl,"translateX",-now*wrapEl.clientWidth);
            }

            setTimeout(function(){
                now++;
                autoMove();
            },20)

        },3000);
    }
    function autoMove(){
        listEl.style.transition = "1s";
        css(listEl,"translateX",-now*wrapEl.clientWidth);
        css(listEl,"translateZ",0.0000001);
        for(var i=0;i<navEls.length;i++){
            navEls[i].className="";
        }
        navEls[now%navEls.length].className="picActive";
    }
}

function css(obj,attr,value){
    if(!obj.transform){
        obj.transform={};
    }

    if(arguments.length>2){//设置
        obj.transform[attr]=value;
        var text ="";
        for(var item in obj.transform){
            switch (item){
                case "rotate":
                case "skewX":
                case "skewY":
                case "skew":
                    text += item+"("+obj.transform[item]+"deg) "
                    break;
                case "translateX":
                case "translateY":
                case "translateZ":
                case "translate":
                    text += item+"("+obj.transform[item]+"px) "
                    break;
                case "scale":
                case "scaleX":
                case "scaleY":
                    text += item+"("+obj.transform[item]+") "
                    break;
            }
        }
        obj.style.webkitTransform=obj.style.transform = text;

    }else{//读取

        value = obj.transform[attr];
        if(typeof value == "undefined"){
            //返回默认值
            if(attr == "scale" || attr == "scaleX" || attr == "scaleY"){
                return 1;
            }else{
                return 0;
            }
        }

        return value;
    }
}
/*logo轮播*/
function logoBanner() {
    var cssEl = document.querySelector('style');
    var bnWidth = document.querySelector('.banner').clientWidth;
    var btnl = document.querySelector('.btnl')
    var btnr = document.querySelector('.btnr')
    var listEl = document.querySelectorAll('.picban li');
    var ulEl = document.querySelector('.picban ul');
    var cssText = ".picban ul{width:"+listEl.length+"00%}";
    console.log(cssText)
    cssEl.innerHTML+=cssText;
    ulEl.style.width = bnWidth*listEl.length;
    btnr.addEventListener('touchstart',function () {
        var nowX = css(ulEl,"translateX")
        nowX-=bnWidth;
        if (nowX >= -(listEl.length-1)*bnWidth && nowX<=0){css(ulEl,'translateX',nowX)}

    })
    btnl.addEventListener('touchstart',function () {
        var nowX = css(ulEl,"translateX")
        nowX+=bnWidth;
        if (nowX >= -listEl.length*bnWidth && nowX<=0){css(ulEl,'translateX',nowX)}
    })
}
