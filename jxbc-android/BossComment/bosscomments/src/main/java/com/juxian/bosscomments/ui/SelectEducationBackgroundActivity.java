package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.kankan.wheel.widget.OnWheelChangedListener;
import com.kankan.wheel.widget.OnWheelClickedListener;
import com.kankan.wheel.widget.WheelView;
import com.kankan.wheel.widget.adapters.ArrayWheelAdapter;

public class SelectEducationBackgroundActivity extends BaseActivity implements OnClickListener, OnWheelChangedListener,OnWheelClickedListener {

    private WheelView mViewSelectCompanyScale;
    private TextView mBtnConfirm;
    /**
     * 所有钱
     */
    protected String[] mAllBottomSalary = {"大专以下", "大专", "本科", "研究生", "硕士",
            "博士"};
    /**
     * 当前钱的下限值
     */
    protected String mCurrentBottomSalary;

    @Override
    public int getContentViewId() {
        return R.layout.activity_one_wheel;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_one_wheel);
        setUpViews();
        setUpListener();
        setUpData();
        WindowManager m = getWindowManager();
        Display d = m.getDefaultDisplay();  //为获取屏幕宽、高

        WindowManager.LayoutParams p = getWindow().getAttributes();  //获取对话框当前的参数值
//        p.height = (int) (d.getHeight() * 1.0);   //高度设置为屏幕的1.0
        p.width = (int) (d.getWidth() * 1.0);    //宽度设置为屏幕的0.8
//        p.alpha = 1.0f;      //设置本身透明度
//        p.dimAmount = 0.0f;      //设置黑暗度

        getWindow().setBackgroundDrawableResource(R.drawable.chuntouming);
        getWindow().setAttributes(p);     //设置生效
        getWindow().setGravity(Gravity.BOTTOM);
//        getWindow().setWindowAnimations(R.style.default_dialog_animation);
    }

    private void setUpViews() {
        mViewSelectCompanyScale = (WheelView) findViewById(R.id.id_company_person_number);
        mBtnConfirm = (TextView) findViewById(R.id.btn_confirm);
    }

    private void setUpListener() {
        // 添加change事件
        mViewSelectCompanyScale.addChangingListener(this);
        mViewSelectCompanyScale.addClickingListener(this);
        // 添加onclick事件
        mBtnConfirm.setOnClickListener(this);
    }

    private void setUpData() {
        mViewSelectCompanyScale.setViewAdapter(new ArrayWheelAdapter<String>(
                SelectEducationBackgroundActivity.this, mAllBottomSalary));
        // 设置可见条目数量
        mViewSelectCompanyScale.setVisibleItems(5);
        mViewSelectCompanyScale.setCurrentItem(mAllBottomSalary.length/2);
        // updateCities();
        // updateAreas();
        // 设置默认选中
        mCurrentBottomSalary = mAllBottomSalary[0];
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        // TODO Auto-generated method stub
        if (wheel == mViewSelectCompanyScale) {
            int pCurrent = mViewSelectCompanyScale.getCurrentItem();
            mCurrentBottomSalary = mAllBottomSalary[pCurrent];
        }
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        super.onClick(v);
        switch (v.getId()) {
            case R.id.btn_confirm:
                showSelectedResult();
                break;
            default:
                break;
        }

    }

    private void showSelectedResult() {
        // Toast.makeText(ThreeLevelActivity.this,
        // "当前选中:"+mCurrentProviceName+","+mCurrentCityName+","
        // +mCurrentDistrictName+","+mCurrentZipCode,
        // Toast.LENGTH_SHORT).show();
        Intent intent = new Intent();
        intent.putExtra("Education_Background", mCurrentBottomSalary);
        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    public void onItemClicked(WheelView wheel, int itemIndex) {

    }
}
