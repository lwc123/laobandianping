using System;
using M2SA.AppGenome.Data;
using JXBC.Passports.DataRepositories;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class SignedUpInfo : EntityBase<long>
    {

        #region Instance Properties

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
        public DateTime SignedUpTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SignedUpIp { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string UtmSource { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string RefererDomain { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string HttpReferer { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string HttpUserAgent { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string InviteCode { get; set; }

        #endregion //Instance Properties


        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            var repository = RepositoryManager.GetRepository<ISignedUpInfoRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal bool Delete()
        {
            var repository = RepositoryManager.GetRepository<ISignedUpInfoRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}