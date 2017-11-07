package net.juxian.appgenome.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import net.juxian.appgenome.AppContextBase;
import android.os.Environment;
import android.util.Base64;

public class FileUtil {
	private static final String DataDirectory = "/juxian/data";
	private static final String CacheDirectory = "/juxian/cache";
	private static final String CameraDirectory = "/DCIM/Camera";

	public static boolean hasSDCard() {
		String status = Environment.getExternalStorageState();
		if (!status.equals(Environment.MEDIA_MOUNTED)) {
			return false;
		}
		return true;
	}

	public static String getDataPath() {
		String path = null;
		if (hasSDCard()) {
			path = AppContextBase.getCurrentBase()
					.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)
					.getAbsolutePath();
		} else {
			path = AppContextBase.getCurrentBase().getFilesDir() + DataDirectory;
			mkdirs(path);
		}
		return path;
	}

	public static String getDataPath(String sunDirectoryName) {
		String path = getDataPath();
		if (null != path)
			path += "/" + sunDirectoryName;
		mkdirs(path);

		return path;
	}

	public static String getCachePath() {
		String path = null;
		if (hasSDCard()) {
			path = AppContextBase.getCurrentBase().getExternalCacheDir().getAbsolutePath();
		} else {
			path = AppContextBase.getCurrentBase().getFilesDir() + CacheDirectory;
			mkdirs(path);
		}
		return path;
	}

	public static String getCachePath(String sunDirectoryName) {
		String path = getCachePath();
		if (null != path)
			path += "/" + sunDirectoryName;
		mkdirs(path);

		return path;
	}

	public static String getImageCachePath() {
		return getCachePath("image");
	}

	public static String getCameraPath() {
		String path = null;
		if (hasSDCard()) {
			path = Environment.getExternalStorageDirectory() + CameraDirectory;
		}
		return path;
	}

	private static void mkdirs(String path) {
		File dir = new File(path);
		if (false == dir.exists())
			dir.mkdirs();
	}

	/**
	 * encodeBase64File:(将文件转成base64 字符串). <br/>
	 * @param path 文件路径
	 * @return
	 */
	public static String encodeBase64File(String path) throws Exception {
		File  file = new File(path);
		FileInputStream inputFile = new FileInputStream(file);
		byte[] buffer = new byte[(int)file.length()];
		inputFile.read(buffer);
		inputFile.close();
		return Base64.encodeToString(buffer, Base64.DEFAULT);
	}

	/**
	 * decoderBase64File:(将base64字符解码保存文件). <br/>
	 * @param base64Code 编码后的字串
	 * @param savePath  文件保存路径
	 */
	public static void decoderBase64File(String base64Code,String savePath) throws Exception {
		//byte[] buffer = new BASE64Decoder().decodeBuffer(base64Code);
		byte[] buffer =Base64.decode(base64Code, Base64.DEFAULT);
		FileOutputStream out = new FileOutputStream(savePath);
		out.write(buffer);
		out.close();
	}
}
