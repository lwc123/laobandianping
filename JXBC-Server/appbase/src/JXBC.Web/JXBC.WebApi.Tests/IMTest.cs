using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using M2SA.AppGenome;
using JXBC.Passports;
using JXBC.Passports.Providers;
using JXBC.WebCore;

namespace JXBC.WebApi.Tests
{
    public class IMTest
    {
        [Test]
        public void CreateAccountTest()
        {
            var imAccount = new ThirdIMAccount()
            { 
                Platform = "Easemob",
                PlatformAccountId = string.Concat("u-2",Mocks.TestHelper.GetRndNumber(10000,999999)),
                PlatformAccountPassword = string.Concat("12321321", Mocks.TestHelper.GetRndNumber(10000, 999999))
            };

            var provider = ObjectIOCFactory.GetSingleton<IIMProvider>(ModuleEnvironment.IMProviderName);
            Console.WriteLine(provider.ToJson());

            var created = ObjectIOCFactory.GetSingleton<IIMProvider>(ModuleEnvironment.IMProviderName).CreateAccount(imAccount);

            Console.WriteLine(created);
        }
        
        [Test]
        public void aa()
        {
            var passportId = 121353430;
            var platformAccountId = string.Concat("im-", passportId);

            
            var imAccount = ThirdIMAccount.CreateNew(passportId, ModuleEnvironment.IMProviderName, platformAccountId);

            if (null != imAccount && false == imAccount.IsSync)
            {
                var isSync = ObjectIOCFactory.GetSingleton<IIMProvider>(ModuleEnvironment.IMProviderName).CreateAccount(imAccount);
                if (isSync)
                {
                    imAccount.IsSync = isSync;
                    imAccount.Save();
                }
            }
        }
    }
}
