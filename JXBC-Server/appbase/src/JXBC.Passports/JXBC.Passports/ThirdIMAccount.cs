using System;
using System.Collections.Generic;
using JXBC.Passports.DataRepositories;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports.Providers;
using JXBC.Passports.Security;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ThirdIMAccount : EntityBase<long>
    {

        #region Static Methods  

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="profileType"></param>
        /// <returns></returns>
        public static string BuildAccountName(long passportId, ProfileType profileType)
        {
            return string.Concat(ProfileType.OrganizationProfile == profileType ? "cc-" : "u-", passportId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="platform"></param>
        /// <param name="platformAccountId"></param>
        /// <returns></returns>
        public static ThirdIMAccount CreateNew(long passportId, string platform, string platformAccountId)
        {
            var account = FindByPlatformAccountId(platform, platformAccountId);
            if (null == account)
            {
                account = new ThirdIMAccount();
                account.PassportId = passportId;
                account.Platform = platform;
                account.PlatformAccountId = platformAccountId;
                account.PlatformAccountPassword = HashHelper.ComputeHash(string.Concat(passportId, DateTime.Now), HashAlgorithmName.MD5).Substring(8, 16);
                account.Save();                
            }
            return account;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformAccountId"></param>
        /// <returns></returns>
        public static ThirdIMAccount FindByPlatformAccountId(string platform, string platformAccountId)
        {
            ArgumentAssertion.IsNotNull(platform, "platform");
            ArgumentAssertion.IsNotNull(platformAccountId, "platformAccountId");

            var repository = RepositoryManager.GetRepository<IThirdIMAccountRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByPlatformAccountId(platform, platformAccountId);
            return model;
        }

        #endregion //Static Methods

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
        public long PassportId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Platform { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PlatformAccountId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PlatformAccountPassword { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Nickname { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool IsSync { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime CreatedTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime ModifiedTime { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public ThirdIMAccount()
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
            this.ModifiedTime = DateTime.Now;

            var repository = RepositoryManager.GetRepository<IThirdIMAccountRepository>(ModuleEnvironment.ModuleName);
            var isSaved = repository.Save(this);
            return isSaved;
        }

        #endregion //Persist Methods
    }
}
