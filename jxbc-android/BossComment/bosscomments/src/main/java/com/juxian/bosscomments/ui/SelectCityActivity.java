package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.CommonAdapter;
import com.juxian.bosscomments.adapter.HeaderRecyclerAndFooterWrapperAdapter;
import com.juxian.bosscomments.adapter.MeituanAdapter;
import com.juxian.bosscomments.adapter.SelectCityAdapter;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.MeiTuanBean;
import com.juxian.bosscomments.models.MeituanHeaderBean;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.utils.DividerItemDecoration;
import com.juxian.bosscomments.utils.OnItemClickListener;
import com.juxian.bosscomments.utils.ViewHolder;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.mcxtzhang.indexlib.IndexBar.bean.BaseIndexPinyinBean;
import com.mcxtzhang.indexlib.IndexBar.widget.IndexBar;
import com.mcxtzhang.indexlib.suspension.SuspensionDecoration;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/22.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/22 18:50]
 * @Version: [v1.0]
 */
public class SelectCityActivity extends BaseActivity implements View.OnClickListener, OnItemClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    //    @BindView(R.id.id_flowlayout)
//    GridView mFlowLayout;
    @BindView(R.id.input_hint)
    TextView mInputHint;
    @BindView(R.id.activity_search)
    RelativeLayout mSearchBox;
    @BindView(R.id.activity_search_text)
    TextView mSearchText;
    private RecyclerView mRv;
    private MeituanAdapter mAdapter;
    private HeaderRecyclerAndFooterWrapperAdapter mHeaderAdapter;
    private LinearLayoutManager mManager;

    //设置给InexBar、ItemDecoration的完整数据集
    private List<BaseIndexPinyinBean> mSourceDatas;
    //头部数据源
    private List<MeituanHeaderBean> mHeaderDatas;
    //主体部分数据源（城市数据）
    private List<MeiTuanBean> mBodyDatas;

    private SuspensionDecoration mDecoration;

    /**
     * 右侧边栏导航区域
     */
    private IndexBar mIndexBar;

    /**
     * 显示指示器DialogText
     */
    private TextView mTvSideBarHint;
    private LayoutInflater mInflater;
    private List<BizDictEntity> HotCitys;
    private List<String> HotCityStrings;
    private List<String> HotCityCodes;
    private SelectCityAdapter adapter;
    private Context mContext;
    private List<String> allCity;
    private List<String> allCityCodes;

    @Override
    public int getContentViewId() {
        return R.layout.activity_select_city;
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
        setSystemBarTintManager(this);
        mInflater = LayoutInflater.from(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        mContext = this;
        title.setText(getString(R.string.select_city));
        mInputHint.setText(getString(R.string.please_input_city_name) + "名");
        mRv = (RecyclerView) findViewById(R.id.rv);
        mRv.setLayoutManager(mManager = new LinearLayoutManager(this));
        mSourceDatas = new ArrayList<>();
        mHeaderDatas = new ArrayList<>();
        HotCitys = new ArrayList<>();
        HotCityStrings = new ArrayList<>();
        HotCityCodes = new ArrayList<>();

        mHeaderDatas.add(new MeituanHeaderBean(HotCityStrings, "热门城市", "热"));
        mSourceDatas.addAll(mHeaderDatas);
        //recycle的adapter
        mAdapter = new MeituanAdapter(this, R.layout.meituan_item_select_city, mBodyDatas);
        mAdapter.setOnItemClickListener(this);
        //列表头部的adapter
        mHeaderAdapter = new HeaderRecyclerAndFooterWrapperAdapter(mAdapter) {
            @Override
            protected void onBindHeaderHolder(ViewHolder holder, int headerPos, int layoutId, Object o) {
                switch (layoutId) {
                    case R.layout.meituan_item_header:
                        final MeituanHeaderBean meituanHeaderBean = (MeituanHeaderBean) o;
                        //网格
                        RecyclerView recyclerView = holder.getView(R.id.rvCity);
                        recyclerView.setAdapter(
                                new CommonAdapter<String>(mContext, R.layout.meituan_item_header_item, meituanHeaderBean.getCityList()) {
                                    @Override
                                    public void convert(ViewHolder holder, final String cityName) {
                                        holder.setText(R.id.tvName, cityName);
                                        holder.getConvertView().setOnClickListener(new View.OnClickListener() {
                                            @Override
                                            public void onClick(View v) {
                                                //热门城市的点击回调
//                                                Toast.makeText(mContext, "cityName:" + cityName, Toast.LENGTH_SHORT).show();
                                                Intent intent = getIntent();
                                                intent.putExtra("city", cityName);
                                                intent.putExtra("CityCode", HotCityCodes.get(HotCityStrings.indexOf(cityName)));
                                                setResult(RESULT_OK, intent);
                                                finish();

                                            }
                                        });
                                    }
                                });
                        recyclerView.setLayoutManager(new GridLayoutManager(mContext, 3));
                        break;
                    default:
                        break;
                }
            }
        };
        mHeaderAdapter.setHeaderView(0, R.layout.meituan_item_header, mHeaderDatas.get(0));
        mRv.setAdapter(mHeaderAdapter);
        //设置分类条目间隔相关属性
        mRv.addItemDecoration(mDecoration = new SuspensionDecoration(this, mSourceDatas)
                .setmTitleHeight((int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 35, getResources().getDisplayMetrics()))
                .setColorTitleBg(0xfff8f8f8)//title的颜色
                .setTitleFontSize((int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, 16, getResources().getDisplayMetrics()))
                .setColorTitleFont(getApplicationContext().getResources().getColor(R.color.black))
                .setHeaderViewCount(mHeaderAdapter.getHeaderViewCount() - mHeaderDatas.size()));

        //设置普通条目
        mRv.addItemDecoration(new DividerItemDecoration(mContext, DividerItemDecoration.VERTICAL_LIST));

        //右侧滑动时中间区域显示文字HintTextView
        mTvSideBarHint = (TextView) findViewById(R.id.tvSideBarHint);
        //IndexBar右侧快速滑动区域
        mIndexBar = (IndexBar) findViewById(R.id.indexBar);
        mIndexBar.setmPressedShowTextView(mTvSideBarHint)//设置HintTextView
                .setNeedRealIndex(true)//设置需要真实的索引
                .setmLayoutManager(mManager)//设置RecyclerView的LayoutManager
                .setHeaderViewCount(mHeaderAdapter.getHeaderViewCount() - mHeaderDatas.size());
        allCity = new ArrayList<>();
        allCityCodes = new ArrayList<>();
        getTags();

//        adapter = new TagAdapter<String>(HotCityStrings) {
//            @Override
//            public View getView(FlowLayout parent, int position, String s) {
//                TextView tv = (TextView) mInflater.inflate(
//                        R.layout.flow_city_tv, mFlowLayout, false);
//                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((getMetrics().widthPixels - dp2px(90)) / 3, LinearLayout.LayoutParams.WRAP_CONTENT);
//                params.leftMargin = dp2px(11);
//                params.rightMargin = dp2px(11);
//                params.bottomMargin = dp2px(10);
//                tv.setPadding(0, dp2px(6), 0, dp2px(6));
//                tv.setLayoutParams(params);
//                tv.setText(s);
//                return tv;
//            }
//        };
//        adapter = new SelectCityAdapter(HotCityStrings,this);
//        mFlowLayout.setAdapter(adapter);

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSearchBox.setOnClickListener(this);
        mSearchText.setOnClickListener(this);
//        mFlowLayout.setOnTagClickListener(new TagFlowLayoutOnTagClickListener());
//        mFlowLayout.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            @Override
//            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
//                Intent intent = getIntent();
//                intent.putExtra("city", HotCityStrings.get(i));
//                intent.putExtra("CityCode", HotCityCodes.get(i));
//                setResult(RESULT_OK, intent);
//                finish();
//            }
//        });
    }

    private void initDatas(final List<String> data) {

        mBodyDatas = new ArrayList<>();
        for (int i = 0; i < data.size(); i++) {
            MeiTuanBean cityBean = new MeiTuanBean();
            cityBean.setCity(data.get(i));//设置城市名称
            mBodyDatas.add(cityBean);
        }
        //先排序
        mIndexBar.getDataHelper().sortSourceDatas(mBodyDatas);

        mAdapter.setDatas(mBodyDatas);
        mHeaderAdapter.notifyDataSetChanged();
        mSourceDatas.addAll(mBodyDatas);

        mIndexBar.setmSourceDatas(mSourceDatas)//设置数据
                .invalidate();
        mDecoration.setmDatas(mSourceDatas);

        MeituanHeaderBean header3 = mHeaderDatas.get(0);
        header3.setCityList(HotCityStrings);
        mHeaderAdapter.notifyItemRangeChanged(1, 1);

    }

    @Override
    public void onItemClick(ViewGroup parent, View view, Object o, int position) {
        Intent intent = getIntent();
        String cityName = mBodyDatas.get(position).getCity();
        intent.putExtra("city", cityName);
        intent.putExtra("CityCode", allCityCodes.get(allCity.indexOf(cityName)));
        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    public boolean onItemLongClick(ViewGroup parent, View view, Object o, int position) {
        return false;
    }

    class TagFlowLayoutOnTagClickListener implements TagFlowLayout.OnTagClickListener {

        @Override
        public boolean onTagClick(View view, int position, FlowLayout parent) {
            Intent intent = getIntent();
            intent.putExtra("city", HotCityStrings.get(position));
            intent.putExtra("CityCode", HotCityCodes.get(position));
            setResult(RESULT_OK, intent);
            finish();
            return true;
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.activity_search:
                Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchCity");
                startActivity(SearchEmployee);
                break;
            case R.id.activity_search_text:
                Intent SearchEmployee1 = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee1.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchCity");
                startActivity(SearchEmployee1);
                break;
            default:
        }
    }

    private BroadcastReceiver CityBroadcastReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            Intent intent1 = getIntent();
            intent1.putExtra("city", intent.getStringExtra("city"));
            intent1.putExtra("CityCode", intent.getStringExtra("CityCode"));
            SelectCityActivity.this.setResult(SelectCityActivity.RESULT_OK, intent1);
            finish();
        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("SelectCityActivity");
        registerReceiver(CityBroadcastReceiver, intentFilter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        try {
            unregisterReceiver(CityBroadcastReceiver);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    public void getTags() {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadCityDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (dialog != null)
                    dialog.dismiss();
                if (entities != null) {
                    HotCitys.clear();
                    HotCityStrings.clear();
                    for (int i = 0; i < entities.get(DictionaryPool.Code_City).size(); i++) {
                        allCity.add(entities.get(DictionaryPool.Code_City).get(i).Name);
                        allCityCodes.add(entities.get(DictionaryPool.Code_City).get(i).Code);
                        if (entities.get(DictionaryPool.Code_City).get(i).IsHotspot == 1) {
                            HotCitys.add(entities.get(DictionaryPool.Code_City).get(i));
                        }
                    }
                    for (int j = 0; j < entities.get(DictionaryPool.Code_City).size(); j++) {
                        if (entities.get(DictionaryPool.Code_City).get(j).IsHotspot == 1) {
                            HotCityStrings.add(entities.get(DictionaryPool.Code_City).get(j).Name);
                            HotCityCodes.add(entities.get(DictionaryPool.Code_City).get(j).Code);
                        }
                    }
//                    adapter.notifyDataChanged();
//                    adapter.notifyDataSetChanged();
//                    mAdapter.setDatas(mBodyDatas);
//                    mHeaderAdapter.notifyDataSetChanged();
                    initDatas(allCity);//所有城市数据源
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }
}
