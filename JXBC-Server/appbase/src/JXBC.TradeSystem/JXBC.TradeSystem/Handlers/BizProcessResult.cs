using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class BizProcessResult
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizId"></param>
        /// <returns></returns>
        public static BizProcessResult CreateSuccessResult(string bizId)
        {
            return new BizProcessResult()
            {
                Success = true,
                BizId = bizId
            };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="errorCode"></param>
        /// <param name="errorMessage"></param>
        /// <returns></returns>
        public static BizProcessResult CreateErrorResult(string errorCode, string errorMessage)
        {
            return new BizProcessResult()
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
        public string BizId { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public string ErrorCode { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public string ErrorMessage { get; set; }

        #endregion //Instance Properties
    }
}
