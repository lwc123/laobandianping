using System;
using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXL.Workplace.Tests
{
    [TestFixture]
    public partial class SearchHistoryTest : TestBase
    {
        private string ignoreProperties = "ItemId,PersistentState";
    
        [Test]
        public void SaveTest()
        {
            var model = CreateNewModel();
            var id = model.Id;

            TestHelper.FillRndProperties(model, ignoreProperties.Split(','));
            model.Id = id;
            
            //modify
            var saveResult2 = model.Save();
            Assert.IsTrue(saveResult2);
        }
        
        [Test]
        public void FindByIdTest()
        {
            var model = CreateNewModel();
            var id = model.Id;
            
            var entry = SearchHistory.FindById(id);
            Assert.NotNull(entry);

            TestHelper.AssertObject(model, entry);

            
        }
        

    
        
        [Test]
        public void DeleteTest()
        {
            var model = CreateNewModel();
            var id = model.Id;
            
            var saveResult = model.Save();
            Assert.IsTrue(saveResult);

            model.Delete();

            var entry = SearchHistory.FindById(model.Id);
            Assert.Null(entry);
        }
        
        internal SearchHistory CreateNewModel()
        {
            var ignores = ignoreProperties.Split(',');
            var model = new SearchHistory();
            TestHelper.FillRndProperties(model, ignores);

            var saveResult = model.Save();
            Assert.IsTrue(saveResult);
            return model;
        }        
    }
}