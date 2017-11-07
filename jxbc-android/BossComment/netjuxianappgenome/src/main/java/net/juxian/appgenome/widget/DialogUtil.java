package net.juxian.appgenome.widget;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.R;
import android.app.Dialog;
import android.content.res.Resources;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.BitmapDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.bumptech.glide.Glide;

public class DialogUtil {
	public static AnimationDrawable animationDrawable;

	public static Dialog showLoadingDialog1() {
		return showLoadingDialog(0);
	}

	public static Dialog showLoadingDialog(int resourceId) {
		Resources resources = AppContextBase.getCurrentBase().getResources();
		String message = resources.getString(resourceId > 0 ? resourceId
				: R.string.loading_message);
		return showLoadingDialog(message);
	}

	public static Dialog showLoadingDialog(String message) {
		if (null == message) {
			return showLoadingDialog(-1);
		}
		Dialog dialog = new LoadingDialog(ActivityManager.getCurrent(), message);
		dialog.show();
		// Dialog dialog = ProgressDialog.show(ActivityManager.getCurrent(),
		// null, message);
		return dialog;
	}

	//
	public static Dialog showLoadingDialog() {

		LayoutInflater inflater = LayoutInflater.from(ActivityManager
				.getCurrent());
		View v = inflater.inflate(R.layout.my_loading_dialog, null);//

		Dialog loadingDialog = new Dialog(ActivityManager.getCurrent());//
		loadingDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		loadingDialog.setContentView(v);//

		loadingDialog.getWindow().setBackgroundDrawable(new BitmapDrawable());
		loadingDialog.setCancelable(false);//
		LinearLayout layout = (LinearLayout) v.findViewById(R.id.dialog_view);//
		ImageView spaceshipImage = (ImageView) v.findViewById(R.id.img);
		Glide.with(ActivityManager.getCurrent()).load(R.drawable.bossloading).into(spaceshipImage);
		loadingDialog.show();
		return loadingDialog;

	}
}
