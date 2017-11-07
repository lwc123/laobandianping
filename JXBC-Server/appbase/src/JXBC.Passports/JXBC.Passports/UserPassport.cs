using System;
using System.Collections.Generic;
using System.Transactions;
using System.Linq;
using JXBC.Passports.Security;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports.DataRepositories;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class UserPassport : EntityBase<long>
    {
        #region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public static long FindIdByEmail(string email)
        {
            ArgumentAssertion.IsNotNull(email, "email");

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var userId = repository.FindIdByEmail(email);
            return userId;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        public static long FindIdByMobilePhone(string mobilePhone)
        {
            ArgumentAssertion.IsNotNull(mobilePhone, "mobilePhone");

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var userId = repository.FindIdByMobilePhone(mobilePhone);
            return userId;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static long FindIdByUserName(string userName)
        {
            ArgumentAssertion.IsNotNull(userName, "userName");

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var userId = repository.FindIdByUserName(userName);
            return userId;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        public static UserPassport FindById(long passportId)
        {
            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var passport = repository.FindById(passportId);
            return passport;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        public static UserPassport FindUserWithSecurityById(long passportId)
        {
            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var passport = repository.FindUserWithSecurityById(passportId);
            return passport;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public static IList<UserPassport> FindByIds(IList<long> ids)
        {
            ids.AssertNotNull("ids");
            if (null== ids|| ids.Count == 0) return null;

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByIds(ids);
            
            return list;
        }

        #endregion //Static Methods

        #region Instance Properties

        [NonSerialized]
        private UserSecurity userSecurity;

        private UserProfile profile;

        /// <summary>
        /// 
        /// </summary>
        public long PassportId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string MobilePhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public PassportStatus PassportStatus { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public ProfileType ProfileType { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public ProfileType MultipleProfiles { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime CreatedTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime ModifiedTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [NonSerializedProperty]
        [Newtonsoft.Json.JsonIgnore]
        public UserSecurity UserSecurity
        {
            get { return this.userSecurity; }
            set
            {
                this.userSecurity = value;
                if (null != this.userSecurity) this.userSecurity.UserPassport = this;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        [NonSerializedProperty]
        public UserProfile Profile
        {
            get { return this.LoadProfile(); }
            set
            {
                this.profile = value;
                if (null != this.profile)
                {
                    this.profile.Passport = this;
                    if (this.profile is OrganizationProfile)
                        this.ProfileType = ProfileType.OrganizationProfile;
                    else
                        this.ProfileType = ProfileType.UserProfile;
                }
            }
        }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public UserPassport()
        {
            this.CreatedTime = DateTime.Now;
            this.ModifiedTime = this.CreatedTime;
        }

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            this.ModifiedTime = DateTime.Now;

            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            var result = false;
            if (this.PersistentState == PersistentState.Transient && null != this.userSecurity)
            {
                using (var transactionScope = new TransactionScope(TransactionScopeOption.Required))
                {
                    result = repository.Save(this);
                    if (result && this.PassportId > 0)
                    {
                        this.UserSecurity.OriginalPassword = this.UserSecurity.Password;
                        this.UserSecurity.Password = this.HashPassword(this.UserSecurity.Password);
                        this.UserSecurity.PassportId = this.PassportId;
                        result = this.UserSecurity.Save();

                        if (result)
                        {
                            this.Profile.PassportId = this.PassportId;
                            result = this.Profile.Save();
                        }
                    }
                    transactionScope.Complete();
                }
            }
            else
            {
                result = repository.Save(this);
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IUserPassportRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <returns></returns>
        public bool ChangePassword(string password)
        {
            this.UserSecurity.OriginalPassword = password;
            this.UserSecurity.HashAlgorithm = null;
            this.UserSecurity.Password = this.HashPassword(password);
            this.UserSecurity.LastPasswordChangedTime = DateTime.Now;
            this.UserSecurity.UnLock();
            var result = this.UserSecurity.Save();
            return result;
        }

        private string HashPassword(string password)
        {
            return PassportSecurityProvider.HashPassword(password, this);
        }

        #endregion //Persist Methods

        #region SignUp & SignIn
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal bool SignUp(SignedUpInfo signedUpInfo)
        {
            using (var transactionScope = new TransactionScope(TransactionScopeOption.Required))
            {
                var result = this.Save();                

                if (null != signedUpInfo)
                {
                    signedUpInfo.SignedUpTime = this.CreatedTime;
                    signedUpInfo.PassportId = this.PassportId;
                    signedUpInfo.Save();
                }

                transactionScope.Complete();
                return result;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        internal void SignIn()
        {
            if (null == this.Profile) return;
            this.Profile.LastSignedInTime = DateTime.Now;
            this.Profile.LastActivityTime = this.Profile.LastSignedInTime;
            this.Profile.Save();
            if (this.UserSecurity != null && this.UserSecurity.IsLocked)
                this.UserSecurity.UnLock();
        }

        #endregion //SignUp & SignIn

        private UserProfile LoadProfile()
        {
            if (null != this.profile) return this.profile;
            if (this.PassportId == 0) return null;

            if ((this.ProfileType & ProfileType.OrganizationProfile) == ProfileType.OrganizationProfile)
                this.profile = OrganizationProfile.FindById(this.PassportId);
            else
                this.profile = UserProfile.FindById(this.PassportId);

            if (null != this.profile) this.profile.Passport = this;
            return this.profile;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetRealName()
        {
            var realName = null == this.Profile ? null : this.Profile.Nickname;
            if (string.IsNullOrEmpty(realName) && this.Profile!=null)
            {
                realName = this.Profile.RealName;
            }
            if (string.IsNullOrEmpty(realName))
            {
                realName = this.UserName;
            }

            if (string.IsNullOrEmpty(realName))
            {
                realName = this.Email;
            }
            if (string.IsNullOrEmpty(realName))
            {
                realName = string.Format("U{0}",this.PassportId);
            }
            return realName;
        }
    }
}