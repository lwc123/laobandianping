package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.kankan.wheel.widget.OnWheelChangedListener;
import com.kankan.wheel.widget.WheelView;
import com.kankan.wheel.widget.adapters.ArrayWheelAdapter;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class EditTimeActivity extends BaseActivity implements
        OnClickListener, OnWheelChangedListener {

    private WheelView mViewYear;
    private WheelView mViewMonth;
    private WheelView mViewDay;
    private TextView mBtnConfirm;
    private TextView mCancel;
    private List<String> list_year;
    @BindView(R.id.start_time)
    TextView title;
    private int type;
    /**
     * 年份
     */
    protected String[] year;
    protected String[] year1;
    /**
     * 月份
     */
    protected String[] month;
    protected String[] month1;
    /**
     * 天数
     */
    protected String[] days;
    protected String[] days1;
    /**
     * 当前选择的年份，带1的是存储有年字的，不带1的是存数字
     */
    protected String mCurrentYear;
    protected String mCurrentYear1;
    /**
     * 当前选择的月份
     */
    protected String mCurrentMonth;
    protected String mCurrentMonth1;
    /**
     * 当前选择的日
     */
    protected String mCurrentDay;
    protected String mCurrentDay1;
    private Calendar calendar;
    private int nowYear;
    private TextView current_date;

    @Override
    public int getContentViewId() {
        return R.layout.activity_edit_time;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);

        list_year = new ArrayList<String>();
        initYear();
        year = new String[list_year.size()];
        year1 = new String[list_year.size()];
        for (int i = 0; i < list_year.size(); i++) {
            year[i] = list_year.get(i);
            year1[i] = list_year.get(i) + "年";
        }
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
    }

    private void initYear() {
        calendar = Calendar.getInstance();
        nowYear = calendar.get(Calendar.YEAR);
        for (int i = nowYear; i >= nowYear - 30; i--) {
            list_year.add(i + "");
        }
    }

    private void setUpViews() {
        mViewYear = (WheelView) findViewById(R.id.id_year);
        mViewMonth = (WheelView) findViewById(R.id.id_mouth);
        mViewDay = (WheelView) findViewById(R.id.id_day);
        mBtnConfirm = (TextView) findViewById(R.id.btn_confirm);
        current_date = (TextView) findViewById(R.id.current_date);
        mCancel = (TextView) findViewById(R.id.cancel);
    }

    private void setUpListener() {
        // 添加change事件
        mViewYear.addChangingListener(this);
        // 添加change事件
        mViewMonth.addChangingListener(this);
        mViewDay.addChangingListener(this);
        // 添加onclick事件
        mBtnConfirm.setOnClickListener(this);
        mCancel.setOnClickListener(this);
    }

    private void setUpData() {
        mViewYear.setViewAdapter(new ArrayWheelAdapter<String>(EditTimeActivity.this, year1));
        mViewYear.setCyclic(false);
        mViewMonth.setCyclic(true);
        mViewDay.setCyclic(true);
        // 设置可见条目数量
        mViewYear.setVisibleItems(5);
        mViewMonth.setVisibleItems(5);
        mViewDay.setVisibleItems(5);
        mCurrentYear = year[0];
//		mCurrentTopSalary = month[0];
        updateMonth();
        initData();
        current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
    }

    private void initData() {
        String data = getIntent().getStringExtra("data");
        if (TextUtils.isEmpty(data)) {
            updateMonth();
            mViewYear.setCurrentItem(0);
            mViewMonth.setCurrentItem(0);
            mViewDay.setCurrentItem(0);

        } else {
            String dataYear = data.substring(0, 5);
            String dataMonth = data.substring(5, 8);
            String dataDay = data.substring(8);
            initMonthAndDays(dataYear, dataMonth);
            int indexYeay = 0;
            int indexMonth = 0;
            int indexDay = 0;
            for (int i = 0; i < year1.length; i++) {
                if (year1[i].equals(dataYear)) {
                    indexYeay = i;
                }
            }
            for (int i = 0; i < month1.length; i++) {
                if (month1[i].equals(dataMonth)) {
                    indexMonth = i;
                }
            }
            for (int i = 0; i < days1.length; i++) {
                if (days1[i].equals(dataDay)) {
                    indexDay = i;
                }
            }
            mViewYear.setCurrentItem(indexYeay);
            mViewMonth.setCurrentItem(indexMonth);
            mViewDay.setCurrentItem(indexDay);

        }
    }

    private void initMonthAndDays(String dataYear, String dataMonth) {
        String str = null;
        int currentYear = Integer.parseInt(dataYear.substring(0, 4));
        int currentMouth = Integer.parseInt(dataMonth.substring(0, 2));
        if (currentYear < nowYear) {
            month = new String[12];
            month1 = new String[12];
            for (int i = 1; i <= month.length; i++) {
                if (i < 10) {
                    str = "0" + i;
                } else {
                    str = i + "";
                }
                month[i - 1] = str;
                month1[i - 1] = str + "月";
            }
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            month = new String[nowMonth + 1];
            month1 = new String[nowMonth + 1];
            for (int i = 1; i <= nowMonth + 1; i++) {
                if (i < 10) {
                    str = "0" + i;
                } else {
                    str = i + "";
                }
                month[i - 1] = str;
                month1[i - 1] = str + "月";
            }
        }
        if (currentYear < nowYear) {
            // 前面两个是闰年，最后一个是平年
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                setDays(true, 29, currentMouth);
            } else {
                setDays(true, 28, currentMouth);
            }
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            int nowDay = calendar.get(Calendar.DAY_OF_MONTH);
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 29, currentMouth);
                } else {
                    days = new String[nowDay];
                    days1 = new String[nowDay];
                    for (int i = 0; i < nowDay; i++) {
                        days[i] = (i + 1) + "";
                        days1[i] = (i + 1) + "日";
                    }
                }
            } else {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 28, currentMouth);
                } else {
                    days = new String[nowDay];
                    days1 = new String[nowDay];
                    for (int i = 0; i < nowDay; i++) {
                        days[i] = (i + 1) + "";
                        days1[i] = (i + 1) + "日";
                    }
                }
            }
        }
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        // TODO Auto-generated method stub
        if (wheel == mViewYear) {
//			int pCurrent = mViewBottomSalary.getCurrentItem();
//			mCurrentBottomSalary = year[pCurrent];
            updateMonth();
        } else if (wheel == mViewMonth) {
//            int pCurrent = mViewMouth.getCurrentItem();
//            mCurrentMouth = month[pCurrent];
            updateDay();
        } else if (wheel == mViewDay) {
            int pCurrent = mViewDay.getCurrentItem();
            mCurrentDay = days[pCurrent];
            mCurrentDay1 = days1[pCurrent];
        }
        current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
    }

    private void updateMonth() {
        int pCurrent = mViewYear.getCurrentItem();
        mCurrentYear = year[pCurrent];
        mCurrentYear1 = year1[pCurrent];
        String str = null;
        if (Integer.parseInt(mCurrentYear) < nowYear) {
            month = new String[12];
            month1 = new String[12];
            for (int i = 1; i <= month.length; i++) {
                if (i < 10) {
                    str = "0" + i;
                } else {
                    str = i + "";
                }
                month[i - 1] = str;
                month1[i - 1] = str + "月";
            }
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            month = new String[nowMonth + 1];
            month1 = new String[nowMonth + 1];
            for (int i = 1; i <= nowMonth + 1; i++) {
                if (i < 10) {
                    str = "0" + i;
                } else {
                    str = i + "";
                }
                month[i - 1] = str;
                month1[i - 1] = str + "月";
            }
        }

        if (month1.length < 5) {
            mViewMonth.setCyclic(false);
        } else {
            mViewMonth.setCyclic(true);
        }
        mViewMonth.setViewAdapter(new ArrayWheelAdapter<String>(EditTimeActivity.this, month1));
        // 在滚动年份变化时，有可能当前选中的年所拥有的月份少于12月，那么就需要判断之前选中的是哪个月，如果是超过现在所有的月份，则设置选中最后一个
        if (mViewMonth.getCurrentItem() > month.length - 1)
            mViewMonth.setCurrentItem(month.length - 1);
        mCurrentMonth = month[mViewMonth.getCurrentItem()];
        mCurrentMonth1 = month1[mViewMonth.getCurrentItem()];
        updateDay();
    }

    /**
     * 根据当前的省，更新市WheelView的信息
     */
    private void updateDay() {
        int mCurrent = mViewMonth.getCurrentItem();
        mCurrentMonth = month[mCurrent];
        mCurrentMonth1 = month1[mCurrent];
        String str = null;
        int currentYear = Integer.parseInt(mCurrentYear);
        int currentMouth = Integer.parseInt(mCurrentMonth);
        if (currentYear < nowYear) {
            // 前面两个是闰年，最后一个是平年
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                setDays(true, 29, currentMouth);
            } else {
                setDays(true, 28, currentMouth);
            }
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            int nowDay = calendar.get(Calendar.DAY_OF_MONTH);
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 29, currentMouth);
                } else {
                    days = new String[nowDay];
                    days1 = new String[nowDay];
                    for (int i = 0; i < nowDay; i++) {
                        days[i] = (i + 1) + "";
                        days1[i] = (i + 1) + "日";
                    }
                }
            } else {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 28, currentMouth);
                } else {
                    days = new String[nowDay];
                    days1 = new String[nowDay];
                    for (int i = 0; i < nowDay; i++) {
                        days[i] = (i + 1) + "";
                        days1[i] = (i + 1) + "日";
                    }
                }
            }
        }
        if (days1.length < 5) {
            mViewDay.setCyclic(false);
        } else {
            mViewDay.setCyclic(true);
        }
        mViewDay.setViewAdapter(new ArrayWheelAdapter<String>(EditTimeActivity.this, days1));
//        if (currentMouth == calendar.get(Calendar.MONTH)){
        if (mViewDay.getCurrentItem() > days.length - 1)
            mViewDay.setCurrentItem(days.length - 1);
//        }
        mCurrentDay = days[mViewDay.getCurrentItem()];
        mCurrentDay1 = days1[mViewDay.getCurrentItem()];
    }

    public void setDays(boolean isRunYear, int febDays, int currentMouth) {
        if (isRunYear) {
            if (currentMouth == 2) {
                days = new String[febDays];
                days1 = new String[febDays];
                for (int i = 0; i < febDays; i++) {
                    days[i] = (i + 1) + "";
                    days1[i] = (i + 1) + "日";
                }
            } else if (currentMouth == 4 || currentMouth == 6 || currentMouth == 9 || currentMouth == 11) {
                days = new String[30];
                days1 = new String[30];
                for (int i = 0; i < 30; i++) {
                    days[i] = (i + 1) + "";
                    days1[i] = (i + 1) + "日";
                }
            } else {
                days = new String[31];
                days1 = new String[31];
                for (int i = 0; i < 31; i++) {
                    days[i] = (i + 1) + "";
                    days1[i] = (i + 1) + "日";
                }
            }
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
            case R.id.cancel:
                finish();
                break;
            default:
                break;
        }

    }

    private void showSelectedResult() {
        Intent intent = new Intent();
        intent.putExtra("year", mCurrentYear1);
        intent.putExtra("month", mCurrentMonth1);
        intent.putExtra("day", mCurrentDay1);
        setResult(RESULT_OK, intent);
        finish();
    }
}
