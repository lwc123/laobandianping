using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public static class AccountBuilder
    {
        private static readonly string[] Names = ModuleEnvironment.GetValueFromConfig("Random:Names","不戒和尚,长青子,丹青生,风清扬").Split(',');
        private static readonly int AvatarCount = ModuleEnvironment.GetValueFromConfig("Random:AvatarCount", 10);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string RandomName()
        {
            return Names[new Random().Next(Names.Length)];
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string RandomAvatar()
        {
            return string.Format("{0}/default/account_avatar/{1}", ModuleEnvironment.ResourceRoot, string.Format("{0}.png", new Random().Next(0, AvatarCount) + 1));
        }
    }
}
