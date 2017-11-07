/**
 * Created by web on 2017/1/6.
 */
$(document).ready(function() {   

    $(".downloadUserPhone").on('mouseover',function () {
        $(".key").show();
    }).on('mouseout',function () {
        $(".key").hide();
    })

    /*到位置后显示关闭后不再显示*/
    var ttt = false;
    var ccc = false;
    $(window).scroll(function () {
        if(ttt == false){
            if ($(window).scrollTop() > $(document).height()/6) {
                $(".footerB").animate({opacity:"1",filter:'alpha(opacity=100)'},1000);
                $(".footerB").css('display','block');
                $(".footerT").css('margin-bottom','74px');
                var num1=0;
                var num2=0;
                var num3 =0;
                if( ccc == false){
                    var jia = setInterval(function () {
                        num1+=38;
                        $('.jia').html(num1)
                        // console.log(num1)
                        if (num1>=0){                         /*家变化最大值*/
                            clearInterval(jia);
                            $('.jia').html('21');              /*家显示的最终值*/
                        }
                    },50)
                    var fen = setInterval(function () {
                        num2+=651;
                        $('.fen').html(num2)
                        if (num2>=0){                       /*份变化最大值*/
                            clearInterval(fen);
                            $('.fen').html('10');            /*份显示的最终值*/
                        }
                    },100);
                    var tiao = setInterval(function () {
                        num3+=651;
                        $('.tiao').html(num3)
                        // console.log(num3)
                        if (num3>=0){                     /*条变化的最大值*/
                            clearInterval(tiao);
                            $('.tiao').html('5');         /*最终显示的值*/
                        }
                    },100)
                    ccc=true
                }
            }
        }
    });
    /*close Buttom*/
    $(".ftClose img").click(function () {
        $(".footerB").css('display','none');
        $(".footerT").css('margin-bottom','0');
        ttt=true;
    })
    /*banner*/
    var btnl = $('.btnl')
    var btnr = $('.btnr')
    var $ulEl = $('.picban ul');
    var moveX = 0;
    btnr.on('click',function () {
        if (moveX>-2010){
            moveX -= 1005;
            $ulEl.css("transform",'translateX('+moveX+'px)')
        }

        console.log(moveX)
    })
    btnl.on('click',function () {

        if (moveX<0){
            moveX += 1005;
            $ulEl.css("transform",'translateX('+moveX+'px)')
        }
        console.log(moveX)
    })

})
