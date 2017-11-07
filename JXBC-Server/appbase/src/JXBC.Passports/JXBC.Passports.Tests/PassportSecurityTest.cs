using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using JXL.Passports.Security;
using M2SA.AppGenome;
using NUnit.Framework;


namespace JXL.Passports.Tests
{
    [TestFixture]
    public class PassportSecurityTest : TestBase
    {
        [Test]
        public void MD5SecurityStrategyTest()
        {
            var oldHash = "A1AFD14FE75EF537F43F5C27A4ECAFB";
            var email = "123@123.com";
            var userName = "123@123.com";
            var password = "123456";

            var userPassport = new UserPassport() { UserSecurity = new UserSecurity() };
            userPassport.Email = email;
            userPassport.UserName = userName;
            userPassport.UserSecurity.HashAlgorithm = "MD5";
            userPassport.UserSecurity.PasswordSalt = "829534";

            var securityStrategy = PassportSecurityProvider.LoadSecurityStrategy(userPassport.UserSecurity.HashAlgorithm);

            var hash = securityStrategy.HashPassword(password, userPassport);
            userPassport.UserSecurity.Password = hash;
            Assert.IsTrue(userPassport.UserSecurity.Password.Length > password.Length);
            Console.WriteLine("{0} => {1}", password, hash);

            var verified = securityStrategy.Verify(password, userPassport);
            Assert.IsTrue(verified);

            Assert.AreEqual(oldHash, hash);
        }

        
    }
}
