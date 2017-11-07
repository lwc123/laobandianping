using System;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class AccountSignResult
    {
        /// <summary>
        /// 
        /// </summary>
        public SignStatus SignStatus { get; set; }

        /// <summary>
        /// 是否注册新账号
        /// </summary>
        public bool CreatedNewPassport { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string ErrorMessage { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public AccountEntity Account { get; set; }

        /// <summary>
        /// 后继行为
        /// </summary>
        public AdditionalAction AdditionalAction { get; set; }
    }
}