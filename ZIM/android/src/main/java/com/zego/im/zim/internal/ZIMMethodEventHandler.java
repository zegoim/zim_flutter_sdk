package com.zego.im.zim.internal;

import android.app.Application;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.lang.*;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;

import im.zego.zim.ZIM;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class ZIMMethodEventHandler {
    private static ZIM zim;

    private static Application application = null;

    public static void getVersion(MethodCall call,Result result){
        result.success(ZIM.getVersion());
    }

    public static void create(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding){
        long appID = call.argument("appID");
        application = (Application)binding.getApplicationContext();
        zim = ZIM.create(appID,application);
        result.success(null);
    }

    //public static void

}
