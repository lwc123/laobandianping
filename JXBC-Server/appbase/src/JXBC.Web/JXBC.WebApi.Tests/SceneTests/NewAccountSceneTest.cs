using System;
using System.Collections.Generic;
using JXBC.WebApi.Tests.Mocks;
using NUnit.Framework;

namespace JXBC.WebApi.Tests.SceneTests
{
    [TestFixture]
    public class NewAccountSceneTest : ApiTestBase
    {
        [Test]
        public void NewAccountFlowTest()
        {
            var signResult = SignUp();

            Assert.IsNotNull(signResult);
            Assert.IsNotNull(signResult.Account);
            Assert.IsTrue(signResult.Account.PassportId > 0);
        }
    }
}
