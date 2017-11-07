package net.juxian.appgenome;

public interface IAppModule {

	boolean asyncStart();
	
	void onStart(AppContextBase context);
	void onEnd(AppContextBase context);	
	void onAuthenticatedStateChanged(AppContextBase context);
}
