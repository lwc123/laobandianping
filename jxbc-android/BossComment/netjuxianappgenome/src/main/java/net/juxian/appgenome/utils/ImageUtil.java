package net.juxian.appgenome.utils;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.media.ExifInterface;
import android.util.Base64;

import net.juxian.appgenome.LogManager;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ImageUtil {
	public static final int ROTATION_0 = 0;
	public static final int ROTATION_90 = 90;
	public static final int ROTATION_180 = 180;
	public static final int ROTATION_270 = 270;

	// public static final int UPLOAD_WIDTH_MAX = 540;
	// public static final int UPLOAD_HEIGHT_MAX = 960;
	public static final int UPLOAD_WIDTH_MAX = 1080;
	public static final int UPLOAD_HEIGHT_MAX = 1920;
	// public static final int UPLOAD_JPEG_QUALITY = 73;
	public static final int UPLOAD_JPEG_QUALITY = 100;

	public static Point getSize(String imgFile) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inPurgeable = true;
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(imgFile, options);
		return new Point(options.outWidth, options.outHeight);
	}

	public static int getFileExifRotation(String imgFile) {
		try {
			ExifInterface exifInterface = new ExifInterface(imgFile);
			int orientation = exifInterface.getAttributeInt(
					ExifInterface.TAG_ORIENTATION,
					ExifInterface.ORIENTATION_NORMAL);
			switch (orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				return ROTATION_90;
			case ExifInterface.ORIENTATION_ROTATE_180:
				return ROTATION_180;
			case ExifInterface.ORIENTATION_ROTATE_270:
				return ROTATION_270;
			default:
				return ROTATION_0;
			}
		} catch (IOException e) {
			return ROTATION_0;
		}
	}

	public static boolean resizeFile(String imgFile, int maxWidth, int maxHeight) {
		Bitmap bitmap = ImageUtil
				.decodeScaledFile(imgFile, maxWidth, maxHeight);
		try {
			FileOutputStream out = new FileOutputStream(imgFile);
			boolean result = bitmap.compress(Bitmap.CompressFormat.JPEG, 100,
					out);
			out.flush();
			out.close();
			return result;
		} catch (FileNotFoundException ex) {
			LogManager.getLogger("").e(ex, "resizeFile(%s,%s,%s)", imgFile,
					maxWidth, maxHeight);
			return false;
		} catch (IOException ioException) {
			LogManager.getLogger("").e(ioException, "resizeFile(%s,%s,%s)",
					imgFile, maxWidth, maxHeight);
			return false;
		} finally {
			bitmap.recycle();
		}
	}

	public static Bitmap decodeFile(String imgFile, int maxWidth, int maxHeight) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inPreferredConfig = Config.ARGB_8888;
		options.inPurgeable = true;
		options.inJustDecodeBounds = true;
		Bitmap bitmap = BitmapFactory.decodeFile(imgFile, options);
		options.inSampleSize = calculateInSampleSize(options, maxWidth,
				maxHeight);
		options.inJustDecodeBounds = false;
		options.inPurgeable = true;
		options.inInputShareable = true;
		bitmap = BitmapFactory.decodeFile(imgFile, options);
		return bitmap;
	}

	public static Bitmap decodeScaledFile(String imgFile, int maxWidth,
			int maxHeight) {
		Bitmap bitmap = decodeFile(imgFile, maxWidth, maxHeight);
		bitmap = decodeScaledBitmap(bitmap, maxWidth, maxHeight);
		return bitmap;
	}

	public static Bitmap decodeScaledBitmap(Bitmap bitmap, int maxWidth,
			int maxHeight) {
		Point size = calcResize(bitmap.getWidth(), bitmap.getHeight(),
				maxWidth, maxHeight);
		if (size.x > 0 && size.y > 0) {
			Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, size.x,
					size.y, true);
			if (scaledBitmap != bitmap) {
				bitmap.recycle();
				bitmap = scaledBitmap;
			}
		}
		return bitmap;
	}

	public static Bitmap decodeByteArray(byte[] imgData, int maxWidth,
			int maxHeight) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inPreferredConfig = Config.ARGB_8888;
		options.inPurgeable = true;
		options.inJustDecodeBounds = true;
		Bitmap bitmap = BitmapFactory.decodeByteArray(imgData, 0,
				imgData.length, options);
		options.inSampleSize = calculateInSampleSize(options, maxWidth,
				maxHeight);
		options.inJustDecodeBounds = false;
		options.inPurgeable = true;
		options.inInputShareable = true;
		bitmap = BitmapFactory.decodeByteArray(imgData, 0, imgData.length,
				options);
		return bitmap;
	}

	public static Bitmap decodeScaledByteArray(byte[] imgData, int maxWidth,
			int maxHeight) {
		Bitmap bitmap = decodeByteArray(imgData, maxWidth, maxHeight);
		bitmap = decodeScaledBitmap(bitmap, maxWidth, maxHeight);
		return bitmap;
	}

	private static int calculateInSampleSize(BitmapFactory.Options options,
			int maxWidth, int maxHeight) {
		int sourceWidth = options.outWidth;
		int sourceHeight = options.outHeight;

		int inSampleSize = 1;

		if (sourceHeight > maxHeight || sourceWidth > maxWidth) {
			int widthSampleSize = 1;
			int heightSampleSize = 1;

			if (sourceWidth > maxWidth && maxWidth > 0) {
				widthSampleSize = (int) Math.floor((double) sourceWidth
						/ (double) maxWidth);
			}

			if (sourceHeight > maxHeight && maxHeight > 0) {
				heightSampleSize = (int) Math.floor((double) sourceHeight
						/ (double) maxHeight);
			}
			inSampleSize = Math.max(widthSampleSize, heightSampleSize);
		}
		if (inSampleSize <= 0)
			inSampleSize = 1;
		return inSampleSize;
	}

	private static Point calcResize(int sourceWidth, int sourceHeight,
			int maxWidth, int maxHeight) {
		float widthScale = (float) maxWidth / (float) sourceWidth;
		float heightScale = (float) maxHeight / (float) sourceHeight;

		float scale = Math.max(widthScale, heightScale);

		int targetWidth = (int) (scale * sourceWidth);
		int targetHeight = (int) (scale * sourceHeight);

		return new Point(targetWidth, targetHeight);
	}

	public static String toUploadBase64(String imgFile) {
		Point size = getSize(imgFile);
		int targetWidth = UPLOAD_WIDTH_MAX;
		int targetHeight = UPLOAD_HEIGHT_MAX;
		if (size.x > size.y && targetWidth < targetHeight) {
			targetWidth = UPLOAD_HEIGHT_MAX;
			targetHeight = UPLOAD_WIDTH_MAX;
		}
		Bitmap bitmap = decodeScaledFile(imgFile, targetWidth, targetHeight);
//		Bitmap bitmap=BitmapFactory.decodeFile(imgFile);
		return toBase64(bitmap);
	}

	public static String toBase64(Bitmap bitmap) {
		String result = null;
		ByteArrayOutputStream output = null;
		try {
			if (bitmap != null) {
				output = new ByteArrayOutputStream();
				bitmap.compress(Bitmap.CompressFormat.JPEG,
						UPLOAD_JPEG_QUALITY, output);
				bitmap.recycle();
				output.flush();
				output.close();
				byte[] data = output.toByteArray();
				result = Base64.encodeToString(data, Base64.DEFAULT);
			}
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		} finally {
			try {
				if (output != null) {
					output.flush();
					output.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public static Bitmap formBase64(String data) {
		byte[] bytes = Base64.decode(data, Base64.DEFAULT);
		return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
	}
}
