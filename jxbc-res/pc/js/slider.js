$(document).ready(function() {
	//菜单
	window.__sidebarMenus = {
		_queryName: "__m__",
		_rootMenuId: "$-1",
		_menuAttrName: "menu-id",
		_containerId: "menu-sidebar",
		menuItems: [],
		menuLinks: [],
		currentMenuItem: null,
		init: function(containerId, menuId) {
			var $container = $("#" + this._containerId);
			$container.data(this._menuAttrName, this._rootMenuId);
			this.appendSubMenus($container);
		},
		appendSubMenus: function(parent, parentMenuId) {
			if (typeof(parentMenuId) == 'undefined' || parentMenuId == null || parentMenuId.length < 1)
				parentMenuId = parent.data(this._menuAttrName);

			var index = 0;
			var $menus = this;
			parent.children('div,li').each(function() {
				index++;

				var $item = $(this);
				var itemMenuId = $item.data($menus._menuAttrName);

				if (typeof(itemMenuId) == 'undefined' || itemMenuId.length < 1) {
					itemMenuId = parentMenuId + '-' + index;
					$item.data($menus._menuAttrName, itemMenuId);
				}

				var links = $item.find('a');
				if (links.length == 1) {
					var href = links.first().attr('href');
					if (typeof(itemMenuId) != 'undefined' || itemMenuId.length > 1) {
						href = href.toLowerCase();
						$item.data('link', href);
						$menus.menuLinks.push([href, $item]);
						//console.debug("append menu : %s -> %s", itemMenuId,href);
					}
				}
				//console.debug("append menu : %s", itemMenuId);
				$menus.menuItems.push([itemMenuId, $item]);

				var subItems = $item.children('ul');
				if (subItems.length == 1) {
					$menus.appendSubMenus($(subItems.first()), itemMenuId);
				}
			});
		},
		autoFixed: function() {
			var targetMenuId = this.getUrlParam(this._queryName);
			var matchItemByMenuId = null,
				matchItemByLink = null;

			if (targetMenuId != null) {
				for (var i = 0; i < this.menuItems.length; i++) {
					var itemId = this.menuItems[i][0];
					if (itemId == targetMenuId) {
						matchItemByMenuId = this.menuItems[i][1];
						break;
					}
				}
			}

			var pageUrl = (location.pathname + location.search).toLowerCase();
			for (var i = 0; i < this.menuLinks.length; i++) {
				var link = this.menuLinks[i][0];
				if (pageUrl.indexOf(link) >= 0) {
					matchItemByLink = this.menuLinks[i][1];
					break;
				}
			}

			//匹配优先级：自定义 MenuId最高， 页面Url其次， 自动生成的MenuId最后匹配
			if (targetMenuId != null && targetMenuId.indexOf(this._rootMenuId) != 0 && null != matchItemByMenuId) {
				this._fixedMenuItem(matchItemByMenuId);
				console.info("fixed by MenuId: ", matchItemByMenuId.data(this._menuAttrName), matchItemByMenuId.data("link"));
			} else if (null != matchItemByLink) {
				this._fixedMenuItem(matchItemByLink);
				console.info("fixed by Link: ", matchItemByLink.data(this._menuAttrName), matchItemByLink.data("link"));
			} else if (null != matchItemByMenuId) {
				this._fixedMenuItem(matchItemByMenuId);
				console.info("fixed by MenuId: ", matchItemByMenuId.data(this._menuAttrName), matchItemByMenuId.data("link"));
			}
		},

		_fixedParentMenu: function(menuItem) {
			if (menuItem.is("body") || menuItem[0].id == this._containerId)
				return;

			if (menuItem.is("li") || menuItem.is("ul")) {
				menuItem.show();
			} else if (menuItem.is("div")) {
				menuItem.addClass("open");
			}
			this._fixedParentMenu(menuItem.parent());
		},
		_fixedMenuItem: function(menuItem) {
			this.currentMenuItem = menuItem;
			if (menuItem.is("li")) {
				menuItem.addClass("active");
			} else {
				menuItem.addClass("open");
				menuItem.children("li").addClass("active");
			}

			//this.currentMenuItem.parents("li").addClass("active open");

			this._fixedParentMenu(this.currentMenuItem.parent());

			var queryParam = this._queryName + "=" + this.currentMenuItem.data(this._menuAttrName);
			var $menus = this;
			$("#page-content a").each(function() {
				var $this = $(this);
				var link = $this.attr("href");
				if (typeof(link) == 'undefined' || link == "#") return;

				var targetMenuId = $this.data($menus._menuAttrName);
				if (typeof(targetMenuId) != 'undefined' && targetMenuId.length > 0) return;

				var linkLowerCase = link.toLowerCase();
				var appendMenuId = true;
				for (var i = 0; i < $menus.menuLinks.length; i++) {
					var menuLink = $menus.menuLinks[i][0];
					if (linkLowerCase.indexOf(menuLink) >= 0) {
						appendMenuId = false;
						break;
					}
				}
				if (appendMenuId) {
					var targetMenuId = $menus.getUrlParam($menus._queryName);

					if (null == targetMenuId) {
						$this.attr("href", link + (link.indexOf("?") == -1 ? "?" : "&") + queryParam);
					} else {
						var baseMenuId = $menus._queryName + "=" + targetMenuId;
						if (linkLowerCase.indexOf(baseMenuId) >= 0) {
							$this.attr("href", link.replace(baseMenuId, queryParam));
						} else {
							$this.attr("href", link + (link.indexOf("?") == -1 ? "?" : "&") + queryParam);
						}
					}

				}
			});
		},
		getUrlParam: function(name) {
			if (window.location.search.length < 3) return null;

			var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
			var r = window.location.search.substr(1).match(reg);
			if (r != null) return unescape(r[2]);
			return null;
		}
	};
	__sidebarMenus.init();
	__sidebarMenus.autoFixed();
	//button[type='submit'],input[type='submit']
	(function($) {
		$.fn._initPostStatus = function() {
			if (this.data("default-text") === undefined) {
				var defaultText = this.text();
				if (this.is('input')) defaultText = this.val();
				this.data("default-text", defaultText);
				this.data("default-class", this.attr("class"));
			}
		};
		$.fn._changePostText = function(text) {
			if (text) {
				if (this.is('input'))
					this.val(text);
				else
					this.text(text);
			}
		};
		$.fn.posting = function() {
			this._initPostStatus();
			this.attr("disabled", true);
			if (this.attr("data-posting-text")) this._changePostText(this.attr("data-posting-text"));
			//if(!this.is('input')) this.prepend(" <i class='icon-refresh icon-spin'></i> ");
			this.removeClass("btn-primary").removeClass("btn-info").removeClass("btn-warning").removeClass("btn-danger").removeClass("btn-inverse").removeClass("btn-highlight");
			return this;
		};
		$.fn.posted = function() {
			this._initPostStatus();
			this.attr("disabled", true);
			if (this.attr("data-posted-text")) this._changePostText(this.attr("data-posted-text"));
			this.addClass("btn-success");
			if (!this.is('input')) this.find("i").remove();
			//if(!this.is('input')) this.prepend(" <i class='icon-ok'></i> ");
			return this;
		};
		$.fn.resetPostStatus = function() {
			this._initPostStatus();
			this.attr("disabled", false);
			if (!this.is('input')) this.find("i").remove();
			this._changePostText(this.data("default-text"));
			this.attr("class", this.data("default-class"));
			return this;
		};

	})(jQuery);
	$("button[type='submit'],input[type='submit']").each(function() {
		var $this = $(this);
		if ($this.attr("data-async")=="true" || $this.attr("data-posted-text") === undefined) {
			setTimeout(function() {
				$this.form().bind("submit", function() {
					$this.posting();
					setTimeout(function() {
						$this.resetPostStatus();
					}, 2100);
					return true;
				});
			}, 2100);
		}
	});

	$(".com-nav div").children("li").click(function() {
		var $this = $(this);
		if ($this.parent().hasClass("open")) {
			$(this).next(".com-slider").slideUp();
			$this.parent().removeClass("open")
		} else {
			var siblings = $this.parent().siblings();
			siblings.children(".com-slider").slideUp();
			siblings.removeClass("open");
			$this.next(".com-slider").slideDown();
			$this.parent().addClass("open");
		}
		if ($(this).next(".com-slider").length > 0)
			return false;

	});
	$(".com-slider").children("li").click(function() {
		if (!$(this).hasClass("active")) {
			$(this).addClass("active");
		}
	});
	
	
	//下载客户端
	  $(".top-ma").hover(function(){
	  	$(this).children("img").show();
	  },function(){
	  	$(this).children("img").hide();
	  })
	 
	//button样式变换
	$("button:not(.em-selectType button),.batch_load-in_employe").bind("mouseenter click",function(){
		$(this).addClass("btn-background");
	})
	$("button:not(.em-selectType button),.batch_load-in_employe").mouseleave(function(){
		$(this).removeClass("btn-background");
	})
	
	//创建新公司
	$("#change_layer .creat-company").click(function(){
		window.location.href='/EnterpriseService/openservice';
	})
    //退出
    $(".com-administrator").click(function(e){
    	$(this).children(".header_change").toggle();
    	e.stopPropagation();
    })
	document.onclick=function () {
        $(".com-administrator").children(".header_change").hide();
    }
    document.onscroll=function () {
        $(".com-administrator").children(".header_change").hide();
    }


	//换页特效
	$(".em-page a").click(function() {
		if ($(this).hasClass("next")) {
			var pre = $(".em-page a").filter(".bg").index(); //获取当前角标
			pre++;
			$(".num").html(pre);
			if (pre > 0)
				$(this).siblings("a").removeClass("bg").siblings("a").eq(pre).addClass("bg");
		} else if ($(this).hasClass("up")) {
			var pre = $(".em-page a").filter(".bg").index();
			pre--;
			$(".num").html(pre);
			if (pre > 0)
				$(this).siblings("a").removeClass("bg").siblings("a").eq(pre).addClass("bg");
		} else {
			$(this).addClass("bg").siblings("a").removeClass("bg");
		}
	})




	

	//工作评语部分字数限制
	$(".ev-say").keyup(function() {
		var num = $.trim($(".ev-say").val()).length;
		var str = $.trim($(".ev-say").val());
		if (num >= 500) {
			var newstr = str.substr(0, 500);
			$(".ev-say").val(newstr);
		}
		
		$(".count").html(num);
	})
     

	$(".close").click(function() {
		$(".evaluate-add").add("#employee-zhao").hide();
	})

    //阶段评价
    $(document).on("click",".sel-stage li:not('.sel-gray')",function(){
    	    $(".leave-tip,.want-tip").css("visibility","hidden");
		    $(this).addClass("selected").siblings().removeClass("selected");
			var selected = $(".selected").attr("data-stage-id");
			$("#txt-sel-stage").attr("value", selected);
			var stageId = $(this).attr("data-stage-id");
			$("#txt-sel-stage").attr("value", stageId);
	
			var selected1 = $(".selected").attr("data-want-id");
			$("#txt-wantRecall").attr("value", selected1);
			var wantId = $(this).attr("data-want-id");
			$("#txt-wantRecall").attr("value", wantId);
		
	})
    
	//添加审核人弹框 --空
	$(".close1,.person1 button").click(function() {
		$(".person1").add("#alertzhe").hide();
		$(".person2").add("#alertzhe").hide();
	})


	//添加审核人非空
	$(".rect").click(function() {
		$(".person1").add("#alertzhe").show();
		$(".person2").add("#alertzhe").show();
		var values = $("#txt-audit-persons").val().split(",");
		$(".pp span").each(function() {
			var personId = $(this).data("person-id");
			for (var i = 0; i < values.length; i++) {
				if (values[i] == personId)
					$(this).addClass("bg-add");
			}
		});
	})

	$(".pp span").click(function() {
		if ($(this).hasClass("bg-add"))
			$(this).removeClass("bg-add");
		else
			$(this).addClass("bg-add");
	})

	$(".person2 button").click(function() {
		var values = [];
		var selectItem = [];
		$(".person2 span").each(function() {
			if ($(this).hasClass("bg-add")) {
				values.push($(this).data("person-id"));
				selectItem.push($(this).html());
			}
		});

		$(".ev-person ul").html("");
		for (var i = 0; i < values.length; i++) {
			$("<li data-val=" + values[i] + ">" + selectItem[i] + '<span class="del"><i class="iconfont">&#xe647;</i></span>' + "</li>").appendTo(".ev-person ul");
		}
		$("#txt-audit-persons").val(values.join(","));
		$(".person2").add("#alertzhe").hide();




	})

	//删除审核人
	$(document).on("click",".del",function(){
		var dataVal = $(this).parent().attr('data-val');
		$(this).parent("li").remove();
		var inpVal = $("#txt-audit-persons").val();
	    var inpArr = inpVal.split(",");
		for (var i = 0; i < inpArr.length; i++) {
			if (inpArr[i] == dataVal) {
				delete inpArr[i];
			}
		}
		$("#txt-audit-persons").val(inpArr);
		$(".pp span").each(function(){
            for(var i=0;i<inpArr.length;i++){
	            if($(this).attr("data-person-id")!=inpArr[i]){
	                 $(this).removeClass("bg-add");
	            }
	        }
		})
    });




	//员工档案，输入薪资字数限制
	$(".per-salary").bind("keyup blur",function() {
        var str = $(this).val();
		if (str.match(/^\+?(:?(:?\d+\.\d+)|(:?\d+))$/)) {
			var value = str.replace(/^(\-)*(\d+)\.(\d\d).*$/, '$1$2.$3');
			$(this).val(value);
			if (value < 3 || value > 999) {
				$(this).siblings(".salary-tip").show();
			} else {
				$(this).siblings(".salary-tip").hide();
			}
		} else if(str==""){
			$(this).siblings(".salary-tip").hide();
		}else {
			$(this).siblings(".salary-tip").show();
		}

	})

	//选择所在部门
	$(document).on('click', ".dep-Id", function() {
		$(".dep-bg,.dep-add").css({"margin-top": "($('.txt-department').height())/-2" });
		$(".dep-add .red").css({"visibility": "hidden"});
		index = $(".dep-Id").index(this);   //获取当前文本框的索引
		$(".txt-department").show();
		$(".dep-bg").height($(".dep-add").height() + 20);
		var depval=$(this).val();

         $(".dep-con span").each(function(){   //遍历部门，若等于文本框中的值，则添加高亮
         	if($(this).html()==depval){
         	   $(this).addClass("selected").siblings().removeClass("selected");
         	}else{
         		$(this).removeClass("selected");
         	}
         })
	})

	$(document).on('click', ".dep-con span", function() {
			$(this).addClass("selected").siblings().removeClass("selected");
			$('.dep-Id:eq(' + index + ')').val($(this).html());
			$(".txt-department").hide();
		})
	
	//添加部门
	$('.dep-add button').click(function() {
		if ($.trim($(".dep-add input").val()) == "") {
			$(".dep-add .red").css({
				"visibility": ""
			});
		} else {
			$('.dep-Id:eq(' + index + ')').val($.trim($(".dep-add input").val()));
			$(".dep-con span").removeClass("selected");
			$('<span>' + $.trim($(".dep-add input").val()) + '</span>').addClass("selected").appendTo(".dep-con");
			$(".dep-bg").height($(".dep-add").height() + 20);
			$(".dep-add input").val("");
			$(".txt-department").hide();
		}
	})


	//添加部门时字数不能超过10字符
	$(".new-dep input").keyup(function() {
		var num = $(this).val().length;
		if (num > 10) {
			var str = $(this).val().substr(0, 10);
			$(this).val(str);
		}
	})


	$(".person-tt i").click(function() {
		$(".txt-department").hide();
	})


	//查看档案弹框
	$(".files-detail .see").click(function() {
		$("#alert>.alertT>span").text("开通会员");
		$(".alertB").html('<div class="file-con"><p>服务年费：<span>20</span>元</p></div>');
		$(".newJobSaveBtn").text("去支付");
		$(".file-tip").html('<p>会员特权</p><p>1，免费查看对自己的评价</p><p>2，查看热招职位，免费求职</p>')
		alertwin();
		$(".file-con input").val($(".files-identity input").val());
	})



	//提现部分

	$(".withDraw-crash input").click(function() {
		//      $("#alert>.alertT>span").text("提现");
		//      $(".alertB").html('<div class="moneyNum"><p>我的口袋：5000元</p><p>可提现金额：3000元</p><p class="bank-title">提现金额</p><input type="text" name="MoneyNumber" placeholder="请输入提现金额"></div><p class="bank-title">个人银行账号</p><div class="pocket-con">开户名&nbsp;&nbsp; ：<input type="text" name="CompanyName"	placeholder="请输入银行开户名" required><br></div><div class="pocket-con">开户银行：<input type="text" name="BankName" placeholder="请输入银行营业网点" required><br></div><div class="pocket-con">银行账号：<input type="text" name="BankCard" placeholder="请输入银行账号" required><br></div>');
		//      $(".newJobSaveBtn").text("提现");
		//      $(".file-tip").html('<p>提现说明：</p><p>提现成功提交后，老板点评将在一周内打款</p>')
		alertwin();
	})

	//  $("#alert .newJobSaveBtn").click(function () {
	//       var moneyNum=$(".moneyNum input").val();
	//       var companyName=$(".pocket-con:eq(0) input").val();
	//       var bankName=$(".pocket-con:eq(1) input").val();
	//       var bankCard=$(".pocket-con:last-child input").val();
	//      $(".alertB").html('<div class="moneyNum"><p>我的口袋：5000元</p><p>可提现金额：3000元</p><p class="bank-title">提现金额<span>'+moneyNum+'</span>元</p></div><p class="bank-title">个人银行账号信息</p><div class="pocket-con">开户名&nbsp;&nbsp; ：'+companyName +'<br></div><div class="pocket-con">开户银行：'+bankName+'<br></div><div class="pocket-con">银行账号：'+bankCard+'<br></div>');
	//  
	//  })



	/*按钮触发事件，填写内容*/
	$("#btnWithDraw").click(function() {
		$("#submitWithDraw").data("step", "One");
		$("#alert>.alertT>span").text("提现");
		$("#alert>.alertB").html($("#WithDrawContainer").html());
		$("#alert div[role='WithDraw-Step-One']").show();
		$("#submitWithDraw").resetPostStatus();
		$("#submitWithDraw").show();
		alertwin();

		var canWithdrawBalance = parseFloat($("#alert span[role='CanWithdrawBalance']").text());
		var rulesForWithDrawMoney = window.formValidateRules.rules["WithDrawMoney"];
		rulesForWithDrawMoney["max"] = canWithdrawBalance;
		rulesForWithDrawMoney["messages"] = window.formValidateRules.messages["WithDrawMoney"];
		$("#alert input[name='WithDrawMoney0']").rules("add", rulesForWithDrawMoney);
		$("#alert input[name='WithDrawMoney1']").rules("add", rulesForWithDrawMoney);
	});



	// /*关闭弹窗*/
	// function XXXalert() {
	//     $("#alertClose").click(function () {
	//         $("#zhezhao").css("display","none");
	//         $("#alert>.alertT>span").text("");
	//         $(".alertB").html("");
	//         $(".newJobSaveBtn").text("");
	//         $(".power_person_details").html("");
	//         $(".patch").html("");
	//     })
	// }

	/*封装弹框事件*/
	window.alertwin = function() {
		var zhezhao = document.getElementById('zhezhao');
		var alertform = document.getElementById('alert');
		var alertClose = document.querySelectorAll('.alertClose');
		zhezhao.style.display = 'block';
		var height = alertform.offsetHeight;
		alertform.style.marginTop = -(height / 2) + 'px';
		zhezhao.style.width = document.documentElement.clientWidth + 'px';
		zhezhao.style.height = document.documentElement.clientHeight + 'px';
		for (var i = 0; i < alertClose.length; i++) {
			alertClose[i].onclick = function() {
				zhezhao.style.display = 'none';
			}
		}
		window.onresize = function() {
			zhezhao.style.width = document.documentElement.clientWidth + 'px';
			zhezhao.style.height = document.documentElement.clientHeight + 'px';
		}
	}

	window.alertLoading=function () {
		$('#zhezhao').show();
		$('#alert').hide();
		$('#loadingpic').show()
    }
    window.removeLoading=function () {
        $('#zhezhao').hide();
        $('#alert').show();
        $('#loadingpic').hide()
    }

	//收听语音
	var $audio = $('.audio');
	if ($audio.length > 0) {
		click();
		var styleChange = {
			pause: {},
			play: {}
		};
		styleChange.play.change = function(obj) {
			obj.addClass('hidden');
			obj.next('.pause').removeClass('hidden');
		};

		styleChange.pause.change = function(elem) {
			elem.addClass('hidden');
			elem.siblings('.play').removeClass('hidden');
		};
		// 点击播放暂停
		function click() {
			var audio;
			$('.play').on('click', function() {
				if (audio) {
					var elem = $('.pause')
					styleChange.pause.change(elem);
					audio[0].pause();
				}
				var obj = $(this)
				styleChange.play.change(obj);
				var current = $(this).children('audio');
				playCotrol(current);
				audio = $(this).children("audio");
				audio[0].play();
			})
			$('.pause').on('click', function() {
				if (audio) {
					audio[0].pause();
					var obj = $(this);
					styleChange.pause.change(obj);
				}
			})
		}
		// 播放事件监听
		function playCotrol(current) {
			var audio = $(current);
			console.log(audio)
			audio.bind('ended', function() {
				var elem = $('.pause');
				styleChange.pause.change(elem);
			})
		}
	}


	/*outTime-service-wrap*/
    window.outTimeService = function() {
		var zhezhao = document.getElementById('outTime-service-zhezhao');
		var alertform = document.getElementById('outTime-service-alert');
		if(zhezhao){
			zhezhao.style.display = 'block';
			var height = alertform.offsetHeight;
			alertform.style.marginTop = -(height / 2) + 'px';
			zhezhao.style.width = document.documentElement.clientWidth + 'px';
			zhezhao.style.height = document.documentElement.clientHeight + 'px';
		}
    }
        outTimeService();
})
