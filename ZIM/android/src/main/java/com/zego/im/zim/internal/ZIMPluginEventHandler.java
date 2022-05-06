package com.zego.im.zim.internal;

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

    private EventChannel.EventSink sink = null;
    private Iterator<String> iterato;

    public void setSink(EventChannel.EventSink sink){
        this.sink = sink;
    }
    @Override
    public void onConnectionStateChanged(ZIM zim, ZIMConnectionState state, ZIMConnectionEvent event, JSONObject extendedData) {
        if(this.sink == null) {
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("method","onConnectionStateChanged");
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("extendedData",extendedData.toString());
        this.sink.success(resultMap);
    }

    @Override
    public void onError(ZIM zim, ZIMError errorInfo) {
        if(this.sink == null) {
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("method","onError");
        resultMap.put("code",errorInfo.code.value());
        resultMap.put("message",errorInfo.message);
        this.sink.success(resultMap);
    }

    @Override
    public void onTokenWillExpire(ZIM zim, int second) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("method","onTokenWillExpire");
        resultMap.put("second",second);
        this.sink.success(resultMap);
    }

    @Override
    public void onConversationChanged(ZIM zim, ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("conversationChangeInfoList",ZIMPluginConverter.cnvZIMConversationChangeInfoListObjectToList(conversationChangeInfoList));
        this.sink.success(resultMap);
    }

    @Override
    public void onConversationTotalUnreadMessageCountUpdated(ZIM zim, int totalUnreadMessageCount) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("totalUnreadMessageCount",totalUnreadMessageCount);
        this.sink.success(resultMap);
    }

    @Override
    public void onReceivePeerMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromUserID) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromUserID",fromUserID);

        this.sink.success(resultMap);
    }

    @Override
    public void onReceiveRoomMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromRoomID) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromUserID",fromRoomID);

        this.sink.success(resultMap);
    }

    @Override
    public void onReceiveGroupMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromGroupID) {
        if(this.sink == null){
            return;
        }
        HashMap resultMap = new HashMap();
        resultMap.put("messageList",ZIMPluginConverter.cnvZIMMessageListObjectToBasic(messageList));
        resultMap.put("fromUserID",fromGroupID);

        this.sink.success(resultMap);
    }

    @Override
    public void onRoomMemberJoined(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
    }

    @Override
    public void onRoomMemberLeft(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
    }

    @Override
    public void onRoomStateChanged(ZIM zim, ZIMRoomState state, ZIMRoomEvent event, JSONObject extendedData, String roomID) {
    }

    @Override
    public void onRoomAttributesUpdated(ZIM zim, ZIMRoomAttributesUpdateInfo info, String roomID) {
    }

    @Override
    public void onRoomAttributesBatchUpdated(ZIM zim, ArrayList<ZIMRoomAttributesUpdateInfo> infos, String roomID) {
    }

    @Override
    public void onGroupStateChanged(ZIM zim, ZIMGroupState state, ZIMGroupEvent event, ZIMGroupOperatedInfo operatedInfo, ZIMGroupFullInfo groupInfo) {
    }

    @Override
    public void onGroupNameUpdated(ZIM zim, String groupName, ZIMGroupOperatedInfo operatedInfo, String groupID) {
    }

    @Override
    public void onGroupNoticeUpdated(ZIM zim, String groupNotice, ZIMGroupOperatedInfo operatedInfo, String groupID) {
    }

    @Override
    public void onGroupAttributesUpdated(ZIM zim, ArrayList<ZIMGroupAttributesUpdateInfo> infos, ZIMGroupOperatedInfo operatedInfo, String groupID) {
    }

    @Override
    public void onGroupMemberStateChanged(ZIM zim, ZIMGroupMemberState state, ZIMGroupMemberEvent event, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
    }

    @Override
    public void onGroupMemberInfoUpdated(ZIM zim, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
    }

    @Override
    public void onCallInvitationReceived(ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
    }

    @Override
    public void onCallInvitationCancelled(ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
    }

    @Override
    public void onCallInvitationAccepted(ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
    }

    @Override
    public void onCallInvitationRejected(ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
    }

    @Override
    public void onCallInvitationTimeout(ZIM zim, String callID) {
    }

    @Override
    public void onCallInviteesAnsweredTimeout(ZIM zim, ArrayList<String> invitees, String callID) {
    }
}


