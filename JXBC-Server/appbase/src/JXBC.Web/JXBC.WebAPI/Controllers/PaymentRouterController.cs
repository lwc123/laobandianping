using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using JXBC.WebCore.ViewModels;
using M2SA.AppGenome;
using JXBC.TradeSystem;
using JXBC.WebCore;
using JXBC.WebCore.Mvc;
using JXBC.TradeSystem.Providers;
using M2SA.AppGenome.Logging;
using System.IO;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class PaymentRouterController : Controller
    {
        #region Alipay Processor

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public ActionResult AlipayH5Pay()
        {
            var tradeCode = this.Request.QueryString.Get("code");
            if (string.IsNullOrEmpty(tradeCode))
                return Content("failed");

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var payment = paymentEngine.GetSignedPaymentFromCache(tradeCode);
            if (null == payment)
                return Content("Pay failed! err:0.");

            if (null != payment && payment.PayWay == PayWays.Alipay)
            {
                return View(payment);
            }

            return Content("Pay failed! err:1.");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AlipayPaidRedirect()
        {
            var tradeCode = this.Request.QueryString.Get("out_trade_no"); 
            var paidWay = PayWays.Alipay;
            var paymentDetail = this.Request.Url.Query;
            if (null == paymentDetail || false == paymentDetail.StartsWith("?"))
                return Content("failed");

            paymentDetail = paymentDetail.Substring(1);
            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(tradeCode, paidWay, null, paymentDetail);
            if (null != tradeJournal)
            {
                if (false == string.IsNullOrEmpty(tradeJournal.ReturnUrl))
                    return this.Redirect(string.Format("{0}{1}out_trade_no={2}", tradeJournal.ReturnUrl, tradeJournal.ReturnUrl.Contains("?") ? "&" : "?", tradeCode));
                else
                    return Content("success");
            }
            return Content("failed");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult AlipayPaidCallback()
        {
            var tradeCode = this.Request.QueryString.Get("out_trade_no");
            var paymentDetail = string.Empty;
            using (var reader = new StreamReader(this.Request.InputStream))
            {
                paymentDetail = reader.ReadToEnd(); 
            }
            if(false == string.IsNullOrEmpty(paymentDetail))
            {
                var postParamCollection = HttpUtility.ParseQueryString(paymentDetail);
                if (postParamCollection.AllKeys.ToList().Contains("out_trade_no"))
                    tradeCode = postParamCollection["out_trade_no"];
            }

            LogManager.GetLogger().Info("==>AlipayPaidCallback-0: {0}", paymentDetail);

            var paidWay = PayWays.Alipay;
            if (string.IsNullOrEmpty(paymentDetail) || string.IsNullOrEmpty(tradeCode))
                return Content("failed");            
            
            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(tradeCode, paidWay, null, paymentDetail);
            var result  = (null != tradeJournal) ? "success" : "failed";

            LogManager.GetLogger().Info("==>AlipayPaidCallback-1: {0}", result);
            return Content(result);
        }

        #endregion //Alipay Processor

        #region Wechat Processor

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult WechatH5Pay()
        {
            var authCode = this.Request.QueryString.Get("code");
            var tradeCode = this.Request.QueryString.Get("out_trade_no");
            if (string.IsNullOrEmpty(authCode) || string.IsNullOrEmpty(tradeCode))
                return Content("failed");

            var wechatProvider = (WechatProvider)ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentProviders[PayWays.Wechat];
            var signedParams = wechatProvider.GenerateH5SignedParams(authCode, tradeCode);
            if (false == string.IsNullOrEmpty(signedParams))
            {
                ViewBag.SignedParams = signedParams;
                ViewBag.TradeCode = tradeCode;
                return View();
            }
            return Content("Pay failed!");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult WechatPaidRedirect()
        {
            var tradeCode = this.Request.QueryString.Get("out_trade_no");
            if (string.IsNullOrEmpty(tradeCode))
                return Content("failed");

            var wechatProvider = (WechatProvider)ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentProviders[PayWays.Wechat];

            var paymentDetail = new Dictionary<string, string>();
            paymentDetail["out_trade_no"] = tradeCode;
            var xml = WechatProvider.ToXmlParams(paymentDetail);

            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(tradeCode, PayWays.Wechat, null, xml);
            if (null != tradeJournal)
            {
                if (false == string.IsNullOrEmpty(tradeJournal.ReturnUrl))
                    return this.Redirect(string.Format("{0}{1}out_trade_no={2}", tradeJournal.ReturnUrl, tradeJournal.ReturnUrl.Contains("?") ? "&" : "?", tradeCode));
                else
                    return Content("success");
            }
            return Content("failed");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult WechatPaidCallback()
        {
            var xml = string.Empty;
            using (var reader = new StreamReader(this.Request.InputStream))
            {
                xml = reader.ReadToEnd(); 
            }
            if(string.IsNullOrEmpty(xml))
                return Content(WechatProvider.FailCallbackResult);

            LogManager.GetLogger().Info("==>WechatPaidCallback-0: {0}", xml);

            var paidWay = PayWays.Wechat;
            var paymentDetail = WechatProvider.ToDictionary(xml);
            if (null== paymentDetail || false == paymentDetail.ContainsKey("out_trade_no"))
                return Content(WechatProvider.FailCallbackResult);

            var tradeCode = paymentDetail["out_trade_no"];
            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(tradeCode, paidWay, null, xml);
            var result = (null != tradeJournal) ? WechatProvider.SuccessCallbackResult : WechatProvider.FailCallbackResult;

            LogManager.GetLogger().Info("==>WechatPaidCallback-1: {0}", result);
            return Content(result);
        }

        #endregion //Wechat Processor
    }
}