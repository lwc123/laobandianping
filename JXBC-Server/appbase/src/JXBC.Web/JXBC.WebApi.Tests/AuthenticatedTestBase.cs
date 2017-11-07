using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using NUnit.Framework;
using System.IO;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.WebApi.Tests.Mocks;
using JXBC.Passports;

namespace JXBC.WebApi.Tests
{
    public class AuthenticatedTestBase : ApiTestBase
    {
        [TestFixtureSetUp]
        public override void Start()
        {
            base.Start();
            SignIn();
        }        
    }
}
