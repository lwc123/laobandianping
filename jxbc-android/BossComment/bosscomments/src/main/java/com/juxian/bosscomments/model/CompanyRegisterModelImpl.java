package com.juxian.bosscomments.model;

import android.os.Handler;
import android.os.Message;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.repositories.AccountRepository;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl.OnLoadValidationCodeListener;
import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.utils.AsyncRunnable;

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
public class CompanyRegisterModelImpl implements CompanyRegisterModel {
    @Override
    public void loadValidationCode(final String phone,final OnLoadValidationCodeListener listener) {
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                if (AccountRepository.existsMobilePhone(phone)) {
                    return AccountSignResult.DUPLICATE_MOBILEPHONE;
                }
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
    public void signUp(final AccountSign accountSign,final Handler myHandler,final CompanyRegisterListener listener) {
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {
                SignResult signResult = null;
                Message message = new Message();
                message.what = 5;
                myHandler.sendMessage(message);

                signResult = AppContext.getCurrent().getAuthentication().signUp(accountSign.MobilePhone,accountSign.Password,accountSign.ValidationCode,accountSign.SelectedProfileType);
                return signResult;
                // }
            }

            @SuppressWarnings("unused")
            @Override
            protected void onPostExecute(SignResult signResult) {
                listener.onCompanyRegisterSuccess(signResult);
            }

            @Override
            protected void onPostError(Exception ex) {
                Message message = new Message();
                message.what = 8;
                myHandler.sendMessage(message);
                listener.onCompanyRegisterFailure(null,ex);
            }
        }.execute();
    }

    public interface CompanyRegisterListener {
        void onCompanyRegisterSuccess(SignResult signResult);
        void onCompanyRegisterEmpty(String msg);
        void onCompanyRegisterFailure(String msg, Exception e);
    }
    public interface OnLoadValidationCodeListener {
        void onLoadValidationCodeSuccess(Integer signResult);
        void onLoadValidationCodeEmpty(String msg);
        void onLoadValidationCodeFailure(String msg, Exception e);
    }
}
