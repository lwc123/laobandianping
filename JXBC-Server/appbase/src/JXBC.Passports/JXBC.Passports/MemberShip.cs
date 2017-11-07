using System;
using System.Text.RegularExpressions;
using M2SA.AppGenome;
using JXBC.Passports.Security;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public static class MemberShip
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passport"></param>
        public delegate void ChangeMemberShip(UserPassport passport);

        private static event ChangeMemberShip OnSignUp;
        private static event ChangeMemberShip OnSignIn;

        private static readonly Regex MobilePhoneRegex = new Regex(@"^1\d{10}$", RegexOptions.Compiled);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="action"></param>
        public static void RegisterSignUpListener(ChangeMemberShip action)
        {
            OnSignUp += action;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="action"></param>
        public static void RegisterSignInListener(ChangeMemberShip action)
        {
            OnSignIn += action;
        }

        #region SignUp 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="mobilePhone"></param>
        /// <param name="password"></param>
        /// <param name="selectedProfileType"></param>
        /// <param name="signedUpInfo"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        public static UserPassport SignUp(string mobilePhone, string password, ProfileType selectedProfileType,  SignedUpInfo signedUpInfo, out SignStatus status)
        {
            status = SignStatus.None;
            status = CheckMobilePhone(mobilePhone);
            if (status != SignStatus.None) return null;

            status = CheckPassword(password);
            if (status != SignStatus.None) return null;

            return SignUp(null, mobilePhone, null, password, selectedProfileType, signedUpInfo, out status);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="selectedProfileType"></param>
        /// <param name="signedUpInfo"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2201:DoNotRaiseReservedExceptionTypes")]
        public static UserPassport SignUp(string email, string userName, string password, ProfileType selectedProfileType, SignedUpInfo signedUpInfo)
        {
            var status = SignStatus.Error;
            var passport = SignUp(email, userName, password, selectedProfileType, signedUpInfo, out status);
            if (null == password)
                throw new Exception(status.ToString());
            return passport;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="selectedProfileType"></param>
        /// <param name="signedUpInfo"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        public static UserPassport SignUp(string email, string userName, string password, ProfileType selectedProfileType, SignedUpInfo signedUpInfo, out SignStatus status)
        {
            status = CheckEmail(email);
            if (status != SignStatus.None) return null;

            status = CheckUserName(userName);
            if (status != SignStatus.None) return null;

            status = CheckPassword(password);
            if (status != SignStatus.None) return null;

            return SignUp(email, null, userName, password, selectedProfileType, signedUpInfo, out status);
        }

        private static UserPassport SignUp(string email, string mobilePhone, string userName, string password, ProfileType selectedProfileType, SignedUpInfo signedUpInfo, out SignStatus status)
        {
            var userPassport = new UserPassport() { UserSecurity = new UserSecurity(), Profile = new UserProfile() };
            userPassport.Email = email;
            userPassport.MobilePhone = mobilePhone;
            userPassport.UserName = userName;
            userPassport.MultipleProfiles = selectedProfileType;            

            userPassport.UserSecurity.Password = password;

            userPassport.Profile.CurrentProfileType = selectedProfileType;
            userPassport.Profile.CreatedTime = userPassport.CreatedTime;
            userPassport.Profile.LastSignedInTime = userPassport.Profile.CreatedTime;
            userPassport.Profile.LastActivityTime = userPassport.Profile.CreatedTime;
            userPassport.Profile.Email = email;
            status = SignStatus.Error;
            if (userPassport.SignUp(signedUpInfo))
            {
                status = SignStatus.Success;
                if (selectedProfileType == ProfileType.OrganizationProfile)
                {
                    OrganizationProfile.Transform(userPassport, new OrganizationProfile());
                }

                if(null != OnSignUp)
                {
                    OnSignUp(userPassport);
                }
            }
                
            return userPassport;
        }


        private static SignStatus CheckEmail(string email)
        {
            ArgumentAssertion.IsNotNull(email, "email");

            var signUpStatus = SignStatus.None;
            if (false == email.IsMatchEMail())
                signUpStatus = SignStatus.InvalidEmail;
            else
            {
                var passportId = UserPassport.FindIdByEmail(email);
                if (passportId > 0)
                    signUpStatus = SignStatus.DuplicateEmail;
            }
            return signUpStatus;
        }

        private static SignStatus CheckMobilePhone(string mobilePhone)
        {
            mobilePhone.AssertNotNull("mobilePhone");

            var signUpStatus = SignStatus.None;

            if (false == mobilePhone.IsMatchMobilePhone())
                signUpStatus = SignStatus.InvalidMobilePhone;
            else
            {
                var passportId = UserPassport.FindIdByMobilePhone(mobilePhone);
                if (passportId > 0)
                    signUpStatus = SignStatus.DuplicateMobilePhone;
            }
            return signUpStatus;
        }


        private static SignStatus CheckUserName(string userName)
        {
            var signUpStatus = SignStatus.None;

            if (string.IsNullOrEmpty(userName)) return signUpStatus;
            if (false == Regex.IsMatch(userName, ModuleEnvironment.UserNamePattern))
                signUpStatus = SignStatus.InvalidUserName;
            else
            {
                var passportId = UserPassport.FindIdByUserName(userName);
                if (passportId > 0)
                    signUpStatus = SignStatus.DuplicateUserName;
            }

            return signUpStatus;
        }

        private static SignStatus CheckPassword(string password)
        {
            ArgumentAssertion.IsNotNull(password, "password");

            var signUpStatus = SignStatus.None;
            var passwordStrength = PasswordStrengthMarker.MarkStrength(password);
            if (passwordStrength < ModuleEnvironment.PasswordStrength)
                signUpStatus = SignStatus.InvalidPassword;

            return signUpStatus;
        }

        private static bool IsMatchRegex(string input, Regex regex)
        {
            var result = !string.IsNullOrEmpty(input);
            if (result)
                result = regex.IsMatch(input);
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static bool IsMatchMobilePhone(this string input)
        {
            return IsMatchRegex(input, MobilePhoneRegex);
        }

        #endregion //SignUp 

        #region SignIn 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userKey"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static bool SignIn(string userKey, string password)
        {
            UserPassport userPassport = null;
            return SignIn(userKey, password, out userPassport);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userKey"></param>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        public static bool SignIn(string userKey, string password, out UserPassport userPassport)
        {
            ArgumentAssertion.IsNotNull(userKey, "userKey");
            ArgumentAssertion.IsNotNull(password, "password");

            long passportId = 0;

            if (userKey.IsMatchEMail())
                passportId = UserPassport.FindIdByEmail(userKey);
            else if (userKey.IsMatchMobilePhone())
                passportId = UserPassport.FindIdByMobilePhone(userKey);
            else
                passportId = UserPassport.FindIdByUserName(userKey);

            userPassport = null;
            var verified = false;
            if (passportId > 0)
            {
                UserPassport passport = null;
                verified = VerifyPassword(passportId, password, out passport);
                if (verified)
                {
                    userPassport = passport;
                    userPassport.SignIn();

                    if (null != OnSignIn)
                    {
                        OnSignIn(userPassport);
                    }

                }
            }
            return verified;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userKey"></param>
        /// <param name="password"></param>
        /// <param name="info"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        public static bool SignIn(string userKey, string password, SignedInLog info, out UserPassport userPassport)
        {
            bool verified = SignIn(userKey, password, out userPassport);
            if (verified && null != userPassport && null != info)
            {
                info.PassportId = userPassport.PassportId;
                info.Save();
            }
            return verified;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="info"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        public static bool SignIn(long passportId, SignedInLog info, out UserPassport userPassport)
        {
            userPassport = UserPassport.FindById(passportId);
            bool verified = null != userPassport;

            if (verified)
            {
                userPassport.SignIn();
                if (null != info)
                {
                    info.PassportId = userPassport.PassportId;
                    info.Save();
                }

                if (null != OnSignIn)
                {
                    OnSignIn(userPassport);
                }
            }
            
            return verified;
        }

        /// <summary>
        /// 
        /// </summary>

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static bool VerifyPassword(long passportId, string password)
        {
            UserPassport userPassport = null;
            return VerifyPassword(passportId, password, out userPassport);
        }

        private static bool VerifyPassword(long passportId, string password, out UserPassport userPassport)
        {
            ArgumentAssertion.IsNotNull(password, "password");

            userPassport = null;
            var result = false;
            if (passportId > 0)
            {
                var passport = UserPassport.FindUserWithSecurityById(passportId);
                result = PassportSecurityProvider.Verify(password, passport);
                if (result)
                    userPassport = passport;
            }
            return result;
        }

        #endregion //SignIn 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters", MessageId = "1#")]
        public static UserPassport BindThirdPassport(ThirdPassport entity, out SignStatus status)
        {
            entity.AssertNotNull("entity");

            UserPassport passport = null;
            status = SignStatus.None;
            var thirdPassport = ThirdPassport.FindByPlatformPassportId(entity.Platform, entity.PlatformPassportId);
            if (null == thirdPassport)
            {
                var email = string.Format("${0}@{1}.io", entity.PlatformPassportId, entity.Platform);
                var password = EncryptProvider.GenerateSalt();

                passport = MemberShip.SignUp(email, null, null, password, ProfileType.UserProfile , new SignedUpInfo(), out status);
                if (SignStatus.Success == status)
                {
                    thirdPassport = entity;
                    thirdPassport.PassportId = passport.PassportId;
                    thirdPassport.Save();
                }
            }
            else
            {
                passport = UserPassport.FindById(thirdPassport.PassportId);
                status = null == passport ? SignStatus.Error : SignStatus.Success;
            }

            return passport;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public static bool ChangePassword(long passportId, string password)
        {
            var result = false;
            if (passportId > 0)
            {
                var passport = UserPassport.FindUserWithSecurityById(passportId);
                result = passport.ChangePassword(password);
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        public static bool AuthenticatUserName(string email, string mobilePhone)
        {
            bool result = false;
            if (!string.IsNullOrEmpty(email))
            {
                var passportId = UserPassport.FindIdByEmail(email);
                result = passportId > 0;
            }
            if (!string.IsNullOrEmpty(mobilePhone))
            {
                var passportId = UserPassport.FindIdByMobilePhone(mobilePhone);
                result = passportId > 0;
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passport"></param>
        /// <param name="newProfile"></param>
        /// <returns></returns>
        public static bool OpenOrganizationService(UserPassport passport, OrganizationProfile newProfile)
        {
            passport.AssertNotNull("passport");
            newProfile.AssertNotNull("newProfile");
            
            return OrganizationProfile.Transform(passport, newProfile);
        }
    }
}
