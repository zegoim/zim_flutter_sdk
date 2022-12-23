package im.zego.zim_flutter.internal;

import android.app.Application;

import java.lang.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import im.zego.zim.ZIM;
import im.zego.zim.callback.ZIMCallAcceptanceSentCallback;
import im.zego.zim.callback.ZIMCallCancelSentCallback;
import im.zego.zim.callback.ZIMCallInvitationSentCallback;
import im.zego.zim.callback.ZIMCallRejectionSentCallback;
import im.zego.zim.callback.ZIMConversationDeletedCallback;
import im.zego.zim.callback.ZIMConversationListQueriedCallback;
import im.zego.zim.callback.ZIMConversationMessageReceiptReadSentCallback;
import im.zego.zim.callback.ZIMConversationNotificationStatusSetCallback;
import im.zego.zim.callback.ZIMConversationUnreadMessageCountClearedCallback;
import im.zego.zim.callback.ZIMGroupAttributesOperatedCallback;
import im.zego.zim.callback.ZIMGroupAttributesQueriedCallback;
import im.zego.zim.callback.ZIMGroupAvatarUrlUpdatedCallback;
import im.zego.zim.callback.ZIMGroupCreatedCallback;
import im.zego.zim.callback.ZIMGroupDismissedCallback;
import im.zego.zim.callback.ZIMGroupInfoQueriedCallback;
import im.zego.zim.callback.ZIMGroupJoinedCallback;
import im.zego.zim.callback.ZIMGroupLeftCallback;
import im.zego.zim.callback.ZIMGroupListQueriedCallback;
import im.zego.zim.callback.ZIMGroupMemberCountQueriedCallback;
import im.zego.zim.callback.ZIMGroupMemberInfoQueriedCallback;
import im.zego.zim.callback.ZIMGroupMemberKickedCallback;
import im.zego.zim.callback.ZIMGroupMemberListQueriedCallback;
import im.zego.zim.callback.ZIMGroupMemberNicknameUpdatedCallback;
import im.zego.zim.callback.ZIMGroupMemberRoleUpdatedCallback;
import im.zego.zim.callback.ZIMGroupMessageReceiptMemberListQueriedCallback;
import im.zego.zim.callback.ZIMGroupNameUpdatedCallback;
import im.zego.zim.callback.ZIMGroupNoticeUpdatedCallback;
import im.zego.zim.callback.ZIMGroupOwnerTransferredCallback;
import im.zego.zim.callback.ZIMGroupUsersInvitedCallback;
import im.zego.zim.callback.ZIMLogUploadedCallback;
import im.zego.zim.callback.ZIMLoggedInCallback;
import im.zego.zim.callback.ZIMMediaDownloadedCallback;
import im.zego.zim.callback.ZIMMediaMessageSentCallback;
import im.zego.zim.callback.ZIMMessageDeletedCallback;
import im.zego.zim.callback.ZIMMessageInsertedCallback;
import im.zego.zim.callback.ZIMMessageQueriedCallback;
import im.zego.zim.callback.ZIMMessageReceiptsInfoQueriedCallback;
import im.zego.zim.callback.ZIMMessageReceiptsReadSentCallback;
import im.zego.zim.callback.ZIMMessageRevokedCallback;
import im.zego.zim.callback.ZIMMessageSentCallback;
import im.zego.zim.callback.ZIMRoomAttributesBatchOperatedCallback;
import im.zego.zim.callback.ZIMRoomAttributesOperatedCallback;
import im.zego.zim.callback.ZIMRoomAttributesQueriedCallback;
import im.zego.zim.callback.ZIMRoomCreatedCallback;
import im.zego.zim.callback.ZIMRoomEnteredCallback;
import im.zego.zim.callback.ZIMRoomJoinedCallback;
import im.zego.zim.callback.ZIMRoomLeftCallback;
import im.zego.zim.callback.ZIMRoomMemberAttributesListQueriedCallback;
import im.zego.zim.callback.ZIMRoomMemberQueriedCallback;
import im.zego.zim.callback.ZIMRoomMembersAttributesOperatedCallback;
import im.zego.zim.callback.ZIMRoomMembersAttributesQueriedCallback;
import im.zego.zim.callback.ZIMRoomOnlineMemberCountQueriedCallback;
import im.zego.zim.callback.ZIMTokenRenewedCallback;
import im.zego.zim.callback.ZIMUserAvatarUrlUpdatedCallback;
import im.zego.zim.callback.ZIMUserExtendedDataUpdatedCallback;
import im.zego.zim.callback.ZIMUserNameUpdatedCallback;
import im.zego.zim.callback.ZIMUsersInfoQueriedCallback;
import im.zego.zim.entity.ZIMAppConfig;
import im.zego.zim.entity.ZIMCacheConfig;
import im.zego.zim.entity.ZIMCallAcceptConfig;
import im.zego.zim.entity.ZIMCallCancelConfig;
import im.zego.zim.entity.ZIMCallInvitationSentInfo;
import im.zego.zim.entity.ZIMCallInviteConfig;
import im.zego.zim.entity.ZIMCallRejectConfig;
import im.zego.zim.entity.ZIMConversation;
import im.zego.zim.entity.ZIMConversationDeleteConfig;
import im.zego.zim.entity.ZIMConversationQueryConfig;
import im.zego.zim.entity.ZIMError;
import im.zego.zim.entity.ZIMErrorUserInfo;
import im.zego.zim.entity.ZIMGroup;
import im.zego.zim.entity.ZIMGroupAdvancedConfig;
import im.zego.zim.entity.ZIMGroupFullInfo;
import im.zego.zim.entity.ZIMGroupInfo;
import im.zego.zim.entity.ZIMGroupMemberInfo;
import im.zego.zim.entity.ZIMGroupMemberQueryConfig;
import im.zego.zim.entity.ZIMGroupMessageReceiptMemberQueryConfig;
import im.zego.zim.entity.ZIMLogConfig;
import im.zego.zim.entity.ZIMMediaMessage;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMMessageDeleteConfig;
import im.zego.zim.entity.ZIMMessageQueryConfig;
import im.zego.zim.entity.ZIMMessageReceiptInfo;
import im.zego.zim.entity.ZIMMessageRevokeConfig;
import im.zego.zim.entity.ZIMMessageSendConfig;
import im.zego.zim.entity.ZIMRoomAdvancedConfig;
import im.zego.zim.entity.ZIMRoomAttributesBatchOperationConfig;
import im.zego.zim.entity.ZIMRoomAttributesDeleteConfig;
import im.zego.zim.entity.ZIMRoomAttributesSetConfig;
import im.zego.zim.entity.ZIMRoomFullInfo;
import im.zego.zim.entity.ZIMRoomInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesOperatedInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesQueryConfig;
import im.zego.zim.entity.ZIMRoomMemberAttributesSetConfig;
import im.zego.zim.entity.ZIMRoomMemberQueryConfig;
import im.zego.zim.entity.ZIMUserFullInfo;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.entity.ZIMUsersInfoQueryConfig;
import im.zego.zim.enums.ZIMConversationNotificationStatus;
import im.zego.zim.enums.ZIMConversationType;
import im.zego.zim.enums.ZIMErrorCode;
import im.zego.zim.enums.ZIMMediaFileType;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
@SuppressWarnings({"unused","deprecation"})

public class ZIMPluginMethodHandler {
    private static final HashMap<String, ZIM> engineMap = new HashMap<>();
    public static void getVersion(MethodCall call,Result result){
        result.success(ZIM.getVersion());
    }

    public static void create(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding,ZIMPluginEventHandler eventHandler){

        ZIM oldZIM = ZIM.getInstance();
        if(oldZIM != null) {
            oldZIM.destroy();
        }

        String handle = call.argument("handle");
        Application application = (Application) binding.getApplicationContext();
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

    public static void login(MethodCall call ,Result result){
        String handle = call.argument("handle");
        ZIM zim = engineMap.get(handle);
        if(zim == null) {
            result.error("-1", "no native instance",null);
            return;
        }

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
}
