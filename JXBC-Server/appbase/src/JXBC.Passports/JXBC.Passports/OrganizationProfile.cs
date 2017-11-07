using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using JXBC.Passports.DataRepositories;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXTB.CommonData;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class OrganizationProfile : UserProfile
    {
        #region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        internal new static OrganizationProfile FindById(long passportId)
        {
            var repository = RepositoryManager.GetRepository<IOrganizationProfileRepository>(ModuleEnvironment.ModuleName);
            var profile = repository.FindById(passportId);
            return profile;
        }

        internal static bool Transform(UserPassport passport, OrganizationProfile newProfile)
        {
            ArgumentAssertion.IsNotNull(passport, "passport");

            OrganizationProfile profile = null;

            if (passport.Profile is OrganizationProfile)
            {
                profile = (OrganizationProfile)passport.Profile;
            }
            else
            {
                profile = new OrganizationProfile();
                profile.FillProfile(passport.Profile);                
                profile.PersistentState = PersistentState.Transient;                
            }
            if(null != newProfile)
            {
                profile.CurrentProfileType = ProfileType.OrganizationProfile;
                profile.CurrentOrganizationId = newProfile.CurrentOrganizationId;
            }
            
            var saved = profile.Save();

            if (saved)
            {
                passport.Profile = profile;
                passport.ProfileType = ProfileType.OrganizationProfile;
                passport.MultipleProfiles = passport.MultipleProfiles | ProfileType.OrganizationProfile;
                passport.Save();
            }  

            return saved;
        }

        #endregion //Static Methods

        #region Instance Properties

        /// <summary>
        /// 认证审核时间
        /// </summary>
        public DateTime AttestationTime { get; set; }        

        /// <summary>
        /// 身份
        /// </summary>
        public string Identity { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SelfIntroduction { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public string[] AuthenticationImages { get; set; }

        /// <summary>
        /// 认证拒绝原因
        /// </summary>
        public string AttestationRejectedReason { get; set; }

        #endregion //Instance Properties

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override bool Save()
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IOrganizationProfileRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool ChangeAttestationStatus()
        {
            this.AttestationTime = DateTime.Now;

            var repository = RepositoryManager.GetRepository<IOrganizationProfileRepository>(ModuleEnvironment.ModuleName);
            return repository.ChangeAttestationStatus(this);
        }

        #endregion //Persist Methods
    }
}
