package im.zego.zim_flutter.internal;

import org.json.*;

import java.util.ArrayList;
import java.util.HashMap;

import im.zego.zim.ZIM;
import im.zego.zim.callback.ZIMEventHandler;
import im.zego.zim.entity.ZIMCallInvitationAcceptedInfo;
import im.zego.zim.entity.ZIMCallInvitationCancelledInfo;
import im.zego.zim.entity.ZIMCallInvitationReceivedInfo;
import im.zego.zim.entity.ZIMCallInvitationRejectedInfo;
import im.zego.zim.entity.ZIMConversationChangeInfo;
import im.zego.zim.entity.ZIMError;
import im.zego.zim.entity.ZIMGroupAttributesUpdateInfo;
import im.zego.zim.entity.ZIMGroupFullInfo;
import im.zego.zim.entity.ZIMGroupMemberInfo;
import im.zego.zim.entity.ZIMGroupOperatedInfo;
import im.zego.zim.entity.ZIMMessage;
import im.zego.zim.entity.ZIMMessageReceiptInfo;
import im.zego.zim.entity.ZIMRevokeMessage;
import im.zego.zim.entity.ZIMRoomAttributesUpdateInfo;
import im.zego.zim.entity.ZIMRoomMemberAttributesUpdateInfo;
import im.zego.zim.entity.ZIMRoomOperatedInfo;
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

    public static HashMap<ZIM, String> engineMapForCallback = new HashMap<>();

    public void setSink(EventChannel.EventSink sink){
        mysink = sink;
    }
    @Override
    public void onConnectionStateChanged(ZIM zim, ZIMConnectionState state, ZIMConnectionEvent event, JSONObject extendedData) {
        if(mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConnectionStateChanged");
        resultMap.put("handle", handle);
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
        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onError");
        resultMap.put("handle", handle);
        resultMap.put("code",errorInfo.code.value());
        resultMap.put("message",errorInfo.message);
        mysink.success(resultMap);
    }

    @Override
    public void onTokenWillExpire(ZIM zim, int second) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onTokenWillExpire");
        resultMap.put("handle", handle);
        resultMap.put("second",second);
        mysink.success(resultMap);
    }

    @Override
    public void onConversationChanged(ZIM zim, ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConversationChanged");
        resultMap.put("handle", handle);
        resultMap.put("conversationChangeInfoList",ZIMPluginConverter.mZIMConversationChangeInfoList(conversationChangeInfoList));
        mysink.success(resultMap);
    }

    @Override
    public void onConversationTotalUnreadMessageCountUpdated(ZIM zim, int totalUnreadMessageCount) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onConversationTotalUnreadMessageCountUpdated");
        resultMap.put("handle", handle);
        resultMap.put("totalUnreadMessageCount",totalUnreadMessageCount);
        mysink.success(resultMap);
    }

    @Override
    public void onReceivePeerMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromUserID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceivePeerMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList",ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromUserID",fromUserID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveRoomMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromRoomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceiveRoomMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList",ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromRoomID",fromRoomID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveGroupMessage(ZIM zim, ArrayList<ZIMMessage> messageList, String fromGroupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onReceiveGroupMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList",ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromGroupID",fromGroupID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberJoined(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomMemberJoined");
        resultMap.put("handle", handle);
        resultMap.put("memberList",ZIMPluginConverter.mZIMUserInfoList(memberList));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberLeft(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomMemberLeft");
        resultMap.put("handle", handle);
        resultMap.put("memberList",ZIMPluginConverter.mZIMUserInfoList(memberList));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);

    }

    @Override
    public void onRoomStateChanged(ZIM zim, ZIMRoomState state, ZIMRoomEvent event, JSONObject extendedData, String roomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("extendedData",extendedData.toString());
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesUpdated(ZIM zim, ZIMRoomAttributesUpdateInfo info, String roomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomAttributesUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo",ZIMPluginConverter.mZIMRoomAttributesUpdateInfo(info));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesBatchUpdated(ZIM zim, ArrayList<ZIMRoomAttributesUpdateInfo> infos, String roomID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomAttributesBatchUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo",ZIMPluginConverter.mZIMRoomAttributesUpdateInfoList(infos));
        resultMap.put("roomID",roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberAttributesUpdated(ZIM zim, ArrayList<ZIMRoomMemberAttributesUpdateInfo> infos, ZIMRoomOperatedInfo operatedInfo, String roomID) {
        if(mysink == null){
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onRoomMemberAttributesUpdated");
        resultMap.put("handle",handle);
        ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
        for (ZIMRoomMemberAttributesUpdateInfo updateInfo:
             infos) {
            infosModel.add(ZIMPluginConverter.mZIMRoomMemberAttributesUpdateInfo(updateInfo));
        }
        resultMap.put("infos",infosModel);
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMRoomOperatedInfo(operatedInfo));
        resultMap.put("roomID",roomID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupStateChanged(ZIM zim, ZIMGroupState state, ZIMGroupEvent event, ZIMGroupOperatedInfo operatedInfo, ZIMGroupFullInfo groupInfo) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupInfo",ZIMPluginConverter.mZIMGroupFullInfo(groupInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNameUpdated(ZIM zim, String groupName, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupNameUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupName",groupName);
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNoticeUpdated(ZIM zim, String groupNotice, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupNoticeUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupNotice",groupNotice);
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAvatarUrlUpdated(ZIM zim, String groupAvatarUrl, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupAvatarUrlUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupID",groupID);
        resultMap.put("groupAvatarUrl",groupAvatarUrl);
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAttributesUpdated(ZIM zim, ArrayList<ZIMGroupAttributesUpdateInfo> infos, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupAttributesUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo",ZIMPluginConverter.mZIMGroupAttributesUpdateInfoList(infos));
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberStateChanged(ZIM zim, ZIMGroupMemberState state, ZIMGroupMemberEvent event, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupMemberStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state",state.value());
        resultMap.put("event",event.value());
        resultMap.put("userList",ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberInfoUpdated(ZIM zim, ArrayList<ZIMGroupMemberInfo> userList, ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onGroupMemberInfoUpdated");
        resultMap.put("handle", handle);
        resultMap.put("userList",ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
        resultMap.put("operatedInfo",ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID",groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationReceived(ZIM zim, ZIMCallInvitationReceivedInfo info, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationReceived");
        resultMap.put("handle", handle);
        resultMap.put("info",ZIMPluginConverter.mZIMCallInvitationReceivedInfo(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationCancelled(ZIM zim, ZIMCallInvitationCancelledInfo info, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationCancelled");
        resultMap.put("handle", handle);
        resultMap.put("info",ZIMPluginConverter.mZIMCallInvitationCancelledInfo(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationAccepted(ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationAccepted");
        resultMap.put("handle", handle);
        resultMap.put("info",ZIMPluginConverter.mZIMCallInvitationAcceptedInfo(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationRejected(ZIM zim, ZIMCallInvitationRejectedInfo info, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationRejected");
        resultMap.put("handle", handle);
        resultMap.put("info",ZIMPluginConverter.mZIMCallInvitationRejectedInfo(info));
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationTimeout(ZIM zim, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInvitationTimeout");
        resultMap.put("handle", handle);
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInviteesAnsweredTimeout(ZIM zim, ArrayList<String> invitees, String callID) {
        if(mysink == null){
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        resultMap.put("method","onCallInviteesAnsweredTimeout");
        resultMap.put("handle", handle);
        resultMap.put("invitees",invitees);
        resultMap.put("callID",callID);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageReceiptChanged(ZIM zim, ArrayList<ZIMMessageReceiptInfo> infos) {
        if(mysink == null){
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
        for (ZIMMessageReceiptInfo info:infos
        ) {
            infosModel.add(ZIMPluginConverter.mZIMMessageReceiptInfo(info));
        }
        resultMap.put("infos",infosModel);
        resultMap.put("method","onMessageReceiptChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageRevokeReceived(ZIM zim, ArrayList<ZIMRevokeMessage> messageList) {
        if(mysink == null){
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String,Object> resultMap = new HashMap<>();
        ArrayList<ZIMMessage> tmpMessageList = new ArrayList<>(messageList);
        resultMap.put("messageList",ZIMPluginConverter.mZIMMessageList(tmpMessageList));
        resultMap.put("method","onMessageRevokeReceived");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onConversationMessageReceiptChanged(ZIM zim, ArrayList<ZIMMessageReceiptInfo> infos) {
        if(mysink == null){
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String,Object> resultMap = new HashMap<>();
        ArrayList<HashMap<String,Object>> infosModel = new ArrayList<>();
        for (ZIMMessageReceiptInfo info:infos
        ) {
            infosModel.add(ZIMPluginConverter.mZIMMessageReceiptInfo(info));
        }
        resultMap.put("infos",infosModel);
        resultMap.put("method","onConversationMessageReceiptChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }
}


