package com.juxian.bosscomments.modules;


import com.juxian.bosscomments.AppContext;

import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.IAppModule;

public class AsyncAppModule implements IAppModule {

	// 在AppContext中初始化这个类，然后调用了onStart方法，初始化一次token
	@Override
	public boolean asyncStart() {
		return true;
	}

	@Override
	public void onStart(AppContextBase context) {
		// 初始化token，在第一次打开app的时候调用，保存token
		// 先通过AppContext获取到application（通过单例模式获取到），然后再获取到UserAuthentication对象
		AppContext.getCurrent().getUserAuthentication().initAccessToken();
//		DictionaryPool.loadDictionaries();

	}

	@Override
	public void onEnd(AppContextBase context) {
	}

	@Override
	public void onAuthenticatedStateChanged(AppContextBase context) {
//		AccountEntity account = AppContext.getCurrent().getCurrentAccount();
//		if (null == account || false == account.isAuthenticated())
//			return;

	}
}
