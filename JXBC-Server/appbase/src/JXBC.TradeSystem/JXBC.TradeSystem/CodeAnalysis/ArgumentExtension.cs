using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public static class ArgumentExtension
    {        /// <summary>
        /// 
        /// </summary>
        /// <param name="argumentValue"></param>
        /// <param name="argumentName"></param>
        public static void AssertNotNull(this object argumentValue, string argumentName)
        {
            if (argumentValue == null)
                throw new ArgumentNullException(argumentName);
        }
    }
}
