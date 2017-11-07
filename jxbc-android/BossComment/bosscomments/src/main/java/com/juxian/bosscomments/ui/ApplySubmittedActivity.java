package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.models.UserSummaryEntity;
import com.juxian.bosscomments.repositories.UserRepository;
import com.nostra13.universalimageloader.core.ImageLoader;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/18.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/18 13:34]
 * @Version: [v1.0]
 */
public class ApplySubmittedActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.view)
    View view_line;
    @BindView(R.id.view1)
    View view_line1;
    @BindView(R.id.upload_legal_person)
    ImageView upload_legal_person;
    @BindView(R.id.upload_legal_person_picture_text)
    TextView upload_legal_person_picture_text;
    @BindView(R.id.set_password)
    ImageView set_password;
    @BindView(R.id.set_password_text)
    TextView set_password_text;
    @BindView(R.id.include_button_button)
    Button mToWorkbench;
    @BindView(R.id.need_help)
    TextView need_help;

    @Override
    public int getContentViewId() {
        return R.layout.activity_apply_submitted;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        initLine();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.company_authentication));
        mToWorkbench.setText(getString(R.string.to_enter_the_workbench));
        back.setVisibility(View.GONE);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mToWorkbench.setOnClickListener(this);
        need_help.setOnClickListener(this);
    }

    public void initLine() {
        WindowManager manager = this.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        int width2 = outMetrics.widthPixels;
        int height2 = outMetrics.heightPixels;
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 2);
        params.leftMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params.rightMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params.topMargin = dp2px(11);
        view_line.setBackgroundColor(getResources().getColor(R.color.list_color));
        view_line.setLayoutParams(params);

        RelativeLayout.LayoutParams params1 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 2);
        params1.leftMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params1.topMargin = dp2px(11);
        params1.rightMargin = ((width2 - 2 * dp2px(22)) / 8) + dp2px(22);
        view_line1.setVisibility(View.VISIBLE);
        view_line1.setBackgroundColor(getResources().getColor(R.color.luxury_gold_color));
        view_line1.setLayoutParams(params1);

        upload_legal_person.setImageResource(R.drawable.shape_become_cc_red);
        upload_legal_person_picture_text.setTextColor(getResources().getColor(R.color.luxury_gold_color));
        set_password.setImageResource(R.drawable.shape_become_cc_red);
        set_password_text.setTextColor(getResources().getColor(R.color.luxury_gold_color));
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                Intent toWorkbench = new Intent(getApplicationContext(),HomeActivity.class);
                startActivity(toWorkbench);
                finish();
                break;
            case R.id.need_help:
                Intent intent = new Intent(getApplicationContext(),AboutUsActivity.class);
                intent.putExtra("ShowType","NeedHelp");
                startActivity(intent);
                break;
        }
    }
}
