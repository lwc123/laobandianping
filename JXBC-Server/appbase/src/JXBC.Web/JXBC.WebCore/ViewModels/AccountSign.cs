using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class AccountSign
    {
        /// <summary>
        /// 
        /// </summary>
        public string MobilePhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// 短信验证码
        /// </summary>
        public string ValidationCode { get; set; }
        /// <summary>
        /// 注册邀请码
        /// </summary>
        public string InviteCode { get; set; }

        /// <summary>
        /// 注册时选择的身份
        /// </summary>
        public ProfileType SelectedProfileType { get; set; }

        /// <summary>
        /// 
        /// </summary>

        public AdditionalAction AdditionalAction { get; set; }
    }
}