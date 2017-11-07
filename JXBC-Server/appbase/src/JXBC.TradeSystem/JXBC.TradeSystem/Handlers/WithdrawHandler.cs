using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class WithdrawHandler : WebProxyHandler
    {
        /// <summary>
        /// 
        /// </summary>
        public override string TargetBizSource
        {
            get { return BizSources.Withdraw; }
            set { }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public override bool Preprocess(Payment paymentParams)
        {
            var walletType = WalletType.Privateness;

            if (paymentParams.TradeType == TradeType.OrganizationToOrganization || paymentParams.TradeType == TradeType.PersonalToOrganization)
                walletType = WalletType.Organization;
            var wallet = Wallet.FindByOwnerId(walletType, paymentParams.OwnerId);
            if (null == wallet || wallet.CanWithdrawBalance < Math.Abs(paymentParams.TotalFee))
                return false;

            paymentParams.AssertNotNull("paymentParams");
            paymentParams.SellerId = -1;
            return base.Preprocess(paymentParams);
        }
    }
}
