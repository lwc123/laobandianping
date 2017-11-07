/**
 * Created by web on 2017/2/20.
 */
window.onscroll=function () {
    var scrollTop=document.documentElement.scrollTop||document.body.scrollTop
    if(scrollTop>=$('.headerT').height()){
        $('.header-content').css({'position':'fixed','top':'0','z-index':'555','border-bottom':'1px solid #E4E5E9'})
    }else {
        $('.header-content').css({'position':'','top':'','z-index':'','border-bottom':''})
    }
}