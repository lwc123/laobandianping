using System;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class ConsultantSummary 
    {
        #region Instance Properties

        /// <summary> 
        ///  
        /// </summary> 
        public decimal WalletBalance { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public int TotalServiceContractCount { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int ServicingContractCount { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int NewContractCount { get; set; }

        private OrganizationProfile profile = null;
        /// <summary>
        /// 
        /// </summary>
        public OrganizationProfile Profile
        {
            get { return profile; }
            set
            {
                this.profile = value;
                if (null != this.profile)
                    this.profile.FormatEntity();
            }
        }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public ConsultantSummary() { }
    }
}