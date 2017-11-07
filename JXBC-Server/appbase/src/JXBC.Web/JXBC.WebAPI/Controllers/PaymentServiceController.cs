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

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class PaymentServiceController : MicroServiceController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult SystemGift([FromBody]Payment payment)
        {
            payment.AssertNotNull("payment");

            if (payment.OwnerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support OwnerId is 0.");
            if (payment.BuyerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support BuyerId is 0.");

            payment.PayWay = PayWays.System;
            payment.TradeMode = TradeMode.Payoff;            

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var tradeJournal = paymentEngine.SystemGift(payment);
            if (null != tradeJournal)
            {
                return new PaymentResult() { Success = true, TradeCode = tradeJournal.TradeCode };
            }
            else
            {
                return new PaymentResult() { Success = false, ErrorMessage = "SystemGift failed." };
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult Withdraw([FromBody]Payment payment)
        {
            payment.AssertNotNull("payment");

            if (payment.OwnerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support OwnerId is 0.");
            if (payment.BuyerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support BuyerId is 0.");

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var tradeJournal = paymentEngine.Withdraw(payment);
            if (null != tradeJournal)
            {
                return new PaymentResult() { Success = true, TradeCode = tradeJournal.TradeCode };
            }
            else
            {
                return new PaymentResult() { Success = false, ErrorMessage = "Withdraw failed." };
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult Refund([FromBody]Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.BizSource.AssertNotNull("payment:BizSource");
            payment.ParentTradeCode.AssertNotNull("payment:ParentTradeCode");

            if (payment.OwnerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support OwnerId is 0.");

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var tradeJournal = paymentEngine.Refund(payment);
            if (null != tradeJournal)
            {
                return new PaymentResult() { Success = true, TradeCode = tradeJournal.TradeCode };
            }
            else
            {
                return new PaymentResult() { Success = false, ErrorMessage = "Refund failed." };
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public PaymentResult ShareIncome([FromBody]Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.BizSource.AssertNotNull("payment:BizSource");
            payment.ParentTradeCode.AssertNotNull("payment:ParentTradeCode");

            if (payment.OwnerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support OwnerId is 0.");

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var tradeJournal = paymentEngine.ShareIncome(payment);
            if (null != tradeJournal)
            {
                return new PaymentResult() { Success = true, TradeCode = payment.TradeCode };
            }
            else
            {
                return new PaymentResult() { Success = false, ErrorMessage = "ShareIncome failed." };
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult OfflinePay([FromBody]PaymentResult paymentResult)
        {
            paymentResult.AssertNotNull("paymentResult");

            if (paymentResult.BuyerId < 0)
                throw new ArgumentOutOfRangeException("payment:BuyerId", "Not support BuyerId is 0.");

            var paymentEngine = ObjectIOCFactory.GetSingleton<PaymentEngine>();
            var tradeJournal = paymentEngine.OfflinePay(paymentResult);
            if (null != tradeJournal)
            {
                return new PaymentResult() { Success = true, TradeCode = tradeJournal.TradeCode };
            }
            else
            {
                return new PaymentResult() { Success = false, ErrorMessage = "OfflinePay failed." };
            }
        }
    }
}