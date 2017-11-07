package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.JobEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Created by nene on 2016/12/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/26 13:54]
 * @Version: [v1.0]
 */
public class JobRepository {

    /**
     * 获取授权人管理列表
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static List<JobEntity> getJobList(long CompanyId, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Job_JobList_Endpoint, CompanyId, pageIndex, ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<JobEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<JobEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 发布职位
     *
     * @param entity
     * @return
     */
    public static long addPosition(JobEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Job_Add_Endpoint, entity,
                Long.class);
        if (responseResult.isSuccess()) {
            return (Long) responseResult.result;
        } else {
            return 0;
        }
    }

    /**
     * 编辑职位
     *
     * @param entity
     * @return
     */
    public static boolean updatePosition(JobEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Job_update_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 获取职位详情
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static JobEntity getJobDetail(long CompanyId, long JobId) {
        String apiUrl = String.format(ApiEnvironment.Job_Detail_Endpoint, CompanyId, JobId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, JobEntity.class);
        if (responseResult.isSuccess()) {
            return (JobEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 关闭职位
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static boolean closeJobTitle(long CompanyId, long JobId) {
        String apiUrl = String.format(ApiEnvironment.Job_CloseJob_Endpoint, CompanyId, JobId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 开启职位
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static boolean openJobTitle(long CompanyId, long JobId) {
        String apiUrl = String.format(ApiEnvironment.Job_OpenJob_Endpoint, CompanyId, JobId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 职位搜索
     *
     * @param JobName
     * @param JobCity
     * @param Industry
     * @param SalaryRange
     * @param Page
     * @param Size
     * @return
     */
    public static List<JobEntity> jobSearch(String JobName, String JobCity, String Industry, String SalaryRange, int Page, int Size) {
        String JobNameEncode = JobName;
        String JobCityEncode = JobCity;
        String IndustryEncode = Industry;
        try {
            JobNameEncode = URLEncoder.encode(JobName, "UTF-8");
            JobCityEncode = URLEncoder.encode(JobCity, "UTF-8");
            IndustryEncode = URLEncoder.encode(Industry, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.JobQuery_Search_Endpoint, JobNameEncode, JobCityEncode, IndustryEncode, SalaryRange, Page, Size);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<JobEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<JobEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 职位详情
     *
     * @param JobId
     * @return
     */
    public static JobEntity jobDetail(long JobId) {
        String apiUrl = String.format(ApiEnvironment.JobQuery_Detail_Endpoint, JobId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, JobEntity.class);
        if (responseResult.isSuccess()) {
            return (JobEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 关闭职位
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public static boolean deleteJobTitle(long CompanyId, long JobId) {
        String apiUrl = String.format(ApiEnvironment.Job_Delete_Endpoint, CompanyId, JobId);
        Response<?> responseResult = WebApiClient.getSingleton().http(Request.Method.POST,apiUrl,null, Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }
}
