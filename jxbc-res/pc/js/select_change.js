$(function(){

/*选择默认为浅灰色*/
$(".com-put select,.em-name select").each(function(){
	var _thisSelect=$(this);
	yuwqColor();
    _thisSelect.change(function(){
       yuwqColor();
    });
})


});

/*颜色状态控制*/
function yuwqColor(){

/*选择默认为浅灰色*/
$(".com-put select,.em-name select").each(function(){
   var _thisSelect2=$(this);
   var _thisVal = _thisSelect2.val();
   console.log(_thisVal);
   if(!_thisVal){
        _thisSelect2.css('color','#9b9b9b');
    }else{

      _thisSelect2.css('color','#000');
    }
})
}
