package com.juxian.bosscomments.adapter;

import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import com.juxian.bosscomments.fragment.BaseFragment;
import java.util.ArrayList;

/**
 * Created by Tam on 2017/2/8.
 */
public class MessageViewPagerAdapter extends FragmentPagerAdapter {

    private ArrayList<BaseFragment> fragments;

    public MessageViewPagerAdapter(FragmentManager fm, ArrayList<BaseFragment> fragments) {
        super(fm);
        // TODO Auto-generated constructor stub
        this.fragments = fragments;
    }

    public MessageViewPagerAdapter(FragmentManager fm) {
        super(fm);
        // TODO Auto-generated constructor stub
    }

    @Override
    public BaseFragment getItem(int arg0) {
        return fragments.get(arg0);
    }

    @Override
    public int getCount() {
        return fragments.size();
    }

    @Override
    public int getItemPosition(Object object) {
        return super.getItemPosition(object);
    }
}