package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by nene on 2016/12/20.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/20 20:22]
 * @Version: [v1.0]
 */
public class DepartmentRepository {
    /**
     * 添加部门
     * @param entity
     * @return
     */
    public static ResultEntity addDepartment(DepartmentEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Department_Add_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<DepartmentEntity> getDepartmentList(long CompanyId) {
        String apiUrl = String.format(ApiEnvironment.Department_DepartmentListByCompany_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<DepartmentEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<DepartmentEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static ResultEntity deleteDepartment(DepartmentEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Department_Delete_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static ResultEntity updateDepartment(DepartmentEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Department_Update_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
