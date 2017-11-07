using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IClientDeviceRepository : IRepository<ClientDevice, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="deviceKey"></param>
        /// <returns></returns>
        ClientDevice FindByKey(string deviceKey);
    }
}