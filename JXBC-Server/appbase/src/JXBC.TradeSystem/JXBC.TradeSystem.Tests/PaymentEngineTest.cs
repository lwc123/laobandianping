using System;
using System.Linq;
using System.Collections.Generic;
using NUnit.Framework;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;
using JXL.TradeSystem;
using JXL.Workplace.PaymentExtension;

namespace JXL.TradeSystem.Tests
{
    [TestFixture]
    public class PaymentEngineTest : TestBase
    {
        [Test]
        public void VaTest()
        {
            var code = "201604142157482746705110";
            var paymentDetail = string.Format("<xml><out_trade_no>{0}</out_trade_no></xml>", code);
            var provider = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentProviders[PayWays.Wechat];
            var paymentDetailDic = provider.ParsePaymentDetail(paymentDetail);
            var isPaid = provider.VerifyPaymentResult(ref paymentDetailDic);
            Assert.IsTrue(isPaid);
        }

        [Test] 
        public void PayoffTest()
        {
            var payment = new Payment();
            payment.OwnerId = 95838;            
            payment.TradeMode = TradeMode.Payoff;
            payment.PayWay = PayWays.Wallet;
            payment.BizSource = BizSources.Deposit;
            payment.CommodityCategory = "充值";
            payment.CommodityCode = "";
            payment.CommodityQuantity = 1;
            payment.TotalFee = 500;
            payment.CommoditySubject = string.Format("充值 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;
            var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
            Assert.IsTrue(signed);

            Console.WriteLine("Sign:{0}", payment.SignedParams);
            var paymentDetail = "TradeCode="+ payment.TradeCode;
            var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(payment.TradeCode, payment.PayWay, null, paymentDetail);
            var isPaid = null != tradeJournal;
            Assert.IsTrue(isPaid);
        }

        [Test]
        public void BuyCareerServiceTest()
        {
            var payment = new Payment();
            payment.OwnerId = 95838;
            //payment.SellerId = 107;
            payment.PayWay = PayWays.Wallet;
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = PaymentSources.BuyCareerService;
            payment.CommodityCategory = "CareerService";
            payment.CommodityCode = "1";
            payment.CommodityQuantity = 1;
            payment.TotalFee = 1000;
            payment.CommoditySubject = string.Format("购买服务 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;
            {
                var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
                Assert.IsTrue(signed);

                Console.WriteLine("Sign:{0}", payment.SignedParams);

                var isPaid = ObjectIOCFactory.GetSingleton<PaymentEngine>().UserWalletPay(payment.OwnerId, payment.SignedParams);
                Assert.IsFalse(isPaid);
            }
             
            {
                payment.TotalFee = 123;
                var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
                Assert.IsTrue(signed);

                Console.WriteLine("Sign:{0}", payment.SignedParams);

                var isPaid = ObjectIOCFactory.GetSingleton<PaymentEngine>().UserWalletPay(payment.OwnerId, payment.SignedParams);
                Assert.IsTrue(isPaid);

                var paymentDetail = "TradeCode=" + payment.TradeCode;
                var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(payment.TradeCode, payment.PayWay, null, paymentDetail);
                isPaid = null != tradeJournal;
                Assert.IsTrue(isPaid);
            }
        }

        [Test]
        public void BuyCareerServiceUseAlipayTest()
        {
            var payment = new Payment();

            payment.PayWay = PayWays.Wechat;
            payment.ClientIP = "211.9.5.234";
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = PaymentSources.BuyCareerService;
            payment.CommodityCategory = "CareerService";
            payment.CommodityCode = "1";
            payment.CommodityQuantity = 1;
            payment.TotalFee = 0.01M;
            payment.CommoditySubject = string.Format("购买服务 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;
            {
                var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
                Assert.IsTrue(signed);

                Console.WriteLine("Sign:{0}", payment.SignedParams);
            }
        }

        [Test]
        public void BuyCareerAdviceTest()
        {
            var payment = new Payment();
            payment.OwnerId = 13;
            payment.SellerId = 107;
            payment.PayWay = PayWays.Wallet;
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = PaymentSources.SendGratuity;
            payment.CommodityCategory = "CareerAdvice";
            payment.CommodityCode = "1";
            payment.CommodityQuantity = 1;
            payment.TotalFee = 1000;
            payment.CommoditySubject = string.Format("打赏 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;
            {
                var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
                Assert.IsTrue(signed);

                Console.WriteLine("Sign:{0}", payment.SignedParams);

                var isPaid = ObjectIOCFactory.GetSingleton<PaymentEngine>().UserWalletPay(payment.OwnerId, payment.SignedParams);
                Assert.IsFalse(isPaid);
            }

            {
                payment.TotalFee = 123;
                var signed = ObjectIOCFactory.GetSingleton<PaymentEngine>().CreateTrade(payment);
                Assert.IsTrue(signed);

                Console.WriteLine("Sign:{0}", payment.SignedParams);

                var isPaid = ObjectIOCFactory.GetSingleton<PaymentEngine>().UserWalletPay(payment.OwnerId, payment.SignedParams);
                Assert.IsTrue(isPaid);

                var paymentDetail = "TradeCode=" + payment.TradeCode;
                var tradeJournal = ObjectIOCFactory.GetSingleton<PaymentEngine>().PaymentCompleted(payment.TradeCode, payment.PayWay, null, paymentDetail);
                isPaid = null != tradeJournal;
                Assert.IsTrue(isPaid);
            }
        }

        [Test]
        public void RefundTest()
        {
            var tradeCode = "201609191657217132408866";
            var source = TradeJournal.FindById(tradeCode);
            Assert.NotNull(source);


            var payment = new Payment();
            payment.ParentTradeCode = source.TradeCode;
            payment.OwnerId = source.SellerId;
            payment.PayWay = source.PaidWay;
            payment.TradeMode = TradeMode.Payoff;
            payment.BizSource = PaymentSources.RejectService;
            payment.CommodityCategory = source.CommodityCategory;
            payment.CommodityCode = source.CommodityCode;
            payment.CommodityQuantity = source.CommodityQuantity;
            payment.CommoditySubject = string.Format("Reject the service {0} for user {1} [￥{2}].", source.CommodityCode, source.BuyerId, -source.TotalFee);
            payment.CommoditySummary = null;
            payment.TotalFee = 0 - source.TotalFee;
            payment.BuyerId = source.BuyerId;
            payment.SellerId = source.SellerId;

            var refunded = ObjectIOCFactory.GetSingleton<PaymentEngine>().Refund(payment);
            Assert.IsTrue(refunded);
        }
    }


}
