package com.liferay.mobile.screens.viewsets.defaultviews.asset.display;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import com.liferay.mobile.screens.R;
import com.liferay.mobile.screens.asset.display.AssetDisplayViewModel;
import com.liferay.mobile.screens.base.BaseScreenlet;
import com.liferay.mobile.screens.util.LiferayLogger;

/**
 * @author Sarai Díaz García
 */
public class AssetDisplayView extends FrameLayout implements AssetDisplayViewModel {

	public AssetDisplayView(Context context) {
		super(context);
	}

	public AssetDisplayView(Context context, AttributeSet attributes) {
		super(context, attributes);
	}

	public AssetDisplayView(Context context, AttributeSet attributes, int defaultStyle) {
		super(context, attributes, defaultStyle);
	}

	@Override
	protected void onFinishInflate() {
		super.onFinishInflate();

		progressBar = (ProgressBar) findViewById(R.id.liferay_progress);
		container = (ViewGroup) findViewById(R.id.inner_screenlet_container);
	}

	@Override
	public void showStartOperation(String actionName) {
		progressBar.setVisibility(VISIBLE);
		container.setVisibility(GONE);
	}

	@Override
	public void showFinishOperation(String actionName) {
		throw new UnsupportedOperationException("showFinishOperation(String) is not supported."
			+ " Use showFinishOperation(BaseScreenlet) instead.");
	}

	@Override
	public void showFailedOperation(String actionName, Exception e) {
		progressBar.setVisibility(GONE);
		LiferayLogger.e("Could not load asset", e);
	}

	@Override
	public BaseScreenlet getScreenlet() {
		return screenlet;
	}

	@Override
	public void setScreenlet(BaseScreenlet screenlet) {
		this.screenlet = screenlet;
	}

	private BaseScreenlet screenlet;
	private ProgressBar progressBar;
	private ViewGroup container;
}