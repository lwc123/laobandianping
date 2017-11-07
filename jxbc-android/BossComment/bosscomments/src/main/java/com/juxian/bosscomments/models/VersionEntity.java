package com.juxian.bosscomments.models;

/**
 * Created by Tam on 2017/3/11.
 */
public class VersionEntity extends BaseEntity {
    public long VersionId;
    public String AppType;//系统，android或ios
    public int UpgradeType; // 1最新不提示   2建议更新，可不更新    3强制更新
    public String VersionCode;//当前版本号 ,
    public String VersionName;// 版本名称 ,
    public String LowestSupportVersion;// 最低支持版本号 , ,
    public String Description;// 升级说明  ,
    public String DownloadUrl;// 下载地址   ,
    public String CreatedTime;// 发布时间   ,
    public String ModifiedTime;// 修改时间   ,


}
