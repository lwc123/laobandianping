package net.juxian.appgenome.exception;

import java.lang.Thread.UncaughtExceptionHandler;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.widget.ToastUtil;
import android.os.Looper;


public class CrashHandler implements UncaughtExceptionHandler {
    private static CrashHandler Instance = new CrashHandler();  

    private Thread.UncaughtExceptionHandler defaultHandler;
    
    private CrashHandler() {  
    }   

    public static CrashHandler getInstance() {  
        return Instance;  
    }    

    public void initialize() {  
        defaultHandler = Thread.getDefaultUncaughtExceptionHandler();  
        Thread.setDefaultUncaughtExceptionHandler(this);  
    }  
  
    /** 
     * ��UncaughtException����ʱ��ת��ú��������� 
     */  
    @Override  
    public void uncaughtException(Thread thread, Throwable ex) {  
    	if (!handleException(ex) && defaultHandler != null) {
        	defaultHandler.uncaughtException(thread, ex);
        }
    	else {
    		android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(1);
    	}

    }  
  
    /** 
     * �Զ��������,�ռ�������Ϣ ���ʹ��󱨸�Ȳ������ڴ����. 
     *  
     * @param ex 
     * @return true:��������˸��쳣��Ϣ;���򷵻�false. 
     */  
    private boolean handleException(Throwable ex) {  
        if (ex == null) {  
            return false;  
        }  
        
        LogManager.getLogger().wtf(ex, "app exit at %s", 123);
        //ʹ��Toast����ʾ�쳣��Ϣ  
        new Thread() {  
            @Override  
            public void run() {  
                Looper.prepare();  
                ToastUtil.showError("�ܱ�Ǹ,��������쳣,�����˳�.");                
                Looper.loop();  
            }  
        }.start();  
//        //�ռ��豸������Ϣ   
//        collectDeviceInfo(mContext);  
//        //������־�ļ�   
//        saveCrashInfo2File(ex);  
        return true;  
    }  
      
}
