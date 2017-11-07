using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class DepositHandler : IPaymentHandler
    {
        /// <summary>
        /// 
        /// </summary>
        public string TargetBizSource
        {
            get { return BizSources.Deposit; }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public bool Preprocess(Payment paymentParams)
        {
            paymentParams.AssertNotNull("paymentParams");
            paymentParams.SellerId = -1;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        public BizProcessResult BizProcess(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            var walletType = WalletType.Privateness;
            if (tradeJournal.TradeType == TradeType.PersonalToOrganization || tradeJournal.TradeType == TradeType.OrganizationToOrganization)
                walletType = WalletType.Organization;

            var paymentResult = Wallet.AddBalance(walletType, tradeJournal.OwnerId, tradeJournal.TradeCode);
            if(null != paymentResult && paymentResult.Success)
                return BizProcessResult.CreateSuccessResult("");
            else
                return BizProcessResult.CreateErrorResult(this.GetType().Name, "[Wallet.AddBalance] fail.");
        }                
    }
}
