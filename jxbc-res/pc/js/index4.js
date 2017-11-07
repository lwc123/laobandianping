  $(function () {
        /*swiper轮播注释*/
        var swiper = new Swiper('.swiper-container', {
            autoplay : 3000,
            speed:1000,
            loop : true,
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplayDisableOnInteraction : false
        });
      window.onscroll=function () {
          var winPos =  $(window).scrollTop()
          console.log(winPos)
          if(winPos>=50){
              $('.header-main').css({'position':'fixed','top':'0','z-index':'555','border-bottom':'1px solid #E4E5E9'})
          }else {
              $('.header-main').css({'position':'','top':'','z-index':'','border-bottom':''})
          }
      }

      $('#friends').mouseenter(function () {
          $(this).children('ul').show();
      })
      $('#friends').mouseleave(function () {
          $(this).children('ul').hide();
      })

        $('.header-main-login div').mouseenter(function () {
            $(this).find('span').css('color','#F4B802')
        })
        $('.header-main-login div').mouseleave(function () {
            $(this).find('span').css('color','')
        })


        $('.news-list a').mouseenter(function () {
            $(this).css('color','#F4B802')
        })
        $('.news-list a').mouseleave(function () {
            $(this).css('color','')
        })


        $('.footer-hover-color a').mouseenter(function () {
            $(this).css('color','#F4B802')
        })
        $('.footer-hover-color a').mouseleave(function () {
            $(this).css('color','')
        })

        $('.header-main-index a:not(:has(".hmi-active"))').mouseenter(function () {
            $(this).children('span').addClass('hmi-active')
        });
        $('.header-main-index a:not(:has(".hmi-active"))').mouseleave(function () {
            $(this).children('span').removeClass('hmi-active')
        });
        $('.news-list').mouseenter(function () {
            $(this).css('box-shadow',"0px 0px 10px 2px #ACA8A6").css('border-radus','8px')
        });
        $('.news-list').mouseleave(function () {
            $(this).css('box-shadow',"")
        });

        $('.company-logo').mouseenter(function () {
            $(this).children('img').css('box-shadow',"0px 0px 10px 2px #ACA8A6").css('border-radus','8px')
        });
        $('.company-logo').mouseleave(function () {
            $(this).children('img').css('box-shadow',"")
        });

        $("#myCarousel").carousel('cycle');
        Caroursel.init($('.caroursel'))
        /*下载app二维码*/
        $('#download').mouseenter(function () {
            $('.downloadimg').show()
        });
        $('#download').mouseleave(function () {
            $('.downloadimg').hide()
        });
        /*wechat 二维码*/
        $('.weichat').mouseenter(function () {
            $('.weichatimg').show()
        });
        $('.weichat').mouseleave(function () {
            $('.weichatimg').hide()
        });
        /*app 二维码*/
        $('.appstroe').mouseenter(function () {
            $('.appstroeimg').show()
        });
        $('.appstroe').mouseleave(function () {
            $('.appstroeimg').hide()
        })
    })