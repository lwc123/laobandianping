
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;


namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class BizDictionaryRepository : SimpleRepositoryBase<BizDictionary, long>, IBizDictionaryRepository
    {
        /// 
        public IList<DictionaryEntry> LoadEntriesByCode(string code)
        {            
            var sqlName = this.FormatSqlName("SelectEntriesByCode");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("Code", code);
            var dataSet = SqlHelper.ExecuteDataSet(sqlName, sqlParams);

            var count = dataSet.Tables[0].Rows.Count;
            IList<DictionaryEntry> list = null;
            if(count > 0)
            {
                list = new List<DictionaryEntry>(count);
                foreach (DataRow row in dataSet.Tables[0].Rows)
                {
                    var entry = row.Serialize<DictionaryEntry>();
                    list.Add(entry);
                }
            }            
            
            return list;
        }
        
    } 
}