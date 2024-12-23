package im.zego.zim_flutter.internal;

import im.zego.zim.ZIM;
import im.zego.zim.callback.*;
import im.zego.zim.entity.*;
import im.zego.zim.enums.*;
import io.flutter.plugin.common.EventChannel;
import java.util.ArrayList;
import java.util.HashMap;
import org.json.*;

public class ZIMPluginEventHandler extends ZIMEventHandler {

    public static EventChannel.EventSink mysink = null;

    public static HashMap<ZIM, String> engineMapForCallback = new HashMap<>();

    public void setSink(EventChannel.EventSink sink) { mysink = sink; }
    @Override
    public void onConnectionStateChanged(ZIM zim, ZIMConnectionState state,
                                         ZIMConnectionEvent event, JSONObject extendedData) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onConnectionStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state", state.value());
        resultMap.put("event", event.value());
        resultMap.put("extendedData", extendedData.toString());
        mysink.success(resultMap);
    }

    @Override
    public void onError(ZIM zim, ZIMError errorInfo) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onError");
        resultMap.put("handle", handle);
        resultMap.put("code", errorInfo.code.value());
        resultMap.put("message", errorInfo.message);
        mysink.success(resultMap);
    }

    @Override
    public void onTokenWillExpire(ZIM zim, int second) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onTokenWillExpire");
        resultMap.put("handle", handle);
        resultMap.put("second", second);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageSentStatusChanged(
        ZIM zim, ArrayList<ZIMMessageSentStatusChangeInfo> messageSentStatusChangeInfoList) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onMessageSentStatusChanged");
        resultMap.put("handle", handle);
        resultMap.put("messageSentStatusChangeInfoList",
                      ZIMPluginConverter.mZIMMessageSentStatusChangeInfoList(
                          messageSentStatusChangeInfoList));

        mysink.success(resultMap);
    }

    @Override
    public void
    onConversationChanged(ZIM zim,
                          ArrayList<ZIMConversationChangeInfo> conversationChangeInfoList) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onConversationChanged");
        resultMap.put("handle", handle);
        resultMap.put(
            "conversationChangeInfoList",
            ZIMPluginConverter.mZIMConversationChangeInfoList(conversationChangeInfoList));
        mysink.success(resultMap);
    }

    @Override
    public void onConversationTotalUnreadMessageCountUpdated(ZIM zim, int totalUnreadMessageCount) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onConversationTotalUnreadMessageCountUpdated");
        resultMap.put("handle", handle);
        resultMap.put("totalUnreadMessageCount", totalUnreadMessageCount);
        mysink.success(resultMap);
    }

    @Override
    public void onReceivePeerMessage(ZIM zim, ArrayList<ZIMMessage> messageList,
                                     String fromUserID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onReceivePeerMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromUserID", fromUserID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveRoomMessage(ZIM zim, ArrayList<ZIMMessage> messageList,
                                     String fromRoomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onReceiveRoomMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromRoomID", fromRoomID);

        mysink.success(resultMap);
    }

    @Override
    public void onReceiveGroupMessage(ZIM zim, ArrayList<ZIMMessage> messageList,
                                      String fromGroupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onReceiveGroupMessage");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("fromGroupID", fromGroupID);

        mysink.success(resultMap);
    }

    @Override
    public void onPeerMessageReceived(ZIM zim, ArrayList<ZIMMessage> messageList,
                                      ZIMMessageReceivedInfo info, String fromUserID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onPeerMessageReceived");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("info", ZIMPluginConverter.mZIMMessageReceivedInfo(info));
        resultMap.put("fromUserID", fromUserID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMessageReceived(ZIM zim, ArrayList<ZIMMessage> messageList,
                                      ZIMMessageReceivedInfo info, String fromRoomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomMessageReceived");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("info", ZIMPluginConverter.mZIMMessageReceivedInfo(info));
        resultMap.put("fromRoomID", fromRoomID);

        mysink.success(resultMap);
    }

    @Override
    public void onGroupMessageReceived(ZIM zim, ArrayList<ZIMMessage> messageList,
                                       ZIMMessageReceivedInfo info, String fromGroupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupMessageReceived");
        resultMap.put("handle", handle);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("info", ZIMPluginConverter.mZIMMessageReceivedInfo(info));
        resultMap.put("fromGroupID", fromGroupID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberJoined(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomMemberJoined");
        resultMap.put("handle", handle);
        resultMap.put("memberList", ZIMPluginConverter.mZIMUserInfoList(memberList));
        resultMap.put("roomID", roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberLeft(ZIM zim, ArrayList<ZIMUserInfo> memberList, String roomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomMemberLeft");
        resultMap.put("handle", handle);
        resultMap.put("memberList", ZIMPluginConverter.mZIMUserInfoList(memberList));
        resultMap.put("roomID", roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomStateChanged(ZIM zim, ZIMRoomState state, ZIMRoomEvent event,
                                   JSONObject extendedData, String roomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state", state.value());
        resultMap.put("event", event.value());
        resultMap.put("extendedData", extendedData.toString());
        resultMap.put("roomID", roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesUpdated(ZIM zim, ZIMRoomAttributesUpdateInfo info, String roomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomAttributesUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo", ZIMPluginConverter.mZIMRoomAttributesUpdateInfo(info));
        resultMap.put("roomID", roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomAttributesBatchUpdated(ZIM zim, ArrayList<ZIMRoomAttributesUpdateInfo> infos,
                                             String roomID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomAttributesBatchUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo", ZIMPluginConverter.mZIMRoomAttributesUpdateInfoList(infos));
        resultMap.put("roomID", roomID);

        mysink.success(resultMap);
    }

    @Override
    public void onRoomMemberAttributesUpdated(ZIM zim,
                                              ArrayList<ZIMRoomMemberAttributesUpdateInfo> infos,
                                              ZIMRoomOperatedInfo operatedInfo, String roomID) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onRoomMemberAttributesUpdated");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> infosModel = new ArrayList<>();
        for (ZIMRoomMemberAttributesUpdateInfo updateInfo : infos) {
            infosModel.add(ZIMPluginConverter.mZIMRoomMemberAttributesUpdateInfo(updateInfo));
        }
        resultMap.put("infos", infosModel);
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMRoomOperatedInfo(operatedInfo));
        resultMap.put("roomID", roomID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupStateChanged(ZIM zim, ZIMGroupState state, ZIMGroupEvent event,
                                    ZIMGroupOperatedInfo operatedInfo, ZIMGroupFullInfo groupInfo) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state", state.value());
        resultMap.put("event", event.value());
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupInfo", ZIMPluginConverter.mZIMGroupFullInfo(groupInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNameUpdated(ZIM zim, String groupName, ZIMGroupOperatedInfo operatedInfo,
                                   String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupNameUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupName", groupName);
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAliasUpdated(ZIM zim, String groupAlias, String operatedUserID,
                                    String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupAliasUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupAlias", groupAlias);
        resultMap.put("operatedUserID", operatedUserID);
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupNoticeUpdated(ZIM zim, String groupNotice, ZIMGroupOperatedInfo operatedInfo,
                                     String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupNoticeUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupNotice", groupNotice);
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAvatarUrlUpdated(ZIM zim, String groupAvatarUrl,
                                        ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupAvatarUrlUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupID", groupID);
        resultMap.put("groupAvatarUrl", groupAvatarUrl);
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMutedInfoUpdated(ZIM zim, ZIMGroupMuteInfo muteInfo,
                                        ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupMutedInfoUpdated");
        resultMap.put("handle", handle);
        resultMap.put("groupID", groupID);
        resultMap.put("groupMuteInfo", ZIMPluginConverter.mZIMGroupMuteInfo(muteInfo));
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onGroupAttributesUpdated(ZIM zim, ArrayList<ZIMGroupAttributesUpdateInfo> infos,
                                         ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupAttributesUpdated");
        resultMap.put("handle", handle);
        resultMap.put("updateInfo", ZIMPluginConverter.mZIMGroupAttributesUpdateInfoList(infos));
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberStateChanged(ZIM zim, ZIMGroupMemberState state,
                                          ZIMGroupMemberEvent event,
                                          ArrayList<ZIMGroupMemberInfo> userList,
                                          ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupMemberStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("state", state.value());
        resultMap.put("event", event.value());
        resultMap.put("userList", ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupMemberInfoUpdated(ZIM zim, ArrayList<ZIMGroupMemberInfo> userList,
                                         ZIMGroupOperatedInfo operatedInfo, String groupID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupMemberInfoUpdated");
        resultMap.put("handle", handle);
        resultMap.put("userInfo", ZIMPluginConverter.mZIMGroupMemberInfoList(userList));
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationReceived(ZIM zim, ZIMCallInvitationReceivedInfo info,
                                         String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationReceived");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationReceivedInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationCancelled(ZIM zim, ZIMCallInvitationCancelledInfo info,
                                          String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationCancelled");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationCancelledInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationAccepted(ZIM zim, ZIMCallInvitationAcceptedInfo info,
                                         String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationAccepted");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationAcceptedInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationRejected(ZIM zim, ZIMCallInvitationRejectedInfo info,
                                         String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationRejected");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationRejectedInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationTimeout(ZIM zim, ZIMCallInvitationTimeoutInfo info, String callID) {
        super.onCallInvitationTimeout(zim, info, callID);
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationTimeout");
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationTimeoutInfo(info));
        resultMap.put("handle", handle);
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInviteesAnsweredTimeout(ZIM zim, ArrayList<String> invitees, String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInviteesAnsweredTimeout");
        resultMap.put("handle", handle);
        resultMap.put("invitees", invitees);
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    public void onCallInvitationCreated(ZIM zim, ZIMCallInvitationCreatedInfo info, String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationCreated");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationCreatedInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallInvitationEnded(ZIM zim, ZIMCallInvitationEndedInfo info, String callID) {
        if (mysink == null) {
            return;
        }

        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallInvitationEnded");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallInvitationEndedInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onCallUserStateChanged(ZIM zim, ZIMCallUserStateChangeInfo info, String callID) {
        super.onCallUserStateChanged(zim, info, callID);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onCallUserStateChanged");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMCallUserStateChangeInfo(info));
        resultMap.put("callID", callID);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageReceiptChanged(ZIM zim, ArrayList<ZIMMessageReceiptInfo> infos) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        ArrayList<HashMap<String, Object>> infosModel = new ArrayList<>();
        for (ZIMMessageReceiptInfo info : infos) {
            LogWriter.writeLog("isSelfOperated:" + info.isSelfOperated);
            HashMap<String, Object> map = ZIMPluginConverter.mZIMMessageReceiptInfo(info);
            infosModel.add(map);
            LogWriter.writeLog("info:" + map);
        }
        resultMap.put("infos", infosModel);
        resultMap.put("method", "onMessageReceiptChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageRevokeReceived(ZIM zim, ArrayList<ZIMRevokeMessage> messageList) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        ArrayList<ZIMMessage> tmpMessageList = new ArrayList<>(messageList);
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(tmpMessageList));
        resultMap.put("method", "onMessageRevokeReceived");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onBroadcastMessageReceived(ZIM zim, ZIMMessage message) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("message", ZIMPluginConverter.mZIMMessage(message));
        resultMap.put("method", "onBroadcastMessageReceived");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageRepliedInfoChanged(ZIM zim, ArrayList<ZIMMessage> messageList) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("messageList", ZIMPluginConverter.mZIMMessageList(messageList));
        resultMap.put("method", "onMessageRepliedInfoChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageRepliedCountChanged(ZIM zim,
                                             ArrayList<ZIMMessageRootRepliedCountInfo> infos) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("infos", ZIMPluginConverter.mZIMMessageRootRepliedCountInfoList(infos));
        resultMap.put("method", "onMessageRepliedCountChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onConversationsAllDeleted(ZIM zim, ZIMConversationsAllDeletedInfo info) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onConversationsAllDeleted");
        resultMap.put("info", ZIMPluginConverter.mZIMConversationsAllDeletedInfo(info));
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onConversationMessageReceiptChanged(ZIM zim,
                                                    ArrayList<ZIMMessageReceiptInfo> infos) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        ArrayList<HashMap<String, Object>> infosModel = new ArrayList<>();
        for (ZIMMessageReceiptInfo info : infos) {
            infosModel.add(ZIMPluginConverter.mZIMMessageReceiptInfo(info));
        }
        resultMap.put("infos", infosModel);
        resultMap.put("method", "onConversationMessageReceiptChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onMessageReactionsChanged(ZIM zim, ArrayList<ZIMMessageReaction> reactions) {
        super.onMessageReactionsChanged(zim, reactions);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("reactions", ZIMPluginConverter.mZIMMessageReactionList(reactions));
        resultMap.put("method", "onMessageReactionsChanged");
        resultMap.put("handle", handle);
        mysink.success(resultMap);
    }

    @Override
    public void onUserInfoUpdated(ZIM zim, ZIMUserFullInfo info) {
        super.onUserInfoUpdated(zim, info);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onUserInfoUpdated");
        resultMap.put("handle", handle);
        resultMap.put("info", ZIMPluginConverter.mZIMUserFullInfo(info));
        mysink.success(resultMap);
    }

    @Override
    public void onUserRuleUpdated(ZIM zim, ZIMUserRule rule) {
        super.onUserRuleUpdated(zim, rule);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onUserRuleUpdated");
        resultMap.put("handle", handle);
        resultMap.put("userRule", ZIMPluginConverter.mZIMUserRule(rule));
        mysink.success(resultMap);
    }

    @Override
    public void onUserStatusUpdated(ZIM zim, ArrayList<ZIMUserStatus> userStatusList) {
        super.onUserStatusUpdated(zim, userStatusList);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onUserStatusUpdated");
        resultMap.put("handle", handle);
        resultMap.put("userStatusList", ZIMPluginConverter.mZIMUserStatusList(userStatusList));
        mysink.success(resultMap);
    }

    @Override
    public void onMessageDeleted(ZIM zim, ZIMMessageDeletedInfo deletedInfo) {
        super.onMessageDeleted(zim, deletedInfo);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onMessageDeleted");
        resultMap.put("handle", handle);
        resultMap.put("deletedInfo", ZIMPluginConverter.mZIMMessageDeletedInfo(deletedInfo));
        mysink.success(resultMap);
    }

    @Override
    public void onFriendInfoUpdated(ZIM zim, ArrayList<ZIMFriendInfo> friendInfoList) {
        super.onFriendInfoUpdated(zim, friendInfoList);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onFriendInfoUpdated");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> infoList = new ArrayList<>();
        for (ZIMFriendInfo info : friendInfoList) {
            infoList.add(
                ZIMPluginConverter.mZIMFriendInfo(info)); // 假设存在 mZIMFriendInfo 转换函数
        }
        resultMap.put("friendInfoList", infoList);
        mysink.success(resultMap);
    }

    @Override
    public void onFriendListChanged(ZIM zim, ArrayList<ZIMFriendInfo> friendInfoList,
                                    ZIMFriendListChangeAction action) {
        super.onFriendListChanged(zim, friendInfoList, action);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onFriendListChanged");
        resultMap.put("handle", handle);
        resultMap.put("action", action.value()); // 假设 ZIMFriendListChangeAction 可以直接存储
        ArrayList<HashMap<String, Object>> infoList = new ArrayList<>();
        for (ZIMFriendInfo info : friendInfoList) {
            infoList.add(
                ZIMPluginConverter.mZIMFriendInfo(info)); // 假设存在 mZIMFriendInfo 转换函数
        }
        resultMap.put("friendInfoList", infoList);
        mysink.success(resultMap);
    }

    @Override
    public void
    onFriendApplicationUpdated(ZIM zim,
                               ArrayList<ZIMFriendApplicationInfo> friendApplicationInfoList) {
        super.onFriendApplicationUpdated(zim, friendApplicationInfoList);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onFriendApplicationUpdated");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> infoList = new ArrayList<>();
        for (ZIMFriendApplicationInfo info : friendApplicationInfoList) {
            infoList.add(ZIMPluginConverter.mZIMFriendApplicationInfo(
                info)); // 假设存在 mZIMFriendApplicationInfo 转换函数
        }
        resultMap.put("friendApplicationInfoList", infoList);
        mysink.success(resultMap);
    }

    @Override
    public void
    onFriendApplicationListChanged(ZIM zim,
                                   ArrayList<ZIMFriendApplicationInfo> friendApplicationInfoList,
                                   ZIMFriendApplicationListChangeAction action) {
        super.onFriendApplicationListChanged(zim, friendApplicationInfoList, action);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onFriendApplicationListChanged");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> infoList = new ArrayList<>();
        for (ZIMFriendApplicationInfo info : friendApplicationInfoList) {
            infoList.add(ZIMPluginConverter.mZIMFriendApplicationInfo(
                info)); // 假设存在 mZIMFriendApplicationInfo 转换函数
        }
        resultMap.put("action", action.value());
        resultMap.put("friendApplicationInfoList", infoList);
        mysink.success(resultMap);
    }

    @Override
    public void onBlacklistChanged(ZIM zim, ArrayList<ZIMUserInfo> userList,
                                   ZIMBlacklistChangeAction action) {
        super.onBlacklistChanged(zim, userList, action);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onBlacklistChanged");
        resultMap.put("handle", handle);
        resultMap.put("action", action.value()); // 假设 ZIMBlacklistChangedAction 可以直接存储
        ArrayList<HashMap<String, Object>> userListMap = new ArrayList<>();
        for (ZIMUserInfo userInfo : userList) {
            userListMap.add(
                ZIMPluginConverter.mZIMUserInfo(userInfo)); // 假设存在 mZIMUserInfo 转换函数
        }
        resultMap.put("userList", userListMap);
        mysink.success(resultMap);
    }

    @Override
    public void onGroupVerifyInfoUpdated(ZIM zim, ZIMGroupVerifyInfo verifyInfo,
                                         ZIMGroupOperatedInfo operatedInfo, String groupID) {
        super.onGroupVerifyInfoUpdated(zim, verifyInfo, operatedInfo, groupID);
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupVerifyInfoUpdated");
        resultMap.put("handle", handle);
        resultMap.put("verifyInfo", ZIMPluginConverter.mZIMGroupVerifyInfo(verifyInfo));
        resultMap.put("operatedInfo", ZIMPluginConverter.mZIMGroupOperatedInfo(operatedInfo));
        resultMap.put("groupID", groupID);

        mysink.success(resultMap);
    }

    @Override
    public void onGroupApplicationListChanged(ZIM zim,
                                              ArrayList<ZIMGroupApplicationInfo> applicationList,
                                              ZIMGroupApplicationListChangeAction action) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupApplicationListChanged");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> applicationInfoMapList = new ArrayList<>();
        for (ZIMGroupApplicationInfo applicationInfo : applicationList) {
            HashMap<String, Object> applicationInfoMap =
                ZIMPluginConverter.mZIMGroupApplicationInfo(
                    applicationInfo); // 假设存在 mZIMFriendApplicationInfo 转换函数
            applicationInfoMapList.add(applicationInfoMap);
        }
        resultMap.put("applicationList", applicationInfoMapList);
        resultMap.put("action", action.value());
        mysink.success(resultMap);
    }

    @Override
    public void onGroupApplicationUpdated(ZIM zim,
                                          ArrayList<ZIMGroupApplicationInfo> applicationList) {
        if (mysink == null) {
            return;
        }
        String handle = engineMapForCallback.get(zim);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onGroupApplicationUpdated");
        resultMap.put("handle", handle);
        ArrayList<HashMap<String, Object>> applicationInfoMapList = new ArrayList<>();
        for (ZIMGroupApplicationInfo applicationInfo : applicationList) {
            HashMap<String, Object> applicationInfoMap =
                ZIMPluginConverter.mZIMGroupApplicationInfo(
                    applicationInfo); // 假设存在 mZIMFriendApplicationInfo 转换函数
            applicationInfoMapList.add(applicationInfoMap);
        }
        resultMap.put("applicationList", applicationInfoMapList);

        mysink.success(resultMap);
    }
}
