using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;
using JXL.TradeSystem.Handlers;

namespace JXL.TradeSystem.Tests.Mocks
{
    public class MockPaymentNotify : IPaymentHandler
    {
        public string TargetBizSource
        {
            get; set;
        }

        public bool BizProcess(TradeJournal tradeJournal)
        { 
            if (this.TargetBizSource == tradeJournal.BizSource && tradeJournal.BizSource == "BuyCareerService")
            {
                //UserWallet.ChangeBalance(tradeJournal.OwnerId, TradeMode.Payout, tradeJournal.TotalFee);

                if(tradeJournal.OwnerId == tradeJournal.BuyerId && tradeJournal.SellerId > 0)
                {
                    PayToSeller(tradeJournal);
                }
                Console.WriteLine(string.Format("PaymentCompleted for {0} by {1}", this.TargetBizSource, this.GetType().Name));

            }
            if (this.TargetBizSource == tradeJournal.BizSource && tradeJournal.BizSource == "SellCareerService")
            {
                UserWallet.AddBalance(tradeJournal.OwnerId, tradeJournal.TradeCode);
            }

            return true;
         }

        private void PayToSeller(TradeJournal tradeJournal)
        {
            var payment = new Payment();
            payment.ParentTradeCode = tradeJournal.TradeCode;
            payment.OwnerId = tradeJournal.SellerId;            
            payment.PayWay = "System";
            payment.TradeMode = TradeMode.Payoff;
            payment.BizSource = "SellCareerService";            
            payment.CommodityCategory = tradeJournal.CommodityCategory;
            payment.CommodityCode = tradeJournal.CommodityCode;
            payment.CommodityQuantity = tradeJournal.CommodityQuantity;
            payment.TotalFee = 0 - tradeJournal.TotalFee;
            payment.CommoditySubject = string.Format("Deposit ￥{0}", payment.TotalFee);
            payment.BuyerId = tradeJournal.BuyerId;
            payment.SellerId = tradeJournal.SellerId;
            var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
            var paymentDetail = "TradeCode=" + payment.TradeCode;
            var isPaid = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(payment.SignedParams, payment.PayWay, null, paymentDetail);
        }

        public bool Preprocess(Payment paymentParams)
        {
            paymentParams.SellerId = 9;
            return true;
        }
    }
}
