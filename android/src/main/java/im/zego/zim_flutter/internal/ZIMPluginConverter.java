package im.zego.zim_flutter.internal;


import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import im.zego.zim.entity.ZIMAppConfig;
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
import im.zego.zim.entity.ZIMGroupMessageReceiptMemberQueryConfig;
import im.zego.zim.entity.ZIMGroupOperatedInfo;
import im.zego.zim.entity.ZIMImageMessage;
import im.zego.zim.entity.ZIMMediaMessage;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMMessageDeleteConfig;
import im.zego.zim.entity.ZIMMessageQueryConfig;
import im.zego.zim.entity.ZIMMessageReceiptInfo;
import im.zego.zim.entity.ZIMMessageRevokeConfig;
import im.zego.zim.entity.ZIMMessageSendConfig;
import im.zego.zim.entity.ZIMPushConfig;
import im.zego.zim.entity.ZIMRevokeMessage;
import im.zego.zim.entity.ZIMRoomAdvancedConfig;
import im.zego.zim.entity.ZIMRoomAttributesBatchOperationConfig;
import im.zego.zim.entity.ZIMRoomAttributesDeleteConfig;
import im.zego.zim.entity.ZIMRoomAttributesSetConfig;
import im.zego.zim.entity.ZIMRoomAttributesUpdateInfo;
import im.zego.zim.entity.ZIMRoomFullInfo;
import im.zego.zim.entity.ZIMRoomInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesOperatedInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesQueryConfig;
import im.zego.zim.entity.ZIMRoomMemberAttributesSetConfig;
import im.zego.zim.entity.ZIMRoomMemberAttributesUpdateInfo;
import im.zego.zim.entity.ZIMRoomMemberQueryConfig;
import im.zego.zim.entity.ZIMRoomOperatedInfo;
import im.zego.zim.entity.ZIMSystemMessage;
import im.zego.zim.entity.ZIMTextMessage;
import im.zego.zim.entity.ZIMUserFullInfo;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.entity.ZIMUsersInfoQueryConfig;
import im.zego.zim.entity.ZIMVideoMessage;
import im.zego.zim.enums.ZIMConversationNotificationStatus;
import im.zego.zim.enums.ZIMConversationType;
import im.zego.zim.enums.ZIMMessageDirection;
import im.zego.zim.enums.ZIMMessagePriority;
import im.zego.zim.enums.ZIMMessageReceiptStatus;
import im.zego.zim.enums.ZIMMessageRevokeStatus;
import im.zego.zim.enums.ZIMMessageSentStatus;
import im.zego.zim.enums.ZIMMessageType;
import im.zego.zim.enums.ZIMRevokeType;

@SuppressWarnings({"unused","deprecation,unchecked,all"})
public class ZIMPluginConverter {

    static public ZIMAppConfig oZIMAppConfig(HashMap<String,Object> configMap){
        ZIMAppConfig config = new ZIMAppConfig();
        config.appID = ZIMPluginCommonTools.safeGetLongValue(configMap.get("appID"));
        config.appSign = (String)(configMap.get("appSign"));
        return config;
    }

    static public ZIMUsersInfoQueryConfig oZIMUsersInfoQueryConfig(HashMap<String,Object> configMap){
        ZIMUsersInfoQueryConfig config = new ZIMUsersInfoQueryConfig();
        config.isQueryFromServer = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isQueryFromServer"));
        return config;
    }

    static public ArrayList<HashMap<String,Object>> mZIMConversationChangeInfoList(ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        ArrayList<HashMap<String,Object>> conversationChangeInfoBasicList = new ArrayList<>();
        for (ZIMConversationChangeInfo conversationChangeInfo:
             conversationChangeInfoList) {
            conversationChangeInfoBasicList.add(mZIMConversationChangeInfo(conversationChangeInfo));
        }
        return conversationChangeInfoBasicList;
    }

    static public HashMap<String,Object> mZIMConversationChangeInfo(ZIMConversationChangeInfo conversationChangeInfo){
        HashMap<String,Object> conversationChangeInfoMap = new HashMap<>();
        conversationChangeInfoMap.put("event",conversationChangeInfo.event.value());


        conversationChangeInfoMap.put("conversation", mZIMConversation(conversationChangeInfo.conversation));
        return conversationChangeInfoMap;
    }

    static public HashMap<String,Object> mZIMConversation(ZIMConversation conversation){
        HashMap<String,Object> conversationMap = new HashMap<>();
        conversationMap.put("conversationID",conversation.conversationID);
        conversationMap.put("conversationName",conversation.conversationName);
        conversationMap.put("conversationAvatarUrl",conversation.conversationAvatarUrl);
        conversationMap.put("type",conversation.type.value());
        conversationMap.put("unreadMessageCount",conversation.unreadMessageCount);
        conversationMap.put("orderKey",conversation.orderKey);
        conversationMap.put("notificationStatus",conversation.notificationStatus.value());
        if(conversation.lastMessage != null){
            conversationMap.put("lastMessage", mZIMMessage(conversation.lastMessage));
        }
        else {
            conversationMap.put("lastMessage",null);
        }
        return conversationMap;
    }

//    static public ArrayList cnvZIMConversationListToBasicList(ArrayList<ZIMConversation> conversationList){
//        ArrayList
//    }

    static public HashMap<String,Object> mZIMMessage(ZIMMessage message){
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
        messageMap.put("isUserInserted",message.isUserInserted());
        messageMap.put("receiptStatus",message.getReceiptStatus().value());
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
                messageMap.put("originalImageHeight",((ZIMImageMessage) message).getOriginalImageHeight());
                messageMap.put("originalImageWidth",((ZIMImageMessage) message).getOriginalImageWidth());
                messageMap.put("largeImageHeight",((ZIMImageMessage) message).getLargeImageHeight());
                messageMap.put("largeImageWidth",((ZIMImageMessage) message).getLargeImageWidth());
                messageMap.put("thumbnailHeight",((ZIMImageMessage) message).getThumbnailHeight());
                messageMap.put("thumbnailWidth",((ZIMImageMessage) message).getThumbnailWidth());
                break;
            case VIDEO:
                assert message instanceof ZIMVideoMessage;
                messageMap.put("videoDuration",((ZIMVideoMessage) message).getVideoDuration());
                messageMap.put("videoFirstFrameDownloadUrl",((ZIMVideoMessage) message).getVideoFirstFrameDownloadUrl());
                messageMap.put("videoFirstFrameLocalPath",((ZIMVideoMessage) message).getVideoFirstFrameLocalPath());
                messageMap.put("videoFirstFrameHeight",((ZIMVideoMessage) message).getVideoFirstFrameHeight());
                messageMap.put("videoFirstFrameWidth",((ZIMVideoMessage) message).getVideoFirstFrameWidth());
                break;
            case AUDIO:
                assert message instanceof ZIMAudioMessage;
                messageMap.put("audioDuration",((ZIMAudioMessage) message).getAudioDuration());
                break;
            case FILE:
                assert message instanceof ZIMFileMessage;
                break;
            case SYSTEM:
                assert message instanceof ZIMSystemMessage;
                messageMap.put("message",((ZIMSystemMessage)message).message);
                break;
            case REVOKE:
                assert message instanceof ZIMRevokeMessage;
                messageMap.put("revokeType",((ZIMRevokeMessage) message).getRevokeType().value());
                messageMap.put("revokeStatus",((ZIMRevokeMessage) message).getRevokeStatus().value());
                messageMap.put("revokeTimestamp",((ZIMRevokeMessage) message).getRevokeTimestamp());
                messageMap.put("operatedUserID",((ZIMRevokeMessage) message).getOperatedUserID());
                messageMap.put("revokeExtendedData",((ZIMRevokeMessage) message).getRevokeExtendedData());
                messageMap.put("originalMessageType",((ZIMRevokeMessage) message).getOriginalMessageType().value());
                messageMap.put("originalTextMessageContent",((ZIMRevokeMessage) message).getOriginalTextMessageContent());
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

    static public ZIMMessage oZIMMessage(HashMap<String,Object> messageMap){
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

                    Field originalImageHeightField = ZIMImageMessage.class.getDeclaredField("originalImageHeight");
                    originalImageHeightField.setAccessible(true);
                    originalImageHeightField.set(message,messageMap.get("originalImageHeight"));
                    originalImageHeightField.setAccessible(false);

                    Field originalImageWidthField = ZIMImageMessage.class.getDeclaredField("originalImageWidth");
                    originalImageWidthField.setAccessible(true);
                    originalImageWidthField.set(message,messageMap.get("originalImageWidth"));
                    originalImageWidthField.setAccessible(false);

                    Field largeImageHeightField = ZIMImageMessage.class.getDeclaredField("largeImageHeight");
                    largeImageHeightField.setAccessible(true);
                    largeImageHeightField.set(message,messageMap.get("largeImageHeight"));
                    largeImageHeightField.setAccessible(false);

                    Field largeImageWidthField = ZIMImageMessage.class.getDeclaredField("largeImageWidth");
                    largeImageWidthField.setAccessible(true);
                    largeImageWidthField.set(message,messageMap.get("largeImageWidth"));
                    largeImageWidthField.setAccessible(false);

                    Field thumbnailHeightField = ZIMImageMessage.class.getDeclaredField("thumbnailHeight");
                    thumbnailHeightField.setAccessible(true);
                    thumbnailHeightField.set(message,messageMap.get("thumbnailHeight"));
                    thumbnailHeightField.setAccessible(false);

                    Field thumbnailWidthField = ZIMImageMessage.class.getDeclaredField("thumbnailWidth");
                    thumbnailWidthField.setAccessible(true);
                    thumbnailWidthField.set(message,messageMap.get("thumbnailWidth"));
                    thumbnailWidthField.setAccessible(false);

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

                    Field videoFirstFrameLocalPathField = ZIMVideoMessage.class.getDeclaredField("videoFirstFrameLocalPath");
                    videoFirstFrameLocalPathField.setAccessible(true);
                    videoFirstFrameLocalPathField.set(message,messageMap.get("videoFirstFrameLocalPath"));
                    videoFirstFrameLocalPathField.setAccessible(false);

                    Field videoFirstFrameHeightField = ZIMVideoMessage.class.getDeclaredField("videoFirstFrameHeight");
                    videoFirstFrameHeightField.setAccessible(true);
                    videoFirstFrameHeightField.set(message,messageMap.get("videoFirstFrameHeight"));
                    videoFirstFrameHeightField.setAccessible(false);

                    Field videoFirstFrameWidthField = ZIMVideoMessage.class.getDeclaredField("videoFirstFrameWidth");
                    videoFirstFrameWidthField.setAccessible(true);
                    videoFirstFrameWidthField.set(message,messageMap.get("videoFirstFrameWidth"));
                    videoFirstFrameWidthField.setAccessible(false);
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
            case SYSTEM:
                message = new ZIMSystemMessage();
                ((ZIMSystemMessage) message).message = (String) messageMap.get("message");
                break;
            case REVOKE:
                message = new ZIMRevokeMessage();
                try{
                    Field revokeTypeField = ZIMRevokeMessage.class.getDeclaredField("revokeType");
                    revokeTypeField.setAccessible(true);
                    revokeTypeField.set(message, ZIMRevokeType.getZIMRevokeType(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("revokeType"))));
                    revokeTypeField.setAccessible(false);

                    Field revokeStatusField = ZIMRevokeMessage.class.getDeclaredField("revokeStatus");
                    revokeStatusField.setAccessible(true);
                    revokeStatusField.set(message, ZIMMessageRevokeStatus.getZIMMessageRevokeStatus(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("revokeStatus"))));
                    revokeStatusField.setAccessible(false);

                    Field originalMessageTypeField = ZIMRevokeMessage.class.getDeclaredField("originalMessageType");
                    originalMessageTypeField.setAccessible(true);
                    originalMessageTypeField.set(message, ZIMMessageType.getZIMMessageType(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("originalMessageType"))));
                    originalMessageTypeField.setAccessible(false);

                    Field revokeTimestampField = ZIMRevokeMessage.class.getDeclaredField("revokeTimestamp");
                    revokeTimestampField.setAccessible(true);
                    revokeTimestampField.set(message,messageMap.get("revokeTimestamp"));
                    revokeTimestampField.setAccessible(false);

                    Field operatedUserIDField = ZIMRevokeMessage.class.getDeclaredField("operatedUserID");
                    operatedUserIDField.setAccessible(true);
                    operatedUserIDField.set(message,messageMap.get("operatedUserID"));
                    operatedUserIDField.setAccessible(false);

                    Field revokeExtendedDataField = ZIMRevokeMessage.class.getDeclaredField("revokeExtendedData");
                    revokeExtendedDataField.setAccessible(true);
                    revokeExtendedDataField.set(message,messageMap.get("revokeExtendedData"));
                    revokeExtendedDataField.setAccessible(false);

                    Field originalTextMessageContentField = ZIMRevokeMessage.class.getDeclaredField("originalTextMessageContent");
                    originalTextMessageContentField.setAccessible(true);
                    originalTextMessageContentField.set(message,messageMap.get("originalTextMessageContent"));
                    originalTextMessageContentField.setAccessible(false);
                }
                catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
                catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
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
            conversationIDField.setAccessible(false);

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

            Field isUserInsertedField = ZIMMessage.class.getDeclaredField("isUserInserted");
            isUserInsertedField.setAccessible(true);
            isUserInsertedField.set(message,ZIMPluginCommonTools.safeGetBoolValue(messageMap.get("isUserInserted")));
            isUserInsertedField.setAccessible(false);

            Field receiptStatusField = ZIMMessage.class.getDeclaredField("receiptStatus");
            receiptStatusField.setAccessible(true);
            receiptStatusField.set(message, ZIMMessageReceiptStatus.getZIMMessageReceiptStatus(ZIMPluginCommonTools.safeGetIntValue(messageMap.get("receiptStatus"))));
            receiptStatusField.setAccessible(false);
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

    static public ArrayList<HashMap<String,Object>> mZIMMessageList(ArrayList<ZIMMessage> messageList){
        ArrayList<HashMap<String,Object>> messageBasicList = new ArrayList<>();
        for (ZIMMessage message:messageList
             ) {
            messageBasicList.add(mZIMMessage(message));
        }
        return messageBasicList;
    }

    static public ArrayList<ZIMMessage> oZIMMessageList(ArrayList<HashMap<String,Object>> basicList){
        ArrayList<ZIMMessage> messageList = new ArrayList<>();
        for (HashMap<String,Object> messageHashMap:basicList
             ) {
            messageList.add(oZIMMessage(messageHashMap));
        }
        return messageList;
    }

    static public HashMap<String,Object>mZIMMessageReceiptInfo(ZIMMessageReceiptInfo info){
        HashMap<String,Object> infoModel = new HashMap<>();
        infoModel.put("conversationID",info.conversationID);
        infoModel.put("conversationType",info.conversationType.value());
        infoModel.put("messageID",info.messageID);
        infoModel.put("status",info.status.value());
        infoModel.put("readMemberCount",info.readMemberCount);
        infoModel.put("unreadMemberCount",info.unreadMemberCount);
        return infoModel;
    }

    static public ArrayList<HashMap<String,Object>> mZIMUserInfoList(ArrayList<ZIMUserInfo> userList){
        ArrayList<HashMap<String,Object>> userInfoBasicList = new ArrayList<>();
        for (ZIMUserInfo userInfo:userList) {
            userInfoBasicList.add(mZIMUserInfo(userInfo));
        }
        return userInfoBasicList;
    }

    static public HashMap<String,Object> mZIMUserFullInfo(ZIMUserFullInfo userFullInfo){
        HashMap<String,Object> userFullInfoMap = new HashMap<>();
        userFullInfoMap.put("userAvatarUrl",userFullInfo.userAvatarUrl);
        userFullInfoMap.put("extendedData",userFullInfo.extendedData);
        HashMap<String,Object> baseInfoMap = mZIMUserInfo(userFullInfo.baseInfo);
        userFullInfoMap.put("baseInfo",baseInfoMap);
        return  userFullInfoMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMUserFullInfoList(ArrayList<ZIMUserFullInfo> userFullInfoList){
        ArrayList<HashMap<String,Object>> userFullInfoBasicList = new ArrayList<>();
        for (ZIMUserFullInfo userFullInfo:userFullInfoList
             ) {
            userFullInfoBasicList.add(mZIMUserFullInfo(userFullInfo));
        }
        return userFullInfoBasicList;
    }

    static public HashMap<String,Object> mZIMUserInfo(ZIMUserInfo userInfo){
        HashMap<String,Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID",userInfo.userID);
        userInfoMap.put("userName",userInfo.userName);
        return userInfoMap;
    }

    static public HashMap<String,Object> mZIMErrorUserInfo(ZIMErrorUserInfo errorUserInfo){
        HashMap<String,Object> errorUserInfoMap = new HashMap<>();
        errorUserInfoMap.put("userID",errorUserInfo.userID);
        errorUserInfoMap.put("reason",errorUserInfo.reason);
        return errorUserInfoMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMErrorUserInfoList(ArrayList<ZIMErrorUserInfo> errorUserList){
        ArrayList<HashMap<String,Object>> errorUserInfoBasicList = new ArrayList<>();
        for (ZIMErrorUserInfo errorUserInfo:errorUserList) {
            errorUserInfoBasicList.add(mZIMErrorUserInfo(errorUserInfo));
        }
        return errorUserInfoBasicList;
    }

    static public ZIMConversationQueryConfig oZIMConversationQueryConfig(HashMap<String,Object> resultMap){
        ZIMConversationQueryConfig queryConfig = new ZIMConversationQueryConfig();
        queryConfig.count = ZIMPluginCommonTools.safeGetIntValue(resultMap.get("count"));
        queryConfig.nextConversation = oZIMConversation(ZIMPluginCommonTools.safeGetHashMap(resultMap.get("nextConversation")));

        return queryConfig;
    }

    static public ZIMConversation oZIMConversation(HashMap<String,Object> resultMap){
        if(resultMap == null) return null;
        ZIMConversation conversation = new ZIMConversation();
        conversation.conversationID = (String) resultMap.get("conversationID");
        conversation.conversationName = (String) resultMap.get("conversationName");
        conversation.conversationAvatarUrl = (String) resultMap.get("conversationAvatarUrl");
        conversation.type = ZIMConversationType.getZIMConversationType(ZIMPluginCommonTools.safeGetIntValue(resultMap.get("type")));
        conversation.unreadMessageCount = ZIMPluginCommonTools.safeGetIntValue(resultMap.get("unreadMessageCount"));
        conversation.orderKey = ZIMPluginCommonTools.safeGetLongValue(resultMap.get("orderKey"));
        conversation.notificationStatus = ZIMConversationNotificationStatus.getZIMConversationNotificationStatus(ZIMPluginCommonTools.safeGetIntValue(resultMap.get("notificationStatus")));
        if(resultMap.get("lastMessage") != null) {
            conversation.lastMessage = oZIMMessage((ZIMPluginCommonTools.safeGetHashMap(resultMap.get("lastMessage"))));
        }else{
            conversation.lastMessage = null;
        }
        return conversation;
    }

    static public ArrayList<HashMap<String,Object>> mZIMConversationList(ArrayList<ZIMConversation> conversationList){
        ArrayList<HashMap<String,Object>> conversationBasicList = new ArrayList<>();
        for (ZIMConversation conversation:
             conversationList) {
            conversationBasicList.add(mZIMConversation(conversation));
        }
        return conversationBasicList;
    }

    static public ZIMMessageDeleteConfig oZIMMessageDeleteConfig(HashMap<String,Object> configMap){
        ZIMMessageDeleteConfig config = new ZIMMessageDeleteConfig();
        config.isAlsoDeleteServerMessage = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerMessage"));
        return config;
    }

    static public ZIMConversationDeleteConfig oZIMConversationDeleteConfig(HashMap<String,Object> configMap){
        ZIMConversationDeleteConfig config = new ZIMConversationDeleteConfig();
        config.isAlsoDeleteServerConversation =  ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerConversation"));
        return config;
    }

    static public ZIMPushConfig oZIMPushConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMPushConfig config = new ZIMPushConfig();
        config.title = (String) Objects.requireNonNull(configMap.get("title"));
        config.content = (String) Objects.requireNonNull(configMap.get("content"));
        config.payload = (String) configMap.get("payload");
        config.resourcesID = (String) configMap.get("resourcesID");
        return config;
    }

    static public ZIMMessageSendConfig oZIMMessageSendConfig(HashMap<String,Object> configMap){
        ZIMMessageSendConfig config = new ZIMMessageSendConfig();
        config.priority = ZIMMessagePriority.getZIMMessagePriority(ZIMPluginCommonTools.safeGetIntValue(configMap.get("priority")));
        config.pushConfig = oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig"))) ;
        config.hasReceipt = (boolean) configMap.get("hasReceipt");
        return config;
    }

    static public ZIMMessageQueryConfig oZIMMessageQueryConfig(HashMap<String,Object> configMap){
        ZIMMessageQueryConfig config = new ZIMMessageQueryConfig();
        config.nextMessage = oZIMMessage(ZIMPluginCommonTools.safeGetHashMap(configMap.get("nextMessage")));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.reverse = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("reverse"));
        return config;
    }

    static public ZIMRoomInfo oZIMRoomInfo(HashMap<String,Object> configMap){
        ZIMRoomInfo roomInfo = new ZIMRoomInfo();
        roomInfo.roomID = (String) configMap.get("roomID");
        roomInfo.roomName = (String) configMap.get("roomName");
        return roomInfo;
    }

    static public HashMap<String,Object> mZIMRoomInfo(ZIMRoomInfo roomInfo){
        HashMap<String,Object> roomInfoMap = new  HashMap<>();
        roomInfoMap.put("roomID",roomInfo.roomID);
        roomInfoMap.put("roomName",roomInfo.roomName);
        return roomInfoMap;
    }

    static public ZIMRoomAdvancedConfig oZIMRoomAdvancedConfig(HashMap<String,Object> configMap){
        ZIMRoomAdvancedConfig config = new ZIMRoomAdvancedConfig();
        if(configMap.get("roomAttributes") != null) {
            config.roomAttributes = (HashMap<String, String>) configMap.get("roomAttributes");
        }
        config.roomDestroyDelayTime = ZIMPluginCommonTools.safeGetIntValue(configMap.get("roomDestroyDelayTime"));
        return config;
    }

    static public HashMap<String,Object> mZIMRoomFullInfo(ZIMRoomFullInfo fullInfo){
        HashMap<String,Object> fullInfoMap = new HashMap<>();
        fullInfoMap.put("baseInfo", mZIMRoomInfo(fullInfo.baseInfo));
        return fullInfoMap;
    }

    static public ZIMRoomMemberQueryConfig oZIMRoomMemberQueryConfig(HashMap<String,Object> configMap){
        ZIMRoomMemberQueryConfig config = new ZIMRoomMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = (String) configMap.get("nextFlag");
        return config;
    }

    static public ZIMRoomAttributesSetConfig oZIMRoomAttributesSetConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesSetConfig config = new ZIMRoomAttributesSetConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMRoomAttributesDeleteConfig oZIMRoomAttributesDeleteConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesDeleteConfig config = new ZIMRoomAttributesDeleteConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        return config;
    }

    static public ZIMRoomAttributesBatchOperationConfig oZIMRoomAttributesBatchOperationConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomAttributesBatchOperationConfig config = new ZIMRoomAttributesBatchOperationConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMRoomMemberAttributesSetConfig oZIMRoomMemberAttributesSetConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomMemberAttributesSetConfig config = new ZIMRoomMemberAttributesSetConfig();
        config.isDeleteAfterOwnerLeft = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        return config;
    }

    static public HashMap<String,Object> mZIMRoomMemberAttributesInfo(ZIMRoomMemberAttributesInfo info){
        if(info == null){
            return null;
        }
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("userID",info.userID);
        infoMap.put("attributes",info.attributes);
        return infoMap;
    }

    static public HashMap<String,Object> mZIMRoomMemberAttributesOperatedInfo(ZIMRoomMemberAttributesOperatedInfo info){
        if(info == null){
            return null;
        }
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("errorKeys",info.errorKeys);
        infoMap.put("attributesInfo",mZIMRoomMemberAttributesInfo(info.attributesInfo));
        return infoMap;
    }

    static public HashMap<String,Object> mZIMRoomMemberAttributesUpdateInfo(ZIMRoomMemberAttributesUpdateInfo info){
        if(info == null){
            return null;
        }
        HashMap<String,Object> updateInfoModel = new HashMap<>();
        updateInfoModel.put("attributesInfo",mZIMRoomMemberAttributesInfo(info.attributesInfo));
        return updateInfoModel;
    }

    static public HashMap<String,Object> mZIMRoomOperatedInfo(ZIMRoomOperatedInfo info){
        if (info == null){
            return null;
        }
        HashMap<String,Object> infoModel = new HashMap<>();
        infoModel.put("userID",info.userID);
        return infoModel;
    }

    static public ZIMRoomMemberAttributesQueryConfig oZIMRoomMemberAttributesQueryConfig(HashMap<String,Object> configMap){
        if(configMap == null){
            return null;
        }
        ZIMRoomMemberAttributesQueryConfig queryConfig = new ZIMRoomMemberAttributesQueryConfig();
        queryConfig.count = (Integer) configMap.get("count");
        queryConfig.nextFlag = (String) configMap.get("nextFlag");
        return queryConfig;
    }

    static public ZIMGroupInfo oZIMGroupInfo(HashMap<String,Object> infoMap){
        ZIMGroupInfo groupInfo = new ZIMGroupInfo();
        groupInfo.groupID = (String) infoMap.get("groupID");
        groupInfo.groupName = (String) infoMap.get("groupName");
        groupInfo.groupAvatarUrl = (String) infoMap.get("groupAvatarUrl");
        return groupInfo;
    }

    static public HashMap<String,Object> mZIMGroupInfo(ZIMGroupInfo groupInfo){
        HashMap<String,Object> groupInfoMap = new HashMap<>();
        groupInfoMap.put("groupID",groupInfo.groupID);
        groupInfoMap.put("groupName",groupInfo.groupName);
        groupInfoMap.put("groupAvatarUrl",groupInfo.groupAvatarUrl);
        return groupInfoMap;
    }

    static public HashMap<String,Object> mZIMGroupFullInfo(ZIMGroupFullInfo groupFullInfo){
        HashMap<String,Object> groupFullInfoMap = new HashMap<>();
        groupFullInfoMap.put("groupNotice",groupFullInfo.groupNotice);
        groupFullInfoMap.put("groupAttributes",groupFullInfo.groupAttributes);
        groupFullInfoMap.put("notificationStatus",groupFullInfo.notificationStatus.value());
        groupFullInfoMap.put("baseInfo", mZIMGroupInfo(groupFullInfo.baseInfo));
        return groupFullInfoMap;
    }

    static public HashMap<String,Object> mZIMGroupMemberInfo(ZIMGroupMemberInfo groupMemberInfo){
        HashMap<String,Object> groupMemberInfoMap = new HashMap<>();
        groupMemberInfoMap.put("memberNickname",groupMemberInfo.memberNickname);
        groupMemberInfoMap.put("memberRole",groupMemberInfo.memberRole);
        groupMemberInfoMap.put("userID",groupMemberInfo.userID);
        groupMemberInfoMap.put("userName",groupMemberInfo.userName);
        groupMemberInfoMap.put("memberAvatarUrl",groupMemberInfo.memberAvatarUrl != null?groupMemberInfo.memberAvatarUrl:"");
        return groupMemberInfoMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMGroupMemberInfoList(ArrayList<ZIMGroupMemberInfo> groupMemberInfoList){
        ArrayList<HashMap<String,Object>> basicList = new ArrayList<>();
        for (ZIMGroupMemberInfo groupMemberInfo:
             groupMemberInfoList) {
            basicList.add(mZIMGroupMemberInfo(groupMemberInfo));
        }
        return basicList;
    }

    static public HashMap<String,Object> mZIMGroupAdvancedConfig(ZIMGroupAdvancedConfig config){
        HashMap<String,Object> configMap = new HashMap<>();
        configMap.put("groupNotice",config.groupNotice);
        configMap.put("groupAttributes",config.groupAttributes);
        return configMap;
    }

    static public ZIMGroupAdvancedConfig oZIMGroupAdvancedConfig(HashMap<String,Object> configMap){
        ZIMGroupAdvancedConfig config = new ZIMGroupAdvancedConfig();
        Object attributesObj = configMap.get("groupAttributes");
        if(attributesObj instanceof HashMap<?,?>){
            config.groupAttributes = (HashMap<String, String>) attributesObj;
        }
        config.groupNotice = (String) configMap.get("groupNotice");
        return config;
    }

    static public HashMap<String,Object> mZIMGroup(ZIMGroup zimGroup){
        HashMap<String,Object> zimGroupMap = new  HashMap<>();
        zimGroupMap.put("baseInfo", mZIMGroupInfo(zimGroup.baseInfo));
        zimGroupMap.put("notificationStatus",zimGroup.notificationStatus.value());
        return zimGroupMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMGroupList(ArrayList<ZIMGroup> groupList){
        ArrayList<HashMap<String,Object>> basicGroupList = new ArrayList<>();
        for (ZIMGroup zimGroup:
             groupList) {
            basicGroupList.add(mZIMGroup(zimGroup));
        }
        return basicGroupList;
    }

    static public ZIMGroupMemberQueryConfig oZIMGroupMemberQueryConfig(HashMap<String,Object> configMap){
        ZIMGroupMemberQueryConfig config = new ZIMGroupMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        return config;
    }

    static public ZIMCallInviteConfig oZIMCallInviteConfig(HashMap<String,Object> configMap){
        ZIMCallInviteConfig config = new ZIMCallInviteConfig();
        config.timeout = ZIMPluginCommonTools.safeGetIntValue(configMap.get("timeout"));
        config.extendedData = (String) configMap.get("extendedData");
        config.pushConfig = oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig"))) ;
        return config;
    }

    static public HashMap<String,Object> mZIMCallUserInfo(ZIMCallUserInfo userInfo){
        HashMap<String,Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID",userInfo.userID);
        userInfoMap.put("state",userInfo.state.value());
        return userInfoMap;
    }

    static public ArrayList<HashMap<String ,Object>> mZIMCallUserInfoList(ArrayList<ZIMCallUserInfo> callUserInfoList){
        ArrayList<HashMap<String ,Object>> basicUserInfoList = new ArrayList<>();
        for (ZIMCallUserInfo callUserInfo :
                callUserInfoList) {
            basicUserInfoList.add(mZIMCallUserInfo(callUserInfo));
        }
        return basicUserInfoList;
    }

    static public HashMap<String,Object> mZIMCallInvitationSentInfo(ZIMCallInvitationSentInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("timeout",info.timeout);
        infoMap.put("errorInvitees", mZIMCallUserInfoList(info.errorInvitees));
        return infoMap;
    }

    static public ZIMCallCancelConfig oZIMCallCancelConfig(HashMap<String,Object> configMap){
        ZIMCallCancelConfig config = new ZIMCallCancelConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public ZIMCallAcceptConfig oZIMCallAcceptConfig(HashMap<String,Object> configMap){
        ZIMCallAcceptConfig config = new ZIMCallAcceptConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public ZIMCallRejectConfig oZIMCallRejectConfig(HashMap<String,Object> configMap) {
        ZIMCallRejectConfig config = new ZIMCallRejectConfig();
        config.extendedData = (String) configMap.get("extendedData");
        return config;
    }

    static public HashMap<String,Object> mZIMRoomAttributesUpdateInfo(ZIMRoomAttributesUpdateInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("action",info.action.value());
        infoMap.put("roomAttributes",info.roomAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMRoomAttributesUpdateInfoList(ArrayList<ZIMRoomAttributesUpdateInfo> infos){
        ArrayList<HashMap<String,Object>> basicInfoList = new ArrayList<>();
        for (ZIMRoomAttributesUpdateInfo info:
             infos) {
            basicInfoList.add(mZIMRoomAttributesUpdateInfo(info));
        }
        return basicInfoList;
    }

    static public HashMap<String,Object> mZIMGroupOperatedInfo(ZIMGroupOperatedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("operatedUserInfo", mZIMGroupMemberInfo(info.operatedUserInfo));
        infoMap.put("userID", info.userID);
        infoMap.put("userName", info.userName);
        infoMap.put("memberNickname", info.memberNickname);
        infoMap.put("memberRole", info.memberRole);
        return infoMap;
    }

    static public HashMap<String,Object> mZIMGroupAttributesUpdateInfo(ZIMGroupAttributesUpdateInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("action",info.action.value());
        infoMap.put("groupAttributes",info.groupAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String,Object>> mZIMGroupAttributesUpdateInfoList(ArrayList<ZIMGroupAttributesUpdateInfo> infoList){
        ArrayList<HashMap<String,Object>> basicList = new ArrayList<>();
        for (ZIMGroupAttributesUpdateInfo info :
                infoList) {
            basicList.add(mZIMGroupAttributesUpdateInfo(info));
        }
        return basicList;
    }

    static public HashMap<String,Object> mZIMCallInvitationReceivedInfo(ZIMCallInvitationReceivedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("timeout",info.timeout);
        infoMap.put("inviter",info.inviter);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> mZIMCallInvitationCancelledInfo(ZIMCallInvitationCancelledInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("inviter",info.inviter);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> mZIMCallInvitationAcceptedInfo(ZIMCallInvitationAcceptedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("invitee",info.invitee);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public HashMap<String,Object> mZIMCallInvitationRejectedInfo(ZIMCallInvitationRejectedInfo info){
        HashMap<String,Object> infoMap = new HashMap<>();
        infoMap.put("invitee",info.invitee);
        infoMap.put("extendedData",info.extendedData);
        return infoMap;
    }

    static public ZIMGroupMessageReceiptMemberQueryConfig oZIMGroupMessageReceiptMemberQueryConfig(HashMap<String,Object> configMap){
        ZIMGroupMessageReceiptMemberQueryConfig queryConfig = new ZIMGroupMessageReceiptMemberQueryConfig();
        queryConfig.count = (Integer) configMap.get("count");
        queryConfig.nextFlag = (Integer) configMap.get("nextFlag");
        return queryConfig;
    }

    static public ZIMMessageRevokeConfig oZIMMessageRevokeConfig(HashMap<String,Object> configMap){
        ZIMMessageRevokeConfig revokeConfig = new ZIMMessageRevokeConfig();
        revokeConfig.revokeExtendedData = (String) configMap.get("revokeExtendedData");
        revokeConfig.pushConfig = oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig"))) ;
        return revokeConfig;
    }
}
