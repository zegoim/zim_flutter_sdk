package im.zego.zim_flutter.internal;

import android.app.Application;
import android.util.Log;

import java.lang.*;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

//import javax.xml.transform.Result;

import im.zego.zim.ZIM;
import im.zego.zim.callback.*;
import im.zego.zim.entity.*;
import im.zego.zim.enums.*;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
@SuppressWarnings({"unused","deprecation"})

public class ZIMPluginMethodHandler {
    private static final HashMap<String, ZIM> engineMap = new HashMap<>();
    public static void getVersion(MethodCall call,Result result){
        result.success(ZIM.getVersion());
    }

    public static void writeLog(MethodCall call,Result result){
        String log = call.argument("logString");
        LogWriter.writeLog(log);
    }

    public static void create(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding,ZIMPluginEventHandler eventHandler){

        ZIM oldZIM = ZIM.getInstance();
        if(oldZIM != null) {
            oldZIM.destroy();
        }

        String handle = call.argument("handle");
        Application application = (Application) binding.getApplicationContext();

        ZIM.setAdvancedConfig("zim_cross_platform","flutter");
        ZIMAppConfig appConfig = ZIMPluginConverter.oZIMAppConfig(Objects.requireNonNull(call.argument("config")));
        ZIM zim = ZIM.create(appConfig, application);
        if(zim != null) {
            engineMap.put(handle, zim);
            ZIMPluginEventHandler.engineMapForCallback.put(zim, handle);
            zim.setEventHandler(eventHandler);
        }

        result.success(null);
    }

    public static void destroy(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim != null) {
            zim.destroy();
            engineMap.remove(handle);
            ZIMPluginEventHandler.engineMapForCallback.remove(zim);
        }

        result.success(null);
    }

    public static void setLogConfig(MethodCall call, Result result){
        ZIMLogConfig zimLogConfig = new ZIMLogConfig();
        zimLogConfig.logPath = call.argument("logPath");
        zimLogConfig.logSize = ZIMPluginCommonTools.safeGetLongValue(call.argument("logSize"));
        ZIM.setLogConfig(zimLogConfig);
        result.success(null);
    }

    public static void setCacheConfig(MethodCall call, Result result){
        ZIMCacheConfig zimCacheConfig = new ZIMCacheConfig();
        zimCacheConfig.cachePath = call.argument("cachePath");

        ZIM.setCacheConfig(zimCacheConfig);
        result.success(null);
    }

    public static void setGeofencingConfig(MethodCall call, Result result){
        ArrayList<Integer> areaList = call.argument("areaList");
        ZIMGeofencingType type = ZIMGeofencingType.getZIMGeofencingType(call.argument("type"));
        boolean ret = ZIM.setGeofencingConfig(areaList,type);
        result.success(ret);
    }

    public static void login(MethodCall call ,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String userID = call.argument("userID");
        ZIMLoginConfig loginConfig = ZIMPluginConverter.oZIMLoginConfig(call.argument("config"));

        zim.login(userID, loginConfig, new ZIMLoggedInCallback() {
            @Override
            public void onLoggedIn(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void uploadLog(MethodCall call ,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        zim.uploadLog(new ZIMLogUploadedCallback() {
            @Override
            public void onLogUploaded(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void logout(MethodCall call ,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        zim.logout();
        result.success(null);
    }

    public static void renewToken(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String token = call.argument("token");
        zim.renewToken(token, new ZIMTokenRenewedCallback() {
            @Override
            public void onTokenRenewed(String token, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("token",token);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryUsersInfo(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");
        ZIMUsersInfoQueryConfig config = ZIMPluginConverter.oZIMUsersInfoQueryConfig(Objects.requireNonNull(call.argument("config")));

        zim.queryUsersInfo(userIDs, config, new ZIMUsersInfoQueriedCallback() {
            @Override
            public void onUsersInfoQueried(ArrayList<ZIMUserFullInfo> userList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("userList",ZIMPluginConverter.mZIMUserFullInfoList(userList));
                    resultMap.put("errorUserList",ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList));
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateUserName(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userName = call.argument("userName");
        zim.updateUserName(userName, new ZIMUserNameUpdatedCallback() {
            @Override
            public void onUserNameUpdated(String userName, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("userName",userName);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }


    public static void updateUserAvatarUrl(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userAvatarUrl = call.argument("userAvatarUrl");
        zim.updateUserAvatarUrl(userAvatarUrl, new ZIMUserAvatarUrlUpdatedCallback() {
            @Override
            public void onUserAvatarUrlUpdated(String userAvatarUrl, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("userAvatarUrl",userAvatarUrl);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateUserExtendedData(MethodCall call ,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String extendedData = call.argument("extendedData");
        zim.updateUserExtendedData(extendedData, new ZIMUserExtendedDataUpdatedCallback() {
            @Override
            public void onUserExtendedDataUpdated(String extendedData, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("extendedData",extendedData);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryConversationList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String,Object> configMap = Objects.requireNonNull((call.argument("config")));
        ZIMConversationQueryConfig config = ZIMPluginConverter.oZIMConversationQueryConfig(configMap);

        zim.queryConversationList(config, new ZIMConversationListQueriedCallback() {
            @Override
            public void onConversationListQueried(ArrayList<ZIMConversation> conversationList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> basicConversationList = ZIMPluginConverter.mZIMConversationList(conversationList);
                    resultMap.put("conversationList",basicConversationList);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryConversation(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        zim.queryConversation(conversationID, conversationType, new ZIMConversationQueriedCallback() {
            @Override
            public void onConversationQueried(ZIMConversation conversation, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversation", ZIMPluginConverter.mZIMConversation(conversation));
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryConversationPinnedList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String,Object> configMap = Objects.requireNonNull((call.argument("config")));
        ZIMConversationQueryConfig config = ZIMPluginConverter.oZIMConversationQueryConfig(configMap);

        zim.queryConversationPinnedList(config, new ZIMConversationPinnedListQueriedCallback() {
            @Override
            public void onConversationPinnedListQueried(ArrayList<ZIMConversation> conversationList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> basicConversationList = ZIMPluginConverter.mZIMConversationList(conversationList);
                    resultMap.put("conversationList",basicConversationList);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateConversationPinnedState(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        boolean isPinned  = call.argument("isPinned");
        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));

        zim.updateConversationPinnedState(isPinned, conversationID, conversationType, new ZIMConversationPinnedStateUpdatedCallback() {
            @Override
            public void onConversationPinnedStateUpdated(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteConversation(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMConversationDeleteConfig config = ZIMPluginConverter.oZIMConversationDeleteConfig(Objects.requireNonNull(call.argument("config")));
        zim.deleteConversation(conversationID, conversationType, config, new ZIMConversationDeletedCallback() {
            @Override
            public void onConversationDeleted(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteAllConversations(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMConversationDeleteConfig config = ZIMPluginConverter.oZIMConversationDeleteConfig(Objects.requireNonNull(call.argument("config")));
        zim.deleteAllConversations(config, new ZIMConversationsAllDeletedCallback() {
            @Override
            public void onConversationsAllDeleted(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void clearConversationUnreadMessageCount(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        zim.clearConversationUnreadMessageCount(conversationID, conversationType, new ZIMConversationUnreadMessageCountClearedCallback() {
            @Override
            public void onConversationUnreadMessageCountCleared(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }
    
    public static void clearConversationTotalUnreadMessageCount(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        zim.clearConversationTotalUnreadMessageCount(new ZIMConversationTotalUnreadMessageCountClearedCallback() {
            @Override
            public void onConversationTotalUnreadMessageCountCleared(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setConversationNotificationStatus(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMConversationNotificationStatus status = ZIMConversationNotificationStatus.getZIMConversationNotificationStatus(ZIMPluginCommonTools.safeGetIntValue(call.argument("status")));
        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        zim.setConversationNotificationStatus(status, conversationID, conversationType, new ZIMConversationNotificationStatusSetCallback() {
            @Override
            public void onConversationNotificationStatusSet(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void sendConversationMessageReceiptRead(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String conversationID = Objects.requireNonNull(call.argument("conversationID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        zim.sendConversationMessageReceiptRead(conversationID, conversationType, new ZIMConversationMessageReceiptReadSentCallback() {
            @Override
            public void onConversationMessageReceiptReadSent(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setConversationDraft(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String draft = Objects.requireNonNull(call.argument("draft"));
        String conversationID = Objects.requireNonNull(call.argument("conversationID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        zim.setConversationDraft(draft, conversationID, conversationType, new ZIMConversationDraftSetCallback() {
            @Override
            public void onConversationDraftSet(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void sendMessageReceiptsRead(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String conversationID = Objects.requireNonNull(call.argument("conversationID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ArrayList<ZIMMessage> messageList = ZIMPluginConverter.oZIMMessageList(Objects.requireNonNull(call.argument("messageList")));
        zim.sendMessageReceiptsRead(messageList, conversationID, conversationType, new ZIMMessageReceiptsReadSentCallback() {
            @Override
            public void onMessageReceiptsReadSent(String conversationID, ZIMConversationType conversationType, ArrayList<Long> errorMessageIDs, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    resultMap.put("errorMessageIDs",errorMessageIDs);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryMessageReceiptsInfo(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String conversationID = Objects.requireNonNull(call.argument("conversationID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ArrayList<ZIMMessage> messageList = ZIMPluginConverter.oZIMMessageList(Objects.requireNonNull(call.argument("messageList")));
        zim.queryMessageReceiptsInfo(messageList, conversationID, conversationType, new ZIMMessageReceiptsInfoQueriedCallback() {
            @Override
            public void onMessageReceiptsInfoQueried(ArrayList<ZIMMessageReceiptInfo> infos, ArrayList<Long> errorMessageIDs, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> infosModel= new ArrayList<>();
                    for (ZIMMessageReceiptInfo info:infos
                         ) {
                        infosModel.add(ZIMPluginConverter.mZIMMessageReceiptInfo(info));
                    }
                    resultMap.put("infos",infosModel);
                    resultMap.put("errorMessageIDs",errorMessageIDs);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMessageReceiptReadMemberList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = ZIMPluginConverter.oZIMMessage(call.argument("message"));
        String groupID = call.argument("groupID");
        ZIMGroupMessageReceiptMemberQueryConfig config = ZIMPluginConverter.oZIMGroupMessageReceiptMemberQueryConfig(Objects.requireNonNull(call.argument("config")));
        zim.queryGroupMessageReceiptReadMemberList(message, groupID, config, new ZIMGroupMessageReceiptMemberListQueriedCallback() {
            @Override
            public void onGroupMessageReceiptMemberListQueried(String groupID, ArrayList<ZIMGroupMemberInfo> userList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("userList",ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
                    resultMap.put("nextFlag",nextFlag);
                    resultMap.put("groupID",groupID);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMessageReceiptUnreadMemberList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = ZIMPluginConverter.oZIMMessage(call.argument("message"));
        String groupID = call.argument("groupID");
        ZIMGroupMessageReceiptMemberQueryConfig config = ZIMPluginConverter.oZIMGroupMessageReceiptMemberQueryConfig(Objects.requireNonNull(call.argument("config")));
        zim.queryGroupMessageReceiptUnreadMemberList(message, groupID, config, new ZIMGroupMessageReceiptMemberListQueriedCallback() {
            @Override
            public void onGroupMessageReceiptMemberListQueried(String groupID, ArrayList<ZIMGroupMemberInfo> userList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("userList",ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
                    resultMap.put("nextFlag",nextFlag);
                    resultMap.put("groupID",groupID);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void revokeMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = ZIMPluginConverter.oZIMMessage(call.argument("message"));
        ZIMMessageRevokeConfig revokeConfig = ZIMPluginConverter.oZIMMessageRevokeConfig(Objects.requireNonNull(call.argument("config")));
        zim.revokeMessage(message, revokeConfig, new ZIMMessageRevokedCallback() {
            @Override
            public void onMessageRevoked(ZIMMessage message, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("message",ZIMPluginConverter.mZIMMessage(message));
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void sendPeerMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessage message = ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String toUserID = (String) Objects.requireNonNull(call.argument("toUserID"));
        ZIMMessageSendConfig config = ZIMPluginConverter.oZIMMessageSendConfig(Objects.requireNonNull(call.argument("config")));
        zim.sendPeerMessage(message, toUserID, config, new ZIMMessageSentCallback() {
            @Override
            public void onMessageAttached(ZIMMessage message) {

            }

            @Override
            public void onMessageSent(ZIMMessage message, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                    resultMap.put("message",messageMap);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void sendGroupMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessage message = ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String toGroupID = (String) Objects.requireNonNull(call.argument("toGroupID"));
        ZIMMessageSendConfig config = ZIMPluginConverter.oZIMMessageSendConfig(Objects.requireNonNull(call.argument("config")));
        zim.sendGroupMessage(message, toGroupID, config, new ZIMMessageSentCallback() {
            @Override
            public void onMessageAttached(ZIMMessage message) {

            }

            @Override
            public void onMessageSent(ZIMMessage message, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                    resultMap.put("message",messageMap);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void sendRoomMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessage message = ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String toRoomID = (String) Objects.requireNonNull(call.argument("toRoomID"));
        ZIMMessageSendConfig config = ZIMPluginConverter.oZIMMessageSendConfig(Objects.requireNonNull(call.argument("config")));
        zim.sendRoomMessage(message, toRoomID, config, new ZIMMessageSentCallback() {
            @Override
            public void onMessageAttached(ZIMMessage message) {

            }

            @Override
            public void onMessageSent(ZIMMessage message, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                    resultMap.put("message",messageMap);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void downloadMediaFile(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMediaMessage mediaMessage = (ZIMMediaMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        ZIMMediaFileType fileType = ZIMMediaFileType.getZIMMediaFileType(ZIMPluginCommonTools.safeGetIntValue(call.argument("fileType")));
        Integer progressID = call.argument("progressID");
        zim.downloadMediaFile(mediaMessage, fileType, new ZIMMediaDownloadedCallback() {
            @Override
            public void onMediaDownloaded(ZIMMediaMessage message, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("message",messageMap);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }

            @Override
            public void onMediaDownloadingProgress(ZIMMediaMessage message, long currentFileSize, long totalFileSize) {
                if(ZIMPluginEventHandler.mysink == null) {
                    return;
                }
                HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                HashMap<String,Object> resultMap = new HashMap<>();
                resultMap.put("handle",handle);
                resultMap.put("method","downloadMediaFileProgress");
                resultMap.put("progressID",progressID);
                resultMap.put("message",messageMap);
                resultMap.put("currentFileSize",currentFileSize);
                resultMap.put("totalFileSize",totalFileSize);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }
        });
    }

    public static void sendMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String toConversationID = Objects.requireNonNull(call.argument("toConversationID"));
        Integer messageAttachedCallbackID = call.argument("messageAttachedCallbackID");
        Integer messageID = Objects.requireNonNull(call.argument("messageID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageSendConfig config = ZIMPluginConverter.oZIMMessageSendConfig(Objects.requireNonNull(call.argument("config")));
        zim.sendMessage(message, toConversationID, conversationType, config, new ZIMMessageSentCallback() {
            @Override
            public void onMessageAttached(ZIMMessage message) {
                if(messageAttachedCallbackID == null){
                    return;
                }
                HashMap<String,Object> resultMap = new HashMap<>();
                HashMap<String,Object> messageModel = ZIMPluginConverter.mZIMMessage(message);
                resultMap.put("handle",handle);
                resultMap.put("message",messageModel);
                resultMap.put("method","onMessageAttached");
                resultMap.put("messageID",messageID);
                resultMap.put("messageAttachedCallbackID",messageAttachedCallbackID);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }

            @Override
            public void onMessageSent(ZIMMessage message, ZIMError errorInfo) {
                HashMap<String,Object> resultMap = new HashMap<>();
                HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                resultMap.put("message",messageMap);
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,resultMap);
                }
            }
        });
    }

    public static void insertMessageToLocalDB(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String conversationID = Objects.requireNonNull(call.argument("conversationID"));
        Integer messageID = Objects.requireNonNull(call.argument("messageID"));
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        String senderUserID = Objects.requireNonNull(call.argument("senderUserID"));
        zim.insertMessageToLocalDB(message, conversationID, conversationType, senderUserID, new ZIMMessageInsertedCallback() {
            @Override
            public void onMessageInserted(ZIMMessage message, ZIMError errorInfo) {
                HashMap<String,Object> resultMap = new HashMap<>();
                HashMap<String,Object> messageModel = ZIMPluginConverter.mZIMMessage(message);
                resultMap.put("message",messageModel);
                resultMap.put("messageID",messageID);
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,resultMap);
                }
            }
        });
    }

    public static void updateMessageLocalExtendedData(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String localExtendedData = Objects.requireNonNull(call.argument("localExtendedData"));
        zim.updateMessageLocalExtendedData(localExtendedData, message,  new ZIMMessageLocalExtendedDataUpdatedCallback() {
            @Override
            public void onMessageExtendedDataUpdated(ZIMMessage message, ZIMError errorInfo) {
                HashMap<String,Object> resultMap = new HashMap<>();
                HashMap<String,Object> messageModel = ZIMPluginConverter.mZIMMessage(message);
                resultMap.put("message",messageModel);
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,resultMap);
                }
            }
        });
    }

    public static void sendMediaMessage(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMediaMessage mediaMessage = (ZIMMediaMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String toConversationID = call.argument("toConversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageSendConfig config = ZIMPluginConverter.oZIMMessageSendConfig(Objects.requireNonNull(call.argument("config")));
        Integer progressID = call.argument("progressID");
        Integer messageID = call.argument("messageID");
        Integer messageAttachedCallbackID = call.argument("messageAttachedCallbackID");

        zim.sendMediaMessage(mediaMessage, toConversationID, conversationType, config, new ZIMMediaMessageSentCallback() {
            @Override
            public void onMessageSent(ZIMMediaMessage message, ZIMError errorInfo) {
                HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                HashMap<String,Object> resultMap = new HashMap<>();
                resultMap.put("message",messageMap);
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,resultMap);
                }
            }

            @Override
            public void onMessageAttached(ZIMMediaMessage message) {
                if(messageAttachedCallbackID == null){
                    return;
                }
                HashMap<String,Object> resultMap = new HashMap<>();
                HashMap<String,Object> messageModel = ZIMPluginConverter.mZIMMessage(message);
                resultMap.put("handle",handle);
                resultMap.put("message",messageModel);
                resultMap.put("method","onMessageAttached");
                resultMap.put("messageID",messageID);
                resultMap.put("messageAttachedCallbackID",messageAttachedCallbackID);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }

            @Override
            public void onMediaUploadingProgress(ZIMMediaMessage message, long currentFileSize, long totalFileSize) {
                if(ZIMPluginEventHandler.mysink == null) {
                    return;
                }
                HashMap<String,Object> messageMap = ZIMPluginConverter.mZIMMessage(message);
                HashMap<String,Object> resultMap = new HashMap<>();
                resultMap.put("handle",handle);
                resultMap.put("method","uploadMediaProgress");
                resultMap.put("progressID",progressID);
                resultMap.put("message",messageMap);
                resultMap.put("currentFileSize",currentFileSize);
                resultMap.put("totalFileSize",totalFileSize);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }
        });
    }

    public static void queryHistoryMessage(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageQueryConfig config = ZIMPluginConverter.oZIMMessageQueryConfig(Objects.requireNonNull(call.argument("config")));

        zim.queryHistoryMessage(conversationID, conversationType, config, new ZIMMessageQueriedCallback() {
            @Override
            public void onMessageQueried(String conversationID, ZIMConversationType conversationType, ArrayList<ZIMMessage> messageList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    resultMap.put("messageList",ZIMPluginConverter.mZIMMessageList(messageList));
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteAllMessage(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageDeleteConfig config = ZIMPluginConverter.oZIMMessageDeleteConfig(Objects.requireNonNull(call.argument("config")));

        zim.deleteAllMessage(conversationID, conversationType, config, new ZIMMessageDeletedCallback() {
            @Override
            public void onMessageDeleted(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteAllConversationMessages(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessageDeleteConfig config = ZIMPluginConverter.oZIMMessageDeleteConfig(Objects.requireNonNull(call.argument("config")));

        zim.deleteAllConversationMessages(config, new ZIMConversationMessagesAllDeletedCallback() {
            @Override
            public void onConversationMessagesAllDeleted(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteMessages(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<ZIMMessage> messageList = ZIMPluginConverter.oZIMMessageList(Objects.requireNonNull(call.argument("messageList")));
        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageDeleteConfig config = ZIMPluginConverter.oZIMMessageDeleteConfig(Objects.requireNonNull(call.argument("config")));

        zim.deleteMessages(messageList, conversationID, conversationType, config, new ZIMMessageDeletedCallback() {
            @Override
            public void onMessageDeleted(String conversationID, ZIMConversationType conversationType, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("conversationID",conversationID);
                    resultMap.put("conversationType",conversationType.value());
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void searchLocalMessages(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String conversationID = call.argument("conversationID");
        ZIMConversationType conversationType = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(call.argument("conversationType")));
        ZIMMessageSearchConfig config = ZIMPluginConverter.oZIMMessageSearchConfig(Objects.requireNonNull(call.argument("config")));
        zim.searchLocalMessages(conversationID, conversationType, config, new ZIMMessagesSearchedCallback() {
            @Override
            public void onMessagesSearched(String conversationID, ZIMConversationType conversationType, ArrayList<ZIMMessage> messageList, ZIMMessage nextMessage, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("conversationID", conversationID);
                    resultMap.put("conversationType", conversationType.value());
                    resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
                    if(nextMessage != null) {
                        resultMap.put("nextMessage", ZIMPluginConverter.mZIMMessage(nextMessage));
                    } else {
                        resultMap.put("nextMessage", null);
                    }
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void searchGlobalLocalMessages(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessageSearchConfig config = ZIMPluginConverter.oZIMMessageSearchConfig(Objects.requireNonNull(call.argument("config")));
        zim.searchGlobalLocalMessages(config, new ZIMMessagesGlobalSearchedCallback() {
            @Override
            public void onMessagesGlobalSearched(ArrayList<ZIMMessage> messageList, ZIMMessage nextMessage, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
                    if(nextMessage != null) {
                        resultMap.put("nextMessage", ZIMPluginConverter.mZIMMessage(nextMessage));
                    } else {
                        resultMap.put("nextMessage", null);
                    }
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void searchLocalConversations(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMConversationSearchConfig config = ZIMPluginConverter.oZIMConversationMessageGlobalSearchConfig(Objects.requireNonNull(call.argument("config")));
        zim.searchLocalConversations(config, new ZIMConversationsSearchedCallback() {
            @Override
            public void onConversationsSearched(ArrayList<ZIMConversationSearchInfo> globalMessageInfoList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("conversationSearchInfoList", ZIMPluginConverter.mZIMConversationSearchInfoList(globalMessageInfoList));
                    resultMap.put("nextFlag", nextFlag);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void createRoom(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMRoomInfo roomInfo = ZIMPluginConverter.oZIMRoomInfo(Objects.requireNonNull(call.argument("roomInfo")));

        zim.createRoom(roomInfo, new ZIMRoomCreatedCallback() {
            @Override
            public void onRoomCreated(ZIMRoomFullInfo roomInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> roomInfoMap = ZIMPluginConverter.mZIMRoomFullInfo(roomInfo);
                    resultMap.put("roomInfo",roomInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }

            }
        });
    }

    public static void createRoomWithConfig(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMRoomInfo roomInfo = ZIMPluginConverter.oZIMRoomInfo(Objects.requireNonNull(call.argument("roomInfo")));
        ZIMRoomAdvancedConfig config = ZIMPluginConverter.oZIMRoomAdvancedConfig(Objects.requireNonNull(ZIMPluginCommonTools.safeGetHashMap(call.argument("config"))));

        zim.createRoom(roomInfo,config, new ZIMRoomCreatedCallback() {
            @Override
            public void onRoomCreated(ZIMRoomFullInfo roomInfo,ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> roomInfoMap = ZIMPluginConverter.mZIMRoomFullInfo(roomInfo);
                    resultMap.put("roomInfo",roomInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }

            }
        });
    }

    public static void enterRoom(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMRoomInfo roomInfo = ZIMPluginConverter.oZIMRoomInfo(Objects.requireNonNull(call.argument("roomInfo")));
        ZIMRoomAdvancedConfig config = ZIMPluginConverter.oZIMRoomAdvancedConfig(Objects.requireNonNull(ZIMPluginCommonTools.safeGetHashMap(call.argument("config"))));
        zim.enterRoom(roomInfo, config, new ZIMRoomEnteredCallback() {
            @Override
            public void onRoomEntered(ZIMRoomFullInfo roomInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> roomInfoMap = ZIMPluginConverter.mZIMRoomFullInfo(roomInfo);
                    resultMap.put("roomInfo",roomInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    };

    public static void joinRoom(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        zim.joinRoom(roomID, new ZIMRoomJoinedCallback() {
            @Override
            public void onRoomJoined(ZIMRoomFullInfo roomInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> roomInfoMap = ZIMPluginConverter.mZIMRoomFullInfo(roomInfo);
                    resultMap.put("roomInfo",roomInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void leaveRoom(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        zim.leaveRoom(roomID, new ZIMRoomLeftCallback() {
            @Override
            public void onRoomLeft(String roomID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryRoomMemberList(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        ZIMRoomMemberQueryConfig config = ZIMPluginConverter.oZIMRoomMemberQueryConfig(Objects.requireNonNull(ZIMPluginCommonTools.safeGetHashMap(call.argument("config"))));

        zim.queryRoomMemberList(roomID, config, new ZIMRoomMemberQueriedCallback() {
            @Override
            public void onRoomMemberQueried(String roomID, ArrayList<ZIMUserInfo> memberList, String nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    ArrayList<HashMap<String,Object>> basicMemberList = ZIMPluginConverter.mZIMUserInfoList(memberList);
                    resultMap.put("memberList",basicMemberList);
                    resultMap.put("nextFlag",nextFlag);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryRoomMembers(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        ArrayList<String> userIDs = call.argument("userIDs");
        zim.queryRoomMembers(userIDs, roomID, new ZIMRoomMembersQueriedCallback() {
            @Override
            public void onRoomMembersQueried(String roomID, ArrayList<ZIMRoomMemberInfo> memberList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo){
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    ArrayList<HashMap<String,Object>> basicMemberList = ZIMPluginConverter.mZIMRoomMemberInfoList(memberList);
                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);
                    resultMap.put("errorUserList",basicErrorUserList);
                    resultMap.put("memberList",basicMemberList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryRoomOnlineMemberCount(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");

        zim.queryRoomOnlineMemberCount(roomID, new ZIMRoomOnlineMemberCountQueriedCallback() {
            @Override
            public void onRoomOnlineMemberCountQueried(String roomID, int count, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    resultMap.put("count",count);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setRoomAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String,String> roomAttributes = call.argument("roomAttributes");
        String roomID = call.argument("roomID");
        ZIMRoomAttributesSetConfig config = ZIMPluginConverter.oZIMRoomAttributesSetConfig(call.argument("config"));
        zim.setRoomAttributes(roomAttributes, roomID, config, new ZIMRoomAttributesOperatedCallback() {
            @Override
            public void onRoomAttributesOperated(String roomID, ArrayList<String> errorKeys, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    resultMap.put("errorKeys",errorKeys);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteRoomAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        List<String> keys = call.argument("keys");
        String roomID = call.argument("roomID");
        ZIMRoomAttributesDeleteConfig config = ZIMPluginConverter.oZIMRoomAttributesDeleteConfig(call.argument("config"));

        zim.deleteRoomAttributes(keys, roomID, config, new ZIMRoomAttributesOperatedCallback() {
            @Override
            public void onRoomAttributesOperated(String roomID, ArrayList<String> errorKeys, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    resultMap.put("errorKeys",errorKeys);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void beginRoomAttributesBatchOperation(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        ZIMRoomAttributesBatchOperationConfig config = ZIMPluginConverter.oZIMRoomAttributesBatchOperationConfig(call.argument("config"));
        zim.beginRoomAttributesBatchOperation(roomID,config);
        result.success(null);
    }

    public static void endRoomAttributesBatchOperation(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        zim.endRoomAttributesBatchOperation(roomID, new ZIMRoomAttributesBatchOperatedCallback() {
            @Override
            public void onRoomAttributesBatchOperated(String roomID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryRoomAllAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String roomID = call.argument("roomID");
        zim.queryRoomAllAttributes(roomID, new ZIMRoomAttributesQueriedCallback() {
            @Override
            public void onRoomAttributesQueried(String roomID, HashMap<String, String> roomAttributes, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    resultMap.put("roomAttributes",roomAttributes);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setRoomMembersAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String roomID = call.argument("roomID");
        HashMap<String,String> attributes = call.argument("attributes");
        ZIMRoomMemberAttributesSetConfig setConfig = ZIMPluginConverter.oZIMRoomMemberAttributesSetConfig(call.argument("config"));
        ArrayList<String> userIDs = call.argument("userIDs");
        zim.setRoomMembersAttributes(attributes, userIDs, roomID, setConfig, new ZIMRoomMembersAttributesOperatedCallback() {
            @Override
            public void onRoomMembersAttributesOperated(String roomID, ArrayList<ZIMRoomMemberAttributesOperatedInfo> infos, ArrayList<String> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("roomID",roomID);
                    ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
                    for (ZIMRoomMemberAttributesOperatedInfo info:infos
                    ) {
                        infosModel.add(ZIMPluginConverter.mZIMRoomMemberAttributesOperatedInfo(info));
                    }
                    resultMap.put("infos",infosModel);
                    resultMap.put("errorUserList",errorUserList);
                    result.success(resultMap);
                }
                else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });

    }

    public static void queryRoomMembersAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String roomID = call.argument("roomID");
        ArrayList<String> userIDs = call.argument("userIDs");
        zim.queryRoomMembersAttributes(userIDs, roomID, new ZIMRoomMembersAttributesQueriedCallback() {
            @Override
            public void onRoomMembersAttributesQueried(String roomID, ArrayList<ZIMRoomMemberAttributesInfo> infos, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
                    resultMap.put("roomID",roomID);
                    for (ZIMRoomMemberAttributesInfo info:infos
                         ) {
                        infosModel.add(ZIMPluginConverter.mZIMRoomMemberAttributesInfo(info));
                    }
                    resultMap.put("infos",infosModel);
                    result.success(resultMap);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryRoomMemberAttributesList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String roomID = call.argument("roomID");
        ZIMRoomMemberAttributesQueryConfig queryConfig = ZIMPluginConverter.oZIMRoomMemberAttributesQueryConfig(call.argument("config"));
        zim.queryRoomMemberAttributesList(roomID, queryConfig, new ZIMRoomMemberAttributesListQueriedCallback() {
            @Override
            public void onRoomMemberAttributesListQueried(String roomID, ArrayList<ZIMRoomMemberAttributesInfo> infos, String nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
                    resultMap.put("roomID",roomID);
                    for (ZIMRoomMemberAttributesInfo info:infos
                    ) {
                        infosModel.add(ZIMPluginConverter.mZIMRoomMemberAttributesInfo(info));
                    }
                    resultMap.put("infos",infosModel);
                    resultMap.put("nextFlag",nextFlag);
                    result.success(resultMap);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void createGroup(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMGroupInfo groupInfo = ZIMPluginConverter.oZIMGroupInfo(Objects.requireNonNull(call.argument("groupInfo")));
        ArrayList<String> userIDs = call.argument("userIDs");

        zim.createGroup(groupInfo, userIDs, new ZIMGroupCreatedCallback() {
            @Override
            public void onGroupCreated(ZIMGroupFullInfo groupInfo, ArrayList<ZIMGroupMemberInfo> userList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {

                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> groupInfoMap = ZIMPluginConverter.mZIMGroupFullInfo(groupInfo);
                    ArrayList<HashMap<String,Object>> basicUserList = ZIMPluginConverter.mZIMGroupMemberInfoList(userList);
                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);
                    resultMap.put("groupInfo",groupInfoMap);
                    resultMap.put("userList",basicUserList);
                    resultMap.put("errorUserList",basicErrorUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void createGroupWithConfig(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMGroupInfo groupInfo = ZIMPluginConverter.oZIMGroupInfo(Objects.requireNonNull(call.argument("groupInfo")));
        ArrayList<String> userIDs = call.argument("userIDs");
        ZIMGroupAdvancedConfig config = ZIMPluginConverter.oZIMGroupAdvancedConfig(Objects.requireNonNull(call.argument("config")));
        zim.createGroup(groupInfo, userIDs, config, new ZIMGroupCreatedCallback() {
            @Override
            public void onGroupCreated(ZIMGroupFullInfo groupInfo, ArrayList<ZIMGroupMemberInfo> userList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {

                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> groupInfoMap = ZIMPluginConverter.mZIMGroupFullInfo(groupInfo);
                    ArrayList<HashMap<String,Object>> basicUserList = ZIMPluginConverter.mZIMGroupMemberInfoList(userList);
                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);
                    resultMap.put("groupInfo",groupInfoMap);
                    resultMap.put("userList",basicUserList);
                    resultMap.put("errorUserList",basicErrorUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void dismissGroup(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        zim.dismissGroup(groupID, new ZIMGroupDismissedCallback() {
            @Override
            public void onGroupDismissed(String groupID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void joinGroup(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        zim.joinGroup(groupID, new ZIMGroupJoinedCallback() {
            @Override
            public void onGroupJoined(ZIMGroupFullInfo groupInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> groupInfoMap = ZIMPluginConverter.mZIMGroupFullInfo(groupInfo);
                    resultMap.put("groupInfo",groupInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void leaveGroup(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        zim.leaveGroup(groupID, new ZIMGroupLeftCallback() {
            @Override
            public void onGroupLeft(String groupID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void inviteUsersIntoGroup(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");
        String groupID = call.argument("groupID");
        zim.inviteUsersIntoGroup(userIDs, groupID, new ZIMGroupUsersInvitedCallback() {
            @Override
            public void onGroupUsersInvited(String groupID, ArrayList<ZIMGroupMemberInfo> userList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    ArrayList<HashMap<String,Object>> basicUserList = ZIMPluginConverter.mZIMGroupMemberInfoList(userList);
                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);
                    resultMap.put("groupID",groupID);
                    resultMap.put("userList",basicUserList);
                    resultMap.put("errorUserList",basicErrorUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void kickGroupMembers(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");
        String groupID = call.argument("groupID");

        zim.kickGroupMembers(userIDs, groupID, new ZIMGroupMemberKickedCallback() {
            @Override
            public void onGroupMemberKicked(String groupID, ArrayList<String> kickedUserIDList, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);
                    resultMap.put("groupID",groupID);
                    resultMap.put("kickedUserIDList",kickedUserIDList);
                    resultMap.put("errorUserList",basicErrorUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void transferGroupOwner(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String toUserID = call.argument("toUserID");
        String groupID = call.argument("groupID");

        zim.transferGroupOwner(toUserID, groupID, new ZIMGroupOwnerTransferredCallback() {
            @Override
            public void onGroupOwnerTransferred(String groupID, String toUserID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupID",groupID);
                    resultMap.put("toUserID",toUserID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateGroupName (MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupName = call.argument("groupName");
        String groupID = call.argument("groupID");

        zim.updateGroupName(groupName, groupID, new ZIMGroupNameUpdatedCallback() {
            @Override
            public void onGroupNameUpdated(String groupID, String groupName, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupID",groupID);
                    resultMap.put("groupName",groupName);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateGroupAvatarUrl(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupAvatarUrl = call.argument("groupAvatarUrl");
        String groupID = call.argument("groupID");
        zim.updateGroupAvatarUrl(groupAvatarUrl, groupID, new ZIMGroupAvatarUrlUpdatedCallback() {
            @Override
            public void onGroupAvatarUrlUpdated(String groupID, String groupAvatarUrl, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupID",groupID);
                    resultMap.put("groupAvatarUrl",groupAvatarUrl);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void updateGroupNotice(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupNotice = call.argument("groupNotice");
        String groupID = call.argument("groupID");

        zim.updateGroupNotice(groupNotice, groupID, new ZIMGroupNoticeUpdatedCallback() {
            @Override
            public void onGroupNoticeUpdated(String groupID, String groupNotice, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupID",groupID);
                    resultMap.put("groupNotice",groupNotice);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void muteGroup(MethodCall call,Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        
        boolean isMute  = call.argument("isMute");
        String groupID = call.argument("groupID");
        ZIMGroupMuteConfig config = ZIMPluginConverter.oZIMGroupMuteConfig(Objects.requireNonNull(call.argument("config")));

        zim.muteGroup(isMute, groupID, config, new ZIMGroupMutedCallback() {
            @Override
            public void onGroupMuted(String groupID, boolean isMute, ZIMGroupMuteInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> groupMuteInfoMap = ZIMPluginConverter.mZIMGroupMuteInfo(info);
                    resultMap.put("isMute", isMute);
                    resultMap.put("groupID", groupID);
                    resultMap.put("info", groupMuteInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void muteGroupMembers(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        
        boolean isMute  = call.argument("isMute");
        String groupID = call.argument("groupID");
        ArrayList<String> userIDs = call.argument("userIDs");
        ZIMGroupMemberMuteConfig config = ZIMPluginConverter.oZIMGroupMemberMuteConfig(Objects.requireNonNull(call.argument("config")));

        zim.muteGroupMembers(isMute, userIDs, groupID, config, new ZIMGroupMembersMutedCallback() {
            @Override
            public void onGroupMembersMuted(String groupID, boolean isMute, int duration,
                                            ArrayList<String> mutedMemberIDs,
                                            ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    
                    ArrayList<HashMap<String,Object>> basicErrorUserList = ZIMPluginConverter.mZIMErrorUserInfoList(errorUserList);

                    resultMap.put("groupID", groupID);
                    resultMap.put("isMute", isMute);
                    resultMap.put("duration", duration);
                    resultMap.put("mutedMemberIDs",mutedMemberIDs);
                    resultMap.put("errorUserList",basicErrorUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMemberMutedList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        ZIMGroupMemberMutedListQueryConfig config = ZIMPluginConverter.oZIMGroupMemberMutedListQueryConfig(Objects.requireNonNull(call.argument("config")));
        zim.queryGroupMemberMutedList(groupID, config, new ZIMGroupMemberMutedListQueriedCallback() {
            @Override
            public void onGroupMemberListQueried(String groupID, long nextFlag,
                                                 ArrayList<ZIMGroupMemberInfo> userList,
                                                 ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> basicUserList = ZIMPluginConverter.mZIMGroupMemberInfoList(userList);
                    resultMap.put("groupID",groupID);
                    resultMap.put("nextFlag",nextFlag);
                    resultMap.put("userList",basicUserList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupInfo(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");

        zim.queryGroupInfo(groupID, new ZIMGroupInfoQueriedCallback() {
            @Override
            public void onGroupInfoQueried(ZIMGroupFullInfo groupInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> groupInfoMap = ZIMPluginConverter.mZIMGroupFullInfo(groupInfo);
                    resultMap.put("groupInfo",groupInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setGroupAttributes(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        HashMap<String ,String> groupAttributes = call.argument("groupAttributes");

        zim.setGroupAttributes(groupAttributes, groupID, new ZIMGroupAttributesOperatedCallback() {
            @Override
            public void onGroupAttributesOperated(String groupID, ArrayList<String> errorKeys, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("errorKeys",errorKeys);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void deleteGroupAttributes(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> keys = call.argument("keys");
        String groupID = call.argument("groupID");

        zim.deleteGroupAttributes(keys, groupID, new ZIMGroupAttributesOperatedCallback() {
            @Override
            public void onGroupAttributesOperated(String groupID, ArrayList<String> errorKeys, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("errorKeys",errorKeys);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupAttributes(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> keys = call.argument("keys");
        String groupID = call.argument("groupID");

        zim.queryGroupAttributes(keys, groupID, new ZIMGroupAttributesQueriedCallback() {
            @Override
            public void onGroupAttributesQueried(String groupID, HashMap<String, String> groupAttributes, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("groupAttributes",groupAttributes);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupAllAttributes(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");

        zim.queryGroupAllAttributes(groupID, new ZIMGroupAttributesQueriedCallback() {
            @Override
            public void onGroupAttributesQueried(String groupID, HashMap<String, String> groupAttributes, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("groupAttributes",groupAttributes);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setGroupMemberRole(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        int role = ZIMPluginCommonTools.safeGetIntValue(call.argument("role"));
        String forUserID = call.argument("forUserID");
        String groupID = call.argument("groupID");

        zim.setGroupMemberRole(role, forUserID, groupID, new ZIMGroupMemberRoleUpdatedCallback() {
            @Override
            public void onGroupMemberRoleUpdated(String groupID, String forUserID, int role, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("forUserID",forUserID);
                    resultMap.put("role",role);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void setGroupMemberNickname(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String nickname = call.argument("nickname");
        String forUserID = call.argument("forUserID");
        String groupID = call.argument("groupID");

        zim.setGroupMemberNickname(nickname, forUserID, groupID, new ZIMGroupMemberNicknameUpdatedCallback() {
            @Override
            public void onGroupMemberNicknameUpdated(String groupID, String forUserID, String nickname, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("forUserID",forUserID);
                    resultMap.put("nickname",nickname);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMemberInfo(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userID = call.argument("userID");
        String groupID = call.argument("groupID");

        zim.queryGroupMemberInfo(userID, groupID, new ZIMGroupMemberInfoQueriedCallback() {
            @Override
            public void onGroupMemberInfoQueried(String groupID, ZIMGroupMemberInfo userInfo, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    HashMap<String,Object> userInfoMap = ZIMPluginConverter.mZIMGroupMemberInfo(userInfo);
                    resultMap.put("groupID",groupID);
                    resultMap.put("userInfo",userInfoMap);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupList(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        zim.queryGroupList(new ZIMGroupListQueriedCallback() {
            @Override
            public void onGroupListQueried(ArrayList<ZIMGroup> groupList, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> basicGroupList = ZIMPluginConverter.mZIMGroupList(groupList);
                    resultMap.put("groupList",basicGroupList);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMemberList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        ZIMGroupMemberQueryConfig config = ZIMPluginConverter.oZIMGroupMemberQueryConfig(Objects.requireNonNull(call.argument("config")));
        zim.queryGroupMemberList(groupID, config, new ZIMGroupMemberListQueriedCallback() {
            @Override
            public void onGroupMemberListQueried(String groupID, ArrayList<ZIMGroupMemberInfo> userList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String,Object>> basicUserList = ZIMPluginConverter.mZIMGroupMemberInfoList(userList);
                    resultMap.put("groupID",groupID);
                    resultMap.put("userList",basicUserList);
                    resultMap.put("nextFlag",nextFlag);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void queryGroupMemberCount(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        zim.queryGroupMemberCount(groupID, new ZIMGroupMemberCountQueriedCallback() {
            @Override
            public void onGroupMemberCountQueried(String groupID, int count, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("groupID",groupID);
                    resultMap.put("count",count);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void searchLocalGroups(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMGroupSearchConfig config = ZIMPluginConverter.oZIMGroupSearchConfig(Objects.requireNonNull(call.argument("config")));
        zim.searchLocalGroups(config, new ZIMGroupsSearchedCallback() {
            @Override
            public void onGroupsSearched(ArrayList<ZIMGroupSearchInfo> groupSearchInfoList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupSearchInfoList", ZIMPluginConverter.mZIMGroupSearchInfoList(groupSearchInfoList));
                    resultMap.put("nextFlag", nextFlag);
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void searchLocalGroupMembers(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String groupID = call.argument("groupID");
        ZIMGroupMemberSearchConfig config = ZIMPluginConverter.oZIMGroupMemberSearchConfig(Objects.requireNonNull(call.argument("config")));
        zim.searchLocalGroupMembers(groupID, config, new ZIMGroupMembersSearchedCallback() {
            @Override
            public void onGroupMembersSearched(String groupID, ArrayList<ZIMGroupMemberInfo> userList, int nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("groupID", groupID);
                    resultMap.put("userList", ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
                    resultMap.put("nextFlag", nextFlag);
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callInvite(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> invitees = call.argument("invitees");
        ZIMCallInviteConfig config = ZIMPluginConverter.oZIMCallInviteConfig(Objects.requireNonNull(call.argument("config")));

        zim.callInvite(invitees, config, new ZIMCallInvitationSentCallback() {
            @Override
            public void onCallInvitationSent(String callID, ZIMCallInvitationSentInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("info",ZIMPluginConverter.mZIMCallInvitationSentInfo(info));
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callingInvite(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> invitees = call.argument("invitees");
        ZIMCallingInviteConfig config = ZIMPluginConverter.oZIMCallingInviteConfig(Objects.requireNonNull(call.argument("config")));
        String callID = call.argument("callID");

        zim.callingInvite(invitees, callID, config, new ZIMCallingInvitationSentCallback() {
            @Override
            public void onCallingInvitationSent(String callID, ZIMCallingInvitationSentInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("info",ZIMPluginConverter.mZIMCallingInvitationSentInfo(info));
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callJoin(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String callID = call.argument("callID");
        ZIMCallJoinConfig joinConfig = ZIMPluginConverter.oZIMCallJoinConfig(call.argument("config"));
        zim.callJoin(callID, joinConfig, new ZIMCallJoinSentCallback() {
            @Override
            public void onCallJoinSent(String callID, ZIMCallJoinSentInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("info",ZIMPluginConverter.mZIMCallJoinSentInfo(info));
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callQuit(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String callID = call.argument("callID");
        ZIMCallQuitConfig config = ZIMPluginConverter.oZIMCallQuitConfig(Objects.requireNonNull(call.argument("config")));
        zim.callQuit(callID, config, new ZIMCallQuitSentCallback() {
            @Override
            public void onCallQuitSent(String callID, ZIMCallQuitSentInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("info",ZIMPluginConverter.mZIMCallQuitSentInfo(info));
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callEnd(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }


        String callID = call.argument("callID");

        ZIMCallEndConfig config = ZIMPluginConverter.oZIMCallEndConfig(Objects.requireNonNull(call.argument("config")));

        zim.callEnd(callID, config, new ZIMCallEndSentCallback() {
            @Override
            public void onCallEndSent(String callID, ZIMCallEndedSentInfo info, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("info",ZIMPluginConverter.mZIMCallEndSentInfo(info));
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }



    public static void callCancel(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> invitees = call.argument("invitees");
        ZIMCallCancelConfig config = ZIMPluginConverter.oZIMCallCancelConfig(Objects.requireNonNull(call.argument("config")));
        String callID = call.argument("callID");
        zim.callCancel(invitees, callID, config, new ZIMCallCancelSentCallback() {
            @Override
            public void onCallCancelSent(String callID, ArrayList<String> errorInvitees, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    resultMap.put("errorInvitees",errorInvitees);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callAccept(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String callID = call.argument("callID");
        ZIMCallAcceptConfig config = ZIMPluginConverter.oZIMCallAcceptConfig(Objects.requireNonNull(call.argument("config")));

        zim.callAccept(callID, config, new ZIMCallAcceptanceSentCallback() {
            @Override
            public void onCallAcceptanceSent(String callID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    public static void callReject(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String callID = call.argument("callID");
        ZIMCallRejectConfig config = ZIMPluginConverter.oZIMCallRejectConfig(Objects.requireNonNull(call.argument("config")));
        zim.callReject(callID, config, new ZIMCallRejectionSentCallback() {
            @Override
            public void onCallRejectionSent(String callID, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    resultMap.put("callID",callID);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }
    public static void addMessageReaction(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String reactionType = Objects.requireNonNull(call.argument("reactionType"));
        zim.addMessageReaction(reactionType, message, new ZIMMessageReactionAddedCallback() {
            @Override
            public void onMessageReactionAdded(ZIMMessageReaction reaction, ZIMError error) {
                if (error.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("reaction",ZIMPluginConverter.mZIMMessageReaction(reaction));
                    result.success(resultMap);
                }else {
                    result.error(String.valueOf(error.code.value()),error.message,null);
                }
            }
        });
    }
    public static void deleteMessageReaction(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        String reactionType = Objects.requireNonNull(call.argument("reactionType"));
        zim.deleteMessageReaction(reactionType, message, new ZIMMessageReactionDeletedCallback() {
            @Override
            public void onMessageReactionDeleted(ZIMMessageReaction reaction, ZIMError error) {
                if (error.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("reaction",ZIMPluginConverter.mZIMMessageReaction(reaction));
                    result.success(resultMap);
                }else {
                    result.error(String.valueOf(error.code.value()),error.message,null);
                }
            }
        });
    }
    public static void queryMessageReactionUserList(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMMessage message = (ZIMMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));
        ZIMMessageReactionUserQueryConfig config = ZIMPluginConverter.oZIMMessageReactionUsersQueryConfig(Objects.requireNonNull(call.argument("config")));

        zim.queryMessageReactionUserList(message, config, new ZIMMessageReactionUserListQueriedCallback() {
            @Override
            public void onMessageReactionUserListQueried(ZIMMessage message, ArrayList<ZIMMessageReactionUserInfo> userList, String reactionType, long nextFlag, int totalCount, ZIMError error) {
                if (error.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("message",ZIMPluginConverter.mZIMMessage(message));
                    resultMap.put("userList",ZIMPluginConverter.mZIMMessageReactionUserInfoList(userList));
                    resultMap.put("reactionType",reactionType);
                    resultMap.put("nextFlag",nextFlag);
                    resultMap.put("totalCount",totalCount);
                    result.success(resultMap);
                }else {
                    result.error(String.valueOf(error.code.value()),error.message,null);
                }
            }
        });
    }



    public static void queryCallList(MethodCall call,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ZIMCallInvitationQueryConfig config = ZIMPluginConverter.oZIMQueryCallListConfig(Objects.requireNonNull(call.argument("config")));
        zim.queryCallInvitationList(config, new ZIMCallInvitationListQueriedCallback() {
            @Override
            public void onCallInvitationListQueried(ArrayList<ZIMCallInfo> callList, long nextFlag, ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("callList",ZIMPluginConverter.mZIMCallInfoList(callList));
                    resultMap.put("nextFlag",nextFlag);
                    result.success(resultMap);
                }
                else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    // addFriend
    public static void addFriend(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userID = call.argument("userID");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendAddConfig config = ZIMPluginConverter.oZIMFriendAddConfig(configMap);

        LogWriter.writeLog("Flutter Android invoke add Friend. attributes:"+config.friendAttributes.toString());
        zim.addFriend(userID, config, new ZIMFriendAddedCallback() {
            @Override
            public void onFriendAddedCallback(ZIMFriendInfo friendInfo, ZIMError zimError) {
                LogWriter.writeLog("Flutter Android add Friend Callback receive.friendInfo attributes:"+friendInfo.friendAttributes.toString());
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("friendInfo", ZIMPluginConverter.mZIMFriendInfo(friendInfo)); // Assuming mZIMFriendInfo exists
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // sendFriendApplication
    public static void sendFriendApplication(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userID = call.argument("userID");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendApplicationSendConfig config = ZIMPluginConverter.oZIMFriendApplicationSendConfig(configMap);
        LogWriter.writeLog("Flutter Native Android invoke sendFriendApplication,attributes:"+config.friendAttributes.toString());
        zim.sendFriendApplication(userID, config, new ZIMFriendApplicationSentCallback() {
            @Override
            public void onFriendApplicationSentCallback(ZIMFriendApplicationInfo applicationInfo, ZIMError errorInfo) {
                if (errorInfo.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("applicationInfo", ZIMPluginConverter.mZIMFriendApplicationInfo(applicationInfo)); // Assuming mZIMFriendApplicationInfo exists
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(errorInfo.code.value()), errorInfo.message, null);
                }
            }
        });

    }

    // deleteFriend
    public static void deleteFriends(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendDeleteConfig config = ZIMPluginConverter.oZIMFriendDeleteConfig(configMap);

        zim.deleteFriends(userIDs, config, new ZIMFriendsDeletedCallback() {
            @Override
            public void onFriendsDeletedCallback(ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    ArrayList<HashMap<String, Object>> errorUsersMapList = new ArrayList<>();
                    for (ZIMErrorUserInfo userInfo : errorUserList) {
                        HashMap<String, Object> userInfoMap = ZIMPluginConverter.mZIMErrorUserInfo(userInfo); // 假设存在 mZIMErrorUserInfo 转换函数
                        errorUsersMapList.add(userInfoMap);
                    }
                    resultMap.put("errorUserList", errorUsersMapList);
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // checkFriendRelation
    public static void checkFriendsRelation(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendRelationCheckConfig config = ZIMPluginConverter.oZIMFriendRelationCheckConfig(configMap);

        zim.checkFriendsRelation(userIDs, config, new ZIMFriendsRelationCheckedCallback() {
            @Override
            public void onFriendsChecked(ArrayList<ZIMFriendRelationInfo> relationInfos, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换关系信息列表
                    ArrayList<HashMap<String, Object>> relationInfoMapList = new ArrayList<>();
                    for (ZIMFriendRelationInfo info : relationInfos) {
                        HashMap<String, Object> infoMap = ZIMPluginConverter.mZIMFriendRelationInfo(info); // 假设存在 mZIMFriendRelationInfo 转换函数
                        relationInfoMapList.add(infoMap);
                    }
                    resultMap.put("relationInfos", relationInfoMapList);

                    // 转换错误用户信息
                    ArrayList<HashMap<String, Object>> errorUsersMapList = new ArrayList<>();
                    for (ZIMErrorUserInfo errorInfo : errorUserList) {
                        HashMap<String, Object> errorInfoMap = ZIMPluginConverter.mZIMErrorUserInfo(errorInfo); // 假设存在 mZIMErrorUserInfo 转换函数
                        errorUsersMapList.add(errorInfoMap);
                    }
                    resultMap.put("errorUserList", errorUsersMapList);

                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // updateFriendAlias
    public static void updateFriendAlias(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String friendAlias = call.argument("friendAlias");
        String userID = call.argument("userID");

        zim.updateFriendAlias(friendAlias, userID, new ZIMFriendAliasUpdatedCallback() {
            @Override
            public void onFriendAliasUpdated(ZIMFriendInfo friendInfo, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("friendInfo", ZIMPluginConverter.mZIMFriendInfo(friendInfo)); // 假设存在 mZIMFriendInfo 转换函数
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // updateFriendAttributes
    public static void updateFriendAttributes(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String, String> friendAttributes = call.argument("friendAttributes");
        String userID = call.argument("userID");

        zim.updateFriendAttributes(friendAttributes, userID, new ZIMFriendAttributesUpdatedCallback() {
            @Override
            public void onFriendAttributesUpdated(ZIMFriendInfo friendInfo, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("friendInfo", ZIMPluginConverter.mZIMFriendInfo(friendInfo)); // 假设存在 mZIMFriendInfo 转换函数
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // queryFriendsInfo
    public static void queryFriendsInfo(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");

        zim.queryFriendsInfo(userIDs, new ZIMFriendsInfoQueriedCallback() {
            @Override
            public void onFriendsInfoQueried(ArrayList<ZIMFriendInfo> friendInfos, ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换朋友信息列表
                    ArrayList<HashMap<String, Object>> friendInfoMapList = new ArrayList<>();
                    for (ZIMFriendInfo friendInfo : friendInfos) {
                        HashMap<String, Object> friendInfoMap = ZIMPluginConverter.mZIMFriendInfo(friendInfo); // 假设存在 mZIMFriendInfo 转换函数
                        friendInfoMapList.add(friendInfoMap);
                    }
                    LogWriter.writeLog("flutter native android onFriendsInfoQueried,friendsInfos size:"+friendInfos.size()+"friendsMapList size:"+friendInfoMapList.size());
                    resultMap.put("friendInfos", friendInfoMapList);

                    // 转换错误用户信息
                    ArrayList<HashMap<String, Object>> errorUsersMapList = new ArrayList<>();
                    for (ZIMErrorUserInfo errorInfo : errorUserList) {
                        HashMap<String, Object> errorInfoMap = ZIMPluginConverter.mZIMErrorUserInfo(errorInfo); // 假设存在 mZIMErrorUserInfo 转换函数
                        errorUsersMapList.add(errorInfoMap);
                    }
                    resultMap.put("errorUserList", errorUsersMapList);

                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // acceptFriendApplication
    public static void acceptFriendApplication(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userID = call.argument("userID");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendApplicationAcceptConfig config = ZIMPluginConverter.oZIMFriendApplicationAcceptConfig(configMap);
        LogWriter.writeLog("flutter native android acceptFriendApplication,attributes:"+config.friendAttributes.toString()+"alias:"+config.friendAlias);
        zim.acceptFriendApplication(userID, config, new ZIMFriendApplicationAcceptedCallback() {
            @Override
            public void onFriendApplicationAccepted(ZIMFriendInfo friendInfo, ZIMError errorInfo) {
                LogWriter.writeLog("flutter native android onFriendApplicationAccepted,attributes:"+friendInfo.friendAttributes.toString()+"alias:"+friendInfo.friendAlias);
                if (errorInfo.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("friendInfo", ZIMPluginConverter.mZIMFriendInfo(friendInfo)); // 假设存在 mZIMFriendApplicationInfo 转换函数
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(errorInfo.code.value()), errorInfo.message, null);
                }
            }
        });

    }

    // rejectFriendApplication
    public static void rejectFriendApplication(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String userID = call.argument("userID");
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendApplicationRejectConfig config = ZIMPluginConverter.oZIMFriendApplicationRejectConfig(configMap);

        zim.rejectFriendApplication(userID, config, new ZIMFriendApplicationRejectedCallback() {
            @Override
            public void onFriendApplicationRejected(ZIMUserInfo userInfo, ZIMError zimError) {
                LogWriter.writeLog("Flutter Android Native onFriendApplicationRejected,userInfo:"+userInfo.toString());
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("userInfo", ZIMPluginConverter.mZIMUserInfo(userInfo)); // 假设存在 mZIMUserInfo 转换函数
                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // queryFriendList
    public static void queryFriendList(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendListQueryConfig config = ZIMPluginConverter.oZIMFriendListQueryConfig(configMap);

        zim.queryFriendList(config, new ZIMFriendListQueriedCallback() {
            @Override
            public void onFriendListQueried(ArrayList<ZIMFriendInfo> friendList, int nextFlag, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换朋友信息列表
                    ArrayList<HashMap<String, Object>> friendInfoMapList = new ArrayList<>();
                    for (ZIMFriendInfo friendInfo : friendList) {
                        HashMap<String, Object> friendInfoMap = ZIMPluginConverter.mZIMFriendInfo(friendInfo); // 假设存在 mZIMFriendInfo 转换函数
                        friendInfoMapList.add(friendInfoMap);
                    }
                    resultMap.put("friendList", friendInfoMapList);
                    resultMap.put("nextFlag", nextFlag);

                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    // queryFriendApplicationList
    public static void queryFriendApplicationList(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendApplicationListQueryConfig config = ZIMPluginConverter.oZIMFriendApplicationListQueryConfig(configMap);

        zim.queryFriendApplicationList(config, new ZIMFriendApplicationListQueriedCallback() {
            @Override
            public void onFriendApplicationListQueried(ArrayList<ZIMFriendApplicationInfo> applicationList, int nextFlag, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换申请信息列表
                    ArrayList<HashMap<String, Object>> applicationInfoMapList = new ArrayList<>();
                    for (ZIMFriendApplicationInfo applicationInfo : applicationList) {
                        HashMap<String, Object> applicationInfoMap = ZIMPluginConverter.mZIMFriendApplicationInfo(applicationInfo); // 假设存在 mZIMFriendApplicationInfo 转换函数
                        applicationInfoMapList.add(applicationInfoMap);
                    }
                    resultMap.put("applicationList", applicationInfoMapList);
                    resultMap.put("nextFlag", nextFlag);

                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    public static void searchLocalFriends(MethodCall call,Result result){

        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
       
        HashMap<String, Object> configMap = call.argument("config");
        ZIMFriendSearchConfig config = ZIMPluginConverter.oZIMFriendSearchConfig(configMap);
        zim.searchLocalFriends(config, new ZIMFriendsSearchedCallback() {
            @Override
            public void onFriendsSearched(ArrayList<ZIMFriendInfo> friendInfos, int nextFlag, ZIMError errorInfo){
                if (errorInfo.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();

                    ArrayList<HashMap<String, Object>> friendInfosMapList = new ArrayList<>();
                    for (ZIMFriendInfo friendInfo : friendInfos) {
                        HashMap<String, Object> friendHashMap = ZIMPluginConverter.mZIMFriendInfo(friendInfo);
                        friendInfosMapList.add(friendHashMap);
                    }
                    resultMap.put("friendInfos", friendInfosMapList);
                    result.success(resultMap);
                }else {
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }
        });
    }

    // addUsersToBlacklist
    public static void addUsersToBlacklist(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");

        zim.addUsersToBlacklist(userIDs, new ZIMBlacklistUsersAddedCallback() {
            @Override
            public void onBlacklistUsersAdded(ArrayList<ZIMErrorUserInfo> errorUserList, ZIMError error) {
                if (error.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换错误用户信息
                    ArrayList<HashMap<String, Object>> errorUsersMapList = new ArrayList<>();
                    for (ZIMErrorUserInfo errorUserInfo : errorUserList) {
                        HashMap<String, Object> errorUserInfoMap = ZIMPluginConverter.mZIMErrorUserInfo(errorUserInfo); // 假设存在 mZIMErrorUserInfo 转换函数
                        errorUsersMapList.add(errorUserInfoMap);
                    }
                    resultMap.put("errorUserList", errorUsersMapList);

                    result.success(resultMap);
                } else {
                    result.error(String.valueOf(error.code.value()), error.message, null);
                }
            }
        });

    }

    public static void removeUsersFromBlacklist(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if (zim == null) {
            result.error("-1", "no native instance", null);
            return;
        }

        ArrayList<String> userIDs = call.argument("userIDs");

        zim.removeUsersFromBlacklist(userIDs, new ZIMBlacklistUsersRemovedCallback() {
            @Override
            public void onBlacklistUsersRemoved(ArrayList<ZIMErrorUserInfo> errorUserInfoArrayList, ZIMError zimError) {
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    HashMap<String, Object> resultMap = new HashMap<>();

                    // 转换错误用户信息
                    ArrayList<HashMap<String, Object>> errorUsersMapList = new ArrayList<>();
                    for (ZIMErrorUserInfo errorUserInfo : errorUserInfoArrayList) {
                        HashMap<String, Object> errorUserInfoMap = ZIMPluginConverter.mZIMErrorUserInfo(errorUserInfo); // 假设存在 mZIMErrorUserInfo 转换函数
                        errorUsersMapList.add(errorUserInfoMap);
                    }
                    resultMap.put("errorUserList", errorUsersMapList);

                    result.success(resultMap);
                } else {
                    // 在出现错误的情况下，返回错误信息
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }


    public static void queryBlackList(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if (zim == null) {
            result.error("-1", "no native instance", null);
            return;
        }

        ZIMBlacklistQueryConfig config = ZIMPluginConverter.oZIMBlacklistQueryConfig(Objects.requireNonNull(call.argument("config"))); // 从 call 中提取并转换配置
        zim.queryBlacklist(config, new ZIMBlacklistQueriedCallback() {
            @Override
            public void onBlacklistQueried(ArrayList<ZIMUserInfo> blacklist, int nextFlag, ZIMError zimError) {
                LogWriter.writeLog("Flutter Android onBlacklistQueried,size:%d "+ blacklist.size());
                if (zimError.code == ZIMErrorCode.SUCCESS) {
                    // 在成功的情况下，处理并返回黑名单用户信息列表
                    ArrayList<HashMap<String, Object>> blacklistMapList = new ArrayList<>();
                    for (ZIMUserInfo userInfo : blacklist) {
                        HashMap<String, Object> userInfoMap = ZIMPluginConverter.mZIMUserInfo(userInfo); // 假设存在 mZIMUserInfo 转换函数
                        blacklistMapList.add(userInfoMap);
                    }
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("blacklist", blacklistMapList);
                    resultMap.put("nextFlag", nextFlag);

                    result.success(resultMap);
                } else {
                    // 在出现错误的情况下，返回错误信息
                    result.error(String.valueOf(zimError.code.value()), zimError.message, null);
                }
            }
        });

    }

    public static void checkUserIsInBlackList(MethodCall call, Result result) {
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        String userID = call.argument("userID");
        zim.checkUserIsInBlacklist(userID, new ZIMBlacklistCheckedCallback() {
            @Override
            public void onBlacklistChecked(boolean isUserInBlacklist, ZIMError errorInfo) {
                if (errorInfo.code == ZIMErrorCode.SUCCESS) {
                    // 在成功的情况下，返回用户是否在黑名单中的信息
                    HashMap<String, Object> resultMap = new HashMap<>();
                    resultMap.put("isUserInBlacklist", isUserInBlacklist);
                    result.success(resultMap);
                } else {
                    // 在出现错误的情况下，返回错误信息
                    result.error(String.valueOf(errorInfo.code.value()), errorInfo.message, null);
                }
            }
        });

    }

    public static void queryCombineMessageDetail(MethodCall call,Result result){

        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }
        ZIMCombineMessage message = (ZIMCombineMessage) ZIMPluginConverter.oZIMMessage(Objects.requireNonNull(call.argument("message")));

        zim.queryCombineMessageDetail(message, new ZIMCombineMessageDetailQueriedCallback() {
            @Override
            public void onCombineMessageDetailQueried(ZIMCombineMessage message, ZIMError error) {
                if (error.code == ZIMErrorCode.SUCCESS){
                    HashMap<String,Object> resultMap = new HashMap<>();
                    resultMap.put("message",ZIMPluginConverter.mZIMMessage(message));
                    result.success(resultMap);
                }else {
                    result.error(String.valueOf(error.code.value()),error.message,null);
                }
            }
        });
    }


    public static void exportLocalMessages(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String folderPath = call.argument("folderPath");
        Integer progressID = call.argument("progressID");
        ZIMMessageExportConfig config = new ZIMMessageExportConfig();

        zim.exportLocalMessages(folderPath, config,new ZIMMessageExportedCallback() {
            @Override
            public void onMessageExported(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }

            @Override
            public void onMessageExportingProgress(long exportedMessageCount, long totalMessageCount) {
                if(ZIMPluginEventHandler.mysink == null) {
                    return;
                }
                HashMap<String,Object> resultMap = new HashMap<>();
                resultMap.put("handle",handle);
                resultMap.put("method","messageExportingProgress");
                resultMap.put("progressID",progressID);
                resultMap.put("exportedMessageCount",exportedMessageCount);
                resultMap.put("totalMessageCount",totalMessageCount);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }
        });
    }

    public static void importLocalMessages(MethodCall call, Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

        String folderPath = call.argument("folderPath");
        Integer progressID = call.argument("progressID");
        ZIMMessageImportConfig config = new ZIMMessageImportConfig();

        zim.importLocalMessages(folderPath, config,new ZIMMessageImportedCallback() {
            @Override
            public void onMessageImported(ZIMError errorInfo) {
                if(errorInfo.code == ZIMErrorCode.SUCCESS){
                    result.success(null);
                }else{
                    result.error(String.valueOf(errorInfo.code.value()),errorInfo.message,null);
                }
            }

            @Override
            public void onMessageImportingProgress(long importedMessageCount, long totalMessageCount) {
                if(ZIMPluginEventHandler.mysink == null) {
                    return;
                }
                HashMap<String,Object> resultMap = new HashMap<>();
                resultMap.put("handle",handle);
                resultMap.put("method","messageImportingProgress");
                resultMap.put("progressID",progressID);
                resultMap.put("importedMessageCount",importedMessageCount);
                resultMap.put("totalMessageCount",totalMessageCount);
                ZIMPluginEventHandler.mysink.success(resultMap);
            }
        });
    }


}
