/**
 * Created by web on 2017/1/24.
 */
$(document).ready(function() {
    // var swiper = new Swiper('.swiper-container', {
    //     autoplay : 3000,
    //     speed:1000,
    //     loop : true,
    //     pagination: '.swiper-pagination',
    //     paginationClickable: true,
    //     autoplayDisableOnInteraction : false
    // });
    setTimeout(function () {
        var $swiperTop = $('.swiper-container').height();
        var $contact = $(".contact");
        $contact.css("top", $swiperTop - 50);
        $contact.css("display", "block");

        $(window).resize(function () {
            var $swiperTop = $('.swiper-container').height();
            var $contact = $(".contact");
            $contact.css("top",$swiperTop-50);
        });
    },50)

    $("#download_btn").on('mouseover',function () {
        $("#download_url").show();
    }).on('mouseout',function () {
        $("#download_url").hide();
    })

    /*到位置后显示关闭后不再显示*/
    // window.animatenum = function (CompanySpeed,CompanyMax,CompanyCount,ArchiveSpeed,ArchiveMax,ArchiveCount,CommentSpeed,CommentMax,CommentCount,) {
        var ttt = false;
        var ccc = false;
        // $(window).scroll(function () {
        //     if(ttt == false){
        //         if ($(window).scrollTop() > $(document).height()/6) {
        //             $(".footerB").animate({opacity:"1",filter:'alpha(opacity=100)'},1000);
        //             $(".footerB").css('display','block');
        //             $(".footerT").css('margin-bottom','74px').css('padding-bottom','110px');
        //             var num1=0;
        //             var num2=0;
        //             var num3 =0;
        //             if( ccc == false){
        //                 var jia = setInterval(function () {
        //                     num1+=1;
        //                     $('.jia').html(num1)
        //                     // console.log(num1)
        //                     if (num1>=111){                         /*家变化最大值*/
        //                         clearInterval(jia);
        //                         $('.jia').html("11111");              /*家显示的最终值*/
        //                     }
        //                 },50)
        //                 var fen = setInterval(function () {
        //                     num2+=1;
        //                     $('.fen').html(num2)
        //                     if (num2>=111){                       /*份变化最大值*/
        //                         clearInterval(fen);
        //                         $('.fen').html("11111");            /*份显示的最终值*/
        //                     }
        //                 },100);
        //                 var tiao = setInterval(function () {
        //                     num3+=1;
        //                     $('.tiao').html(num3)
        //                     // console.log(num3)
        //                     if (num3>=111){                     /*条变化的最大值*/
        //                         clearInterval(tiao);
        //                         $('.tiao').html("11111");         /*最终显示的值*/
        //                     }
        //                 },100)
        //                 ccc=true
        //             }
        //         }
        //     }
        // });
    // }

    /*close Buttom*/
    $(".ftClose img").click(function () {
        $(".footerB").css('display','none');
        $(".footerT").css('margin-bottom','0').css("padding-bottom","30px");
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


});