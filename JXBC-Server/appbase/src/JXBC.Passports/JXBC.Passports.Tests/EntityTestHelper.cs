using System;
using NUnit.Framework;
using M2SA.AppGenome.Data;
using JXL.Passports.DataRepositories;

namespace JXL.Passports.Tests
{
    public static class EntityTestHelper 
    {
        public static void SaveTest<TEntity, TId, TRepository>(string ignoreProperties)
            where TEntity : IEntity<TId> 
            where TRepository : IRepository<TEntity, TId> 
        {
            var ignores = ignoreProperties.Split(',');
            var repository = RepositoryManager.GetRepository<TRepository>(ModuleEnvironment.ModuleName);
            dynamic model = repository.CreateNew();
            TestHelper.FillRndProperties(model, ignores);

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);
            TId id = model.Id;

            TestHelper.FillRndProperties(model, ignores);
            model.Id = id;
            var saveResult2 = model.Save();
            Assert.IsTrue(saveResult2);
        }


        [Test]
        public static void FindByIdTest<TEntity, TId, TRepository>(string ignoreProperties)
            where TEntity : IEntity<TId> 
            where TRepository : IRepository<TEntity, TId> 
        {
            var ignores = ignoreProperties.Split(',');
            var repository = RepositoryManager.GetRepository<TRepository>(ModuleEnvironment.ModuleName);
            dynamic model = repository.CreateNew();
            TestHelper.FillRndProperties(model, ignores);

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);

            TId id = model.Id;
            var entry = repository.FindById(id);
            Assert.NotNull(entry);

            TestHelper.AssertObject(model, entry);
        }

        [Test]
        public static void DeleteTest<TEntity, TId, TRepository>(string ignoreProperties)
            where TEntity : IEntity<TId>
            where TRepository : IRepository<TEntity, TId> 
        {
            var ignores = ignoreProperties.Split(',');
            var repository = RepositoryManager.GetRepository<TRepository>(ModuleEnvironment.ModuleName);
            dynamic model = repository.CreateNew();
            TestHelper.FillRndProperties(model, ignores);

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);

            model.Delete();

            TId id = model.Id;
            var entry = repository.FindById(id);
            Assert.Null(entry);
        }
    }
}