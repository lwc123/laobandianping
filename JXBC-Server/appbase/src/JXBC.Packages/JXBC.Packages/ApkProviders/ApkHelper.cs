using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
//using JuXian.CompanyCircle.Web;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;

namespace JXBC.Packages.ApkProviders
{
    public static class ApkHelper
    {
        public static AppVersion LoadAppVersion(string apkFullPath)
        {
            //var apkFile = "/apps/juxian-development.apk";
            //var apkPath = "";// FileHelper.GetFullPath(apkFile);
            var apkInfo = ReadApkFromPath(apkFullPath);

            var apkVersion = new AppVersion()
            {
                PackageName = apkInfo.packageName,
                VersionCode = apkInfo.versionCode.Convert<int>(),
                VersionName = apkInfo.versionName,
                Description = apkInfo.GetMetaData("upgrade:description", string.Empty),
                EnforcedUpgrades = apkInfo.GetMetaData("upgrade:eforced", false),
            };

            if (string.IsNullOrEmpty(apkVersion.Description))
            {
                apkVersion.Description = string.Format("新版本:{0}\r\ndeploy {1}", apkVersion.VersionName, File.GetLastWriteTime(apkFullPath));
            }
            return apkVersion;
        }

        public static ApkInfo ReadApkFromPath(string path)
        {
            string upgradeDescription = null;
            byte[] manifestData = null;
            byte[] resourcesData = null;
            using (ZipInputStream zip = new ZipInputStream(File.OpenRead(path)))
            {
                using (var filestream = new FileStream(path, FileMode.Open, FileAccess.Read))
                {
                    ZipFile zipfile = new ZipFile(filestream);
                    ZipEntry item;
                    while ((item = zip.GetNextEntry()) != null)
                    {
                        if (item.Name.ToLower() == "androidmanifest.xml")
                        {
                            manifestData = loadFileData(zipfile, item);
                        }
                        if (item.Name.ToLower() == "resources.arsc")
                        {
                            resourcesData = loadFileData(zipfile, item);
                        }

                        if (item.Name.ToLower() == "assets/upgrade_description.txt")
                        {
                            var upgradeDescriptionData = loadFileData(zipfile, item);
                            upgradeDescription = Encoding.UTF8.GetString(upgradeDescriptionData);
                        }

                       // var s = loadFileData(zipfile, item);
                    }
                }
            }

            ApkReader apkReader = new ApkReader();
            ApkInfo info = apkReader.extractInfo(manifestData, resourcesData);
            if (false == string.IsNullOrEmpty(upgradeDescription))
                info.metaData.Add("upgrade:description", upgradeDescription);
            return info;
        }

        private static byte[] loadFileData(ZipFile zipfile, ZipEntry item)
        {
            using (Stream stream = zipfile.GetInputStream(item))
            {
                var ms = new MemoryStream() { Capacity = 1024 };
                StreamUtils.Copy(stream, ms, new byte[1024]);
                //var ms = new MemoryStream();
                //StreamUtils.Copy(stream, ms, new byte[1024]);
                return ms.ToArray();
            }
        }
    }
}