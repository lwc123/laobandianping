using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using JXBC.Passports;
using JXBC.TradeSystem;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using M2SA.AppGenome.Data;

namespace JXBC.WebAPI.Controllers
{
    [Authorize]
    public class ConsultantController : AuthenticatedApiController
    {
        [HttpGet]
        public ConsultantPageEntity Page(long id)
        {
            var userPassport = UserPassport.FindById(id);
            if (null == userPassport) return null;

            var entity = new ConsultantPageEntity();
            entity.Profile = (OrganizationProfile)userPassport.Profile.FormatEntity();
            return entity;
        }

        [HttpGet]
        public ConsultantSummary Summary()
        {
            var userWallet = Wallet.FindByOwnerId(WalletType.Privateness, MvcContext.Current.PassportId);
            

            var entity = new ConsultantSummary();
            entity.Profile = (OrganizationProfile)MvcContext.Current.UserPassport.Profile;
            entity.WalletBalance = null == userWallet ? 0 : userWallet.AvailableBalance;

            return entity;
        }

        [HttpPost]
        public AccountEntity OpenOrganizationService([FromBody]OrganizationProfile entity)
        {
            var passport = MvcContext.Current.UserPassport;
            if (null == entity)
            {
                entity = new OrganizationProfile();
                entity.PassportId = passport.PassportId;
                entity.RealName = passport.Profile.Nickname;
            }
            var success = MemberShip.OpenOrganizationService(passport, entity);

            AccountEntity result = null;
            if (success)
            {                
                AccountAuthentication.SyncIMAccount(passport);
                result = new AccountEntity(MvcContext.Current.ClientAccount, passport);
            }

            return result;
        }

        [HttpPost]
        public AccountEntity ChangeToConsultant()
        {
            var passport = MvcContext.Current.UserPassport;
            AccountEntity result = null;
            if (passport.Profile is OrganizationProfile)
            {
                var profile = (passport.Profile as OrganizationProfile);
                profile.CurrentProfileType = ProfileType.OrganizationProfile;
                var saved = profile.Save();
                if (saved)
                {
                    AccountAuthentication.SyncIMAccount(passport);
                    result = new AccountEntity(MvcContext.Current.ClientAccount, passport);
                }

            }
            return result;
        }

        [HttpPost]
        public AccountEntity ChangeToUser()
        {
            var passport = MvcContext.Current.UserPassport;
            AccountEntity result = null;
            if (passport.Profile is OrganizationProfile)
            {
                var profile = (passport.Profile as OrganizationProfile);
                profile.CurrentProfileType = ProfileType.UserProfile;
                var saved = profile.Save();
                if (saved)
                {
                    AccountAuthentication.SyncIMAccount(passport);
                    result = new AccountEntity(MvcContext.Current.ClientAccount, passport);
                }
            }
            return result;
        }

        [HttpPost]
        public string ChangeAvatar([FromBody]AvatarEntity entity)
        {
            if (entity == null || string.IsNullOrEmpty(entity.AvatarStream)) return null;

            var profile = MvcContext.Current.UserPassport.Profile;
            string avatarUrl = ImageHelper.SaveAvatar(profile.PassportId, entity.AvatarStream);
            if (false == string.IsNullOrEmpty(avatarUrl))
            {
                profile.Avatar = avatarUrl + "?t=" + DateTime.Now.ToString("yyMMddHHmmssfff");
                var isSave = profile.Save();
                if (isSave)
                {
                    return ImageHelper.ToAbsoluteUri(avatarUrl);
                }
            }

            return null;
        }

        [HttpPost]
        public bool ChangeProfile([FromBody]OrganizationProfile entity)
        {
            if (entity == null) return false;
            var profile = (OrganizationProfile)MvcContext.Current.UserPassport.Profile;
            var syncIMAccount = false == string.IsNullOrEmpty(entity.RealName) && profile.RealName != entity.RealName;
            profile.FillPropertiesFromEntity(entity, true);
            profile.PassportId = MvcContext.Current.PassportId;

            var saved = profile.Save();
            if(saved && syncIMAccount)
            {
                AccountAuthentication.SyncIMAccount(MvcContext.Current.UserPassport);
            }
            return saved;
        }
    }
}  