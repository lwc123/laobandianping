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
    public class UserPageEntity
    {
        #region Instance Properties

        private UserProfile profile = null;
        /// <summary>
        /// 
        /// </summary>
        public UserProfile Profile
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
        public UserPageEntity() { }
    }
}