package net.juxian.appgenome.widget;

import com.android.volley.Cache.Entry;
import com.android.volley.RequestQueue;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.webapi.NetworkQueue;
import android.graphics.Bitmap;
import android.support.v4.util.LruCache;

public class ImageLoader extends com.android.volley.toolbox.ImageLoader {	
	private static class SingletonHolder {
		private static final ImageLoader Instance = new ImageLoader(NetworkQueue.newQueue(), new BitmapCache());
	}
	
	public static ImageLoader getSingleton() {
		return SingletonHolder.Instance;
	}
	
	private ImageCache cache = null;
	private RequestQueue requestQueue = null;
	
	private ImageLoader(RequestQueue requestQueue, ImageCache imageCache) {		
		super(requestQueue,imageCache);	
		this.cache = imageCache;
		this.requestQueue = requestQueue;		
	}
	
	public Bitmap getCachedBitmap(String url, int maxWidth, int maxHeight) {
		Bitmap data = cache.getBitmap(getCacheKey(url,maxWidth,maxHeight));
		if(null == data) {
			Entry entry = this.requestQueue.getCache().get(url);
			if(null != entry) {
				data = ImageUtil.decodeScaledByteArray(entry.data, maxWidth, maxHeight);
			}
		}
		return data;
	}
	
	private static String getCacheKey(String url, int maxWidth, int maxHeight) {
		return new StringBuilder(url.length() + 12).append("#W").append(maxWidth)
		    .append("#H").append(maxHeight).append(url).toString();
	}
	
	private static class BitmapCache implements ImageCache { 
		private static final int FRACTION_MAX_MEMORY_SIZE = 6;
		
	    private LruCache<String, Bitmap> cache;  
	    public BitmapCache() {  
	    	int maxMemorySize = (int)Runtime.getRuntime().maxMemory();	    	
	        int maxCacheSize = maxMemorySize / FRACTION_MAX_MEMORY_SIZE;  
	        cache = new LruCache<String, Bitmap>(maxCacheSize) {  
	            @Override  
	            protected int sizeOf(String key, Bitmap bitmap) {  
	                return bitmap.getRowBytes() * bitmap.getHeight();  
	            }  
	        };  

	        LogManager.getLogger().i("MaxMemory:%s, ImageCache:%s"
	        		, maxMemorySize*1.0/1024.0/1024.0, maxCacheSize*1.0/1024.0/1024.0);
	    }  
	  
	    @Override  
	    public Bitmap getBitmap(String url) {  
	        return cache.get(url);  
	    }  
	  
	    @Override  
	    public void putBitmap(String url, Bitmap bitmap) {  
	        cache.put(url, bitmap);  
	    }
	} 
}
