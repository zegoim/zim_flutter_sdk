package com.example.zim_plugin.internal;

import org.json.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import im.zego.zim.ZIM;
import im.zego.zim.callback.ZIMEventHandler;
import im.zego.zim.entity.ZIMCallInvitationAcceptedInfo;
import im.zego.zim.entity.ZIMCallInvitationCancelledInfo;
import im.zego.zim.entity.ZIMCallInvitationReceivedInfo;
import im.zego.zim.entity.ZIMCallInvitationRejectedInfo;
import im.zego.zim.entity.ZIMCommandMessage;
import im.zego.zim.entity.ZIMConversationChangeInfo;
import im.zego.zim.entity.ZIMError;
import im.zego.zim.entity.ZIMGroupAttributesUpdateInfo;
import im.zego.zim.entity.ZIMGroupFullInfo;
import im.zego.zim.entity.ZIMGroupMemberInfo;
import im.zego.zim.entity.ZIMGroupOperatedInfo;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMRoomAttributesUpdateInfo;
import im.zego.zim.entity.ZIMUserInfo;
import im.zego.zim.enums.ZIMConnectionEvent;
import im.zego.zim.enums.ZIMConnectionState;
import im.zego.zim.enums.ZIMGroupEvent;
import im.zego.zim.enums.ZIMGroupMemberEvent;
import im.zego.zim.enums.ZIMGroupMemberState;
import im.zego.zim.enums.ZIMGroupState;
import im.zego.zim.enums.ZIMRoomEvent;
import im.zego.zim.enums.ZIMRoomState;
import io.flutter.plugin.common.EventChannel;

public class ZIMPluginEventHandler extends ZIMEventHandler {

    public static EventChannel.EventSink mysink = null;

    public void setSink(EventChannel.EventSink sink){
        mysink = sink;
    }
    @Override
    public void onConnectionStateChanged(ZIM zim, ZIMConnectionState state, ZIMConnectionEvent event, JSONObject extendedData) {
        if(mysink == null) {
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConnectionStateChanged");
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("extendedData",extendedData.toString());
        mysink.success(resultMap);
    }

    @Override
    public void onError(ZIM zim, ZIMError errorInfo) {
        if(mysink == null) {
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onError");
        resultMap.put("code",errorInfo.code.value());
        resultMap.put("message",errorInfo.message);
        mysink.success(resultMap);
    }

    @Override
    public void onTokenWillExpire(ZIM zim, int second) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onTokenWillExpire");
        resultMap.put("second",second);
        mysink.success(resultMap);
    }

    @Override
    public void onConversationChanged(ZIM zim, ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConversationChanged");
        resultMap.put("conversationChangeInfoList",ZIMPluginConverter.cnvZIMConversationChangeInfoListObjectToList(conversationChangeInfoList));
        mysink.success(resultMap);
    }

    @Override
    public void onConversationTotalUnreadMessageCountUpdated(ZIM zim, int totalUnreadMessageCount) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConversationTotalUnreadMessageCountUpdated");
        resultMap.put("totalUnreadMessageCount",totalUnreadMessageCount);
        mysink.success(resultMap);
    }

    @Override
    public void onReceivePeerMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromUserID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceivePeerMessage");
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromUserID",fromUserID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveRoomMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromRoomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceiveRoomMessage");
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromRoomID",fromRoomID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveGroupMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromGroupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceiveGroupMessage");
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromGroupID",fromGroupID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberJoined(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomMemberJoined");
        resultMap.put("memberList",ZIMPluginConverter.cnvZIMUserInfoListObjectToBasic(memberList));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberLeft(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomMemberLeft");
        resultMap.put("memberList",ZIMPluginConverter.cnvZIMUserInfoListObjectToBasic(memberList));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);

    }

    @Override
    public void onRoomStateChanged(ZIM zim, ZIMRoomState state, ZIMRoomEvent event, JSONObject extendedData, String roomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomStateChanged");
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("extendedData",event.toString());
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesUpdated(ZIM zim, ZIMRoomAttributesUpdateInfo info, String roomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomAttributesUpdated");
        resultMap.put("updateInfo",ZIMPluginConverter.cnvZIMRoomAttributesUpdateInfoObjectToMap(info));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesBatchUpdated(ZIM zim, ArrayList<ZIMRoomAttributesUpdateInfo> infos, String roomID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomAttributesBatchUpdated");
        resultMap.put("updateInfo",ZIMPluginConverter.cnvZIMRoomAttributesUpdateInfoListToBasicList(infos));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onGroupStateChanged(ZIM zim, ZIMGroupState state, ZIMGroupEvent event, ZIMGroupOperatedInfo operatedInfo, ZIMGroupFullInfo groupInfo) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupStateChanged");
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupInfo",ZIMPluginConverter.cnvZIMGroupFullInfoObjectToMap(groupInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNameUpdated(ZIM zim, String groupName, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupNameUpdated");
        resultMap.put("groupName",groupName);
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNoticeUpdated(ZIM zim, String groupNotice, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupNoticeUpdated");
        resultMap.put("groupNotice",groupNotice);
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAttributesUpdated(ZIM zim, ArrayList<ZIMGroupAttributesUpdateInfo> infos, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupAttributesUpdated");
        resultMap.put("updateInfo",ZIMPluginConverter.cnvZIMGroupAttributesUpdateInfoListToBasicList(infos));
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberStateChanged(ZIM zim, ZIMGroupMemberState state, ZIMGroupMemberEvent event, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupMemberStateChanged");
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("userList",ZIMPluginConverter.cnvZIMGroupMemberInfoListToBasicList(userList));
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberInfoUpdated(ZIM zim, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupMemberInfoUpdated");
        resultMap.put("userList",ZIMPluginConverter.cnvZIMGroupMemberInfoListToBasicList(userList));
        resultMap.put("operatedInfo",ZIMPluginConverter.cnvZIMGroupOperatedInfoObjectToMap(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationReceived(ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationReceived");
        resultMap.put("info",ZIMPluginConverter.cnvZIMCallInvitationReceivedInfoObjectToMap(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationCancelled(ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationCancelled");
        resultMap.put("info",ZIMPluginConverter.cnvZIMCallInvitationCancelledInfoObjectToMap(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationAccepted(ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationAccepted");
        resultMap.put("info",ZIMPluginConverter.cnvZIMCallInvitationAcceptedInfoObjectToMap(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationRejected(ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationRejected");
        resultMap.put("info",ZIMPluginConverter.cnvZIMCallInvitationRejectedInfoObjectToMap(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationTimeout(ZIM zim, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationTimeout");
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInviteesAnsweredTimeout(ZIM zim, ArrayList<String> invitees, String callID) {
        if(mysink == null){
            return;
        }
        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInviteesAnsweredTimeout");
        resultMap.put("invitees",invitees);
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }
}


