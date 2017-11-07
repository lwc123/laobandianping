package net.juxian.appgenome;

import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.TextUtil;

public class AppEnvironment {
	private static final String RUNTIME_MODE_KEY = "environment:runtime_mode";
	private static final String MODE_DEBUG = "debug";
	private static final String MODE_PUBLIC = "public";
	
	public static String Mode;
	
	public static boolean isPublicMode() {
		if(null == Mode) {
			Mode = AppConfigUtil.getMetaData(RUNTIME_MODE_KEY);
			if(TextUtil.isNullOrEmpty(Mode)) {
				Mode = BuildConfig.DEBUG ? MODE_DEBUG : MODE_PUBLIC;
			}
		}
		
		return Mode.equals(MODE_PUBLIC);
	}
}
