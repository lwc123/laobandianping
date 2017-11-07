using System;
using JXL.Passports.Security;
using M2SA.AppGenome.Reflection;
using NUnit.Framework;
using System.Linq;

namespace JXL.Passports.Tests
{
    [TestFixture]
    public class MemberShipTest : TestBase
    {
        [Test]
        public void SignUpTest()
        {
            var password = string.Format("P{0}", TestHelper.GetRndNumber(10000, 90000));
            var passport = SignUp(password);
        }

        [Test]
        public void SignInTest()
        {
            var password = string.Format("P{0}", TestHelper.GetRndNumber(10000, 90000));
            var passport = SignUp(password);
            var mobilePhone = passport.MobilePhone;

            Assert.IsTrue(MemberShip.SignIn(mobilePhone, password));

            UserPassport newPassport = null;
            var signInResult = MemberShip.SignIn(mobilePhone, password, out newPassport);
            TestHelper.AssertObject(passport, newPassport);
        }

        [Test]
        public void ChangePasswordTest()
        {
            var password = string.Format("P{0}", TestHelper.GetRndNumber(10000, 90000));
            var passport = SignUp(password);
            
            Assert.IsTrue(MemberShip.SignIn(passport.MobilePhone, password));

            var newPassword = string.Format("NP{0}", TestHelper.GetRndNumber(10000, 90000));
            var chanedResult = MemberShip.ChangePassword(passport.PassportId, newPassword);
            Assert.IsTrue(chanedResult);

            Assert.IsFalse(MemberShip.SignIn(passport.MobilePhone, password));
            Assert.IsTrue(MemberShip.SignIn(passport.MobilePhone, newPassword));
        }

        [Test]
        public void UserProfileTest()
        {
            var password = string.Format("P{0}", TestHelper.GetRndNumber(10000, 90000));
            var passport = SignUp(password);
            var profile = passport.Profile;
            Assert.IsNotNull(profile);
            Assert.IsTrue(profile is UserProfile);

            Assert.IsNull(profile.RealName);
            
            TestHelper.FillRndProperties(profile, "Passport,PassportId,PersistentState,CreatedTime".Split(','));
            Assert.IsNotNull(profile.RealName);

            Assert.IsTrue(profile.Save());

            var newPassport = UserPassport.FindById(passport.PassportId);
            Assert.IsNotNull(newPassport);

            var newPofile = newPassport.Profile;
            Assert.IsNotNull(newPofile);
            Assert.IsTrue(newPofile is UserProfile);
            Assert.AreEqual(profile.RealName, newPofile.RealName);


            TestHelper.FillRndProperties(passport.Profile, "Passport,PassportId,PersistentState,CreatedTime".Split(','));
            Assert.IsTrue(profile.Save());
            Assert.AreNotEqual(profile.RealName, newPofile.RealName);

        }

        [Test]
        public void ConsultantProfileTest()
        {
            var password = string.Format("P{0}", TestHelper.GetRndNumber(10000, 90000));
            var passport = SignUp(password);
            var profile = passport.Profile;
            Assert.IsNotNull(profile);
            Assert.IsTrue(profile is UserProfile);

            TestHelper.FillRndProperties(passport.Profile, "Passport,PassportId,PersistentState,CreatedTime".Split(','));
            Assert.IsTrue(profile.Save());

            var consultantProfile = new ConsultantProfile();
            TestHelper.FillRndProperties(consultantProfile, "Passport,PassportId,PersistentState,CreatedTime".Split(','));
            var opened = MemberShip.OpenCareerService(passport, consultantProfile);
            Assert.IsTrue(opened);

            Assert.AreNotEqual(profile.Gender, consultantProfile.Gender);
            Assert.AreNotEqual(profile.Birthday, consultantProfile.Birthday);
            Assert.AreNotEqual(profile.RealName, consultantProfile.RealName);

            var newPassport = UserPassport.FindById(passport.PassportId);
            Assert.IsNotNull(newPassport);

            var newPofile = newPassport.Profile;
            Assert.IsNotNull(newPofile);
            Assert.IsTrue(newPofile is ConsultantProfile);

            Assert.AreEqual(profile.Gender, newPofile.Gender);
            Assert.AreEqual(profile.Birthday, newPofile.Birthday);
            Assert.AreEqual(consultantProfile.RealName, newPofile.RealName);
            Assert.AreNotEqual(profile.RealName, newPofile.RealName);            
        }

        UserPassport SignUp(string password)
        {
            var phone = string.Format("17{0}", TestHelper.GetRndNumber(100000000, 900000000));
            
            var signedUpInfo = new SignedUpInfo();
            signedUpInfo.SignedUpIp = "127.0.0.1";
            var status = SignUpStatus.Error;
            UserPassport passport = MemberShip.SignUp(phone, password, signedUpInfo, out status);
            Assert.AreEqual(SignUpStatus.Success, status);

            Console.WriteLine("SignUp({0},{1}) => {2}", phone, password, passport.PassportId);
            return passport;
        }
    }
}
