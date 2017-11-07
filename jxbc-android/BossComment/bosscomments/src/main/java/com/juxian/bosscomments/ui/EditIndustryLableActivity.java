package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明: 选择行业标签
 * @创建时间：2016-3-10 下午3:55:26
 */
public class EditIndustryLableActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    private Context context;
    private List<String> Lable;
    // private String[] lables = { "职业规划", "产品经理", "UI设计", "阿里妈妈", "设计", "产品经理",
    // "产品经理经理", "陈国佳", "      +      " };
    private String[] lables;
    //    @BindView(R.id.include_head_title_register)
//    TextView saveTitle;
//    @BindView(R.id.include_head_title_register_re)
//    RelativeLayout saveRe;
    @BindView(R.id.lable_flowlayout)
    TagFlowLayout mFlowLayout;
    private LayoutInflater mInflater;
    public static final int CODE_ADD_LABLE = 1;
    private WindowManager manager;
    private Dialog dialog;
    private String[] tags;
    private List<String> histsoft;

    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            final String[] strs = (String[]) msg.obj;

            mFlowLayout.setAdapter(new TagAdapter<String>((String[]) msg.obj) {
                @Override
                public View getView(FlowLayout parent, int position, String s) {
                    RelativeLayout rl = (RelativeLayout) mInflater.inflate(
                            R.layout.item_industry_lable, mFlowLayout, false);

                    if (position == strs.length-1){
                        LayoutParams params = new LayoutParams(dp2px(91), dp2px(30));
                        params.leftMargin = dp2px(10);
                        params.rightMargin = dp2px(10);
                        params.topMargin = dp2px(10);
                        rl.setLayoutParams(params);
                        TextView tv = (TextView) rl.findViewById(R.id.lable);
                        tv.setGravity(Gravity.CENTER);
                        tv.setText(s);
                        tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.add_industry));
                    } else {
                        LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT, dp2px(30));
                        params.leftMargin = dp2px(10);
                        params.rightMargin = dp2px(10);
                        params.topMargin = dp2px(10);
                        rl.setLayoutParams(params);
                        TextView tv = (TextView) rl.findViewById(R.id.lable);
                        tv.setGravity(Gravity.CENTER);
                        tv.setText(s);
                    }

                    return rl;
                }
            });
        }
    };

    @Override
    public int getContentViewId() {
        return R.layout.activity_edit_industry_lable;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        context = this;
        manager = this.getWindowManager();
        initViewsData();
        initListener();

        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.company_industry));
        mInflater = LayoutInflater.from(this);
        Lable = new ArrayList<String>();
        histsoft = new ArrayList<>();
        try {
            readFile02();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (getIntent().getStringArrayExtra("lables") != null) {
            for (int i = 0; i < getIntent().getStringArrayExtra("lables").length; i++) {
                Lable.add(getIntent().getStringArrayExtra("lables")[i]);
            }
        }
        getTags(DictionaryPool.Code_Industry);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mFlowLayout.setOnTagClickListener(new TagFlowLayout.OnTagClickListener() {
            @Override
            public boolean onTagClick(View view, int position,
                                      FlowLayout parent) {
                if (position == lables.length - 1) {
                    Intent intent = new Intent(context, EditNameActivity.class);
                    intent.putExtra(Global.LISTVIEW_ITEM_TAG, EditNameActivity.TYPE_INDUSTRY);
                    startActivityForResult(intent, CODE_ADD_LABLE);
                } else {
                    Intent ResultIntent = new Intent();
                    ResultIntent.putExtra("industry", lables[position]);
                    setResult(RESULT_OK, ResultIntent);
                    finish();
                }
                return true;
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            default:
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case CODE_ADD_LABLE:
                if (resultCode == RESULT_OK) {
                    String content = data.getStringExtra("lable");
                    Intent ResultIntent = new Intent();
                    ResultIntent.putExtra("industry", content);
                    setResult(RESULT_OK, ResultIntent);
                    finish();
                }
                break;

            default:
                break;
        }
    }

    public void getTags(final String code) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadIndustryDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (dialog != null)
                    dialog.dismiss();
                if (entities != null) {
                    if (entities.size() != 0){
                        List<BizDictEntity> industrys = entities.get(DictionaryPool.Code_Industry);
                        for (int i=0;i<industrys.size();i++){
                            Lable.add(industrys.get(i).Name);
                        }
                        lables = new String[Lable.size()+histsoft.size()+1];
                        for (int i = 0; i < Lable.size(); i++) {
                            lables[i] = Lable.get(i);
                        }
                        int j = 0;
                        for (int i = Lable.size(); i < (histsoft.size() + Lable.size()); i++) {
                            if (j < histsoft.size()) {
                                lables[i] = histsoft.get(j);
                                j++;
                            }
                        }
                        lables[Lable.size()+histsoft.size()] = "";
                        Message msg = new Message();
                        msg.obj = lables;
                        mHandler.sendMessage(msg);
                    } else {
                        lables = new String[Lable.size()+histsoft.size()+1];
                        int j = 0;
                        for (int i = Lable.size(); i < (histsoft.size() + Lable.size()); i++) {
                            if (j < histsoft.size()) {
                                lables[i] = histsoft.get(j);
                                j++;
                            }
                        }
                        lables[Lable.size()+histsoft.size()] = "";
                        Message msg = new Message();
                        msg.obj = lables;
                        mHandler.sendMessage(msg);
                    }
                } else {
                    lables = new String[Lable.size()+histsoft.size()+1];
                    int j = 0;
                    for (int i = Lable.size(); i < (histsoft.size() + Lable.size()); i++) {
                        if (j < histsoft.size()) {
                            lables[i] = histsoft.get(j);
                            j++;
                        }
                    }
                    lables[Lable.size()+histsoft.size()] = "";
                    Message msg = new Message();
                    msg.obj = lables;
                    mHandler.sendMessage(msg);
                }

            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }

    public void readFile02() throws IOException {
        FileInputStream fis = new FileInputStream(Environment
                .getExternalStorageDirectory().getPath()
                + "//"
                + "JuXianBossComments.txt");
        InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
        BufferedReader br = new BufferedReader(isr);
        // 简写如下
        // BufferedReader br = new BufferedReader(new InputStreamReader(
        // new FileInputStream("E:/phsftp/evdokey/evdokey_201103221556.txt"),
        // "UTF-8"));
        String line = "";
        String[] arrs = null;
        histsoft.clear();
        while ((line = br.readLine()) != null) {
            // arrs = line.split(",");
            // ToastUtil.showInfo(line);
            histsoft.add(line);
            Log.i("JuXian", "测试" + line);
            // System.out.println(arrs[0] + " : " + arrs[1] + " : " + arrs[2]);
        }

        br.close();
        isr.close();
        fis.close();
    }
}
