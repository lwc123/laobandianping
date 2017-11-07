package com.juxian.bosscomments.fragment;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.models.VersionEntity;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.ui.AboutUsActivity;
import com.juxian.bosscomments.ui.AdvertiseActivity;
import com.juxian.bosscomments.ui.AllEmployeeRecordActivity;
import com.juxian.bosscomments.ui.CMessageListActivity;
import com.juxian.bosscomments.ui.CommentListActivity;
import com.juxian.bosscomments.ui.CompanyDetailActivity;
import com.juxian.bosscomments.ui.DepartureReportListActivity;
import com.juxian.bosscomments.ui.InviteFriendsActivity;
import com.juxian.bosscomments.ui.SearchBossCommentActivity;
import com.juxian.bosscomments.ui.SelectOpinionActivity;
import com.juxian.bosscomments.ui.SignInActivity;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.SignInUtils;
import com.juxian.bosscomments.utils.TimeUtil;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.socialize.ThirdPassport;
import net.juxian.appgenome.utils.AnalyticsUtil;
import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 工作台
 */
public class MainFragment extends BaseFragment implements View.OnClickListener, DialogUtils.DialogListener,DialogUtils.MainDialogListener {

//    @BindView(R.id.include_head_title_title)
//    TextView title;
//    @BindView(R.id.include_head_title_lin)
//    LinearLayout back;
    private static final String PARAM = "param";
    private String mParam;
    @BindView(R.id.employee_record)
    TextView mEmployeeRecord;
    @BindView(R.id.stage_employee_comments)
    TextView mAddEmployeeComments;
    @BindView(R.id.departure_report)
    TextView mAddDepartureReport;
    @BindView(R.id.background_investigation)
    TextView mBackgroundInvestigation;
    @BindView(R.id.recruit)
    TextView mRecruit;
    @BindView(R.id.main_message)
    TextView mMainMessage;
    @BindView(R.id.invite_register)
    RelativeLayout mInviteRegister;
    @BindView(R.id.unread_msg_number)
    TextView unreadLabel;
    @BindView(R.id.invite_prize)
    ImageView mInvitePrize;
    @BindView(R.id.user_photo)
    RoundAngleImageView mCompanyLogo;
    @BindView(R.id.company_name)
    TextView mCompanyName;
    @BindView(R.id.legal_person)
    TextView mLegalPerson;
    @BindView(R.id.employee_count)
    TextView mEmployeeCount;// 员工档案
    @BindView(R.id.leave_office_employee_count)
    TextView mDepartEmployeeCount;// 离职员工
    @BindView(R.id.authentication_image)
    ImageView mAlreadyAuthentication;
    @BindView(R.id.authentication)
    TextView mAuthentication;
    @BindView(R.id.exist_demonstration)
    TextView mExistDemonstration;
    @BindView(R.id.stage_comments_number)
    TextView mStageCommentsNumber;// 阶段评价数目
    @BindView(R.id.leave_office_comments_number)
    TextView mLeaveOfficeCommentsNumber;// 离任报告数目
    @BindView(R.id.cardView1)
    LinearLayout mCardView1;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;
    private int mAuditStatus;
    private String mAuditInfo;
    private int mEmployedNum;
    private int mDimissionNum;
    private String mCurrentCompanyName;
    private CompanyEntity companyEntity;
    private Dialog dialog;
    private boolean isEnabled;
    private Context mContext;
    private int mDialogOption;
    private boolean IsDemonstration;
//    private EaseVoiceRecorder recorder;

    public static MainFragment newInstance(String param) {
        MainFragment fragment = new MainFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }

//    private Handler mHandler = new Handler(){
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            showProgresbarDialog();
//        }
//    };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = getActivity();
        if (getArguments() != null) {
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mEmployeeRecord.setOnClickListener(this);
        mAddEmployeeComments.setOnClickListener(this);
        mAddDepartureReport.setOnClickListener(this);
        mBackgroundInvestigation.setOnClickListener(this);
        mRecruit.setOnClickListener(this);
        mMainMessage.setOnClickListener(this);
        mInviteRegister.setOnClickListener(this);
        mExistDemonstration.setOnClickListener(this);
//        mCardView1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                ToastUtil.showInfo("123");
//            }
//        });
//        recorder = new EaseVoiceRecorder(getContext(),mHandler);
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
        View view = View.inflate(mActivity, R.layout.fragment_main, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
//        back.setVisibility(View.GONE);
//        title.setText(getString(R.string.main_workbench));
        if ("18700000000".equals(AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone)) {
            mExistDemonstration.setVisibility(View.VISIBLE);
        } else {
            mExistDemonstration.setVisibility(View.GONE);
        }

        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParams.leftMargin = getMetrics().widthPixels / 6 + dp2px(9);
        layoutParams.topMargin = dp2px(20);
        mInvitePrize.setLayoutParams(layoutParams);
        initNumLable();
    }

    @Override
    public void setData() {
//        GetMineMessage(AppConfig.getCurrentUseCompany());
    }

    @Override
    public int getAuditStatus() {
        return mAuditStatus;
    }

    @Override
    public String getAuditInfo() {
        if (TextUtils.isEmpty(mAuditInfo)) {
            return "未获得企业信息数据，请检查网络";
        } else {
            return mAuditInfo;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        GetMineMessage(AppConfig.getCurrentUseCompany());
    }

    public DisplayMetrics getMetrics() {
        WindowManager manager = getActivity().getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.employee_record:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                Intent AllEmployeeRecord = new Intent(getActivity(), AllEmployeeRecordActivity.class);
                startActivity(AllEmployeeRecord);
                break;
            case R.id.stage_employee_comments:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                Intent CommentList = new Intent(getActivity(), CommentListActivity.class);
                startActivity(CommentList);
                break;
            case R.id.departure_report:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                Intent DepartureReportList = new Intent(getActivity(), DepartureReportListActivity.class);
                startActivity(DepartureReportList);
                break;
            case R.id.background_investigation:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                Intent SearchBossComment = new Intent(getActivity(), SearchBossCommentActivity.class);
                startActivity(SearchBossComment);
                break;
            case R.id.recruit:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                if (TextUtils.isEmpty(mCurrentCompanyName)) {
                    return;
                }
                Intent Advertise = new Intent(getActivity(), AdvertiseActivity.class);
                Advertise.putExtra("CompanyName", mCurrentCompanyName);
                startActivity(Advertise);
                break;
            case R.id.main_message:
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    return;
                }
                Intent Message = new Intent(getActivity(), CMessageListActivity.class);
                startActivity(Message);
                break;
            case R.id.invite_register:
                mInviteRegister.setEnabled(false);
                if (mAuditStatus != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showMainDialog(mAuditInfo, getActivity(),this);
                    mInviteRegister.setEnabled(true);
                    return;
                }
                if (isEnabled) {
                    mDialogOption = 1;
                    DialogUtils.showRadiusDialog(getActivity(), true, "稍候开通", "开通服务", "此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？", this);
                    mInviteRegister.setEnabled(true);
                    return;
                }
                getClaimList(AppConfig.getCurrentUseCompany());
//                Intent CompanyOpinion = new Intent(getActivity(), SelectOpinionActivity.class);
//                startActivity(CompanyOpinion);
//                Intent InviteFriend = new Intent(getActivity(), InviteFriendsActivity.class);
//                InviteFriend.putExtra("CompanyEntity", JsonUtil.ToJson(companyEntity));
//                startActivity(InviteFriend);
                break;
            case R.id.exist_demonstration:
                IsDemonstration = true;
                signOut();
                break;
            default:
                break;
        }
    }

    public int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    private void GetMineMessage(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getSummary(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    companyEntity = entity;
                    AppConfig.setAccountCompany(JsonUtil.ToJson(entity));
                    AppConfig.setCompanyAbbr(entity.CompanyAbbr);
                    AppConfig.setBossInformation(JsonUtil.ToJson(entity.BossInformation));
                    AppConfig.setCurrentUserInformation(JsonUtil.ToJson(entity.MyInformation));

                    if (entity.ServiceEndTime!=null) {
                        if (TimeUtil.getGapCount(new Date(), entity.ServiceEndTime) < 0) {
                            isEnabled = true;
                        } else {
                            isEnabled = false;
                        }
                    }

                    ImageLoader.getInstance().displayImage(entity.CompanyLogo, mCompanyLogo, options, animateFirstListener);
                    mAuditStatus = entity.AuditStatus;
                    if (entity.AuditStatus == 2) {
                        mAlreadyAuthentication.setVisibility(View.VISIBLE);
                        mAlreadyAuthentication.setImageDrawable(getResources().getDrawable(R.drawable.already_authentication));
                        mAuthentication.setVisibility(View.GONE);
                        if (entity.ServiceEndTime != null) {
                            int TimeDiferenceValue = TimeUtil.getGapCount(new Date(), entity.ServiceEndTime);
                            if (TimeDiferenceValue < 0) {
                                mAlreadyAuthentication.setVisibility(View.VISIBLE);
                                mAlreadyAuthentication.setImageDrawable(getResources().getDrawable(R.drawable.the_service_expired));
                                mAuthentication.setVisibility(View.GONE);
                            }
//                            } else if (TimeDiferenceValue <= 30) {
//                                mAlreadyAuthentication.setVisibility(View.VISIBLE);
//                                mAlreadyAuthentication.setImageDrawable(getResources().getDrawable(R.drawable.is_about_to_expire));
//                                mAuthentication.setText("剩余:"+TimeDiferenceValue+"天");
//                                mAuthentication.setVisibility(View.VISIBLE);
//                            }
                        }
                    } else if (entity.AuditStatus == CompanyEntity.AttestationStatus_Submited){
                        mAlreadyAuthentication.setVisibility(View.VISIBLE);
                        mAlreadyAuthentication.setImageDrawable(getResources().getDrawable(R.drawable.in_authentication));
                        mAuthentication.setVisibility(View.GONE);
                    }
                    if (!TextUtils.isEmpty(entity.PromptInfo)) {
                        mAuditInfo = entity.PromptInfo;
                    } else {
                        mAuditInfo = "未获得企业信息数据，请检查网络";
                    }
                    if (entity.UnreadMessageNum > 0) {
                        if (entity.UnreadMessageNum > 99) {
                            unreadLabel.setText("...");
                        } else {
                            unreadLabel.setText(entity.UnreadMessageNum + "");
                        }
                        unreadLabel.setVisibility(View.VISIBLE);
                    } else {
                        unreadLabel.setText("");
                        unreadLabel.setVisibility(View.GONE);
                    }
                    mEmployedNum = entity.EmployedNum;
                    mDimissionNum = entity.DimissionNum;
                    mEmployeeCount.setText("" + entity.EmployedNum);
                    mDepartEmployeeCount.setText("" + entity.DimissionNum);
                    if (!TextUtils.isEmpty(entity.CompanyName)) {
                        mCompanyName.setText(entity.CompanyAbbr);
                        mCurrentCompanyName = entity.CompanyName;
                    } else {
                        mCompanyName.setText("");
                    }
                    if (!TextUtils.isEmpty(entity.LegalName)) {
                        mLegalPerson.setText(entity.LegalName);
                    } else {
                        mLegalPerson.setText("");
                    }
                    mStageCommentsNumber.setText("" + entity.StageEvaluationNum);
                    mLeaveOfficeCommentsNumber.setText("" + entity.DepartureReportNum);
                    //判断更新
                    if (CheckUpdata) {
                        String versionCode = AppConfigUtil.getCurrentVersion().VersionName;
                        IsEsistsVersion(versionCode, "android");
                    }
                } else {
                    Log.e(Global.LOG_TAG, "NULL");
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private int UpdataAppType;
    private String UpdataAppUrl;
    private boolean CheckUpdata = true;

    private void IsEsistsVersion(final String VersionCode, final String Apptype) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<VersionEntity>() {
            @Override
            protected VersionEntity doInBackground(Void... params) {
                VersionEntity entity = UserRepository.ExistsVersion(VersionCode, Apptype);
                return entity;
            }

            @Override
            protected void onPostExecute(VersionEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    UpdataAppType = entity.UpgradeType;
                    UpdataAppUrl = entity.DownloadUrl;
                    if (UpdataAppType == 1) {//不提示

                    } else if (UpdataAppType == 2) {//建议更新
                        showUpdataDialog(getActivity(), true, "暂不升级", "前往升级", entity.Description);
                        CheckUpdata = false;
                    } else if (UpdataAppType == 3) {//强制更新
                        showUpdataDialog(getActivity(), false, "", "前往升级", entity.Description);
                        CheckUpdata = false;
                    }

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private void showUpdataDialog(Context context, boolean showLeftBt, String leftBtString, String rightBtString, String descripe) {
        mDialogOption = 2;
        DialogUtils.showRadiusDialog(context, showLeftBt, leftBtString, rightBtString, descripe, this);
    }

    /**
     * 未读消息数Lable初始化
     */
    private void initNumLable() {
        WindowManager manager = getActivity().getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        int width2 = outMetrics.widthPixels;
        int height2 = outMetrics.heightPixels;
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(dp2px(18), dp2px(18));
//        params.leftMargin = (width2 / 8) * 5;
//        params.topMargin = dp2px(2);
        params.leftMargin = (width2 / 6) * 5 + dp2px(15);
        params.topMargin = dp2px(10);
        unreadLabel.setLayoutParams(params);
        // Toast.makeText(context, R.string.ceshistring,
        // Toast.LENGTH_SHORT).show();
    }

    private final void signOut() {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getAuthentication().signOut();
            }

            @Override
            protected void onPostExecute(Boolean result) {

                if (result == true) {
//                    MobclickAgent.onProfileSignOff();
                    AppConfig.setCurrentUseCompany(0);
                    AppConfig.setCurrentProfileType(0);
                    if (IsDemonstration) {
                        signIn();
                    } else {
                        Intent intent = new Intent(getActivity(), SignInActivity.class);
                        startActivity(intent);
                        getActivity().finish();
                    }
                } else {

                }
            }

            @Override
            protected void onPostError(Exception ex) {

            }
        }.execute();
    }

    // 登录
    private void signIn() {
        final String loginName = AppConfig.get("loginName");
        final String password = AppConfig.get("loginPassword");

        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {
                SignResult signResult = AppContext.getCurrent().getAuthentication().signIn(loginName, password);
                return signResult;
            }

            @Override
            protected void onPostExecute(SignResult signResult) {
                if (dialog != null)
                    dialog.dismiss();
                AccountSignResult accountSignResult = (AccountSignResult) signResult;
                if (null == accountSignResult || accountSignResult.SignStatus != accountSignResult.SUCCESS) {

                } else {
                    AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_SIGNIN, ThirdPassport.Platform_JuXian);
                    {
                        AppConfig.set("mobilePhone", loginName + "");
                        onSignInSuccess();

                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void onSignInSuccess() {
        UserAuthentication authentication = AppContext.getCurrent().getUserAuthentication();
        if (authentication.isInitializedIdentity()) {
            if (AppContext.getCurrent().isAuthenticated()) {
                UserProfileEntity entity = authentication.getCurrentAccount().getProfile();

                SignInUtils.SignInSuccess(getActivity(), authentication);
            } else {
                return;
            }
        } else {

            return;
        }
    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        if (mDialogOption == 2){
            if (UpdataAppType == 2 || UpdataAppType == 3) {
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                Uri content_url = Uri.parse(UpdataAppUrl);
                intent.setData(content_url);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }
        } else {
            Intent toPay = new Intent(getActivity(), AboutUsActivity.class);
            toPay.putExtra("ShowType", "CreateCount");
            startActivity(toPay);
        }

    }

    @Override
    public void MainLeftBtMethod() {
        IsDemonstration = false;
        signOut();
    }

    @Override
    public void MainRightBtMethod() {

    }
    private void getClaimList(final long CompanyId) {
        new AsyncRunnable<List<CCompanyEntity>>() {
            @Override
            protected List<CCompanyEntity> doInBackground(Void... params) {
                List<CCompanyEntity> cCompanyEntities = CompanyReputationRepository.getClaimList(CompanyId);
                return cCompanyEntities;
            }

            @Override
            protected void onPostExecute(List<CCompanyEntity> cCompanyEntities) {
                mInviteRegister.setEnabled(true);
                if (cCompanyEntities != null){
                    if (cCompanyEntities.size() == 0){
                        ToastUtil.showInfo("暂无口碑公司信息");
                    } else if (cCompanyEntities.size() == 1){
                        Intent intent = new Intent(getActivity(), CompanyDetailActivity.class);
                        intent.putExtra("FromResource","FromB");
                        intent.putExtra("CompanyId",cCompanyEntities.get(0).CompanyId);
                        startActivity(intent);
                    } else {
                        Intent intent = new Intent(getActivity(), SelectOpinionActivity.class);
                        ArrayList<String> Companys = new ArrayList<>();
                        for (int i=0;i<cCompanyEntities.size();i++){
                            Companys.add(JsonUtil.ToJson(cCompanyEntities.get(i)));
                        }
                        intent.putStringArrayListExtra("Companys",Companys);
                        startActivity(intent);
                    }
                } else {
                    ToastUtil.showInfo("网络超时");
                }
            }

            protected void onPostError(Exception ex) {
                mInviteRegister.setEnabled(true);
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
