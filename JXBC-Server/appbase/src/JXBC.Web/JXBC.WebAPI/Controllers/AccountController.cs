using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using JXBC.Passports;
using JXBC.WebCore;
using JXBC.WebCore.Mvc;
using JXBC.WebCore.ViewModels;
using JXBC.Workplace;
using JXBC.Passports.Security;
using M2SA.AppGenome.Logging;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class AccountController : ApiController
    {
        private void WriteTokenToBrowser(AccountSignResult signResult)
        {
            if (null == signResult || signResult.SignStatus != SignStatus.Success)
                return;

            if (null != this.Request.Headers.UserAgent)
            {
                if(signResult.Account.PassportId > 0)
                    CookieHelper.SetCookie(AccountAuthentication.TokenKey, signResult.Account.Token.AccessToken);
                else 
                    CookieHelper.SetCookie(AccountAuthentication.TokenKey, signResult.Account.Token.AccessToken, DateTime.MaxValue);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        [HttpPost]
        public AccountSignResult CreateNew(ClientDevice entity)
        {
            var result = new AccountSignResult();
            result.SignStatus = SignStatus.None;

            if (null == entity
                || string.IsNullOrEmpty(entity.DeviceKey)
                || string.IsNullOrEmpty(entity.Product)
                || string.IsNullOrEmpty(entity.Brand))
            {
                this.ReturnPreconditionFailedMessage();
            }

            var account = AccountAuthentication.CreateNew(entity);
            if(null != account)
            {
                result.SignStatus = SignStatus.Success;
                result.Account = new AccountEntity(account, null);

                WriteTokenToBrowser(result);
            }
            else
            {
                result.SignStatus = SignStatus.Error;
            }
                
            return result;
        }

        /// <summary>
        /// 账户注册
        /// </summary>
        /// <param name="entity">必填项：MobilePhone;ValidationCode;EntName;LegalRepresentative;</param>
        /// <returns></returns>
        [HttpPost]
        public AccountSignResult SignUp(AccountSign entity)
        {
            if (null == entity || string.IsNullOrEmpty(entity.MobilePhone) || string.IsNullOrEmpty(entity.Password)
                || string.IsNullOrEmpty(entity.ValidationCode) || ProfileType.None == entity.SelectedProfileType) this.ReturnPreconditionFailedMessage();
            var account = MvcContext.Current.ClientAccount;
            if (null == account) this.ReturnPreconditionFailedMessage();

            var isValid = MessageHelper.CheckSMSValidationCode(entity.MobilePhone, entity.ValidationCode);
            if (MvcContext.Current.Test && entity.ValidationCode == AppEnvironment.TestValidationCode) isValid = true;
            if (false == isValid)
            {
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.InvalidValidationCode,
                    ErrorMessage = "验证码无效，请重新获取"
                };
            }
            if (!string.IsNullOrEmpty(entity.InviteCode))
            {
                System.Web.HttpContext.Current.Items.Add(WorkplaceApplication.InviteCodeKey, entity.InviteCode);
            }
            
            var signStatus = SignStatus.Error;

            var signedUpInfo = new SignedUpInfo()
            {
                InviteCode = entity.InviteCode,
                SignedUpIp = this.Request.GetClientIP(),
                HttpUserAgent = this.Request.GetUserAgent(),
                HttpReferer = null == this.Request.Headers.Referrer ? "" : this.Request.Headers.Referrer.ToString()
            };
            var userPassport = AccountAuthentication.SignUp(entity.MobilePhone, entity.Password, entity.SelectedProfileType, signedUpInfo, out signStatus);

            var result = new AccountSignResult();
            result.SignStatus = signStatus;
            if (result.SignStatus == SignStatus.Success)
            {
                result.CreatedNewPassport = true;
                result.Account = new AccountEntity(account, userPassport);
                result.AdditionalAction = ProcessAdditionalAction(entity.AdditionalAction);

                WriteTokenToBrowser(result);
            }
            else
            {
                if (result.SignStatus == SignStatus.DuplicateMobilePhone)
                    result.ErrorMessage = "手机号已经注册";
                else
                    result.ErrorMessage = "注册失败";
            }

            return result;
        }

        [HttpPost]
        public AccountSignResult SignIn(AccountSign entity)
        {
            if (null == entity || string.IsNullOrEmpty(entity.MobilePhone) || string.IsNullOrEmpty(entity.Password)) return null;
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return null;

            if (!string.IsNullOrEmpty(entity.InviteCode))
            {
                System.Web.HttpContext.Current.Items.Add(WorkplaceApplication.InviteCodeKey, entity.InviteCode);
            }
            UserPassport userPassport = null;
            var isSignIn = AccountAuthentication.SignIn(entity.MobilePhone, entity.Password, new SignedInLog(), out userPassport);

            var result = new AccountSignResult();
            result.SignStatus = isSignIn ? SignStatus.Success : SignStatus.InvalidPassword;
            if (result.SignStatus == SignStatus.Success)
            {
                result.Account = new AccountEntity(account, userPassport);
                result.AdditionalAction = ProcessAdditionalAction(entity.AdditionalAction);

                WriteTokenToBrowser(result);
            }
            else
            {
                result.ErrorMessage = "用户名或密码错误";
            }
            return result;
        }

        [HttpPost]
        public AccountSignResult ShortcutSignIn(AccountSign entity)
        {
            if (null == entity || string.IsNullOrEmpty(entity.MobilePhone) || string.IsNullOrEmpty(entity.ValidationCode))
                return null;
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return null;

            var passportId = UserPassport.FindIdByMobilePhone(entity.MobilePhone);
            if(passportId == 0)
            {
                entity.Password = HashHelper.ComputeHash(entity.MobilePhone, HashAlgorithmName.SHA1).Substring(0, 6);
                return SignUp(entity);
            }

            var isValid = MessageHelper.CheckSMSValidationCode(entity.MobilePhone, entity.ValidationCode);
            if (MvcContext.Current.Test && entity.ValidationCode == AppEnvironment.TestValidationCode) isValid = true;
            if (false == isValid)
            {
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.InvalidValidationCode,
                    ErrorMessage = "验证码无效，请重新获取"
                };
            }
            if (!string.IsNullOrEmpty(entity.InviteCode))
            {
                System.Web.HttpContext.Current.Items.Add(WorkplaceApplication.InviteCodeKey, entity.InviteCode);
            }
            UserPassport userPassport = null;
            var isSignIn = AccountAuthentication.SignIn(passportId, new SignedInLog(), out userPassport);

            var result = new AccountSignResult();
            result.SignStatus = isSignIn ? SignStatus.Success : SignStatus.InvalidPassword;
            if (result.SignStatus == SignStatus.Success)
            {
                result.Account = new AccountEntity(account, userPassport);
                result.AdditionalAction = ProcessAdditionalAction(entity.AdditionalAction);

                WriteTokenToBrowser(result);
            }
            else
            {
                result.ErrorMessage = "用户名或密码错误";
            }
            return result;
        }

        [HttpPost]
        public AccountSignResult BindThirdPassport(ThirdPassport entity)
        {
            if (null == entity || string.IsNullOrEmpty(entity.Platform) || string.IsNullOrEmpty(entity.PlatformPassportId)) return null;
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return null;

            var signStatus = SignStatus.Error;
            UserPassport userPassport = AccountAuthentication.BindThirdPassport(entity, out signStatus);

            var result = new AccountSignResult();
            result.SignStatus = signStatus;
            if (result.SignStatus == SignStatus.Success)
            {
                result.Account = new AccountEntity(account, userPassport);
                WriteTokenToBrowser(result);
            }
            else
            {
                result.ErrorMessage = "绑定账号失败";
            }
            return result;
        }

        [HttpPost]
        public AccountSignResult SignInByToken()
        {
            if (false == MvcContext.Current.IsAuthenticated)
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.Failed,
                    ErrorMessage = "认证信息已失效，请重新登录"
                };

            var account = new AccountEntity(MvcContext.Current.ClientAccount, MvcContext.Current.UserPassport);

            return new AccountSignResult()
            {
                SignStatus = SignStatus.Success,
                Account = account
            };
        }

        [HttpPost]
        public bool SignOut()
        {
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return false;

            return true;
        }

        [HttpPost]
        public AccountSignResult ResetPassword(AccountSign entity)
        {
            if (null == entity || string.IsNullOrEmpty(entity.MobilePhone)
                || string.IsNullOrEmpty(entity.Password) || string.IsNullOrEmpty(entity.ValidationCode)) return null;
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return null;

            var isValid = MessageHelper.CheckSMSValidationCode(entity.MobilePhone, entity.ValidationCode);
            if (MvcContext.Current.Test && entity.ValidationCode == AppEnvironment.TestValidationCode) isValid = true;
            if (false == isValid)
            {
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.InvalidValidationCode,
                    ErrorMessage = "验证码无效，请重新获取"
                };
            }

            var passportId = UserPassport.FindIdByMobilePhone(entity.MobilePhone);
            if (passportId < 1)
            {
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.InvalidMobilePhone,
                    ErrorMessage = "手机号未注册"
                };
            }

            var isChanged = MemberShip.ChangePassword(passportId, entity.Password);
            if (isChanged)
            {
                return new AccountSignResult()
                {
                    SignStatus = SignStatus.Success
                };
            }
            return new AccountSignResult()
            {
                SignStatus = SignStatus.Failed
            };
        }

        [HttpPost]
        public bool SendValidationCode(string phone)
        {
            if (string.IsNullOrEmpty(phone)) return false;
            var account = MvcContext.Current.ClientAccount;
            if (null == account) return false;

            var result = MessageHelper.SendSMSValidationCode(account, this.Request.GetClientIP(), phone);
            return result.Success;
        }

        [HttpGet]
        public bool CheckValidationCode(string phone, string code)
        {
            var isValid = MessageHelper.CheckSMSValidationCode(phone, code);
            if (MvcContext.Current.Test && code == AppEnvironment.TestValidationCode) isValid = true;
            return isValid;
        }

        [HttpGet]
        public bool ExistsMobilePhone(string phone)
        {
            if (string.IsNullOrEmpty(phone)) return false;
            var passportId = UserPassport.FindIdByMobilePhone(phone);
            return passportId > 0;
        }


        private AdditionalAction ProcessAdditionalAction(AdditionalAction action)
        {
            //Todo: ProcessAdditionalAction
            return action;
        }
    }
}
