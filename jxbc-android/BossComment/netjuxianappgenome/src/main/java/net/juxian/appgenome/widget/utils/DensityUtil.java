package net.juxian.appgenome.widget.utils;

import net.juxian.appgenome.AppContextBase;
import android.content.Context;  

public class DensityUtil {  
    public static int dip2px(float dpValue) {
        float scale = AppContextBase.getCurrentBase().getResources().getDisplayMetrics().density;  
        return (int) (dpValue * scale + 0.5f);  
    }  

    public static int px2dip(Context context, float pxValue) {  
        float scale = AppContextBase.getCurrentBase().getResources().getDisplayMetrics().density;  
        return (int) (pxValue / scale + 0.5f);  
    }  
    
    public static int sp2px(float spValue) {
    	float scale = AppContextBase.getCurrentBase().getResources().getDisplayMetrics().scaledDensity;
    	return (int) (spValue * scale + 0.5f); 
    }
    
    public static int px2sp(float pxValue) {
    	float scale = AppContextBase.getCurrentBase().getResources().getDisplayMetrics().scaledDensity;
    	return (int) (pxValue / scale + 0.5f);
    }
}
