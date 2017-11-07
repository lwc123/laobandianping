using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.TradeSystem.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface IWalletRepository : IRepository<Wallet,long>
    {

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="walletType"></param> 
        /// <param name="ownerId"></param> 
        /// <returns></returns>         
        Wallet FindByOwnerId(WalletType walletType, long ownerId);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <param name="totalFee"></param>
        /// <param name="addWithdrawBalance"></param>
        /// <returns></returns>
        bool AddBalance(Wallet model, decimal totalFee, bool addWithdrawBalance);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        bool ChangeBankAccount(Wallet model);

    }    
}