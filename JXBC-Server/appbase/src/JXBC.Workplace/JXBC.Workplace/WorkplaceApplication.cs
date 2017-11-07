using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.AppHub;
using JXBC.Passports;
using M2SA.AppGenome.Logging;
using System.Web;

namespace JXBC.Workplace
{
    public class WorkplaceApplication : IExtensionApplication
    {
        public static readonly string InviteCodeKey = "InviteCode";
        public bool AsyncStart
        {
            get{ return false; }
        }

        public void OnInit(ApplicationHost onwer, CommandArguments args)
        {
            //empty action
        }

        public void OnStart(ApplicationHost onwer, CommandArguments args)
        {
            MemberShip.RegisterSignUpListener(this.MemberShip_OnSignUp);
            MemberShip.RegisterSignInListener(this.MemberShip_OnSignIn);
        }

        public void OnStop(ApplicationHost onwer, CommandArguments args)
        {
            //empty action
        }
         
        private void MemberShip_OnSignUp(UserPassport passport)
        {
            var phoneDic = BizDictionary.GetSimpleDictionary(BizDictionary.Listeners_SignUp);
            if (null != phoneDic && phoneDic.Count > 0)
            {
                var phones = string.Join(",", phoneDic.Keys.ToArray());
                var content = string.Format("{0}用户 {1} 刚刚注册，请及时联系用户"
                    , passport.ProfileType == ProfileType.OrganizationProfile ? "企业" : "个人", passport.MobilePhone);
                MessageHelper.SendSMS("SendNotify", 0, phones, content);
            }

            this.AddInvitedRelationship(passport);
        }

        private void MemberShip_OnSignIn(UserPassport passport)
        {
            this.AddInvitedRelationship(passport);
        }

        private void AddInvitedRelationship(UserPassport passport)
        {
            if (null == HttpContext.Current) return;
            var inviteCode = HttpContext.Current.Request[InviteCodeKey];
            if (string.IsNullOrEmpty(inviteCode) && HttpContext.Current.Items.Contains(InviteCodeKey))
            {
                inviteCode = HttpContext.Current.Items[InviteCodeKey].ToString();
            }
            if (string.IsNullOrEmpty(inviteCode)) return;

            var relationship = new InvitedRelationship();
            relationship.PassportId = passport.PassportId;
            relationship.InviteCode = inviteCode;
            relationship.Save();
        }
    }
}
