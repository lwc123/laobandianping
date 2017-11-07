using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using JXBC.WebCore;
using M2SA.AppGenome;

namespace JXBC.WebSite
{
    public class PackageHelper
    {
        public static void DownloadFile(string filePath, HttpResponseBase response)
        {
            var fullPath = FileHelper.GetFullPath(filePath);
            var isExist = File.Exists(fullPath);
            if (isExist)
            {
                response.Clear();
                response.ContentType = "application/octet-stream";
                response.ContentEncoding = Encoding.UTF8;
                response.AppendHeader("Content-Disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode(Path.GetFileName(filePath), Encoding.UTF8));
                // Response.AppendHeader("Content-Length", fInfo.Length.ToString());
                response.WriteFile(filePath);
            }
        }
        public static string GetAndroidPackageFile() 
        {
            var fileName = AppEnvironment.GetValueFromConfig<string>("package:android", "com.juxian.ling.apk");
            var packageFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Packages", fileName);
            return packageFile;
        }
    }
}