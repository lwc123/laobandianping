using System;
using System.Net;
using System.Collections.Generic;
using System.IO;
using NUnit.Framework;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.WebApi.Tests.Mocks;
using JXBC.Passports;

namespace JXBC.WebApi.Tests
{
    [TestFixture]
    public class ConsultantApiTest : AuthenticatedTestBase
    {

        [Test]
        public void OpenCareerServiceTest()
        {
            var accountSign = new AccountSign()
            {
                MobilePhone = "181"+TestHelper.GetRndNumber(10000000, 90000000).ToString(),
                Password = string.Format("jxl12345", new Random().Next(12345, 98765))
            };

            var signResult = SignUp(accountSign);
            if (signResult.SignStatus == SignStatus.DuplicateMobilePhone)
            {
                Console.WriteLine("{0} => {1}", accountSign.MobilePhone, signResult.ErrorMessage);
                return;
            }

            var accountResult = WebApiClient.HttpPost(ApiEnvironment.Consultant_OpenCareerService_Endpoint, new OrganizationProfile());
            Console.WriteLine("OpenCareerService => {0}", accountResult.Content);
        }

        [Test]
        public void ConsultantSummaryTest()
        {
            var responseResult = WebApiClient.HttpGet(ApiEnvironment.Consultant_Summary_Endpoint);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var summary = responseResult.Content.ConvertEntity<ConsultantSummary>();
            Assert.IsNotNull(summary.Profile);
            Assert.IsTrue(summary.Profile.PassportId > 0);
        }

        [Test]
        public void ChangeProfileTest()
        {
            var entity = new OrganizationProfile();            
            TestHelper.FillRndProperties(entity, "Id");
            entity.Avatar = null;

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Consultant_ChangeProfile_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);
            
            Assert.IsTrue(responseResult.Content.ConvertEntity<bool>());
        }

        [Test]
        public void ChangeAvatarTest()
        {
            var entity = new AvatarEntity();
            entity.AvatarStream = TestHelper.GetTestImageStream();

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.User_ChangeAvatar_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);
            
            Assert.IsTrue(responseResult.Content.ConvertEntity<string>().StartsWith("http://"));
            Console.WriteLine(responseResult.Content);
        }

        [Test]
        public void ApplyAuthenticationTest()
        {
            var entity = new OrganizationProfile();
            entity.Identity = TestHelper.GetRndString();
            entity.AuthenticationImages = new string[TestHelper.GetRndNumber(1, 4)];
            for (var i=0; i< entity.AuthenticationImages.Length; i++)
            {
                entity.AuthenticationImages[i] = TestHelper.GetTestImageStream();
            }

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Consultant_ApplyAuthentication_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var images = responseResult.Content.ConvertEntity<string[]>();
            Assert.IsNotNull(images);

            Assert.AreEqual(images.Length, entity.AuthenticationImages.Length);
        }
    }
}
