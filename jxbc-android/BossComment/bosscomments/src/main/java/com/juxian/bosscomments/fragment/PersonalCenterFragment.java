package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AvatarEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.presenter.AccountPresenter;
import com.juxian.bosscomments.presenter.AccountPresenterImpl;
import com.juxian.bosscomments.ui.AboutUsActivity;
import com.juxian.bosscomments.ui.AccountInfoActivity;
import com.juxian.bosscomments.ui.AccreditManageActivity;
import com.juxian.bosscomments.ui.AllDepartmentActivity;
import com.juxian.bosscomments.ui.CHomeActivity;
import com.juxian.bosscomments.ui.HaveBankCardNumberActivity;
import com.juxian.bosscomments.ui.InputMoneyActivity;
import com.juxian.bosscomments.ui.InviteFriendsActivity;
import com.juxian.bosscomments.ui.ModifyAvatarActivity;
import com.juxian.bosscomments.ui.ModifyCpInfoActivity;
import com.juxian.bosscomments.ui.MyCommentActivity;
import com.juxian.bosscomments.ui.OpenServiceActivity;
import com.juxian.bosscomments.ui.RechargeRecordActivity;
import com.juxian.bosscomments.ui.SelectOtherCompanyActivity;
import com.juxian.bosscomments.ui.SettingActivity;
import com.juxian.bosscomments.ui.WithdrawDepositActivity;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.TimeUtil;
import com.juxian.bosscomments.view.AccountView;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;
import java.util.Date;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * 我的
 */
public class PersonalCenterFragment extends BaseFragment implements View.OnClickListener, AccountView,DialogUtils.DialogListener {

    private static final String PARAM = "param";
    private String mParam;
//    @BindView(R.id.include_head_title_title)
//    TextView title;
//    @BindView(R.id.include_head_title_lin)
//    LinearLayout back;
    @BindView(R.id.withdraw_deposit)
    TextView withdraw_deposit;// 金库与提现
    @BindView(R.id.activity_boss_comment_recharge_record)
    RelativeLayout boss_comment_recharge_record;// 老板点评充值记录
    @BindView(R.id.activity_boss_comment_recharge)
    RelativeLayout boss_comment_recharge;// 充值
    @BindView(R.id.activity_authorization_management)
    RelativeLayout authorization_management;// 授权管理
    @BindView(R.id.activity_i_add_the_evaluation)
    RelativeLayout i_add_the_evaluation;// 我添加的评价
    @BindView(R.id.activity_invite_other_company)
    RelativeLayout activity_invite_other_company;
    @BindView(R.id.activity_system_setting)
    RelativeLayout system_setting;// 系统设置
    @BindView(R.id.activity_department_management)
    RelativeLayout department_management;// 部门管理
    @BindView(R.id.modify_personal_information)
    RelativeLayout modify_personal_information;
    @BindView(R.id.personal_name)
    TextView mPersonalName;
    @BindView(R.id.activity_user_role_name)
    TextView mCurrentUserRole;
    @BindView(R.id.audit_status)
    TextView mAuditStutus;
    @BindView(R.id.profile_image)
    CircleImageView mProfileImage;
    @BindView(R.id.activity_user_role)
    RelativeLayout mUserRole;
    @BindView(R.id.company_vault_value)
    TextView mCompanyVault;
    @BindView(R.id.company_cash_check_value)
    TextView mCanWithdrawDeposit;
    @BindView(R.id.activity_withdraw_deposit)
    RelativeLayout mGoldExplain;
    @BindView(R.id.activity_my_other_company)
    RelativeLayout mMyOtherCompany;
    @BindView(R.id.service_explain)
    RelativeLayout mServiceExplain;
    @BindView(R.id.service_time)
    TextView mServiceTime;
    @BindView(R.id.open_service)
    TextView mOpenService;
    @BindView(R.id.activity_my_other_company_text)
    TextView mMyOtherCompanyText;
    private String path;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    private AccountPresenter mAccountPresenter;
    public int mAuditStatus;
    private DecimalFormat df1 = new DecimalFormat("0");
    private CompanyEntity mCompanyEntity;
    private int myCompanys;
    private boolean isEnabled;

    public static PersonalCenterFragment newInstance(String param) {
        PersonalCenterFragment fragment = new PersonalCenterFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        MemberEntity entity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
//        if (entity.Role == MemberEntity.CompanyMember_Role_Admin || entity.Role == MemberEntity.CompanyMember_Role_Boss) {
//            authorization_management.setVisibility(View.VISIBLE);
//        } else {
//            authorization_management.setVisibility(View.GONE);
//        }
        modify_personal_information.setOnClickListener(this);
        activity_invite_other_company.setOnClickListener(this);
        withdraw_deposit.setOnClickListener(this);
        boss_comment_recharge_record.setOnClickListener(this);
        boss_comment_recharge.setOnClickListener(this);
        authorization_management.setOnClickListener(this);
        i_add_the_evaluation.setOnClickListener(this);
        system_setting.setOnClickListener(this);
        mUserRole.setOnClickListener(this);
        department_management.setOnClickListener(this);
        mGoldExplain.setOnClickListener(this);
        mMyOtherCompany.setOnClickListener(this);
        mOpenService.setOnClickListener(this);
        mAccountPresenter = new AccountPresenterImpl(getActivity(), this);
    }

    /**
     * Fragment切换时隐藏控件
     *
     * @param menuVisible
     */
    @Override
    public void setMenuVisibility(boolean menuVisible) {
        super.setMenuVisibility(menuVisible);
        if (this.getView() != null) {
            this.getView().setVisibility(menuVisible ? View.VISIBLE : View.GONE);
        }
    }

    @Override
    public View initViews() {
        View view = View.inflate(mActivity, R.layout.fragment_personal_center, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
//        title.setText(getString(R.string.main_tab_third));
//        back.setVisibility(View.GONE);
    }

    @Override
    public void setData() {
//        GetMineMessage();
        mAccountPresenter.loadAccountSummary(AppConfig.getCurrentUseCompany());
        MemberEntity entity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
        if (entity.Role == MemberEntity.CompanyMember_Role_Admin || entity.Role == MemberEntity.CompanyMember_Role_Boss) {
            authorization_management.setVisibility(View.VISIBLE);
//            withdraw_deposit.setVisibility(View.VISIBLE);
            withdraw_deposit.setVisibility(View.GONE);
        } else {
            authorization_management.setVisibility(View.GONE);
            withdraw_deposit.setVisibility(View.GONE);
        }

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.modify_personal_information:
                if (mCompanyEntity == null) {
                    return;
                }
                Intent modifyAvatar = new Intent(getActivity(), ModifyAvatarActivity.class);
                modifyAvatar.putExtra("CompanyEntity", JsonUtil.ToJson(mCompanyEntity));
                startActivity(modifyAvatar);
//                ToastUtil.showInfo("修改个人信息");
                break;
            case R.id.withdraw_deposit:
                if (mCompanyEntity == null) {
                    return;
                }
                //判断有无银行卡
                if (mCompanyEntity.ExistBankCard) {
                    Intent WithdrawDeposit = new Intent(getActivity(), HaveBankCardNumberActivity.class);
                    startActivity(WithdrawDeposit);
                } else {
                    Intent WithdrawDeposit = new Intent(getActivity(), WithdrawDepositActivity.class);
                    startActivity(WithdrawDeposit);
                }

                break;
            case R.id.activity_boss_comment_recharge_record:
                Intent RechargeRecord = new Intent(getActivity(), RechargeRecordActivity.class);
                startActivity(RechargeRecord);
                break;
            case R.id.activity_boss_comment_recharge:
                Intent intent1 = new Intent(getActivity(), InputMoneyActivity.class);
                startActivity(intent1);
                break;
            case R.id.activity_authorization_management:
                Intent AccreditManage = new Intent(getActivity(), AccreditManageActivity.class);
                startActivity(AccreditManage);
                break;
            case R.id.activity_i_add_the_evaluation:
                Intent AddComments = new Intent(getActivity(), MyCommentActivity.class);
                startActivity(AddComments);
                break;
            case R.id.activity_system_setting:
                Intent toSystemSetting = new Intent(getActivity(), SettingActivity.class);
                startActivityForResult(toSystemSetting, 200);
                break;
            case R.id.activity_user_role:
                if (isEnabled){
                    DialogUtils.showRadiusDialog(getActivity(),true,"稍候开通","开通服务","此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？",this);
                    return;
                }
                if (mCompanyEntity == null) {
                    return;
                }
                Intent ChangeData = new Intent(getActivity(), ModifyCpInfoActivity.class);
                ChangeData.putExtra("CompanyEntity", JsonUtil.ToJson(mCompanyEntity));
                startActivity(ChangeData);
                break;
            case R.id.activity_department_management:
                Intent mDepartmentManage = new Intent(getActivity(), AllDepartmentActivity.class);
                startActivity(mDepartmentManage);

                break;
            case R.id.activity_withdraw_deposit:
                Intent mGoldExplainIntent = new Intent(getActivity(), AboutUsActivity.class);
                mGoldExplainIntent.putExtra("ShowType", "GoldExplain");
                startActivity(mGoldExplainIntent);
                break;
            case R.id.activity_my_other_company:
                if ("18700000000".equals(AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone)) {
                    ToastUtil.showInfo("演示账号不能使用此功能");
                    return;
                }
                if (myCompanys > 1) {
//                    ToastUtil.showInfo("到选择公司页面");
                    Intent SelectOtherCompany = new Intent(getActivity(), SelectOtherCompanyActivity.class);
                    SelectOtherCompany.putExtra("BackStatus", "select");
                    startActivityForResult(SelectOtherCompany, 600);
                } else {
                    Intent toOpenService = new Intent(getActivity(), OpenServiceActivity.class);
                    toOpenService.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                    startActivityForResult(toOpenService, 700);
                }

                break;
            case R.id.open_service:
                Intent toPay = new Intent(getActivity(), AboutUsActivity.class);
                toPay.putExtra("ShowType", "CreateCount");
                startActivity(toPay);
                break;
            case R.id.activity_invite_other_company:
                Intent InviteFriend = new Intent(getActivity(), InviteFriendsActivity.class);
                InviteFriend.putExtra("CompanyEntity", JsonUtil.ToJson(mCompanyEntity));
                startActivity(InviteFriend);
                break;
            default:
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 200:
                if (resultCode == getActivity().RESULT_OK) {
                    getActivity().finish();
                }
                break;
            case 520:
                if (requestCode == 520 && resultCode == getActivity().RESULT_OK) {
                    path = data.getStringExtra("path");
//                    ChangeAvatar(path);
                    Log.i("JuXian", "状态页面" + path);
                    Bitmap bitmap = BitmapFactory.decodeFile(path);
//                    my_head_photo.setImageBitmap(bitmap);
                }
                break;
            case 600:
                if (resultCode == getActivity().RESULT_OK) {
                    getActivity().finish();
                }
                break;
            case 700:
                if (resultCode == getActivity().RESULT_OK) {
                    getActivity().finish();
                }
                break;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
//        setData();
        mAccountPresenter.loadAccountSummary(AppConfig.getCurrentUseCompany());

    }

    @Override
    public void showAccountMessage(CompanyEntity entity) {
        if (entity != null) {
            ImageLoader.getInstance().displayImage(AppContext.getCurrent().getCurrentAccount().getProfile().Avatar, mProfileImage, options, animateFirstListener);
            mCompanyEntity = entity;
            mAuditStatus = entity.AuditStatus;
//            mEmployedNum = entity.EmployedNum;
//            mDimissionNum = entity.DimissionNum;
            if (entity.ServiceEndTime!=null) {
                if (TimeUtil.getGapCount(new Date(), entity.ServiceEndTime) < 0) {
                    isEnabled = true;
                } else {
                    isEnabled = false;
                }
            }

            if (entity.Wallet != null) {
                mCompanyVault.setText(df1.format(entity.Wallet.AvailableBalance) + "金币");
                mCanWithdrawDeposit.setText(df1.format((entity.Wallet.CanWithdrawBalance)) + "金币");
            } else {
                mCompanyVault.setText("0金币");
                mCanWithdrawDeposit.setText("0金币");
            }
            if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Admin) {
                mCurrentUserRole.setText(entity.MyInformation.RealName + "(管理员)");
            } else if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Boss) {
                mCurrentUserRole.setText(entity.MyInformation.RealName + "(老板)");
            } else if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Senior) {
                mCurrentUserRole.setText(entity.MyInformation.RealName + "(高管)");
            } else {
                mCurrentUserRole.setText(entity.MyInformation.RealName + "(建档员)");
            }
            myCompanys = entity.myCompanys;
            if (myCompanys>1){
                mMyOtherCompanyText.setText(getString(R.string.my_other_company));
            } else {
                mMyOtherCompanyText.setText(getString(R.string.build_new_company));
            }
            if (!TextUtils.isEmpty(entity.CompanyName)){
                mCurrentUserRole.setText(entity.CompanyName);
            }
            if (!TextUtils.isEmpty(entity.MyInformation.RealName)){
                mPersonalName.setText(entity.MyInformation.RealName);
            }
            if (entity.ServiceEndTime != null) {
                int TimeDiferenceValue = TimeUtil.getGapCount(new Date(), entity.ServiceEndTime);
                if (TimeDiferenceValue < 0) {
                    mAuditStutus.setText("服务到期");
                    mAuditStutus.setTextColor(getResources().getColor(R.color.juxian_red));
                    mServiceExplain.setVisibility(View.VISIBLE);
                    mServiceTime.setText("您的服务已经到期，请开通服务后继续使用");
                } else if (TimeDiferenceValue <= 30) {
//                    mAuditStutus.setText("即将到期 剩余"+TimeDiferenceValue+"天");
                    mAuditStutus.setText("已认证");
                    mAuditStutus.setTextColor(getResources().getColor(R.color.luxury_gold_color));
//                    mAuditStutus.setTextColor(getResources().getColor(R.color.juxian_red));
                    mServiceExplain.setVisibility(View.VISIBLE);
                    mServiceTime.setText("您的服务剩余时间：" + TimeDiferenceValue + "天");
                } else {
                    mAuditStutus.setText("已认证");
                    mAuditStutus.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                    mServiceTime.setText("您的服务剩余时间：300天");
                    mServiceExplain.setVisibility(View.GONE);
                    mOpenService.setVisibility(View.GONE);
                }

            } else {
                mAuditStutus.setText("已认证");
                mAuditStutus.setTextColor(getResources().getColor(R.color.luxury_gold_color));
//                mServiceTime.setText("您的服务剩余时间：300天");
                mServiceExplain.setVisibility(View.GONE);
                mOpenService.setVisibility(View.GONE);
            }
        } else {
            Log.e(Global.LOG_TAG, "NULL");
        }
    }

    @Override
    public void showProgress() {

    }

    @Override
    public void hideProgress() {

    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        Intent toPay = new Intent(getActivity(), AboutUsActivity.class);
        toPay.putExtra("ShowType","CreateCount");
        startActivity(toPay);
    }
}
