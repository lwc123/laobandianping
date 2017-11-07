package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.juxian.bosscomments.models.PriceStrategyEntity;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

/**
 * Created by nene on 2016/12/8.
 * 企业服务API
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 12:57]
 * @Version: [v1.0]
 */
public class EnterpriseServiceRepository {
    public static ResultEntity companyAudit(CompanyAuditEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Company_RequestCompanyAudit_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
