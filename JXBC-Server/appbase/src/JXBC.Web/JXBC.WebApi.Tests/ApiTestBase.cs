using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using NUnit.Framework;
using System.IO;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.WebApi.Tests.Mocks;
using JXBC.Passports;
using System.Configuration;
using M2SA.AppGenome.Reflection;

namespace JXBC.WebApi.Tests
{
    public class ApiTestBase : TestBase
    {
        public static readonly object Sync = new object();
        public static bool HasAccount = false;

        [TestFixtureSetUp]
        public override void Start()
        {
            base.Start();
            lock (Sync)
            {
                if (false == HasAccount)
                {
                    var entity = CreateNew();
                    Assert.IsNotNull(entity);
                    HasAccount = true;
                }
            }
        }

        public static AccountSignResult SignIn()
        {
            var accountSign = new AccountSign() { MobilePhone = "18900000001", Password = "123456" };

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_SignIn_Endpoint, accountSign);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);

            var signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.Success, signResult.SignStatus);

            return signResult;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static AccountEntity CreateNew()
        {
            var accountInfo = new ClientDevice()
            {
                DeviceKey = Guid.NewGuid().ToString("N"),
                Brand = "test:Brand",
                Device = "test:Device",
                Product = "test:Product"
            };
            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_CreateNew_Endpoint, accountInfo);
            if (responseResult.StatusCode != HttpStatusCode.OK)
            {
                Console.WriteLine(responseResult.StatusCode);
                Console.WriteLine(responseResult.Content);
            }

            var entity = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(entity);
            Assert.AreEqual(SignStatus.Success, entity.SignStatus);
            Assert.IsNotNull(entity.Account);
            Assert.IsNotNull(entity.Account.Token);
            Assert.IsNotNull(entity.Account.Token.AccessToken);

            WebApiClient.SaveAuthToken(entity.Account.Token.AccessToken);
            Console.WriteLine("NewAccount:\t{0}\r\n", responseResult.Content);
            return entity.Account;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static AccountSignResult SignUp()
        {
            var accountSign = new AccountSign()
            {
                MobilePhone = string.Format("199{0}", new Random().Next(12345678, 98765432)),
                Password = string.Format("pwd{0}", new Random().Next(12345678, 98765432)),
                SelectedProfileType = ProfileType.OrganizationProfile
            };
            return SignUp(accountSign);
        }

        public static AccountSignResult SignUp(AccountSign accountSign)
        {
            accountSign.ValidationCode = ConfigurationManager.AppSettings["app:TestValidationCode"];
            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_SignUp_Endpoint, accountSign);
            Console.WriteLine("[{0}]{1}", responseResult.StatusCode, responseResult.Content);
            var entity = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(entity);
            if(entity.SignStatus != SignStatus.DuplicateMobilePhone)
            {
                Assert.IsNotNull(entity.Account);
                Assert.IsNotNull(entity.Account.Token);
                Assert.IsTrue(entity.Account.PassportId > 0);
            }
           
            return entity;
        }
    }
}
