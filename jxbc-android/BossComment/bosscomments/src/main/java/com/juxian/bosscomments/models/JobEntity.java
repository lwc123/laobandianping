package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/26 13:49]
 * @Version: [v1.0]
 */
public class JobEntity extends BaseEntity {
    public long JobId;
    public long CompanyId;
    public long PassportId;
    public String JobName;
    public double SalaryRangeMin;
    public double SalaryRangeMax;
    public String ExperienceRequire;
    public String ExperienceRequireText;
    public String EducationRequire;
    public String EducationRequireText;
    public String JobCity;
    public String JobCityText;
    public String JobLocation;
    public String JobDescription;
    public String ContactEmail;
    public String ContactNumber;
    public int DisplayState;
    public Date CreatedTime;
    public Date ModifiedTime;
    public MemberEntity CompanyMember;
    public CompanyEntity Company;
}
