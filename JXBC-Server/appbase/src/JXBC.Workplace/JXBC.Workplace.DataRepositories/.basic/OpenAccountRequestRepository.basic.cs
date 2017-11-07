
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
    public partial class OpenAccountRequestRepository : SimpleRepositoryBase<OpenAccountRequest,long>, IOpenAccountRequestRepository
    {
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns>  
        public OpenAccountRequest FindByPassportId(long passportId)
        {            
            var sqlName = this.FormatSqlName("SelectByPassportId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("PassportId", passportId);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            OpenAccountRequest result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entName"></param> 
        /// <returns></returns>  
        public OpenAccountRequest FindByEntName(string entName)
        {            
            var sqlName = this.FormatSqlName("SelectByEntName");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("EntName", entName);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            OpenAccountRequest result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="attestationStatus"></param> 
        /// <returns></returns>  
        public OpenAccountRequest FindByAttestationStatus(int attestationStatus)
        {            
            var sqlName = this.FormatSqlName("SelectByAttestationStatus");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("AttestationStatus", attestationStatus);
            var dataset = SqlHelper.ExecuteDataSet(sqlName, pValues);
            OpenAccountRequest result = null;
            if (dataset.Tables[0].Rows.Count == 1)
                result = this.Convert(dataset.Tables[0].Rows[0]);
            return result;
        }
        
    
    } 
}