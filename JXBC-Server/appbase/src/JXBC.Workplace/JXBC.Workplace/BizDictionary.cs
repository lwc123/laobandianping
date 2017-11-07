using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;
using JXBC.Passports;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public partial class BizDictionary
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly string Listeners_SignUp = "Listeners_SignUp";
        /// <summary>
        /// 
        /// </summary>
        public static readonly string Listeners_OpenEnterpriseService = "Listeners_OpenEnterpriseService";

        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public static IDictionary<string, string> GetSimpleDictionary(string code)
        {
            code.AssertNotNull("code");

            var repository = RepositoryManager.GetRepository<IBizDictionaryRepository>(ModuleEnvironment.ModuleName);
            var list = repository.LoadEntriesByCode(code);

            IDictionary<string, string> bizDictionary = null;
            if(null != list &&  list.Count > 0)
            {
                bizDictionary = new Dictionary<string, string>(list.Count);
                foreach (var item in list)
                {
                    if (false == item.Forbidden)
                        bizDictionary.Add(item.Code, item.Name);
                }
            }
            return bizDictionary;
        }



        #endregion //Static Members
    }
}
