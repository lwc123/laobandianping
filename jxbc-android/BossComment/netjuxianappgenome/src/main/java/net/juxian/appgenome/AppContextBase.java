package net.juxian.appgenome;

import android.app.Application;
import android.support.multidex.MultiDex;

import net.juxian.appgenome.exception.CrashHandler;
import net.juxian.appgenome.utils.AppConfigUtil;

import java.util.ArrayList;

public abstract class AppContextBase extends Application {
    public static final String TAG_ACTION = LogManager.Default_Tag + ":Action";

    protected static AppContextBase Instance = null;

    public static AppContextBase getCurrentBase() {
        return Instance;
    }

    private ArrayList<IAppModule> appModules;

    protected final void register(IAppModule module) {
        appModules.add(module);
    }

    private String deviceKey = null;
    private IAuthentication authentication = null;

    @Override
    public final void onCreate() {
        super.onCreate();
        Instance = this;
        appModules = new ArrayList<IAppModule>();
        MultiDex.install(this);
        LogManager.getLogger(TAG_ACTION).d(">>> created app ");

        CrashHandler.getInstance().initialize();

        this.initialize();
        this.start();
    }

    protected void initialize() {
        this.register(new CommonModule());
        LogManager.getLogger(TAG_ACTION).d(">>> initialized app ");
    }

    @Override
    public void onTerminate() {
        try {
            super.onTerminate();
            this.exit();
        } catch (Exception e) {
        }
    }

    private final void start() {
        for (IAppModule module : appModules) {
            if (false == module.asyncStart()) {
                module.onStart(Instance);
            }
        }

        Runnable startTask = new Runnable() {
            @Override
            public void run() {
                for (IAppModule module : appModules) {
                    if (true == module.asyncStart()) {
                        module.onStart(Instance);
                    }
                }
            }
        };

        TaskThreadPool.getInstance().addTask(startTask);

        LogManager.getLogger(TAG_ACTION).d(">>> started app ");
    }

    public final void exit() {
        for (IAppModule module : appModules) {
            module.onEnd(Instance);
        }
        ActivityManager.finishAll();

        LogManager.getLogger(TAG_ACTION).d(">>> exit app ");
        System.exit(0);
    }

    public final void authenticatedStateChanged() {
        for (IAppModule module : appModules) {
            module.onAuthenticatedStateChanged(Instance);
        }
    }

    public final String getDeviceKey() {
        if (null == deviceKey)
            deviceKey = AppConfigUtil.getDeviceKey();
        return deviceKey;
    }

    public final IAuthentication getAuthentication() {
        if (null == authentication)
            authentication = ObjectIOCFactory
                    .getSingleton(IAuthentication.class);
        return authentication;
    }
}
