using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JXBC.Packages
{
    public class AppVersion
    {
        public string PackageName { get; set; }
        public int VersionCode { get; set; }
        public string VersionName { get; set; }
        public string Description { get; set; }
        public string DownloadUrl { get; set; }
        public bool EnforcedUpgrades { get; set; }
    }
}