package net.juxian.appgenome.widget.utils;

import net.juxian.appgenome.utils.ResourcesUtil;
import android.R;
import android.annotation.SuppressLint;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.GridView;
import android.widget.ListAdapter;
import android.widget.ListView;

public class ListViewUtil {
	
	public static void resetLayout(AbsListView listView) {
		if (ListView.class.isInstance(listView))
			resetLayout(listView, 1);
		else if  (GridView.class.isInstance(listView))
			resetLayout((GridView)listView, 0);
	}
	
	@SuppressLint("NewApi")
	public static void resetLayout(GridView gridView, int column) {
		if(column < 1) {
			if(Build.VERSION.SDK_INT >= 16)
				column = gridView.getNumColumns();
			else
				throw new RuntimeException("column < 1");
		}
		
		resetLayout((AbsListView)gridView, column);
	}	
	
	@SuppressLint("NewApi")
	private static void resetLayout(AbsListView listView, int column) {
		ListAdapter listAdapter = listView.getAdapter();
		if (listAdapter == null) {
			return;
		}

		int totalHeight = 0;
		int lineCount =  listAdapter.getCount();
		if(column > 1) {
			lineCount = lineCount / column + 1;
		}
		for (int i = 0, len = listAdapter.getCount(); i < len; i+=column) {
			View listItem = listAdapter.getView(i, null, listView);
			listItem.measure(0, 0);
			totalHeight += listItem.getMeasuredHeight();
		}		
		
		int dividerHeight = DensityUtil.dip2px(8);
		if (ListView.class.isInstance(listView))
			dividerHeight = ((ListView)listView).getDividerHeight();
		else if  (Build.VERSION.SDK_INT >= 16 && GridView.class.isInstance(listView))
			dividerHeight = ((GridView)listView).getHorizontalSpacing();

		ViewGroup.LayoutParams params = listView.getLayoutParams();
		params.height = totalHeight+ (dividerHeight * (lineCount - 1));
		listView.setLayoutParams(params);
	}
}
