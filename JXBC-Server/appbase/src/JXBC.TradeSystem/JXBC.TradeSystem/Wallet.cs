using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.TradeSystem.DataRepositories;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class Wallet : EntityBase<long>
    {
        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        public static readonly string PaidWayName = "wallet";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="toTradeCode"></param>
        /// <returns></returns>
        public static PaymentResult Pay(long ownerId, string toTradeCode)
        {
            var tradeJournal = TradeJournal.FindById(toTradeCode);
            if (null == tradeJournal) return null;

            if (tradeJournal.TradeMode != TradeMode.Payout) return null;
            if (tradeJournal.TradeStatus >= TradeStatus.Paid) return null;

            var walletType = WalletType.Privateness;

            if (tradeJournal.TradeType == TradeType.OrganizationToOrganization || tradeJournal.TradeType == TradeType.OrganizationToPersonal)
                walletType = WalletType.Organization;

            var wallet = Wallet.FindByOwnerId(walletType, tradeJournal.OwnerId);
            if (null == wallet || wallet.AvailableBalance < Math.Abs(tradeJournal.TotalFee)) return null;
            if (wallet.OwnerId != ownerId) return null;

            var result = ChangeBalance(wallet, TradeMode.Payout, tradeJournal.TotalFee, tradeJournal.TradeCode, tradeJournal.BizSource, tradeJournal.BuyerId);
            result.TradeCode = toTradeCode;
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public static PaymentResult Refund(TradeJournal tradeJournal)
        {
            if (null == tradeJournal) return null;

            if (tradeJournal.TradeMode != TradeMode.Payoff) return null;
            if (tradeJournal.TradeStatus >= TradeStatus.Paid) return null;

            var walletType = WalletType.Privateness;

            if (tradeJournal.TradeType == TradeType.OrganizationToOrganization || tradeJournal.TradeType == TradeType.PersonalToOrganization)
                walletType = WalletType.Organization;

            var wallet = Wallet.FindByOwnerId(walletType, tradeJournal.OwnerId);
            if (null == wallet) return null;

            var result = ChangeBalance(wallet, TradeMode.Payoff, tradeJournal.TotalFee, tradeJournal.TradeCode, tradeJournal.BizSource, tradeJournal.BuyerId);
            result.TradeCode = tradeJournal.TradeCode;
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="walletType"></param>
        /// <param name="ownerId"></param>
        /// <param name="fromTradeCode"></param>
        /// <returns></returns>
        public static PaymentResult AddBalance(WalletType walletType, long ownerId, string fromTradeCode)
        {
            if (walletType == WalletType.All) return null;

            var tradeJournal = TradeJournal.FindById(fromTradeCode);
            if (null == tradeJournal) return null;

            if (tradeJournal.TradeMode != TradeMode.Payoff) return null;
            if (tradeJournal.TradeStatus == TradeStatus.BizCompleted) return null;
            if (tradeJournal.TradeStatus != TradeStatus.Paid && tradeJournal.PayWay != PayWays.System) return null;

            Wallet wallet = Wallet.FindByOwnerId(walletType, ownerId);
            if (null == wallet)
            {
                wallet = new Wallet();
                wallet.WalletType = walletType;
                wallet.OwnerId = ownerId;
                wallet.Save();
            }
            
            var handlerId = tradeJournal.SellerId > 0 ? tradeJournal.SellerId : tradeJournal.BuyerId;

            return ChangeBalance(wallet, TradeMode.Payoff, tradeJournal.TotalFee, tradeJournal.TradeCode, tradeJournal.BizSource, handlerId);
        }
        
        private static PaymentResult ChangeBalance(Wallet wallet, TradeMode tradeMode, decimal totalFee, string tradeCode, string bizSource, long handlerId)
        {
            if (string.IsNullOrEmpty(bizSource))
                throw new ArgumentNullException("bizSource");

            if ((tradeMode == TradeMode.Payoff && totalFee < 0) || (tradeMode == TradeMode.Payout && totalFee > 0))
                totalFee = 0 - totalFee;

            var addWithdrawBalance = ModuleEnvironment.RealityMoneyBizSourceScopeList.Contains(bizSource);

            var journal = new WalletJournal();
            journal.WalletId = wallet.WalletId;            
            journal.TradeMode = tradeMode;
            journal.TargetTradeCode = tradeCode;
            journal.BizSource = bizSource;
            journal.TotalFee = totalFee;
            journal.HandlerId = handlerId;
            
            using (var scope = new System.Transactions.TransactionScope())
            {
                var changed = wallet.AddBalance(totalFee, addWithdrawBalance);
                if (changed)
                {
                    journal.Save();
                    scope.Complete();

                    var paidDetail = new Dictionary<string, object>();
                    paidDetail.Add("TradeCode", tradeCode);
                    paidDetail.Add("WalletId", wallet.WalletId);
                    paidDetail.Add("WalletType", wallet.WalletType);                
                    paidDetail.Add("JournalId", journal.JournalId);
                    paidDetail.Add("BizSource", journal.BizSource);
                    paidDetail.Add("TotalFee", journal.TotalFee);                    
                    return new PaymentResult() { Success = true, PaidDetail = paidDetail.ToJson() };
                }
                return new PaymentResult() { Success = false } ;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Wallet FindById(long id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<IWalletRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }

        /// <summary>
        /// 
        /// </summary>        
        /// <param name="walletType"></param>
        /// /// <param name="ownerId"></param>
        /// <returns></returns>
        public static Wallet FindByOwnerId(WalletType walletType, long ownerId)
        {
            if (ownerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IWalletRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByOwnerId(walletType, ownerId);
            return model;
        }
        

        #endregion //Static Members

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long WalletId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }
        /// <summary> 
        ///  
        /// </summary> 
        public WalletType WalletType { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public long OwnerId { get; set; }
        /// <summary> 
        ///  可用余额
        /// </summary> 
        public decimal AvailableBalance { get; set; }

        /// <summary>
        /// 可提现余额
        /// </summary>
        public decimal CanWithdrawBalance { get; set; }

        /// <summary>
        /// 已冻结金额
        /// </summary>
        public decimal FreezeBalance { get; set; }
        /// <summary> 
        ///  身份证
        /// </summary> 
        public string IDCard { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string BankName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string BankAccountName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string BankAccountNumber { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime CreatedTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ModifiedTime { get; set; }
 
        #endregion //Instance Properties
		
        /// <summary>
        /// 
        /// </summary>	
		public Wallet()
		{
			this.CreatedTime = DateTime.Now;
			this.ModifiedTime = this.CreatedTime;
		}

        #region Persist Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal bool Save()
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IWalletRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="totalFee"></param>
        /// <param name="addWithdrawBalance"></param>
        /// <returns></returns>
        internal bool AddBalance(decimal totalFee, bool addWithdrawBalance)
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IWalletRepository>(ModuleEnvironment.ModuleName);
            return repository.AddBalance(this, totalFee, addWithdrawBalance);
        }

        #endregion //Persist Methods
    }
}

