import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zego_zim/src/internal/zim_engine.dart';
import 'zim_common_data.dart';
import '../zim_event_handler.dart';
import '../zim_defines.dart';
import 'zim_defines_extension.dart';
import 'zim_converter.dart';
import 'zim_manager.dart';

class ZIMEventHandlerImpl implements ZIMEventHandler {
  static const EventChannel _event = EventChannel('zim_event_handler');
  static StreamSubscription<dynamic>? _streamSubscription;

  /* EventHandler */

  static void registerEventHandler() async {
    _streamSubscription = _event.receiveBroadcastStream().listen(eventListener);
  }

  static void unregisterEventHandler() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  static void eventListener(dynamic data) {
    final Map<dynamic, dynamic> map = data;
    ZIMEngine? zim = ZIMManager.engineMap[map['handle']];
    switch (map['method']) {
      case 'onConnectionStateChanged':
        if (ZIMEventHandler.onConnectionStateChanged == null) return;
        ZIMEventHandler.onConnectionStateChanged!(
            zim!,
            ZIMConnectionStateExtension.mapValue[map['state']]!,
            ZIMConnectionEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']));
        break;
      case 'onError':
        if (ZIMEventHandler.onError == null) return;
        ZIMError errorInfo =
            ZIMError(code: map['code'], message: map['message']);
        ZIMEventHandler.onError!(zim!, errorInfo);
        break;
      case 'onTokenWillExpire':
        if (ZIMEventHandler.onTokenWillExpire == null) return;
        ZIMEventHandler.onTokenWillExpire!(zim!, map['second']);
        break;
      case 'onConversationChanged':
        if (ZIMEventHandler.onConversationChanged == null) return;
        List<ZIMConversationChangeInfo> conversationChangeInfoList =
            ZIMConverter.oZIMConversationChangeInfoList(
                map['conversationChangeInfoList']);

        ZIMEventHandler.onConversationChanged!(
            zim!, conversationChangeInfoList);
        break;
      case 'onConversationTotalUnreadMessageCountUpdated':
        if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
            null) return;
        ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
            zim!, map['totalUnreadMessageCount']);
        break;
      case 'onReceivePeerMessage':
        if (ZIMEventHandler.onReceivePeerMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(
            zim!, messageList, map['fromUserID']);
        break;
      case 'onReceiveRoomMessage':
        if (ZIMEventHandler.onReceiveRoomMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceiveRoomMessage!(
            zim!, messageList, map['fromRoomID']);
        break;
      case 'onReceiveGroupMessage':
        if (ZIMEventHandler.onReceiveGroupMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceiveGroupMessage!(
            zim!, messageList, map['fromGroupID']);
        break;
      case 'onRoomMemberJoined':
        if (ZIMEventHandler.onRoomMemberJoined == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.oZIMUserInfoList(map['memberList']);
        ZIMEventHandler.onRoomMemberJoined!(zim!, memberList, map['roomID']);
        break;
      case 'onRoomMemberLeft':
        if (ZIMEventHandler.onRoomMemberLeft == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.oZIMUserInfoList(map['memberList']);
        ZIMEventHandler.onRoomMemberLeft!(zim!, memberList, map['roomID']);
        break;
      case 'onRoomStateChanged':
        if (ZIMEventHandler.onRoomStateChanged == null) return;
        ZIMEventHandler.onRoomStateChanged!(
            zim!,
            ZIMRoomStateExtension.mapValue[map['state']]!,
            ZIMRoomEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']),
            map['roomID']);
        break;
      case 'onRoomAttributesUpdated':
        if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

        ZIMEventHandler.onRoomAttributesUpdated!(
            zim!,
            ZIMConverter.oZIMRoomAttributesUpdateInfo(map['updateInfo']),
            map['roomID']);

        break;
      case 'onRoomAttributesBatchUpdated':
        if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

        ZIMEventHandler.onRoomAttributesBatchUpdated!(
            zim!,
            ZIMConverter.oZIMRoomAttributesUpdateInfoList(map['updateInfo']),
            map['roomID']);
        break;
      case 'onRoomMemberAttributesUpdated':
        if (ZIMEventHandler.onRoomMemberAttributesUpdated == null) return;
        List<Map> infosMap = (map['infos'] as List).cast<Map>();
        List<ZIMRoomMemberAttributesUpdateInfo> infoList = [];
        for (Map updateInfoMap in infosMap) {
          infoList.add(
              ZIMConverter.oZIMRoomMemberAttributesUpdateInfo(updateInfoMap));
        }
        ZIMEventHandler.onRoomMemberAttributesUpdated!(
            zim!,
            infoList,
            ZIMConverter.oZIMRoomOperatedInfo(map['operatedInfo']),
            map['roomID']);
        break;
      case 'onGroupStateChanged':
        if (ZIMEventHandler.onGroupStateChanged == null) return;

        ZIMEventHandler.onGroupStateChanged!(
            zim!,
            ZIMGroupStateExtension.mapValue[map['state']]!,
            ZIMGroupEventExtension.mapValue[map['event']]!,
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            ZIMConverter.oZIMGroupFullInfo(map['groupInfo'])!);
        break;
      case 'onGroupNameUpdated':
        if (ZIMEventHandler.onGroupNameUpdated == null) return;

        ZIMEventHandler.onGroupNameUpdated!(
            zim!,
            map['groupName'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupNoticeUpdated':
        if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

        ZIMEventHandler.onGroupNoticeUpdated!(
            zim!,
            map['groupNotice'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupAvatarUrlUpdated':
        if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;
        ZIMEventHandler.onGroupAvatarUrlUpdated!(
            zim!,
            map['groupAvatarUrl'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupAttributesUpdated':
        if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

        ZIMEventHandler.onGroupAttributesUpdated!(
            zim!,
            ZIMConverter.oZIMGroupAttributesUpdateInfoList(map['updateInfo']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberStateChanged':
        if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

        ZIMEventHandler.onGroupMemberStateChanged!(
            zim!,
            ZIMGroupMemberStateExtension.mapValue[map['state']]!,
            ZIMGroupMemberEventExtension.mapValue[map['event']]!,
            ZIMConverter.oZIMGroupMemberInfoList(map['userList']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberInfoUpdated':
        if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

        ZIMEventHandler.onGroupMemberInfoUpdated!(
            zim!,
            ZIMConverter.oZIMGroupMemberInfoList(map['userInfo']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onCallInvitationReceived':
        if (ZIMEventHandler.onCallInvitationReceived == null) return;

        ZIMEventHandler.onCallInvitationReceived!(
            zim!,
            ZIMConverter.oZIMCallInvitationReceivedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationCancelled':
        if (ZIMEventHandler.onCallInvitationCancelled == null) return;

        ZIMEventHandler.onCallInvitationCancelled!(
            zim!,
            ZIMConverter.oZIMCallInvitationCancelledInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationAccepted':
        if (ZIMEventHandler.onCallInvitationAccepted == null) return;

        ZIMEventHandler.onCallInvitationAccepted!(
            zim!,
            ZIMConverter.oZIMCallInvitationAcceptedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationRejected':
        if (ZIMEventHandler.onCallInvitationRejected == null) return;

        ZIMEventHandler.onCallInvitationRejected!(
            zim!,
            ZIMConverter.oZIMCallInvitationRejectedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationTimeout':
        if (ZIMEventHandler.onCallInvitationTimeout == null) return;

        ZIMEventHandler.onCallInvitationTimeout!(zim!, map['callID']);
        break;
      case 'onCallInviteesAnsweredTimeout':
        if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

        ZIMEventHandler.onCallInviteesAnsweredTimeout!(
            zim!, (map['invitees'] as List).cast<String>(), map['callID']);
        break;
      case 'onMessageAttached':
        int? messageAttachedCallbackID = map['messageAttachedCallbackID'];
        ZIMMessageAttachedCallback? onMessageAttached = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];
        if (onMessageAttached != null) {
          ZIMMessage message =
              ZIMConverter.oZIMMessage(map['message'], map['messageID']);
          onMessageAttached(message);
        }
        break;
      case 'downloadMediaFileProgress':
        int? progressID = map['progressID'];
        ZIMMessage message = ZIMConverter.oZIMMessage(map['message']);
        int currentFileSize = map['currentFileSize'];
        int totalFileSize = map['totalFileSize'];
        ZIMMediaDownloadingProgress? progress =
            ZIMCommonData.mediaDownloadingProgressMap[progressID ?? 0];
        if (progress != null) {
          progress(message, currentFileSize, totalFileSize);
        }
        break;
      case 'uploadMediaProgress':
        int? progressID = map['progressID'];
        ZIMMessage message =
            ZIMConverter.oZIMMessage(map['message'], map['messageID']);
        int currentFileSize = map['currentFileSize'];
        int totalFileSize = map['totalFileSize'];
        ZIMMediaUploadingProgress? progress =
            ZIMCommonData.mediaUploadingProgressMap[progressID ?? 0];
        if (progress != null) {
          progress(message, currentFileSize, totalFileSize);
        }
        break;
      case 'onMessageRevokeReceived':
        if (ZIMEventHandler.onMessageRevokeReceived == null) return;
        List<ZIMRevokeMessage> messageList = List<ZIMRevokeMessage>.from(ZIMConverter.oZIMMessageList(map['messageList']));
        ZIMEventHandler.onMessageRevokeReceived!(zim!,messageList);
        break;
      case 'onMessageReceiptChanged':
        if (ZIMEventHandler.onMessageReceiptChanged == null) return;
        List<ZIMMessageReceiptInfo> infos = [];
        for(Map infoModel in map['infos']){
          infos.add(ZIMConverter.oZIMMessageReceiptInfo(infoModel));
        }
        ZIMEventHandler.onMessageReceiptChanged!(zim!,infos);
        break;
      case 'onConversationMessageReceiptChanged':
        if (ZIMEventHandler.onConversationMessageReceiptChanged == null) return;
        List<ZIMMessageReceiptInfo> infos = [];
        for(Map infoModel in map['infos']){
          infos.add(ZIMConverter.oZIMMessageReceiptInfo(infoModel));
        }
        ZIMEventHandler.onConversationMessageReceiptChanged!(zim!,infos);
        break;
      default:
        break;
    }
  }
}
