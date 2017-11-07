using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using NUnit.Framework;

namespace JXBC.WebApi.Tests.Mocks
{
    public abstract class TestBase
    {
        [TestFixtureSetUp]
        public virtual void Start()
        {

            Console.WriteLine("ApplicationHost.GetInstance().BeginStart();");
            ApplicationHost.GetInstance().Start();
            ApplicationHost.GetInstance().Exit += new EventHandler(TestBase_OnExit);
        }

        void TestBase_OnExit(object sender, EventArgs e)
        {
            Console.WriteLine("ApplicationHost exit.");
        }

        [TestFixtureTearDown]
        public virtual void Stop()
        {
            Console.WriteLine("ApplicationHost.GetInstance().BeginStop();");
            ApplicationHost.GetInstance().Stop();
            Console.WriteLine("ApplicationHost.GetInstance().StopEnd();");
        }
    }
}
