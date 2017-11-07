package com.juxian.bosscomments.utils.apiutils;

import com.juxian.bosscomments.repositories.CompanyReputationRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.ToastUtil;

/**
 * Created by nene on 2017/4/21.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/21 18:43]
 * @Version: [v1.0]
 */
public class LikedUtils {

    public static void opinionLiked(final long OpinionId,final int position,final ClickLikedCallBackListener listener) {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isLiked = CompanyReputationRepository.opinionLiked(OpinionId);
                return isLiked;
            }

            @Override
            protected void onPostExecute(Boolean isLiked) {
                if (isLiked) {
//                    ToastUtil.showInfo("点赞成功");
                    listener.clickLikedCallBack(position);
                } else {
//                    ToastUtil.showInfo("点赞失败");
                }
            }

            protected void onPostError(Exception ex) {

            }
        }.execute();
    }

    public interface ClickLikedCallBackListener{
        void clickLikedCallBack(int position);
    }
}
