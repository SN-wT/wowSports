package com.nft.wowsports;

import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.wowt.flowhackathon/aractivity";
    private static final String TAG = "MethodChannel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {

                            Log.d(TAG, "Call received ");
                            //  startActivity();
                            startActivity(new Intent(MainActivity.this, ARVideoActivity.class));


                        }
                );
    }
}

