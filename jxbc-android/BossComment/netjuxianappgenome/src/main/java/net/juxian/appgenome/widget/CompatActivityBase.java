package net.juxian.appgenome.widget;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.SparseArray;

import com.umeng.socialize.controller.UMSocialService;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.socialize.ShareMessage;
import net.juxian.appgenome.socialize.ShareUtil;
import net.juxian.appgenome.socialize.SocialManager;
import net.juxian.appgenome.utils.AnalyticsUtil;
import net.juxian.appgenome.utils.AppConfigUtil;

public abstract class CompatActivityBase extends AppCompatActivity {
	public static final int REQUEST_CODE_SEED = 1024;
	private String pageName;
	private SparseArray<IResultListener> resultListenerArray;
	public boolean firstLoadData = true;
	public Dialog dl = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ActivityManager.add(this);
		this.pageName = this.getClass().getName();

	}

	@Override
	protected void onStart() {
		super.onStart();
		ActivityManager.setCurrent(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		ActivityManager.finish(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		AnalyticsUtil.onPageEnd(this, this.pageName);
	}

	@Override
	protected void onResume() {
		super.onResume();
		AnalyticsUtil.onPageStart(this, this.pageName);
	}

	public void startActivityForResult(Class<?> clazz, Bundle bundle) {
		this.startActivityForResult(clazz, bundle, new IResultListener() {
			@Override
			public void onReturn(int resultCode, Bundle bundle) {
				//
			}
		});
	}

	public void startActivityForResult(Class<?> clazz, Bundle bundle,
			IResultListener listener) {
		this.startActivityForResult(clazz, bundle, -1, listener);
	}

	public void startActivityForResult(Class<?> clazz, Bundle bundle,
			int flags, IResultListener listener) {
		Intent intent = new Intent(this, clazz);
		if (flags > 0)
			intent.setFlags(flags);
		if (null != bundle)
			intent.putExtras(bundle);
		if (null == this.resultListenerArray)
			this.resultListenerArray = new SparseArray<IResultListener>();

		int requestCode = REQUEST_CODE_SEED + this.resultListenerArray.size();
		this.resultListenerArray.put(requestCode, listener);

		LogManager.getLogger().i("startActivityForResult Rc: %s", requestCode);

		this.startActivityForResult(intent, requestCode);
	}

	protected void returnResult(int resultCode, Bundle data) {
		LogManager.getLogger().i("returnResult: %s", resultCode);

		Intent intent = new Intent();
		if (null != data)
			intent.putExtras(data);

		this.setResult(resultCode, intent);
		this.finish();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// ToastUtil.showInfo("requestCode:%s, Result: %s", requestCode,
		// resultCode);
		ActivityManager.setCurrent(this);
		if (null == this.resultListenerArray
				|| 0 > this.resultListenerArray.indexOfKey(requestCode)) {
			LogManager
					.getLogger()
					.i("onActivityResult[listener==null]:requestCode:%s, Result: %s",
							requestCode, resultCode);
			// ToastUtil.showInfo(resultCode + "");
			return;
		}

		LogManager.getLogger().i(
				"onActivityResult:Listener %s, RC: %s Result: %s",
				this.getClass(), requestCode, resultCode);
		this.resultListenerArray.get(requestCode).onReturn(resultCode,
				RESULT_CANCELED == resultCode ? null : data.getExtras());
	}

	private UMSocialService shareService = null;

	public void share(ShareMessage message) {
		if (null == shareService)
			shareService = SocialManager.getShareService(this);
		ShareUtil.resetShareMedia(shareService, message);
		shareService.openShare(this, false);
	}

	public void initPage(){

	}

	public void checkNetStatus(){

	}

	public void optionsCheckNetStatus(){
		if (!firstLoadData) {
			if (AppConfigUtil.NETWORK_DISABLE != AppConfigUtil.getNetworkStatus()) {
				// 网络可用
				if (null != dl)
					dl.dismiss();
				ToastUtil.showInfo("网络超时");
			} else {
				// 网络不可用
				if (null != dl)
					dl.dismiss();
				ToastUtil.showInfo("未开启移动网络或Wifi？");
			}
		}
	}

	public void loadData(){
		loadPageData();
	}

	public void loadPageData(){

	}

	public void onRetry(){
		loadPageData();
	}
}
