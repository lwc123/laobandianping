package com.juxian.bosscomments.model;

import android.content.Context;

import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.AccountRepository;
import com.juxian.bosscomments.repositories.EnterpriseServiceRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;

import java.util.ArrayList;

/**
 * Created by nene on 2016/11/9.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.model]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:33]
 * @Version: [v1.0]
 */
public class CompanyAuthenticationModelImpl implements CompanyAuthenticationModel {

    @Override
    public void loadValidationCode(final String phone,final CompanyRegisterModelImpl.OnLoadValidationCodeListener listener) {
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                Boolean result = AccountRepository.sendValidationCode(phone);
                return result ? 0 : -1;
            }

            @Override
            protected void onPostExecute(Integer result) {
                listener.onLoadValidationCodeSuccess(result);
            }
            @Override
            protected void onPostError(Exception ex) {
                listener.onLoadValidationCodeFailure(null,ex);
            }
        }.execute();
    }

    @Override
    public void submitAuthentication(final Context context,final String Licence, final ArrayList<String> mNetImage, final ArrayList<String> mSelectImage, final CompanyAuditEntity entity, final CompanyAuthenticationListener listener) {
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                if (Licence.startsWith("http://")){
                    entity.Licence = Licence;
                } else {
                    ImageUtils.writeToFile(context, ImageUtils.getSmallBitmap(context, Licence), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                    entity.Licence = ImageUtil.toUploadBase64(ImageUtils.saveFilePaths.get(0));
                    ImageUtils.saveFilePaths.clear();
                }
//                if (mSelectImage != null) {
//                    for (int i = 0; i < mSelectImage.size(); i++) {
//                        ImageUtils.writeToFile(context, ImageUtils.getSmallBitmap(context, mSelectImage.get(i)), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
//                    }
//                    entity.Images = new String[mNetImage.size() + mSelectImage.size()];
//                    for (int i = 0; i < mNetImage.size(); i++) {
//                        entity.Images[i] = mNetImage.get(i);
//                    }
//                    for (int i = mNetImage.size(); i < (mNetImage.size() + mSelectImage.size()); i++) {
//                        entity.Images[i] = ImageUtil.toUploadBase64(ImageUtils.saveFilePaths.get(i - mNetImage.size()));
//                    }
//                } else {
//                    entity.Images = new String[mNetImage.size()];
//                    for (int i = 0; i < mNetImage.size(); i++) {
//                        entity.Images[i] = mNetImage.get(i);
//                    }
//                }
                ResultEntity result = EnterpriseServiceRepository.companyAudit(entity);
                return result;
            }

            @SuppressWarnings("unused")
            @Override
            protected void onPostExecute(ResultEntity result) {
                listener.onCompanyAuthenticationSuccess(result);
            }

            @Override
            protected void onPostError(Exception ex) {
                listener.onCompanyAuthenticationFailure(null,ex);
            }
        }.execute();
    }

    public interface CompanyAuthenticationListener {
        void onCompanyAuthenticationSuccess(ResultEntity resultEntity);
        void onCompanyAuthenticationEmpty(String msg);
        void onCompanyAuthenticationFailure(String msg, Exception e);
    }
}
