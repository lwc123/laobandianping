using System;
using System.Collections.Generic;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports.DataRepositories;
using M2SA.AppGenome.Reflection;
using JXTB.CommonData;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class UserProfile : EntityBase<long>
    {
        #region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        internal static UserProfile FindById(long passportId)
        {
            var repository = RepositoryManager.GetRepository<IUserProfileRepository>(ModuleEnvironment.ModuleName);
            var profile = repository.FindById(passportId);
            return profile;
        }

        #endregion //Static Methods

        #region Instance Properties

        private UserPassport userPassport;
        
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
        public ProfileType CurrentProfileType { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Nickname { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string RealName { get; set; }

        /// <summary>
        /// -1：未知;0:男;1:女;
        /// </summary>
        public int Gender { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Avatar { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime Birthday { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Signature { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string CurrentCompany { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string CurrentJobTitle { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public AttestationStatus AttestationStatus { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime LastSignedInTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime LastActivityTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime CreatedTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime ModifiedTime { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string MobilePhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public long CurrentOrganizationId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [NonSerializedProperty]
        [Newtonsoft.Json.JsonIgnore]
        public UserPassport Passport
        {
            get { return this.userPassport; }
            set
            {
                this.userPassport = value;
                if (null != this.userPassport)
                {
                    this.MobilePhone = this.userPassport.MobilePhone;
                    this.PassportId = this.userPassport.PassportId;
                    if (this.CreatedTime <= ModuleEnvironment.EmptyDateTime)
                        this.CreatedTime = this.userPassport.CreatedTime;
                }
            }
        }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public UserProfile()
        {
            this.Gender = -1;
            this.CreatedTime = DateTime.Now;
            this.ModifiedTime = this.CreatedTime;
        }

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual bool Save()
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IUserProfileRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        #endregion //Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="profile"></param>
        public void FillProfile(UserProfile profile)
        {
            var profileType = this.GetType();
            var sourceValues = profile.GetPropertyValues();
            var targetValues = new Dictionary<string, object>(sourceValues.Count);

            foreach (var propValue in sourceValues)
            {
                if (null != propValue.Value && null != profileType.GetPropertyType(propValue.Key))
                    targetValues.Add(propValue.Key, propValue.Value);
            }
            this.SetPropertyValues(targetValues);
        }
    }
}