
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
    public partial class TargetEmployeRepository : SimpleRepositoryBase<TargetEmploye,long>, ITargetEmployeRepository
    {
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns>  
        public TargetEmploye FindByPassportId(long passportId)
        {            
            var sqlName = this.FormatSqlName("SelectByPassportId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("PassportId", passportId);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            TargetEmploye result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="iDCard"></param> 
        /// <returns></returns>  
        public TargetEmploye FindByIDCard(string iDCard)
        {            
            var sqlName = this.FormatSqlName("SelectByIDCard");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("IDCard", iDCard);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            TargetEmploye result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
    
    } 
}