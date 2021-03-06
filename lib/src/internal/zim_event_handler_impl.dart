import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'zim_common_data.dart';
import '../zim_event_handler.dart';
import '../zim_defines.dart';
import 'zim_defines_extension.dart';
import 'zim_converter.dart';

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
    switch (map['method']) {
      case 'onConnectionStateChanged':
        if (ZIMEventHandler.onConnectionStateChanged == null) return;
        ZIMEventHandler.onConnectionStateChanged!(
            ZIMConnectionStateExtension.mapValue[map['state']]!,
            ZIMConnectionEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']));
        break;
      case 'onError':
        if (ZIMEventHandler.onError == null) return;
        ZIMError errorInfo =
            ZIMError(code: map['code'], message: map['message']);
        ZIMEventHandler.onError!(errorInfo);
        break;
      case 'onTokenWillExpire':
        if (ZIMEventHandler.onTokenWillExpire == null) return;
        ZIMEventHandler.onTokenWillExpire!(map['second']);
        break;
      case 'onConversationChanged':
        if (ZIMEventHandler.onConversationChanged == null) return;
        List<ZIMConversationChangeInfo> conversationChangeInfoList =
            ZIMConverter.cnvZIMConversationChangeInfoListBasicToObject(
                map['conversationChangeInfoList']);

        ZIMEventHandler.onConversationChanged!(conversationChangeInfoList);
        break;
      case 'onConversationTotalUnreadMessageCountUpdated':
        if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
            null) return;
        ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
            map['totalUnreadMessageCount']);
        break;
      case 'onReceivePeerMessage':
        if (ZIMEventHandler.onReceivePeerMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(messageList, map['fromUserID']);
        break;
      case 'onReceiveRoomMessage':
        if (ZIMEventHandler.onReceiveRoomMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceiveRoomMessage!(messageList, map['fromRoomID']);
        break;
      case 'onReceiveGroupMessage':
        if (ZIMEventHandler.onReceiveGroupMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceiveGroupMessage!(messageList, map['fromGroupID']);
        break;
      case 'onRoomMemberJoined':
        if (ZIMEventHandler.onRoomMemberJoined == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.cnvZIMUserInfoListBasicToObject(map['memberList']);
        ZIMEventHandler.onRoomMemberJoined!(memberList, map['roomID']);
        break;
      case 'onRoomMemberLeft':
        if (ZIMEventHandler.onRoomMemberLeft == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.cnvZIMUserInfoListBasicToObject(map['memberList']);
        ZIMEventHandler.onRoomMemberLeft!(memberList, map['roomID']);
        break;
      case 'onRoomStateChanged':
        if (ZIMEventHandler.onRoomStateChanged == null) return;
        ZIMEventHandler.onRoomStateChanged!(
            ZIMRoomStateExtension.mapValue[map['state']]!,
            ZIMRoomEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']),
            map['roomID']);
        break;
      case 'onRoomAttributesUpdated':
        if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

        ZIMEventHandler.onRoomAttributesUpdated!(
            ZIMConverter.cnvZIMRoomAttributesUpdateInfoMapToObject(
                map['updateInfo']),
            map['roomID']);

        break;
      case 'onRoomAttributesBatchUpdated':
        if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

        ZIMEventHandler.onRoomAttributesBatchUpdated!(
            ZIMConverter.cnvZIMRoomAttributesUpdateInfoListBasicToObject(
                map['updateInfo']),
            map['roomID']);
        break;

      case 'onGroupStateChanged':
        if (ZIMEventHandler.onGroupStateChanged == null) return;

        ZIMEventHandler.onGroupStateChanged!(
            ZIMGroupStateExtension.mapValue[map['state']]!,
            ZIMGroupEventExtension.mapValue[map['event']]!,
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            ZIMConverter.cnvZIMGroupFullInfoMapToObject(map['groupInfo'])!);
        break;
      case 'onGroupNameUpdated':
        if (ZIMEventHandler.onGroupNameUpdated == null) return;

        ZIMEventHandler.onGroupNameUpdated!(
            map['groupName'],
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupNoticeUpdated':
        if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

        ZIMEventHandler.onGroupNoticeUpdated!(
            map['groupNotice'],
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupAttributesUpdated':
        if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

        ZIMEventHandler.onGroupAttributesUpdated!(
            ZIMConverter.cnvBasicListToZIMGroupAttributesUpdateInfoList(
                map['updateInfo']),
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberStateChanged':
        if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

        ZIMEventHandler.onGroupMemberStateChanged!(
            ZIMGroupMemberStateExtension.mapValue[map['state']]!,
            ZIMGroupMemberEventExtension.mapValue[map['event']]!,
            ZIMConverter.cnvBasicListToZIMGroupMemberInfoList(map['userList']),
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberInfoUpdated':
        if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

        ZIMEventHandler.onGroupMemberInfoUpdated!(
            ZIMConverter.cnvBasicListToZIMGroupMemberInfoList(map['userInfo']),
            ZIMConverter.cnvZIMGroupOperatedInfoMapToObject(
                map['operatedInfo']),
            map['groupID']);
        break;
      case 'onCallInvitationReceived':
        if (ZIMEventHandler.onCallInvitationReceived == null) return;

        ZIMEventHandler.onCallInvitationReceived!(
            ZIMConverter.cnvZIMCallInvitationReceivedInfoMapToObject(
                map['info']),
            map['callID']);
        break;
      case 'onCallInvitationCancelled':
        if (ZIMEventHandler.onCallInvitationCancelled == null) return;

        ZIMEventHandler.onCallInvitationCancelled!(
            ZIMConverter.cnvZIMCallInvitationCancelledInfoMapToObject(
                map['info']),
            map['callID']);
        break;
      case 'onCallInvitationAccepted':
        if (ZIMEventHandler.onCallInvitationAccepted == null) return;

        ZIMEventHandler.onCallInvitationAccepted!(
            ZIMConverter.cnvZIMCallInvitationAcceptedInfoMapToObject(
                map['info']),
            map['callID']);
        break;
      case 'onCallInvitationRejected':
        if (ZIMEventHandler.onCallInvitationRejected == null) return;

        ZIMEventHandler.onCallInvitationRejected!(
            ZIMConverter.cnvZIMCallInvitationRejectedInfoMapToObject(
                map['info']),
            map['callID']);
        break;
      case 'onCallInvitationTimeout':
        if (ZIMEventHandler.onCallInvitationTimeout == null) return;

        ZIMEventHandler.onCallInvitationTimeout!(map['callID']);
        break;
      case 'onCallInviteesAnsweredTimeout':
        if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

        ZIMEventHandler.onCallInviteesAnsweredTimeout!(
            (map['invitees'] as List).cast<String>(), map['callID']);
        break;
      case 'downloadMediaFileProgress':
        int progressID = map['progressID'];
        ZIMMessage message =
            ZIMConverter.cnvZIMMessageMapToObject(map['message']);
        int currentFileSize = map['currentFileSize'];
        int totalFileSize = map['totalFileSize'];
        ZIMMediaDownloadingProgress? progress =
            ZIMCommonData.mediaDownloadingProgressMap[progressID];
        if (progress != null) {
          progress(message, currentFileSize, totalFileSize);
        }
        break;
      case 'uploadMediaProgress':
        int progressID = map['progressID'];
        ZIMMessage message =
            ZIMConverter.cnvZIMMessageMapToObject(map['message']);
        int currentFileSize = map['currentFileSize'];
        int totalFileSize = map['totalFileSize'];
        ZIMMediaUploadingProgress? progress =
            ZIMCommonData.mediaUploadingProgressMap[progressID];
        if (progress != null) {
          progress(message, currentFileSize, totalFileSize);
        }
        break;
      default:
        break;
    }
  }
}
