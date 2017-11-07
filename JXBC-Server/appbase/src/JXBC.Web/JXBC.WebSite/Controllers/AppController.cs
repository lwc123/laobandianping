using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Mvc;
using JXBC.WebCore.ViewModels;
using JXBC.WebCore;
using M2SA.AppGenome;
using JXBC.Packages.ApkProviders;
using M2SA.AppGenome.Logging;
using JXBC.Packages;

namespace JXBC.WebSite.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class AppController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult index(string name)
        {
            return View("error");
        }

        [HttpGet]
        public ActionResult Download(string target = null)
        {
            var userAgent = Request.UserAgent.ToLower();
            if (target == "ios" || userAgent.Contains("iphone") || userAgent.Contains("mac os x"))
            {
                var downloadUrl = AppEnvironment.GetValueFromConfig("appstore:ios", "/");
                return Redirect(downloadUrl);
            }
            else if(Request.UserAgent.ToLower().Contains("micromessenger") || target == "wechat")
            {
                var appVersion = GetLastVersionByAndroid();                
                var downloadUrl = string.Format("http://a.app.qq.com/o/simple.jsp?pkgname={0}", appVersion.PackageName);
                return Redirect(downloadUrl);
            }
            else
            {
                var file = PackageHelper.GetAndroidPackageFile();
                PackageHelper.DownloadFile(PackageHelper.GetAndroidPackageFile(), this.Response);
                return null;
            }
        }

        [HttpGet]
        public ActionResult LastVersion()
        {            
            var appVersion = GetLastVersionByAndroid();
            return Json(appVersion, JsonRequestBehavior.AllowGet);
        }

        private AppVersion GetLastVersionByAndroid()
        {
            var apkFile = PackageHelper.GetAndroidPackageFile();
            var appVersion = PackageManager.GetLastVersion(apkFile);
            appVersion.DownloadUrl = this.Request.Url.AbsoluteUri.ToLower().Replace("LastVersion".ToLower(), "Download");
            return appVersion;
        }
    }
}
