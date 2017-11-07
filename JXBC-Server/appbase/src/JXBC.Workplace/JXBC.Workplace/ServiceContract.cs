using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.TradeSystem;
using JXBC.Workplace.DataRepositories;
using JXBC.Workplace.PaymentExtension;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public partial class ServiceContract
    {
        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="buyerId"></param>
        /// <returns></returns>
        public static ServiceContract FindLastOneByBuyer(long buyerId)
        {
            if (buyerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindLastOneByBuyer(buyerId);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="newContract"></param>
        /// <returns></returns>
        public static bool AddServiceContract(ServiceContract newContract)
        {
            newContract.AssertNotNull("newContract");
            
            if (newContract.BuyerId < 0) return false;

            var contract = FindLastOneByBuyer(newContract.BuyerId);
            if(null == contract || contract.ContractStatus > ContractStatus.Servicing)
            {
                contract = newContract;
                contract.ContractCode = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmssfff"), new Random().Next(1000000, 9000000));
            } 
            else
            {
                newContract.ContractCode = contract.ContractCode;

                contract.PaidWay = newContract.PaidWay;
                contract.ServiceEndTime = contract.ServiceEndTime.Add(newContract.ServiceEndTime - newContract.ServiceBeginTime);
                contract.TotalFee += newContract.TotalFee;
            }
            contract.ContractStatus = ContractStatus.Servicing;
            var saved = contract.Save();
            return saved;
        }

        #endregion //Static Members        
    }
}
