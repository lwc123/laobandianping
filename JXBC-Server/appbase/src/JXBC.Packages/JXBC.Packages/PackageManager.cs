using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using JXBC.Packages.ApkProviders;
using M2SA.AppGenome;
using Newtonsoft.Json;

namespace JXBC.Packages
{
    public class PackageManager
    {
        private static readonly object SyncObject = new object();
        private static PackageManager Manager = null;

        public static AppVersion GetLastVersion(string apkFile)
        {
            if (null != Manager) return Manager.LoadAppVersion();
            lock (SyncObject)
            {
                if (null != Manager) return Manager.LoadAppVersion();

                Manager = new PackageManager(apkFile);
                return Manager.LoadAppVersion();
            }
        }

        private readonly string apkFile = null;
        private readonly string versionFile = null;
        private AppVersion lastAppVersion = null;
        private FileSystemWatcher versionWatcher;

        private PackageManager(string apkFile)
        {
            this.apkFile = FileHelper.GetFullPath(apkFile);
            this.versionFile = Path.ChangeExtension(this.apkFile, "json");
            this.NotifyFileChanged();
        }

        private AppVersion LoadAppVersion()
        {
            if (null == this.lastAppVersion)
                this.lastAppVersion = this.LoadVersionFromApkFile();
            return lastAppVersion;
        }

        private AppVersion LoadVersionFromApkFile()
        {
            var appVersion = ApkHelper.LoadAppVersion(this.apkFile);
            var fileVesion = this.LoadVersionFromVersionFile();
            if (null != fileVesion
                && fileVesion.VersionCode == appVersion.VersionCode && fileVesion.VersionName == appVersion.VersionName)
                appVersion = fileVesion;
            else
                this.UpdateVersionFile();
            return appVersion;
        }

        private void UpdateVersionFile()
        {
            var versionInfo = JsonConvert.SerializeObject(this.lastAppVersion, new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore

            });

            var tryTimes = 3;
            for (var i = 0; i < tryTimes; i++)
            {
                try
                {
                    File.WriteAllText(this.versionFile, versionInfo);
                    break;
                }
                catch
                {
                    Thread.Sleep(1500);
                    continue;
                }
            }
        }

        private AppVersion LoadVersionFromVersionFile()
        {
            try
            {
                using (var textReader = File.OpenText(this.versionFile))
                {
                    var versionInfo = textReader.ReadToEnd();
                    var appVersion = JsonConvert.DeserializeObject<AppVersion>(versionInfo);
                    return appVersion;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
        private void NotifyFileChanged()
        {
            var pathInfo = this.apkFile.Split(Path.DirectorySeparatorChar);

            this.versionWatcher = new FileSystemWatcher();
            this.versionWatcher.Path = string.Join(Path.DirectorySeparatorChar.ToString(), pathInfo, 0, pathInfo.Length - 1);
            //this.versionWatcher.Filter = "*.*";
            this.versionWatcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.CreationTime | NotifyFilters.LastWrite | NotifyFilters.Size;
            this.versionWatcher.Created += this.fileSystemWatcher_Changed;
            this.versionWatcher.Changed += this.fileSystemWatcher_Changed;
            this.versionWatcher.Deleted += this.fileSystemWatcher_Changed;
            this.versionWatcher.Renamed += this.fileSystemWatcher_Changed;

            this.versionWatcher.EnableRaisingEvents = true;
        }

        void fileSystemWatcher_Changed(object sender, FileSystemEventArgs e)
        {
            Thread.Sleep(1500);

            if (e.FullPath == this.versionFile)
            {
                var fileVesion = this.LoadVersionFromVersionFile();
                if (null != fileVesion)
                {
                    this.lastAppVersion = fileVesion;
                    return;
                }
            }

            this.lastAppVersion = this.LoadVersionFromApkFile();
        }
    }
}
