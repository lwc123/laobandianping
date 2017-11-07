using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Passports.DataRepositories;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public class SignedInLog : EntityBase<long>
    {
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long LogId
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
        public DateTime SignedInTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SignedInIP { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string UtmSource { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string HttpUserAgent { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string RefererDomain { get; set; }

        #endregion //Instance Properties


        /// <summary>
        /// 
        /// </summary>
        public SignedInLog()
        {
            this.SignedInTime = DateTime.Now;
        }

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            this.SignedInTime = DateTime.Now;

            var repository = RepositoryManager.GetRepository<ISignedInLogRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        #endregion //Persist Methods
    }
}
