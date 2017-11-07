using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;
using JXBC.TradeSystem.Handlers;

namespace JXBC.Workplace.PaymentExtension
{
    /// <summary>
    /// 
    /// </summary>
    public class BuyMemberServiceHandler : IPaymentHandler
    {
        /// <summary>
        /// 
        /// </summary>
        public string TargetBizSource
        {
            get { return PaymentSources.BuyMemberService; }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public bool Preprocess(Payment paymentParams)
        {
            paymentParams.AssertNotNull("paymentParams");
            paymentParams.SellerId = 0;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        public bool BizProcess(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");

            if (tradeJournal.OwnerId == tradeJournal.BuyerId)
            {
                return AddServiceContract(tradeJournal);
            }

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        private static bool AddServiceContract(TradeJournal tradeJournal)
        {
            var contract = new ServiceContract();
            contract.BuyerId = tradeJournal.BuyerId;
            contract.ContractStatus = ContractStatus.Paid;
            contract.TotalFee = Math.Abs(tradeJournal.TotalFee);
            contract.ServiceBeginTime = DateTime.Now;
            contract.ServiceEndTime = contract.ServiceBeginTime.Date.AddDays(1).AddYears(tradeJournal.CommodityQuantity);
            contract.PaidWay = tradeJournal.PaidWay;
            contract.TradeCode = tradeJournal.TradeCode;

            var saved = ServiceContract.AddServiceContract(contract);
            if (saved)
            {
                tradeJournal.UpdateBizTradeCode(contract.ContractCode);
            }

            return true;
        }
    }
}
