using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public class MessageResult
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <param name="bizModel"></param>
        /// <returns></returns>
        public static MessageResult SuccessResult(string bizType = null, string bizId = null, string bizModel = null)
        {
            return new MessageResult()
            {
                Success = true,
                BizType = bizType,
                BizId = bizId,
                BizModel = bizModel
            };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="errorCode"></param>
        /// <param name="errorMessage"></param>
        /// <returns></returns>
        public static MessageResult FailedResult(string errorCode = null, string errorMessage = null)
        {
            return new MessageResult()
            {
                Success = false,
                ErrorCode = errorCode,
                ErrorMessage = errorMessage
            };
        }

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string ErrorCode { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string ErrorMessage { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BizType { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BizId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BizModel { get; set; }

        #endregion //Instance Properties
    }
}
