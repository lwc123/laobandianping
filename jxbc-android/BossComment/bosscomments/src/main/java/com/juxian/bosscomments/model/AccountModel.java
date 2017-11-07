package com.juxian.bosscomments.model;

import com.juxian.bosscomments.model.AccountModelImpl.OnLoadAccountSummaryListener;

public interface AccountModel {
    void loadAccountSummary(long CompanyId,OnLoadAccountSummaryListener listener);
}
