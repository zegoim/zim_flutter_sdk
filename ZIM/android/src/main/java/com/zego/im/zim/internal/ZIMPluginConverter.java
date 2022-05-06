package com.zego.im.zim.internal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import im.zego.zim.entity.ZIMBarrageMessage;
import im.zego.zim.entity.ZIMCommandMessage;
import im.zego.zim.entity.ZIMConversation;
import im.zego.zim.entity.ZIMConversationChangeInfo;
import im.zego.zim.entity.ZIMConversationQueryConfig;
import im.zego.zim.entity.ZIMErrorUserInfo;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMTextMessage;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.enums.ZIMConversationNotificationStatus;
import im.zego.zim.enums.ZIMConversationType;
import im.zego.zim.enums.ZIMMessageDirection;
import im.zego.zim.enums.ZIMMessageSentStatus;
import im.zego.zim.enums.ZIMMessageType;

public class ZIMPluginConverter {

    static public ArrayList cnvZIMConversationChangeInfoListObjectToList(ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        ArrayList conversationChangeInfoBasicList = new ArrayList<>();
        for (ZIMConversationChangeInfo conversationChangeInfo:
             conversationChangeInfoList) {
            conversationChangeInfoBasicList.add(cnvZIMConversationChangeInfoObjectToMap(conversationChangeInfo));
        }
        return conversationChangeInfoBasicList;
    }

    static public HashMap cnvZIMConversationChangeInfoObjectToMap(ZIMConversationChangeInfo conversationChangeInfo){
        HashMap conversationChangeInfoMap = new HashMap();
        conversationChangeInfoMap.put("event",conversationChangeInfo.event);


        conversationChangeInfoMap.put("conversation",cnvZIMConversationObjectToMap(conversationChangeInfo.conversation));
        return conversationChangeInfoMap;
    }

    static public HashMap cnvZIMConversationObjectToMap(ZIMConversation conversation){
        HashMap conversationMap = new HashMap();
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

    static public HashMap cnvZIMMessageObjectToMap(ZIMMessage message){
        HashMap messageMap = new HashMap();
        messageMap.put("type",message.type);
        messageMap.put("messageID",message.messageID);
        messageMap.put("conversationID",message.conversationID);
        messageMap.put("conversationSeq",message.conversationSeq);
        messageMap.put("senderUserID",message.senderUserID);
        messageMap.put("timestamp",message.timestamp);
        messageMap.put("localMessageID",message.localMessageID);
        messageMap.put("conversationType",message.conversationType.value());
        messageMap.put("direction",message.direction.value());
        messageMap.put("sentStatus",message.sentStatus.value());
        messageMap.put("orderKey",message.orderKey);
        switch(message.type){
            case UNKNOWN:
                break;
            case TEXT:
                messageMap.put("message",((ZIMTextMessage)message).message);
                break;
            case COMMAND:
                messageMap.put("message",((ZIMCommandMessage)message).message);
            case BARRAGE:
                messageMap.put("message",((ZIMBarrageMessage)message).message);
                break;
            default:
                break;
        }
        return messageMap;
    }

    static public ZIMMessage cnvZIMMessageMapToObject(HashMap messageMap){
        ZIMMessage message = new ZIMMessage();
        message.type = ZIMMessageType.values()[(int) messageMap.get("type")];
        message.messageID = (long) messageMap.get("messageID");
        message.conversationID = (String) messageMap.get("conversationID");
        message.conversationSeq = (long) messageMap.get("conversationSeq");
        message.senderUserID = (String) messageMap.get("senderUserID");
        message.timestamp = (long) messageMap.get("timestamp");
        message.localMessageID = (long) messageMap.get("localMessageID");
        message.conversationType = ZIMConversationType.values()[(int) messageMap.get("conversationType")];
        message.direction = ZIMMessageDirection.values()[(int) messageMap.get("direction")];
        message.sentStatus = ZIMMessageSentStatus.values()[(int) messageMap.get("sentStatus")];
        message.orderKey = (long) messageMap.get("orderKey");
        switch(message.type){
            case UNKNOWN:
                return message;
            case TEXT:
                ZIMTextMessage txtMsg = (ZIMTextMessage) message;
                txtMsg.message = (String) messageMap.get("message");
                return txtMsg;
            case COMMAND:
                ZIMCommandMessage cmdMsg = (ZIMCommandMessage) message;
                cmdMsg.message = (byte[]) messageMap.get("message");
                return cmdMsg;
            case BARRAGE:
                ZIMBarrageMessage brgMsg = (ZIMBarrageMessage) message;
                brgMsg.message = (String) messageMap.get("message");
                return brgMsg;
            default:
                return message;
        }
    }

    static public ArrayList cnvZIMMessageListObjectToBasic(ArrayList<ZIMMessage> messageList){
        ArrayList messageBasicList = new ArrayList();
        for (ZIMMessage message:messageList
             ) {
            messageBasicList.add(cnvZIMMessageObjectToMap(message));
        }
        return messageBasicList;
    }

    static public ArrayList cnvZIMUserInfoListObjectToBasic(ArrayList<ZIMUserInfo> userList){
        ArrayList userInfoBasicList = new ArrayList();
        for (ZIMUserInfo userInfo:userList) {
            userInfoBasicList.add(cnvZIMUserInfoObjectToMap(userInfo));
        }
        return userInfoBasicList;
    }

    static public HashMap cnvZIMUserInfoObjectToMap(ZIMUserInfo userInfo){
        HashMap userInfoMap = new HashMap();
        userInfoMap.put("userID",userInfo.userID);
        userInfoMap.put("userName",userInfo.userName);
        return userInfoMap;
    }

    static public HashMap cnvZIMErrorUserInfoObjectToMap(ZIMErrorUserInfo errorUserInfo){
        HashMap errorUserInfoMap = new HashMap();
        errorUserInfoMap.put("userID",errorUserInfo.userID);
        errorUserInfoMap.put("reason",errorUserInfo.reason);
        return errorUserInfoMap;
    }

    static public ArrayList cnvZIMErrorUserInfoListObjectToBasic(ArrayList<ZIMErrorUserInfo> errorUserList){
        ArrayList errorUserInfoBasicList = new ArrayList();
        for (ZIMErrorUserInfo errorUserInfo:errorUserList) {
            errorUserInfoBasicList.add(cnvZIMErrorUserInfoObjectToMap(errorUserInfo));
        }
        return errorUserInfoBasicList;
    }

    static public ZIMConversationQueryConfig cnvZIMConversationQueryConfigMapToObject(HashMap resultMap){
        ZIMConversationQueryConfig queryConfig = new ZIMConversationQueryConfig();
        queryConfig.count = (int)resultMap.get("count");
        if(resultMap.get("nextConversation") != null){
            queryConfig.nextConversation = cnvZIMConversationMapToObject((HashMap) resultMap.get("nextConversation"));
        }
        return queryConfig;
    }

    static public ZIMConversation cnvZIMConversationMapToObject(HashMap resultMap){
        ZIMConversation conversation = new ZIMConversation();
        conversation.conversationID = (String) resultMap.get("conversationID");
        conversation.conversationName = (String) resultMap.get("conversationName");
        conversation.type = ZIMConversationType.values()[(int) resultMap.get("type")];
        conversation.unreadMessageCount = (int) resultMap.get("unreadMessageCount");
        conversation.orderKey = (long) resultMap.get("orderKey");
        conversation.notificationStatus = ZIMConversationNotificationStatus.values()[(int) resultMap.get("notificationStatus")];
        if(resultMap.get("lastMessage") != null) {
            conversation.lastMessage = cnvZIMMessageMapToObject((HashMap) resultMap.get("lastMessage"));
        }else{
            conversation.lastMessage = null;
        }
        return conversation;
    }

    static public ArrayList cnvZIMConversationListObjectToBasic(ArrayList<ZIMConversation> conversationList){
        ArrayList conversationBasicList = new ArrayList();
        for (ZIMConversation conversation:
             conversationList) {
            conversation.
        }
    }
}
