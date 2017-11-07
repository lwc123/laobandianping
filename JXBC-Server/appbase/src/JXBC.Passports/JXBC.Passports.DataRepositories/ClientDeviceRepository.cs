using System.Collections.Generic;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public class ClientDeviceRepository : SimpleRepositoryBase<ClientDevice, long>, IClientDeviceRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="deviceKey"></param>
        /// <returns></returns>
        public ClientDevice FindByKey(string deviceKey)
        {
            var sqlName = this.FormatSqlName("SelectByDeviceKey");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("DeviceKey", deviceKey);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            ClientDevice device = null;
            if (dataset.Tables[0].Rows.Count > 0)
            {
                device = this.Convert(dataset.Tables[0].Rows[0]);
            }

            return device;
        }
    }
}