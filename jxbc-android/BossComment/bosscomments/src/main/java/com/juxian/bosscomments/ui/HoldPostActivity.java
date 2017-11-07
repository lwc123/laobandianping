package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.WorkItemEntity;
import com.kankan.wheel.widget.OnWheelChangedListener;
import com.kankan.wheel.widget.WheelView;
import com.kankan.wheel.widget.adapters.ArrayWheelAdapter;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/28.
 * 建立担任职务
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 15:18]
 * @Version: [v1.0]
 */
public class HoldPostActivity extends BaseActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button mComplete;
    @BindView(R.id.edit_hold_post)
    EditText mHoldPost;
    @BindView(R.id.edit_wage_income)
    EditText mWageIncome;
    @BindView(R.id.activity_in_department)
    RelativeLayout mInDepartment;
    @BindView(R.id.edit_in_department)
    TextView mInDepartmentText;
    @BindView(R.id.activity_hold_post_start_time)
    RelativeLayout mSelectStartTime;
    @BindView(R.id.activity_hold_post_end_time)
    RelativeLayout mSelectEndTime;
    @BindView(R.id.edit_hold_post_start_time)
    TextView mStartTime;
    @BindView(R.id.edit_hold_post_end_time)
    TextView mEndTime;
    @BindView(R.id.include_head_title_tab2)
    TextView mSavePostText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mSavePost;
    private static final int ENTRY_TIME = 300, DEPARTURE_TIME = 400;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月dd日");

    /**
     * 时间选择器部分
     */
    private List<String> list_year;
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
    private WorkItemEntity mWorkItemEntity;

    private String mEntryTime;
    private String mDepartmentTime;

    @Override
    public void invalidateOptionsMenu() {
        super.invalidateOptionsMenu();
    }

    @Override
    public int getContentViewId() {
        return R.layout.activity_hold_post;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.build_hold_post));
        mComplete.setText(getString(R.string.complete));
//        String hint = "请填写薪资收入，可不填";
//        mWageIncome.setHint(Html.fromHtml(hint));
        mSavePostText.setText(getString(R.string.complete));
        mSavePost.setVisibility(View.GONE);
        mSavePostText.setVisibility(View.GONE);
        if ("change".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG))) {
            mWorkItemEntity = JsonUtil.ToEntity(getIntent().getStringExtra("WorkItemEntity"), WorkItemEntity.class);
            mStartTime.setText(sdfymdhms.format(mWorkItemEntity.PostStartTime));
            String endTime = sdfymdhms.format(mWorkItemEntity.PostEndTime);
            if ("3000年01月01日".equals(endTime)) {
                mEndTime.setText("至今");
            } else {
                mEndTime.setText(endTime);
            }
            mHoldPost.setText(mWorkItemEntity.PostTitle);
            mHoldPost.setSelection(mWorkItemEntity.PostTitle.length());
            mWageIncome.setText(mWorkItemEntity.Salary);
            mInDepartmentText.setText(mWorkItemEntity.Department);
        }
        mEntryTime = getIntent().getStringExtra("mEntryTime");
        mDepartmentTime = getIntent().getStringExtra("mDepartureTime");

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mComplete.setOnClickListener(this);
        mInDepartment.setOnClickListener(this);
        mSelectStartTime.setOnClickListener(this);
        mSelectEndTime.setOnClickListener(this);
        mSavePost.setOnClickListener(this);
        mWageIncome.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().contains(".")) {
                    if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                        charSequence = charSequence.toString().subSequence(0,
                                charSequence.toString().indexOf(".") + 3);
                        mWageIncome.setText(charSequence);
                        mWageIncome.setSelection(charSequence.length());
                    }
                }
                if (charSequence.toString().trim().substring(0).equals(".")) {
                    charSequence = "0" + charSequence;
                    mWageIncome.setText(charSequence);
                    mWageIncome.setSelection(2);
                }

                if (charSequence.toString().startsWith("0")
                        && charSequence.toString().trim().length() > 1) {
                    if (!charSequence.toString().substring(1, 2).equals(".")) {
                        mWageIncome.setText(charSequence.subSequence(0, 1));
                        mWageIncome.setSelection(1);
                        return;
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (getCurrentFocus() != null
                    && getCurrentFocus().getWindowToken() != null) {
                manager.hideSoftInputFromWindow(getCurrentFocus()
                        .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                submitPost();
                break;
            case R.id.activity_in_department:
                Intent SelectDepartment = new Intent(getApplicationContext(), SelectDepartmentActivity.class);
                startActivityForResult(SelectDepartment, 200);
                break;
            case R.id.activity_hold_post_start_time:
//                Intent selectTime = new Intent(getApplicationContext(), EditTimeActivity.class);
//                selectTime.putExtra("data", mStartTime.getText().toString().trim());
//                startActivityForResult(selectTime, ENTRY_TIME);
                showSelectScaleDialog(mStartTime, 0, mStartTime.getText().toString());
                break;
            case R.id.activity_hold_post_end_time:
//                Intent selectTime1 = new Intent(getApplicationContext(), EditTimeActivity.class);
//                selectTime1.putExtra("data", mEndTime.getText().toString().trim());
//                startActivityForResult(selectTime1, DEPARTURE_TIME);
                showSelectScaleDialog(mEndTime, 1, mEndTime.getText().toString());
                break;
            case R.id.include_head_title_re1:
                submitPost();
                break;
            default:
        }
    }

    public void submitPost() {
        if (TextUtils.isEmpty(mHoldPost.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_input_hold_post));
            return;
        }
        if (TextUtils.isEmpty(mStartTime.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_select_hold_post_start_time));
            return;
        }
        if (TextUtils.isEmpty(mEndTime.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_select_hold_post_end_time));
            return;
        }

        if (mHoldPost.getText().toString().trim().length() > 30) {
            ToastUtil.showInfo(getString(R.string.input_hold_post_length_limit));
            return;
        }
        if (!TextUtils.isEmpty(mWageIncome.getText().toString())) {
            if (Double.parseDouble(mWageIncome.getText().toString().trim()) > 999 || Double.parseDouble(mWageIncome.getText().toString().trim()) < 3) {
                ToastUtil.showInfo(getString(R.string.wage_income_length_limit));
                return;
            }
        }
        if (TextUtils.isEmpty(mInDepartmentText.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_input_department_name));
            return;
        }
        WorkItemEntity entity = new WorkItemEntity();
        if ("change".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG))) {
            entity = mWorkItemEntity;
        }
        try {
            entity.PostStartTime = sdfymdhms.parse(mStartTime.getText().toString().trim());
            if ("至今".equals(mEndTime.getText().toString().trim())) {
                entity.PostEndTime = sdfymdhms.parse("3000年1月1日");
            } else {
                entity.PostEndTime = sdfymdhms.parse(mEndTime.getText().toString().trim());
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (TextUtils.isEmpty(mEntryTime)) {
            ToastUtil.showInfo(getString(R.string.post_time_entry));
            return;
        }
        if (entity.PostStartTime.after(entity.PostEndTime)) {
            ToastUtil.showInfo(getString(R.string.post_time_limit));
            return;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
        if (!TextUtils.isEmpty(mEntryTime)) {
            try {
                Date date = sdf.parse(mEntryTime);
                if (date.after(entity.PostStartTime)) {
                    ToastUtil.showInfo("职务的任职开始时间必须大于入职时间");
                    return;
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        if (!TextUtils.isEmpty(mDepartmentTime)) {
            try {
                Date date1 = sdf.parse(mDepartmentTime);
                if (date1.before(entity.PostEndTime)) {
                    ToastUtil.showInfo("职务的任职结束时间必须小于离任时间");
                    return;
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }

        }
        entity.PostTitle = mHoldPost.getText().toString();
        entity.Salary = mWageIncome.getText().toString();
        entity.Department = mInDepartmentText.getText().toString();
//        if ("new_build".equals(getIntent().getStringExtra("new_build"))){
//            longvideo Archive = getIntent().getLongExtra("ArchiveId",0);
//            employeeArchive(entity);
//        } else {
        employeeArchive(entity);
//        }
    }

    public void employeeArchive(WorkItemEntity entity) {
        Intent intent = getIntent();
        intent.putExtra("WorkItemEntity", JsonUtil.ToJson(entity));
        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 200:
                if (resultCode == RESULT_OK) {
                    mInDepartmentText.setText(data.getStringExtra("department"));
                }
                break;
            case ENTRY_TIME:
                if (resultCode == RESULT_OK) {
                    String year = data.getStringExtra("year");
                    String month = data.getStringExtra("month");
                    String day = data.getStringExtra("day");
                    mStartTime.setText(year + month + day);
                }
                break;
            case DEPARTURE_TIME:
                if (resultCode == RESULT_OK) {
                    String year = data.getStringExtra("year");
                    String month = data.getStringExtra("month");
                    String day = data.getStringExtra("day");
                    mEndTime.setText(year + month + day);
                }
                break;
            default:
        }
    }

    private int yearIndex;
    private int monthIndex;
    private int dayIndex;

    public void showSelectScaleDialog(final TextView textView, int tag, String timeText) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.activity_edit_time, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mViewYear = (WheelView) dialog_view.findViewById(R.id.id_year);
        final WheelView mViewMonth = (WheelView) dialog_view.findViewById(R.id.id_mouth);
        final WheelView mViewDay = (WheelView) dialog_view.findViewById(R.id.id_day);
//        mViewDay.setVisibility(View.GONE);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        final TextView current_date = (TextView) dialog_view.findViewById(R.id.current_date);
        TextView time_title = (TextView) dialog_view.findViewById(R.id.start_time);
        if (tag == 1) {
            time_title.setText(getString(R.string.hold_post_end_time));
        } else {
            time_title.setText(getString(R.string.hold_post_start_time));
        }
        current_date.setVisibility(View.GONE);
        mViewYear.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                updateMonth(mViewYear, mViewMonth, mViewDay);
                current_date.setText(mCurrentYear1 + mCurrentMonth1);
            }
        });
        mViewMonth.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                updateDay(mViewMonth, mViewDay);
                mCurrentMonth = month[mViewMonth.getCurrentItem()];
                mCurrentMonth1 = month1[mViewMonth.getCurrentItem()];

                current_date.setText(mCurrentYear1 + mCurrentMonth1);
            }
        });
        mViewDay.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                mCurrentDay = days[mViewDay.getCurrentItem()];
                mCurrentDay1 = days1[mViewDay.getCurrentItem()];
                current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                textView.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
                dl.dismiss();
            }
        });
        list_year = new ArrayList<String>();
        initYear(tag);
        year = new String[list_year.size()];
        year1 = new String[list_year.size()];
        for (int i = 0; i < list_year.size(); i++) {
            if (i == 0) {
                if (tag == 1) {
                    year[i] = list_year.get(i);
                    year1[i] = list_year.get(i);
                } else {
                    year[i] = list_year.get(i);
                    year1[i] = list_year.get(i) + "年";
                }
            } else {
                year[i] = list_year.get(i);
                year1[i] = list_year.get(i) + "年";
            }
        }

        mViewYear.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), year1));
//        mViewYear.setCyclic(true);
        mViewMonth.setCyclic(true);

        // 设置可见条目数量
        mViewYear.setVisibleItems(5);
        mViewMonth.setVisibleItems(5);
        mViewDay.setVisibleItems(5);
        if ("至今".equals(timeText)) {
            mViewYear.setCurrentItem(0);
            mViewMonth.setCurrentItem(0);
            mViewDay.setCurrentItem(0);
            mCurrentYear = year[0];
        } else if (!TextUtils.isEmpty(timeText) && (!"至今".equals(timeText))) {
            Date timeDate = null;
            try {
                timeDate = sdfymdhms.parse(timeText);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            Calendar ClickCalendar = Calendar.getInstance();
            ClickCalendar.setTime(timeDate);

            for (int i = 0; i < year1.length; i++) {
                if ((ClickCalendar.get(Calendar.YEAR) + "年").equals(year1[i])) {
                    yearIndex = i;
                }
            }
            mViewYear.setCurrentItem(yearIndex);
            mViewMonth.setCurrentItem(ClickCalendar.get(Calendar.MONTH));
            mViewDay.setCurrentItem(ClickCalendar.get(Calendar.DAY_OF_MONTH)-1);
            mCurrentYear = year[yearIndex];
        } else {
            mViewYear.setCurrentItem(0);
            mViewMonth.setCurrentItem(0);
            mViewDay.setCurrentItem(0);
            mCurrentYear = year[0];
        }
        updateMonth(mViewYear, mViewMonth, mViewDay);
        current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1 + "");
    }

    private void initYear(int tag) {
        calendar = Calendar.getInstance();
        nowYear = calendar.get(Calendar.YEAR);
        if (tag == 1) {
            list_year.add("至今");
        }
        for (int i = nowYear; i >= nowYear - 30; i--) {
            list_year.add(i + "");
        }
    }

    private void updateMonth(WheelView mViewYear, WheelView mViewMonth, WheelView mViewDay) {
        int pCurrent = mViewYear.getCurrentItem();
        mCurrentYear = year[pCurrent];
        mCurrentYear1 = year1[pCurrent];
        String str = null;
        if ("至今".equals(mCurrentYear)) {
            month = new String[1];
            month[0] = "";
            month1 = new String[1];
            month1[0] = "";
        } else if (Integer.parseInt(mCurrentYear) < nowYear) {
            initMonth(12);
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            initMonth(nowMonth + 1);
        }
        if (month1.length < 5) {
            mViewMonth.setCyclic(false);
        } else {
            mViewMonth.setCyclic(true);
        }
        mViewMonth.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), month1));
        // 在滚动年份变化时，有可能当前选中的年所拥有的月份少于12月，那么就需要判断之前选中的是哪个月，如果是超过现在所有的月份，则设置选中最后一个
        if (mViewMonth.getCurrentItem() > month.length - 1)
            mViewMonth.setCurrentItem(month.length - 1);

        mCurrentMonth = month[mViewMonth.getCurrentItem()];
        mCurrentMonth1 = month1[mViewMonth.getCurrentItem()];
        updateDay(mViewMonth, mViewDay);
    }

    public void initMonth(int length) {
        String str = null;
        month = new String[length];
        month1 = new String[length];
        for (int i = 1; i <= length; i++) {
            if (i < 10) {
                str = "0" + i;
            } else {
                str = i + "";
            }
            month[i - 1] = str;
            month1[i - 1] = str + "月";
        }
    }

    /**
     * 根据当前的月，更新日WheelView的信息
     */
    private void updateDay(WheelView mViewMonth, WheelView mViewDay) {
        int mCurrent = mViewMonth.getCurrentItem();
        mCurrentMonth = month[mCurrent];
        mCurrentMonth1 = month1[mCurrent];
        String str = null;
        if ("至今".equals(mCurrentYear)) {
            days = new String[1];
            days1 = new String[1];
            days[0] = "";
            days1[0] = "";
        } else {
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
                        initDays(nowDay);
                    }
                } else {
                    if (currentMouth < nowMonth + 1) {
                        setDays(true, 28, currentMouth);
                    } else {
                        initDays(nowDay);
                    }
                }
            }
        }
        mViewDay.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), days1));
        if (mViewDay.getCurrentItem() > days.length - 1)
            mViewDay.setCurrentItem(days.length - 1);
        mCurrentDay = days[mViewDay.getCurrentItem()];
        mCurrentDay1 = days1[mViewDay.getCurrentItem()];
    }

    public void setDays(boolean isRunYear, int febDays, int currentMouth) {
        if (isRunYear) {
            if (currentMouth == 2) {
                initDays(febDays);
            } else if (currentMouth == 4 || currentMouth == 6 || currentMouth == 9 || currentMouth == 11) {
                initDays(30);
            } else {
                initDays(31);
            }
        }
    }

    public void initDays(int length) {
        days = new String[length];
        days1 = new String[length];
        for (int i = 0; i < length; i++) {
            days[i] = (i + 1) + "";
            days1[i] = (i + 1) + "日";
        }
    }
}
