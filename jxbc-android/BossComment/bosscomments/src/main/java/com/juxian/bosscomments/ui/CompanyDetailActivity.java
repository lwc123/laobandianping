package com.juxian.bosscomments.ui;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.app.Dialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.CompanyDetailAdapter;
import com.juxian.bosscomments.adapter.ManageOpinionAdapter;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.listener.ClickLikedListener;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.apiutils.LikedUtils;
import com.juxian.bosscomments.widget.CustomTitleShareBoard;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.RoundProgressBar;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/4/18.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/18 17:05]
 * @Version: [v1.0]
 */
public class CompanyDetailActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView>, ClickLikedListener, LikedUtils.ClickLikedCallBackListener,
        com.juxian.bosscomments.utils.DialogUtils.DialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_lin1)
    LinearLayout back1;
    @BindView(R.id.include_head_title_title1)
    TextView title1;
    @BindView(R.id.include_head_title_tab2)
    ImageView mOperationImage1;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mOperationRl;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.re_listview)
    RelativeLayout mShowOrNot;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    @BindView(R.id.remark_on_company)
    TextView mRemarkOnCompany;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.include_head_title_big_re1)
    RelativeLayout mToolBar;
    @BindView(R.id.include_head_title_tab)
    ImageView mOperationImage;
    @BindView(R.id.include_head_title_re2)
    RelativeLayout mManagerBt;
    @BindView(R.id.include_head_title_tab4)
    TextView mManagerBtText;
    private SystemBarTintManager tintManager;
    private View mCompanyDetailHeaderView;
    private RoundAngleImageView mCompanyLogo;
    private TextView mAttentionBt, mClaimBt, mCompanyName, mCompanyIndustry, mCompanyRegion, mCompanySize, mAllNumber;
    private RatingBar mRatingBar;
    private TagFlowLayout mTagFlow;
    private TagAdapter<String> mTagFlowAdapter;
    private RoundProgressBar roundProgressBar1, roundProgressBar2, roundProgressBar3;
    private ImageView mNoData1,mNoData2,mNoData3;
    private List<OpinionEntity> entities;
    private CompanyDetailAdapter mAdapter;
    private int pageIndex = 1;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;
    private List<String> mLables;
    public LayoutInflater inflater;
    //    private String CompanyName;
    private CCompanyEntity cCompanyEntity;
    private String mFromResource;
    private PopupWindow popupWindow;
    private CustomTitleShareBoard shareBoard;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_company_detail;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
//        setSystemBarTintManager(this);
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
        tintManager.setStatusBarTintResource(R.color.transparency_color);
        if ("FromB".equals(mFromResource)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                view.setVisibility(View.VISIBLE);
            } else {
                view.setVisibility(View.GONE);
            }
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                view.setVisibility(View.GONE);
            } else {
                view.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title1.setText("公司详情");

        mFromResource = getIntent().getStringExtra("FromResource");

        mLables = new ArrayList<>();
        inflater = LayoutInflater.from(getApplicationContext());
        mOperationImage.setImageResource(R.drawable.ic_share);
        mOperationImage.setVisibility(View.VISIBLE);
        mOperationImage1.setImageResource(R.drawable.ic_share);
        mOperationImage1.setVisibility(View.VISIBLE);

        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mCompanyDetailHeaderView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_company_detail_header, null);
        mRefreshListView.getRefreshableView().addHeaderView(mCompanyDetailHeaderView, null, false);
        mCompanyLogo = (RoundAngleImageView) mCompanyDetailHeaderView.findViewById(R.id.user_photo);
        mAttentionBt = (TextView) mCompanyDetailHeaderView.findViewById(R.id.attention_bt);
        mClaimBt = (TextView) mCompanyDetailHeaderView.findViewById(R.id.claim_bt);
        mCompanyName = (TextView) mCompanyDetailHeaderView.findViewById(R.id.company_name);
        mCompanyIndustry = (TextView) mCompanyDetailHeaderView.findViewById(R.id.company_industry);
        mCompanyRegion = (TextView) mCompanyDetailHeaderView.findViewById(R.id.company_region);
        mCompanySize = (TextView) mCompanyDetailHeaderView.findViewById(R.id.company_size);
        mRatingBar = (RatingBar) mCompanyDetailHeaderView.findViewById(R.id.ratingBar);
        mTagFlow = (TagFlowLayout) mCompanyDetailHeaderView.findViewById(R.id.tag_flow);
        mAllNumber = (TextView) mCompanyDetailHeaderView.findViewById(R.id.all_number);
        roundProgressBar1 = (RoundProgressBar) mCompanyDetailHeaderView.findViewById(R.id.roundProgressBar1);
        roundProgressBar2 = (RoundProgressBar) mCompanyDetailHeaderView.findViewById(R.id.roundProgressBar2);
        roundProgressBar3 = (RoundProgressBar) mCompanyDetailHeaderView.findViewById(R.id.roundProgressBar3);
        mNoData1 = (ImageView) mCompanyDetailHeaderView.findViewById(R.id.no_data1);
        mNoData2 = (ImageView) mCompanyDetailHeaderView.findViewById(R.id.no_data2);
        mNoData3 = (ImageView) mCompanyDetailHeaderView.findViewById(R.id.no_data3);
        roundProgressBar1.setMax(100);
        roundProgressBar2.setMax(100);
        roundProgressBar3.setMax(100);

        if ("FromB".equals(mFromResource)) {
            back.setVisibility(View.GONE);
            mOperationImage.setVisibility(View.GONE);
            mOperationImage1.setVisibility(View.GONE);
            mOperationRl.setVisibility(View.GONE);
            mToolBar.setVisibility(View.VISIBLE);
            mManagerBt.setVisibility(View.VISIBLE);
            mManagerBtText.setText("管理");
            mManagerBtText.setVisibility(View.VISIBLE);
            title1.setText("公司口碑");

            mAttentionBt.setVisibility(View.GONE);
            mClaimBt.setVisibility(View.GONE);
            mRemarkOnCompany.setVisibility(View.GONE);
        }

        mTagFlowAdapter = new TagAdapter<String>(mLables) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) inflater.inflate(
                        R.layout.company_reputation_lable, mTagFlow, false);
                tv.setText(s);
                return tv;
            }
        };
        mTagFlow.setAdapter(mTagFlowAdapter);

        entities = new ArrayList<>();
        mAdapter = new CompanyDetailAdapter(entities, this, this,mFromResource);
        mRefreshListView.setAdapter(mAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        back1.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mAttentionBt.setOnClickListener(this);
        mRemarkOnCompany.setOnClickListener(this);
        mClaimBt.setOnClickListener(this);
        mOperationImage.setOnClickListener(this);
        mOperationRl.setOnClickListener(this);
        if ("FromB".equals(mFromResource)) {
            mManagerBt.setOnClickListener(this);
        }

        mRefreshListView.setOnScrollListener(new AbsListView.OnScrollListener() {
            private SparseArray recordSp = new SparseArray(0);
            private int mCurrentfirstVisibleItem = 0;

            @Override
            public void onScrollStateChanged(AbsListView arg0, int arg1) {
                // TODO Auto-generated method stub
            }

            @Override
            public void onScroll(AbsListView arg0, int arg1, int arg2, int arg3) {
                // TODO Auto-generated method stub
                mCurrentfirstVisibleItem = arg1;
                View firstView = arg0.getChildAt(0);
                if (null != firstView) {
                    ItemRecod itemRecord = (ItemRecod) recordSp.get(arg1);
                    if (null == itemRecord) {
                        itemRecord = new ItemRecod();
                    }
                    itemRecord.height = firstView.getHeight();
                    itemRecord.top = firstView.getTop();
                    recordSp.append(arg1, itemRecord);
                    int h = getScrollY();//滚动距离
//                    Log.e(Global.LOG_TAG,h+"");
                    // 上滑h值在增加，下滑在减小
                    if ("FromB".equals(mFromResource)) {

                    } else {
                        if (h > 100) {
                            mToolBar.setVisibility(View.VISIBLE);
                            back.setVisibility(View.GONE);
                            mOperationImage.setVisibility(View.GONE);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                                view.setVisibility(View.VISIBLE);
                            } else {
                                view.setVisibility(View.GONE);
                            }
                        } else {
                            mToolBar.setVisibility(View.GONE);
                            back.setVisibility(View.VISIBLE);
                            mOperationImage.setVisibility(View.VISIBLE);
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                                view.setVisibility(View.GONE);
                            } else {
                                view.setVisibility(View.GONE);
                            }
                        }
                    }
                }
            }

            private int getScrollY() {
                int height = 0;
                for (int i = 0; i < mCurrentfirstVisibleItem; i++) {
                    ItemRecod itemRecod = (ItemRecod) recordSp.get(i);
                    height += itemRecod.height;
                }
                ItemRecod itemRecod = (ItemRecod) recordSp.get(mCurrentfirstVisibleItem);
                if (null == itemRecod) {
                    itemRecod = new ItemRecod();
                }
                return height - itemRecod.top;
            }

            class ItemRecod {
                int height = 0;
                int top = 0;
            }
        });
    }

    public int getScrollY() {
        View c = mRefreshListView.getChildAt(0);
        if (c == null) {
            return 0;
        }
        int firstVisiblePosition = mRefreshListView.getRefreshableView().getFirstVisiblePosition();
        int top = c.getTop();
        return -top + firstVisiblePosition * c.getHeight();
    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getCompanyReputationList(getIntent().getLongExtra("CompanyId", 0), pageIndex, 0, true);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_lin1:
                finish();
                break;
            case R.id.attention_bt:
                getCompanyReputationList(getIntent().getLongExtra("CompanyId", 0));
                break;
            case R.id.remark_on_company:
                Intent intent = new Intent(getApplicationContext(), CompanyCircleWebViewActivity.class);
                intent.putExtra("WebViewType", "OpinionCreate");
                intent.putExtra("CreateResource", "CompanyDetail");
                intent.putExtra("CompanyId", cCompanyEntity.CompanyId);
                intent.putExtra("CompanyName", cCompanyEntity.CompanyName);
                startActivity(intent);
                break;
            case R.id.claim_bt:
                int MultipleProfiles = AppContext.getCurrent().getCurrentAccount().MultipleProfiles;
                if (((MultipleProfiles & 1) == 1) && ((MultipleProfiles & 2) == 2)) {
                    com.juxian.bosscomments.utils.DialogUtils.showRadiusDialog(this, false, "否", "确定", "认领公司请联系客服：400-815-9166", this);
                } else {
                    Intent goToClaimCompany = new Intent(this, CompanyCircleWebViewActivity.class);
                    goToClaimCompany.putExtra("WebViewType", "ClaimCompany");
                    goToClaimCompany.putExtra("CompanyId", cCompanyEntity.CompanyId);
                    goToClaimCompany.putExtra("CompanyName", cCompanyEntity.CompanyName);
                    startActivity(goToClaimCompany);
                }
//                ToastUtil.showInfo("等你来认领吧");
                break;
            case R.id.include_head_title_tab:
                String shareTitle = cCompanyEntity.Introduction;
                String content = cCompanyEntity.BriefIntroduction;
                String UserAvatar = cCompanyEntity.CompanyLogo;
                String shareUrl = cCompanyEntity.ShareLink;
                shareBoard = new CustomTitleShareBoard(
                        CompanyDetailActivity.this, getApplicationContext(), shareTitle, content,
                        UserAvatar, shareUrl);
                shareBoard.showAsDropDown(mOperationImage, 0, 8);
                break;
            case R.id.include_head_title_re1:
                String shareTitle1 = cCompanyEntity.BriefIntroduction;
                String content1 = cCompanyEntity.Introduction;
                String UserAvatar1 = cCompanyEntity.CompanyLogo;
                String shareUrl1 = cCompanyEntity.ShareLink;
                shareBoard = new CustomTitleShareBoard(
                        CompanyDetailActivity.this, getApplicationContext(), shareTitle1, content1,
                        UserAvatar1, shareUrl1);
                shareBoard.showAsDropDown(mOperationImage1, 0, 12);
                break;
            case R.id.include_head_title_re2:
                MemberEntity userInformation = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
                if ((userInformation.Role == MemberEntity.CompanyMember_Role_Boss) || (userInformation.Role == MemberEntity.CompanyMember_Role_Admin)) {
//                    ToastUtil.showInfo("管理");
                    showPopupWindow(view);
                } else {
                    ToastUtil.showInfo("只有老板或管理员才可以使用设置功能哦");
                }
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getCompanyReputationList(getIntent().getLongExtra("CompanyId", 0), pageIndex, 0, false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getCompanyReputationList(getIntent().getLongExtra("CompanyId", 0), pageIndex, 1, false);
    }

    private void getCompanyReputationList(final long CompanyId, final int pageIndex, final int tag, final boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<CCompanyEntity>() {
            @Override
            protected CCompanyEntity doInBackground(Void... params) {
                CCompanyEntity CompanyEntity = CompanyReputationRepository.getCompanyDetail(CompanyId, pageIndex);
                return CompanyEntity;
            }

            @Override
            protected void onPostExecute(CCompanyEntity CompanyEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (CompanyEntity != null) {
                    IsInitData = true;
                    ImageLoader.getInstance().displayImage(CompanyEntity.CompanyLogo, mCompanyLogo, options, animateFirstListener);
                    if (CompanyEntity.IsConcerned) {
                        mAttentionBt.setText("取消关注");
                    } else {
                        mAttentionBt.setText("关注");
                    }
                    if (CompanyEntity.IsClaim) {
                        mClaimBt.setText("已认领");
                    } else {
                        mClaimBt.setText("认领企业");
                    }
                    cCompanyEntity = CompanyEntity;
//                    CompanyName = CompanyEntity.CompanyName;
                    if ("FromB".equals(mFromResource)) {

                    } else {
                        title1.setText(CompanyEntity.CompanyName);
                    }
                    mCompanyName.setText(CompanyEntity.CompanyName);
                    mCompanyIndustry.setText(CompanyEntity.Industry);
                    mCompanyRegion.setText(CompanyEntity.Region);
                    mCompanySize.setText(CompanyEntity.CompanySize);
                    mRatingBar.setRating((float) CompanyEntity.Score);
                    mAllNumber.setText("总阅读 " + CompanyEntity.ReadCount + "   共" + CompanyEntity.CommentCount + "条点评    来自" + CompanyEntity.StaffCount + "位员工");
                    mLables.clear();
                    mLables.addAll(CompanyEntity.Labels);
                    mTagFlowAdapter.notifyDataChanged();
                    if (CompanyEntity.Recommend == 0){
                        roundProgressBar1.setVisibility(View.GONE);
                        mNoData1.setVisibility(View.VISIBLE);
                    } else {
                        roundProgressBar1.setVisibility(View.VISIBLE);
                        mNoData1.setVisibility(View.GONE);
                    }
                    if (CompanyEntity.Optimistic == 0){
                        roundProgressBar2.setVisibility(View.GONE);
                        mNoData2.setVisibility(View.VISIBLE);
                    } else {
                        roundProgressBar2.setVisibility(View.VISIBLE);
                        mNoData2.setVisibility(View.GONE);
                    }
                    if (CompanyEntity.SupportCEO == 0){
                        roundProgressBar3.setVisibility(View.GONE);
                        mNoData3.setVisibility(View.VISIBLE);
                    } else {
                        roundProgressBar3.setVisibility(View.VISIBLE);
                        mNoData3.setVisibility(View.GONE);
                    }
                    roundProgressBar1.setProgress(CompanyEntity.Recommend);
                    roundProgressBar2.setProgress(CompanyEntity.Optimistic);
                    roundProgressBar3.setProgress(CompanyEntity.SupportCEO);
//                    roundProgressBar1.setProgress(100);
//                    roundProgressBar2.setProgress(80);
//                    roundProgressBar3.setProgress(90);
                    if (CompanyEntity.Opinions.size() > 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
//                        mShowOrNot.setVisibility(View.VISIBLE);
                        content_is_null.setVisibility(View.GONE);
                        entities.addAll(CompanyEntity.Opinions);
                        mAdapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
//                            mShowOrNot.setVisibility(View.GONE);
                            content_is_null.setVisibility(View.VISIBLE);
                        }
                    }
                } else {
                    onRemoteError();
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    private void getCompanyReputationList(final long CompanyId) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isAttention = CompanyReputationRepository.concernedAttention(CompanyId);
                return isAttention;
            }

            @Override
            protected void onPostExecute(Boolean isAttention) {
                if (dialog != null)
                    dialog.dismiss();
                if (isAttention) {
//                    ToastUtil.showInfo("关注成功");
                    pageIndex = 1;
                    getCompanyReputationList(getIntent().getLongExtra("CompanyId", 0), pageIndex, 0, false);
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    @Override
    public void clickLiked(long OpinionId, int position) {
        LikedUtils.opinionLiked(OpinionId, position, this);
    }

    @Override
    public void clickLikedCallBack(int position) {
        if (entities.get(position).IsLiked) {
            entities.get(position).IsLiked = false;
            entities.get(position).LikedCount = entities.get(position).LikedCount - 1;
        } else {
            entities.get(position).IsLiked = true;
            entities.get(position).LikedCount = entities.get(position).LikedCount + 1;
        }
        mAdapter.setCompanyDetailDatas(entities);
    }

    public void showPopupWindow(View view) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_consume_type, null);
        RelativeLayout reIncomeRecord = (RelativeLayout) contentView.findViewById(R.id.re_income_record);
        TextView select_income_record = (TextView) contentView.findViewById(R.id.select_income_record);
        select_income_record.setText(getString(R.string.company_opinion_manage_opinion));
        RelativeLayout reExpenseRecord = (RelativeLayout) contentView.findViewById(R.id.re_expense_record);
        TextView select_expense_record = (TextView) contentView.findViewById(R.id.select_expense_record);
        select_expense_record.setText(getString(R.string.company_opinion_manage_label));
        RelativeLayout reWithdrawDepositRecord = (RelativeLayout) contentView.findViewById(R.id.re_withdraw_deposit_record);
        TextView select_withdraw_deposit_record = (TextView) contentView.findViewById(R.id.select_withdraw_deposit_record);
        select_withdraw_deposit_record.setText(getString(R.string.company_reputation_advanced_settings));
        reIncomeRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent ManageOpinion = new Intent(getApplicationContext(), ManageOpinionActivity.class);
                ManageOpinion.putExtra("OpinionCompanyId", getIntent().getLongExtra("CompanyId", 0));
                startActivity(ManageOpinion);
                popupWindow.dismiss();
            }
        });
        reExpenseRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent ManageLabel = new Intent(getApplicationContext(),ManageLableActivity.class);
                ManageLabel.putExtra("OpinionCompanyId", getIntent().getLongExtra("CompanyId", 0));
                ArrayList<String> mLabels = new ArrayList<String>();
                mLabels.addAll(cCompanyEntity.Labels);
                ManageLabel.putStringArrayListExtra("Labels",mLabels);
                startActivity(ManageLabel);
                popupWindow.dismiss();
            }
        });
        reWithdrawDepositRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent AdvancedSetting = new Intent(getApplicationContext(), SettingActivity.class);
                AdvancedSetting.putExtra("OpinionCompanyId", getIntent().getLongExtra("CompanyId", 0));
                AdvancedSetting.putExtra("IsCloseComment", cCompanyEntity.IsCloseComment);
                AdvancedSetting.putExtra("Advanced", "advanced");
                startActivity(AdvancedSetting);
                popupWindow.dismiss();
            }
        });
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mManagerBtText, 0, 22);

    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        Intent intent = new Intent(Intent.ACTION_DIAL);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setData(Uri.parse("tel:400-815-9166"));
        startActivity(intent);
    }
}
