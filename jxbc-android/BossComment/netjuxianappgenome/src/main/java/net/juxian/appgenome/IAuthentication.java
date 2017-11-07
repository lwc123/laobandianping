package net.juxian.appgenome;

import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.socialize.ThirdPassport;

public interface IAuthentication {
	boolean isAuthenticated();

	String getAccessToken();

	String getAccountKey();

	boolean bindThirdPassport(ThirdPassport thirdPassport);

	boolean signInByToken();

	SignResult signIn(String loginName, String password);

	SignResult shortcutSignIn(String loginName, String validationCode);

	SignResult signUp(String mobilePhone, String password, String validationCode, int SelectedProfileType);
	
	SignResult resetPwd(String mobilePhone,String password,String identifyingCode);

	boolean signOut();
}
