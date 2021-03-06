package edu.uml.cs.isense.csv;

import edu.uml.cs.isense.csv.R;
import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ViewData extends Activity {

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.view_data);
		
		final Button ok = (Button) findViewById(R.id.view_data_ok);
		ok.setOnClickListener(new OnClickListener() {

			public void onClick(View v) {
				setResult(RESULT_OK);
				finish();
			}	
		});
		
		final Button cancel = (Button) findViewById(R.id.view_data_cancel);
		cancel.setOnClickListener(new OnClickListener() {

			public void onClick(View v) {
				setResult(RESULT_CANCELED);
				finish();
			}	
		});
		
	}
	
	@Override
	public void onBackPressed() {
		setResult(RESULT_CANCELED);
		finish();
	}
}