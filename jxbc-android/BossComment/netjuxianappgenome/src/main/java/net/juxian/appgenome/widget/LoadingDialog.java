package net.juxian.appgenome.widget;

import net.juxian.appgenome.R;
import android.app.Dialog;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

public class LoadingDialog extends Dialog {
	private TextView txtMessage;
	
	public LoadingDialog(Context context) {  
        this(context, null);  
    }  
  
    public LoadingDialog(Context context, String message) {  
        super(context, R.style.dialog_loading);  
        this.setContentView(R.layout.dialog_loading);   
        this.setCancelable(false);
        
        this.txtMessage = (TextView) this.findViewById(R.id.loading_message);  
        this.setMessage(message);
    }  
  
    @Override  
    public void onWindowFocusChanged(boolean hasFocus) {  
  
        if (!hasFocus) {  
            dismiss();  
        }  
    }  
    
    public void setMessage(String message) {
    	if(null == this.txtMessage) return;
    	
    	if(TextUtils.isEmpty(message)) {
    		this.txtMessage.setVisibility(View.GONE);
    	} else {
    		this.txtMessage.setText(message);
    		this.txtMessage.setVisibility(View.VISIBLE);
    	}
    }
}
