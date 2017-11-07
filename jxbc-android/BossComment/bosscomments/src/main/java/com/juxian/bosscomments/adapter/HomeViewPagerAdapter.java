package com.juxian.bosscomments.adapter;

import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.juxian.bosscomments.fragment.BaseFragment;

import java.util.ArrayList;

public class HomeViewPagerAdapter extends FragmentPagerAdapter {

    private ArrayList<BaseFragment> fragments;

    public HomeViewPagerAdapter(FragmentManager fm, ArrayList<BaseFragment> fragments) {
        super(fm);
        // TODO Auto-generated constructor stub
        this.fragments = fragments;
    }

    public HomeViewPagerAdapter(FragmentManager fm) {
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
