package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;
import android.widget.RelativeLayout;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.CompanyListAdapter;
import com.juxian.bosscomments.listener.ClickLikedListener;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.OpinionTotalEntity;
import com.juxian.bosscomments.models.TopicEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.ui.SearchCompanyActivity;
import com.juxian.bosscomments.ui.SingleTypeCompanyActivity;
import com.juxian.bosscomments.utils.GlideImageLoader;
import com.juxian.bosscomments.utils.apiutils.LikedUtils;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.Transformer;
import com.youth.banner.listener.OnBannerListener;

import net.juxian.appgenome.utils.AsyncRunnable;
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
 * Created by nene on 2017/4/14.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/14 16:45]
 * @Version: [v1.0]
 */
public class CompanyListFragment extends BaseFragment implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView>, ClickLikedListener,LikedUtils.ClickLikedCallBackListener {

    @BindView(R.id.activity_search)
    RelativeLayout mSearchCompany;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.activity_cc_page_error_rela)
    RelativeLayout mSearchBg;
    private CompanyListAdapter mAdapter;
    private static final String PARAM = "param";
    private String mParam;
    private List<OpinionEntity> mCompanyEntities;
    private View mCompanyListHeaderView;
    private Banner mBanner;
    private List<TopicEntity> mTopicEntities;
    private List<String> images;
    private List<String> titles;
    private int pageIndex = 1;
    private static onRefreshRedPointListener listener;
    private Dialog dialog;

    public static CompanyListFragment newInstance(String param,onRefreshRedPointListener onRefreshRedPointListener) {
        listener = onRefreshRedPointListener;
        CompanyListFragment fragment = new CompanyListFragment();
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
    public View initViews() {
        View view = View.inflate(mActivity, R.layout.fragment_company_list, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
        // 初始化数据
        mSearchBg.setBackgroundColor(getResources().getColor(R.color.main_background));
        images = new ArrayList<>();
        mTopicEntities = new ArrayList<>();
        images.add("http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg");
        images.add("http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg");
        images.add("http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg");
        titles = new ArrayList<>();
        titles.add("123");
        titles.add("456");
        titles.add("789");
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mCompanyListHeaderView = LayoutInflater.from(getContext()).inflate(R.layout.banner_company_list, null);
        mBanner = (Banner) mCompanyListHeaderView.findViewById(R.id.banner);
        mBanner.setVisibility(View.GONE);
        mBanner.setBannerStyle(BannerConfig.CIRCLE_INDICATOR);
        //设置图片加载器
        mBanner.setImageLoader(new GlideImageLoader());
        //设置图片集合
        mBanner.setImages(images);
        //设置banner动画效果
        mBanner.setBannerAnimation(Transformer.Default);
        //设置标题集合（当banner样式有显示title时）
        mBanner.setBannerTitles(titles);
        //设置自动轮播，默认为true
        mBanner.isAutoPlay(true);
        //设置轮播时间
        mBanner.setDelayTime(3000);
        //设置指示器位置（当banner模式中有指示器时）
        mBanner.setIndicatorGravity(BannerConfig.CENTER);
        //banner设置方法全部调用完毕时最后调用
        mBanner.start();
        mRefreshListView.getRefreshableView().addHeaderView(mCompanyListHeaderView, null, false);
        mCompanyEntities = new ArrayList<>();

        mAdapter = new CompanyListAdapter(mCompanyEntities, getActivity(), this,"All");
        mRefreshListView.setAdapter(mAdapter);
        getCompanyReputationBannerList();
        getCompanyReputationList(pageIndex, 0, true);
        // 添加监听
        mSearchCompany.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mBanner.setOnBannerListener(new OnBannerListener() {
            @Override
            public void OnBannerClick(int position) {
                if (mTopicEntities.size() > 0) {
                    Intent intent = new Intent(getActivity(), SingleTypeCompanyActivity.class);
                    intent.putExtra("TopicId", mTopicEntities.get(position).TopicId);
                    intent.putExtra("TopicTitle", mTopicEntities.get(position).TopicName);
                    startActivity(intent);
                }
            }
        });
    }

    @Override
    public void setData() {
        pageIndex = 1;
        getCompanyReputationList(pageIndex, 0, true);
    }

    @Override
    public void onResume() {
        super.onResume();
        pageIndex = 1;
        getCompanyReputationList(pageIndex, 0, false);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.activity_search:
                Intent intent = new Intent(getActivity(),SearchCompanyActivity.class);
                startActivity(intent);
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getCompanyReputationList(pageIndex, 0, false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getCompanyReputationList(pageIndex, 1, false);
    }

    private void getCompanyReputationList(final int page, final int tag, final boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<OpinionTotalEntity>() {
            @Override
            protected OpinionTotalEntity doInBackground(Void... params) {
                OpinionTotalEntity opinionTotalEntity = CompanyReputationRepository.getCompanyReputationList(page);
                return opinionTotalEntity;
            }

            @Override
            protected void onPostExecute(OpinionTotalEntity opinionTotalEntity) {
                dialog.dismiss();
                if (opinionTotalEntity != null) {
                    listener.onRefreshRedPoint(opinionTotalEntity.IsRedDot);
                    if (opinionTotalEntity.Opinions.size() != 0) {
                        if (tag == 0) {
                            // 下拉刷新
                            mCompanyEntities.clear();
                        }
                        mCompanyEntities.addAll(opinionTotalEntity.Opinions);
                        mAdapter.notifyDataSetChanged();
                    } else {

                    }
                } else {
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                dialog.dismiss();
            }
        }.execute();
    }

    private void getCompanyReputationBannerList() {
//        DialogUtils.showLoadingDialog();
        new AsyncRunnable<List<TopicEntity>>() {
            @Override
            protected List<TopicEntity> doInBackground(Void... params) {
                List<TopicEntity> TopicEntities = CompanyReputationRepository.getCompanyReputationBannerList();
                return TopicEntities;
            }

            @Override
            protected void onPostExecute(List<TopicEntity> TopicEntities) {
//                DialogUtils.hideLoadingDialog();
                if (TopicEntities != null) {
                    if (TopicEntities.size() > 0) {
                        mTopicEntities.clear();
                        mTopicEntities.addAll(TopicEntities);
                        List<String> list = new ArrayList<>();
                        for (int i = 0; i < TopicEntities.size(); i++) {
                            list.add(TopicEntities.get(i).BannerPicture);
                        }
                        // 这里在使用修改的时候，需要使用一个新的集合
                        mBanner.update(list);
                        mBanner.setVisibility(View.VISIBLE);
                    } else {
                        mBanner.setVisibility(View.GONE);
                    }
                } else {
                    mBanner.setVisibility(View.GONE);
                }
            }

            protected void onPostError(Exception ex) {
//                DialogUtils.hideLoadingDialog();
                mBanner.setVisibility(View.GONE);
            }
        }.execute();
    }

    private void opinionLiked(final long OpinionId,final int position) {
//        DialogUtils.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isLiked = CompanyReputationRepository.opinionLiked(OpinionId);
                return isLiked;
            }

            @Override
            protected void onPostExecute(Boolean isLiked) {
//                DialogUtils.hideLoadingDialog();
                if (isLiked) {
                    ToastUtil.showInfo("点赞成功");
                    if (mCompanyEntities.get(position).IsLiked){
                        mCompanyEntities.get(position).IsLiked = false;
                        mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount-1;
                    } else {
                        mCompanyEntities.get(position).IsLiked = true;
                        mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount+1;
                    }
                    mAdapter.setCompanyListDatas(mCompanyEntities);
//                    if (position >= 0) {
//                        int startShownIndex = mRefreshListView.getRefreshableView().getFirstVisiblePosition();
//                        int endShownIndex = mRefreshListView.getRefreshableView().getLastVisiblePosition();
//                        if (position >= startShownIndex
//                                && position <= endShownIndex) {
//                            View view = mRefreshListView.getChildAt(position - startShownIndex);
//                            mAdapter.getView(position, view, mRefreshListView);
//                        }
//
//                    }
                } else {
                    ToastUtil.showInfo("点赞失败");
                }
            }

            protected void onPostError(Exception ex) {
//                DialogUtils.hideLoadingDialog();
            }
        }.execute();
    }

    @Override
    public void clickLiked(long OpinionId,int position) {
        LikedUtils.opinionLiked(OpinionId,position,this);
    }

    @Override
    public void clickLikedCallBack(int position) {
        if (mCompanyEntities.get(position).IsLiked){
            mCompanyEntities.get(position).IsLiked = false;
            mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount-1;
        } else {
            mCompanyEntities.get(position).IsLiked = true;
            mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount+1;
        }
        mAdapter.setCompanyListDatas(mCompanyEntities);
    }

    public interface onRefreshRedPointListener{
        void onRefreshRedPoint(boolean IsRedDot);
    }
}
