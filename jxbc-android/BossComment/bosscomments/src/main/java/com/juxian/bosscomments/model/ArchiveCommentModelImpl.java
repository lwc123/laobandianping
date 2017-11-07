package com.juxian.bosscomments.model;

import android.content.Context;
import android.util.Log;

import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.utils.Bimp;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/14.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/14 16:57]
 * @Version: [v1.0]
 */
public class ArchiveCommentModelImpl implements ArchiveCommentModel {

    @Override
    public void addArchiveComment(final Context context, final ArrayList<String> mSelectImage, final ArchiveCommentEntity entity, final AddArchiveCommentListener listener) {
        new AsyncRunnable<Long>() {
            @Override
            protected Long doInBackground(Void... params) {
                for (int i = 0; i < mSelectImage.size(); i++) {
                    ImageUtils.writeToFile(context, ImageUtils.getSmallBitmap(context, mSelectImage.get(i)), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                }
                if (ImageUtils.saveFilePaths.size() > 0) {
                    entity.WorkCommentImages = new String[ImageUtils.saveFilePaths.size()];
                    for (int i = 0; i < ImageUtils.saveFilePaths.size(); i++) {
                        entity.WorkCommentImages[i] = ImageUtil.toUploadBase64(ImageUtils.saveFilePaths.get(i));
                    }
                }
                Long id = ArchiveCommentRepository.addArchiveComment(entity);
                return id;
            }

            @Override
            protected void onPostExecute(Long id) {
                listener.onArchiveCommentSuccess(id, entity);
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,ex.toString());
                listener.onArchiveCommentFailure(null, ex);
            }
        }.execute();
    }

    @Override
    public void getCommentDetail(final long CompanyId, final long CommentId, final GetCommentDetailListener listener) {
        new AsyncRunnable<ArchiveCommentEntity>() {
            @Override
            protected ArchiveCommentEntity doInBackground(Void... params) {
                ArchiveCommentEntity entity = ArchiveCommentRepository.getCommentDetail(CompanyId, CommentId);
                return entity;
            }

            @Override
            protected void onPostExecute(ArchiveCommentEntity entity) {
                listener.onGetCommentDetailSuccess(entity);
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,ex.toString());
                listener.onGetCommentDetailFailure(null, ex);
            }
        }.execute();
    }

    @Override
    public void changeArchiveComment(final Context context, final ArrayList<String> mNetImage, final ArrayList<String> mSelectImage, final ArchiveCommentEntity entity, final ChangeArchiveCommentListener listener) {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                if (mSelectImage != null) {
                    for (int i = 0; i < mSelectImage.size(); i++) {
                        ImageUtils.writeToFile(context, ImageUtils.getSmallBitmap(context, mSelectImage.get(i)), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                    }
                    entity.WorkCommentImages = new String[mNetImage.size() + mSelectImage.size()];
                    for (int i = 0; i < mNetImage.size(); i++) {
                        entity.WorkCommentImages[i] = mNetImage.get(i);
                    }
                    for (int i = mNetImage.size(); i < (mNetImage.size() + mSelectImage.size()); i++) {
                        entity.WorkCommentImages[i] = ImageUtil.toUploadBase64(ImageUtils.saveFilePaths.get(i - mNetImage.size()));
                    }
                } else {
                    entity.WorkCommentImages = new String[mNetImage.size()];
                    for (int i = 0; i < mNetImage.size(); i++) {
                        entity.WorkCommentImages[i] = mNetImage.get(i);
                    }
                }
                Boolean id = ArchiveCommentRepository.updateArchiveComment(entity);
                return id;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                listener.onArchiveCommentSuccess(isSuccess, entity);
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,ex.toString());
                listener.onArchiveCommentFailure(null, ex);
            }
        }.execute();
    }

    public interface AddArchiveCommentListener {
        void onArchiveCommentSuccess(Long archiveId, ArchiveCommentEntity entity);

        void onArchiveCommentFailure(String msg, Exception e);
    }

    public interface GetCommentDetailListener {
        void onGetCommentDetailSuccess(ArchiveCommentEntity entity);

        void onGetCommentDetailFailure(String msg, Exception e);
    }

    public interface ChangeArchiveCommentListener {
        void onArchiveCommentSuccess(Boolean isSuccess, ArchiveCommentEntity entity);

        void onArchiveCommentFailure(String msg, Exception e);
    }
}
