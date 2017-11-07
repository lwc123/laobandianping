package net.juxian.appgenome;

import net.juxian.appgenome.utils.AnalyticsUtil;

public class CommonModule implements IAppModule {

	@Override
	public boolean asyncStart() {
		return false;
	}

	@Override
	public void onStart(AppContextBase context) {
		AnalyticsUtil.initialize();
	}

	@Override
	public void onEnd(AppContextBase context) {

	}

	@Override
	public void onAuthenticatedStateChanged(AppContextBase context) {
		String accountKey = context.getAuthentication().getAccountKey();
	}

}
