package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2016/12/9.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/9 15:39]
 * @Version: [v1.0]
 */
public class ArchiveCommentEntity extends BaseEntity {

    public static final int ArchiveComment_AttestationStatus_None = 0;
    public static final int ArchiveComment_AttestationStatus_Submited = 1;
    public static final int ArchiveComment_AttestationStatus_Passed = 2;
    public static final int ArchiveComment_AttestationStatus_Rejected = 9;

    public long CompanyId;
    public long ArchiveId; //档案
    public long CommentId;
    public String OperateRealName;
    public long PresenterId; //提交者
    public long ModifiedId;  //修改人 ,
    public int CommentType;  //是否离任报告，0否，1是 ,
    public int AuditStatus;  //审核状态，0未审核，1审核中，2已审核，9被退回 ,
    public String StageYear;  //评价年份 ,
    public String StageSection;//年份区间 ,
    public String StageSectionText;
    public int WorkAbility;
    public int WorkAttitude;
    public int WorkPerformance;
    public String WorkComment; //评价文字
    public String DimissionSalary;
    public Date DimissionTime;
    public String DimissionReason;
    public String DimissionReasonText;
    public String DimissionSupply;
    public int HandoverTimely;
    public int HandoverOverall;
    public int HandoverSupport;
    public String WantRecall;
    public String WantRecallText;
    public String[] WorkCommentImages;
    public int WorkCommentVoiceSecond;
    public String WorkCommentVoice;
    public List<Long> AuditPersons;
    public List<MemberEntity> AuditPersonList;// 返回审核人列表
    public String RejectReason;//驳回原因
    public Date ModifiedTime;
    public Date CreatedTime;  //评价时间
    public EmployeArchiveEntity EmployeArchive;
    public boolean IsSendSms;
}
