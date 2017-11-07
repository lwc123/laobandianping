package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.BossCircleAdapter;
import com.juxian.bosscomments.models.BossDynamicEntity;
import com.juxian.bosscomments.repositories.BossCircleRepository;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.PauseOnScrollListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by Tam on 2016/12/26.
 */
public class BossCircleMyDynamicActivity extends BaseActivity implements BossCircleAdapter.CircleOperationListener, PullToRefreshBase.OnRefreshListener2<ListView>, BossCircleAdapter.ReplyAction {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_re)
    RelativeLayout include_head_title_re;
    @BindView(R.id.include_head_title_tab)
    ImageView include_head_title_tab;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.lin_circle)
    RelativeLayout lin_circle;
    @BindView(R.id.edt_circle)
    EditText mEdt_circle_comment;
    @BindView(R.id.tv_circle)
    TextView mSend_circle_comment;
    private List<BossDynamicEntity> entities;
    private BossCircleAdapter mBossCircleAdapter;
    private int PageIndex;
    private boolean isRefresh = true;
    private ImageLoader mImageLoader;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_boss_circle_my_dynamic;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        include_head_title_tab.setOnClickListener(this);
    }


    @Override
    protected void onResume() {
        super.onResume();
        PageIndex = 1;
        if (isRefresh) {
            getCircleDynamic(AppConfig.getCurrentUseCompany(), 10, PageIndex,true);
        } else {
            isRefresh = true;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 111:
                isRefresh = false;
                break;
            default:
                break;
        }
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        refreshListView.setOnRefreshListener(this);
        mImageLoader = ImageLoader.getInstance();
        refreshListView.getRefreshableView().setOnScrollListener(new PauseOnScrollListener(mImageLoader, true, true));
        refreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        title.setText("已发布");
//        include_head_title_tab.setImageResource(R.drawable.addition);
//        include_head_title_tab.setVisibility(View.VISIBLE);
        entities = new ArrayList<>();
        mBossCircleAdapter = new BossCircleAdapter(entities, this, this, this);
        refreshListView.setAdapter(mBossCircleAdapter);
        getCircleDynamic(AppConfig.getCurrentUseCompany(), 10, 1,true);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_tab://发布
                Intent intent = new Intent(this, BossCirclePostMsgActivity.class);
                startActivity(intent);
                break;
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    @Override
    public void deleteCircleDynamic(long CompanyId, long DynamicId, int pos) {
        PostDeleteCircleDynamic(CompanyId, DynamicId, pos);
    }

    @Override
    public void likeCircleDynamic(long CompanyId, long DynamicId, int pos, boolean b, View
            view) {
        PostLikeCircleDynamic(CompanyId, DynamicId, pos, b, view);
    }


    @Override
    public void commentCircleDynamic(int pos,View view) {
//        currentDynamicPos = pos;
//        if (softInputIsVisiable) {
//            softInputIsVisiable = false;
//            updateEditTextBodyVisible(mEdt_circle_comment.VISIBLE);
//        } else {
//            updateEditTextBodyVisible(mEdt_circle_comment.GONE);
//            softInputIsVisiable = true;
//        }
    }

    private void getCircleDynamic(final long companyId, final int Size, final int PageIndex,boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<List<BossDynamicEntity>>() {
            @Override
            protected List<BossDynamicEntity> doInBackground(Void... params) {
                List<BossDynamicEntity> dynamicEntities = BossCircleRepository.getBossCircleMyDynamic(companyId, Size, PageIndex);
                return dynamicEntities;
            }

            @Override
            protected void onPostExecute(List<BossDynamicEntity> dynamicEntities) {
                if (dialog != null)
                    dialog.dismiss();
                if (dynamicEntities != null) {
//                    ToastUtil.showInfo("获取成功");
                    if (dynamicEntities.size() > 0) {
                        if (PageIndex == 1) {
                            entities.clear();
                        }
                        entities.addAll(dynamicEntities);
                        mBossCircleAdapter.notifyDataSetChanged();
                    }
                } else {
                    ToastUtil.showInfo("暂无更多动态");
                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                refreshListView.onRefreshComplete();
                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }

    private void PostDeleteCircleDynamic(final long CompanyId, final long DynamicId, final int pos) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = BossCircleRepository.getBossCircleDeleteDynamic(CompanyId, DynamicId);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                dialog.dismiss();
                if (model) {
                    setResult(RESULT_OK);
                    ToastUtil.showInfo("删除成功");
                    entities.remove(pos);
                    mBossCircleAdapter.notifyDataSetChanged();
                } else {
                    ToastUtil.showInfo("删除失败");
                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                refreshListView.onRefreshComplete();
                dialog.dismiss();
//                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }

    private void PostLikeCircleDynamic(final long CompanyId, final long DynamicId, final int Pos, final boolean b, final View view) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = BossCircleRepository.getBossCircleLikedDynamic(CompanyId, DynamicId);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (dialog != null)
                    dialog.dismiss();
                if (model) {
                    if (b == true) {//之前点过赞
                        setResult(RESULT_OK);
                        entities.get(Pos).LikedNum--;
                        ToastUtil.showInfo("取消赞成功");
                        entities.get(Pos).IsLiked = false;
                        ((ImageView) view).setImageResource(R.drawable.red_like);
                    } else {
                        entities.get(Pos).LikedNum++;
                        ToastUtil.showInfo("点赞成功");
                        entities.get(Pos).IsLiked = true;
                        ((ImageView) view).setImageResource(R.drawable.black_like);
                    }
                    if (entities.get(Pos).LikedNum <= 0) {
                        entities.get(Pos).LikedNum = 0;
                    }
                    mBossCircleAdapter.notifyDataSetChanged();
                } else {
                    ToastUtil.showInfo("点赞失败");
                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                refreshListView.onRefreshComplete();
//                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        PageIndex = 1;
        getCircleDynamic(AppConfig.getCurrentUseCompany(), 10, PageIndex,false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        PageIndex++;
        getCircleDynamic(AppConfig.getCurrentUseCompany(), 10, PageIndex,false);
    }

    private int CommentTag;

    @Override
    public void replayAction(View view, String CompanyAbbr, int position, int Tag) {
//        updateEditTextBodyVisible();
//        CommentTag = Tag;
//        mEdt_circle_comment.setHint("回复" + CompanyAbbr + ":");
    }

//    public void updateEditTextBodyVisible() {
//        if (lin_circle.getVisibility() == View.GONE) {
//            lin_circle.setVisibility(View.VISIBLE);
//            mEdt_circle_comment.requestFocus();
//            //弹出键盘
//            CommonUtils.showSoftInput(mEdt_circle_comment.getContext(), mEdt_circle_comment);
//
//        } else if (lin_circle.getVisibility() == View.VISIBLE) {
//            //隐藏键盘
//            CommonUtils.hideSoftInput(mEdt_circle_comment.getContext(), mEdt_circle_comment);
//        }
//    }

//    private void PostCommentCircleDynamic(final BossDynamicCommentEntity entity) {
//        new AsyncRunnable<Long>() {
//            @Override
//            protected Long doInBackground(Void... params) {
//                Long id = BossCircleRepository.postBossCircleCommentdDynamic(entity);
//                return id;
//            }
//
//            @Override
//            protected void onPostExecute(Long id) {
//                if (id > 0) {
//                    entities.get(currentDynamicPos).Comment.add(entity);
//                    mBossCircleAdapter.notifyDataSetChanged();
//                    ToastUtil.showInfo("评论成功");
////                    finish();
//                } else {
//                    ToastUtil.showInfo("评论失败");
//                }
//            }
//
//            protected void onPostError(Exception ex) {
////                ToastUtil.showError(getString(R.string.net_false_hint));
//            }
//        }.execute();
//    }
}
