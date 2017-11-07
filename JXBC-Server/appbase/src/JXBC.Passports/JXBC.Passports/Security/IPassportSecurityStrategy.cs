using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome;

namespace JXBC.Passports.Security
{
    /// <summary>
    /// 
    /// </summary>
    public interface IPassportSecurityStrategy
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        string HashPassword(string password, UserPassport userPassport);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        bool Verify(string password, UserPassport userPassport);
    }
}
