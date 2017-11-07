using System;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class UserSummary
    {
        #region Instance Properties

        /// <summary>
        ///  
        /// </summary> 
        public decimal WalletBalance { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public int ResumeIntegrality { get; set; }

        private UserProfile userProfile = null;
        /// <summary>
        /// 
        /// </summary>
        public UserProfile UserProfile
        {
            get { return userProfile; }
            set
            {
                this.userProfile = value;
                if (null != this.userProfile)
                    this.userProfile.FormatEntity();
            }
        }      

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public UserSummary(UserProfile profile)
        {
            this.UserProfile = profile;
        }
    }
}