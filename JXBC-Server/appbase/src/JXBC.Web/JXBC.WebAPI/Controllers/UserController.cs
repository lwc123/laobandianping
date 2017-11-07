using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports;
using JXBC.TradeSystem;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using M2SA.AppGenome.Logging;

namespace JXBC.WebAPI.Controllers
{
    public class UserController : ApiController
    {
        [HttpGet]
        public UserProfile Profile(string imAccount)
        {
            if (string.IsNullOrEmpty(imAccount) || false == imAccount.Contains("-"))
                return null;

            var accountInfo = imAccount.Split('-');
            if(accountInfo.Length != 2) return null;
            var passportId = 0L;
            if(long.TryParse(accountInfo[1], out passportId))
            {
                return Profile(passportId);
            }
            return null;
        }

        [HttpGet]
        public UserProfile Profile(long id)
        {
            var userPassport = UserPassport.FindById(id);
            if (null == userPassport) return null;

            return userPassport.Profile.FormatEntity();
        }

        [HttpGet]
        public IList<UserProfile> Profiles(string ids)
        {
            if (string.IsNullOrEmpty(ids)) return null;

            var idsArray = ids.Split(',');
            var idList = new List<long>(idsArray.Length);
            foreach(var item in idsArray)
            {
                var id = 0L;
                if(long.TryParse(item, out id))
                {
                    idList.Add(id);
                }
            }

            var passports = UserPassport.FindByIds(idList);

            IList<UserProfile> profiles = null;
            if(null != passports && passports.Count > 0)
            {
                profiles = new List<UserProfile>(passports.Count);
                for (var i=0; i< passports.Count; i++)
                {
                    profiles.Add(passports[i].Profile.FormatEntity());
                }
            }

            return profiles;
        }

        [Authorize]
        [HttpGet]
        public UserSummary Summary()
        {
            var profile = MvcContext.Current.UserPassport.Profile;
            var userWallet = Wallet.FindByOwnerId(WalletType.Privateness, profile.PassportId);
            var resumeIntegrality = 0;

            var userSummary = new UserSummary(profile);
            userSummary.WalletBalance = null == userWallet ? 0 : userWallet.AvailableBalance;
            userSummary.ResumeIntegrality = resumeIntegrality;

            return userSummary;
        }

        [Authorize]
        [HttpPost]
        public bool ChangeProfile([FromBody]UserProfile entity)
        {
            if (entity == null) return false;
            var profile = MvcContext.Current.UserPassport.Profile;
            var syncIMAccount = false == string.IsNullOrEmpty(entity.Nickname) && profile.Nickname != entity.Nickname;

            profile.FillPropertiesFromEntity(entity, true);            
            profile.PassportId = MvcContext.Current.PassportId;

            var saved = profile.Save();
            if (saved && syncIMAccount)
            {
                AccountAuthentication.SyncIMAccount(MvcContext.Current.UserPassport);
            }
            return saved;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpPost]
        public AccountEntity ChangeCurrentToOrganizationProfile(OrganizationProfile newProfile)
        {
            var passport = MvcContext.Current.UserPassport;
            MemberShip.OpenOrganizationService(passport, newProfile);

            AccountAuthentication.SyncIMAccount(passport);
            return new AccountEntity(MvcContext.Current.ClientAccount, passport);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Authorize]
        [HttpPost]
        public AccountEntity ChangeCurrentToUserProfile()
        {
            var passport = MvcContext.Current.UserPassport;
            AccountEntity result = null;

            if ((passport.MultipleProfiles & ProfileType.UserProfile) != ProfileType.UserProfile)
            {
                passport.MultipleProfiles = passport.MultipleProfiles | ProfileType.UserProfile;
                passport.Save();
            }

            if (passport.Profile.CurrentProfileType != ProfileType.UserProfile)
            {
                var profile = passport.Profile;
                profile.CurrentProfileType = ProfileType.UserProfile;
                var saved = profile.Save();
                if (saved)
                {
                    AccountAuthentication.SyncIMAccount(passport);
                    result = new AccountEntity(MvcContext.Current.ClientAccount, passport);
                }
            }
            return new AccountEntity(MvcContext.Current.ClientAccount, passport); 
        }

        [Authorize]
        [HttpPost]
        public string ChangeAvatar([FromBody]AvatarEntity entity)
        {
            entity.PassportId = MvcContext.Current.UserPassport.PassportId;
            if (entity == null || string.IsNullOrEmpty(entity.AvatarStream)) return null;

            var profile = MvcContext.Current.UserPassport.Profile;
            string avatarUrl = ImageHelper.SaveAvatar(profile.PassportId, entity.AvatarStream);
            if(false == string.IsNullOrEmpty(avatarUrl))
            {
                profile.Avatar = avatarUrl + "?t=" + DateTime.Now.ToString("yyMMddHHmmssfff");
                var isSave = profile.Save();
                if(isSave)
                {
                    return string.Format("{0}{1}", AppEnvironment.ResourcesSiteRoot, profile.Avatar);
                }                
            }

            return null;
        }

        [HttpPost]
        public bool ChangePassword([FromBody]AccountSign entity)
        {
            if (entity == null || string.IsNullOrEmpty(entity.Password)) return false;

            var isChanged = MemberShip.ChangePassword(MvcContext.Current.PassportId, entity.Password);
            return isChanged;
        }
    }
}
