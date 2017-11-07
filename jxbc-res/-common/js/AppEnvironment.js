window.getUrlParam = function(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return decodeURIComponent(r[2]);return null;
};

window.AppEnvironment = {
	//apiRoot:"http://bc-api.jux360.cn:8120/v-test",
	apiRoot:"/api",   
	bizSources: {
		OpenEnterpriseService   : "OpenEnterpriseService",
        RenewalEnterpriseService: "RenewalEnterpriseService",
		BuyBackgroundSurvey     : "BuyBackgroundSurvey"
	},
    bizTypes: {
		StageEvaluation : 1,
		DepartureReport : 2
	},
    TradeTypes: {
		PersonalToPersonal      : 1,
		PersonalToOrganization  : 2,
        OrganizationToPersonal  : 3,
        OrganizationToOrganization  : 4
	},  
    TradeModes: {
		Payoff : 1,
		Payout : 2
	},     
    companyId   : getUrlParam("CompanyId"),
    inviteCode  : getUrlParam("InviteCode")
};
window.AppBase = {
	toast:function(html,millisec) {
		var $toast = $("#toast");

		if(millisec===undefined || millisec == null)
            millisec = 2000;

		if($toast.size() == 0) {
            $(document.body).append("<div id='toast' class='toast'></div>");
            $toast = $("#toast");
		}

        $toast.html(html);
		var left = $(document.body).width()/2-$toast.width()/2;
		var $sidebar = $("#sidebar");
		if($sidebar) left = left + $sidebar.width()/2;
        $toast.css("left",left).show();
        setTimeout(function(){
            $("#toast").hide();
        },millisec);
	},
    navigate:function(url) {
        var lnkTarget = $("#lnkTarget");
        if(lnkTarget.size() ==0) {
            $("body:eq(0)").append('<a id="lnkTarget" href="#" style="display:none">i im a link</a>');
            lnkTarget = $("#lnkTarget");            
        }
        lnkTarget.attr("href",url);
        if (/msie/i.test(navigator.userAgent)) //IE
        {
            $("#lnkTarget")[0].fireEvent("onclick");
        } else {
            var e = document.createEvent('MouseEvent');
            e.initEvent('click', false, false);
            $("#lnkTarget")[0].dispatchEvent(e);
        }
    }
};
