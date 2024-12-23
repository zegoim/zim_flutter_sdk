package im.zego.zim_flutter.internal;

import im.zego.zim.ZIM;
import im.zego.zim.entity.*;
import im.zego.zim.enums.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

@SuppressWarnings({"unused", "deprecation,unchecked,all"})
public class ZIMPluginConverter {

    static public ZIMAppConfig oZIMAppConfig(HashMap<String, Object> configMap) {
        ZIMAppConfig config = new ZIMAppConfig();
        config.appID = ZIMPluginCommonTools.safeGetLongValue(configMap.get("appID"));
        config.appSign = (String)(configMap.get("appSign"));
        return config;
    }

    static public ZIMLoginConfig oZIMLoginConfig(HashMap<String, Object> configMap) {
        ZIMLoginConfig config = new ZIMLoginConfig();
        config.userName = (String)(configMap.get("userName"));
        config.token = (String)(configMap.get("token"));
        config.isOfflineLogin =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isOfflineLogin"));
        return config;
    }

    static public ZIMUsersInfoQueryConfig
    oZIMUsersInfoQueryConfig(HashMap<String, Object> configMap) {
        ZIMUsersInfoQueryConfig config = new ZIMUsersInfoQueryConfig();
        config.isQueryFromServer =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isQueryFromServer"));
        return config;
    }

    static public ArrayList<HashMap<String, Object>> mZIMConversationChangeInfoList(
        ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        ArrayList<HashMap<String, Object>> conversationChangeInfoBasicList = new ArrayList<>();
        for (ZIMConversationChangeInfo conversationChangeInfo : conversationChangeInfoList) {
            conversationChangeInfoBasicList.add(mZIMConversationChangeInfo(conversationChangeInfo));
        }
        return conversationChangeInfoBasicList;
    }

    static public ArrayList<HashMap<String, Object>> mZIMMessageSentStatusChangeInfoList(
        ArrayList<ZIMMessageSentStatusChangeInfo> messageSentStatusChangeInfoList) {
        ArrayList<HashMap<String, Object>> messageSentStatusChangeInfoBasicList = new ArrayList<>();
        for (ZIMMessageSentStatusChangeInfo messageSentStatusChangeInfo :
             messageSentStatusChangeInfoList) {
            messageSentStatusChangeInfoBasicList.add(
                mZIMMessageSentStatusChangInfo(messageSentStatusChangeInfo));
        }
        return messageSentStatusChangeInfoBasicList;
    }

    static public HashMap<String, Object>
    mZIMConversationChangeInfo(ZIMConversationChangeInfo conversationChangeInfo) {
        HashMap<String, Object> conversationChangeInfoMap = new HashMap<>();
        conversationChangeInfoMap.put("event", conversationChangeInfo.event.value());

        conversationChangeInfoMap.put("conversation",
                                      mZIMConversation(conversationChangeInfo.conversation));
        return conversationChangeInfoMap;
    }

    static public HashMap<String, Object>
    mZIMMessageSentStatusChangInfo(ZIMMessageSentStatusChangeInfo messageSentStatusChangeInfo) {
        HashMap<String, Object> messageSentStatusChangeInfoMap = new HashMap<>();
        messageSentStatusChangeInfoMap.put("status", messageSentStatusChangeInfo.status.value());
        messageSentStatusChangeInfoMap.put("message",
                                           mZIMMessage(messageSentStatusChangeInfo.message));
        messageSentStatusChangeInfoMap.put("reason", messageSentStatusChangeInfo.reason);
        return messageSentStatusChangeInfoMap;
    }

    static public HashMap<String, Object>
    mZIMConversationBaseInfo(ZIMConversationBaseInfo baseInfo) {
        HashMap<String, Object> conversationMap = new HashMap<>();
        conversationMap.put("conversationID", baseInfo.conversationID);
        conversationMap.put("conversationType", baseInfo.conversationType.value());
        return conversationMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMConversationBaseInfoList(ArrayList<ZIMConversationBaseInfo> conversationList) {
        ArrayList<HashMap<String, Object>> conversationBasicList = new ArrayList<>();
        for (ZIMConversationBaseInfo conversation : conversationList) {
            conversationBasicList.add(mZIMConversationBaseInfo(conversation));
        }
        return conversationBasicList;
    }

    static public HashMap<String, Object> mZIMConversation(ZIMConversation conversation) {
        HashMap<String, Object> conversationMap = new HashMap<>();
        conversationMap.put("conversationID", conversation.conversationID);
        conversationMap.put("conversationName", conversation.conversationName);
        conversationMap.put("conversationAlias", conversation.conversationAlias);
        conversationMap.put("conversationAvatarUrl", conversation.conversationAvatarUrl);
        conversationMap.put("type", conversation.type.value());
        conversationMap.put("unreadMessageCount", conversation.unreadMessageCount);
        conversationMap.put("orderKey", conversation.orderKey);
        conversationMap.put("notificationStatus", conversation.notificationStatus.value());
        ArrayList<HashMap<String, Object>> mentionInfoList = new ArrayList<>();
        for (ZIMMessageMentionedInfo info : conversation.mentionedInfoList) {
            HashMap<String, Object> mentionInfo = new HashMap<String, Object>();
            mentionInfo.put("fromUserID", info.fromUserID);
            mentionInfo.put("messageID", info.messageID);
            mentionInfo.put("messageSeq", info.messageSeq);
            mentionInfo.put("type", info.type.value());
            mentionInfoList.add(mentionInfo);
        }
        conversationMap.put("mentionedInfoList", mentionInfoList);
        if (conversation.lastMessage != null) {
            conversationMap.put("lastMessage", mZIMMessage(conversation.lastMessage));
        } else {
            conversationMap.put("lastMessage", null);
        }
        conversationMap.put("isPinned", conversation.isPinned);
        conversationMap.put("draft", conversation.draft);
        conversationMap.put("marks", conversation.marks);
        if (conversation.type == ZIMConversationType.GROUP) {
            if (conversation instanceof ZIMGroupConversation) {
                conversationMap.put("mutedExpiredTime",
                                    ((ZIMGroupConversation)conversation).mutedExpiredTime);
                conversationMap.put("isDisabled", ((ZIMGroupConversation)conversation).isDisabled);
            }
        }
        return conversationMap;
    }

    //    static public ArrayList cnvZIMConversationListToBasicList(ArrayList<ZIMConversation> conversationList){
    //        ArrayList
    //    }

    static public HashMap<String, Object> mZIMMessage(ZIMMessage message) {
        if (message == null) {
            return null;
        }
        HashMap<String, Object> messageMap = new HashMap<>();
        messageMap.put("type", message.getType().value());
        messageMap.put("messageID", message.getMessageID());
        messageMap.put("conversationID", message.getConversationID());
        messageMap.put("conversationSeq", message.getConversationSeq());
        messageMap.put("messageSeq", message.getMessageSeq());
        messageMap.put("senderUserID", message.getSenderUserID());
        messageMap.put("timestamp", message.getTimestamp());
        messageMap.put("localMessageID", message.getLocalMessageID());
        messageMap.put("conversationType", message.getConversationType().value());
        messageMap.put("direction", message.getDirection().value());
        messageMap.put("sentStatus", message.getSentStatus().value());
        messageMap.put("orderKey", message.getOrderKey());
        messageMap.put("isUserInserted", message.isUserInserted());
        messageMap.put("receiptStatus", message.getReceiptStatus().value());
        messageMap.put("extendedData", message.extendedData);
        messageMap.put("localExtendedData", message.localExtendedData);
        messageMap.put("reactions", mZIMMessageReactionList(message.getReactions()));
        messageMap.put("isBroadcastMessage", message.isBroadcastMessage());
        messageMap.put("isServerMessage", message.isServerMessage());
        messageMap.put("mentionedUserIDs", message.getMentionedUserIDs());
        messageMap.put("isMentionAll", message.isMentionAll());
        messageMap.put("cbInnerID", message.getCbInnerID());
        messageMap.put("rootRepliedCount", message.getRootRepliedCount());
        messageMap.put("repliedInfo", mZIMMessageRepliedInfo(message.getRepliedInfo()));
        switch (message.getType()) {
        case TEXT:
            messageMap.put("message", ((ZIMTextMessage)message).message);
            break;
        case COMMAND:
            messageMap.put("message", ((ZIMCommandMessage)message).message);
            break;
        case BARRAGE:

            assert message instanceof ZIMBarrageMessage;
            messageMap.put("message", ((ZIMBarrageMessage)message).message);
            break;
        case IMAGE:
            assert message instanceof ZIMImageMessage;

            messageMap.put("thumbnailDownloadUrl",
                           ((ZIMImageMessage)message).getThumbnailDownloadUrl() != null
                               ? ((ZIMImageMessage)message).getThumbnailDownloadUrl()
                               : "");
            messageMap.put("thumbnailLocalPath",
                           ((ZIMImageMessage)message).getThumbnailLocalPath() != null
                               ? ((ZIMImageMessage)message).getThumbnailLocalPath()
                               : "");
            messageMap.put("largeImageDownloadUrl",
                           ((ZIMImageMessage)message).getLargeImageDownloadUrl() != null
                               ? ((ZIMImageMessage)message).getLargeImageDownloadUrl()
                               : "");
            messageMap.put("largeImageLocalPath",
                           ((ZIMImageMessage)message).getLargeImageLocalPath() != null
                               ? ((ZIMImageMessage)message).getLargeImageLocalPath()
                               : "");
            messageMap.put("originalImageHeight",
                           ((ZIMImageMessage)message).getOriginalImageHeight());
            messageMap.put("originalImageWidth",
                           ((ZIMImageMessage)message).getOriginalImageWidth());
            messageMap.put("largeImageHeight", ((ZIMImageMessage)message).getLargeImageHeight());
            messageMap.put("largeImageWidth", ((ZIMImageMessage)message).getLargeImageWidth());
            messageMap.put("thumbnailHeight", ((ZIMImageMessage)message).getThumbnailHeight());
            messageMap.put("thumbnailWidth", ((ZIMImageMessage)message).getThumbnailWidth());
            break;
        case VIDEO:
            assert message instanceof ZIMVideoMessage;
            messageMap.put("videoDuration", ((ZIMVideoMessage)message).getVideoDuration());
            messageMap.put("videoFirstFrameDownloadUrl",
                           ((ZIMVideoMessage)message).getVideoFirstFrameDownloadUrl());
            messageMap.put("videoFirstFrameLocalPath",
                           ((ZIMVideoMessage)message).getVideoFirstFrameLocalPath());
            messageMap.put("videoFirstFrameHeight",
                           ((ZIMVideoMessage)message).getVideoFirstFrameHeight());
            messageMap.put("videoFirstFrameWidth",
                           ((ZIMVideoMessage)message).getVideoFirstFrameWidth());
            break;
        case AUDIO:
            assert message instanceof ZIMAudioMessage;
            messageMap.put("audioDuration", ((ZIMAudioMessage)message).getAudioDuration());
            break;
        case FILE:
            assert message instanceof ZIMFileMessage;
            break;
        case SYSTEM:
            assert message instanceof ZIMSystemMessage;
            messageMap.put("message", ((ZIMSystemMessage)message).message);
            break;
        case REVOKE:
            assert message instanceof ZIMRevokeMessage;
            messageMap.put("revokeType", ((ZIMRevokeMessage)message).getRevokeType().value());
            messageMap.put("revokeStatus", ((ZIMRevokeMessage)message).getRevokeStatus().value());
            messageMap.put("revokeTimestamp", ((ZIMRevokeMessage)message).getRevokeTimestamp());
            messageMap.put("operatedUserID", ((ZIMRevokeMessage)message).getOperatedUserID());
            messageMap.put("revokeExtendedData",
                           ((ZIMRevokeMessage)message).getRevokeExtendedData());
            messageMap.put("originalMessageType",
                           ((ZIMRevokeMessage)message).getOriginalMessageType().value());
            messageMap.put("originalTextMessageContent",
                           ((ZIMRevokeMessage)message).getOriginalTextMessageContent());
            break;
        case CUSTOM:
            assert message instanceof ZIMCustomMessage;
            messageMap.put("message", ((ZIMCustomMessage)message).message);
            messageMap.put("subType", ((ZIMCustomMessage)message).subType);
            messageMap.put("searchedContent", ((ZIMCustomMessage)message).searchedContent);
            break;
        case COMBINE:
            assert message instanceof ZIMCombineMessage;
            messageMap.put("title", ((ZIMCombineMessage)message).title);
            messageMap.put("summary", ((ZIMCombineMessage)message).summary);
            ArrayList<HashMap<String, Object>> messageListMap = new ArrayList<>();
            for (ZIMMessage zimMessage : ((ZIMCombineMessage)message).messageList) {
                messageListMap.add(mZIMMessage(zimMessage));
            }
            messageMap.put("messageList", messageListMap);
            messageMap.put("combineID", ((ZIMCombineMessage)message).getCombineID());
            break;
        case TIPS:
            assert message instanceof ZIMTipsMessage;
            messageMap.put("event", ((ZIMTipsMessage)message).event.value());
            if (((ZIMTipsMessage)message).operatedUser != null) {
                messageMap.put("operatedUser",
                               mZIMUserInfo(((ZIMTipsMessage)message).operatedUser));
            }
            messageMap.put("targetUserList",
                           mZIMUserInfoList(((ZIMTipsMessage)message).targetUserList));
            if (((ZIMTipsMessage)message).changeInfo != null) {
                messageMap.put("changeInfo",
                               mZIMTipsMessageChangeInfo(((ZIMTipsMessage)message).changeInfo));
            }
        case UNKNOWN:
        default:
            break;
        }
        if (message instanceof ZIMMediaMessage) {
            messageMap.put("fileLocalPath", ((ZIMMediaMessage)message).getFileLocalPath());
            messageMap.put("fileDownloadUrl", ((ZIMMediaMessage)message).getFileDownloadUrl());
            messageMap.put("fileUID", ((ZIMMediaMessage)message).getFileUID());
            messageMap.put("fileName", ((ZIMMediaMessage)message).getFileName());
            messageMap.put("fileSize", ((ZIMMediaMessage)message).getFileSize());
        }
        return messageMap;
    }

    static public ZIMMessage oZIMMessage(HashMap<String, Object> messageMap) {
        if (messageMap == null) {
            return null;
        }
        ZIMMessage message;
        ZIMMessageType type = ZIMMessageType.getZIMMessageType(
            ZIMPluginCommonTools.safeGetIntValue(messageMap.get("type")));
        switch (type) {
        case TEXT:
            message = new ZIMTextMessage();
            ((ZIMTextMessage)message).message = (String)messageMap.get("message");
            break;
        case COMMAND:
            message = new ZIMCommandMessage();
            ((ZIMCommandMessage)message).message = (byte[])messageMap.get("message");
            break;
        case BARRAGE:
            message = new ZIMBarrageMessage();
            ((ZIMBarrageMessage)message).message = (String)messageMap.get("message");
            break;
        case IMAGE:
            message = new ZIMImageMessage((String)messageMap.get("fileLocalPath"));
            ((ZIMImageMessage)message)
                .setThumbnailDownloadUrl((String)messageMap.get("thumbnailDownloadUrl"));
            ((ZIMImageMessage)message)
                .setLargeImageDownloadUrl((String)messageMap.get("largeImageDownloadUrl"));
            try {
                Field thumbnailLocalPathField =
                    ZIMImageMessage.class.getDeclaredField("thumbnailLocalPath");
                thumbnailLocalPathField.setAccessible(true);
                thumbnailLocalPathField.set(message, messageMap.get("thumbnailLocalPath"));
                thumbnailLocalPathField.setAccessible(false);

                Field largeImageLocalPathField =
                    ZIMImageMessage.class.getDeclaredField("largeImageLocalPath");
                largeImageLocalPathField.setAccessible(true);
                largeImageLocalPathField.set(message, messageMap.get("largeImageLocalPath"));
                largeImageLocalPathField.setAccessible(false);

                Field originalImageHeightField =
                    ZIMImageMessage.class.getDeclaredField("originalImageHeight");
                originalImageHeightField.setAccessible(true);
                originalImageHeightField.set(message, messageMap.get("originalImageHeight"));
                originalImageHeightField.setAccessible(false);

                Field originalImageWidthField =
                    ZIMImageMessage.class.getDeclaredField("originalImageWidth");
                originalImageWidthField.setAccessible(true);
                originalImageWidthField.set(message, messageMap.get("originalImageWidth"));
                originalImageWidthField.setAccessible(false);

                Field largeImageHeightField =
                    ZIMImageMessage.class.getDeclaredField("largeImageHeight");
                largeImageHeightField.setAccessible(true);
                largeImageHeightField.set(message, messageMap.get("largeImageHeight"));
                largeImageHeightField.setAccessible(false);

                Field largeImageWidthField =
                    ZIMImageMessage.class.getDeclaredField("largeImageWidth");
                largeImageWidthField.setAccessible(true);
                largeImageWidthField.set(message, messageMap.get("largeImageWidth"));
                largeImageWidthField.setAccessible(false);

                Field thumbnailHeightField =
                    ZIMImageMessage.class.getDeclaredField("thumbnailHeight");
                thumbnailHeightField.setAccessible(true);
                thumbnailHeightField.set(message, messageMap.get("thumbnailHeight"));
                thumbnailHeightField.setAccessible(false);

                Field thumbnailWidthField =
                    ZIMImageMessage.class.getDeclaredField("thumbnailWidth");
                thumbnailWidthField.setAccessible(true);
                thumbnailWidthField.set(message, messageMap.get("thumbnailWidth"));
                thumbnailWidthField.setAccessible(false);

            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            break;
        case FILE:
            message = new ZIMFileMessage((String)messageMap.get("fileLocalPath"));
            break;
        case VIDEO:
            message = new ZIMVideoMessage(
                (String)messageMap.get("fileLocalPath"),
                ZIMPluginCommonTools.safeGetLongValue(messageMap.get("videoDuration")));
            try {
                Field videoFirstFrameDownloadUrlField =
                    ZIMVideoMessage.class.getDeclaredField("videoFirstFrameDownloadUrl");
                videoFirstFrameDownloadUrlField.setAccessible(true);
                videoFirstFrameDownloadUrlField.set(message,
                                                    messageMap.get("videoFirstFrameDownloadUrl"));
                videoFirstFrameDownloadUrlField.setAccessible(false);

                Field videoFirstFrameLocalPathField =
                    ZIMVideoMessage.class.getDeclaredField("videoFirstFrameLocalPath");
                videoFirstFrameLocalPathField.setAccessible(true);
                videoFirstFrameLocalPathField.set(message,
                                                  messageMap.get("videoFirstFrameLocalPath"));
                videoFirstFrameLocalPathField.setAccessible(false);

                Field videoFirstFrameHeightField =
                    ZIMVideoMessage.class.getDeclaredField("videoFirstFrameHeight");
                videoFirstFrameHeightField.setAccessible(true);
                videoFirstFrameHeightField.set(message, messageMap.get("videoFirstFrameHeight"));
                videoFirstFrameHeightField.setAccessible(false);

                Field videoFirstFrameWidthField =
                    ZIMVideoMessage.class.getDeclaredField("videoFirstFrameWidth");
                videoFirstFrameWidthField.setAccessible(true);
                videoFirstFrameWidthField.set(message, messageMap.get("videoFirstFrameWidth"));
                videoFirstFrameWidthField.setAccessible(false);
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            break;
        case AUDIO:
            message = new ZIMAudioMessage(
                (String)messageMap.get("fileLocalPath"),
                ZIMPluginCommonTools.safeGetLongValue(messageMap.get("audioDuration")));
            break;
        case SYSTEM:
            message = new ZIMSystemMessage();
            ((ZIMSystemMessage)message).message = (String)messageMap.get("message");
            break;

        case CUSTOM:
            message = new ZIMCustomMessage("", 0);
            ((ZIMCustomMessage)message).message = (String)messageMap.get("message");
            ((ZIMCustomMessage)message).subType =
                ZIMPluginCommonTools.safeGetIntValue(messageMap.get("subType"));
            ((ZIMCustomMessage)message).searchedContent = (String)messageMap.get("searchedContent");
            break;
        case REVOKE:
            message = new ZIMRevokeMessage();
            try {
                Field revokeTypeField = ZIMRevokeMessage.class.getDeclaredField("revokeType");
                revokeTypeField.setAccessible(true);
                revokeTypeField.set(
                    message, ZIMRevokeType.getZIMRevokeType(ZIMPluginCommonTools.safeGetIntValue(
                                 messageMap.get("revokeType"))));
                revokeTypeField.setAccessible(false);

                Field revokeStatusField = ZIMRevokeMessage.class.getDeclaredField("revokeStatus");
                revokeStatusField.setAccessible(true);
                revokeStatusField.set(message, ZIMMessageRevokeStatus.getZIMMessageRevokeStatus(
                                                   ZIMPluginCommonTools.safeGetIntValue(
                                                       messageMap.get("revokeStatus"))));
                revokeStatusField.setAccessible(false);

                Field originalMessageTypeField =
                    ZIMRevokeMessage.class.getDeclaredField("originalMessageType");
                originalMessageTypeField.setAccessible(true);
                originalMessageTypeField.set(
                    message, ZIMMessageType.getZIMMessageType(ZIMPluginCommonTools.safeGetIntValue(
                                 messageMap.get("originalMessageType"))));
                originalMessageTypeField.setAccessible(false);

                Field revokeTimestampField =
                    ZIMRevokeMessage.class.getDeclaredField("revokeTimestamp");
                revokeTimestampField.setAccessible(true);
                revokeTimestampField.set(message, messageMap.get("revokeTimestamp"));
                revokeTimestampField.setAccessible(false);

                Field operatedUserIDField =
                    ZIMRevokeMessage.class.getDeclaredField("operatedUserID");
                operatedUserIDField.setAccessible(true);
                operatedUserIDField.set(message, messageMap.get("operatedUserID"));
                operatedUserIDField.setAccessible(false);

                Field revokeExtendedDataField =
                    ZIMRevokeMessage.class.getDeclaredField("revokeExtendedData");
                revokeExtendedDataField.setAccessible(true);
                revokeExtendedDataField.set(message, messageMap.get("revokeExtendedData"));
                revokeExtendedDataField.setAccessible(false);

                Field originalTextMessageContentField =
                    ZIMRevokeMessage.class.getDeclaredField("originalTextMessageContent");
                originalTextMessageContentField.setAccessible(true);
                originalTextMessageContentField.set(message,
                                                    messageMap.get("originalTextMessageContent"));
                originalTextMessageContentField.setAccessible(false);
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            break;
        case COMBINE:
            ArrayList<ZIMMessage> messagesList = new ArrayList<>();
            for (HashMap<String, Object> map :
                 (ArrayList<HashMap<String, Object>>)messageMap.get("messageList")) {
                messagesList.add(oZIMMessage(map));
            }
            message = new ZIMCombineMessage((String)messageMap.get("title"),
                                            (String)messageMap.get("summary"), messagesList);
            try {
                Field combineID = ZIMCombineMessage.class.getDeclaredField("combineID");
                combineID.setAccessible(true);
                combineID.set(message, messageMap.get("combineID"));
                combineID.setAccessible(false);
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
            break;
        case TIPS:
            message = new ZIMTipsMessage();
            break;
        case UNKNOWN:
        default:
            message = new ZIMMessage(ZIMMessageType.UNKNOWN);
            break;
        }

        if (message instanceof ZIMMediaMessage) {
            ((ZIMMediaMessage)message)
                .setFileDownloadUrl((String)messageMap.get("fileDownloadUrl"));
            try {
                Field fileUIDField = ZIMMediaMessage.class.getDeclaredField("fileUID");
                fileUIDField.setAccessible(true);
                fileUIDField.set(message, messageMap.get("fileUID"));
                fileUIDField.setAccessible(false);

                Field fileNameField = ZIMMediaMessage.class.getDeclaredField("fileName");
                fileNameField.setAccessible(true);
                fileNameField.set(message, messageMap.get("fileName"));
                fileNameField.setAccessible(false);

                Field fileSizeField = ZIMMediaMessage.class.getDeclaredField("fileSize");
                fileSizeField.setAccessible(true);
                fileSizeField.set(message,
                                  ZIMPluginCommonTools.safeGetIntValue(messageMap.get("fileSize")));
                fileSizeField.setAccessible(false);

            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        try {
            Field msgTypeField = ZIMMessage.class.getDeclaredField("type");
            msgTypeField.setAccessible(true);
            msgTypeField.set(message,
                             ZIMMessageType.getZIMMessageType(
                                 ZIMPluginCommonTools.safeGetIntValue(messageMap.get("type"))));
            msgTypeField.setAccessible(false);

            Field messageIDField = ZIMMessage.class.getDeclaredField("messageID");
            messageIDField.setAccessible(true);
            messageIDField.set(message,
                               ZIMPluginCommonTools.safeGetLongValue(messageMap.get("messageID")));
            messageIDField.setAccessible(false);

            Field conversationIDField = ZIMMessage.class.getDeclaredField("conversationID");
            conversationIDField.setAccessible(true);
            conversationIDField.set(message, messageMap.get("conversationID"));
            conversationIDField.setAccessible(false);

            Field conversationSeqField = ZIMMessage.class.getDeclaredField("conversationSeq");
            conversationSeqField.setAccessible(true);
            conversationSeqField.set(
                message, ZIMPluginCommonTools.safeGetLongValue(messageMap.get("conversationSeq")));
            conversationSeqField.setAccessible(false);

            Field messageSeqField = ZIMMessage.class.getDeclaredField("messageSeq");
            messageSeqField.setAccessible(true);
            messageSeqField.set(
                message, ZIMPluginCommonTools.safeGetLongValue(messageMap.get("messageSeq")));
            messageSeqField.setAccessible(false);

            Field senderUserIDField = ZIMMessage.class.getDeclaredField("senderUserID");
            senderUserIDField.setAccessible(true);
            senderUserIDField.set(message, messageMap.get("senderUserID"));
            senderUserIDField.setAccessible(false);

            Field timestampField = ZIMMessage.class.getDeclaredField("timestamp");
            timestampField.setAccessible(true);
            timestampField.set(message,
                               ZIMPluginCommonTools.safeGetLongValue(messageMap.get("timestamp")));
            timestampField.setAccessible(false);

            Field localMessageIDField = ZIMMessage.class.getDeclaredField("localMessageID");
            localMessageIDField.setAccessible(true);
            localMessageIDField.set(
                message, ZIMPluginCommonTools.safeGetLongValue(messageMap.get("localMessageID")));
            localMessageIDField.setAccessible(false);

            Field conversationTypeField = ZIMMessage.class.getDeclaredField("conversationType");
            conversationTypeField.setAccessible(true);
            conversationTypeField.set(message, ZIMConversationType.getZIMConversationType(
                                                   ZIMPluginCommonTools.safeGetIntValue(
                                                       messageMap.get("conversationType"))));
            conversationTypeField.setAccessible(false);

            Field directionField = ZIMMessage.class.getDeclaredField("direction");
            directionField.setAccessible(true);
            directionField.set(
                message, ZIMMessageDirection.getZIMMessageDirection(
                             ZIMPluginCommonTools.safeGetIntValue(messageMap.get("direction"))));
            directionField.setAccessible(false);

            Field sentStatusField = ZIMMessage.class.getDeclaredField("sentStatus");
            sentStatusField.setAccessible(true);
            sentStatusField.set(
                message, ZIMMessageSentStatus.getZIMMessageSentStatus(
                             ZIMPluginCommonTools.safeGetIntValue(messageMap.get("sentStatus"))));
            sentStatusField.setAccessible(false);

            Field orderKeyField = ZIMMessage.class.getDeclaredField("orderKey");
            orderKeyField.setAccessible(true);
            orderKeyField.set(message,
                              ZIMPluginCommonTools.safeGetLongValue(messageMap.get("orderKey")));
            orderKeyField.setAccessible(false);

            Field isUserInsertedField = ZIMMessage.class.getDeclaredField("isUserInserted");
            isUserInsertedField.setAccessible(true);
            isUserInsertedField.set(
                message, ZIMPluginCommonTools.safeGetBoolValue(messageMap.get("isUserInserted")));
            isUserInsertedField.setAccessible(false);

            Field receiptStatusField = ZIMMessage.class.getDeclaredField("receiptStatus");
            receiptStatusField.setAccessible(true);
            receiptStatusField.set(message, ZIMMessageReceiptStatus.getZIMMessageReceiptStatus(
                                                ZIMPluginCommonTools.safeGetIntValue(
                                                    messageMap.get("receiptStatus"))));
            receiptStatusField.setAccessible(false);

            Field extendedDataField = ZIMMessage.class.getDeclaredField("extendedData");
            extendedDataField.setAccessible(true);
            extendedDataField.set(message, messageMap.get("extendedData"));
            extendedDataField.setAccessible(false);

            Field localExtendedDataField = ZIMMessage.class.getDeclaredField("localExtendedData");
            localExtendedDataField.setAccessible(true);
            localExtendedDataField.set(message, messageMap.get("localExtendedData"));
            localExtendedDataField.setAccessible(false);

            Field isBroadcastMessageField = ZIMMessage.class.getDeclaredField("isBroadcastMessage");
            isBroadcastMessageField.setAccessible(true);
            isBroadcastMessageField.set(message, ZIMPluginCommonTools.safeGetBoolValue(
                                                     messageMap.get("isBroadcastMessage")));
            isBroadcastMessageField.setAccessible(false);

            Field isServerMessageField = ZIMMessage.class.getDeclaredField("isServerMessage");
            isServerMessageField.setAccessible(true);
            isServerMessageField.set(
                message, ZIMPluginCommonTools.safeGetBoolValue(messageMap.get("isServerMessage")));
            isServerMessageField.setAccessible(false);

            Field cbInnerIDField = ZIMMessage.class.getDeclaredField("cbInnerID");
            cbInnerIDField.setAccessible(true);
            cbInnerIDField.set(message, messageMap.get("cbInnerID"));
            cbInnerIDField.setAccessible(false);

            Field rootRepliedCountField = ZIMMessage.class.getDeclaredField("rootRepliedCount");
            rootRepliedCountField.setAccessible(true);
            rootRepliedCountField.set(message, messageMap.get("rootRepliedCount"));
            rootRepliedCountField.setAccessible(false);

            Field repliedInfoField = ZIMMessage.class.getDeclaredField("repliedInfo");
            repliedInfoField.setAccessible(true);
            repliedInfoField.set(
                message, oZIMMessageRepliedInfo(
                             ZIMPluginCommonTools.safeGetHashMap(messageMap.get("repliedInfo"))));
            repliedInfoField.setAccessible(false);

        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        message.setIsMentionAll(
            ZIMPluginCommonTools.safeGetBoolValue(messageMap.get("isMentionAll")));
        ArrayList<String> mentionedUserIds = new ArrayList<>();
        for (String userId : (ArrayList<String>)messageMap.get("mentionedUserIDs")) {
            mentionedUserIds.add(userId);
        }
        message.setMentionedUserIDs(mentionedUserIds);

        return message;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMMessageList(ArrayList<ZIMMessage> messageList) {
        ArrayList<HashMap<String, Object>> messageBasicList = new ArrayList<>();
        for (ZIMMessage message : messageList) {
            messageBasicList.add(mZIMMessage(message));
        }
        return messageBasicList;
    }

    static public ArrayList<ZIMMessage>
    oZIMMessageList(ArrayList<HashMap<String, Object>> basicList) {
        ArrayList<ZIMMessage> messageList = new ArrayList<>();
        for (HashMap<String, Object> messageHashMap : basicList) {
            messageList.add(oZIMMessage(messageHashMap));
        }
        return messageList;
    }

    static public HashMap<String, Object> mZIMMessageReceivedInfo(ZIMMessageReceivedInfo info) {
        if (info == null) {
            return null;
        }

        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("isOfflineMessage", info.isOfflineMessage);

        return infoMap;
    }

    static public HashMap<String, Object> mZIMMessageRepliedInfo(ZIMMessageRepliedInfo info) {
        if (info == null) {
            return null;
        }

        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("state", info.state.value());
        infoMap.put("messageInfo", mZIMMessageLiteInfo(info.messageInfo));
        infoMap.put("senderUserID", info.senderUserID);
        infoMap.put("messageID", info.messageID);
        infoMap.put("messageSeq", info.messageSeq);
        infoMap.put("sentTime", info.sentTime);

        return infoMap;
    }

    static public HashMap<String, Object> mZIMMessageLiteInfo(ZIMMessageLiteInfo info) {
        if (info == null) {
            return null;
        }

        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("type", info.type.value());
        switch (info.type) {
        case TEXT:
            ZIMTextMessageLiteInfo textLiteInfo = (ZIMTextMessageLiteInfo)info;
            infoMap.put("message", textLiteInfo.message);
            break;
        case CUSTOM:
            ZIMCustomMessageLiteInfo customLiteInfo = (ZIMCustomMessageLiteInfo)info;
            infoMap.put("message", customLiteInfo.message);
            infoMap.put("subType", customLiteInfo.subType);
            break;
        case COMBINE:
            ZIMCombineMessageLiteInfo cbLiteInfo = (ZIMCombineMessageLiteInfo)info;
            infoMap.put("title", cbLiteInfo.title);
            infoMap.put("summary", cbLiteInfo.summary);
            break;
        case IMAGE:
            ZIMImageMessageLiteInfo imageLiteInfo = (ZIMImageMessageLiteInfo)info;
            infoMap.put("fileName", imageLiteInfo.fileName);
            infoMap.put("fileSize", imageLiteInfo.fileSize);
            infoMap.put("fileDownloadUrl", imageLiteInfo.fileDownloadUrl);
            infoMap.put("fileLocalPath", imageLiteInfo.fileLocalPath);
            infoMap.put("originalImageWidth", imageLiteInfo.originalImageWidth);
            infoMap.put("originalImageHeight", imageLiteInfo.originalImageHeight);
            infoMap.put("largeImageDownloadUrl", imageLiteInfo.largeImageDownloadUrl);
            infoMap.put("largeImageLocalPath", imageLiteInfo.largeImageLocalPath);
            infoMap.put("largeImageWidth", imageLiteInfo.largeImageWidth);
            infoMap.put("largeImageHeight", imageLiteInfo.largeImageHeight);
            infoMap.put("thumbnailDownloadUrl", imageLiteInfo.thumbnailDownloadUrl);
            infoMap.put("thumbnailLocalPath", imageLiteInfo.thumbnailLocalPath);
            infoMap.put("thumbnailWidth", imageLiteInfo.thumbnailWidth);
            infoMap.put("thumbnailHeight", imageLiteInfo.thumbnailHeight);
            break;
        case FILE:
            ZIMFileMessageLiteInfo fileLiteInfo = (ZIMFileMessageLiteInfo)info;
            infoMap.put("fileName", fileLiteInfo.fileName);
            infoMap.put("fileSize", fileLiteInfo.fileSize);
            infoMap.put("fileDownloadUrl", fileLiteInfo.fileDownloadUrl);
            infoMap.put("fileLocalPath", fileLiteInfo.fileLocalPath);
            break;
        case AUDIO:
            ZIMAudioMessageLiteInfo audioLiteInfo = (ZIMAudioMessageLiteInfo)info;
            infoMap.put("fileName", audioLiteInfo.fileName);
            infoMap.put("fileSize", audioLiteInfo.fileSize);
            infoMap.put("fileDownloadUrl", audioLiteInfo.fileDownloadUrl);
            infoMap.put("fileLocalPath", audioLiteInfo.fileLocalPath);
            infoMap.put("audioDuration", audioLiteInfo.audioDuration);
            break;
        case VIDEO:
            ZIMVideoMessageLiteInfo videoLiteInfo = (ZIMVideoMessageLiteInfo)info;
            infoMap.put("fileName", videoLiteInfo.fileName);
            infoMap.put("fileSize", videoLiteInfo.fileSize);
            infoMap.put("fileDownloadUrl", videoLiteInfo.fileDownloadUrl);
            infoMap.put("fileLocalPath", videoLiteInfo.fileLocalPath);
            infoMap.put("videoDuration", videoLiteInfo.videoDuration);
            infoMap.put("videoFirstFrameDownloadUrl", videoLiteInfo.videoFirstFrameDownloadUrl);
            infoMap.put("videoFirstFrameLocalPath", videoLiteInfo.videoFirstFrameLocalPath);
            infoMap.put("videoFirstFrameWidth", videoLiteInfo.videoFirstFrameWidth);
            infoMap.put("videoFirstFrameHeight", videoLiteInfo.videoFirstFrameHeight);
            break;
        default:
            break;
        }

        return infoMap;
    }

    static public ZIMMessageRepliedInfo oZIMMessageRepliedInfo(HashMap<String, Object> infoMap) {
        if (infoMap == null) {
            return null;
        }

        ZIMMessageRepliedInfo info = new ZIMMessageRepliedInfo();
        info.state = ZIMMessageRepliedInfoState.getZIMMessageRepliedInfoState(
            ZIMPluginCommonTools.safeGetIntValue(infoMap.get("state")));
        info.messageInfo =
            oZIMMessageLiteInfo(ZIMPluginCommonTools.safeGetHashMap(infoMap.get("messageInfo")));
        info.messageID = ZIMPluginCommonTools.safeGetLongValue(infoMap.get("messageID"));
        info.messageSeq = ZIMPluginCommonTools.safeGetLongValue(infoMap.get("messageSeq"));
        info.senderUserID = (String)infoMap.get("senderUserID");
        info.sentTime = ZIMPluginCommonTools.safeGetLongValue(infoMap.get("sentTime"));

        return info;
    }

    static public ZIMMessageLiteInfo oZIMMessageLiteInfo(HashMap<String, Object> infoMap) {
        if (infoMap == null) {
            return null;
        }

        ZIMMessageLiteInfo info = null;
        ZIMMessageType messageType = ZIMMessageType.getZIMMessageType(
            ZIMPluginCommonTools.safeGetIntValue(infoMap.get("type")));
        switch (messageType) {
        case TEXT:
            info = new ZIMTextMessageLiteInfo();
            ZIMTextMessageLiteInfo textLiteInfo = (ZIMTextMessageLiteInfo)info;
            textLiteInfo.message = (String)infoMap.get("message");
            break;
        case CUSTOM:
            info = new ZIMCustomMessageLiteInfo();
            ZIMCustomMessageLiteInfo customLiteInfo = (ZIMCustomMessageLiteInfo)info;
            customLiteInfo.message = (String)infoMap.get("message");
            customLiteInfo.subType = ZIMPluginCommonTools.safeGetIntValue(infoMap.get("subType"));
            break;
        case COMBINE:
            info = new ZIMCombineMessageLiteInfo();
            ZIMCombineMessageLiteInfo cbLiteInfo = (ZIMCombineMessageLiteInfo)info;
            cbLiteInfo.title = (String)infoMap.get("title");
            cbLiteInfo.summary = (String)infoMap.get("summary");
            break;
        case REVOKE:
            info = new ZIMRevokeMessageLiteInfo();
            break;
        case IMAGE:
            info = new ZIMImageMessageLiteInfo();
            ZIMImageMessageLiteInfo imageLiteInfo = (ZIMImageMessageLiteInfo)info;
            imageLiteInfo.originalImageWidth =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("originalImageWidth"));
            imageLiteInfo.originalImageHeight =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("originalImageHeight"));
            imageLiteInfo.largeImageDownloadUrl = (String)infoMap.get("largeImageDownloadUrl");
            imageLiteInfo.largeImageLocalPath = (String)infoMap.get("largeImageLocalPath");
            imageLiteInfo.largeImageWidth =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("largeImageWidth"));
            imageLiteInfo.largeImageHeight =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("largeImageHeight"));
            imageLiteInfo.thumbnailDownloadUrl = (String)infoMap.get("thumbnailDownloadUrl");
            imageLiteInfo.thumbnailLocalPath = (String)infoMap.get("thumbnailLocalPath");
            imageLiteInfo.thumbnailWidth =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("thumbnailWidth"));
            imageLiteInfo.thumbnailHeight =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("thumbnailHeight"));
            break;
        case FILE:
            info = new ZIMFileMessageLiteInfo();
            break;
        case AUDIO:
            info = new ZIMAudioMessageLiteInfo();
            ZIMAudioMessageLiteInfo audioLiteInfo = (ZIMAudioMessageLiteInfo)info;
            audioLiteInfo.audioDuration =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("audioDuration"));
            break;
        case VIDEO:
            info = new ZIMVideoMessageLiteInfo();
            ZIMVideoMessageLiteInfo videoLiteInfo = (ZIMVideoMessageLiteInfo)info;
            videoLiteInfo.videoDuration =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("videoDuration"));
            videoLiteInfo.videoFirstFrameDownloadUrl =
                (String)infoMap.get("videoFirstFrameDownloadUrl");
            videoLiteInfo.videoFirstFrameLocalPath =
                (String)infoMap.get("videoFirstFrameLocalPath");
            videoLiteInfo.videoFirstFrameWidth =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("videoFirstFrameWidth"));
            videoLiteInfo.videoFirstFrameHeight =
                ZIMPluginCommonTools.safeGetIntValue(infoMap.get("videoFirstFrameHeight"));
            break;
        default:
            info = new ZIMMessageLiteInfo();
            break;
        }

        if (info instanceof ZIMMediaMessageLiteInfo) {
            ZIMMediaMessageLiteInfo mediaLiteInfo = (ZIMMediaMessageLiteInfo)info;
            mediaLiteInfo.fileName = (String)infoMap.get("fileName");
            mediaLiteInfo.fileDownloadUrl = (String)infoMap.get("fileDownloadUrl");
            mediaLiteInfo.fileLocalPath = (String)infoMap.get("fileLocalPath");
            mediaLiteInfo.fileSize = ZIMPluginCommonTools.safeGetIntValue(infoMap.get("fileSize"));
        }

        return info;
    }

    static public HashMap<String, Object>
    mZIMMessageRootRepliedInfo(ZIMMessageRootRepliedInfo info) {
        if (info == null) {
            return null;
        }

        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("state", info.state.value());
        infoMap.put("message", mZIMMessage(info.message));
        infoMap.put("senderUserID", info.senderUserID);
        infoMap.put("sentTime", info.sentTime);
        infoMap.put("repliedCount", info.repliedCount);

        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMMessageRootRepliedCountInfo(ZIMMessageRootRepliedCountInfo info) {
        if (info == null) {
            return null;
        }

        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("conversationID", info.conversationID);
        infoMap.put("conversationType", info.conversationType.value());
        infoMap.put("messageID", info.messageID);
        infoMap.put("count", info.count);

        return infoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMMessageRootRepliedCountInfoList(ArrayList<ZIMMessageRootRepliedCountInfo> infoList) {
        if (infoList == null) {
            return null;
        }

        ArrayList<HashMap<String, Object>> infoMapArray = new ArrayList<>();
        for (ZIMMessageRootRepliedCountInfo info : infoList) {
            HashMap<String, Object> infoMap = mZIMMessageRootRepliedCountInfo(info);
            if (infoMap != null) {
                infoMapArray.add(infoMap);
            }
        }

        return infoMapArray;
    }

    static public HashMap<String, Object> mZIMMessageReceiptInfo(ZIMMessageReceiptInfo info) {
        HashMap<String, Object> infoModel = new HashMap<>();
        infoModel.put("conversationID", info.conversationID);
        infoModel.put("conversationType", info.conversationType.value());
        infoModel.put("messageID", info.messageID);
        infoModel.put("status", info.status.value());
        infoModel.put("readMemberCount", info.readMemberCount);
        infoModel.put("unreadMemberCount", info.unreadMemberCount);
        infoModel.put("isSelfOperated", info.isSelfOperated);
        return infoModel;
    }

    static public ZIMMessageRepliedListQueryConfig
    oZIMMessageRepliedListQueryConfig(HashMap<String, Object> configMap) {
        ZIMMessageRepliedListQueryConfig config = new ZIMMessageRepliedListQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetLongValue(configMap.get("nextFlag"));

        return config;
    }

    static public ZIMMessageSearchConfig
    oZIMMessageSearchConfig(HashMap<String, Object> configMap) {
        ZIMMessageSearchConfig config = new ZIMMessageSearchConfig();
        config.nextMessage =
            oZIMMessage(ZIMPluginCommonTools.safeGetHashMap(configMap.get("nextMessage")));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.order = ZIMMessageOrder.getZIMMessageOrder(
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("order")));
        config.keywords = (ArrayList<String>)configMap.get("keywords");
        config.subMessageTypes = (ArrayList<Integer>)configMap.get("subMessageTypes");
        config.senderUserIDs = (ArrayList<String>)configMap.get("senderUserIDs");
        ArrayList<ZIMMessageType> messageTypes = new ArrayList<>();
        for (Integer msgType : (ArrayList<Integer>)configMap.get("messageTypes")) {
            messageTypes.add(ZIMMessageType.getZIMMessageType(msgType.intValue()));
        }
        config.messageTypes = messageTypes;
        config.startTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("startTime"));
        config.endTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("endTime"));

        return config;
    }

    static public ZIMFileCacheClearConfig
    oZIMFileCacheClearConfig(HashMap<String, Object> configMap) {
        ZIMFileCacheClearConfig config = new ZIMFileCacheClearConfig();
        config.endTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("endTime"));
        return config;
    }

    static public ZIMFileCacheQueryConfig
    oZIMFileCacheQueryConfig(HashMap<String, Object> configMap) {
        ZIMFileCacheQueryConfig config = new ZIMFileCacheQueryConfig();
        config.endTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("endTime"));
        return config;
    }

    static public HashMap<String, Object> mZIMFileCacheInfo(ZIMFileCacheInfo fileCacheInfo) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("totalFileSize", fileCacheInfo.totalFileSize);

        return infoMap;
    }

    static public ZIMFriendSearchConfig oZIMFriendSearchConfig(HashMap<String, Object> configMap) {
        ZIMFriendSearchConfig config = new ZIMFriendSearchConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        config.keywords = (ArrayList<String>)configMap.get("keywords");
        config.isAlsoMatchFriendAlias =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoMatchFriendAlias"));
        return config;
    }

    static public ZIMConversationSearchConfig
    oZIMConversationMessageGlobalSearchConfig(HashMap<String, Object> configMap) {
        ZIMConversationSearchConfig config = new ZIMConversationSearchConfig();
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        config.totalConversationCount =
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("totalConversationCount"));
        config.conversationMessageCount =
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("conversationMessageCount"));
        config.keywords = (ArrayList<String>)configMap.get("keywords");
        config.subMessageTypes = (ArrayList<Integer>)configMap.get("subMessageTypes");
        config.senderUserIDs = (ArrayList<String>)configMap.get("senderUserIDs");
        ArrayList<ZIMMessageType> messageTypes = new ArrayList<>();
        for (Integer msgType : (ArrayList<Integer>)configMap.get("messageTypes")) {
            messageTypes.add(ZIMMessageType.getZIMMessageType(msgType.intValue()));
        }
        config.messageTypes = messageTypes;
        config.startTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("startTime"));
        config.endTime = ZIMPluginCommonTools.safeGetLongValue(configMap.get("endTime"));

        return config;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMConversationSearchInfoList(ArrayList<ZIMConversationSearchInfo> globalInfoList) {
        ArrayList<HashMap<String, Object>> mapInfoList = new ArrayList<>();
        for (ZIMConversationSearchInfo info : globalInfoList) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("conversationID", info.conversationID);
            map.put("conversationType", info.conversationType.value());
            map.put("totalMessageCount", info.totalMessageCount);
            map.put("messageList", mZIMMessageList(info.messageList));
            mapInfoList.add(map);
        }

        return mapInfoList;
    }

    static public HashMap<String, Object>
    mZIMConversationsAllDeletedInfo(ZIMConversationsAllDeletedInfo conversationsAllDeletedInfo) {
        HashMap<String, Object> conversationsAllDeletedInfoMap = new HashMap<>();
        conversationsAllDeletedInfoMap.put("count", conversationsAllDeletedInfo.count);

        return conversationsAllDeletedInfoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMUserInfoList(ArrayList<ZIMUserInfo> userList) {
        ArrayList<HashMap<String, Object>> userInfoBasicList = new ArrayList<>();
        for (ZIMUserInfo userInfo : userList) {
            userInfoBasicList.add(mZIMUserInfo(userInfo));
        }
        return userInfoBasicList;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMRoomMemberInfoList(ArrayList<ZIMRoomMemberInfo> userList) {
        ArrayList<HashMap<String, Object>> userInfoBasicList = new ArrayList<>();
        for (ZIMRoomMemberInfo userInfo : userList) {
            userInfoBasicList.add(mZIMRoomMemberInfo(userInfo));
        }
        return userInfoBasicList;
    }

    static public HashMap<String, Object> mZIMUserFullInfo(ZIMUserFullInfo userFullInfo) {
        HashMap<String, Object> userFullInfoMap = new HashMap<>();
        userFullInfoMap.put("userAvatarUrl", userFullInfo.userAvatarUrl);
        userFullInfoMap.put("extendedData", userFullInfo.extendedData);
        HashMap<String, Object> baseInfoMap = mZIMUserInfo(userFullInfo.baseInfo);
        userFullInfoMap.put("baseInfo", baseInfoMap);
        return userFullInfoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMUserFullInfoList(ArrayList<ZIMUserFullInfo> userFullInfoList) {
        ArrayList<HashMap<String, Object>> userFullInfoBasicList = new ArrayList<>();
        for (ZIMUserFullInfo userFullInfo : userFullInfoList) {
            userFullInfoBasicList.add(mZIMUserFullInfo(userFullInfo));
        }
        return userFullInfoBasicList;
    }

    static public HashMap<String, Object> mZIMUserInfo(ZIMUserInfo userInfo) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID", userInfo.userID);
        userInfoMap.put("userName", userInfo.userName);
        userInfoMap.put("userAvatarUrl", userInfo.userAvatarUrl);
        if (userInfo instanceof ZIMGroupMemberSimpleInfo) {
            userInfoMap.put("memberNickname", ((ZIMGroupMemberSimpleInfo)userInfo).memberNickname);
            userInfoMap.put("memberRole", ((ZIMGroupMemberSimpleInfo)userInfo).memberRole);
            userInfoMap.put("classType", "ZIMGroupMemberSimpleInfo");
        } else if (userInfo instanceof ZIMGroupMemberInfo) {
            userInfoMap.put("memberNickname", ((ZIMGroupMemberInfo)userInfo).memberNickname);
            userInfoMap.put("memberRole", ((ZIMGroupMemberInfo)userInfo).memberRole);
            userInfoMap.put("memberAvatarUrl", ((ZIMGroupMemberInfo)userInfo).memberAvatarUrl);
            userInfoMap.put("muteExpiredTime", ((ZIMGroupMemberInfo)userInfo).muteExpiredTime);
            userInfoMap.put("classType", "ZIMGroupMemberInfo");
        } else if (userInfo instanceof ZIMFriendInfo) {
            userInfoMap.put("friendAlias", ((ZIMFriendInfo)userInfo).friendAlias);
            userInfoMap.put("createTime", ((ZIMFriendInfo)userInfo).createTime);
            userInfoMap.put("wording", ((ZIMFriendInfo)userInfo).wording);
            userInfoMap.put("friendAttributes", ((ZIMFriendInfo)userInfo).friendAttributes);
            userInfoMap.put("classType", "ZIMFriendInfo");
        }
        return userInfoMap;
    }

    static ZIMUserOfflinePushRule
    oZIMUserOfflinePushRule(HashMap<String, Object> offlinePushRuleMap) {
        ZIMUserOfflinePushRule userOfflinePushRule = new ZIMUserOfflinePushRule();
        userOfflinePushRule.onlinePlatforms =
            (ArrayList<Integer>)offlinePushRuleMap.get("onlinePlatforms");
        userOfflinePushRule.notToReceiveOfflinePushPlatforms =
            (ArrayList<Integer>)offlinePushRuleMap.get("notToReceiveOfflinePushPlatforms");
        return userOfflinePushRule;
    }

    static public HashMap<String, Object>
    mZIMUserOfflinePushRule(ZIMUserOfflinePushRule offlinePushRule) {
        HashMap<String, Object> userOfflinePushRuleMap = new HashMap<>();
        userOfflinePushRuleMap.put("onlinePlatforms", offlinePushRule.onlinePlatforms);
        userOfflinePushRuleMap.put("notToReceiveOfflinePushPlatforms",
                                   offlinePushRule.notToReceiveOfflinePushPlatforms);
        return userOfflinePushRuleMap;
    }

    static public HashMap<String, Object> mZIMUserRule(ZIMUserRule userRule) {
        HashMap<String, Object> userRuleMap = new HashMap<>();
        userRuleMap.put("offlinePushRule",
                        ZIMPluginConverter.mZIMUserOfflinePushRule(userRule.offlinePushRule));
        return userRuleMap;
    }

    static public HashMap<String, Object> mZIMSelfUserInfo(ZIMSelfUserInfo selfUserInfo) {
        HashMap<String, Object> selfInfoMap = new HashMap<>();
        selfInfoMap.put("userRule", ZIMPluginConverter.mZIMUserRule(selfUserInfo.userRule));
        selfInfoMap.put("userFullInfo",
                        ZIMPluginConverter.mZIMUserFullInfo(selfUserInfo.userFullInfo));
        return selfInfoMap;
    }

    static public ZIMUserInfo oZIMUserInfo(HashMap<String, Object> map, ZIMUserInfo userInfo) {
        if (userInfo == null) {
            String classType = "";
            if (map.containsKey("classType")) {
                classType = (String)map.get("classType");
            }
            switch (classType) {
            case "ZIMGroupMemberSimpleInfo":
                userInfo = new ZIMGroupMemberSimpleInfo();
                break;
            case "ZIMGroupMemberInfo":
                userInfo = new ZIMGroupMemberInfo();
                break;
            case "ZIMFriendInfo":
                userInfo = new ZIMFriendInfo();
                break;
            default:
                userInfo = new ZIMUserInfo();
            }
        }

        userInfo.userID = (String)map.get("userID");
        userInfo.userName = (String)map.get("userName");
        userInfo.userAvatarUrl = (String)map.get("userAvatarUrl");
        if (userInfo instanceof ZIMGroupMemberSimpleInfo) {
            ((ZIMGroupMemberSimpleInfo)userInfo).memberNickname = (String)map.get("memberNickname");
            ((ZIMGroupMemberSimpleInfo)userInfo).memberRole = (int)map.get("memberRole");
        } else if (userInfo instanceof ZIMGroupMemberInfo) {
            ((ZIMGroupMemberInfo)userInfo).memberNickname = (String)map.get("memberNickname");
            ((ZIMGroupMemberInfo)userInfo).memberRole = (int)map.get("memberRole");
            ((ZIMGroupMemberInfo)userInfo).memberAvatarUrl = (String)map.get("memberAvatarUrl");
            ((ZIMGroupMemberInfo)userInfo).muteExpiredTime = (long)map.get("muteExpiredTime");
        } else if (userInfo instanceof ZIMFriendInfo) {
            ((ZIMFriendInfo)userInfo).friendAlias = (String)map.get("friendAlias");
            ((ZIMFriendInfo)userInfo).createTime = (long)map.get("createTime");
            ((ZIMFriendInfo)userInfo).wording = (String)map.get("wording");
            ((ZIMFriendInfo)userInfo).friendAttributes =
                (HashMap<String, String>)map.get("friendAttributes");
        }
        return userInfo;
    }

    static public ZIMUserInfo oZIMUserInfo(HashMap<String, Object> map) {
        return oZIMUserInfo(map, null);
    }

    static public HashMap<String, Object> mZIMRoomMemberInfo(ZIMRoomMemberInfo userInfo) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID", userInfo.userID);
        userInfoMap.put("userName", userInfo.userName);
        return userInfoMap;
    }

    static public HashMap<String, Object> mZIMErrorUserInfo(ZIMErrorUserInfo errorUserInfo) {
        HashMap<String, Object> errorUserInfoMap = new HashMap<>();
        errorUserInfoMap.put("userID", errorUserInfo.userID);
        errorUserInfoMap.put("reason", errorUserInfo.reason);
        return errorUserInfoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMErrorUserInfoList(ArrayList<ZIMErrorUserInfo> errorUserList) {
        ArrayList<HashMap<String, Object>> errorUserInfoBasicList = new ArrayList<>();
        for (ZIMErrorUserInfo errorUserInfo : errorUserList) {
            errorUserInfoBasicList.add(mZIMErrorUserInfo(errorUserInfo));
        }
        return errorUserInfoBasicList;
    }

    static public ZIMConversationQueryConfig
    oZIMConversationQueryConfig(HashMap<String, Object> resultMap) {
        ZIMConversationQueryConfig queryConfig = new ZIMConversationQueryConfig();
        queryConfig.count = ZIMPluginCommonTools.safeGetIntValue(resultMap.get("count"));
        queryConfig.nextConversation = oZIMConversation(
            ZIMPluginCommonTools.safeGetHashMap(resultMap.get("nextConversation")));

        return queryConfig;
    }

    static public ZIMConversationFilterOption
    oZIMConversationFilterOption(HashMap<String, Object> resultMap) {
        ZIMConversationFilterOption option = new ZIMConversationFilterOption();
        Object optionValue = resultMap.get("marks");

        if (optionValue instanceof ArrayList) {
            ArrayList<?> list = (ArrayList<?>)optionValue;
            if (list.stream().allMatch(Integer.class ::isInstance)) {
                option.marks = (ArrayList<Integer>)list;
            } else {
                throw new IllegalArgumentException(
                    "The 'option' value is not an ArrayList of Integers.");
            }
        } else {
            throw new IllegalArgumentException("The 'option' key does not map to an ArrayList.");
        }

        Object types = resultMap.get("conversationTypes");
        ArrayList<ZIMConversationType> typesList = new ArrayList<ZIMConversationType>();
        if (types instanceof ArrayList) {
            ArrayList<?> list = (ArrayList<?>)types;
            if (list.stream().allMatch(Integer.class ::isInstance)) {
                ArrayList<Integer> intList = (ArrayList<Integer>)list;
                for (Integer integer : intList) {
                    typesList.add(ZIMConversationType.getZIMConversationType(integer.intValue()));
                }
                option.conversationTypes = typesList;
            } else {
                throw new IllegalArgumentException(
                    "The 'conversationTypes' value is not an ArrayList of Integers.");
            }
        } else {
            throw new IllegalArgumentException(
                "The 'conversationTypes' key does not map to an ArrayList.");
        }

        Object isOnlyUnreadConversationObj = resultMap.get("isOnlyUnreadConversation");
        if (isOnlyUnreadConversationObj instanceof Boolean) {
            option.isOnlyUnreadConversation = ((Boolean)isOnlyUnreadConversationObj).booleanValue();
        } else {
            throw new IllegalArgumentException(
                "The 'isOnlyUnreadConversation' key does not map to an ArrayList.");
        }
        return option;
    }

    static public ZIMConversationTotalUnreadMessageCountQueryConfig
    oZIMConversationTotalUnreadMessageCountQueryConfig(HashMap<String, Object> resultMap) {
        ZIMConversationTotalUnreadMessageCountQueryConfig config =
            new ZIMConversationTotalUnreadMessageCountQueryConfig();
        Object configValue = resultMap.get("marks");

        if (configValue instanceof ArrayList) {
            ArrayList<?> list = (ArrayList<?>)configValue;
            if (list.stream().allMatch(Integer.class ::isInstance)) {
                config.marks = (ArrayList<Integer>)list;
            } else {
                throw new IllegalArgumentException(
                    "The 'config' value is not an ArrayList of Integers.");
            }
        } else {
            throw new IllegalArgumentException("The 'config' key does not map to an ArrayList.");
        }

        Object types = resultMap.get("conversationTypes");
        ArrayList<ZIMConversationType> typesList = new ArrayList<ZIMConversationType>();
        if (types instanceof ArrayList) {
            ArrayList<?> list = (ArrayList<?>)types;
            if (list.stream().allMatch(Integer.class ::isInstance)) {
                ArrayList<Integer> intList = (ArrayList<Integer>)list;
                for (Integer integer : intList) {
                    typesList.add(ZIMConversationType.getZIMConversationType(integer.intValue()));
                }
                config.conversationTypes = typesList;
            } else {
                throw new IllegalArgumentException(
                    "The 'conversationTypes' value is not an ArrayList of Integers.");
            }
        } else {
            throw new IllegalArgumentException(
                "The 'conversationTypes' key does not map to an ArrayList.");
        }

        return config;
    }

    static public ZIMConversationBaseInfo
    oZIMConversationBaseInfo(HashMap<String, Object> resultMap) {
        if (resultMap == null)
            return null;
        ZIMConversationBaseInfo conversation = new ZIMConversationBaseInfo();
        conversation.conversationID = (String)resultMap.get("conversationID");
        conversation.conversationType = ZIMConversationType.getZIMConversationType(
            ZIMPluginCommonTools.safeGetIntValue(resultMap.get("conversationType")));
        return conversation;
    }

    static public ArrayList<ZIMConversationBaseInfo>
    oZIMConversationBaseInfoList(ArrayList<HashMap<String, Object>> basicList) {
        ArrayList<ZIMConversationBaseInfo> convList = new ArrayList<>();
        for (HashMap<String, Object> convMap : basicList) {
            convList.add(oZIMConversationBaseInfo(convMap));
        }
        return convList;
    }

    static public ZIMConversation oZIMConversation(HashMap<String, Object> resultMap) {
        if (resultMap == null)
            return null;
        ZIMConversation conversation;
        ZIMConversationType type = ZIMConversationType.getZIMConversationType(
            ZIMPluginCommonTools.safeGetIntValue(resultMap.get("type")));
        if (type == ZIMConversationType.GROUP) {
            conversation = new ZIMGroupConversation();
            if (resultMap.containsKey("mutedExpiredTime") &&
                resultMap.get("mutedExpiredTime") != null) {
                ((ZIMGroupConversation)conversation).mutedExpiredTime =
                    (long)resultMap.get("mutedExpiredTime");
            } else {
                ((ZIMGroupConversation)conversation).mutedExpiredTime = 0L;
            }

            if (resultMap.containsKey("isDisabled") && resultMap.get("isDisabled") != null) {
                ((ZIMGroupConversation)conversation).isDisabled =
                    (boolean)resultMap.get("isDisabled");
            } else {
                ((ZIMGroupConversation)conversation).isDisabled = false;
            }
        } else {
            conversation = new ZIMConversation();
        }
        conversation.conversationID = (String)resultMap.get("conversationID");
        conversation.conversationAlias = (String)resultMap.get("conversationAlias");
        conversation.conversationName = (String)resultMap.get("conversationName");
        conversation.conversationAvatarUrl = (String)resultMap.get("conversationAvatarUrl");
        conversation.type = ZIMConversationType.getZIMConversationType(
            ZIMPluginCommonTools.safeGetIntValue(resultMap.get("type")));
        conversation.unreadMessageCount =
            ZIMPluginCommonTools.safeGetIntValue(resultMap.get("unreadMessageCount"));
        conversation.orderKey = ZIMPluginCommonTools.safeGetLongValue(resultMap.get("orderKey"));
        conversation.notificationStatus =
            ZIMConversationNotificationStatus.getZIMConversationNotificationStatus(
                ZIMPluginCommonTools.safeGetIntValue(resultMap.get("notificationStatus")));
        if (resultMap.get("lastMessage") != null) {
            conversation.lastMessage =
                oZIMMessage((ZIMPluginCommonTools.safeGetHashMap(resultMap.get("lastMessage"))));
        } else {
            conversation.lastMessage = null;
        }
        conversation.isPinned = ZIMPluginCommonTools.safeGetBoolValue(resultMap.get("isPinned"));
        conversation.draft = (String)resultMap.get("draft");
        return conversation;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMConversationList(ArrayList<ZIMConversation> conversationList) {
        ArrayList<HashMap<String, Object>> conversationBasicList = new ArrayList<>();
        for (ZIMConversation conversation : conversationList) {
            conversationBasicList.add(mZIMConversation(conversation));
        }
        return conversationBasicList;
    }

    static public ZIMMessageDeleteConfig
    oZIMMessageDeleteConfig(HashMap<String, Object> configMap) {
        ZIMMessageDeleteConfig config = new ZIMMessageDeleteConfig();
        config.isAlsoDeleteServerMessage =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerMessage"));
        return config;
    }

    static public ZIMConversationDeleteConfig
    oZIMConversationDeleteConfig(HashMap<String, Object> configMap) {
        ZIMConversationDeleteConfig config = new ZIMConversationDeleteConfig();
        config.isAlsoDeleteServerConversation =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoDeleteServerConversation"));
        return config;
    }

    static public ZIMPushConfig oZIMPushConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMPushConfig config = new ZIMPushConfig();
        config.title = (String)Objects.requireNonNull(configMap.get("title"));
        config.content = (String)Objects.requireNonNull(configMap.get("content"));
        config.payload = (String)configMap.get("payload");
        config.resourcesID = (String)configMap.get("resourcesID");
        config.enableBadge = (Boolean)configMap.get("enableBadge");
        config.badgeIncrement = (int)configMap.get("badgeIncrement");
        config.voIPConfig =
            ZIMPluginConverter.oZIMVoIPconfig((HashMap<String, Object>)configMap.get("voIPConfig"));
        return config;
    }

    static public ZIMMessageSendConfig oZIMMessageSendConfig(HashMap<String, Object> configMap) {
        ZIMMessageSendConfig config = new ZIMMessageSendConfig();
        config.priority = ZIMMessagePriority.getZIMMessagePriority(
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("priority")));
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        config.hasReceipt = (boolean)configMap.get("hasReceipt");
        config.isNotifyMentionedUsers = (boolean)configMap.get("isNotifyMentionedUsers");
        return config;
    }

    static public ZIMMessageQueryConfig oZIMMessageQueryConfig(HashMap<String, Object> configMap) {
        ZIMMessageQueryConfig config = new ZIMMessageQueryConfig();
        config.nextMessage =
            oZIMMessage(ZIMPluginCommonTools.safeGetHashMap(configMap.get("nextMessage")));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.reverse = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("reverse"));
        return config;
    }

    static public ZIMRoomInfo oZIMRoomInfo(HashMap<String, Object> configMap) {
        ZIMRoomInfo roomInfo = new ZIMRoomInfo();
        roomInfo.roomID = (String)configMap.get("roomID");
        roomInfo.roomName = (String)configMap.get("roomName");
        return roomInfo;
    }

    static public HashMap<String, Object> mZIMRoomInfo(ZIMRoomInfo roomInfo) {
        HashMap<String, Object> roomInfoMap = new HashMap<>();
        roomInfoMap.put("roomID", roomInfo.roomID);
        roomInfoMap.put("roomName", roomInfo.roomName);
        return roomInfoMap;
    }

    static public ZIMRoomAdvancedConfig oZIMRoomAdvancedConfig(HashMap<String, Object> configMap) {
        ZIMRoomAdvancedConfig config = new ZIMRoomAdvancedConfig();
        if (configMap.get("roomAttributes") != null) {
            config.roomAttributes = (HashMap<String, String>)configMap.get("roomAttributes");
        }
        config.roomDestroyDelayTime =
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("roomDestroyDelayTime"));
        return config;
    }

    static public HashMap<String, Object> mZIMRoomFullInfo(ZIMRoomFullInfo fullInfo) {
        HashMap<String, Object> fullInfoMap = new HashMap<>();
        fullInfoMap.put("baseInfo", mZIMRoomInfo(fullInfo.baseInfo));
        return fullInfoMap;
    }

    static public ZIMRoomMemberQueryConfig
    oZIMRoomMemberQueryConfig(HashMap<String, Object> configMap) {
        ZIMRoomMemberQueryConfig config = new ZIMRoomMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = (String)configMap.get("nextFlag");
        return config;
    }

    static public ZIMRoomAttributesSetConfig
    oZIMRoomAttributesSetConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMRoomAttributesSetConfig config = new ZIMRoomAttributesSetConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMRoomAttributesDeleteConfig
    oZIMRoomAttributesDeleteConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMRoomAttributesDeleteConfig config = new ZIMRoomAttributesDeleteConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        return config;
    }

    static public ZIMRoomAttributesBatchOperationConfig
    oZIMRoomAttributesBatchOperationConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMRoomAttributesBatchOperationConfig config = new ZIMRoomAttributesBatchOperationConfig();
        config.isForce = ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isForce"));
        config.isDeleteAfterOwnerLeft =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        config.isUpdateOwner =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isUpdateOwner"));
        return config;
    }

    static public ZIMRoomMemberAttributesSetConfig
    oZIMRoomMemberAttributesSetConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMRoomMemberAttributesSetConfig config = new ZIMRoomMemberAttributesSetConfig();
        config.isDeleteAfterOwnerLeft =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isDeleteAfterOwnerLeft"));
        return config;
    }

    static public HashMap<String, Object>
    mZIMRoomMemberAttributesInfo(ZIMRoomMemberAttributesInfo info) {
        if (info == null) {
            return null;
        }
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("userID", info.userID);
        infoMap.put("attributes", info.attributes);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMRoomMemberAttributesOperatedInfo(ZIMRoomMemberAttributesOperatedInfo info) {
        if (info == null) {
            return null;
        }
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("errorKeys", info.errorKeys);
        infoMap.put("attributesInfo", mZIMRoomMemberAttributesInfo(info.attributesInfo));
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMRoomMemberAttributesUpdateInfo(ZIMRoomMemberAttributesUpdateInfo info) {
        if (info == null) {
            return null;
        }
        HashMap<String, Object> updateInfoModel = new HashMap<>();
        updateInfoModel.put("attributesInfo", mZIMRoomMemberAttributesInfo(info.attributesInfo));
        return updateInfoModel;
    }

    static public HashMap<String, Object> mZIMRoomOperatedInfo(ZIMRoomOperatedInfo info) {
        if (info == null) {
            return null;
        }
        HashMap<String, Object> infoModel = new HashMap<>();
        infoModel.put("userID", info.userID);
        return infoModel;
    }

    static public ZIMRoomMemberAttributesQueryConfig
    oZIMRoomMemberAttributesQueryConfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMRoomMemberAttributesQueryConfig queryConfig = new ZIMRoomMemberAttributesQueryConfig();
        queryConfig.count = (Integer)configMap.get("count");
        queryConfig.nextFlag = (String)configMap.get("nextFlag");
        return queryConfig;
    }

    static public ZIMGroupInfo oZIMGroupInfo(HashMap<String, Object> infoMap) {
        ZIMGroupInfo groupInfo = new ZIMGroupInfo();
        groupInfo.groupID = (String)infoMap.get("groupID");
        groupInfo.groupName = (String)infoMap.get("groupName");
        groupInfo.groupAvatarUrl = (String)infoMap.get("groupAvatarUrl");
        return groupInfo;
    }

    static public HashMap<String, Object> mZIMGroupInfo(ZIMGroupInfo groupInfo) {
        HashMap<String, Object> groupInfoMap = new HashMap<>();
        groupInfoMap.put("groupID", groupInfo.groupID);
        groupInfoMap.put("groupName", groupInfo.groupName);
        groupInfoMap.put("groupAvatarUrl", groupInfo.groupAvatarUrl);
        return groupInfoMap;
    }

    static public ZIMGroupMuteInfo oZIMGroupMuteInfo(HashMap<String, Object> infoMap) {
        ZIMGroupMuteInfo muteInfo = new ZIMGroupMuteInfo();

        muteInfo.mode = ZIMGroupMuteMode.getZIMGroupMuteMode(
            ZIMPluginCommonTools.safeGetIntValue(infoMap.get("mode")));
        muteInfo.expiredTime = (long)infoMap.get("expiredTime");
        ArrayList<Integer> roles = new ArrayList<>();
        for (Integer role : (ArrayList<Integer>)infoMap.get("roles")) {
            roles.add(role);
        }
        muteInfo.roles = roles;

        return muteInfo;
    }

    static public HashMap<String, Object> mZIMGroupMuteInfo(ZIMGroupMuteInfo muteInfo) {
        HashMap<String, Object> muteInfoMap = new HashMap<>();

        muteInfoMap.put("mode", muteInfo.mode.value());
        muteInfoMap.put("expiredTime", muteInfo.expiredTime);
        muteInfoMap.put("roles", muteInfo.roles);

        return muteInfoMap;
    }

    static public HashMap<String, Object> mZIMGroupFullInfo(ZIMGroupFullInfo groupFullInfo) {
        HashMap<String, Object> groupFullInfoMap = new HashMap<>();
        groupFullInfoMap.put("groupNotice", groupFullInfo.groupNotice);
        groupFullInfoMap.put("groupAlias", groupFullInfo.groupAlias);
        groupFullInfoMap.put("groupAttributes", groupFullInfo.groupAttributes);
        groupFullInfoMap.put("notificationStatus", groupFullInfo.notificationStatus.value());
        groupFullInfoMap.put("baseInfo", mZIMGroupInfo(groupFullInfo.baseInfo));
        groupFullInfoMap.put("mutedInfo", mZIMGroupMuteInfo(groupFullInfo.mutedInfo));
        groupFullInfoMap.put("createTime", groupFullInfo.createTime);
        groupFullInfoMap.put("maxMemberCount", groupFullInfo.maxMemberCount);
        groupFullInfoMap.put("verifyInfo", mZIMGroupVerifyInfo(groupFullInfo.verifyInfo));
        return groupFullInfoMap;
    }

    static public HashMap<String, Object> mZIMGroupEnterInfo(ZIMGroupEnterInfo groupEnterInfo) {
        HashMap<String, Object> groupEnterInfoMap = new HashMap<>();
        groupEnterInfoMap.put("operatedUser",
                              mZIMGroupMemberSimpleInfo(groupEnterInfo.operatedUser));
        groupEnterInfoMap.put("enterTime", groupEnterInfo.enterTime);
        groupEnterInfoMap.put("enterType", groupEnterInfo.enterType.value());
        return groupEnterInfoMap;
    }

    static public HashMap<String, Object> mZIMGroupMemberInfo(ZIMGroupMemberInfo groupMemberInfo) {
        HashMap<String, Object> groupMemberInfoMap = new HashMap<>();
        groupMemberInfoMap.put("memberNickname", groupMemberInfo.memberNickname);
        groupMemberInfoMap.put("memberRole", groupMemberInfo.memberRole);
        groupMemberInfoMap.put("userID", groupMemberInfo.userID);
        groupMemberInfoMap.put("userName", groupMemberInfo.userName);
        groupMemberInfoMap.put("userAvatarUrl", groupMemberInfo.memberAvatarUrl != null
                                                    ? groupMemberInfo.userAvatarUrl
                                                    : "");
        groupMemberInfoMap.put("memberAvatarUrl", groupMemberInfo.memberAvatarUrl != null
                                                      ? groupMemberInfo.memberAvatarUrl
                                                      : "");
        groupMemberInfoMap.put("muteExpiredTime", groupMemberInfo.muteExpiredTime);
        groupMemberInfoMap.put("groupEnterInfo",
                               mZIMGroupEnterInfo(groupMemberInfo.groupEnterInfo));
        return groupMemberInfoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMGroupMemberInfoList(ArrayList<ZIMGroupMemberInfo> groupMemberInfoList) {
        ArrayList<HashMap<String, Object>> basicList = new ArrayList<>();
        for (ZIMGroupMemberInfo groupMemberInfo : groupMemberInfoList) {
            basicList.add(mZIMGroupMemberInfo(groupMemberInfo));
        }
        return basicList;
    }

    static public HashMap<String, Object> mZIMGroupAdvancedConfig(ZIMGroupAdvancedConfig config) {
        HashMap<String, Object> configMap = new HashMap<>();
        configMap.put("groupNotice", config.groupNotice);
        configMap.put("groupAttributes", config.groupAttributes);
        return configMap;
    }

    static public ZIMGroupAdvancedConfig
    oZIMGroupAdvancedConfig(HashMap<String, Object> configMap) {
        ZIMGroupAdvancedConfig config = new ZIMGroupAdvancedConfig();
        Object attributesObj = configMap.get("groupAttributes");
        config.inviteMode =
            ZIMGroupInviteMode.getZIMGroupInviteMode((int)configMap.get("inviteMode"));
        config.joinMode = ZIMGroupJoinMode.getZIMGroupJoinMode((int)configMap.get("joinMode"));
        config.beInviteMode =
            ZIMGroupBeInviteMode.getZIMGroupBeInviteMode((int)configMap.get("beInviteMode"));
        config.maxMemberCount = (int)configMap.get("maxMemberCount");
        if (attributesObj instanceof HashMap<?, ?>) {
            config.groupAttributes = (HashMap<String, String>)attributesObj;
        }
        config.groupNotice = (String)configMap.get("groupNotice");
        return config;
    }

    static public ZIMGroupMuteConfig oZIMGroupMuteConfig(HashMap<String, Object> configMap) {
        ZIMGroupMuteConfig config = new ZIMGroupMuteConfig();
        config.mode = ZIMGroupMuteMode.getZIMGroupMuteMode(
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("mode")));
        config.duration = (int)configMap.get("duration");
        config.roles = (ArrayList<Integer>)configMap.get("roles");
        return config;
    }

    static public ZIMGroupMemberMuteConfig
    oZIMGroupMemberMuteConfig(HashMap<String, Object> configMap) {
        ZIMGroupMemberMuteConfig config = new ZIMGroupMemberMuteConfig();
        config.duration = (int)configMap.get("duration");
        return config;
    }

    static public ZIMGroupMemberMutedListQueryConfig
    oZIMGroupMemberMutedListQueryConfig(HashMap<String, Object> configMap) {
        ZIMGroupMemberMutedListQueryConfig config = new ZIMGroupMemberMutedListQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        return config;
    }

    static public HashMap<String, Object> mZIMGroup(ZIMGroup zimGroup) {
        HashMap<String, Object> zimGroupMap = new HashMap<>();
        zimGroupMap.put("baseInfo", mZIMGroupInfo(zimGroup.baseInfo));
        zimGroupMap.put("groupAlias", zimGroup.groupAlias);
        zimGroupMap.put("notificationStatus", zimGroup.notificationStatus.value());
        return zimGroupMap;
    }

    static public ArrayList<HashMap<String, Object>> mZIMGroupList(ArrayList<ZIMGroup> groupList) {
        ArrayList<HashMap<String, Object>> basicGroupList = new ArrayList<>();
        for (ZIMGroup zimGroup : groupList) {
            basicGroupList.add(mZIMGroup(zimGroup));
        }
        return basicGroupList;
    }

    static public ZIMGroupMemberQueryConfig
    oZIMGroupMemberQueryConfig(HashMap<String, Object> configMap) {
        ZIMGroupMemberQueryConfig config = new ZIMGroupMemberQueryConfig();
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        return config;
    }

    static public ZIMGroupSearchConfig oZIMGroupSearchConfig(HashMap<String, Object> configMap) {
        ZIMGroupSearchConfig config = new ZIMGroupSearchConfig();
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.keywords = (ArrayList<String>)configMap.get("keywords");
        config.isAlsoMatchGroupMemberUserName =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoMatchGroupMemberUserName"));
        config.isAlsoMatchGroupMemberNickname =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoMatchGroupMemberNickname"));

        return config;
    }

    static public ZIMGroupMemberSearchConfig
    oZIMGroupMemberSearchConfig(HashMap<String, Object> configMap) {
        ZIMGroupMemberSearchConfig config = new ZIMGroupMemberSearchConfig();
        config.nextFlag = ZIMPluginCommonTools.safeGetIntValue(configMap.get("nextFlag"));
        config.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        config.keywords = (ArrayList<String>)configMap.get("keywords");
        config.isAlsoMatchGroupMemberNickname =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("isAlsoMatchGroupMemberNickname"));

        return config;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMGroupSearchInfoList(ArrayList<ZIMGroupSearchInfo> groupSearchInfoList) {
        ArrayList<HashMap<String, Object>> mapInfoList = new ArrayList<>();
        for (ZIMGroupSearchInfo info : groupSearchInfoList) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("groupInfo", mZIMGroupInfo(info.groupInfo));
            map.put("userList", mZIMGroupMemberInfoList(info.userList));
            mapInfoList.add(map);
        }

        return mapInfoList;
    }

    static public ZIMCallInviteConfig oZIMCallInviteConfig(HashMap<String, Object> configMap) {
        ZIMCallInviteConfig config = new ZIMCallInviteConfig();
        config.timeout = ZIMPluginCommonTools.safeGetIntValue(configMap.get("timeout"));
        config.extendedData = (String)configMap.get("extendedData");
        config.enableNotReceivedCheck =
            ZIMPluginCommonTools.safeGetBoolValue(configMap.get("enableNotReceivedCheck"));
        config.mode = ZIMCallInvitationMode.getZIMCallInvitationMode(
            ZIMPluginCommonTools.safeGetIntValue(configMap.get("mode")));
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    static public ZIMCallingInviteConfig
    oZIMCallingInviteConfig(HashMap<String, Object> configMap) {
        ZIMCallingInviteConfig config = new ZIMCallingInviteConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    static public HashMap<String, Object> mZIMCallUserInfo(ZIMCallUserInfo userInfo) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID", userInfo.userID);
        userInfoMap.put("state", userInfo.state.value());
        userInfoMap.put("extendedData", userInfo.extendedData);
        return userInfoMap;
    }

    static public HashMap<String, Object> mZIMCallInfo(ZIMCallInfo callInfo) {
        HashMap<String, Object> callInfoMap = new HashMap<>();
        callInfoMap.put("callID", callInfo.callID);
        callInfoMap.put("caller", callInfo.caller);
        callInfoMap.put("createTime", callInfo.createTime);
        callInfoMap.put("endTime", callInfo.endTime);
        callInfoMap.put("state", callInfo.state.value());
        callInfoMap.put("mode", callInfo.mode.value());
        callInfoMap.put("callUserList", mZIMCallUserInfoList(callInfo.callUserList));
        callInfoMap.put("extendedData", callInfo.extendedData);
        //        callInfoMap.put("callDuration",callInfo.callDuration);
        //        callInfoMap.put("userDuration",callInfo.userDuration);
        return callInfoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMCallInfoList(ArrayList<ZIMCallInfo> callInfoList) {
        ArrayList<HashMap<String, Object>> basicInfoList = new ArrayList<>();
        for (ZIMCallInfo callInfo : callInfoList) {
            basicInfoList.add(mZIMCallInfo(callInfo));
        }
        return basicInfoList;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMCallUserInfoList(ArrayList<ZIMCallUserInfo> callUserInfoList) {
        ArrayList<HashMap<String, Object>> basicUserInfoList = new ArrayList<>();
        for (ZIMCallUserInfo callUserInfo : callUserInfoList) {
            basicUserInfoList.add(mZIMCallUserInfo(callUserInfo));
        }
        return basicUserInfoList;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationSentInfo(ZIMCallInvitationSentInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("timeout", info.timeout);
        infoMap.put("errorList", mZIMErrorUserInfoList(info.errorUserList));
        infoMap.put("errorInvitees", mZIMCallUserInfoList(info.errorInvitees));

        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallingInvitationSentInfo(ZIMCallingInvitationSentInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("errorInvitees", mZIMErrorUserInfoList(info.errorUserList));
        return infoMap;
    }

    static public HashMap<String, Object> mZIMCallQuitSentInfo(ZIMCallQuitSentInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("quitTime", info.quitTime);
        infoMap.put("acceptTime", info.acceptTime);
        infoMap.put("createTime", info.createTime);
        return infoMap;
    }

    static public HashMap<String, Object> mZIMCallEndSentInfo(ZIMCallEndedSentInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("acceptTime", info.acceptTime);
        infoMap.put("endTime", info.endTime);
        infoMap.put("createTime", info.createTime);
        return infoMap;
    }

    static public ZIMCallQuitConfig oZIMCallQuitConfig(HashMap<String, Object> configMap) {
        ZIMCallQuitConfig config = new ZIMCallQuitConfig();
        config.extendedData = (String)configMap.get("extendedData");
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    static public ZIMCallEndConfig oZIMCallEndConfig(HashMap<String, Object> configMap) {
        ZIMCallEndConfig config = new ZIMCallEndConfig();
        config.extendedData = (String)configMap.get("extendedData");
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    static public ZIMCallCancelConfig oZIMCallCancelConfig(HashMap<String, Object> configMap) {
        ZIMCallCancelConfig config = new ZIMCallCancelConfig();
        config.extendedData = (String)configMap.get("extendedData");
        return config;
    }

    static public ZIMCallAcceptConfig oZIMCallAcceptConfig(HashMap<String, Object> configMap) {
        ZIMCallAcceptConfig config = new ZIMCallAcceptConfig();
        config.extendedData = (String)configMap.get("extendedData");
        return config;
    }

    static public ZIMCallRejectConfig oZIMCallRejectConfig(HashMap<String, Object> configMap) {
        ZIMCallRejectConfig config = new ZIMCallRejectConfig();
        config.extendedData = (String)configMap.get("extendedData");
        return config;
    }

    static public ZIMCallInvitationQueryConfig
    oZIMQueryCallListConfig(HashMap<String, Object> configMap) {
        ZIMCallInvitationQueryConfig config = new ZIMCallInvitationQueryConfig();
        config.count = (Integer)configMap.get("count");
        config.nextFlag = ZIMPluginCommonTools.safeGetLongValue(configMap.get("nextFlag"));
        return config;
    }

    static public HashMap<String, Object>
    mZIMRoomAttributesUpdateInfo(ZIMRoomAttributesUpdateInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("action", info.action.value());
        infoMap.put("roomAttributes", info.roomAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMRoomAttributesUpdateInfoList(ArrayList<ZIMRoomAttributesUpdateInfo> infos) {
        ArrayList<HashMap<String, Object>> basicInfoList = new ArrayList<>();
        for (ZIMRoomAttributesUpdateInfo info : infos) {
            basicInfoList.add(mZIMRoomAttributesUpdateInfo(info));
        }
        return basicInfoList;
    }

    static public HashMap<String, Object> mZIMGroupOperatedInfo(ZIMGroupOperatedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("operatedUserInfo", mZIMGroupMemberInfo(info.operatedUserInfo));
        infoMap.put("userID", info.userID);
        infoMap.put("userName", info.userName);
        infoMap.put("memberNickname", info.memberNickname);
        infoMap.put("memberRole", info.memberRole);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMGroupAttributesUpdateInfo(ZIMGroupAttributesUpdateInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("action", info.action.value());
        infoMap.put("groupAttributes", info.groupAttributes);
        return infoMap;
    }

    static public ArrayList<HashMap<String, Object>>
    mZIMGroupAttributesUpdateInfoList(ArrayList<ZIMGroupAttributesUpdateInfo> infoList) {
        ArrayList<HashMap<String, Object>> basicList = new ArrayList<>();
        for (ZIMGroupAttributesUpdateInfo info : infoList) {
            basicList.add(mZIMGroupAttributesUpdateInfo(info));
        }
        return basicList;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationReceivedInfo(ZIMCallInvitationReceivedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("timeout", info.timeout);
        infoMap.put("inviter", info.inviter);
        infoMap.put("caller", info.caller);
        infoMap.put("mode", info.mode.value());
        infoMap.put("createTime", info.createTime);
        infoMap.put("callUserList", ZIMPluginConverter.mZIMCallUserInfoList(info.callUserList));
        infoMap.put("extendedData", info.extendedData);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationCancelledInfo(ZIMCallInvitationCancelledInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("inviter", info.inviter);
        infoMap.put("extendedData", info.extendedData);
        infoMap.put("mode", info.mode.value());
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationAcceptedInfo(ZIMCallInvitationAcceptedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("invitee", info.invitee);
        infoMap.put("extendedData", info.extendedData);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationRejectedInfo(ZIMCallInvitationRejectedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("invitee", info.invitee);
        infoMap.put("extendedData", info.extendedData);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationCreatedInfo(ZIMCallInvitationCreatedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("mode", info.mode.value());
        infoMap.put("caller", info.caller);
        infoMap.put("extendedData", info.extendedData);
        infoMap.put("timeout", info.timeout);
        infoMap.put("createTime", info.createTime);
        infoMap.put("callUserList", ZIMPluginConverter.mZIMCallUserInfoList(info.callUserList));
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationEndedInfo(ZIMCallInvitationEndedInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("endTime", info.endTime);
        infoMap.put("mode", info.mode.value());
        infoMap.put("extendedData", info.extendedData);
        infoMap.put("caller", info.caller);
        infoMap.put("operatedUserID", info.operatedUserID);
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallInvitationTimeoutInfo(ZIMCallInvitationTimeoutInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("mode", info.mode.value());
        return infoMap;
    }

    static public HashMap<String, Object>
    mZIMCallUserStateChangeInfo(ZIMCallUserStateChangeInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("callUserList", mZIMCallUserInfoList(info.callUserList));
        return infoMap;
    }

    static public ZIMGroupMessageReceiptMemberQueryConfig
    oZIMGroupMessageReceiptMemberQueryConfig(HashMap<String, Object> configMap) {
        ZIMGroupMessageReceiptMemberQueryConfig queryConfig =
            new ZIMGroupMessageReceiptMemberQueryConfig();
        queryConfig.count = (Integer)configMap.get("count");
        queryConfig.nextFlag = (Integer)configMap.get("nextFlag");
        return queryConfig;
    }

    static public ZIMMessageRevokeConfig
    oZIMMessageRevokeConfig(HashMap<String, Object> configMap) {
        ZIMMessageRevokeConfig revokeConfig = new ZIMMessageRevokeConfig();
        revokeConfig.revokeExtendedData = (String)configMap.get("revokeExtendedData");
        revokeConfig.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return revokeConfig;
    }

    public static HashMap<String, Object> mZIMMessageReaction(ZIMMessageReaction reaction) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("userList", mZIMMessageReactionUserInfoList(reaction.userList));
        infoMap.put("conversationID", reaction.conversationID);
        infoMap.put("conversationType", reaction.conversationType.value());
        infoMap.put("messageID", reaction.messageID);
        infoMap.put("totalCount", reaction.totalCount);
        infoMap.put("reactionType", reaction.reactionType);
        infoMap.put("isSelfIncluded", reaction.isSelfIncluded);
        return infoMap;
    }

    public static ArrayList<HashMap<String, Object>>
    mZIMMessageReactionUserInfoList(ArrayList<ZIMMessageReactionUserInfo> userInfos) {
        ArrayList<HashMap<String, Object>> userInfoMaps = new ArrayList<>();
        for (ZIMMessageReactionUserInfo userInfo : userInfos) {
            userInfoMaps.add(mZIMMessageReactionUserInfo(userInfo));
        }
        return userInfoMaps;
    }

    public static HashMap<String, Object>
    mZIMMessageReactionUserInfo(ZIMMessageReactionUserInfo userInfo) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("userID", userInfo.userID);
        return userInfoMap;
    }

    public static ZIMMessageReactionUserQueryConfig
    oZIMMessageReactionUsersQueryConfig(HashMap<String, Object> configMap) {
        ZIMMessageReactionUserQueryConfig queryConfig = new ZIMMessageReactionUserQueryConfig();
        queryConfig.nextFlag = ZIMPluginCommonTools.safeGetLongValue(configMap.get("nextFlag"));
        queryConfig.count = ZIMPluginCommonTools.safeGetIntValue(configMap.get("count"));
        queryConfig.reactionType = (String)Objects.requireNonNull(configMap.get("reactionType"));
        ;
        return queryConfig;
    }

    public static ArrayList<HashMap<String, Object>>
    mZIMMessageReactionList(ArrayList<ZIMMessageReaction> infos) {
        ArrayList<HashMap<String, Object>> maps = new ArrayList<>();
        for (ZIMMessageReaction info : infos) {
            maps.add(ZIMPluginConverter.mZIMMessageReaction(info));
        }
        return maps;
    }

    public static ZIMVoIPConfig oZIMVoIPconfig(HashMap<String, Object> configMap) {
        if (configMap == null) {
            return null;
        }
        ZIMVoIPConfig voIPConfig = new ZIMVoIPConfig();
        voIPConfig.iOSVoIPHandleType =
            ZIMCXHandleType.getZIMCXHandleType((Integer)configMap.get("iOSVoIPHandleType"));
        voIPConfig.iOSVoIPHasVideo = (Boolean)configMap.get("iOSVoIPHasVideo");
        voIPConfig.iOSVoIPHandleValue = (String)configMap.get("iOSVoIPHandleValue");
        return voIPConfig;
    }

    public static HashMap<String, Object> mZIMMessageDeletedInfo(ZIMMessageDeletedInfo info) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("conversationID", info.conversationID);
        map.put("conversationType", info.conversationType.value());
        map.put("messageDeleteType", info.messageDeleteType.value());
        map.put("isDeleteConversationAllMessage", info.isDeleteConversationAllMessage);
        map.put("messageList", ZIMPluginConverter.mZIMMessageList(info.messageList));
        return map;
    }

    public static ZIMCallJoinConfig oZIMCallJoinConfig(HashMap<String, Object> configMap) {
        ZIMCallJoinConfig joinConfig = new ZIMCallJoinConfig();
        joinConfig.extendedData = (String)configMap.get("extendedData");
        return joinConfig;
    }

    public static HashMap<String, Object> mZIMCallJoinSentInfo(ZIMCallJoinSentInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("extendedData", info.extendedData);
        infoMap.put("createTime", info.createTime);
        infoMap.put("joinTime", info.joinTime);
        infoMap.put("callUserList", ZIMPluginConverter.mZIMCallUserInfoList(info.callUserList));
        return infoMap;
    }

    static public ZIMFriendAddConfig oZIMFriendAddConfig(HashMap<String, Object> configMap) {
        ZIMFriendAddConfig config = new ZIMFriendAddConfig();
        config.wording = (String)configMap.get("wording");
        config.friendAlias = (String)configMap.get("friendAlias");
        config.friendAttributes = (HashMap<String, String>)configMap.get("friendAttributes");
        return config;
    }

    static public ZIMFriendApplicationAcceptConfig
    oZIMFriendApplicationAcceptConfig(HashMap<String, Object> configMap) {
        ZIMFriendApplicationAcceptConfig config = new ZIMFriendApplicationAcceptConfig();
        config.friendAlias = (String)configMap.get("friendAlias");
        config.friendAttributes = (HashMap<String, String>)configMap.get("friendAttributes");
        config.pushConfig = oZIMPushConfig(
            (HashMap<String, Object>)configMap.get("pushConfig")); // 假设已有转换 pushConfig 的函数
        return config;
    }

    static public ZIMFriendApplicationInfo
    oZIMFriendApplicationInfo(HashMap<String, Object> infoMap) {
        ZIMFriendApplicationInfo info = new ZIMFriendApplicationInfo();
        info.applyUser = ZIMPluginConverter.oZIMUserInfo(
            (HashMap<String, Object>)infoMap.get("applyUser")); // 假设已有转换 ZIMUserInfo 的函数
        info.wording = (String)infoMap.get("wording");
        info.createTime = (long)infoMap.get("createTime");
        info.updateTime = (long)infoMap.get("updateTime");
        info.type = ZIMFriendApplicationType.getZIMFriendApplicationType(
            (Integer)infoMap.get("type")); // 假设 ZIMFriendApplicationType 可直接转换
        info.state =
            ZIMFriendApplicationState.getZIMFriendApplicationState((Integer)infoMap.get("state"));
        return info;
    }

    static public HashMap<String, Object> mZIMFriendApplicationInfo(ZIMFriendApplicationInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("applyUser",
                    mZIMUserInfo(info.applyUser)); // Assuming mZIMUserInfo exists for ZIMUserInfo
        infoMap.put("wording", info.wording);
        infoMap.put("createTime", info.createTime);
        infoMap.put("updateTime", info.updateTime);
        infoMap.put("type",
                    info.type.value()); // Assuming ZIMFriendApplicationType can be directly stored
        infoMap.put(
            "state",
            info.state.value()); // Assuming ZIMFriendApplicationState can be directly stored
        return infoMap;
    }

    static public ZIMFriendApplicationListQueryConfig
    oZIMFriendApplicationListQueryConfig(HashMap<String, Object> configMap) {
        ZIMFriendApplicationListQueryConfig config = new ZIMFriendApplicationListQueryConfig();
        config.count = (int)configMap.get("count");
        config.nextFlag = (int)configMap.get("nextFlag");
        return config;
    }

    static public ZIMFriendApplicationRejectConfig
    oZIMFriendApplicationRejectConfig(HashMap<String, Object> configMap) {
        ZIMFriendApplicationRejectConfig config = new ZIMFriendApplicationRejectConfig();
        config.pushConfig = oZIMPushConfig(
            (HashMap<String, Object>)configMap.get("pushConfig")); // Assuming oZIMPushConfig exists
        return config;
    }

    static public ZIMFriendDeleteConfig oZIMFriendDeleteConfig(HashMap<String, Object> configMap) {
        ZIMFriendDeleteConfig config = new ZIMFriendDeleteConfig();
        config.type = ZIMFriendDeleteType.getZIMFriendDeleteType(
            (Integer)configMap.get("type")); // Assuming direct conversion is possible
        return config;
    }

    static public HashMap<String, Object> mZIMFriendInfo(ZIMFriendInfo info) {
        return mZIMUserInfo(info);
        //        HashMap<String, Object> infoMap = new HashMap<>(mZIMUserInfo(info)); // Assuming mZIMUserInfo for ZIMUserInfo inheritance
        //        infoMap.put("friendAlias", info.friendAlias);
        //        infoMap.put("createTime", info.createTime);
        //        infoMap.put("wording", info.wording);
        //        infoMap.put("friendAttributes", info.friendAttributes);
        //        return infoMap;
    }

    static public ZIMFriendInfo oZIMFriendInfo(HashMap<String, Object> infoMap) {
        ZIMFriendInfo info = new ZIMFriendInfo();
        oZIMUserInfo(infoMap, info);
        //        info.friendAlias = (String) infoMap.get("friendAlias");
        //        info.createTime = (Long) infoMap.get("createTime");
        //        info.wording = (String) infoMap.get("wording");
        //        info.friendAttributes = (HashMap<String, String>) infoMap.get("friendAttributes");
        return info;
    }

    static public ZIMFriendListQueryConfig
    oZIMFriendListQueryConfig(HashMap<String, Object> configMap) {
        ZIMFriendListQueryConfig config = new ZIMFriendListQueryConfig();
        config.count = (int)configMap.get("count");
        config.nextFlag = (int)configMap.get("nextFlag");
        return config;
    }

    static public ZIMFriendRelationCheckConfig
    oZIMFriendRelationCheckConfig(HashMap<String, Object> configMap) {
        ZIMFriendRelationCheckConfig config = new ZIMFriendRelationCheckConfig();
        config.type = ZIMFriendRelationCheckType.getZIMFriendRelationCheckType(
            (Integer)configMap.get("type")); // Assuming direct conversion is possible
        return config;
    }

    static public HashMap<String, Object> mZIMFriendRelationInfo(ZIMFriendRelationInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("type",
                    info.type.value()); // Assuming ZIMUserRelationType can be directly stored
        infoMap.put("userID", info.userID);
        return infoMap;
    }

    static public ZIMFriendRelationInfo oZIMFriendRelationInfo(HashMap<String, Object> infoMap) {
        ZIMFriendRelationInfo info = new ZIMFriendRelationInfo();
        info.type = ZIMUserRelationType.getZIMUserRelationType(
            (Integer)infoMap.get("type")); // Assuming direct conversion is possible
        info.userID = (String)infoMap.get("userID");
        return info;
    }

    static public ZIMFriendApplicationSendConfig
    oZIMFriendApplicationSendConfig(HashMap<String, Object> configMap) {
        ZIMFriendApplicationSendConfig config = new ZIMFriendApplicationSendConfig();
        config.wording = (String)configMap.get("wording");
        config.friendAlias = (String)configMap.get("friendAlias");
        config.friendAttributes = (HashMap<String, String>)configMap.get("friendAttributes");
        config.pushConfig = oZIMPushConfig(
            (HashMap<String, Object>)configMap.get("pushConfig")); // Assuming oZIMPushConfig exists
        return config;
    }

    static public ZIMBlacklistQueryConfig
    oZIMBlacklistQueryConfig(HashMap<String, Object> configMap) {
        ZIMBlacklistQueryConfig config = new ZIMBlacklistQueryConfig();
        if (configMap.containsKey("nextFlag")) {
            config.nextFlag = (int)configMap.get("nextFlag");
        }
        if (configMap.containsKey("count")) {
            config.count = (int)configMap.get("count");
        }
        return config;
    }

    public static ZIMGroupJoinApplicationSendConfig
    oZIMGroupJoinApplicationSendConfig(HashMap<String, Object> configMap) {
        ZIMGroupJoinApplicationSendConfig config = new ZIMGroupJoinApplicationSendConfig();
        if (configMap.containsKey("wording")) {
            config.wording = (String)configMap.get("wording");
        }
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    public static ZIMGroupJoinApplicationAcceptConfig
    oZIMGroupJoinApplicationAcceptConfig(HashMap<String, Object> configMap) {
        ZIMGroupJoinApplicationAcceptConfig config = new ZIMGroupJoinApplicationAcceptConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    public static ZIMGroupJoinApplicationRejectConfig
    oZIMGroupJoinApplicationRejectConfig(HashMap<String, Object> configMap) {
        ZIMGroupJoinApplicationRejectConfig config = new ZIMGroupJoinApplicationRejectConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    public static ZIMGroupInviteApplicationSendConfig
    oZIMGroupInviteApplicationSendConfig(HashMap<String, Object> configMap) {
        ZIMGroupInviteApplicationSendConfig config = new ZIMGroupInviteApplicationSendConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        if (configMap.containsKey("wording")) {
            config.wording = (String)configMap.get("wording");
        }
        return config;
    }

    public static ZIMGroupInviteApplicationAcceptConfig
    oZIMGroupInviteApplicationAcceptConfig(HashMap<String, Object> configMap) {
        ZIMGroupInviteApplicationAcceptConfig config = new ZIMGroupInviteApplicationAcceptConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    public static ZIMGroupInviteApplicationRejectConfig
    oZIMGroupInviteApplicationRejectConfig(HashMap<String, Object> configMap) {
        ZIMGroupInviteApplicationRejectConfig config = new ZIMGroupInviteApplicationRejectConfig();
        config.pushConfig =
            oZIMPushConfig(ZIMPluginCommonTools.safeGetHashMap(configMap.get("pushConfig")));
        return config;
    }

    public static ZIMGroupApplicationListQueryConfig
    oZIMGroupApplicationListQueryConfig(HashMap<String, Object> configMap) {
        ZIMGroupApplicationListQueryConfig config = new ZIMGroupApplicationListQueryConfig();
        if (configMap.containsKey("nextFlag")) {
            config.nextFlag = (int)configMap.get("nextFlag");
        }
        if (configMap.containsKey("count")) {
            config.count = (int)configMap.get("count");
        }
        return config;
    }

    public static HashMap<String, Object>
    mZIMGroupApplicationInfo(ZIMGroupApplicationInfo applicationInfo) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("applyUser", mZIMUserInfo(applicationInfo.applyUser));
        infoMap.put("groupInfo", mZIMGroupInfo(applicationInfo.groupInfo));
        infoMap.put("operatedUser", mZIMGroupMemberSimpleInfo(applicationInfo.operatedUser));
        infoMap.put("wording", applicationInfo.wording);
        infoMap.put("createTime", applicationInfo.createTime);
        infoMap.put("updateTime", applicationInfo.updateTime);
        infoMap.put("type", applicationInfo.type.value());
        infoMap.put("state", applicationInfo.state.value());
        return infoMap;
    }

    private static Object mZIMGroupMemberSimpleInfo(ZIMGroupMemberSimpleInfo operatedUser) {
        if (operatedUser == null) {
            return null;
        }
        return mZIMUserInfo(operatedUser);
        //        HashMap<String, Object> userInfoMap = new HashMap<>();
        //        userInfoMap.put("userID", operatedUser.userID);
        //        userInfoMap.put("userName", operatedUser.userName);
        //        userInfoMap.put("userAvatarUrl", operatedUser.userAvatarUrl);
        //        userInfoMap.put("memberNickname", operatedUser.memberNickName);
        //        userInfoMap.put("memberRole", operatedUser.memberRole);
        //        return userInfoMap;
    }

    public static Object mZIMGroupVerifyInfo(ZIMGroupVerifyInfo verifyInfo) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("beInviteMode", verifyInfo.beInviteMode.value());
        userInfoMap.put("joinMode", verifyInfo.joinMode.value());
        userInfoMap.put("inviteMode", verifyInfo.inviteMode.value());
        return userInfoMap;
    }

    public static HashMap<String, Object> mZIMTipsMessageChangeInfo(ZIMTipsMessageChangeInfo info) {
        HashMap<String, Object> infoMap = new HashMap<>();
        infoMap.put("type", info.type.value());
        if (info instanceof ZIMTipsMessageGroupChangeInfo) {
            infoMap.put("classType", "ZIMTipsMessageGroupChangeInfo");
            infoMap.put("groupDataFlag", ((ZIMTipsMessageGroupChangeInfo)info).groupDataFlag);
            infoMap.put("groupName", ((ZIMTipsMessageGroupChangeInfo)info).groupName);
            infoMap.put("groupNotice", ((ZIMTipsMessageGroupChangeInfo)info).groupNotice);
            infoMap.put("groupAvatarUrl", ((ZIMTipsMessageGroupChangeInfo)info).groupAvatarUrl);
            if (((ZIMTipsMessageGroupChangeInfo)info).groupMutedInfo != null) {
                infoMap.put(
                    "groupMuteInfo",
                    mZIMGroupMuteInfo(((ZIMTipsMessageGroupChangeInfo)info).groupMutedInfo));
            }
        } else if (info instanceof ZIMTipsMessageGroupMemberChangeInfo) {
            infoMap.put("role", ((ZIMTipsMessageGroupMemberChangeInfo)info).memberRole);
            infoMap.put("muteExpiredTime",
                        ((ZIMTipsMessageGroupMemberChangeInfo)info).muteExpiredTime);
            infoMap.put("classType", "ZIMTipsMessageGroupMemberChangeInfo");
        }
        return infoMap;
    }

    public static ZIMUserStatusSubscribeConfig
    oZIMUserStatusSubscribeConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }
        ZIMUserStatusSubscribeConfig config = new ZIMUserStatusSubscribeConfig();
        config.subscriptionDuration = (int)map.get("subscriptionDuration");
        return config;
    }

    public static ZIMUserStatus oZIMUserStatus(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }
        ZIMUserStatus userStatus = new ZIMUserStatus();
        userStatus.userID = (String)map.get("userID");
        userStatus.onlineStatus =
            ZIMUserOnlineStatus.getZIMUserOnlineStatus((Integer)map.get("onlineStatus"));
        userStatus.onlinePlatforms = new ArrayList<>();
        for (Integer platformInt : (Integer[])map.get("onlinePlatforms")) {
            userStatus.onlinePlatforms.add(ZIMPlatformType.getZIMPlatformType(platformInt));
        }
        userStatus.lastUpdateTime = (long)map.get("lastUpdateTime");
        return userStatus;
    }

    public static HashMap<String, Object> mZIMUserStatus(ZIMUserStatus userStatus) {
        if (userStatus == null) {
            return null;
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("userID", userStatus.userID);
        map.put("onlineStatus", userStatus.onlineStatus.value());
        map.put("lastUpdateTime", userStatus.lastUpdateTime);
        ArrayList<Integer> onlinePlatforms = new ArrayList<Integer>();
        for (ZIMPlatformType type : userStatus.onlinePlatforms) {
            onlinePlatforms.add(type.value());
        }
        map.put("onlinePlatforms", onlinePlatforms);
        return map;
    }

    public static ArrayList<ZIMUserStatus>
    oZIMUserStatusList(ArrayList<HashMap<String, Object>> basicList) {
        if (basicList == null) {
            return null;
        }
        ArrayList<ZIMUserStatus> list = new ArrayList<>();
        for (HashMap<String, Object> map : basicList) {
            list.add(oZIMUserStatus(map));
        }
        return list;
    }

    public static ArrayList<HashMap<String, Object>>
    mZIMUserStatusList(ArrayList<ZIMUserStatus> userStatusList) {
        if (userStatusList == null) {
            return null;
        }
        ArrayList<HashMap<String, Object>> list = new ArrayList<>();
        for (ZIMUserStatus userStatus : userStatusList) {
            list.add(mZIMUserStatus(userStatus));
        }
        return list;
    }

    public static ZIMSubscribedUserStatusQueryConfig
    oZIMSubscribedUserStatusQueryConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }
        ZIMSubscribedUserStatusQueryConfig config = new ZIMSubscribedUserStatusQueryConfig();
        config.userIDs = (ArrayList<String>)map.get("userIDs");
        return config;
    }

    public static HashMap<String, Object>
    mZIMUserStatusSubscription(ZIMUserStatusSubscription subscription) {
        if (subscription == null) {
            return null;
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("userStatus", mZIMUserStatus(subscription.userStatus));
        map.put("subscribeExpiredTime", subscription.subscribeExpiredTime);
        return map;
    }

    public static ArrayList<HashMap<String, Object>>
    mZIMUserStatusSubscriptionList(ArrayList<ZIMUserStatusSubscription> subscriptionList) {
        if (subscriptionList == null) {
            return null;
        }
        ArrayList<HashMap<String, Object>> basicList = new ArrayList<>();
        for (ZIMUserStatusSubscription subscription : subscriptionList) {
            basicList.add(mZIMUserStatusSubscription(subscription));
        }
        return basicList;
    }
}
