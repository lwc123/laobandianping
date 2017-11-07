using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using JXL.Passports.DataRepositories;
using JXL.Passports.Security;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using NUnit.Framework;


namespace JXL.Passports.Tests
{
    [TestFixture]
    public class UserPassportTest : TestBase
    {
        private string ignoreProperties = "PassportId,PersistentState";

        [Test]
        public void SaveTest()
        {
            EntityTestHelper.SaveTest<UserPassport, long, IUserPassportRepository>(ignoreProperties);
        }

        [Test]
        public void FindByIdTest()
        {
            var entry = UserPassport.FindById(2);
           // EntityTestHelper.FindByIdTest<UserPassport, long, IUserPassportRepository>(ignoreProperties);
        }

        [Test]
        public void FindByIdsTest()
        {
            var ids = new List<long>() {1, 2, 4};
            var list = UserPassport.FindByIds(ids);
            Assert.IsNotNull(list);
            Assert.AreEqual(list.Count, ids.Count);
        }

        [Test]
        public void DeleteTest()
        {
            var model = CreateNewModel();
            var id = model.Id;

            model.Delete();

            var entry = UserPassport.FindById(id);
            Assert.IsNotNull(entry);
            Assert.AreEqual(PassportStatus.Cancellation, entry.PassportStatus);
        }

        internal UserPassport CreateNewModel()
        {
            var ignores = ignoreProperties.Split(',');
            var model = new UserPassport();
            TestHelper.FillRndProperties(model, ignores);

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);
            return model;
        }
    }
}
