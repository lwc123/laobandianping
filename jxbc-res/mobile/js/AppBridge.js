$(document).ready(function() {
	function _intiApp() {
		if(window.AppBridge) {
			var initialized = false;
			AppBridge.embeddedAppView = true;					
			var appInfo = JSON.parse(AppBridge.getAppInfo());
			if(typeof(appInfo)=="object" && typeof(appInfo.device)=="string") {
				if(typeof(appInfo.token)=="string" && appInfo.token.length>8) {
					document.cookie = "device="+escape (appInfo.device)+";path=/";
					document.cookie = "JX-TOKEN="+escape(appInfo.token)+";path=/";
					initialized = true;
				}
			}
			if (!initialized) console.error("Initialize app failed.");
		} else {
			window.AppBridge = {embeddedAppView:false};
			window.AppBridge.gotoNativePage = function(pageName,pageParams) {
				console.warn("JsBridge:gotoNativePage('%s',%s);",pageName,pageParams);
			}	
		}
	}
	function _bindAppAction(){
		$("[data-target='app:gotoNativePage']").click(function(){
			var pageName = $(this).data("page-name");
			var pageParams = JSON.stringify($(this).data("page-params"));
			//alert("JsBridge:gotoNativePage:('"+pageName+"',"+pageParams+")"); //test
			AppBridge.gotoNativePage(pageName,pageParams);
		});
        if(AppBridge.embeddedAppView && navigator.userAgent.toLowerCase().indexOf("android")>-1){
            $("a[data-target='app:tel']").click(function(){
                var pageName = "tel";
                var pageParams = $(this).attr("href");
                //alert("JsBridge:gotoNativePage:('"+pageName+"',"+pageParams+")"); //test
                AppBridge.gotoNativePage(pageName,pageParams);
                return false;
            });
        }
	}
	
	_intiApp();
	_bindAppAction();
});