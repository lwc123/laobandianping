package net.juxian.appgenome.widget;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.R;
import net.juxian.appgenome.utils.ResourcesUtil;
import net.juxian.appgenome.utils.TextUtil;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

public class MagicImageView extends com.android.volley.toolbox.NetworkImageView {	
	private final static int ALPHA_MAX = 255;
	
	private static final int SHAPE_RECTANGLE = 0;  
	private static final int SHAPE_ROUND = 1;
	private static final int SHAPE_CIRCLE = 2;  
	
	private int shape;
	private int borderColor = ResourcesUtil.getColor(R.color.grey_500);
	private int borderWidth = 0, cornerRadius = 0;
	private float borderAlpha = 1.0f;
	private String url;
	private int defaultImageResId = 0 ;
	
	private int viewWidth, viewHeight;
	private int bitmapWidth, bitmapHeight;
	private float bitmapScale, translateX, translateY;
	private final Paint borderPaint = new Paint();
	private final Paint imagePaint = new Paint();
	private RectF borderRect = new RectF();
	private RectF imageRect = new RectF();
	private final Matrix matrix = new Matrix();
	
	public MagicImageView(Context context) {
		super(context);
	}
	
	public MagicImageView(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
	}
	
	public MagicImageView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		
		if(null != attrs) {		
			TypedArray typedArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.MagicImageView, defStyle, 0);
			shape = typedArray.getInt(R.styleable.MagicImageView_shape, SHAPE_RECTANGLE);
			borderColor = typedArray.getColor(R.styleable.MagicImageView_borderColor, borderColor);
			borderWidth = typedArray.getDimensionPixelSize(R.styleable.MagicImageView_borderWidth, borderWidth);
			borderAlpha = typedArray.getFloat(R.styleable.MagicImageView_BorderAlpha, borderAlpha);
			cornerRadius = typedArray.getDimensionPixelSize(R.styleable.MagicImageView_cornerRadius, cornerRadius);
			url = typedArray.getString(R.styleable.MagicImageView_url);
			typedArray.recycle();
			
			for(int i=0; i<attrs.getAttributeCount();i++) {
				if("src".equals(attrs.getAttributeName(i))) {
					this.defaultImageResId = Integer.valueOf(attrs.getAttributeValue(i).substring(1));
					this.setDefaultImageResId(this.defaultImageResId);
				}
			}
			
			if(false == TextUtil.isNullOrEmpty(url)) {
				this.setImageUrl(url);
			}
		}
		
		borderPaint.setStyle(Paint.Style.STROKE);
		borderPaint.setAntiAlias(true);
		imagePaint.setAntiAlias(true);
	}
	
	@Override
    public void setImageBitmap(Bitmap bm) {
        super.setImageBitmap(bm);
        this.resetImageDrawable();
    }

    @Override
    public void setImageResource(int resId) {
    	this.setDefaultImageResId(resId);
        super.setImageResource(resId);
        this.resetImageDrawable();
    }
    
	@Override
	public void setImageDrawable(Drawable drawable) {
		super.setImageDrawable(drawable);
	}

	public void setImageUrl(String url) {
		super.setImageUrl(url, ImageLoader.getSingleton());
		this.resetImageDrawable();
    }
	
	public void setImageUrl(String url, ImageLoader imageLoader) {
		if(null == imageLoader) 
			imageLoader = ImageLoader.getSingleton();
		super.setImageUrl(url, imageLoader);
		this.resetImageDrawable();
    }
	

	@Override
	protected void onSizeChanged(int width, int height, int oldw, int oldh) {
		super.onSizeChanged(width, height, oldw, oldh);
		viewWidth = width;
		viewHeight = height;
		if(this.shape == SHAPE_CIRCLE) {
			viewWidth = viewHeight = Math.min(width, height);
		}
		calculateDrawableSizes();
	}
	
	@Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        if(this.shape == SHAPE_CIRCLE) {
            int width = getMeasuredWidth();
            int height = getMeasuredHeight();
            int dimen = Math.min(width, height);
            setMeasuredDimension(dimen, dimen);
        }
    }
	
	@Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
    }
	
	private void resetImageDrawable() {
        imagePaint.setShader(null);
	}
    
    @Override
    public void onDraw(Canvas canvas) {
    	boolean drew = drawShape(canvas);
    	if(false == drew)
    		super.onDraw(canvas);
    }
    
    private boolean drawShape(Canvas canvas)  
    {  
        switch (this.shape)  
        {  
	        case SHAPE_RECTANGLE:
	        	return drawRectangleImage(canvas);
	        case SHAPE_ROUND:
	        	return drawRoundImage(canvas);
	        case SHAPE_CIRCLE:
	        	return drawCircleImage(canvas);
	        }  
        return false;
    }
    
    private boolean drawRectangleImage(Canvas canvas) {
    	if(this.borderWidth == 0) 
    		return false;
    	
    	borderPaint.setColor(borderColor);
        borderPaint.setAlpha(Float.valueOf(borderAlpha * ALPHA_MAX).intValue());
        borderPaint.setStrokeWidth(borderWidth*2);
        
        borderRect.set(borderWidth, borderWidth, viewWidth - borderWidth, viewHeight - borderWidth);
        canvas.drawRect(borderRect, borderPaint);
    	canvas.save(); 
    	
    	initImagePaint();
    	
    	imageRect.set(-translateX, -translateY, bitmapWidth + translateX, bitmapHeight + translateY);
    	canvas.concat(matrix);
    	canvas.drawRect(imageRect, imagePaint);
        canvas.restore();
        return true;
    }
    
    private boolean drawRoundImage(Canvas canvas) {
    	if(this.borderWidth == 0 && this.cornerRadius == 0) 
    		return false;
    	
    	if(this.borderWidth > 0) {
    		borderPaint.setColor(borderColor);
            borderPaint.setAlpha(Float.valueOf(borderAlpha * ALPHA_MAX).intValue());
            borderPaint.setStrokeWidth(borderWidth*2);
            
            borderRect.set(borderWidth, borderWidth, viewWidth - borderWidth, viewHeight - borderWidth);
            canvas.drawRoundRect(borderRect, cornerRadius, cornerRadius, borderPaint);
        	canvas.save();         	
    	}
    	
    	initImagePaint();
    	
    	imageRect.set(-translateX, -translateY, bitmapWidth + translateX, bitmapHeight + translateY);
        int bitmapRadius = Math.round(cornerRadius / bitmapScale);
    	canvas.concat(matrix);
    	canvas.drawRoundRect(imageRect, bitmapRadius, bitmapRadius, imagePaint);
        canvas.restore();
        return true;
    }
    
    private boolean drawCircleImage(Canvas canvas) {
    	if(this.borderWidth > 0) {
    		borderPaint.setColor(borderColor);
            borderPaint.setAlpha(Float.valueOf(borderAlpha * ALPHA_MAX).intValue());
            borderPaint.setStrokeWidth(borderWidth);
            
    		int viewCenter = Math.round(viewWidth / 2f);
        	int borderRadius = Math.round((viewWidth - borderWidth) / 2f);
        	canvas.drawCircle(viewCenter, viewCenter, borderRadius, borderPaint);
        	canvas.save();
    	}
    	
    	initImagePaint();
    	canvas.concat(matrix);
    	canvas.drawCircle(Math.round(bitmapWidth / 2f), Math.round(bitmapHeight / 2f)
    			, Math.round(Math.round(viewWidth - 2f * borderWidth) / bitmapScale / 2f), imagePaint);
    	canvas.restore();
    	return true;
    }
    
	private Bitmap getBitmap() {
        Bitmap bitmap = null;
        Drawable drawable = this.getDrawable();
        if(drawable != null) {
            if(drawable instanceof BitmapDrawable) {
                bitmap = ((BitmapDrawable) drawable).getBitmap();
            }
        }

        return bitmap;
    }
	
	private void initImagePaint() {	
		Bitmap bitmap = calculateDrawableSizes();
        if(bitmap != null && bitmap.getWidth() > 0 && bitmap.getHeight() > 0) {
        	BitmapShader shader = new BitmapShader(bitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
            imagePaint.setShader(shader);
        }
	}

    private Bitmap calculateDrawableSizes() {
        Bitmap bitmap = getBitmap();
        if(bitmap != null) {
            bitmapWidth = bitmap.getWidth();
            bitmapHeight = bitmap.getHeight();

            if(bitmapWidth > 0 && bitmapHeight > 0) {
                float width = Math.round(viewWidth - 2f * borderWidth);
                float height = Math.round(viewHeight - 2f * borderWidth);

                if (bitmapWidth * height > width * bitmapHeight) {
                	bitmapScale = height / bitmapHeight;
                    translateX = Math.round((width/bitmapScale - bitmapWidth) / 2f);
                } else {
                	bitmapScale = width / (float) bitmapWidth;
                    translateY = Math.round((height/bitmapScale - bitmapHeight) / 2f);
                }

                matrix.setScale(bitmapScale, bitmapScale);
                matrix.preTranslate(translateX, translateY);
                matrix.postTranslate(borderWidth, borderWidth);

                return bitmap;
            }
        }

        return null;
    }

}
