package net.juxian.appgenome.utils;

import android.content.Context;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.util.Log;

import net.juxian.appgenome.AppContextBase;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import static android.os.Environment.MEDIA_MOUNTED;

/**
 * Created by nene on 2016/10/31.
 *
 * @ProjectName: [BossComment]
 * @Package: [net.juxian.appgenome.utils]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/31 13:44]
 * @Version: [v1.0]
 */
public class ImageUtils {

    private File cropCacheFolder;
    private static final String EXTERNAL_STORAGE_PERMISSION = "android.permission.WRITE_EXTERNAL_STORAGE";
    public static List<String> saveFilePaths = new ArrayList<String>();
    public static List<String> photoPaths = new ArrayList<String>();

    // 根据路径获得图片并压缩，返回bitmap用于显示
    public static Bitmap getSmallBitmap(Context context,String filePath) {
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(filePath, options);
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        options.inSampleSize = calculateInSampleSize(options, displayMetrics.widthPixels, displayMetrics.heightPixels);
        options.inJustDecodeBounds = false;
        // Calculate inSampleSize
        options.inSampleSize = calculateInSampleSize(options, 320, 480);
//
//        // Decode bitmap with inSampleSize set
        options.inJustDecodeBounds = false;
//        Bitmap bitmap = BitmapFactory.decodeFile(filePath, options);
        return BitmapFactory.decodeFile(filePath, options);
//        return compressImage1(bitmap);
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

    //计算图片的缩放值
//    public static int calculateInSampleSize(BitmapFactory.Options options,int reqWidth, int reqHeight) {
//        final int height = options.outHeight;
//        final int width = options.outWidth;
//        int inSampleSize = 1;
//
//        if (height > reqHeight || width > reqWidth) {
//            final int heightRatio = Math.round((float) height/ (float) reqHeight);
//            final int widthRatio = Math.round((float) width / (float) reqWidth);
//            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
//        }
//        return inSampleSize;
//    }

    public File getCropCacheFolder(Context context) {
        if (cropCacheFolder == null) {
//            cropCacheFolder = new File(Environment.getExternalStorageDirectory().getAbsolutePath()+ "/fuxiaolong/cropTemp/");
            cropCacheFolder = new File(Environment.getExternalStorageDirectory().getAbsolutePath());
        }
        return cropCacheFolder;
    }

    public static File getFileCacheDirectory(Context context, String cacheDir) {
        File appCacheDir = null;
        if (MEDIA_MOUNTED.equals(Environment.getExternalStorageState()) && hasExternalStoragePermission(context)) {
            appCacheDir = new File(Environment.getExternalStorageDirectory(), cacheDir);
        }
        if (appCacheDir == null || (!appCacheDir.exists() && !appCacheDir.mkdirs())) {
            appCacheDir = context.getCacheDir();
        }
        return appCacheDir;
    }

    public static void writeToFile(Context context,Bitmap bitmap,String filePath,String fileName){
        File file=getFileCacheDirectory(context,filePath);
        if (!file.exists() || file.isDirectory())
            file.mkdirs();
        File saveFile = new File(file,fileName+".jpg");
        saveFilePaths.add(saveFile.toString());
        Log.e("JuXian",saveFile.toString());
        int options = 80;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        while (baos.toByteArray().length / 1024 > 200) {
            baos.reset();
//            if (options>10) {
//                options -= 10;
//            }
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, baos);
            if (options>10) {
                options -= 10;
            }
//            if (options == 10) {
//                options = 10;
//                break;
//            } else {
//                options -= 10;// 每次都减少10
//            }
        }
        try {
            //使用流的方式去输出文件的话，会对文件进行一定的压缩。
            FileOutputStream fos = new FileOutputStream(saveFile);
            fos.write(baos.toByteArray());
            fos.flush();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
//        OutputStream outputStream = null;
//        try {
//            outputStream = AppContextBase.getCurrentBase().getContentResolver().openOutputStream(Uri.fromFile(saveFile));
//            if(bitmap.compress(Bitmap.CompressFormat.PNG, 50, outputStream)){
//                outputStream.flush();
//                outputStream.close();
//            }
//        } catch (FileNotFoundException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        } catch (IOException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
    }

    private static boolean hasExternalStoragePermission(Context context) {
        int perm = context.checkCallingOrSelfPermission(EXTERNAL_STORAGE_PERMISSION);
        return perm == PackageManager.PERMISSION_GRANTED;
    }

    /**
     * 用于高效加载本地图片  decodeFile也是同理
     * @param res
     * @param resId
     * @param reqWidth
     * @param reqHeight
     * @return
     * ImageView.setImageBitmap(decodeSampleBitmapFromResource(getResources(),R.id.myimage,100,100))
     */
    public static Bitmap decodeSampleBitmapFromResource(Resources res, int resId, int reqWidth, int reqHeight){
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        // 取出原始图片的宽高
        BitmapFactory.decodeResource(res,resId,options);

        options.inSampleSize = calculateInSampleSize1(options,reqWidth,reqHeight);
        options.inJustDecodeBounds = false;
        return BitmapFactory.decodeResource(res,resId,options);
    }

    public static int calculateInSampleSize1(BitmapFactory.Options options,
                                             int reqWidth, int reqHeight) {
        final int sourceWidth = options.outWidth;
        final int sourceHeight = options.outHeight;

        int inSampleSize = 1;

        if (sourceHeight > reqWidth || sourceWidth > reqHeight) {
            final int halfHeight = sourceHeight/2;
            final int halfWidth = sourceWidth/2;

            while ((halfHeight/inSampleSize)>=reqHeight && (halfWidth/inSampleSize) >= reqWidth){
                inSampleSize *= 2;
            }
        }
        return inSampleSize;
    }

    /**
     * 图片按比例压缩
     * @param srcPath
     * @return
     */
    private Bitmap getimage(String srcPath) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(srcPath,newOpts);//此时返回bm为空

        newOpts.inJustDecodeBounds = false;
        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        //现在主流手机比较多是800*480分辨率，所以高和宽我们设置为
        float hh = 1280f;//这里设置高度为800f
        float ww = 720f;//这里设置宽度为480f
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        int be = 1;//be=1表示不缩放
        if (w > h && w > ww) {//如果宽度大的话根据宽度固定大小缩放
            be = (int) (newOpts.outWidth / ww);
        } else if (w < h && h > hh) {//如果高度高的话根据宽度固定大小缩放
            be = (int) (newOpts.outHeight / hh);
        }
        if (be <= 0)
            be = 1;
        newOpts.inSampleSize = be;//设置缩放比例
        //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
        bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
        return bitmap;//压缩好比例大小后再进行质量压缩
//        return compressImage(bitmap);//压缩好比例大小后再进行质量压缩
    }

    /**
     * 质量压缩法
     * @param image
     * @return
     */
    public static Bitmap compressImage(Bitmap image) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.PNG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while ( baos.toByteArray().length / 1024>100) {    //循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            options -= 10;//每次都减少10
            image.compress(Bitmap.CompressFormat.PNG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return bitmap;
    }

    /**
     * 质量压缩法
     * @param image
     * @return
     */
    public static Bitmap compressImage1(Bitmap image) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.PNG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while ( baos.toByteArray().length / 1024>1000) {    //循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            options -= 10;//每次都减少10
            image.compress(Bitmap.CompressFormat.PNG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中

        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return bitmap;
    }

    /**
     * 图片按比例大小压缩方法（根据Bitmap图片压缩）：
     * @param image
     * @return
     */
    private Bitmap comp(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        if( baos.toByteArray().length / 1024>1024) {//判断如果图片大于1M,进行压缩避免在生成图片（BitmapFactory.decodeStream）时溢出
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, 50, baos);//这里压缩50%，把压缩后的数据存放到baos中
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);
        newOpts.inJustDecodeBounds = false;
        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        //现在主流手机比较多是800*480分辨率，所以高和宽我们设置为
        float hh = 800f;//这里设置高度为800f
        float ww = 480f;//这里设置宽度为480f
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        int be = 1;//be=1表示不缩放
        if (w > h && w > ww) {//如果宽度大的话根据宽度固定大小缩放
            be = (int) (newOpts.outWidth / ww);
        } else if (w < h && h > hh) {//如果高度高的话根据宽度固定大小缩放
            be = (int) (newOpts.outHeight / hh);
        }
        if (be <= 0)
            be = 1;
        newOpts.inSampleSize = be;//设置缩放比例
        newOpts.inPreferredConfig = Bitmap.Config.RGB_565;//降低图片从ARGB888到RGB565
        //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
        isBm = new ByteArrayInputStream(baos.toByteArray());
        bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);
        return compressImage(bitmap);//压缩好比例大小后再进行质量压缩
    }
}
