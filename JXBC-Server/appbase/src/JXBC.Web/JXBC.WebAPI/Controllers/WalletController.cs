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
    public class WalletController : AuthenticatedApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="tradeCode"></param>
        /// <returns></returns>
        [HttpPost]
        public PaymentResult Pay(long ownerId = 0, string tradeCode = null)
        {
            if (ownerId < 1 && string.IsNullOrEmpty(tradeCode))
                this.ReturnPreconditionFailedMessage();

            var paymentResult = Wallet.Pay(ownerId, tradeCode);
            return paymentResult;
        }
    }
}