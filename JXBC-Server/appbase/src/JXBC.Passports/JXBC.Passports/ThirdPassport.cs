using System;
using System.Collections.Generic;
using JXBC.Passports.DataRepositories;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ThirdPassport : EntityBase<long>
    {
        private static readonly object Sync = new object();

        #region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformPassportId"></param>
        /// <returns></returns>
        public static ThirdPassport FindByPlatformPassportId(string platform, string platformPassportId)
        {
            ArgumentAssertion.IsNotNull(platform, "platform");
            ArgumentAssertion.IsNotNull(platformPassportId, "platformPassportId");

            var repository = RepositoryManager.GetRepository<IThirdPassportRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByPlatformPassportId(platform, platformPassportId);
            return model;
        }

        #endregion //Static Methods

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long ThirdPassportId
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
        public string PlatformPassportId { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public string Nickname { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PhotoUrl { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string AccessToken { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PassportInfo { get; set; }

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
        public ThirdPassport()
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

            var oldModel = FindByPlatformPassportId(this.Platform,this.PlatformPassportId);
            if (null != oldModel)
            {
                this.ThirdPassportId = oldModel.ThirdPassportId;
                this.PassportId = oldModel.PassportId;
                this.PersistentState = PersistentState.Persistent;
                return true;
            }

            lock (Sync)
            {
                oldModel = FindByPlatformPassportId(this.Platform, this.PlatformPassportId);
                if (null != oldModel)
                {
                    this.ThirdPassportId = oldModel.ThirdPassportId;
                    this.PassportId = oldModel.PassportId;
                    this.PersistentState = PersistentState.Persistent;
                    return true;
                }

                var repository = RepositoryManager.GetRepository<IThirdPassportRepository>(ModuleEnvironment.ModuleName);
                var isSaved = repository.Save(this);
                return isSaved;
            }
        }

        #endregion //Persist Methods
    }
}
