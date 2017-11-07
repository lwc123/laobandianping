package com.juxian.bosscomments.fragment;

/**
 * Author: 张振清
 * Time: 2015/10/5
 * ProjectName: My Application
 * PackageName: com.pangzi.zhbj.fragment
 *
 * @version: V1.0
 */

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * fragment基类
 */
public abstract class BaseFragment extends Fragment {

    public Activity mActivity;

    // fragment创建
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Fragment也可以看成是一个布局界面，所以它也是自带有一个Activity对象，可以通过getActivity()方法获取到。
        mActivity = getActivity();
    }

    // 处理fragment的布局
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = initViews();
        return view;
    }

    // 依附的activity创建完成
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initData();
    }

    // 子类必须实现初始化布局的方法
    public abstract View initViews();

    // 初始化数据, 可以不实现
    public void initData() {

    }

    public int getAuditStatus(){
        return 0;
    }

    public String getAuditInfo(){
        return null;
    }

    public abstract void setData();

    public void setAllSelect(){}

    public void netWork(){

    }

    public int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }
}