/*
$.validator.setDefaults({
    submitHandler: function() {
      alert("提交事件!");
    }
});
*/

$().ready(function() {
	// 在键盘按下并释放及提交后验证提交表单
	jQuery.validator.addMethod("isMobile", function(value, element) {

		var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
		return this.optional(element) || (value.length = 11 && mobile.test(value));
	}, "请正确填写您的手机号码");

	//开始时间和结束时间的验证
	jQuery.validator.methods.compareDate = function(value, element, param) {
		var startDate = $("form input[name='" + param + "']").val();
		var endDate = value == "至今" ? "3000-01-01" : value;
		var date1 = Date.parse(startDate.replace(/\s/g,'T').replace(/\//g,'-'));
		var date2 = Date.parse(endDate.replace(/\s/g,'T').replace(/\//g,'-'));
		return date1 < date2;
	};

	//薪资大小比较
    jQuery.validator.methods.compareMoney = function(value, element, param) {
        var minMoney= $("form input[name='" + param + "']").val();  
        var min = parseInt(minMoney);
        var maxMoney = parseInt(value);
        var result=min<=maxMoney;
        return result;
    };

	jQuery.validator.addMethod("isCard", function(value, element) {
		var isIDCard1 = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$/; //(15位)
		var isIDCard2 = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/; //(18位)
		return this.optional(element) || (isIDCard1.test(value)) || (isIDCard2.test(value));
	}, "请填写正确的身份证号码");

	jQuery.validator.addMethod("checkEmail", function(value, element) {
		var mail = /^[a-z0-9._%-]+@([a-z0-9-]+\.)+[a-z]{2,4}$/;
		return this.optional(element) || (mail.test(value));
	}, "邮箱格式不对");

	window.formValidateRules = {
		ignore:"#idcard",
		rules: {
			CompanyName: {
				required: true,
				maxlength: 30
			},
			CompanyAbbr: {
				required: true,
				maxlength: 10
			},
			WorkComment: "required",
			Industry: "required",
			CompanySize: "required",
			Region: "required",
			LegalName: {
				required: true,
				maxlength: 5
			},
			ValidationCode: "required",
			EntryTime: "required",
			DimissionTime: "required",
			Education: "required",
			JobTitle: "required",
			DeptName: "required",
			BankOwnerName: "required",
			BankName: "required",
			BankCard: "required",
			JobName: "required",
			SalaryRangeMin:{
				required: true,
				min:3000,
				number:true
			},
			SalaryRangeMax:{
				required: true,
				number:true,
				compareMoney:"SalaryRangeMin"
			},
			JobCity: "required",
			JobLocation: "required",
			ExperienceRequire: "required",
			EducationRequire: "required",
			JobDescription: "required",
			ContactEmail: {
				required: true,
				checkEmail: true
			},
			RealName: {
				required: true,
				maxlength: 5
			},
			GraduateSchool: {
				required: true,
				maxlength: 30
			},
			MobilePhone: {
				required: true,
				maxlength: 11,
				isMobile: true
			},
			IDCard: {
				required: true,
				isCard: true
			},
			Education: "required",
			PostTitle1: {
				required: true,
				maxlength: 30
			},
			PostStartTime1: {
				required: true
			},
			PostEndTime1: {
				required: true,
				compareDate: "PostStartTime1"
			},
			Department1: {
				required: true
			},
			password: {
				required: true,
				minlength: 6
			},
			WithDrawMoney: {
				required: true,
				number: true,
				min: 0.01
			}
		},
		messages: {
			RealName: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入姓名",
				maxlength: "<i class='iconfont'>&#xe640;</i> 名字最多5个汉字"
			},
			password: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入密码",
				minlength: "<i class='iconfont'>&#xe640;</i> 密码长度不能小于 6个字符"
			},
			MobilePhone: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入手机号码",
				maxlength: "<i class='iconfont'>&#xe640;</i> 最多输入11位号码",
				isMobile: "<i class='iconfont'>&#xe640;</i> 您输入的手机号格式错误"
			},
			IDCard: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入身份证号码",
				isCard: "<i class='iconfont'>&#xe640;</i> 请检查身份证号填写是否正确"
			},
			GraduateSchool: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入毕业学校",
				maxlength: "<i class='iconfont'>&#xe640;</i> 毕业学校最多30个汉字"
			},
			JobTitle: "<i class='iconfont'>&#xe640;</i> 请输入担任职务",

			Department1: {
				required: "<i class='iconfont'>&#xe640;</i> 请选择所在部门</p>"
			},
			WorkComment: "<i class='iconfont'>&#xe640;</i> 请输入工作评语",
			EntryTime: "<i class='iconfont'>&#xe640;</i> 请选择入职日期",
			DeptName: "<i class='iconfont'>&#xe640;</i> 请输入部门名称",
			DimissionTime: "<i class='iconfont'>&#xe640;</i> 请选择离任日期",
			PostTitle1: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入职务名称",
				maxlength: "<i class='iconfont'>&#xe640;</i> 担任职务最多30个汉字"
			},
			PostStartTime1: {
				required: "<i class='iconfont'>&#xe640;</i> 请选择担任职务开始时间"
			},
			PostEndTime1: {
				required: "<i class='iconfont'>&#xe640;</i> 请选择担任职务结束时间",
				compareDate: "<i class='iconfont'>&#xe640;</i> 结束时间必须大于开始时间"
			},
			Education: "<i class='iconfont'>&#xe640;</i> 请选择学历",

			BankOwnerName: "<i class='iconfont'>&#xe640;</i> 请输入银行开户名",
			BankName: "<i class='iconfont'>&#xe640;</i> 请输入银行营业网点",
			BankCard: "<i class='iconfont'>&#xe640;</i> 请输入银行账号",

			CompanyName: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入企业名称",
				maxlength: "<i class='iconfont'>&#xe640;</i> 企业名称超过了30个汉字"
			},
			CompanyAbbr: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入公司简称",
				maxlength: "<i class='iconfont'>&#xe640;</i> 企业简称超过了10个汉字"
			},
			Industry: "<i class='iconfont'>&#xe640;</i> 请选择公司行业",
			CompanySize: "<i class='iconfont'>&#xe640;</i> 请选择公司人员规模",
			Region: "<i class='iconfont'>&#xe640;</i> 请选择所在城市",
			JobName: "<i class='iconfont'>&#xe640;</i> 请输入职位名称",
			SalaryRangeMin:{
				required:"<i class='iconfont'>&#xe640;</i> 请输入薪资",
				min:"<i class='iconfont'>&#xe640;</i> 请输入正确的薪资哦~",
				number:"<i class='iconfont'>&#xe640;</i> 请输入正确的薪资哦~"
			 },
			SalaryRangeMax:{
				required:"<i class='iconfont'>&#xe640;</i> 请输入薪资",
				number:"<i class='iconfont'>&#xe640;</i> 请输入正确的薪资哦~",
				compareMoney: "<i class='iconfont'>&#xe640;</i> 最高薪资必须大于最低薪资"
			 },
			JobCity: "<i class='iconfont'>&#xe640;</i> 请选择工作城市",
			JobLocation: "<i class='iconfont'>&#xe640;</i> 请输入工作地点",
			ExperienceRequire: "<i class='iconfont'>&#xe640;</i> 请选择工作年限",
			EducationRequire: "<i class='iconfont'>&#xe640;</i> 请选择学历",
			JobDescription: "<i class='iconfont'>&#xe640;</i> 请输入职位描述",
			ContactEmail: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入接收简历邮箱",
				checkEmail: "<i class='iconfont'>&#xe640;</i> 请输入正确的邮箱地址"
			},
			LegalName: {
				required: "<i class='iconfont'>&#xe640;</i> 请填写企业法人姓名",
				maxlength: "<i class='iconfont'>&#xe640;</i> 法人姓名超过了5个汉字"
			},
			ValidationCode: "<i class='iconfont'>&#xe640;</i> 请输入验证码",

			WithDrawMoney: {
				required: "<i class='iconfont'>&#xe640;</i> 请输入要提现的金额",
				number: "<i class='iconfont'>&#xe640;</i> 请输入要提现的数字金额",
				min: "<i class='iconfont'>&#xe640;</i> 提现金额必须大于0",
				max: "<i class='iconfont'>&#xe640;</i> 提现金额不能大于可提现金额"
			}
		}

	};

	$("form").each(function(i, item) {
		$(item).validate(window.formValidateRules);
	});
     
     
	$("input.selectDate").each(function() {
		initdatepicker_cn();
		$(this).datepicker({
			"changeYear": true,
			"changeMonth": true,
			"dateFormat": "yy-mm-dd",
			"yearRange": "-70:+0",
			"minDate": "-70y",
			"maxDate": "newDate()",
			onClose: function() {
				$(this).blur();
				$(this).parent().siblings().children("input.selectDate").blur();
			},
			onSelect: function(selectedDate) {
				var relatedStartDate = $(this).data("start-date");
				var relatedEndDate = $(this).data("end-date");
				//				console.info("start:%s, end:%s", relatedStartDate, relatedEndDate);
				if (relatedStartDate) {
					$("input[name='" + relatedStartDate + "']").datepicker("option", "maxDate", selectedDate);
				}
				if (relatedEndDate) {
					$("input[name='" + relatedEndDate + "']").datepicker("option", "minDate", selectedDate);
				}
			}
		});
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
			monthNamesShort:  ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
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

});	

//jxFileUpload
$(document).ready(function() {
    window.previewLocalImageFile = function(source, previewContainer) {
        console.info(previewContainer.attr("id"));
        console.info(source.files[0]);
        if (source.files) {
            if(source.files[0]) {
                $(source).data("has-file", true);
                previewContainer.html("");
                var img = document.createElement("img");
                previewContainer.append(img);
                img.onload = function() {
                    img.style.width = "100%";
                    img.style.height = "100%";
                }
                var reader = new FileReader();
                reader.onload = function(evt) {
                    img.src = evt.target.result;
                }
                reader.readAsDataURL(source.files[0]);
            }
        } else { //兼容IE
            source.select();
            source.blur();
            var src = document.selection.createRange().text;
            if(src) {
                $(source).data("has-file", true);
                previewContainer.html("");
                var img = document.createElement("img");
                previewContainer.append(img);

                var sFilter = 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="';
                img.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;
                previewContainer.html("<div style='width:100%;height:100%;" + sFilter + src + "\"'></div>");
            }
        }
    };

    function _init() {
        $("input[type='file']").each(function() {
            var containerId = $(this).data("img-preview");
            if (containerId) {
                var $this = this;
                console.info($this.name);
                var previewContainer = $("#" + containerId);
                previewContainer.click(function() {
                    $this.click();
                });
                $($this).change(function() {
                    previewLocalImageFile(this, previewContainer);
                });
            }
        });
    }
    _init();
});