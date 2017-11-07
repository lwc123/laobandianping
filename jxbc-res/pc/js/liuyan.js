$(function () {
    $("#nmessagebtn").click(function () {
        var isget = $(this).attr("isget");
        if (isget ==1)
        {
            return;
        }
        var site = "天拓汇";
        var c1 = $("#messagecontents1").val();
        var c2 = $("#messagecontents2").val();
        var c3 = $("#messagecontents3").val();
        var course ="88老板点评";
         
        if(course==NaN)
        {
        	course="";
        	
        }
     
        var local = document.location.href;
        var source = document.referrer;
        var tel = $("#tel").val();
        if (!/^(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])\d{8}$/i.test(tel)) {
            alert('请输入正确的手机号码！');
            return;
        }
        
        if (c1 == "") {
            alert("请输入姓名");
            return;
        }
        if (c2 == "") {
            alert("请输入年龄");
            return;
        }
         
		 $(this).attr("isget", "1");
		alert("已经成功留言，请等待我们的回复！");
        $.ajax("http://crm.neline.com.cn/sms/message.ashx?typeid=3&site=" + site + "&c1=" + c1 + "&c2=" + c2 + "&c3=" + c3 + "&course=" + course + "&local=" + local + "&source=" + source + "&tel=" + tel ,
           {
           	
               type:"get",
               dataType: "jsonp",
               jsonp: 'callbackparam',
               success: function (json) {
                   $(this).attr("isget", "0");
                   if (json[0].error == 0) {
                       alert("已经成功留言，请等待我们的回复！");
                   }
                   else {
                       alert('服务器返回一个错误，请稍候重试！');
                   }
               } 
           });
    });
});