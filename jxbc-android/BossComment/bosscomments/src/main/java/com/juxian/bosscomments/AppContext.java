package com.juxian.bosscomments;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.juxian.bosscomments.models.AccountEntity;
import com.juxian.bosscomments.modules.AsyncAppModule;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.repositories.JuXianApiClient;
import com.juxian.bosscomments.repositories.PackageRepository;
import com.juxian.bosscomments.ui.AuditWebViewActivity;
import com.juxian.bosscomments.ui.HomeActivity;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiskCache;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.WeakMemoryCache;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.utils.StorageUtils;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.PushAgent;
import com.umeng.message.UmengNotificationClickHandler;
import com.umeng.message.entity.UMessage;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.IAuthentication;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.ObjectIOCFactory;
import net.juxian.appgenome.upgrade.IPackageRepository;
import net.juxian.appgenome.webapi.WebApiClient;

import org.xutils.x;

import java.io.File;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class AppContext extends AppContextBase {
    private PushAgent mPushAgent;

    public static AppContext getCurrent() {
        return (AppContext) Instance;
    }

    @Override
    protected void initialize() {
        super.initialize();
        // 异步AppModule，在这个里面会去初始化token，调用token登录，并且在AppContextBase中进行异步AppModule的开启
        this.register(new AsyncAppModule());
        // 在使用 SDK 各组间之前初始化 context 信息，传入 ApplicationContext
//		SDKInitializer.initialize(this);
        initImageLoader(getApplicationContext());
        x.Ext.init(this);
        x.Ext.setDebug(BuildConfig.DEBUG);
        // init demo helper
//		DemoHelper.getInstance().init(this);
        // 环信结束

        ActivityManager.registerHomeActivity(HomeActivity.class);
        ObjectIOCFactory.registerTypeAlias(WebApiClient.class,
                JuXianApiClient.class);
        ObjectIOCFactory.registerTypeAlias(IAuthentication.class,
                UserAuthentication.class);
        ObjectIOCFactory.registerTypeAlias(IPackageRepository.class,
                PackageRepository.class);

        LogManager.getLogger(TAG_ACTION).d(">>> initialized application ");
//        initUMRegister();
//        initUmengNotificationClickHandler();
    }

    private void initUmengNotificationClickHandler() {
        UmengNotificationClickHandler notificationClickHandler = new UmengNotificationClickHandler() {
            @Override
            public void dealWithCustomAction(Context context, UMessage msg) {
                Toast.makeText(context, msg.custom, Toast.LENGTH_LONG).show();
            }

            @Override
            public void launchApp(Context context, UMessage msg) {
                super.launchApp(context, msg);
                if (msg != null) {
                    Intent intent = new Intent(ActivityManager.getCurrent(), AuditWebViewActivity.class);
                    Map<String, String> CustomExtra = msg.extra;
                    Set<String> keySet = CustomExtra.keySet();
                    Iterator<String> iterator = keySet.iterator();
                    long bizId = 0;
                    long CompanyId = 0;
                    long bizType = 0;
                    while (iterator.hasNext()) {
                        switch (iterator.next()) {
                            case "BizId":
                                String bizIdOld = CustomExtra.get("BizId");
                                bizId = Long.parseLong(bizIdOld);
                                break;
                            case "bizType":
                                String bizTypeOld = CustomExtra.get("bizType");
                                bizType = Long.parseLong(bizTypeOld);
                                break;
                            case "CompanyId":
                                String CompanyIdld = CustomExtra.get("CompanyId");
                                CompanyId = Long.parseLong(CompanyIdld);
                                break;
                            default:
                                break;

                        }
                    }
                    intent.putExtra("Operation", "ClickNotification");
                    intent.putExtra("BizId", bizId);
                    if (bizType == 0) {//普通消息，不可点击
                        Intent intent1 = new Intent(ActivityManager.getCurrent(), HomeActivity.class);
                        startActivity(intent1);
                    } else if (bizType == 2) {// 离任报告
                        intent.putExtra("CommentType", "leaving_report");
                    } else if (bizType == 3) {//阶段评价
                        intent.putExtra("CommentType", "audit");
                    }
                    intent.putExtra("bizType", bizType);
                    intent.putExtra("CompanyId", CompanyId);
                    ActivityManager.getCurrent().startActivity(intent);
                }
            }

            @Override
            public void openActivity(Context context, UMessage uMessage) {
            }
        };
        mPushAgent.setNotificationClickHandler(notificationClickHandler);
    }

    private void initUMRegister() {
        mPushAgent = PushAgent.getInstance(this);
        //注册推送服务，每次调用register方法都会回调该接口
        mPushAgent.register(new IUmengRegisterCallback() {

            @Override
            public void onSuccess(String deviceToken) {
                //注册成功会返回device token
                Log.e("qq", "deviceToken-->" + deviceToken);


            }

            @Override
            public void onFailure(String s, String s1) {
                Log.e("qq", "deviceToken-->失败");
            }
        });
    }

    private UserAuthentication authentication = null;

    public final UserAuthentication getUserAuthentication() {
        if (null == authentication)
            authentication = (UserAuthentication) getAuthentication();
        return authentication;
    }

    public final Boolean isAuthenticated() {
        return this.getAuthentication().isAuthenticated();
    }

    public AccountEntity getCurrentAccount() {
        return this.getUserAuthentication().getCurrentAccount();
    }

    public static void initImageLoader(Context context) {
        // This configuration tuning is custom. You can tune every option, you
        // may tune some of them,
        // or you can create default configuration by
        // ImageLoaderConfiguration.createDefault(this);
        // method.
        File cacheDir = StorageUtils.getOwnCacheDirectory(context,
                "com.juxian.bosscomments/Cache");
        @SuppressWarnings("deprecation")
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(
                context).threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .discCache(new UnlimitedDiskCache(cacheDir))
                .diskCacheFileNameGenerator(new Md5FileNameGenerator())
                .diskCacheSize(20 * 1024 * 1024)
                // 50 Mb
                .threadPoolSize(4)
                .memoryCache(new WeakMemoryCache())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .writeDebugLogs() // Remove for release app
                .build();
        // Initialize ImageLoader with configuration.
        ImageLoader.getInstance().init(config);
    }
}
