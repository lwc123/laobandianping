package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.juxian.bosscomments.models.BossCommentEntity;
import com.juxian.bosscomments.models.TargetEmploye;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Created by nene on 2016/11/1.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.repositories]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/1 17:55]
 * @Version: [v1.0]
 */
public class BossCommentRepository {

    /**
     * 获取我的点评列表信息
     */
//    public static List<BossCommentEntity> GetMyBossComments() {
//        String apiUrl = String.format(ApiEnvironment.BossComment_Search_Endpoint, industry, grade,
//                sortType, pageIndex, ApiEnvironment.OnceLoadItemCount);
//        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
//                apiUrl, new TypeToken<List<BossCommentEntity>>() {
//                }.getType());
//        if (responseResult.isSuccess()) {
//            return (List<BossCommentEntity>) responseResult.result;
//        } else {
//            return null;
//        }
//    }

    /**
     * 搜索某个员工的多条评价
     */
    public static TargetEmploye GetBossCommentSearch(String idCard, String employeeName, String company, int pageIndex) {
        String employeeNameEncode = employeeName;
        String companyEncode = company;
        try {
            employeeNameEncode = URLEncoder.encode(employeeName, "UTF-8");
            companyEncode = URLEncoder.encode(company, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.BossComment_Search_Endpoint, idCard, employeeNameEncode, companyEncode, pageIndex, ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                apiUrl, TargetEmploye.class);
        if (responseResult.isSuccess()) {
            return (TargetEmploye) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 发布老板点评
     */
    public static Integer PostBossComment(BossCommentEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().httpPost(ApiEnvironment.BossComment_Post_Endpoint, entity, Integer.class);
        if (responseResult.isSuccess()) {
            return (Integer) responseResult.result;
        } else {
            return -1;
        }
    }
}
