using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Transactions;
using M2SA.AppGenome;
using M2SA.AppGenome.Configuration;
using JXBC.TradeSystem.Providers;
using JXBC.TradeSystem.Handlers;
using JXBC.Passports.Security;
using M2SA.AppGenome.Cache;
using M2SA.AppGenome.Logging;
using System.Threading;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public class PaymentEngine : ResolveObjectBase
    {
        #region Static members

        static PaymentEngine()
        {
            RegisterType<IPaymentProvider, SystemProvider>("Provider");
            RegisterType<IPaymentProvider, WalletProvider>("Provider");
            RegisterType<IPaymentProvider, AlipayProvider>("Provider");
            RegisterType<IPaymentProvider, WechatProvider>("Provider");
            RegisterType<IPaymentProvider, AppleIAPProvider>("Provider");
            RegisterType<IPaymentProvider, OfflineProvider>("Provider");

            RegisterType<IPaymentHandler, DepositHandler>("Handler");
            RegisterType<IPaymentHandler, WithdrawHandler>("Handler");
            RegisterType<IPaymentHandler, WebProxyHandler>("Handler");
            RegisterType<IPaymentHandler, EmptyHandler>("Handler");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="TImpl"></typeparam>
        /// <param name="suffix"></param>
        public static void RegisterType<T, TImpl>(string suffix) where TImpl : T
        {
            AppInstance.RegisterTypeAlias<T, TImpl>(typeof(TImpl).Name.Replace(suffix, ""));
        }

        internal static void EnableTestTotalFee(Payment payment)
        {
            if (ModuleEnvironment.EnableTestTotalFee) // 启用测试支付金额(0.01元)
            {
                if (payment.TradeMode == TradeMode.Payoff)
                    payment.TotalFee = 0.01m;
                else if (payment.TradeMode == TradeMode.Payout)
                    payment.TotalFee = -0.01m;
            }
        }

        #endregion static members

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, IPaymentProvider> PaymentProviders { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, string> PayWaysOfBizSource { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IList<IPaymentHandler> PaymentHandlers { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        private PaymentEngine()
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="os"></param>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public string[] GetPayWays(string os, string bizSource)
        {
            if (null == this.PayWaysOfBizSource) return null;

            string[] payWays = null;

            var bizSourceKey = string.Concat(os, ":", bizSource);
            if (this.PayWaysOfBizSource.ContainsKey(bizSourceKey))
            {
                payWays = this.PayWaysOfBizSource[bizSourceKey].Split(',');
            }
            else if (this.PayWaysOfBizSource.ContainsKey(os))
            {
                payWays = this.PayWaysOfBizSource[os].Split(',');
            }
            else if (this.PayWaysOfBizSource.ContainsKey("*"))
            {
                return GetPayWays("*", bizSource);
            }
            return payWays;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public bool CreateTrade(Payment payment)
        {
            var result = CreateTradeByPayment(payment);

            return result.Item1;
        }

        private Tuple<bool, TradeJournal> CreateTradeByPayment(Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.PayWay.AssertNotNull("payment:PayWay");
            payment.BizSource.AssertNotNull("payment:BizSource");
            if (payment.TradeMode == TradeMode.All)
                throw new ArgumentOutOfRangeException("payment:TradeMode", string.Format("Not support the TradeMode : {0}", payment.TradeMode));
            if (payment.TotalFee < 0)
                throw new ArgumentOutOfRangeException("payment:TotalFee", string.Format("Not support the TotalFee : {0}", payment.TotalFee));
            if (null == this.PaymentProviders || false == this.PaymentProviders.ContainsKey(payment.PayWay))
                throw new ArgumentOutOfRangeException("payment:PaidWay", string.Format("Not support the PayWay : {0}", payment.PayWay));
            if (null == this.PaymentHandlers || false == this.PaymentHandlers.Where(o => o.TargetBizSource == payment.BizSource).Any())
                throw new ArgumentOutOfRangeException("payment:BizSource", string.Format("Not support the BizSource : {0}", payment.BizSource));

            if (payment.OwnerId == 0 && (payment.TradeType == TradeType.OrganizationToPersonal || payment.TradeType == TradeType.OrganizationToOrganization))
                throw new ArgumentOutOfRangeException("payment:OwnerId", string.Format("Not support OwnerId is 0 from OrganizationTo*** trade.", payment.TradeMode));

            if (payment.BuyerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support BuyerId is 0.");

            if(payment.PayWay == PayWays.System && false == ModuleEnvironment.SystemPayBizSourceScopeList.Contains(payment.BizSource))
                throw new ArgumentOutOfRangeException("payment:PayWay", "Not support use System Pay.");


            var processed = this.Preprocess(payment);
            if (false == processed) return Tuple.Create<bool, TradeJournal>(false, null);

            if (payment.TradeMode == TradeMode.Payoff && payment.TotalFee < 0)
                payment.TotalFee = 0 - payment.TotalFee;
            else if (payment.TradeMode == TradeMode.Payout && payment.TotalFee > 0)
                payment.TotalFee = 0 - payment.TotalFee;            

            var tradeJournal = TradeJournal.CreateNew(payment);
            PaymentEngine.EnableTestTotalFee(tradeJournal);

            var provider = this.PaymentProviders[payment.PayWay];
            payment.TradeCode = tradeJournal.TradeCode;
            payment.SignedParams = provider.GenerateSignedParams(tradeJournal);

            tradeJournal.UpdateTradeStatus(TradeStatus.WaitingPayment);

            var isSigned = false == string.IsNullOrEmpty(payment.SignedParams);
            if (isSigned)
                return Tuple.Create<bool, TradeJournal>(true, tradeJournal);
            else
                return Tuple.Create<bool, TradeJournal>(false, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        public string CacheSignedPayment(Payment payment)
        {
            var paymentJson = payment.ToJson();
            var code = HashHelper.ComputeHash(paymentJson, HashAlgorithmName.MD5);
            CacheManager.GetCache(ModuleEnvironment.ModuleName).Set(code, paymentJson);
            return code;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public Payment GetSignedPaymentFromCache(string code)
        {
            var paymentJson = CacheManager.GetCache(ModuleEnvironment.ModuleName).Get<string>(code);
            if (null != paymentJson)
            {
                return paymentJson.ConvertEntity<Payment>();
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public TradeJournal Withdraw(Payment payment)
        {
            if (payment.OwnerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support OwnerId is 0.");
            if (payment.BuyerId < 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support BuyerId is 0.");
            if (payment.TotalFee <= 0)
                throw new ArgumentOutOfRangeException("payment:OwnerId", "Not support TotalFee <= 0.");

            payment.PayWay = PayWays.Wallet;
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = BizSources.Withdraw;

            if (payment.TradeType == TradeType.PersonalToOrganization || payment.TradeType == TradeType.PersonalToPersonal)
            {
                if(payment.BuyerId != payment.OwnerId)
                    throw new ArgumentOutOfRangeException("payment:BuyerId", "Not support BuyerId != OwnerId .");
            }

            var signed = this.CreateTrade(payment);

            if (signed)
            {
                var paymentResult = Wallet.Pay(payment.OwnerId, payment.TradeCode);
                if(null != paymentResult && paymentResult.Success)
                {
                    var tradeJournal = this.PaymentCompleted(payment.TradeCode, payment.PayWay, payment.BuyerId.ToString(), paymentResult.PaidDetail);
                    return tradeJournal;
                }
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public TradeJournal Refund(Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.ParentTradeCode.AssertNotNull("payment:ParentTradeCode");            
            
            if (payment.TotalFee <= 0)
                throw new ArgumentOutOfRangeException("payment:TotalFee", string.Format("Not support the TotalFee : {0}", payment.TotalFee));
            if (null == this.PaymentHandlers || false == this.PaymentHandlers.Where(o => o.TargetBizSource == payment.BizSource).Any())
                throw new ArgumentOutOfRangeException("payment:BizSource", string.Format("Not support the BizSource : {0}", payment.BizSource));

            payment.TradeMode = TradeMode.Payoff;

            var parentTradeSource = TradeJournal.FindById(payment.ParentTradeCode);
            if (null == parentTradeSource) return null;
            if (payment.OwnerId != parentTradeSource.OwnerId) return null;

            if (parentTradeSource.TradeStatus != TradeStatus.BizCompleted) return null;
            if (payment.TotalFee > parentTradeSource.TotalFee) return null;

            var result = CreateTradeByPayment(payment);

            if (result.Item1)
            {
                var tradeSource = result.Item2;
                var provider = this.PaymentProviders[payment.PayWay];
                var refundResult = provider.Refund(result.Item2);                
                if (refundResult.Item1)
                {
                    var saved = SavePaymentResult(tradeSource, tradeSource.BuyerId.ToString(), provider.ParsePaymentResult(tradeSource, refundResult.Item2));
                    return saved ? tradeSource : null;
                }
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public TradeJournal ShareIncome(Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.BizSource.AssertNotNull("payment:BizSource");
            payment.ParentTradeCode.AssertNotNull("payment:ParentTradeCode");

            if (payment.TotalFee <= 0)
                throw new ArgumentOutOfRangeException("payment:TotalFee", string.Format("Not support the TotalFee : {0}", payment.TotalFee));
            if (null == this.PaymentHandlers || false == this.PaymentHandlers.Where(o => o.TargetBizSource == payment.BizSource).Any())
                throw new ArgumentOutOfRangeException("payment:BizSource", string.Format("Not support the BizSource : {0}", payment.BizSource));

            payment.PayWay = PayWays.System;
            payment.TradeMode = TradeMode.Payoff;

            var parentTradeSource = TradeJournal.FindById(payment.ParentTradeCode);
            if (null == parentTradeSource) return null;
            if (parentTradeSource.TradeStatus < TradeStatus.Paid) return null;
            if (payment.TotalFee > Math.Abs(parentTradeSource.TotalFee)) return null;

            var result = CreateTradeByPayment(payment);
            if (result.Item1)
            {
                var tradeSource = result.Item2;
                var walletType = WalletType.Privateness;
                if (tradeSource.TradeType == TradeType.PersonalToOrganization || tradeSource.TradeType == TradeType.OrganizationToOrganization)
                    walletType = WalletType.Organization;

                var paymentResult = Wallet.AddBalance(walletType, payment.OwnerId, payment.TradeCode);
                if (null != paymentResult && paymentResult.Success)
                {
                    var tradeJournal = this.PaymentCompleted(payment.TradeCode, payment.PayWay, payment.BuyerId.ToString(), paymentResult.PaidDetail);
                    return tradeJournal;
                }
            }
            return null;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        public TradeJournal SystemGift(Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.BizSource.AssertNotNull("payment:BizSource");

            if (payment.TotalFee <= 0)
                throw new ArgumentOutOfRangeException("payment:TotalFee", string.Format("Not support the TotalFee : {0}", payment.TotalFee));
            if (null == this.PaymentHandlers || false == this.PaymentHandlers.Where(o => o.TargetBizSource == payment.BizSource).Any())
                throw new ArgumentOutOfRangeException("payment:BizSource", string.Format("Not support the BizSource : {0}", payment.BizSource));

            payment.PayWay = PayWays.System;
            payment.TradeMode = TradeMode.Payoff;

            if(false == string.IsNullOrEmpty(payment.ParentTradeCode))
            {
                var parentTradeSource = TradeJournal.FindById(payment.ParentTradeCode);
                if (null == parentTradeSource) return null;
                if (parentTradeSource.TradeStatus < TradeStatus.Paid) return null;
            }           

            var result = CreateTradeByPayment(payment);
            if (result.Item1)
            {
                var tradeSource = result.Item2;
                var walletType = WalletType.Privateness;
                if (tradeSource.TradeType == TradeType.PersonalToOrganization || tradeSource.TradeType == TradeType.OrganizationToOrganization)
                    walletType = WalletType.Organization;

                var paymentResult = Wallet.AddBalance(walletType, payment.OwnerId, payment.TradeCode);
                if (null != paymentResult && paymentResult.Success)
                {
                    var tradeJournal = this.PaymentCompleted(payment.TradeCode, payment.PayWay, payment.BuyerId.ToString(), paymentResult.PaidDetail);
                    return tradeJournal;
                }
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        public TradeJournal OfflinePay(PaymentResult paymentResult)
        {
            paymentResult.AssertNotNull("payment");
            paymentResult.BizSource.AssertNotNull("payment:BizSource");
            if(paymentResult.BuyerId < 1)
                throw new ArgumentOutOfRangeException("payment:BuyerId", string.Format("Not support the BuyerId : {0}", paymentResult.BuyerId));

            if (paymentResult.TotalFee <= 0)
                throw new ArgumentOutOfRangeException("payment:TotalFee", string.Format("Not support the TotalFee : {0}", paymentResult.TotalFee));
            if (null == this.PaymentHandlers || false == this.PaymentHandlers.Where(o => o.TargetBizSource == paymentResult.BizSource).Any())
                throw new ArgumentOutOfRangeException("payment:BizSource", string.Format("Not support the BizSource : {0}", paymentResult.BizSource));

            paymentResult.TradeMode = TradeMode.Payout;

            var result = CreateTradeByPayment(paymentResult);
            if (result.Item1)
            {
                /*
{
    "TradeCode":"201702141945408037873865",
    "Nonce":"2F62FA07717F82983119971A7B7AB4AD5FA43799",
    "TotalFee":"2400",
    "Transfer-BankName":"bank123",
    "Transfer-AccountName":"account123",
    "Sign":"19251926E8104BDC56FF4F36D1886F6B391F4CB9"
}
                 */

                var paidDetail = paymentResult.PaidDetail.ConvertEntity<IDictionary<string, string>>();
                var tradeDetail = paymentResult.SignedParams.ConvertEntity<IDictionary<string, string>>();                
                foreach(var item in tradeDetail)
                {
                    paidDetail[item.Key] = item.Value;
                }

                var provider = (OfflineProvider)this.PaymentProviders[PayWays.Offline];
                paidDetail = provider.SignPaymentDetail(paidDetail);

                var tradeJournal = this.PaymentCompleted(paymentResult.TradeCode, paymentResult.PayWay, paymentResult.BuyerId.ToString(), paidDetail.ToJson());
                return tradeJournal;
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeCode"></param>
        /// <param name="paidWay"></param>
        /// <param name="operatorCode"></param>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        public TradeJournal PaymentCompleted(string tradeCode, string paidWay, string operatorCode, string paymentResult)
        {
            tradeCode.AssertNotNull("tradeCode");
            paymentResult.AssertNotNull("paymentDetail");            

            LogManager.GetLogger().Info("==>paymentResult: {0}", paymentResult.ToJson());

            var tradeSource = TradeJournal.FindById(tradeCode);
            if (null == tradeSource) return null;
            if (tradeSource.TradeStatus == TradeStatus.BizCompleted) return tradeSource;
            if (tradeSource.TradeStatus == TradeStatus.Paid)
            {
                var maxTimes = 5;
                for(var i=0; i < maxTimes; i++)
                {
                    Thread.Sleep(1200);
                    tradeSource = TradeJournal.FindById(tradeCode);
                    if (tradeSource.TradeStatus == TradeStatus.BizCompleted) return tradeSource;
                }
                return tradeSource;
            }

            if (tradeSource.PayWay == PayWays.System && false == ModuleEnvironment.SystemPayBizSourceScopeList.Contains(tradeSource.BizSource))
                throw new ArgumentOutOfRangeException("payment:PayWay", "Not support use System Pay.");

            var provider = this.PaymentProviders[paidWay];
            var paymentDetail = provider.ParsePaymentResult(tradeSource, paymentResult);
            var verifyResult = provider.VerifyPaymentResult(tradeSource, paymentDetail);
            if (false == verifyResult.Item1) return null;

            paymentDetail = verifyResult.Item2;
            tradeSource.PayWay = paidWay;
            var saved = SavePaymentResult(tradeSource, operatorCode, paymentDetail);
            return saved ? tradeSource : null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeCode"></param>
        /// <returns></returns>
        public PaymentResult QueryTrade(string tradeCode)
        {
            var tradeSource = TradeJournal.FindById(tradeCode);
            if (null == tradeSource) return null;

            return new PaymentResult() { Success = tradeSource.TradeStatus >= TradeStatus.BizCompleted, TargetBizTradeCode = tradeSource.TargetBizTradeCode };

        }

        private bool SavePaymentResult(TradeJournal tradeJournal, string operatorCode, IDictionary<string, string> paymentDetail)
        {
            var provider = this.PaymentProviders[tradeJournal.PayWay];
            var credential = provider.BuildPaymentCredential(tradeJournal, paymentDetail); 
            
            credential.PaidWay = tradeJournal.PayWay;
            credential.TradeCode = tradeJournal.TradeCode;
            credential.ThirdPaidDetails = paymentDetail.ToJson();
            credential.LastOperator = operatorCode;            
            var saved = credential.Save();

            if (saved)
            {
                tradeJournal.TradeStatus = TradeStatus.Paid;
                saved = this.BizProcess(tradeJournal);                
            }
            return saved;
        }

        private bool Preprocess(Payment payment)
        {
            if(null != this.PaymentProviders)
            {
                foreach(var item in this.PaymentHandlers)
                {
                    if (item.TargetBizSource != payment.BizSource) continue;

                    var continued = item.Preprocess(payment);
                    if (false == continued)
                        return false;
                }
            }
            return true;
        }

        private bool BizProcess(TradeJournal tradeJournal)
        {
            if (tradeJournal.TradeStatus == TradeStatus.BizCompleted) return true;
            if (tradeJournal.TradeStatus != TradeStatus.Paid) return false;

            var bizProcessResult = new BizProcessResult(); ;
            if (null != this.PaymentHandlers)
            {
                foreach (var item in this.PaymentHandlers)
                {
                    if (item.TargetBizSource != tradeJournal.BizSource) continue;

                    bizProcessResult = item.BizProcess(tradeJournal);
                    break;
                }
            }

            if (bizProcessResult.Success)
            {
                tradeJournal.CompletedTrade(bizProcessResult.BizId);
            }

            return bizProcessResult.Success;
        }        
    }
}
