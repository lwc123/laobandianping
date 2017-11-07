package net.juxian.appgenome.upgrade;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog.Builder;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.ObjectIOCFactory;
import net.juxian.appgenome.R;
import net.juxian.appgenome.models.PackageVersion;
import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.AsyncTaskWrapper;
import net.juxian.appgenome.utils.FileUtil;
import net.juxian.appgenome.widget.ToastUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;

public class UpgradeManager {
	private static final int NOSDCARD = -1;
	private static final int DOWNLOAD_CANCEL = 0;
	private static final int DOWNLOAD_COMPLETED = 1;
	private static final int DOWNLOAD_ERROR = 9;

	private static PackageVersion NewVersion = null;
	private static Boolean IgnoreNewVersion = false;

	private static String UpgradePackageFile = null;
	private static String UpgradePackageFileSize = null;
	private static String DownloadedFileSize = null;
	private static Boolean Downloading = false;
	private static ProgressBar DownloadProgressBar;
	private static TextView DownloadProgressText;
	private static Dialog DownloadDialog;

	public static PackageVersion loadNewVersion() {
		PackageVersion lastVersion = null;
		if (null != NewVersion)
			return NewVersion;

		try {
			lastVersion = ObjectIOCFactory.getSingleton(
					IPackageRepository.class).getLastVersion();
		} catch (Exception e) {
			lastVersion = new PackageVersion();
		}
		PackageVersion currentVersion = AppConfigUtil.getCurrentVersion();

		if (null == lastVersion) {
			LogManager.getLogger().e("Not load PackageVersion");
			return null;
		}
		if (lastVersion.VersionCode <= currentVersion.VersionCode) {
			LogManager.getLogger().i("CurrentVersion is new,  %s:%s >= %s:%s",
					currentVersion.VersionCode, currentVersion.VersionName,
					lastVersion.VersionCode, lastVersion.VersionName);
			return null;
		}

		LogManager.getLogger().i("New version,  %s:%s => %s:%s",
				currentVersion.VersionCode, currentVersion.VersionName,
				lastVersion.VersionCode, lastVersion.VersionName);

		NewVersion = lastVersion;
		return NewVersion;
	}

	public static void checkUpgrades() {
		if (IgnoreNewVersion)
			return;
		if (false == FileUtil.hasSDCard())
			return;
//
		HttpUtils http=new HttpUtils();
		String url="http://ling-web.juxian.com/app/LastVersion";
		http.send(HttpRequest.HttpMethod.GET, url, new RequestCallBack<String>() {
			@Override
			public void onSuccess(ResponseInfo<String> responseInfo) {
				Log.i("JuXian","请求成功，请求到的数据为："+responseInfo.result.toString());
				JSONObject json= null;
				try {
					json = new JSONObject(responseInfo.result.toString());
					PackageVersion newVersion = new PackageVersion();
					newVersion.PackageName=json.getString("PackageName");
					newVersion.VersionCode=json.getInt("VersionCode");
					newVersion.VersionName=json.getString("VersionName");
					newVersion.Description=json.getString("Description");
					newVersion.DownloadUrl=json.getString("DownloadUrl");
					newVersion.EnforcedUpgrades=json.getBoolean("EnforcedUpgrades");
					if (null == newVersion) {
						LogManager.getLogger().e("Not load PackageVersion");
					}else{
						NewVersion=newVersion;
					}
					PackageVersion currentVersion = AppConfigUtil.getCurrentVersion();
					if (newVersion.VersionCode <= currentVersion.VersionCode) {
						LogManager.getLogger().i("CurrentVersion is new,  %s:%s >= %s:%s",
								currentVersion.VersionCode, currentVersion.VersionName,
								newVersion.VersionCode, newVersion.VersionName);
					}else{//更新
						showUpgradeDialog();
					}

					LogManager.getLogger().i("New version,  %s:%s => %s:%s",
							currentVersion.VersionCode, currentVersion.VersionName,
							newVersion.VersionCode, newVersion.VersionName);

				} catch (JSONException e) {

					e.printStackTrace();
				}

			}

			@Override
			public void onFailure(HttpException e, String s) {

			}

		});
		//
//		new AsyncRunnable<PackageVersion>() {
//			@Override
//			protected PackageVersion doInBackground(Void... params) {
//				PackageVersion lastVersion = loadNewVersion();
//				return lastVersion;
//			}
//
//			@Override
//			protected void onPostExecute(PackageVersion lastVersion) {
//				showUpgradeDialog();
//			}
//		}.execute();
	}

	public static void ignoreUpgrades() {
		IgnoreNewVersion = true;
		NewVersion = null;
	}

	public static void clear() {
		NewVersion = null;
		Downloading = false;
		DownloadProgressBar = null;
		DownloadProgressText = null;
		DownloadDialog = null;
	}

	public static void showUpgradeDialog() {
		if (null == NewVersion)
			return;

		Builder builder = new Builder(ActivityManager.getCurrent());
		builder.setTitle("有新的版本更新");
		builder.setMessage(NewVersion.Description);
		builder.setPositiveButton("立即更新", new OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				downloadNewVersion();
			}
		});
		if (NewVersion.EnforcedUpgrades) {
			builder.setNegativeButton("退出", new OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					AppContextBase.getCurrentBase().exit();
					dialog.dismiss();
				}
			});
		} else {
			builder.setNegativeButton("以后再说", new OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					ignoreUpgrades();
					dialog.dismiss();
				}
			});
		}
		builder.setCancelable(false).show();
	}

	private static void downloadNewVersion() {
		if (null == NewVersion)
			return;

		showDownloadDialog();
	}

	@SuppressLint("InflateParams")
	private static void showDownloadDialog() {
		Activity activity = ActivityManager.getCurrent();
		Builder builder = new Builder(activity);
		builder.setTitle("正在下载新版本");

		final LayoutInflater inflater = LayoutInflater.from(activity);
		View view = inflater.inflate(R.layout.upgrade_progress, null);
		DownloadProgressBar = (ProgressBar) view
				.findViewById(R.id.upgrade_progress);
		DownloadProgressText = (TextView) view
				.findViewById(R.id.upgrade_progress_text);

		builder.setView(view);
		builder.setNegativeButton("取消", new OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
				Downloading = false;
			}
		});
		builder.setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface dialog) {
				dialog.dismiss();
				Downloading = false;
			}
		});
		DownloadDialog = builder.create();
		DownloadDialog.setCanceledOnTouchOutside(false);
		DownloadDialog.show();

		downloadApk();
	}

	private static void downloadApk() {
		AsyncTaskWrapper<Integer> task = new AsyncTaskWrapper<Integer>() {
			@Override
			protected Integer doInBackground(Void... params) {
				try {
					if (false == Environment.getExternalStorageState().equals(
							Environment.MEDIA_MOUNTED)) {
						return NOSDCARD;
					}

					String upgradePath = Environment
							.getExternalStorageDirectory().getAbsolutePath()
							+ "/Download/";
					String packageName = AppContextBase.getCurrentBase()
							.getPackageName();
					String apkName = String.format("%s_%s.apk", packageName,
							NewVersion.VersionName);
					String tmpName = String.format("%s_%s.apk.tmp",
							packageName, NewVersion.VersionName);

					UpgradePackageFile = upgradePath + apkName;
					String tmpApkFile = upgradePath + tmpName;

					File path = new File(upgradePath);
					if (!path.exists()) {
						path.mkdirs();
					}

					File apkFile = new File(UpgradePackageFile);

					// 是否已下载更新文件
					if (apkFile.exists()) {
						DownloadDialog.dismiss();
						return DOWNLOAD_COMPLETED;
					}
					Downloading = true;

					File tmpFile = new File(tmpApkFile);
					FileOutputStream tmpFileStream = new FileOutputStream(
							new File(tmpApkFile));

					URL url = new URL(NewVersion.DownloadUrl);
					HttpURLConnection conn = (HttpURLConnection) url
							.openConnection();
					conn.connect();
					int length = conn.getContentLength();
					InputStream responseStream = conn.getInputStream();

					DecimalFormat df = new DecimalFormat("0.00");
					UpgradePackageFileSize = df
							.format((float) length / 1024 / 1024) + "MB";

					int count = 0;
					byte buf[] = new byte[1024];

					int downloadResult = DOWNLOAD_CANCEL;
					do {
						int numread = responseStream.read(buf);
						count += numread;
						DownloadedFileSize = df
								.format((float) count / 1024 / 1024) + "MB";
						int progress = (int) (((float) count / length) * 100);

						this.publishProgress(progress);

						if (numread <= 0) {
							if (tmpFile.renameTo(apkFile)) {
								downloadResult = DOWNLOAD_COMPLETED;
								break;
							}

							downloadResult = DOWNLOAD_ERROR;
							break;
						}
						tmpFileStream.write(buf, 0, numread);
					} while (Downloading);// 点击取消就停止下载

					tmpFileStream.close();
					responseStream.close();
					return downloadResult;
				} catch (Exception e) {
					onPostError(e);
					return DOWNLOAD_ERROR;
				} finally {
					DownloadDialog.dismiss();
					clear();
				}
			}

			@Override
			protected void onPostExecute(Integer status) {
				switch (status) {
				case DOWNLOAD_COMPLETED:
					installApk();
					break;
				case DOWNLOAD_ERROR:
					ToastUtil.showError("无法下载安装文件，请稍后重试");
					break;
				case NOSDCARD:
					ToastUtil.showError("无法下载安装文件，请检查SD卡是否挂载");
					break;
				}

				clear();
			}

			@Override
			protected void onProgressUpdate(int progress) {
				if (null == DownloadDialog)
					return;
				DownloadProgressBar.setProgress(progress);
				DownloadProgressText.setText(DownloadedFileSize + "/"
						+ UpgradePackageFileSize);
			}

			@Override
			protected void onPostError(Exception ex) {
				ToastUtil.showError("无法下载安装文件，请稍后重试");
				clear();
			}
		};
		task.execute();
	}

	private static void installApk() {
		File apkfile = new File(UpgradePackageFile);
		if (!apkfile.exists()) {
			return;
		}

		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.setDataAndType(Uri.fromFile(apkfile),
				"application/vnd.android.package-archive");
		ActivityManager.getCurrent().startActivity(intent);
		AppContextBase.getCurrentBase().exit();
	}
}
