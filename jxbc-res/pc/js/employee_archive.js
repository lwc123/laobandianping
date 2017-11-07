var deptHtml = $("#depinfo1").prop("outerHTML");
$(document).on('click', "#addDept", function() {
	var index = $("#deptCount").val();
	var newIndex = parseInt(index) + 1;
	var id=$(this).prev().attr("id");
	var newId=id.substring(0, id.length - index.length) + newIndex;
	$(this).prev().attr("id",newId);
	$("#deptCount").val(newIndex);
	$(this).before(deptHtml);
	$(this).prev().find(".com-tt .count").text(newIndex);
	$(this).prev().find(".com-tt").append("<span class='delete'><a href='#' class='blue'>删除</a></span>");
	
	$(this).prev().find("input").each(function() {
		$(this).val("");
		var sourceName = this.name;
		var newName = this.name.substring(0, sourceName.length - index.length) + newIndex;
		this.name = newName;
		if (window.formValidateRules.rules[sourceName]) {
			var rule = window.formValidateRules.rules[sourceName];
			if (rule["compareDate"]) {
				rule["compareDate"] = rule["compareDate"].substring(0, rule["compareDate"].length - index.length) + newIndex;
			}
			rule["messages"] = window.formValidateRules.messages[sourceName];
			$(this).rules("add", rule);
		}
	});
	//员工职务结束时间	
    $(".now").change(function(){
    	if($(this).prop("checked")){
    		$(this).parent().children(".selectDate").val("至今").attr("readonly","readonly");
    		$(this).parent().children("label").hide();
    		$(this).prev().datepicker("disable").attr("readonly","readonly");
    		$(this).prev().removeAttr("disabled");
    	}else{
    		$(this).parent().children(".selectDate").val("").attr("placeholder","请输入职务结束时间");
    		$(this).prev().datepicker('enable');
    		$(this).prev().removeAttr("readonly");
    	}
    })
    
    var radioVal;
	var radioVal = $('input:radio[name="IsDimission"]:checked').val();
	if (radioVal == 1) {
		$(".now").attr("disabled", "disabled");
	}
    $('input:radio[name="IsDimission"]').change(function() {
		radioVal = $(this).val();
		if (radioVal == 1) {
			$(".now").attr("disabled", "disabled");
			$(".dimisstime").removeAttr("disabled");
			$(".dimisstime-tip").hide();
		} else {
			$(".now").removeAttr("disabled");
			$(".dimisstime").attr("disabled", "disabled");
			$(".dimisstime-tip").show();
		}
	})
    
    $(".selectDate").each(function(){
    	if($(this).val()=="至今"){
    		$(this).parent().children("input[type=checkbox]").attr("checked","checked");
    	}
    })

	$(this).prev().find("input.selectDate").each(function() {
		initdatepicker_cn();
		$(this).datepicker({
			"inline": true,
			"changeYear": true,
			"changeMonth": true,
			"dateFormat": "yy-mm-dd",
			"yearRange": "1945:2017",
			"minDate": "-70y",
			"maxDate": "newDate()",
			onClose: function() {
				$(this).blur();
				$(this).parent().siblings().children("input.selectDate").blur();
			}
		})
	});

	function initdatepicker_cn() {
		$.datepicker.regional['zh-CN'] = {
			clearText: '清除',
			clearStatus: '清除已选日期',
			closeText: '关闭',
			closeStatus: '不改变当前选择',
			prevText: '<上月',
			prevStatus: '显示上月',
			prevBigText: '<<',
			prevBigStatus: '显示上一年',
			nextText: '下月>',
			nextStatus: '显示下月',
			nextBigText: '>>',
			nextBigStatus: '显示下一年',
			currentText: '今天',
			currentStatus: '显示本月',
			monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
			monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
			monthStatus: '选择月份',
			yearStatus: '选择年份',
			weekHeader: '周',
			weekStatus: '年内周次',
			dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
			dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
			dayNamesMin: ['日', '一', '二', '三', '四', '五', '六'],
			dayStatus: '设置 DD 为一周起始',
			dateStatus: '选择 m月 d日,DD',
			dateFormat: 'yy-mm-dd',
			firstDay: 1,
			initStatus: '请选择日期',
			isRTL: false
		};
		$.datepicker.setDefaults($.datepicker.regional['zh-CN']);
	}


	$(document).on('click', ".delete", function() {
		$(this).parents(".depinfo").remove();
		newIndex = newIndex - 1;
		$("#deptCount").val(newIndex);
	});
});



$(document).ready(function() {
	//员工职务结束时间	
    $(".now").change(function(){
    	if($(this).prop("checked")){
    		$(this).parent().children(".selectDate").val("至今").attr("readonly","readonly");
    		$(this).parent().children("label").hide();
    		$(this).prev().datepicker("disable").attr("readonly","readonly");
    		$(this).prev().removeAttr("disabled");
    	}else{
    		$(this).parent().children(".selectDate").val("").attr("placeholder","请输入职务结束时间");
    		$(this).prev().datepicker('enable');
    		$(this).prev().removeAttr("readonly");
    	}
    })
    $(".selectDate").each(function(){
    	if($(this).val()=="至今"){
    		$(this).parent().children("input[type=checkbox]").attr("checked","checked");
    	}
    })
	//判断员工的在职状态
	var radioVal;
	var radioVal = $('input:radio[name="IsDimission"]:checked').val();
	if (radioVal == 0) {
		$(".dimisstime").attr({"disabled":"disabled",'placeholder':'在职，可不填'});
		$(".dimisstime-tip").show();
	}else{
		$(".now").attr("disabled", "disabled");
	}
	$('input:radio[name="IsDimission"]').change(function() {
		radioVal = $(this).val();
		if (radioVal == 1) {
            $(".dimisstime").attr({'placeholder':'请输入离职日期'});
			$(".now").attr("disabled", "disabled");
			$(".dimisstime").removeAttr("disabled");
			$(".dimisstime-tip").hide();
		} else {
			$(".now").removeAttr("disabled")
            $(".dimisstime").attr({"disabled":"disabled",'placeholder':'在职，可不填'});
			$(".dimisstime-tip").show();
		}
	})



})