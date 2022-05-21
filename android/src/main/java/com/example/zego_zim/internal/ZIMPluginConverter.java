package com.example.zego_zim.internal;


import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import im.zego.zim.entity.ZIMAudioMessage;
import im.zego.zim.entity.ZIMBarrageMessage;
import im.zego.zim.entity.ZIMCallAcceptConfig;
import im.zego.zim.entity.ZIMCallCancelConfig;
import im.zego.zim.entity.ZIMCallInvitationAcceptedInfo;
import im.zego.zim.entity.ZIMCallInvitationCancelledInfo;
import im.zego.zim.entity.ZIMCallInvitationReceivedInfo;
import im.zego.zim.entity.ZIMCallInvitationRejectedInfo;
import im.zego.zim.entity.ZIMCallInvitationSentInfo;
import im.zego.zim.entity.ZIMCallInviteConfig;
import im.zego.zim.entity.ZIMCallRejectConfig;
import im.zego.zim.entity.ZIMCallUserInfo;
import im.zego.zim.entity.ZIMCommandMessage;
import im.zego.zim.entity.ZIMConversation;
import im.zego.zim.entity.ZIMConversationChangeInfo;
import im.zego.zim.entity.ZIMConversationDeleteConfig;
import im.zego.zim.entity.ZIMConversationQueryConfig;
import im.zego.zim.entity.ZIMErrorUserInfo;
import im.zego.zim.entity.ZIMFileMessage;
import im.zego.zim.entity.ZIMGroup;
import im.zego.zim.entity.ZIMGroupAdvancedConfig;
import im.zego.zim.entity.ZIMGroupAttributesUpdateInfo;
import im.zego.zim.entity.ZIMGroupFullInfo;
import im.zego.zim.entity.ZIMGroupInfo;
import im.zego.zim.entity.ZIMGroupMemberInfo;
import im.zego.zim.entity.ZIMGroupMemberQueryConfig;
import im.zego.zim.entity.ZIMGroupOperatedInfo;
import im.zego.zim.entity.ZIMImageMessage;
import im.zego.zim.entity.ZIMMediaMessage;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMMessageDeleteConfig;
import im.zego.zim.entity.ZIMMessageQueryConfig;
import im.zego.zim.entity.ZIMMessageSendConfig;
import im.zego.zim.entity.ZIMPushConfig;
import im.zego.zim.entity.ZIMRoomAdvancedConfig;
import im.zego.zim.entity.ZIMRoomAttributesBatchOperationConfig;
import im.zego.zim.entity.ZIMRoomAttributesDeleteConfig;
import im.zego.zim.entity.ZIMRoomAttributesSetConfig;
import im.zego.zim.entity.ZIMRoomAttributesUpdateInfo;
import im.zego.zim.entity.ZIMRoomFullInfo;
import im.zego.zim.entity.ZIMRoomInfo;
import im.zego.zim.entity.ZIMRoomMemberQueryConfig;
import im.zego.zim.entity.ZIMTextMessage;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.entity.ZIMVideoMessage;
import im.zego.zim.enums.ZIMConversationNotificationStatus;
import im.zego.zim.enums.ZIMConversationType;
import im.zego.zim.enums.ZIMMessageDirection;
import im.zego.zim.enums.ZIMMessagePriority;
import im.zego.zim.enums.ZIMMessageSentStatus;
import im.zego.zim.enums.ZIMMessageType;

public class ZIMPluginConverter {

    static public ArrayList<HashMap<String,Object>> cnvZIMConversationChangeInfoListObjectToList(ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        ArrayList<HashMap<String,Object>> conversationChangeInfoBasicList = new ArrayList<>();
        for (ZIMConversationChangeInfo conversationChangeInfo:
             conversationChangeInfoList) {
            conversationChangeInfoBasicList.add(cnvZIMConversationChangeInfoObjectToMap(conversationChangeInfo));
        }
        return conversationChangeInfoBasicList;
    }

    static public HashMap<String,Object> cnvZIMConversationChangeInfoObjectToMap(ZIMConversationChangeInfo conversationChangeInfo){
        HashMap<String,Object> conversationChangeInfoMap = new HashMap<>();
        conversationChangeInfoMap.put("event",conversationChangeInfo.event.value());


        conversationChangeInfoMap.put("conversation",cnvZIMConversationObjectToMap(conversationChangeInfo.conversation));
        return conversationChangeInfoMap;
    }

    static public HashMap<String,Object> cnvZIMConversationObjectToMap(ZIMConversation conversation){
        HashMap<String,Object> conversationMap = new HashMap<>();
        conversationMap.put("conversationID",conversation.conversationID);
        conversationMap.put("conversationName",conversation.conversationName);
        conversationMap.put("type",conversation.type.value());
        conversationMap.put("unreadMessageCount",conversation.unreadMessageCount);
        conversationMap.put("orderKey",conversation.orderKey);
        conversationMap.put("notificationStatus",conversation.notificationStatus.value());
        if(conversation.lastMessage != null){
            conversationMap.put("lastMessage",cnvZIMMessageObjectToMap(conversation.lastMessage));
        }
        else {
            conversationMap.put("lastMessage",null);
        }
        return conversationMap;
    }

//    static public ArrayList cnvZIMConversationListToBasicList(ArrayList<ZIMConversation> conversationList){
//        ArrayList
//    }

    static public HashMap<String,Object> cnvZIMMessageObjectToMap(ZIMMessage message){
        HashMap<String,Object> messageMap = new HashMap<>();
        messageMap.put("type",message.getType().value());
        messageMap.put("messageID",message.getMessageID());
        messageMap.put("conversationID",message.getConversationID());
        messageMap.put("conversationSeq",message.getConversationSeq());
        messageMap.put("senderUserID",message.getSenderUserID());
        messageMap.put("timestamp",message.getTimestamp());
        messageMap.put("localMessageID",message.getLocalMessageID());
        messageMap.put("conversationType",message.getConversationType().value());
        messageMap.put("direction",message.getDirection().value());
        messageMap.put("sentStatus",message.getSentStatus().value());
        messageMap.put("orderKey",message.getOrderKey());
        switch(message.getType()){
            case TEXT:
                messageMap.put("message",((ZIMTextMessage)message).message);
                break;
            case COMMAND:
                messageMap.put("message",((ZIMCommandMessage)message).message);
                break;
            case BARRAGE:

                assert message instanceof ZIMBarrageMessage;
                messageMap.put("message",((ZIMBarrageMessage)message).message);
                break;
            case IMAGE:
                assert message instanceof ZIMImageMessage;

                messageMap.put("thumbnailDownloadUrl",((ZIMImageMessage) message).getThumbnailDownloadUrl() != null?((ZIMImageMessage) message).getThumbnailDownloadUrl(): "");
                messageMap.put("thumbnailLocalPath",((ZIMImageMessage) message).getThumbnailLocalPath() != null ? ((ZIMImageMessage) message).getThumbnailLocalPath() : "");
                messageMap.put("largeImageDownloadUrl",((ZIMImageMessage) message).getLargeImageDownloadUrl() != null ? ((ZIMImageMessage) message).getLargeImageDownloadUrl() : "");
                messageMap.put("largeImageLocalPath",((ZIMImageMessage) message).getLargeImageLocalPath() != null ? ((ZIMImageMessage) message).getLargeImageLocalPath() : "");
                break;
            case VIDEO:
                assert message instanceof ZIMVideoMessage;
                try {
                    Field videoDurationField = ZIMVideoMessage.class.getDeclaredField("videoDuration");
                    videoDurationField.setAccessible(true);
                    messageMap.put("videoDuration",videoDurationField.get(message));
                    videoDurationField.setAccessible(false);
                }
                catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                messageMap.put("videoFirstFrameDownloadUrl",((ZIMVideoMessage) message).getVideoFirstFrameDownloadUrl());
                messageMap.put("videoFirstFrameLocalPath",((ZIMVideoMessage) message).getVideoFirstFrameLocalPath());
                break;
            case AUDIO:
                assert message instanceof ZIMAudioMessage;
                try {
                    Field audioDurationField = ZIMAudioMessage.class.getDeclaredField("audioDuration");
                    audioDurationField.setAccessible(true);
                    messageMap.put("audioDuration",audioDurationField.get(message));
                    audioDurationField.setAccessible(false);
                }
                catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                break;
            case FILE:
                assert message instanceof ZIMFileMessage;
                break;
            case UNKNOWN:
            default:
                break;
        }
        if (message instanceof ZIMMediaMessage) {
            messageMap.put("fileLocalPath",((ZIMMediaMessage) message).getFileLocalPath());
            messageMap.put("fileDownloadUrl",((ZIMMediaMessage) message).getFileDownloadUrl());
            messageMap.put("fileUID",((ZIMMediaMessage) message).getFileUID());
            messageMap.put("fileName",((ZIMMediaMessage) message).getFileName());
            messageMap.put("fileSize",((ZIMMediaMessage) message).getFileSize());
        }
        return messageMap;
    }

    static public ZIMMessage cnvZIMMessageMapToObject(HashMap<String,Object> messageMap){
        if(messageMap == null){
            return null;
        }
        ZIMMessage message;
        ZIMMessageType type = ZIMMessageType.getZIMMessageType(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("type")));
        switch(type){
            case TEXT:
                message = new ZIMTextMessage();
                ((ZIMTextMessage) message).message = (String) messageMap.get("message");
                break;
            case COMMAND:
                message = new ZIMCommandMessage();
                ((ZIMCommandMessage) message).message = (byte[]) messageMap.get("message");
                break;
            case BARRAGE:
                message = new ZIMBarrageMessage();
                ((ZIMBarrageMessage) message).message = (String) messageMap.get("message");
                break;
            case IMAGE:
                message = new ZIMImageMessage((String) messageMap.get("fileLocalPath"));
                ((ZIMImageMessage) message).setThumbnailDownloadUrl((String) messageMap.get("thumbnailDownloadUrl"));
                ((ZIMImageMessage) message).setLargeImageDownloadUrl((String) messageMap.get("largeImageDownloadUrl"));
                try {
                    Field thumbnailLocalPathField = ZIMImageMessage.class.getDeclaredField("thumbnailLocalPath");
                    thumbnailLocalPathField.setAccessible(true);
                    thumbnailLocalPathField.set(message,messageMap.get("thumbnailLocalPath"));
                    thumbnailLocalPathField.setAccessible(false);

                    Field largeImageLocalPathField = ZIMImageMessage.class.getDeclaredField("largeImageLocalPath");
                    largeImageLocalPathField.setAccessible(true);
                    largeImageLocalPathField.set(message,messageMap.get("largeImageLocalPath"));
                    largeImageLocalPathField.setAccessible(false);
                }
                catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                break;
            case FILE:
                message = new ZIMFileMessage((String) messageMap.get("fileLocalPath"));
                break;
            case VIDEO:
                message = new ZIMVideoMessage((String) messageMap.get("fileLocalPath"),ZIMPluginCommonTools.safeGetLongValue(messageMap.get("videoDuration")));
                try{
                    Field videoFirstFrameDownloadUrlField = ZIMVideoMessage.class.getDeclaredField("videoFirstFrameDownloadUrl");
                    videoFirstFrameDownloadUrlField.setAccessible(true);
                    videoFirstFrameDownloadUrlField.set(message,messageMap.get("videoFirstFrameDownloadUrl"));
                    videoFirstFrameDownloadUrlField.setAccessible(false);
                }
                catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                break;
            case AUDIO:
                message = new ZIMAudioMessage((String) messageMap.get("fileLocalPath"),ZIMPluginCommonTools.safeGetLongValue(messageMap.get("audioDuration")));
                break;
            case UNKNOWN:
            default:
                message = new ZIMMessage(ZIMMessageType.UNKNOWN);
                break;
        }
        try {
            Field msgTypeField = ZIMMessage.class.getDeclaredField("type");
            msgTypeField.setAccessible(true);
            msgTypeField.set(message,ZIMMessageType.getZIMMessageType(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("type"))));
            msgTypeField.setAccessible(false);

            Field messageIDField = ZIMMessage.class.getDeclaredField("messageID");
            messageIDField.setAccessible(true);
            messageIDField.set(message,ZIMPluginCommonTools.safeGetLongValue(messageMap.get("messageID")));
            messageIDField.setAccessible(false);

            Field conversationIDField = ZIMMessage.class.getDeclaredField("conversationID");
            conversationIDField.setAccessible(true);
            conversationIDField.set(message,messageMap.get("conversationID"));

            Field conversationSeqField = ZIMMessage.class.getDeclaredField("conversationSeq");
            conversationSeqField.setAccessible(true);
            conversationSeqField.set(message,ZIMPluginCommonTools.safeGetLongValue(messageMap.get("conversationSeq")));
            conversationSeqField.setAccessible(false);

            Field senderUserIDField = ZIMMessage.class.getDeclaredField("senderUserID");
            senderUserIDField.setAccessible(true);
            senderUserIDField.set(message,messageMap.get("senderUserID"));
            senderUserIDField.setAccessible(false);

            Field timestampField = ZIMMessage.class.getDeclaredField("timestamp");
            timestampField.setAccessible(true);
            timestampField.set(message,ZIMPluginCommonTools.safeGetLongValue(messageMap.get("timestamp")));
            timestampField.setAccessible(false);

            Field localMessageIDField = ZIMMessage.class.getDeclaredField("localMessageID");
            localMessageIDField.setAccessible(true);
            localMessageIDField.set(message,ZIMPluginCommonTools.safeGetLongValue(messageMap.get("localMessageID")));
            localMessageIDField.setAccessible(false);

            Field conversationTypeField = ZIMMessage.class.getDeclaredField("conversationType");
            conversationTypeField.setAccessible(true);
            conversationTypeField.set(message,ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("conversationType"))));
            conversationTypeField.setAccessible(false);

            Field directionField = ZIMMessage.class.getDeclaredField("direction");
            directionField.setAccessible(true);
            directionField.set(message,ZIMMessageDirection.getZIMMessageDirection(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("direction"))));
            directionField.setAccessible(false);

            Field sentStatusField = ZIMMessage.class.getDeclaredField("sentStatus");
            sentStatusField.setAccessible(true);
            sentStatusField.set(message,ZIMMessageSentStatus.getZIMMessageSentStatus(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("sentStatus"))));
            sentStatusField.setAccessible(false);

            Field orderKeyField = ZIMMessage.class.getDeclaredField("orderKey");
            orderKeyField.setAccessible(true);
            orderKeyField.set(message,ZIMPluginCommonTools.safeGetLongValue(messageMap.get("orderKey")));
            orderKeyField.setAccessible(false);

        }
        catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        if (message instanceof ZIMMediaMessage) {
            ((ZIMMediaMessage) message).setFileDownloadUrl((String) messageMap.get("fileDownloadUrl"));
            try {
                Field fileUIDField = ZIMMediaMessage.class.getDeclaredField("fileUID");
                fileUIDField.setAccessible(true);
                fileUIDField.set(message,messageMap.get("fileUID"));
                fileUIDField.setAccessible(false);

                Field fileNameField = ZIMMediaMessage.class.getDeclaredField("fileName");
                fileNameField.setAccessible(true);
                fileNameField.set(message,messageMap.get("fileName"));
                fileNameField.setAccessible(false);

                Field fileSizeField = ZIMMediaMessage.class.getDeclaredField("fileSize");
                fileSizeField.setAccessible(true);
                fileSizeField.set(message,ZIMPluginCommonTools.safeGetIntValue(messageMap.get("fileSize")));
                fileSizeField.setAccessible(false);

            }
            catch (NoSuchFieldException e) {
                e.printStackTrace();
            }
            catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        return message;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMMessageListObjectToBasic(ArrayList<ZIMMessage> messageList){
        ArrayList<HashMap<String,Object>> messageBasicList = new ArrayList<>();
        for (ZIMMessage message:messageList
             ) {
            messageBasicList.add(cnvZIMMessageObjectToMap(message));
        }
        return messageBasicList;
    }

    static public ArrayList<ZIMMessage> cnvBasicListToZIMMessageList(ArrayList<HashMap<String,Object>> basicList){
        ArrayList<ZIMMessage> messageList = new ArrayList<>();
        for (HashMap<String,Object> messageHashMap:basicList
             ) {
            messageList.add(cnvZIMMessageMapToObject(messageHashMap));
        }
        return messageList;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMUserInfoListObjectToBasic(ArrayList<ZIMUserInfo> userList){
        ArrayList<HashMap<String,Object>> userInfoBasicList = new ArrayList<>();
        for (ZIMUserInfo userInfo:userList) {
            userInfoBasicList.add(cnvZIMUserInfoObjectToMap(userInfo));
        }
        return userInfoBasicList;
    }

    static public HashMap<String,Object> cnvZIMUserInfoObjectToMap(ZIMUserInfo userInfo){
        HashMap<String,Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID",userInfo.userID);
        userInfoMap.put("userName",userInfo.userName);
        return userInfoMap;
    }

    static public HashMap<String,Object> cnvZIMErrorUserInfoObjectToMap(ZIMErrorUserInfo errorUserInfo){
        HashMap<String,Object> errorUserInfoMap = new HashMap<>();
        errorUserInfoMap.put("userID",errorUserInfo.userID);
        errorUserInfoMap.put("reason",errorUserInfo.reason);
        return errorUserInfoMap;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMErrorUserInfoListObjectToBasic(ArrayList<ZIMErrorUserInfo> errorUserList){
        ArrayList<HashMap<String,Object>> errorUserInfoBasicList = new ArrayList<>();
        for (ZIMErrorUserInfo errorUserInfo:errorUserList) {
            errorUserInfoBasicList.add(cnvZIMErrorUserInfoObjectToMap(errorUserInfo));
        }
        return errorUserInfoBasicList;
    }

    static public ZIMConversationQueryConfig cnvZIMConversationQueryConfigMapToObject(HashMap<String,Object> resultMap){
        ZIMConversationQueryConfig queryConfig = new ZIMConversationQueryConfig();
        queryConfig.count = ZIMPluginCommonTools.safeGetIntValue(resultMap.get("count"));
        queryConfig.nextConversation = cnvZIMConversationMapToObject(ZIMPluginCommonTools.safeGetHashMap(resultMap.get("nextConversation")));

        return queryConfig;
    }

    static public ZIMConversation cnvZIMConversationMapToObject(HashMap<String,Object> resultMap){
        if(resultMap == null) return null;
        ZIMConversation conversation = new ZIMConversation();
        conversation.conversationID = (String) resultMap.get("conversationID");
        conversation.conversationName = (String) resultMap.get("conversationName");
        conversation.type = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(resultMap.get("type")));
        conversation.unreadMessageCount = ZIMPluginCommonTools.safeGetIntValue(resultMap.get("unreadMessageCount"));
        conversation.orderKey = ZIMPluginCommonTools.safeGetLongValue(resultMap.get("orderKey"));
        conversation.notificationStatus = ZIMConversationNotificationStatus.getZIMConversationNotificationStatus(ZIMPluginCommonTools.safeGetIntValue(resultMap.get("notificationStatus")));
        if(resultMap.get("lastMessage") != null) {
            conversation.lastMessage = cnvZIMMessageMapToObject((ZIMPluginCommonTools.safeGetHashMap(resultMap.get("lastMessage"))));
        }else{
            conversation.lastMessage = null;
        }
        return conversation;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMConversationListObjectToBasic(ArrayList<ZIMConversation> conversationList){
        ArrayList<HashMap<String,Object>> conversationBasicList = new ArrayList<>();
        for (ZIMConversation conversation:
             conversationList) {
            conversationBasicList.add(cnvZIMConversationObjectToMap(conversation));
        }
        return conversationBasicList;
    }

    static public ZIMMessageDeleteConfig cnvZIMMessageDeleteConfigBasicToObject(HashMap<String,Object> configMap){
        ZIMMessageDeleteConfig config = new ZIMMessageDeleteConfig();
        config.isAlsoDeleteServerMessage = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerMessage"));
        return config;
    }

    static public ZIMConversationDeleteConfig cnvZIMConversationDeleteConfigBasicToObject(HashMap<String,Object> configMap){
        ZIMConversationDeleteConfig config = new ZIMConversationDeleteConfig();
        config.isAlsoDeleteServerConversation =  ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerConversation"));
        return config;
    }

    static public ZIMPushConfig cnvZIMPushConfigMapToObject(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMPushConfig config = new ZIMPushConfig();
        config.title = (String) Objects.requireNonNull(configMap.get("title"));
        config.content = (String) Objects.requireNonNull(configMap.get("content"));
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public ZIMMessageSendConfig cnvZIMMessageSendConfigMapToObject(HashMap<String,Object> configMap){
        ZIMMessageSendConfig config = new ZIMMessageSendConfig();
        config.priority = ZIMMessagePriority.getZIMMessagePriority(ZIMPluginCommonTools.safeGetIntValue(configMap.get("priority")));
        config.pushConfig = cnvZIMPushConfigMapToObject(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig"))) ;
        return config;
    }

    static public ZIMMessageQueryConfig cnvZIMMessageQueryConfigMapToObject(HashMap<String,Object> configMap){
        ZIMMessageQueryConfig config = new ZIMMessageQueryConfig();
        config.nextMessage = cnvZIMMessageMapToObject(ZIMPluginCommonTools.safeGetHashMap(configMap.get("nextMessage")));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.reverse = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("reverse"));
        return config;
    }

    static public ZIMRoomInfo cnvZIMRoomInfoMapToObejct(HashMap<String,Object> configMap){
        ZIMRoomInfo roomInfo = new ZIMRoomInfo();
        roomInfo.roomID = (String) configMap.get("roomID");
        roomInfo.roomName = (String) configMap.get("roomName");
        return roomInfo;
    }

    static public HashMap<String,Object> cnvZIMRoomInfoObjectToMap(ZIMRoomInfo roomInfo){
        HashMap<String,Object> roomInfoMap = new  HashMap<>();
        roomInfoMap.put("roomID",roomInfo.roomID);
        roomInfoMap.put("roomName",roomInfo.roomName);
        return roomInfoMap;
    }

    static public ZIMRoomAdvancedConfig cnvZIMRoomAdvancedConfigMapToObject(HashMap<String,Object> configMap){
        ZIMRoomAdvancedConfig config = new ZIMRoomAdvancedConfig();
        if(configMap.get("roomAttributes") != null) config.roomAttributes = (HashMap<String, String>) configMap.get("roomAttributes");
        config.roomDestroyDelayTime = ZIMPluginCommonTools.safeGetIntValue(configMap.get("roomDestroyDelayTime"));
        return config;
    }

    static public HashMap<String,Object> cnvZIMRoomFullInfoObjectToMap(ZIMRoomFullInfo fullInfo){
        HashMap<String,Object> fullInfoMap = new HashMap<>();
        fullInfoMap.put("baseInfo",cnvZIMRoomInfoObjectToMap(fullInfo.baseInfo));
        return fullInfoMap;
    }

    static public ZIMRoomMemberQueryConfig cnvZIMRoomMemberQueryConfigMapToObject(HashMap<String,Object> configMap){
        ZIMRoomMemberQueryConfig config = new ZIMRoomMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = (String) configMap.get("nextFlag");
        return config;
    }

    static public ZIMRoomAttributesSetConfig cnvZIMRoomAttributesSetConfigMapToObject(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesSetConfig config = new ZIMRoomAttributesSetConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMRoomAttributesDeleteConfig cnvZIMRoomAttributesDeleteConfigMapToObject(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesDeleteConfig config = new ZIMRoomAttributesDeleteConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        return config;
    }

    static public ZIMRoomAttributesBatchOperationConfig cnvZIMRoomAttributesBatchOperationConfigMapToObject(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesBatchOperationConfig config = new ZIMRoomAttributesBatchOperationConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMGroupInfo cnvZIMGroupInfoMapToObject(HashMap<String,Object> infoMap){
        ZIMGroupInfo groupInfo = new ZIMGroupInfo();
        groupInfo.groupID = (String) infoMap.get("groupID");
        groupInfo.groupName = (String) infoMap.get("groupName");
        return groupInfo;
    }

    static public HashMap<String,Object> cnvZIMGroupInfoObjectToMap(ZIMGroupInfo groupInfo){
        HashMap<String,Object> groupInfoMap = new HashMap<>();
        groupInfoMap.put("groupID",groupInfo.groupID);
        groupInfoMap.put("groupName",groupInfo.groupName);
        return groupInfoMap;
    }

    static public HashMap<String,Object> cnvZIMGroupFullInfoObjectToMap(ZIMGroupFullInfo groupFullInfo){
        HashMap<String,Object> groupFullInfoMap = new HashMap<>();
        groupFullInfoMap.put("groupNotice",groupFullInfo.groupNotice);
        groupFullInfoMap.put("groupAttributes",groupFullInfo.groupAttributes);
        groupFullInfoMap.put("notificationStatus",groupFullInfo.notificationStatus.value());
        groupFullInfoMap.put("baseInfo",cnvZIMGroupInfoObjectToMap(groupFullInfo.baseInfo));
        return groupFullInfoMap;
    }

    static public HashMap<String,Object> cnvZIMGroupMemberInfoObjectToMap(ZIMGroupMemberInfo groupMemberInfo){
        HashMap<String,Object> groupMemberInfoMap = new HashMap<>();
        groupMemberInfoMap.put("memberNickname",groupMemberInfo.memberNickname);
        groupMemberInfoMap.put("memberRole",groupMemberInfo.memberRole);
        groupMemberInfoMap.put("userID",groupMemberInfo.userID);
        groupMemberInfoMap.put("userName",groupMemberInfo.userName);
        return groupMemberInfoMap;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMGroupMemberInfoListToBasicList(ArrayList<ZIMGroupMemberInfo> groupMemberInfoList){
        ArrayList<HashMap<String,Object>> basicList = new ArrayList<>();
        for (ZIMGroupMemberInfo groupMemberInfo:
             groupMemberInfoList) {
            basicList.add(cnvZIMGroupMemberInfoObjectToMap(groupMemberInfo));
        }
        return basicList;
    }

    static public HashMap<String,Object> cnvZIMGroupAdvancedConfigObjectToMap(ZIMGroupAdvancedConfig config){
        HashMap<String,Object> configMap = new HashMap<>();
        configMap.put("groupNotice",config.groupNotice);
        configMap.put("groupAttributes",config.groupAttributes);
        return configMap;
    }

    static public ZIMGroupAdvancedConfig cnvZIMGroupAdvancedConfigMapToObject(HashMap<String,Object> configMap){
        ZIMGroupAdvancedConfig config = new ZIMGroupAdvancedConfig();
        Object attributesObj = configMap.get("groupAttributes");
        if(attributesObj instanceof HashMap<?,?>){
            config.groupAttributes = (HashMap<String,String>) attributesObj;
        }
        config.groupNotice = (String) configMap.get("groupNotice");
        return config;
    }

    static public HashMap<String,Object> cnvZIMGroupObjectToMap(ZIMGroup zimGroup){
        HashMap<String,Object> zimGroupMap = new  HashMap<>();
        zimGroupMap.put("baseInfo",cnvZIMGroupInfoObjectToMap(zimGroup.baseInfo));
        zimGroupMap.put("notificationStatus",zimGroup.notificationStatus.value());
        return zimGroupMap;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMGroupListToBasicList(ArrayList<ZIMGroup> groupList){
        ArrayList<HashMap<String,Object>> basicGroupList = new ArrayList<>();
        for (ZIMGroup zimGroup:
             groupList) {
            basicGroupList.add(cnvZIMGroupObjectToMap(zimGroup));
        }
        return basicGroupList;
    }

    static public ZIMGroupMemberQueryConfig cnvZIMGroupMemberQueryConfigMapToObject(HashMap<String,Object> configMap){
        ZIMGroupMemberQueryConfig config = new ZIMGroupMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        return config;
    }

    static public ZIMCallInviteConfig cnvZIMCallInviteConfigMapToObject(HashMap<String,Object> configMap){
        ZIMCallInviteConfig config = new ZIMCallInviteConfig();
        config.timeout = ZIMPluginCommonTools.safeGetIntValue(configMap.get("timeout"));
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public HashMap<String,Object> cnvZIMCallUserInfoObjectToMap(ZIMCallUserInfo userInfo){
        HashMap<String,Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID",userInfo.userID);
        userInfoMap.put("state",userInfo.state.value());
        return userInfoMap;
    }

    static public ArrayList<HashMap<String ,Object>> cnvZIMCallUserInfoListToBasicList(ArrayList<ZIMCallUserInfo> callUserInfoList){
        ArrayList<HashMap<String ,Object>> basicUserInfoList = new ArrayList<>();
        for (ZIMCallUserInfo callUserInfo :
                callUserInfoList) {
            basicUserInfoList.add(cnvZIMCallUserInfoObjectToMap(callUserInfo));
        }
        return basicUserInfoList;
    }

    static public HashMap<String,Object> cnvZIMCallInvitationSentInfoObjectToMap(ZIMCallInvitationSentInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("timeout",info.timeout);
        infoMap.put("errorInvitees",cnvZIMCallUserInfoListToBasicList(info.errorInvitees));
        return infoMap;
    }

    static public ZIMCallCancelConfig cnvZIMCallCancelConfigMapToObject(HashMap<String,Object> configMap){
        ZIMCallCancelConfig config = new ZIMCallCancelConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public ZIMCallAcceptConfig cnvZIMCallAcceptConfigMapToObject(HashMap<String,Object> configMap){
        ZIMCallAcceptConfig config = new ZIMCallAcceptConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public ZIMCallRejectConfig cnvZIMCallRejectConfigMapToObject(HashMap<String,Object> configMap) {
        ZIMCallRejectConfig config = new ZIMCallRejectConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public HashMap<String,Object> cnvZIMRoomAttributesUpdateInfoObjectToMap(ZIMRoomAttributesUpdateInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("action",info.action.value());
        infoMap.put("roomAttributes",info.roomAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMRoomAttributesUpdateInfoListToBasicList(ArrayList<ZIMRoomAttributesUpdateInfo> infos){
        ArrayList<HashMap<String,Object>> basicInfoList = new ArrayList<>();
        for (ZIMRoomAttributesUpdateInfo info:
             infos) {
            basicInfoList.add(cnvZIMRoomAttributesUpdateInfoObjectToMap(info));
        }
        return basicInfoList;
    }

    static public HashMap<String,Object> cnvZIMGroupOperatedInfoObjectToMap(ZIMGroupOperatedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("operatedUserInfo",cnvZIMGroupMemberInfoObjectToMap(info.operatedUserInfo));
        return infoMap;
    }

    static public HashMap<String,Object> cnvZIMGroupAttributesUpdateInfoObjectToMap(ZIMGroupAttributesUpdateInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("action",info.action.value());
        infoMap.put("groupAttributes",info.groupAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String,Object>> cnvZIMGroupAttributesUpdateInfoListToBasicList(ArrayList<ZIMGroupAttributesUpdateInfo> infoList){
        ArrayList<HashMap<String,Object>> basicList = new ArrayList<>();
        for (ZIMGroupAttributesUpdateInfo info :
                infoList) {
            basicList.add(cnvZIMGroupAttributesUpdateInfoObjectToMap(info));
        }
        return basicList;
    }

    static public HashMap<String,Object> cnvZIMCallInvitationReceivedInfoObjectToMap(ZIMCallInvitationReceivedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("timeout",info.timeout);
        infoMap.put("inviter",info.inviter);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> cnvZIMCallInvitationCancelledInfoObjectToMap(ZIMCallInvitationCancelledInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("inviter",info.inviter);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> cnvZIMCallInvitationAcceptedInfoObjectToMap(ZIMCallInvitationAcceptedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("invitee",info.invitee);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> cnvZIMCallInvitationRejectedInfoObjectToMap(ZIMCallInvitationRejectedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("invitee",info.invitee);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }
}
