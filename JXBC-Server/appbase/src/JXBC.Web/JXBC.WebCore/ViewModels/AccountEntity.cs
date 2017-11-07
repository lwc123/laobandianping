using System;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class AccountEntity : AnonymousAccount
    {
        #region Instance Properties        
        
        /// <summary>
        /// 
        /// </summary>
        public string MobilePhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public ProfileType MultipleProfiles { get; set; }

        private UserProfile userPofile = null;
        /// <summary>
        /// 
        /// </summary>
        public UserProfile UserProfile
        {
            get { return userPofile; }
            set
            {
                this.userPofile = value;
                if (null != this.userPofile)
                    this.userPofile.FormatEntity();
            }
        }        

        public ThirdIMAccount IMAccount { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public AccountEntity()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="account"></param>
        /// <param name="passport"></param>
        public AccountEntity(AnonymousAccount account, UserPassport passport)
        {
            this.SetPropertyValues(account.GetPropertyValues());
            if (null != passport && null != passport.Profile)
            {
                this.UserProfile = passport.Profile;

                this.MobilePhone = passport.MobilePhone;
                this.MultipleProfiles = passport.MultipleProfiles;
                this.IMAccount = AccountAuthentication.LoadIMAccount(passport.Profile);
            }
        }
    }
}