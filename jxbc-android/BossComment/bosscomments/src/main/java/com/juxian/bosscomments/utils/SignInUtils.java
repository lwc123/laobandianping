package com.juxian.bosscomments.utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.ui.CHomeActivity;
import com.juxian.bosscomments.ui.HomeActivity;
import com.juxian.bosscomments.ui.InputBasicInformationActivity;
import com.juxian.bosscomments.ui.OpenServiceActivity;
import com.juxian.bosscomments.ui.PWorkbenchActivity;
import com.juxian.bosscomments.ui.SelectCompanyActivity;
import com.juxian.bosscomments.ui.SelectOtherCompanyActivity;
import com.juxian.bosscomments.ui.SelectUserIdentityActivity;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.webapi.WebApiClient;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by nene on 2016/12/9.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/9 13:53]
 * @Version: [v1.0]
 */
public class SignInUtils {
    public static void SignInSuccess(Context context, UserAuthentication authentication) {
        if (AppContext.getCurrent().getCurrentAccount().getProfile().CurrentProfileType == 0){
            Intent SelectUserIdentity = new Intent(context,SelectUserIdentityActivity.class);
            ((Activity) context).setResult(((Activity) context).RESULT_OK);
            context.startActivity(SelectUserIdentity);
            ((Activity) context).finish();
        } else if (AppContext.getCurrent().getCurrentAccount().getProfile().CurrentProfileType == 1) {
            AppConfig.setCurrentProfileType(1);
            AppConfig.setCurrentUseCompany(0);
            Intent PersonalWorkBench = new Intent(context, CHomeActivity.class);
//            Intent PersonalWorkBench = new Intent(context, PWorkbenchActivity.class);
            ((Activity) context).setResult(((Activity) context).RESULT_OK);
            context.startActivity(PersonalWorkBench);
            ((Activity) context).finish();
        } else {
            getMyRoles(context);
        }
    }

    public static void getMyRoles(final Context context) {
        new AsyncRunnable<List<MemberEntity>>() {
            @Override
            protected List<MemberEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<MemberEntity> entities = CompanyMemberRepository.getMyRoles();
                return entities;
            }

            @Override
            protected void onPostExecute(List<MemberEntity> entities) {
                if (WebApiClient.getSingleton().LastError != null) {
                    ToastUtil.showInfo(context.getString(R.string.myroles_error_hint));
                } else {
                    if (entities == null || entities.size() == 0) {
                        Intent toOpenService = new Intent(context, OpenServiceActivity.class);
                        ((Activity) context).setResult(((Activity) context).RESULT_OK);
                        context.startActivity(toOpenService);
                        ((Activity) context).finish();
                    } else {
                        if (AppConfig.getCurrentUseCompany() != 0) {
                            for (int i = 0; i < entities.size(); i++) {
                                if (entities.get(i).CompanyId == AppConfig.getCurrentUseCompany()) {
                                    judgeStatus(context, entities.get(i));
                                }
                            }
                        } else {
                            if (entities.size() == 1) {
                                // 一家公司，已认证等，就直接进入工作台，保存身份和企业id等信息
                                judgeStatus(context, entities.get(0));
                            } else {
                                Intent toSelectCompany = new Intent(context, SelectOtherCompanyActivity.class);
                                ArrayList<String> memberEntities = new ArrayList<String>();
                                for (int i = 0; i < entities.size(); i++) {
                                    memberEntities.add(JsonUtil.ToJson(entities.get(i)));
                                }
                                toSelectCompany.putExtra("LoginSelectCompany","LoginSelectCompany");
                                toSelectCompany.putStringArrayListExtra("AllCompany", memberEntities);
                                ((Activity) context).setResult(((Activity) context).RESULT_OK);
                                context.startActivity(toSelectCompany);
                                ((Activity) context).finish();
                            }
                        }
                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {

            }
        }.execute();
    }

    public static void judgeStatus(Context context, MemberEntity entity) {
        if ((entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Passed) || (entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Submited)) {
            AppConfig.setCurrentProfileType(2);
            AppConfig.setCurrentUseCompany(entity.CompanyId);
            Intent toHome = new Intent(context, HomeActivity.class);
            toHome.putExtra("CurrentMember",JsonUtil.ToJson(entity));
            ((Activity) context).setResult(((Activity) context).RESULT_OK);
            context.startActivity(toHome);
            ((Activity) context).finish();
        } else {
            // tag 为select的时候，表示从选择公司列表页进到认证页面，这个时候允许退出
            Intent toAttestation = new Intent(context, InputBasicInformationActivity.class);
            toAttestation.putExtra("Company", entity.myCompany.CompanyName);
            toAttestation.putExtra("CompanyId", entity.CompanyId + "");
            if (entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Rejected)
                toAttestation.putExtra("AuditStatus", "9");
            ((Activity) context).setResult(((Activity) context).RESULT_OK);
            context.startActivity(toAttestation);
            ((Activity) context).finish();
        }
    }
}
