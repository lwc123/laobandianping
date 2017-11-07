package net.juxian.appgenome.modules;

import net.juxian.appgenome.socialize.ShareMessage;

/**
 * @author: 付晓龙
 * @类 说 明:
 * @version 1.0
 * @创建时间：2015-9-30 下午1:20:49
 * 
 */
public class ShareMessageBuilder {

	public static ShareMessage BuildByTrends(String title, String content,
											 String targeurl, String imgurl) {
		ShareMessage message = new ShareMessage();
		message.Title = title;
		message.Content = content;
		message.TargetUrl = targeurl;
		message.setImageUrl(imgurl);
		return message;
	}
}
