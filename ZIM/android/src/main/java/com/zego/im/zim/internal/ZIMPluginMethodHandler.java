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
import java.util.Map;

import im.zego.zim.ZIM;
import im.zego.zim.callback.ZIMConversationListQueriedCallback;
import im.zego.zim.callback.ZIMLogUploadedCallback;
import im.zego.zim.callback.ZIMLoggedInCallback;
import im.zego.zim.callback.ZIMTokenRenewedCallback;
import im.zego.zim.callback.ZIMUsersInfoQueriedCallback;
import im.zego.zim.entity.ZIMCacheConfig;
import im.zego.zim.entity.ZIMConversation;
import im.zego.zim.entity.ZIMConversationQueryConfig;
import im.zego.zim.entity.ZIMError;
import im.zego.zim.entity.ZIMErrorUserInfo;
import im.zego.zim.entity.ZIMLogConfig;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.enums.ZIMErrorCode;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class ZIMPluginMethodHandler {
    private static ZIM zim;

    private static Application application = null;


    public static void getVersion(MethodCall call,Result result){
        result.success(ZIM.getVersion());
    }

    public static void create(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding,ZIMPluginEventHandler eventHandler){
        long appID = call.argument("appID");
        application = (Application)binding.getApplicationContext();
        zim = ZIM.create(appID,application);
        zim.setEventHandler(eventHandler);
        result.success(null);
    }

    public static void destroy(MethodCall call, Result result){
        zim.destroy();
        result.success(null);
    }

    public static void setLogConfig(MethodCall call, Result result){
        ZIMLogConfig zimLogConfig = new ZIMLogConfig();
        zimLogConfig.logPath = call.argument("logPath");
        zimLogConfig.logSize = call.argument("logSize");

        ZIM.setLogConfig(zimLogConfig);
        result.success(null);
    }

    public static void setCacheConfig(MethodCall call, Result result){
        ZIMCacheConfig zimCacheConfig = new ZIMCacheConfig();
        zimCacheConfig.cachePath = call.argument("cachePath");

        ZIM.setCacheConfig(zimCacheConfig);
        result.success(null);
    }

    public static void login(MethodCall call ,Result result){
        String token = call.argument("token");
        ZIMUserInfo userInfo = new ZIMUserInfo();
        userInfo.userID = call.argument("userID");
        userInfo.userName = call.argument("userName");
        zim.login(userInfo, token, new ZIMLoggedInCallback() {
            @Override
            public void onLoggedIn(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else{
                    result.error(String.format("%d",errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void uploadLog(MethodCall call ,Result result){

        zim.uploadLog(new ZIMLogUploadedCallback() {
            @Override
            public void onLogUploaded(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else {
                    result.error(String.format("%d",errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void logout(MethodCall call ,Result result){
        zim.logout();
        result.success(null);
    }

    public static void renewToken(MethodCall call, Result result){
        String token = call.argument("token");

        zim.renewToken(token, new ZIMTokenRenewedCallback() {
            @Override
            public void onTokenRenewed(String token, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }
                else {
                    result.error(String.format("%d",errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryUsersInfo(MethodCall call, Result result){
        ArrayList<String> userIDs = call.argument("userIDs");

        zim.queryUsersInfo(userIDs, new ZIMUsersInfoQueriedCallback() {
            @Override
            public void onUsersInfoQueried(ArrayList<ZIMUserInfo> userList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap resultMap = new HashMap();
                    resultMap.put("userList",ZIMPluginConverter.cnvZIMUserInfoListObjectToBasic(userList));
                    resultMap.put("errorUserList",ZIMPluginConverter.cnvZIMErrorUserInfoListObjectToBasic(errorUserList));
                    result.success(resultMap);
                }
                else{
                    result.error(String.format("%d",errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryConversationList(MethodCall call, Result result){
        HashMap configMap = call.argument("config");
        ZIMConversationQueryConfig config = ZIMPluginConverter.cnvZIMConversationQueryConfigMapToObject(configMap);

        zim.queryConversationList(config, new ZIMConversationListQueriedCallback() {
            @Override
            public void onConversationListQueried(ArrayList<ZIMConversation> conversationList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap conversationListMap = ZIMPluginConverter.cnvZIMConversationObjectToMap()
                    result.success();
                }
                else{

                }
            }
        });
    }
}
