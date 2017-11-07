using System;
using JXL.Passports.DataRepositories;
using M2SA.AppGenome.Data;
using NUnit.Framework;
namespace JXL.Passports.Tests
{
    [TestFixture]
    public class UserSecurityTest : TestBase
    {
        private string ignoreProperties = "PassportId,PersistentState";

        [Test]
        public void SaveTest()
        {
            var model = CreateNewModel();
            var id = model.Id;

            TestHelper.FillRndProperties(model, ignoreProperties.Split(','));
            model.Id = id;
            var saveResult2 = model.Save();
            Assert.IsTrue(saveResult2);
        }

        [Test]
        public void FindByIdTest()
        {
            var model = CreateNewModel();
            var id = model.Id;

            var repository = RepositoryManager.GetRepository<IUserProfileRepository>(ModuleEnvironment.ModuleName);
            var entry = UserPassport.FindById(id).UserSecurity;
            Assert.NotNull(entry);

            TestHelper.AssertObject(model, entry);
        }

        internal UserSecurity CreateNewModel()
        {
            var userPassport = new UserPassportTest().CreateNewModel();

            var ignores = ignoreProperties.Split(',');
            var model = new UserSecurity();
            TestHelper.FillRndProperties(model, ignores);
            model.PassportId = userPassport.PassportId;
            userPassport.UserSecurity = model;

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);
            return model;
        }
    }
}