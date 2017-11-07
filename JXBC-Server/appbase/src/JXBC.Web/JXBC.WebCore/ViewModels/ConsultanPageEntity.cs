using System;
using System.Collections.Generic;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;
using JXBC.Workplace;


namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class ConsultantPageEntity
    {
        #region Instance Properties



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
        public ConsultantPageEntity() { }
    }
}