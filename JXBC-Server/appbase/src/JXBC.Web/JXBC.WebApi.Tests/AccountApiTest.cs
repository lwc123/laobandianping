using System;
using System.Net;
using System.Collections.Generic;
using System.IO;
using NUnit.Framework;
using JXBC.Passports;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.WebApi.Tests.Mocks;
using System.Configuration;

namespace JXBC.WebApi.Tests
{
    [TestFixture]
    public class AccountApiTest : ApiTestBase
    {
        [Test]
        public void SignUpTest()
        {
            Console.WriteLine(ConfigurationManager.AppSettings["app:TestValidationCode"]);
            var entity = ApiTestBase.SignUp();
            Assert.IsNotNull(entity);
        }

        [Test]
        public void InviteSignUpTest()
        {
            Console.WriteLine(ConfigurationManager.AppSettings["app:TestValidationCode"]);
            var accountSign = new AccountSign()
            {
                MobilePhone = string.Format("199{0}", new Random().Next(12345678, 98765432)),
                Password = string.Format("pwd{0}", new Random().Next(12345678, 98765432)),
                InviteCode = string.Format("Invite-{0}", Guid.NewGuid().ToString("N"))
            };
            var entity = ApiTestBase.SignUp(accountSign);
            Assert.IsNotNull(entity);
        }

        [Test]
        public void SignInTest()
        {
            var accountSign = new AccountSign()
            {
                MobilePhone = string.Format("171{0}", new Random().Next(12345678, 98765432)),
                Password = string.Format("pwd{0}", new Random().Next(12345, 98765))
            };

            var entity = ApiTestBase.SignUp(accountSign);

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_SignIn_Endpoint, accountSign);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Console.WriteLine(responseResult.Content);

            var signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.Success, signResult.SignStatus);
            Assert.IsNotNull(signResult.Account);

            // Error password
            accountSign.Password += "000";
            responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_SignIn_Endpoint, accountSign);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.InvalidPassword, signResult.SignStatus);
        }

        [Test]
        public void SignInByTokenTest()
        {
            //TODO: SignInByTokenTest
        }

        [Test]
        public void BindThirdAccountTest()
        {
            var thirdPassport = new ThirdPassport() { Platform = "apitest", PlatformPassportId = Guid.NewGuid().ToString("N") };
            thirdPassport.PassportInfo = thirdPassport.ToJson();
            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_BindThirdPassport_Endpoint, thirdPassport);
            if (HttpStatusCode.OK != responseResult.StatusCode)
                Console.WriteLine(responseResult.Content);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);

            var signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.Success, signResult.SignStatus);
            Assert.IsNotNull(signResult.Account);
            Assert.IsTrue(signResult.Account.PassportId > 0);

            responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_BindThirdPassport_Endpoint, thirdPassport);
            if (HttpStatusCode.OK != responseResult.StatusCode)
                Console.WriteLine(responseResult.Content);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);

            var signResult2 = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult2);
            Assert.AreEqual(SignStatus.Success, signResult2.SignStatus);
            Assert.IsNotNull(signResult2.Account);
            Assert.AreEqual(signResult.Account.PassportId, signResult2.Account.PassportId);
        }

        [Test]
        public void ExistsMobilePhoneTest()
        {
            var accountSign = new AccountSign()
            {
                MobilePhone = string.Format("171{0}", new Random().Next(12345678, 98765432)),
                Password = string.Format("pwd{0}", new Random().Next(12345, 98765))
            };
            var responseResult = WebApiClient.HttpGet(ApiEnvironment.Account_ExistsMobilePhone_Endpoint + "?phone=" + accountSign.MobilePhone);
            if (HttpStatusCode.OK != responseResult.StatusCode)
                Console.WriteLine(responseResult.Content);
            Assert.AreEqual("false", responseResult.Content);

            ApiTestBase.SignUp(accountSign);

            responseResult = WebApiClient.HttpGet(ApiEnvironment.Account_ExistsMobilePhone_Endpoint + "?phone=" + accountSign.MobilePhone);
            if (HttpStatusCode.OK != responseResult.StatusCode)
                Console.WriteLine(responseResult.Content);
            Assert.AreEqual("true", responseResult.Content);
        }
        [Test]
        public void ChangeProfileTest()
        {
            SignIn();
        }

        [Test]
        public void ResetPasswordTest()
        {
            var accountSign = new AccountSign() { MobilePhone = "18900999900", Password = "123456", ValidationCode="1232" };
            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_ResetPassword_Endpoint, accountSign);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Console.WriteLine(responseResult.Content);

            var signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.InvalidValidationCode, signResult.SignStatus);

            accountSign = new AccountSign() { MobilePhone = "18900999900", Password = "123456", ValidationCode = "FRUIT1204" };
            responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_ResetPassword_Endpoint, accountSign);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            signResult = responseResult.Content.ConvertEntity<AccountSignResult>();
            Assert.IsNotNull(signResult);
            Assert.AreEqual(SignStatus.InvalidMobilePhone, signResult.SignStatus);


            responseResult = WebApiClient.HttpPost(ApiEnvironment.Account_ResetPassword_Endpoint, accountSign);

        }

        [Test]
        public void ChangeAvatarTest()
        {
            SignIn();
            FileStream fs = File.OpenRead(@"E:\刘亮\项目\meinv.jpg"); //OpenRead
            int filelength = 0;
            filelength = (int)fs.Length; //获得文件长度 
            Byte[] image = new Byte[filelength];                                                 //建立一个字节数组 
            fs.Read(image, 0, filelength);                                                        //按字节流读取 
            string s = Convert.ToBase64String(image);
            var dic = new Dictionary<string, string>();
            dic.Add("AvatarStream", s);
            dic.Add("FileName", "meinv");
            //var avatar = new ProfileAvatar() { AvatarStream = s, FileName = "meinv" };
            //var resutl = WebApiClient.HttpPost("/Profile/ChangeAvatar", dic);
        }
        [Test]
        public void ClearUserTest()
        {
            SignIn();
            var mobilePhone="18210145561";
            var otherMobilePhone = mobilePhone.Substring(0, 7) + new Random().Next(1000, 9999);
            //var resutl = WebApiClient.HttpPost("/Account/ClearUser?mobilePhone=18210145561", "");
            // var list = resutl.Content.ConvertEntity<IList<AccountProfile>>();
        }
        [Test]
        public void GetGratuityRecord()
        {
            SignIn();
            var resutl = WebApiClient.HttpGet("/Profile/GetGratuityRecord");
        }
    }
}
