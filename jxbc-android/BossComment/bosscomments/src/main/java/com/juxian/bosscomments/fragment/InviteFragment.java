package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.BossCircleAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BossDynamicCommentEntity;
import com.juxian.bosscomments.models.BossDynamicEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.BossCircleRepository;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.ui.BossCircleMyDynamicActivity;
import com.juxian.bosscomments.ui.BossCirclePostMsgActivity;
import com.juxian.bosscomments.utils.CommonUtils;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.nostra13.universalimageloader.core.listener.PauseOnScrollListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * 老板圈
 */
public class InviteFragment extends BaseFragment implements View.OnClickListener, BossCircleAdapter.CircleOperationListener, PullToRefreshBase.OnRefreshListener2<ListView>, BossCircleAdapter.ReplyAction {

    private static final String PARAM = "param";
    private String mParam;
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
    //    @BindView(R.id.lin_circle)
//    RelativeLayout lin_circle;
//    @BindView(R.id.tv_circle)
//    TextView mSend_circle_comment;
    @BindView(R.id.boss_circle)
    RelativeLayout mRootView;
    @BindView(R.id.ll_parent)
    LinearLayout ll_parent;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    @BindView(R.id.circle_cp_name1)
    TextView circle_cp_name1;
    @BindView(R.id.circle_user_head1)
    ImageView circle_user_head1;
    @BindView(R.id.viewPop)
    View mViewPopLocation;
    private List<BossDynamicEntity> entities;
    private BossCircleAdapter mBossCircleAdapter;

    private View refreshListViewHeader;
    private TextView circle_cp_name;
    private ImageView circle_user_head;
    private ImageLoader imageLoader;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_MY_CENTER_AVATAR_OPTIONS;
    private InputMethodManager mInputMethodManager;
    private int currentDynamicPos;
    private int currentKeyboardH;
    // 软键盘的显示状态
    public int PageIndex = 1;
    private long FirstClick;

    public static InviteFragment newInstance(String param) {
        InviteFragment fragment = new InviteFragment();
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
        include_head_title_re.setOnClickListener(this);
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

        View view = View.inflate(mActivity, R.layout.activity_boss_circle_home, null);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
//        setListenerToRootView();
        title.setText("老板圈");
        title.setOnClickListener(this);
        back.setVisibility(View.GONE);
        include_head_title_tab.setImageResource(R.drawable.addition);
        include_head_title_tab.setVisibility(View.VISIBLE);
        include_head_title_tab.setOnClickListener(this);
        imageLoader = ImageLoader.getInstance();
        //滑动不加载图片
        refreshListView.getRefreshableView().setOnScrollListener(new PauseOnScrollListener(imageLoader, true, true));
        initRefreshListView();
        addGlobalListener();

        entities = new ArrayList<>();
        mBossCircleAdapter = new BossCircleAdapter(entities, getContext(), this, this);
        refreshListView.setAdapter(mBossCircleAdapter);
    }

    private void initSoftInput() {
        mSend_circle_comment.setOnClickListener(this);
        mEdt_circle_comment.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.length() > 0) {
                    mSend_circle_comment.setBackgroundResource(R.drawable.bt_send_boss_circle_ok);
                } else {
                    mSend_circle_comment.setBackgroundResource(R.drawable.bt_send_boss_circle);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    int statusBarHeight;//状态栏高度
    int screenHeight; // 屏幕高度
    int keyboardHeight; //键盘弹出高度

    private void addGlobalListener() {
        ViewTreeObserver.OnGlobalLayoutListener globalLayoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {

            @Override
            public void onGlobalLayout() {
                // 应用可以显示的区域。此处包括应用占用的区域，包括标题栏不包括状态栏
                Rect r = new Rect();
                ll_parent.getWindowVisibleDisplayFrame(r);
                // 键盘最小高度
                int minKeyboardHeight = 150;
                // 获取状态栏高度
                statusBarHeight = getStatusBarHeight();
                // 屏幕高度,不含虚拟按键的高度
                screenHeight = ll_parent.getRootView().getHeight();
                // 在不显示软键盘时，height等于状态栏的高度
                keyboardHeight = screenHeight - r.bottom;

//                Log.e(Global.LOG_TAG, "  clickHeightToBottom-->" + clickHeightToBottom + "  keyboradHeight-->" + keyboardHeight);//1282-100
                //height==0，说明这时软键盘已经收起
                if (keyboardHeight == 0) {
                    if (popWindow != null) {
                        popWindow.dismiss();
                    }
                } else {
//                    if (clickHeightToBottom > keyboardHeight) {
////                        Log.e(Global.LOG_TAG, "高于键盘高度");
//                    } else {
//                        Log.e(Global.LOG_TAG, "低于键盘高度");
//                        refreshListView.getRefreshableView().smoothScrollBy(keyboardHeight, 500);
//                    }
                }
            }
        };
        ll_parent.getViewTreeObserver().addOnGlobalLayoutListener(globalLayoutListener);
    }

    private void initRefreshListView() {
        refreshListView.setOnRefreshListener(this);
        refreshListView.setMode(PullToRefreshBase.Mode.BOTH);//允许下拉上拉

        refreshListView.getRefreshableView().setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView absListView, int i) {

                switch (i) {
                    case AbsListView.OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:
                        if (lin_circle != null) {
                            popWindow.dismiss();
                            CommonUtils.hideSoftInput(lin_circle.getContext(), lin_circle);
                        }
                        break;
                    default:
                        break;
                }
            }

            @Override
            public void onScroll(AbsListView absListView, int i, int i1, int i2) {

            }
        });
        refreshListViewHeader = LayoutInflater.from(getActivity().getApplicationContext()).inflate(R.layout.include_head_circle, null);
//        ImageView circle_bg = (ImageView) refreshListViewHeader.findViewById(R.id.circle_bg);
//        circle_bg.setBackgroundResource();
        circle_user_head = (ImageView) refreshListViewHeader.findViewById(R.id.circle_user_head);
        circle_user_head.setOnClickListener(this);
        circle_cp_name = (TextView) refreshListViewHeader.findViewById(R.id.circle_cp_name);

        refreshListView.getRefreshableView().addHeaderView(refreshListViewHeader, null, false);
        refreshListView.setDividerPadding(0);
    }

    @Override
    public void setData() {
        PageIndex = 1;
        getCompanyMessage(AppConfig.getCurrentUseCompany());
        getCircleDynamic(AppConfig.getCurrentUseCompany(), PageIndex, 0);

    }

    public void moveToTop() {
        if (refreshListView != null) {
            refreshListView.getRefreshableView().setSelection(0);
        }
    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_tab://发布
                MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
                if (memberEntity.Role == MemberEntity.CompanyMember_Role_Boss) {
                    Intent intent = new Intent(getActivity(), BossCirclePostMsgActivity.class);
                    getActivity().startActivityForResult(intent, 3);
                } else {
                    ToastUtil.showInfo("只有老板才可以发布内容哦~");
                }
                break;
            case R.id.circle_user_head: //我的发布
                Intent intentpost = new Intent(getActivity(), BossCircleMyDynamicActivity.class);
//                startActivity(intent1);
                getActivity().startActivityForResult(intentpost, 2);
                break;
            case R.id.tv_circle:
                BossDynamicCommentEntity entity = new BossDynamicCommentEntity();
                if (TextUtils.isEmpty(mEdt_circle_comment.getText().toString().trim())) {
                    ToastUtil.showInfo("请输入评论内容");
                    return;
                }
                if (mEdt_circle_comment.getText().toString().trim().length() > 140) {
                    ToastUtil.showInfo("评论最多140字");
                    return;
                }
                if (CommentTag == 1) {
                    //回复别人的评论
                    entity.Content = mEdt_circle_comment.getText().toString();
                    entity.DynamicId = entities.get(currentDynamicPos).DynamicId;
                    entity.CompanyId = AppConfig.getCurrentUseCompany();
                    entity.CompanyAbbr = AppConfig.getCompanyAbbr();
                    PostCommentCircleDynamic(entity);
                } else {
                    //对动态进行评论
                    entity.Content = mEdt_circle_comment.getText().toString().trim();
                    entity.DynamicId = entities.get(currentDynamicPos).DynamicId;
                    entity.CompanyId = AppConfig.getCurrentUseCompany();
                    entity.CompanyAbbr = AppConfig.getCompanyAbbr();
                    PostCommentCircleDynamic(entity);
                }

                break;
            case R.id.include_head_title_title:
                long newClick = System.currentTimeMillis();
                if (newClick - FirstClick < 1.5 * 1000) {
                    setData();
                }
                FirstClick = newClick;
                break;
            default:
                break;
        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void deleteCircleDynamic(long CompanyId, long DynamicId, int pos) {
        PostDeleteCircleDynamic(CompanyId, DynamicId, pos);
    }

    @Override
    public void likeCircleDynamic(long CompanyId, long DynamicId, int pos, boolean b, View view) {
        PostLikeCircleDynamic(CompanyId, DynamicId, pos, b, view);
    }

    int clickHeightToBottom;

    @Override
    public void commentCircleDynamic(int pos, View view) {
        currentDynamicPos = pos;
        int Pos[] = {-1, -1};  //保存当前坐标的数组
        view.getLocationOnScreen(Pos);
        clickHeightToBottom = screenHeight -  Pos[1]; //点击位置到底部距离
        showPopup(mViewPopLocation);
    }

    private PopupWindow popWindow;
    private EditText mEdt_circle_comment;
    private RelativeLayout lin_circle;
    private TextView mSend_circle_comment;

    private void showPopup(View parent) {
        if (popWindow == null) {
            LayoutInflater layoutInflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View view = layoutInflater.inflate(R.layout.popwindow_pinglun, null);
            lin_circle = (RelativeLayout) view.findViewById(R.id.lin_circle);
            mEdt_circle_comment = (EditText) view.findViewById(R.id.edt_circle);
            mSend_circle_comment = (TextView) view.findViewById(R.id.tv_circle);
            // 创建一个PopuWidow对象
            popWindow = new PopupWindow(view, LinearLayout.LayoutParams.FILL_PARENT, 200, true);
        }

        //popupwindow弹出时的动画     popWindow.setAnimationStyle(R.style.popupWindowAnimation);
        // 使其聚集 ，要想监听菜单里控件的事件就必须要调用此方法
        popWindow.setFocusable(true);
        // 设置允许在外点击消失
        popWindow.setOutsideTouchable(false);
        // 设置背景，点击非popwindow隐藏popwindow，点击“返回Back”也能使其消失，并且并不会影响你的背景
        popWindow.setBackgroundDrawable(new BitmapDrawable());
        //软键盘不会挡着popupwindow
        popWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        //设置菜单显示的位置
        if (popWindow.isShowing()) {
            popWindow.dismiss();
            CommonUtils.hideSoftInput(lin_circle.getContext(), lin_circle);
        } else {
            popWindow.showAtLocation(parent, Gravity.BOTTOM, 0, 0);
            initSoftInput();
            CommonUtils.showSoftInput(lin_circle.getContext(), lin_circle);
            mEdt_circle_comment.setHint("说点什么...");
        }
    }

    private void getCircleDynamic(final long companyId, final int PageIndex, final int tag) {

        new AsyncRunnable<List<BossDynamicEntity>>() {
            @Override
            protected List<BossDynamicEntity> doInBackground(Void... params) {
                List<BossDynamicEntity> dynamicEntities = BossCircleRepository.getBossCircleHome(companyId, PageIndex);
                return dynamicEntities;
            }

            @Override
            protected void onPostExecute(List<BossDynamicEntity> dynamicEntities) {
                if (dynamicEntities != null) {
//                    ToastUtil.showInfo("获取成功");
                    if (dynamicEntities.size() > 0) {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(dynamicEntities);
                            mBossCircleAdapter.notifyDataSetChanged();
                            moveToTop();
                        } else {
                            entities.addAll(dynamicEntities);
                            mBossCircleAdapter.notifyDataSetChanged();
                        }
                        content_is_null.setVisibility(View.GONE);
                        mRootView.setVisibility(View.VISIBLE);
                    } else {
                        if (tag == 0) {//下拉
                            content_is_null.setVisibility(View.VISIBLE);
                            mRootView.setVisibility(View.GONE);
                            entities.clear();
                            entities.addAll(dynamicEntities);
                            mBossCircleAdapter.notifyDataSetChanged();
                        } else {
                            ToastUtil.showInfo("没有更多数据了");
                        }
                    }
                } else {
                    content_is_null.setVisibility(View.VISIBLE);
                    mRootView.setVisibility(View.GONE);

                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
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
                if (dialog != null)
                    dialog.dismiss();
                if (model) {
                    ToastUtil.showInfo("删除成功");
                    entities.remove(pos);
                    mBossCircleAdapter.notifyDataSetChanged();
                } else {
                    ToastUtil.showInfo("删除失败");
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

    private void PostCommentCircleDynamic(final BossDynamicCommentEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Long>() {
            @Override
            protected Long doInBackground(Void... params) {
                Long id = BossCircleRepository.postBossCircleCommentdDynamic(entity);
                return id;
            }

            @Override
            protected void onPostExecute(Long id) {
                if (dialog != null)
                    dialog.dismiss();
                if (id > 0) {
                    if (CommentTag == 1) {
                        ToastUtil.showInfo("回复成功");
                        //单独刷新列表适配器，不全部刷新适配器
//                        mBossCircleAdapter.refresh(CommenItemPos, entity);
                    } else {
                        entities.get(currentDynamicPos).CommentCount++;
                        entities.get(currentDynamicPos).Comment.add(entity);
                        mBossCircleAdapter.notifyDataSetChanged();
                    }
                    popWindow.dismiss();
//                    ToastUtil.showInfo("评论成功");
                    mEdt_circle_comment.setText("");
                    mSend_circle_comment.setBackgroundResource(R.drawable.bt_send_boss_circle);
                } else {
//                    ToastUtil.showInfo("评论失败");
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

    private void PostLikeCircleDynamic(final long CompanyId, final long DynamicId, final int Pos, final boolean b, final View view) {
//        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = BossCircleRepository.getBossCircleLikedDynamic(CompanyId, DynamicId);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
//                dialog.dismiss();
                if (model) {
                    if (b == true) {//之前点过赞
                        entities.get(Pos).LikedNum--;
//                        ToastUtil.showInfo("取消赞成功");
                        entities.get(Pos).IsLiked = false;
                        ((ImageView) view).setImageResource(R.drawable.red_like);
                    } else {
                        entities.get(Pos).LikedNum++;
//                        ToastUtil.showInfo("点赞成功");
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
//                dialog.dismiss();
                refreshListView.onRefreshComplete();
//                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }

    private void getCompanyMessage(final long CompanyId) {
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getMine(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (entity != null) {
                    imageLoader.displayImage(entity.CompanyLogo, circle_user_head1, options, animateFirstListener);
                    imageLoader.displayImage(entity.CompanyLogo, circle_user_head, options, animateFirstListener);
                    if (!TextUtils.isEmpty(entity.CompanyName)) {
                        circle_cp_name1.setText(entity.CompanyName);
                        circle_cp_name.setText(entity.CompanyName);
                    } else {
                        circle_cp_name1.setText("");
                        circle_cp_name.setText("");
                    }
                }
            }

            protected void onPostError(Exception ex) {
            }
        }.execute();
    }

    private int getStatusBarHeight() {
        int result = 0;
        int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        PageIndex = 1;
        getCircleDynamic(AppConfig.getCurrentUseCompany(), PageIndex, 0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        PageIndex++;
        getCircleDynamic(AppConfig.getCurrentUseCompany(), PageIndex, 1);
    }

    private int CommentTag;
    private int CommenItemPos;

    /**
     * @param view
     * @param CompanyAbbr 要回复条目的公司简称
     * @param position    评论条目位置
     * @param Tag         1为回复评论
     */
    @Override
    public void replayAction(View view, final String CompanyAbbr, int position, int Tag) {
//        updateEditTextBodyVisible();
//        CommentTag = Tag;
//        CommenItemPos = position;
//        mEdt_circle_comment.setHint("回复" + CompanyAbbr + ":");
    }
}
