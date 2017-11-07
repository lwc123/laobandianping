 function circleProgress(name,num,color){  
    var c = document.getElementById(name),  
    process = 0,  
    ctx = c.getContext('2d');  
    
    //画单线的圆
    ctx.beginPath();  
    ctx.arc(25, 25, 23, 0, Math.PI*2);  
    ctx.closePath();  
    ctx.strokeStyle = color;
    ctx.stroke(); 
  
    function animate(num){  
        requestAnimationFrame(function (){  
 
            drawCricle(ctx, process,color);  
            if (process < num) {  // 这个就是进度条的那个数值大小你可以后台获取值
                 animate(num);
                process = process + 1;  
            }  
        });  
    }  
    function drawCricle(ctx, percent,aaa){  
        // 画进度环  
        ctx.beginPath();  
        ctx.moveTo(25, 25);
        //逆时针
        ctx.arc(25, 25, 25, Math.PI * 1.5, Math.PI * (1.5 - 2 * percent / 100 ),true); 
        ctx.fillStyle=aaa;
        ctx.fill();  
  
        // 画内填充圆  
        ctx.beginPath();  
        ctx.arc(25, 25, 21, 0, Math.PI * 2);  
        ctx.closePath();  
        ctx.fillStyle ='#fff';  
        ctx.fill();  
  
        // 填充文字  
        ctx.font = "bold 0.277rem Microsoft YaHei";   
        ctx.fillStyle = aaa; 
        ctx.textAlign = 'center';    
        ctx.textBaseline = 'middle';    
        ctx.moveTo(25, 25);  
        if(process==0){
            ctx.fillText("暂无数据", 25,25);  
        }else{
        	ctx.fillText(process + '%', 25, 25);  
        }
        
    }  
  
    animate(num);  
}; 
var aa=document.getElementById("Recommend").value;
var bb=document.getElementById("Optimistic").value;
var cc=document.getElementById("SupportCEO").value;
circleProgress("process",aa,"#c3b2a2");
circleProgress("process1",bb,"#a4caf6");
circleProgress("process2",cc,"#f39ba3");