package net.juxian.appgenome.socialize;

import java.util.Map;

import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.JsonUtil;
import android.app.Activity;
import android.util.Log;

import com.android.volley.BuildConfig;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;
import com.umeng.socialize.weixin.controller.UMWXHandler;

public class SocialManager {
	private static final String TAG = LogManager.Default_Tag + ":Social";
	private static final String SocialService_SignIn = "com.umeng.login";
	private static final String SocialService_Share = "com.umeng.share";

	public static UMSocialService getLoginService(Activity activity) {
		UMSocialService loginService = UMServiceFactory
				.getUMSocialService(SocialService_SignIn);


		// UMQQSsoHandler qqSsoHandler = new
		// com.umeng.socialize.sso.UMQQSsoHandler(
		// activity, "1103195425", "amZPXSRcDmAvqANP");

		// UMWXHandler wxHandler = new UMWXHandler(activity,
		// "wx4e03e3fcf7855014",
		// "4f984682dde8875bfaa55b604274f861");
		// wxHandler.addToSocialSDK();
		return loginService;
	}

	public static UMSocialService getShareService(Activity activity) {
		UMSocialService shareService = UMServiceFactory
				.getUMSocialService(SocialService_Share);


		shareService.getConfig().registerListener(getPostListener());
		shareService.getConfig().setPlatforms(SHARE_MEDIA.SINA,
				SHARE_MEDIA.WEIXIN_CIRCLE, SHARE_MEDIA.WEIXIN,
				SHARE_MEDIA.QZONE);

		registerWeiXinHandler(shareService, activity);

		return shareService;
	}

	private static SnsPostListener getPostListener() {
		SnsPostListener snsPostListener = new SnsPostListener() {
			@Override
			public void onComplete(SHARE_MEDIA platform, int eCode,
					SocializeEntity entity) {
				onShareCompleted(platform, eCode, entity);
			}

			@Override
			public void onStart() {
				LogManager.getLogger(TAG).i("share start one");
			}
		};
		return snsPostListener;
	}

	private static void onShareCompleted(SHARE_MEDIA platform, int eCode,
			SocializeEntity entity) {
		if (200 == eCode) {
			Log.i("bobby", "����ɹ�~~~~~~~~~~~~~~~~~~~~~");
			LogManager.getLogger(TAG).i("share success by %s", platform);
		} else {
			Log.i("bobby", "����ʧ��~~~~~~~~~~");
			LogManager.getLogger(TAG)
					.i("share failed  %s:%s ", platform, eCode);
		}
	}

	private static void registerWeiXinHandler(UMSocialService socialService,
			Activity context) {
		// UMWXHandler wxHandler = new UMWXHandler(context,
		// "wx4e03e3fcf7855014",
		// "4f984682dde8875bfaa55b604274f861");
		// wxHandler.addToSocialSDK();
		// UMWXHandler wxCircleHandler = new UMWXHandler(context,
		// "wx4e03e3fcf7855014", "4f984682dde8875bfaa55b604274f861");
		UMWXHandler wxHandler = new UMWXHandler(context, "wxae2889dd481d4049",
				"20a0c14cee553f601f76c41da6458ebd");
		wxHandler.addToSocialSDK();
		UMWXHandler wxCircleHandler = new UMWXHandler(context,
				"wxae2889dd481d4049", "20a0c14cee553f601f76c41da6458ebd");
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();
	}



	public static Boolean bindThirdPassport(SHARE_MEDIA meida,
			Map<String, Object> info) {
		ThirdPassport thirdPassport = buildThirdPassport(meida, info);
		Boolean isBinded = AppContextBase.getCurrentBase().getAuthentication()
				.bindThirdPassport(thirdPassport);

		if (BuildConfig.DEBUG)
			LogManager.getLogger(TAG).d("%s passport ==> %s", meida,
					JsonUtil.ToJson(thirdPassport));
		return isBinded;
	}

	public static Boolean bindThirdPassport(SHARE_MEDIA platform,
			String platformPassportId) {
		ThirdPassport thirdPassport = new ThirdPassport();
		thirdPassport.Platform = convertPlatform(platform);
		thirdPassport.PlatformPassportId = platformPassportId;

		Boolean isBinded = AppContextBase.getCurrentBase().getAuthentication()
				.bindThirdPassport(thirdPassport);

		if (BuildConfig.DEBUG)
			LogManager.getLogger(TAG).d("%s passport ==> %s", platform,
					JsonUtil.ToJson(thirdPassport));
		return isBinded;
	}

	private static ThirdPassport buildThirdPassport(SHARE_MEDIA platform,
			Map<String, Object> info) {

		ThirdPassport thirdPassport = new ThirdPassport();
		thirdPassport.PassportInfo = JsonUtil.ToJson(info);
		thirdPassport.Platform = convertPlatform(platform);
		thirdPassport.PlatformPassportId = String.valueOf(info.get("uid"));
		thirdPassport.Nickname = String.valueOf(info.get("screen_name"));
		thirdPassport.PhotoUrl = String.valueOf(info.get("profile_image_url"));

		return thirdPassport;
	}

	public static String convertPlatform(SHARE_MEDIA platform) {
		if (SHARE_MEDIA.SINA == platform)
			return ThirdPassport.Platform_Weibo;
		else if (SHARE_MEDIA.WEIXIN == platform
				|| SHARE_MEDIA.WEIXIN_CIRCLE == platform)
			return ThirdPassport.Platform_Weixin;
		else if (SHARE_MEDIA.QQ == platform || SHARE_MEDIA.QZONE == platform)
			return ThirdPassport.Platform_QQ;
		else
			return null;
	}
}
