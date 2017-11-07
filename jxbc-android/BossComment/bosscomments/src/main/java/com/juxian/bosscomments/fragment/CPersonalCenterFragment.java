package com.juxian.bosscomments.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PrivatenessServiceContractEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;
import com.juxian.bosscomments.ui.HaveBankCardNumberActivity;
import com.juxian.bosscomments.ui.MessageListActivity;
import com.juxian.bosscomments.ui.MineOpinionActivity;
import com.juxian.bosscomments.ui.ModifyDataActivity;
import com.juxian.bosscomments.ui.MyArchiveActivity;
import com.juxian.bosscomments.ui.OpenServiceActivity;
import com.juxian.bosscomments.ui.PersonalArchiveListActivity;
import com.juxian.bosscomments.ui.PersonalInviteActivity;
import com.juxian.bosscomments.ui.PersonalJobSearchListActivity;
import com.juxian.bosscomments.ui.SelectOtherCompanyActivity;
import com.juxian.bosscomments.ui.SettingActivity;
import com.juxian.bosscomments.ui.WithdrawDepositActivity;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2017/4/11.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/11 13:06]
 * @Version: [v1.0]
 */
public class CPersonalCenterFragment extends BaseFragment implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.modify_personal_information)
    RelativeLayout mModifyPersonalInformation;
    @BindView(R.id.activity_my_archive)
    RelativeLayout mActivityMyArchive;
    @BindView(R.id.activity_my_company)
    RelativeLayout mActivityMyCompany;
    @BindView(R.id.activity_my_comment)
    RelativeLayout mActivityMyComment;
    @BindView(R.id.activity_apply_job)
    RelativeLayout mActivityApplyJob;
    @BindView(R.id.activity_my_pocket)
    RelativeLayout mActivityMyPocket;
    @BindView(R.id.activity_personal_message)
    RelativeLayout mActivityPersonalMessage;
    @BindView(R.id.activity_invite_register)
    RelativeLayout mActivityInviteRegister;
    @BindView(R.id.activity_system_setting)
    RelativeLayout mActivitySystemSetting;
    @BindView(R.id.profile_image)
    CircleImageView mProfileImage;
    @BindView(R.id.personal_name)
    TextView mPersonalName;
    private static final String PARAM = "param";
    private String mParam;
    private boolean ExistBankCard;
    private long exitTime = 0;
    private PrivatenessServiceContractEntity mPrivatenessServiceContractEntity;
    private int CompanyNumber;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;

    public static CPersonalCenterFragment newInstance(String param) {
        CPersonalCenterFragment fragment = new CPersonalCenterFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null){
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public View initViews() {
        View view = View.inflate(getActivity(),R.layout.fragment_cpersonal_center,null);
        ButterKnife.bind(this,view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
        back.setVisibility(View.GONE);
        title.setText(getString(R.string.main_tab_third));
        ImageLoader.getInstance().displayImage(AppContext.getCurrent().getCurrentAccount().getProfile().Avatar,mProfileImage,options,animateFirstListener);
        mPersonalName.setText(AppContext.getCurrent().getCurrentAccount().getProfile().RealName);
        initListener();
    }

    public void initListener(){
        mModifyPersonalInformation.setOnClickListener(this);
        mActivityMyArchive.setOnClickListener(this);
        mActivityMyCompany.setOnClickListener(this);
        mActivityMyComment.setOnClickListener(this);
        mActivityApplyJob.setOnClickListener(this);
        mActivityMyPocket.setOnClickListener(this);
        mActivityPersonalMessage.setOnClickListener(this);
        mActivityInviteRegister.setOnClickListener(this);
        mActivitySystemSetting.setOnClickListener(this);
    }

    @Override
    public void setData() {
        GetPersonalSummary();
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.modify_personal_information:
                Intent ModifyData = new Intent(getActivity(), ModifyDataActivity.class);
                startActivityForResult(ModifyData,520);
                break;
            case R.id.activity_my_archive:
                mPrivatenessServiceContractEntity = JsonUtil.ToEntity(AppConfig.getPersonalServiceContract(), PrivatenessServiceContractEntity.class);
                if (mPrivatenessServiceContractEntity != null) {
                    Intent PersonalArchiveList = new Intent(getActivity(), PersonalArchiveListActivity.class);
                    startActivity(PersonalArchiveList);
                } else {
                    Intent toMyArchive = new Intent(getActivity(), MyArchiveActivity.class);
                    startActivity(toMyArchive);
                }
                break;
            case R.id.activity_my_company:
                if (CompanyNumber >= 1) {
                    Intent SelectOtherCompany = new Intent(getActivity(), SelectOtherCompanyActivity.class);
                    SelectOtherCompany.putExtra(Global.LISTVIEW_ITEM_TAG, "personal");
                    SelectOtherCompany.putExtra("BackStatus", "select");
                    startActivityForResult(SelectOtherCompany, 600);
                } else {
                    Intent toOpenService = new Intent(getActivity(), OpenServiceActivity.class);
                    toOpenService.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                    startActivityForResult(toOpenService, 600);
                }
                break;
            case R.id.activity_my_comment:
                Intent mineOpinion = new Intent(getActivity(), MineOpinionActivity.class);
                startActivity(mineOpinion);
                break;
            case R.id.activity_apply_job:
                Intent intent = new Intent(getActivity(), PersonalJobSearchListActivity.class);
                startActivity(intent);
                break;
            case R.id.activity_my_pocket:
                if (ExistBankCard) {
                    Intent WithdrawDeposit = new Intent(getActivity(), HaveBankCardNumberActivity.class);
                    WithdrawDeposit.putExtra("Personal", true);
                    startActivity(WithdrawDeposit);
                } else {
                    Intent toMyPocket = new Intent(getActivity(), WithdrawDepositActivity.class);
                    toMyPocket.putExtra("Personal", true);
                    startActivity(toMyPocket);
                }
                break;
            case R.id.activity_personal_message:
                Intent toMessageList = new Intent(getActivity(), MessageListActivity.class);
                startActivity(toMessageList);
                break;
            case R.id.activity_invite_register:
                Intent toInvite = new Intent(getActivity(), PersonalInviteActivity.class);
                startActivity(toInvite);
                break;
            case R.id.activity_system_setting:
                Intent toSetting = new Intent(getActivity(), SettingActivity.class);
                toSetting.putExtra(Global.LISTVIEW_ITEM_TAG, "personal");
                toSetting.putExtra("CompanyNumber", CompanyNumber);
                startActivityForResult(toSetting, 100);
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode){
            case 600:
                if (resultCode == getActivity().RESULT_OK){
                    getActivity().finish();
                }
                break;
            case 520:
                if (resultCode == getActivity().RESULT_OK){
                    ImageLoader.getInstance().displayImage(AppContext.getCurrent().getCurrentAccount().getProfile().Avatar,mProfileImage,options,animateFirstListener);
                    mPersonalName.setText(AppContext.getCurrent().getCurrentAccount().getProfile().RealName);
                }
                break;
        }
    }

    private void GetPersonalSummary() {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<PrivatenessSummaryEntity>() {
            @Override
            protected PrivatenessSummaryEntity doInBackground(Void... params) {
                PrivatenessSummaryEntity entity = PrivatenessRepository.GetPersonalSummary();
                return entity;
            }

            @Override
            protected void onPostExecute(PrivatenessSummaryEntity entity) {
                if (entity != null) {
                    ExistBankCard = entity.ExistBankCard;
                    if (entity.PrivatenessServiceContract.IDCard != null) {
                        AppConfig.setPersonalServiceContract(JsonUtil.ToJson(entity.PrivatenessServiceContract));
                    } else {
                        AppConfig.setPersonalServiceContract(null);
                    }
                    CompanyNumber = entity.myCompanys;
//                    if (entity.UnreadMessageNum > 0) {
//                        unreadLabel.setVisibility(View.VISIBLE);
//                        unreadLabel.setText(entity.UnreadMessageNum + "");
//                    } else {
//                        unreadLabel.setVisibility(View.GONE);
//                    }
//                    if (CheckUpdata) {
//                        String versionCode = AppConfigUtil.getCurrentVersion().VersionName;
//                        IsEsistsVersion(versionCode, "android");
//                    }
                } else {
                    AppConfig.setPersonalServiceContract(null);
//                    unreadLabel.setVisibility(View.GONE);
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
