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
    public class CommentApiTest : AuthenticatedTestBase
    {
        [Test]
        public void PostTest()
        {
            var responseResult = WebApiClient.HttpGet(ApiEnvironment.BossComment_Search_Endpoint);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var summary = responseResult.Content.ConvertEntity<IList<BossCommentEntity>>();


            var entity = new BossCommentEntity()
            {
                TargetName = string.Format("Name{0}", TestHelper.GetRndString()),
                TargetIDCard = string.Format("IDcard{0}", TestHelper.GetRndString()),
                TargetJobTitle = string.Format("title{0}", TestHelper.GetRndString()),
                WorkAbility = TestHelper.GetRndNumber(0,5),
                WorkAchievement = TestHelper.GetRndNumber(0, 5),
                WorkManner = TestHelper.GetRndNumber(0, 5),
                Text = string.Format("title{0}", TestHelper.GetRndString()),
                Voice = TestHelper.GetTestImageStream(),
                Images = new string[TestHelper.GetRndNumber(1, 4)]
            };

            for (var i = 0; i < entity.Images.Length; i++)
            {
                entity.Images[i] = TestHelper.GetTestImageStream();
            }

            var responseResult2 = WebApiClient.HttpPost(ApiEnvironment.BossComment_Post_Endpoint, entity);
            Assert.AreEqual(HttpStatusCode.OK, responseResult2.StatusCode);
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
