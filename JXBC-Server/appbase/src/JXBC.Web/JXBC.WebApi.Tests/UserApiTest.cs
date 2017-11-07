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
    public class UserApiTest : AuthenticatedTestBase
    {
        [Test]
        public void UserSummaryTest()
        {
            var responseResult = WebApiClient.HttpGet(ApiEnvironment.User_Summary_Endpoint);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var summary = responseResult.Content.ConvertEntity<UserSummary>();
            Assert.IsTrue(null != summary.UserProfile);
        }

        [Test]
        public void ChangeProfile()
        {
            var entity = new UserProfile();            
            TestHelper.FillRndProperties(entity, "Id");
            entity.Nickname = "nikc-ccc";

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.User_ChangeProfile_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);
            
            Assert.IsTrue(responseResult.Content.ConvertEntity<bool>());
        }

        [Test]
        public void ChangeAvatar()
        {
            var entity = new AvatarEntity();
            entity.AvatarStream = TestHelper.GetTestImageStream();

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.User_ChangeAvatar_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);
            
            Assert.IsTrue(responseResult.Content.ConvertEntity<string>().StartsWith("http://"));
            Console.WriteLine(responseResult.Content);
        }
    }
}
