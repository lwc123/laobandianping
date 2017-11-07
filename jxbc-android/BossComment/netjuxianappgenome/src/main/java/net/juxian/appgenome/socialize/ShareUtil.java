package net.juxian.appgenome.socialize;

import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.media.SinaShareContent;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;

public class ShareUtil {
	public static void resetShareMedia(UMSocialService shareService,
			ShareMessage message) {
		resetWeiboMedia(shareService, message);
		resetWeiXinMedia(shareService, message);
		resetCircleMedia(shareService, message);

	}

	private static void resetWeiboMedia(UMSocialService shareService,
			ShareMessage message) {
		SinaShareContent media = new SinaShareContent();
		media.setTitle(message.Title);
		media.setShareContent(String.format("%s %s", message.Content,
				message.TargetUrl));
		media.setShareImage(message.getShareImage());
		shareService.setShareMedia(media);
	}

	private static void resetWeiXinMedia(UMSocialService shareService,
			ShareMessage message) {
		WeiXinShareContent media = new WeiXinShareContent();
		media.setTitle(message.Title);
		media.setShareContent(message.Content);
		media.setTargetUrl(message.TargetUrl);
		media.setShareImage(message.getShareImage());
		shareService.setShareMedia(media);
	}

	private static void resetCircleMedia(UMSocialService shareService,
			ShareMessage message) {
		CircleShareContent media = new CircleShareContent();
		media.setTitle(message.Title);
		media.setShareContent(message.Content);
		media.setTargetUrl(message.TargetUrl);
		media.setShareImage(message.getShareImage());
		shareService.setShareMedia(media);
	}


}
