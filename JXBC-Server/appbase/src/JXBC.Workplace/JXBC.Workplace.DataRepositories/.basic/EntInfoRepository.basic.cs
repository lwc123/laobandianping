
using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class EntInfoRepository : SimpleRepositoryBase<EntInfo,long>, IEntInfoRepository
    {
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entName"></param> 
        /// <returns></returns>  
        public EntInfo FindByEntName(string entName)
        {            
            var sqlName = this.FormatSqlName("SelectByEntName");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("EntName", entName);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            EntInfo result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
    
    } 
}