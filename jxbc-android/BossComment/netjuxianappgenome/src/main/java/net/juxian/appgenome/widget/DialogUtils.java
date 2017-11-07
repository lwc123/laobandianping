package net.juxian.appgenome.widget;

import android.app.Dialog;
import android.content.res.Resources;
import android.graphics.drawable.AnimationDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.bumptech.glide.Glide;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.R;

public class DialogUtils {

	public static Dialog loadingDialog;
	public static View v;

	public static void showLoadingDialog(){
		hideLoadingDialog();
		initLoadingDialog();
	}

	public static void initLoadingDialog() {
		LayoutInflater inflater = LayoutInflater.from(ActivityManager
				.getCurrent());
		View v = inflater.inflate(R.layout.my_loading_dialog, null);//
//		LinearLayout layout = (LinearLayout) v.findViewById(R.id.dialog_view);
		ImageView spaceshipImage = (ImageView) v.findViewById(R.id.img);
		Glide.with(ActivityManager.getCurrent()).load(R.drawable.bossloading).into(spaceshipImage);
		loadingDialog = new Dialog(ActivityManager.getCurrent(),
				R.style.loading_dialog);//
		loadingDialog.setCancelable(false);//
		loadingDialog.setContentView(v, new LinearLayout.LayoutParams(
				LinearLayout.LayoutParams.WRAP_CONTENT,
				LinearLayout.LayoutParams.WRAP_CONTENT));//
		loadingDialog.show();
	}

	public static void hideLoadingDialog(){
		if (loadingDialog != null) {
			loadingDialog.dismiss();
			loadingDialog = null;
		}
	}
}
