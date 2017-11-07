package com.juxian.bosscomments.modules;

import android.util.Log;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountEntity;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.repositories.AccountRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.models.AvatarEntity;

import net.juxian.appgenome.IAuthentication;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.socialize.ThirdPassport;
import net.juxian.appgenome.utils.AnalyticsUtil;
import net.juxian.appgenome.utils.JsonUtil;

public class UserAuthentication implements IAuthentication {
    public static final String TAG = LogManager.Default_Tag + ":Authentication";
    private String accessToken = null;
    private AccountEntity currentAccount = null;

    @Override
    public String getAccessToken() {
        if (null == accessToken)
            accessToken = AppConfig.getAccessToken();
        return accessToken;
    }

    public final void setAccessToken(String token) {
        this.accessToken = token;
        // 存在一个共享参数中
        AppConfig.setAccessToken(token);
    }

    /**
     * 在token不为空的时候，获取到相应的用户信息
     */
    public AccountEntity getCurrentAccount() {
        LogManager.getLogger(TAG).i("CurrentAccount: %s", currentAccount);
        if (null == currentAccount && null != getAccessToken()) {
            synchronized (UserAuthentication.class) {
                if (null == currentAccount) {
                    synchronized (UserAuthentication.class) {
                        String json = AppConfig.getAccountData();
                        currentAccount = JsonUtil.ToEntity(json,
                                AccountEntity.class);
                        LogManager.getLogger(TAG).i(json);
                    }
                }
            }
        }
        return currentAccount;
    }

    private void changeAccountState(AccountEntity account) {
        synchronized (UserAuthentication.class) {
            currentAccount = account;
            if (null == currentAccount) {
                this.setAccessToken(null);
                AppConfig.setAccountData(null);
            } else {
                this.setAccessToken(currentAccount.Token.AccessToken);
                AppConfig.setAccountData(JsonUtil.ToJson(currentAccount));
            }
        }
    }

    private long getPassportId() {
        long id = 0;
        AccountEntity account = getCurrentAccount();
        if (null != account)
            id = account.PassportId;
        return id;
    }

    private long getAnonymousAccountId() {
        long id = 0;
        AccountEntity account = getCurrentAccount();
        if (null != account)
            id = account.AccountId;
        return id;
    }

    // 用于判断是否登录，即在使用account的时候，都需要判断一次
    @Override
    public boolean isAuthenticated() {
        boolean isAuthenticated = false;
        AccountEntity account = getCurrentAccount();
        if (null != account)
            // 如果account不为空，但是用户有可能是不登录的，则PassportId会不大于0，返回的是false
            isAuthenticated = account.isAuthenticated();
        return isAuthenticated;
    }

    @Override
    public String getAccountKey() {
        String accountKey = "";
        long passportId = getPassportId();
        long accountId = getAnonymousAccountId();
        if (passportId > 0)
            accountKey = String.format("Passport_%s", passportId);
        else if (accountId > 0)
            accountKey = String.format("Account_%s", accountId);
        return accountKey;
    }

    // 第三方登录
    @Override
    public boolean bindThirdPassport(ThirdPassport thirdPassport) {
        AccountSignResult signResult = AccountRepository
                .bindThirdAccount(thirdPassport);
        // Global.passportId = signResult.Account.PassportId;
        // 前往保存token
        return authenticate(signResult);
    }

    @Override
    public boolean signInByToken() {
        AccountSignResult signResult = AccountRepository.signInByToken();
        // 前往保存token
        // Global.passportId = signResult.Account.PassportId;
        this.authenticate(signResult);
        if (AccountSignResult.SUCCESS != signResult.SignStatus) {
            this.signOut();
        }
        return this.isAuthenticated();
    }

    @Override
    public SignResult signIn(String loginName, String password) {
        AccountSignResult signResult = AccountRepository.signIn(loginName,
                password);
        // 保存passportId
        // Global.passportId = signResult.Account.PassportId;
        // 前往保存token
        this.authenticate(signResult);
        return signResult;
    }

    @Override
    public SignResult shortcutSignIn(String loginName, String validationCode) {
        AccountSignResult signResult = AccountRepository.shortcutSignIn(loginName,
                validationCode);
        // 保存passportId
        // Global.passportId = signResult.Account.PassportId;
        // 前往保存token
        this.authenticate(signResult);
        return signResult;
    }

    /**
     * 注册
     */
    public SignResult signUp(String mobilePhone, String password, String validationCode, int SelectedProfileType) {
        AccountSignResult signResult = AccountRepository.signUp(mobilePhone,password,validationCode,SelectedProfileType);
        // Global.passportId = signResult.Account.PassportId;
        // 前往保存token
        this.authenticate(signResult);
        return signResult;
    }

    /**
     * 重置密码
     *
     * @param password
     * @param identifyingCode
     * @return
     */
    public SignResult resetPwd(String mobilePhone, String password, String identifyingCode) {
        AccountSignResult signResult = AccountRepository.resetPwd(mobilePhone, password,
                identifyingCode);
        // Global.passportId = signResult.Account.PassportId;
        // 前往保存token
        // this.authenticate(signResult);
        return signResult;
    }

    public String changeAvatar(AvatarEntity entity) {
        String url = UserRepository.ChangeAvatar(entity);
        Log.e(Global.LOG_TAG,url+"");
        if (null != url) {
            AccountEntity accountEntity = getCurrentAccount();
            accountEntity.getProfile().Avatar = url;
            this.changeAccountState(accountEntity);
            return url;
        }
        return null;
    }

    public boolean changeProfile(UserProfileEntity entity) {
        boolean isSuccess = UserRepository.ChangeProfile(entity);
        if (isSuccess) {
            AccountEntity accountEntity = getCurrentAccount();
            accountEntity.getProfile().RealName = entity.RealName;
            accountEntity.getProfile().Nickname = entity.Nickname;
            accountEntity.getProfile().Email = entity.Email;
            this.changeAccountState(accountEntity);
            return true;
        }
        return false;
    }

    /**
     * 切换到猎头身份
     */
    public Boolean ChangeCurrentToOrganizationProfile(UserProfileEntity profileEntity) {
        AccountEntity accountEntity = UserRepository
                .ChangeCurrentToOrganizationProfile(profileEntity);
        if (null != accountEntity) {
            this.changeAccountState(accountEntity);
            AppContext.getCurrent().authenticatedStateChanged();
            return true;
        }
        return false;
    }

    /**
     * 切换回普通用户身份
     */
    public Boolean ChangeCurrentToUserProfile() {
        AccountEntity accountEntity = UserRepository.ChangeCurrentToUserProfile();
        if (null != accountEntity) {
            this.changeAccountState(accountEntity);
            AppContext.getCurrent().authenticatedStateChanged();
            return true;
        }
        return false;
    }

    public void changeUserAccount(UserProfileEntity entity) {
        AccountEntity accountEntity = getCurrentAccount();
        accountEntity.UserProfile = entity;
        this.changeAccountState(accountEntity);
    }

    /**
     * 退出登录
     */
    @Override
    public boolean signOut() {
        AccountRepository.signOut();
        // 将token置空。
        this.changeAccountState(null);
        AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_SIGNOUT, null);
        this.initAccessToken();
        return true;
    }

    public final void initAccessToken() {
        if (null == this.getAccessToken()) {
            // 获取到返回的信息，第一次打开app的时候，调用createNew方法，获取到token
            AccountSignResult signResult = AccountRepository.createNew();
            // Global.passportId = signResult.Account.PassportId;
            // 前往保存token
            this.authenticate(signResult);

            AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_NEW, null);
            LogManager.getLogger(AppContext.TAG_ACTION).i("createNew");
        } else {
//            this.signInByToken();
            LogManager.getLogger(AppContext.TAG_ACTION).i("signInByToken");
        }

        LogManager.getLogger().d("passportId: %s, token: %s",
                this.getPassportId(), this.getAccessToken());
    }

    public final String loadSecureAccessToken() {
        if (null == this.getAccessToken()) {
            AccountSignResult signResult = AccountRepository.createNew();
            // Global.passportId = signResult.Account.PassportId;
            // 前往保存token
            this.authenticate(signResult);

            AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_NEW, null);
            LogManager.getLogger(AppContext.TAG_ACTION).i("createNew");
        }
        return this.getAccessToken();
    }

    private final Boolean authenticate(AccountSignResult signResult) {
        if (null != signResult && null != signResult.Account
                && signResult.SignStatus == AccountSignResult.SUCCESS) {
            // 保存token
            this.changeAccountState(signResult.Account);
            AppContext.getCurrent().authenticatedStateChanged();
            return true;
        }
        return false;
    }

    public boolean isInitializedIdentity() {
        boolean isInitializedIdentity = false;
        AccountEntity account = getCurrentAccount();
        if (null != account) {
            isInitializedIdentity = true;
        }
        return isInitializedIdentity;
    }

}
