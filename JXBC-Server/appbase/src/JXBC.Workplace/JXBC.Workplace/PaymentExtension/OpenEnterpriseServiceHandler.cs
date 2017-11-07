using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;
using JXBC.TradeSystem.Handlers;
using JXBC.Passports;

namespace JXBC.Workplace.PaymentExtension
{
    /// <summary>
    /// 
    /// </summary>
    public class OpenEnterpriseServiceHandler : WebProxyHandler
    { 
        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public override bool Preprocess(Payment paymentParams)
        {
            paymentParams.AssertNotNull("paymentParams");
            paymentParams.CommodityExtension.AssertNotNull("tradeJournal.CommodityExtension");

            var requestInfo = paymentParams.CommodityExtension.ConvertEntity<OpenEnterpriseRequest>();
            if (null == requestInfo || string.IsNullOrEmpty(requestInfo.CompanyName) || string.IsNullOrEmpty(requestInfo.RealName) || string.IsNullOrEmpty(requestInfo.JobTitle))
                return false;

            paymentParams.SellerId = 0;

            return base.Preprocess(paymentParams);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        public override BizProcessResult BizProcess(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            tradeJournal.CommodityExtension.AssertNotNull("tradeJournal.CommodityExtension");

            var requestInfo = tradeJournal.CommodityExtension.ConvertEntity<OpenEnterpriseRequest>();
            if (null == requestInfo || string.IsNullOrEmpty(requestInfo.CompanyName) || string.IsNullOrEmpty(requestInfo.RealName) || string.IsNullOrEmpty(requestInfo.JobTitle))
                return BizProcessResult.CreateErrorResult(this.GetType().Name, "Check OpenEnterpriseRequest failed.");

            var userPassport = UserPassport.FindById(tradeJournal.BuyerId);
            if (null == userPassport) return BizProcessResult.CreateErrorResult(this.GetType().Name, "Not find the passport.");

            var bizProcessResult = base.BizProcess(tradeJournal);
            if (bizProcessResult.Success)
            {
                userPassport.Profile.RealName = requestInfo.RealName;
                userPassport.Profile.CurrentCompany = requestInfo.CompanyName;
                userPassport.Profile.CurrentJobTitle = requestInfo.JobTitle;
                userPassport.Profile.Save();

                var phoneDic = BizDictionary.GetSimpleDictionary(BizDictionary.Listeners_OpenEnterpriseService);
                if (null != phoneDic && phoneDic.Count > 0)
                {
                    var phones = string.Join(",", phoneDic.Keys.ToArray());
                    var content = string.Format("公司[{0}]({1}){2}-{3} 刚刚开通了企业服务，请及时联系企业"
                        , requestInfo.CompanyName, userPassport.MobilePhone, requestInfo.RealName, requestInfo.JobTitle);
                    MessageHelper.SendSMS("SendNotify", 0, phones, content);
                }
            }

            return bizProcessResult;
        }
    }
}
