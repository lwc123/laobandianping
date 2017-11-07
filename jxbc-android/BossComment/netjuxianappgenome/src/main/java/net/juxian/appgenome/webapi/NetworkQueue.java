package net.juxian.appgenome.webapi;

import java.io.File;

import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.utils.FileUtil;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.net.http.AndroidHttpClient;
import android.os.Build;

import com.android.volley.Network;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.BasicNetwork;
import com.android.volley.toolbox.DiskBasedCache;
import com.android.volley.toolbox.HttpClientStack;
import com.android.volley.toolbox.HttpStack;
import com.android.volley.toolbox.HurlStack;

public class NetworkQueue {

	private static final String DEFAULT_CACHE_DIR = "volley";
	private static final int DEFAULT_NETWORK_THREAD_POOL_SIZE = 6;
	private static final int DEFAULT_DISK_USAGE_BYTES = 128 * 1024 * 1024;

	public static RequestQueue newQueue() {
		File cacheDir = new File(FileUtil.getCachePath(DEFAULT_CACHE_DIR));

		Network network = buildNetwork();

		RequestQueue queue = new RequestQueue(new DiskBasedCache(cacheDir,
				DEFAULT_DISK_USAGE_BYTES), network,
				DEFAULT_NETWORK_THREAD_POOL_SIZE);
		queue.start();

		return queue;
	}

	public static Network buildNetwork() {
		Context context = AppContextBase.getCurrentBase();
		String userAgent = "net.juxian.appgenome.webapi-0";

		try {
			String packageName = context.getPackageName();
			PackageInfo info = context.getPackageManager().getPackageInfo(
					packageName, 0);
			userAgent = packageName + "-" + info.versionCode;
		} catch (Exception e) {
		}

		HttpStack stack = null;
		if (Build.VERSION.SDK_INT >= 9) {
			stack = new HurlStack();
		} else {
			// Prior to Gingerbread, HttpUrlConnection was unreliable.
			// See:
			// http://android-developers.blogspot.com/2011/09/androids-http-clients.html
			stack = new HttpClientStack(
					AndroidHttpClient.newInstance(userAgent));
		}

		Network network = new BasicNetwork(stack);
		return network;
	}
}
