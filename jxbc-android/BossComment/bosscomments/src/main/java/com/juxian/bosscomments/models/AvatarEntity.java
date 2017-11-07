package com.juxian.bosscomments.models;

import android.util.Log;

import com.juxian.bosscomments.common.Global;

import net.juxian.appgenome.utils.ImageUtil;

public class AvatarEntity {
	public long PassportId;	
	public String AvatarStream;
	
	public void setAvatar(String avatarFile) {
		this.AvatarStream = ImageUtil.toUploadBase64(avatarFile);
		Log.e(Global.LOG_TAG,AvatarStream);
	}
}
