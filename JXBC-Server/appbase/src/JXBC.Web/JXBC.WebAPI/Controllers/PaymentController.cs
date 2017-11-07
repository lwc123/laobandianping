using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http;
using M2SA.AppGenome;
using JXBC.TradeSystem;
using JXBC.WebCore;
using JXBC.WebCore.Mvc;
using JXBC.WebCore.ViewModels;
using M2SA.AppGenome.Cache;
using JXBC.Passports.Security;
using M2SA.AppGenome.Logging;
using JXBC.TradeSystem.Providers;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class PaymentController : AuthenticatedApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public AppleIAPProvider.Product GetIAPProduct(string bizSource)
        {            
            var iapProvider = (AppleIAPProvider)ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentProviders[PayWays.AppleIAP];
            return iapProvider.GetProductJson(bizSource);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="os"></param>
        /// <param name="bizSource"></param>
        /// <param name="payWays"></param>
        /// <returns></returns>
        [HttpGet]
        public string[] GetPayWays(string os, string bizSource, string payWays = null)
        {
            if(false == string.IsNullOrEmpty(payWays))
            {
                return payWays.Split(',');
            }

            return ObjectIOCFactory.GetSingleton<PaymentEngine>().GetPayWays(os, bizSource);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult CreateTrade([FromBody]Payment payment)
        {
            payment.AssertNotNull("payment");
            if (string.IsNullOrEmpty(payment.BizSource)) throw new ArgumentNullException("payment:BizSource");
            if (string.IsNullOrEmpty(payment.CommoditySubject)) throw new ArgumentNullException("payment:CommoditySubject");

            if (payment.OwnerId == 0 && (payment.TradeType == TradeType.OrganizationToPersonal || payment.TradeType == TradeType.OrganizationToOrganization))
                throw new ArgumentOutOfRangeException("payment:OwnerId", string.Format("Not support OwnerId is 0 from OrganizationTo*** trade.", payment.TradeMode));

            if (string.IsNullOrEmpty(payment.PayRoute))
                payment.PayRoute = PayWays.Route_APP;

            payment.BuyerId = MvcContext.Current.PassportId;
            if (payment.TradeType == TradeType.PersonalToPersonal || payment.TradeType == TradeType.PersonalToOrganization)
            {
                payment.OwnerId = payment.BuyerId;
            }
            payment.ClientIP = "8.8.8.8";
            try
            {
                var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
                var signed = paymentEngine.CreateTrade(payment);
                if (signed)
                {
                    return new PaymentResult() { Success = true, TradeCode = payment.TradeCode, SignedParams = payment.SignedParams };
                }
                else
                {
                    return new PaymentResult() { Success = false, ErrorMessage = "Create sign failed." };
                }
            }
            catch (ArgumentOutOfRangeException ex)
            {
                this.ReturnPreconditionFailedMessage(ex.Message);
                return null;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult PaymentCompleted([FromBody]PaymentResult paymentResult)
        {
            if (null == paymentResult || string.IsNullOrEmpty(paymentResult.TradeCode))
            {
                this.ReturnPreconditionFailedMessage();
                return null;
            }

            LogManager.GetLogger().Info("==>paymentResult[PaymentCompleted]: {0}", TradeSystem.JsonExtension.ToJson(paymentResult));

            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(paymentResult.TradeCode, paymentResult.PayWay, null, paymentResult.PaidDetail);
            if (null != tradeJournal)
                return new PaymentResult() { Success = true, TradeCode= tradeJournal.TradeCode, TargetBizTradeCode = tradeJournal.TargetBizTradeCode};
            else
                return new PaymentResult() { Success = false, ErrorMessage = "Paid failed." };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeCode"></param>
        /// <returns></returns>
        [HttpGet]
        public PaymentResult QueryTrade(string tradeCode)
        {
            if (string.IsNullOrEmpty(tradeCode))
                return null;

            return ObjectIOCFactory.GetSingleton<PaymentEngine>().QueryTrade(tradeCode);
        }
    }
}