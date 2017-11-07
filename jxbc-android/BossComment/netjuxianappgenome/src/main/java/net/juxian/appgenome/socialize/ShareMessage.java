package net.juxian.appgenome.socialize;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.R;
import net.juxian.appgenome.utils.TextUtil;
import net.juxian.appgenome.widget.ImageLoader;
import android.graphics.Bitmap;

import com.umeng.socialize.media.UMImage;

public class ShareMessage {

	public ShareMessage() {
	}

	public String Title;
	public String TargetUrl;
	public String Content;
	private String imageUrl;
	private UMImage shareImage;
	private Bitmap imageData;

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
		this.imageData = ImageLoader.getSingleton().getCachedBitmap(this.imageUrl, 128, 128);
	}

	public UMImage getShareImage() {		
		if(null != this.shareImage) return this.shareImage;
		if(null == this.imageData) {
			if(TextUtil.isNullOrEmpty(this.imageUrl)) {
				LogManager.getLogger().d("share-UMImage-appIcon");
				this.shareImage = new UMImage(ActivityManager.getCurrent(),	R.drawable.app_icon_share);
			} else {
				LogManager.getLogger().d("share-UMImage-imageUrl");
				this.shareImage = new UMImage(ActivityManager.getCurrent(),	this.imageUrl);
			}
			
		} else {
			LogManager.getLogger().d("share-UMImage-imageData");
			this.shareImage = new UMImage(ActivityManager.getCurrent(),	this.imageData);
		}

		return this.shareImage;
	}	
}
