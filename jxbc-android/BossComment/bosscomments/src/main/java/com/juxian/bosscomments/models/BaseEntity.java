package com.juxian.bosscomments.models;

import net.juxian.appgenome.utils.JsonUtil;

public class BaseEntity {
	public BaseEntity() {
	}

	@Override
	public String toString() {
		return JsonUtil.ToJson(this);
	}
}
