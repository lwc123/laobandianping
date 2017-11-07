using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Configuration;
using JXBC.Passports;

namespace JXBC.Passports.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public interface IIMProvider : IResolveObject
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="imAccount"></param>
        /// <returns></returns>
        bool CreateAccount(ThirdIMAccount imAccount);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="imAccount"></param>
        /// <returns></returns>
        bool ChangeNickname(ThirdIMAccount imAccount);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toAccount"></param>
        /// <param name="fromAccount"></param>
        /// <param name="msgType"></param>
        /// <param name="content"></param>
        /// <param name="extParams"></param>
        /// <returns></returns>
        bool SendMessage(string toAccount, string fromAccount, string msgType, string content, IDictionary<string,object> extParams);
    }
}
