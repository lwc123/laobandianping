using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.TradeSystem.DataRepositories;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class PaymentCredential : EntityBase<string>
    {
        #region Static Members

        private static readonly string PaymentSalt = "#NTD04>6ry12LY0";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static PaymentCredential FindById(string id)
        {
			id.AssertNotNull("id");		
            var repository = RepositoryManager.GetRepository<IPaymentCredentialRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }

        private static string GenerateSign(TradeJournal tradeJournal, PaymentCredential credential)
        {
            var factorParams = new string[]
            {
                PaymentSalt,
                tradeJournal.TradeCode,
                tradeJournal.TradeMode.ToString(),
                tradeJournal.PayWay,
                tradeJournal.BizSource,
                tradeJournal.CommodityCategory,
                tradeJournal.CommodityCode,
                tradeJournal.CommodityQuantity.ToString(),
                tradeJournal.CommoditySubject,
                tradeJournal.TotalFee.ToString(),
                credential.ToJson()
            }.OrderBy(x => x).ToArray();

            var text = string.Join("", factorParams);

            using (var algorithmProvider = SHA1.Create())
            {
                byte[] hashed = algorithmProvider.ComputeHash(Encoding.UTF8.GetBytes(text));
                StringBuilder sBuilder = new StringBuilder();
                for (int i = 0; i < hashed.Length; i++)
                {
                    sBuilder.Append(hashed[i].ToString("X2"));
                }
                return sBuilder.ToString();
            }
        }

        #endregion //Static Members

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string TradeCode
        {
            get { return this.Id; }
            set { this.Id = value; }
        }		
        
        /// <summary> 
        ///  
        /// </summary> 
        public long OwnerId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string PaidWay { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string PaidChannel { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal TotalFee { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdTradeCode { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdBuyerCode { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdBuyerName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdSellerCode { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdSellerName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdPaidDetails { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string CredentialSign { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string LastOperator { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime PaidTime { get; set; }
 
        #endregion //Instance Properties
		
        /// <summary>
        /// 
        /// </summary>	
		public PaymentCredential()
		{
		}

        #region Persist Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            var tradeJournal = TradeJournal.FindById(this.TradeCode);
            if (null == tradeJournal) return false;

            if (tradeJournal.TradeStatus >= TradeStatus.Paid) return true;

            this.OwnerId = tradeJournal.OwnerId;
            this.CredentialSign = null;
            this.PaidTime = DateTime.Now;
            this.CredentialSign = GenerateSign(tradeJournal, this);

            using(var scope = new System.Transactions.TransactionScope())
            {
                var repository = RepositoryManager.GetRepository<IPaymentCredentialRepository>(ModuleEnvironment.ModuleName);
                var saved = repository.Save(this);

                if (saved)
                {
                    tradeJournal.PayWay = this.PaidWay;
                    tradeJournal.TradeStatus = TradeStatus.Paid;
                    saved = tradeJournal.Save();
                    scope.Complete();
                }
                
                return saved;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IPaymentCredentialRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

