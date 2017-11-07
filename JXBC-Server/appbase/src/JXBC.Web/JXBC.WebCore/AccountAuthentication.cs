using System;
using System.Web;
using JXBC.Passports;
using JXBC.Passports.Security;
using JXBC.Passports.Providers;
using M2SA.AppGenome;

namespace JXBC.WebCore
{
    /// <summary>
    /// 
    /// </summary>
    public static class AccountAuthentication
    {
        public static readonly string TokenKey = "JX-TOKEN";
        public static readonly string DeviceKey = "JX-DEVICE";

        public static AnonymousAccount CreateNew(ClientDevice device)
        {
            if (null == device) return null;

            device.DeviceId = 0;
            device.CreatedTime = DateTime.Now;
            device.ModifiedTime = device.CreatedTime;
            device.Save();

            var account = AnonymousAccount.CreateNew(device.DeviceId);
            return account;
        }        

        public static UserPassport BindThirdPassport(ThirdPassport entity, out SignStatus status)
        {
            UserPassport passport = null;
            status = SignStatus.None;

            if (null == entity
                || string.IsNullOrEmpty(entity.Platform) || string.IsNullOrEmpty(entity.PlatformPassportId))
                return null;            
            
            MemberShip.BindThirdPassport(entity, out status);
            if (status == SignStatus.Success)
            {
                Authenticate(passport);
            }

            return passport;
        }

        public static UserPassport SignUp(string mobilePhone, string password, ProfileType selectedProfileType, SignedUpInfo signedUpInfo, out SignStatus status)
        {
            var passport = MemberShip.SignUp(mobilePhone, password, selectedProfileType, signedUpInfo, out status);

            if (status == SignStatus.Success)
            {
                Authenticate(passport);                
            }

            return passport;
        }

        public static bool SignIn(string userKey, string password, SignedInLog info, out UserPassport passport)
        {
            var signInResult = MemberShip.SignIn(userKey, password, info, out passport);
            if (signInResult)
            {
                Authenticate(passport);
            }

            return signInResult;
        }

        public static bool SignIn(long passportId, SignedInLog info, out UserPassport passport)
        {
            var signInResult = MemberShip.SignIn(passportId, info, out passport);
            if (signInResult)
            {
                Authenticate(passport);
            }

            return signInResult;
        }

        public static void Authenticate(UserPassport passport)
        {
            if (null == passport)
            {
                SignOut();
            }
            else
            {
                MvcContext.Current.PassportId = passport.PassportId;
                if(null != MvcContext.Current.ClientAccount)
                {
                    MvcContext.Current.ClientAccount.PassportId = passport.PassportId;
                    MvcContext.Current.ClientAccount.Save();
                }

                //SyncIMAccount(passport);
            }
        }

        public static ThirdIMAccount LoadIMAccount(UserProfile profile)
        {
            var currentProfileType = ProfileType.UserProfile;

            if (profile is OrganizationProfile)
                currentProfileType = ((OrganizationProfile)profile).CurrentProfileType;

            var platform = ModuleEnvironment.IMProviderName;
            var imAccount = ThirdIMAccount.FindByPlatformAccountId(platform, ThirdIMAccount.BuildAccountName(profile.PassportId, currentProfileType));
            return imAccount;
        }

        #region SyncIMAccount

        public static void SyncIMAccount(UserPassport passport)
        {
            return; // not using im 
            var currentProfileType = ProfileType.UserProfile;

            if (passport.Profile is OrganizationProfile)
                currentProfileType = ((OrganizationProfile)passport.Profile).CurrentProfileType;

            var imAccount = new ThirdIMAccount();
            imAccount.Platform = ModuleEnvironment.IMProviderName;
            imAccount.PlatformAccountId = string.Concat(ProfileType.OrganizationProfile == currentProfileType ? "cc-" : "u-", passport.PassportId);
            imAccount.Nickname = ProfileType.OrganizationProfile == currentProfileType ? passport.Profile.RealName : passport.Profile.Nickname;

            TrySyncIMAccount(imAccount);
        }

        private static void TrySyncIMAccount(ThirdIMAccount source)
        {
            try
            {
                SyncIMAccount(source);
            }
            catch
            {
                AppInstance.GetThreadPool().QueueWorkItem((item) => SyncIMAccount(item), source);
            }
        }

        private static void SyncIMAccount(ThirdIMAccount source)
        {
            var imAccount = ThirdIMAccount.CreateNew(source.PassportId, source.Platform, source.PlatformAccountId);
            imAccount.Nickname = source.Nickname;

            if (null == imAccount) return;

            if (imAccount.IsSync)
            {
                ObjectIOCFactory.GetSingleton<IIMProvider>(ModuleEnvironment.IMProviderName).ChangeNickname(imAccount);
            }
            else
            {
                var isSync = ObjectIOCFactory.GetSingleton<IIMProvider>(ModuleEnvironment.IMProviderName).CreateAccount(imAccount);
                if (isSync)
                {
                    imAccount.IsSync = isSync;
                    imAccount.Save();
                }
            };
        }

        #endregion //SyncIMAccount

        public static void SignOut()
        {
            MvcContext.Current.PassportId = 0;
            MvcContext.Current.UserPassport = null;
            MvcContext.Current.ClientAccount = null;

            var deviceKey = HttpContext.Current.Request.Headers[DeviceKey];
            var deviceId = 0L;
            if (false == string.IsNullOrEmpty(deviceKey) && false == long.TryParse(deviceKey, out deviceId) && deviceId > 0)
            {
                var account = AnonymousAccount.CreateNew(deviceId);
                MvcContext.Current.ClientAccount = account;
            }
        }        

        internal static AnonymousAccount LoadAuthenticationInfo()
        {
            var accessToken = HttpContext.Current.Request.Headers[TokenKey];
            var clientId = HttpContext.Current.Request.Headers[DeviceKey];

            if (string.IsNullOrEmpty(accessToken))
                accessToken = CookieHelper.GetValue(TokenKey);
            if (string.IsNullOrEmpty(accessToken))
                return null;

            var account = AnonymousAccount.FindByAccessToken(accessToken);
            return account;
        }
    }
}
