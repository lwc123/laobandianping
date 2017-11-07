package com.juxian.bosscomments.view;

import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.UserProfileEntity;

public interface AccountView {
    void showAccountMessage(CompanyEntity entity);

    void showProgress();

    void hideProgress();
}
