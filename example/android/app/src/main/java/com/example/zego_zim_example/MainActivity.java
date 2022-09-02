package com.example.zego_zim_example;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private static final String TAG = "ActivityPluginRegistrant";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        //super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        try {
            flutterEngine.getPlugins().add(new TokenPlugin());
        } catch(Exception e) {
            Log.e(TAG, "Error registering plugin TokenPlugin at Demo MainActivity", e);
        }
    }
}
