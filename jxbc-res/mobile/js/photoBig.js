//var imgsObj = $('.amplifyImg img'); //需要放大的图像
//if(imgsObj) {
//	$.each(imgsObj, function() {
//		$(this).click(function() {
//			var currImg = $(this);
//			coverLayer(1);
//			var tempContainer = $('<div class=tempContainer></div>');
//			with(tempContainer) {
//				appendTo("body");
//				var windowWidth = $(window).width();
//				var windowHeight = $(window).height();
//
//				var orignImg = new Image();
//				orignImg.src = currImg.attr("src");
//				var currImgWidth = orignImg.width;
//				var currImgHeight = orignImg.height;
//				if(currImgWidth < windowWidth) {
//					if(currImgHeight < windowHeight) {
//						var topHeight = (windowHeight - currImgHeight) / 2;
//						if(topHeight > 35) {
//							topHeight = topHeight - 35;
//							css('top', topHeight);
//						} else {
//							css('top', 0);
//						}
//						html('<img border=0 src=' + currImg.attr('src') + '>');
//					} else {
//						css('top', 0);
//						html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " height": windowHeight });
//					}
//				} else {
//					var currImgChangeHeight = (currImgHeight * windowWidth) / currImgWidth;
//					if(currImgChangeHeight < windowHeight) {
//						var topHeight = (windowHeight - currImgChangeHeight) / 2;
//						if(topHeight > 35) {
//							topHeight = topHeight - 35;
//							css('top', topHeight);
//						} else {
//							css('top', 0);
//						}
//						html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " width": windowWidth });
//					} else {
//						css('top', 0);
//						html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " width": windowWidth, " height": windowHeight });
//					}
//				}
//			}
//			$('.over').click(function() {
//				$(".tempContainer").remove();
//				coverLayer(0);
//			});
//			tempContainer.click(function() {
//				$(this).remove();
//				coverLayer(0);
//			});
//		});
//	});
//}

function bianda(img){
	$(img).click(function() {
		var currImg = $(this);
		coverLayer(1);
		var tempContainer = $('<div class=tempContainer></div>');
		with(tempContainer) {
			appendTo("body");
			var windowWidth = $(window).width();
			var windowHeight = $(window).height();

			var orignImg = new Image();
			orignImg.src = currImg.attr("src");
			var currImgWidth = orignImg.width;
			var currImgHeight = orignImg.height;
			if(currImgWidth < windowWidth) {
				if(currImgHeight < windowHeight) {
					var topHeight = (windowHeight - currImgHeight) / 2;
					if(topHeight > 35) {
						topHeight = topHeight - 35;
						css('top', topHeight);
					} else {
						css('top', 0);
					}
					html('<img border=0 src=' + currImg.attr('src') + '>');
				} else {
					css('top', 0);
					html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " height": windowHeight });
				}
			} else {
				var currImgChangeHeight = (currImgHeight * windowWidth) / currImgWidth;
				if(currImgChangeHeight < windowHeight) {
					var topHeight = (windowHeight - currImgChangeHeight) / 2;
					if(topHeight > 35) {
						topHeight = topHeight - 35;
						css('top', topHeight);
					} else {
						css('top', 0);
					}
					html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " width": windowWidth });
				} else {
					css('top', 0);
					html('<img border=0 src=' + currImg.attr('src') + '>').animate({ " width": windowWidth, " height": windowHeight });
				}
			}
		}
		$('.over').click(function() {
			$(".tempContainer").remove();
			coverLayer(0);
		});
		tempContainer.click(function() {
			$(".tempContainer").remove();
			coverLayer(0);
		});
	});
}
  bianda(".amplifyImg img");
//使用禁用蒙层效果  
function coverLayer(tag) {
	with($('.over')) {
		if(tag == 1) {
			css('height', $(document).height());
			css('display', 'block');
			css('opacity', 1);
			css("background-color", "#000");
		} else {
			css('display', 'none');
		}
	}
}

