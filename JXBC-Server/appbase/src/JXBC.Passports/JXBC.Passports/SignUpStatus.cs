using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public enum SignStatus
    {
        /// <summary>
        /// 
        /// </summary>
        None,

        /// <summary>
        /// 
        /// </summary>
        Success = 1,

        /// <summary>
        /// 
        /// </summary>
        InvalidValidationCode = 2,

        /// <summary>
        /// 
        /// </summary>
        Failed = 9,

        /// <summary>
        /// 
        /// </summary>
        Error = 99,

        /// <summary>
        /// 
        /// </summary>
        InvalidEmail = 101,

        /// <summary>
        /// 
        /// </summary>
        InvalidMobilePhone = 102,

        /// <summary>
        /// 
        /// </summary>
        InvalidUserName = 103,

        /// <summary>
        /// 
        /// </summary>
        InvalidPassword = 109,

        /// <summary>
        /// 
        /// </summary>
        DuplicateEmail = 201,

        /// <summary>
        /// 
        /// </summary>
        DuplicateMobilePhone = 202,

        /// <summary>
        /// 
        /// </summary>
        DuplicateUserName = 203,

        /// <summary>
        /// 
        /// </summary>
        DuplicateEntName = 204,

        /// <summary>
        /// 
        /// </summary>
        UserRejected = 999
    }
}