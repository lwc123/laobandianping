using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using JXBC.Passports.DataRepositories;
using JXBC.Passports.Security;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Cache;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class AnonymousAccount : EntityBase<long>
    {
        #region Static Methods

        private static void ChangeAccessTokenCache(string accessToken, AnonymousAccount account)
        {
            var cache = CacheManager.GetCache(ModuleEnvironment.TokenCacheName);
            if (null == account)
            {
                cache.Remove(accessToken);
            }
            else
            {
                cache.Set(accessToken, account);
            }

            if (false == string.IsNullOrEmpty(ModuleEnvironment.ThirdLinkedCacheName))
            {
                var thirdLinkedCache = CacheManager.GetCache(ModuleEnvironment.ThirdLinkedCacheName);
                thirdLinkedCache.Remove(accessToken);
            }

            M2SA.AppGenome.Logging.LogManager.GetLogger().Info("=========>[Token] Change cache {0} => [{1}]", accessToken, null == account ? "null" : account.ToText());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="accessToken"></param>
        /// <returns></returns>
        public static AnonymousAccount FindByAccessToken(string accessToken)
        {
            var cache = CacheManager.GetCache(ModuleEnvironment.TokenCacheName);
            var account = cache.Get<AnonymousAccount>(accessToken);
            if (null != account && account.Token.IsExpired)
            {
                account = null;
                ChangeAccessTokenCache(accessToken, account);
            }

            if (null == account)
            {
                var repository = RepositoryManager.GetRepository<IAnonymousAccountRepository>(ModuleEnvironment.ModuleName);
                account = repository.FindByAccessToken(accessToken);
                if (null != account && false == account.Token.IsExpired)
                    ChangeAccessTokenCache(accessToken, account);
                else
                    account = null;
            }

            return account;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deviceId"></param>
        /// <returns></returns>
        public static AnonymousAccount CreateNew(long deviceId)
        {
            ArgumentAssertion.IsNotNull(deviceId, "deviceId");
            var accountKey = string.Concat(deviceId.ToString(), Guid.NewGuid().ToString("N"));

            var account = new AnonymousAccount();
            account.DeviceId = deviceId;
            var authToken = HashHelper.ComputeHash(string.Concat(accountKey, account.CreatedTime.ToString()), HashAlgorithmName.SHA1);
            account.Token = new AnonymousAccount.AccountToken() { AccessToken = authToken, ExpiresTime = DateTime.Now.AddYears(1) };
            var saved = account.Save();
            return saved ? account : null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        public static AnonymousAccount FindLastByPassport(long passportId)
        {
            var repository = RepositoryManager.GetRepository<IAnonymousAccountRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindLastByPassport(passportId);

            if (null != model && model.Token.IsExpired) model = null;

            return model;
        }


        #endregion //Static Methods

        #region AccountToken

        /// <summary>
        /// 
        /// </summary>
        [Serializable]
        public class AccountToken
        {
            /// <summary>
            /// 
            /// </summary>
            public long TokenId { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public long AccountId { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public long PassportId { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string AccessToken { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public DateTime ExpiresTime { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public bool IsExpired
            {
                get { return this.ExpiresTime < DateTime.Now; }
            }
        }

        #endregion //AccountToken

        private long passportId = 0;

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long AccountId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public long DeviceId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public long PassportId
        {
            get { return this.passportId; }
            set
            {
                this.passportId = value;
                if (this.Token != null)
                    this.Token.PassportId = this.passportId;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string Nickname { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Avatar { get; set; }

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
        public AccountToken Token { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public AnonymousAccount()
        {
            this.CreatedTime = DateTime.Now;
        }

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            this.ModifiedTime = this.CreatedTime;

            var repository = RepositoryManager.GetRepository<IAnonymousAccountRepository>(ModuleEnvironment.ModuleName);
            var isSaved = repository.Save(this);            
            if (isSaved && this.Token.TokenId > 0)
            {
                ChangeAccessTokenCache(this.Token.AccessToken, this);
            }
            return isSaved;

        }

        #endregion //Persist Methods
    }
}