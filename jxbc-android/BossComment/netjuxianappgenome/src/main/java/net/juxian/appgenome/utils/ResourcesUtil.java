package net.juxian.appgenome.utils;

import net.juxian.appgenome.AppContextBase;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;

public class ResourcesUtil {
	public static final String  TYPE_ATTR = "attr";
	public static final String  TYPE_COLOR = "color";
	public static final String  TYPE_DIMEN = "dimen";
	public static final String  TYPE_STYLE = "style";	
	public static final String  TYPE_DRAWABLE = "drawable";
	
	public static String getString(int resourceId) {		
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getString(resourceId);
	}
	
	public static int getIdentifier(String resourceKey, String resourceType) {
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getIdentifier(resourceKey, resourceType, AppContextBase.getCurrentBase().getPackageName());
	}
	
	public static int getIdentifier(String resourceKey, String resourceType, String packageName) {
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getIdentifier(resourceKey, resourceType, AppContextBase.getCurrentBase().getPackageName());
	}
	
	public static Drawable getDrawable(int resourceId) {		
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getDrawable(resourceId);
	}
	
	public static int getColor(int resourceId) {		
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getColor(resourceId);
	}	
	
	public static float getDimension(int resourceId) {		
		Resources resources = AppContextBase.getCurrentBase().getResources();
		return resources.getDimension(resourceId);
	}
}
