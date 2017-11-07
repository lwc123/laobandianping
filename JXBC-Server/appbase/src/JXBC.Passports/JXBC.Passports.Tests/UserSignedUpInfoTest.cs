using System;
using M2SA.AppGenome.Reflection;
using JXL.Passports.DataRepositories;
using NUnit.Framework;

namespace JXL.Passports.Tests
{
    [TestFixture]
    public class UserSignedUpInfoTest : TestBase
    {
        private string ignoreProperties = "PersistentState";

        [Test]
        public void SaveTest()
        {
            EntityTestHelper.SaveTest<SignedUpInfo, long, ISignedUpInfoRepository>(ignoreProperties);
		}
		
        [Test]
        public void FindByIdTest()
        {
            EntityTestHelper.FindByIdTest<SignedUpInfo, long, ISignedUpInfoRepository>(ignoreProperties);
		}		
		
        [Test]
        public void DeleteTest()
        {
            EntityTestHelper.DeleteTest<SignedUpInfo, long, ISignedUpInfoRepository>(ignoreProperties);
		}		
    }
}