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
    if (zim == null) {
      return;
    }
    switch (map['method']) {
      case 'onConnectionStateChanged':
        if (ZIMEventHandler.onConnectionStateChanged == null) return;
        ZIMEventHandler.onConnectionStateChanged!(
            zim,
            ZIMConnectionStateExtension.mapValue[map['state']]!,
            ZIMConnectionEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']));
        break;
      case 'onError':
        if (ZIMEventHandler.onError == null) return;
        ZIMError errorInfo =
            ZIMError(code: map['code'], message: map['message']);
        ZIMEventHandler.onError!(zim, errorInfo);
        break;
      case 'onTokenWillExpire':
        if (ZIMEventHandler.onTokenWillExpire == null) return;
        ZIMEventHandler.onTokenWillExpire!(zim, map['second']);
        break;
      case 'onUserInfoUpdated':
        if (ZIMEventHandler.onUserInfoUpdated == null) return;
        ZIMUserFullInfo info = ZIMConverter.oZIMUserFullInfo(map['info']);
        ZIMEventHandler.onUserInfoUpdated!(zim, info);
        break;
      case 'onConversationChanged':
        if (ZIMEventHandler.onConversationChanged == null) return;
        List<ZIMConversationChangeInfo> conversationChangeInfoList =
            ZIMConverter.oZIMConversationChangeInfoList(
                map['conversationChangeInfoList']);

        ZIMEventHandler.onConversationChanged!(zim, conversationChangeInfoList);
        break;
      case 'onConversationsAllDeleted':
        if (ZIMEventHandler.onConversationsAllDeleted == null) return;
        ZIMEventHandler.onConversationsAllDeleted!(
            zim, ZIMConverter.oZIMConversationsAllDeletedInfo(map['info']));
        break;
      case 'onMessageSentStatusChanged':
        if (ZIMEventHandler.onMessageSentStatusChanged == null) return;
        List<ZIMMessageSentStatusChangeInfo> messageSentStatusChangeInfoList =
            ZIMConverter.oMessageSentStatusChangeInfoList(
                map['messageSentStatusChangeInfoList']);

        ZIMEventHandler.onMessageSentStatusChanged!(
            zim, messageSentStatusChangeInfoList);
        break;
      case 'onMessageDeleted':
        if (ZIMEventHandler.onMessageDeleted == null) return;
        ZIMMessageDeletedInfo info =
            ZIMConverter.oZIMMessageDeletedInfo(map['deletedInfo']);
        ZIMEventHandler.onMessageDeleted!(zim, info);
        break;
      case 'onConversationTotalUnreadMessageCountUpdated':
        if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
            null) return;
        ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
            zim, map['totalUnreadMessageCount']);
        break;
      case 'onReceivePeerMessage':
        if (ZIMEventHandler.onReceivePeerMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(
            zim, messageList, map['fromUserID']);
        break;
      case 'onReceiveRoomMessage':
        if (ZIMEventHandler.onReceiveRoomMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceiveRoomMessage!(
            zim, messageList, map['fromRoomID']);
        break;
      case 'onReceiveGroupMessage':
        if (ZIMEventHandler.onReceiveGroupMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.oZIMMessageList(map['messageList']);
        ZIMEventHandler.onReceiveGroupMessage!(
            zim, messageList, map['fromGroupID']);
        break;
      case 'onRoomMemberJoined':
        if (ZIMEventHandler.onRoomMemberJoined == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.oZIMUserInfoList(map['memberList']);
        ZIMEventHandler.onRoomMemberJoined!(zim, memberList, map['roomID']);
        break;
      case 'onRoomMemberLeft':
        if (ZIMEventHandler.onRoomMemberLeft == null) return;
        List<ZIMUserInfo> memberList =
            ZIMConverter.oZIMUserInfoList(map['memberList']);
        ZIMEventHandler.onRoomMemberLeft!(zim, memberList, map['roomID']);
        break;
      case 'onRoomStateChanged':
        if (ZIMEventHandler.onRoomStateChanged == null) return;
        ZIMEventHandler.onRoomStateChanged!(
            zim,
            ZIMRoomStateExtension.mapValue[map['state']]!,
            ZIMRoomEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']),
            map['roomID']);
        break;
      case 'onRoomAttributesUpdated':
        if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

        ZIMEventHandler.onRoomAttributesUpdated!(
            zim,
            ZIMConverter.oZIMRoomAttributesUpdateInfo(map['updateInfo']),
            map['roomID']);

        break;
      case 'onRoomAttributesBatchUpdated':
        if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

        ZIMEventHandler.onRoomAttributesBatchUpdated!(
            zim,
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
            zim,
            infoList,
            ZIMConverter.oZIMRoomOperatedInfo(map['operatedInfo']),
            map['roomID']);
        break;
      case 'onGroupStateChanged':
        if (ZIMEventHandler.onGroupStateChanged == null) return;

        ZIMEventHandler.onGroupStateChanged!(
            zim,
            ZIMGroupStateExtension.mapValue[map['state']]!,
            ZIMGroupEventExtension.mapValue[map['event']]!,
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            ZIMConverter.oZIMGroupFullInfo(map['groupInfo'])!);
        break;
      case 'onGroupNameUpdated':
        if (ZIMEventHandler.onGroupNameUpdated == null) return;

        ZIMEventHandler.onGroupNameUpdated!(
            zim,
            map['groupName'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupNoticeUpdated':
        if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

        ZIMEventHandler.onGroupNoticeUpdated!(
            zim,
            map['groupNotice'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupAvatarUrlUpdated':
        if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;
        ZIMEventHandler.onGroupAvatarUrlUpdated!(
            zim,
            map['groupAvatarUrl'],
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupAttributesUpdated':
        if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

        ZIMEventHandler.onGroupAttributesUpdated!(
            zim,
            ZIMConverter.oZIMGroupAttributesUpdateInfoList(map['updateInfo']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberStateChanged':
        if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

        ZIMEventHandler.onGroupMemberStateChanged!(
            zim,
            ZIMGroupMemberStateExtension.mapValue[map['state']]!,
            ZIMGroupMemberEventExtension.mapValue[map['event']]!,
            ZIMConverter.oZIMGroupMemberInfoList(map['userList']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onGroupMemberInfoUpdated':
        if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

        ZIMEventHandler.onGroupMemberInfoUpdated!(
            zim,
            ZIMConverter.oZIMGroupMemberInfoList(map['userInfo']),
            ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']),
            map['groupID']);
        break;
      case 'onCallInvitationReceived':
        if (ZIMEventHandler.onCallInvitationReceived == null) return;

        ZIMEventHandler.onCallInvitationReceived!(
            zim,
            ZIMConverter.oZIMCallInvitationReceivedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationCancelled':
        if (ZIMEventHandler.onCallInvitationCancelled == null) return;

        ZIMEventHandler.onCallInvitationCancelled!(
            zim,
            ZIMConverter.oZIMCallInvitationCancelledInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationAccepted':
        if (ZIMEventHandler.onCallInvitationAccepted == null) return;

        ZIMEventHandler.onCallInvitationAccepted!(
            zim,
            ZIMConverter.oZIMCallInvitationAcceptedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationRejected':
        if (ZIMEventHandler.onCallInvitationRejected == null) return;

        ZIMEventHandler.onCallInvitationRejected!(
            zim,
            ZIMConverter.oZIMCallInvitationRejectedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationTimeout':
        if (ZIMEventHandler.onCallInvitationTimeout == null) return;

        ZIMEventHandler.onCallInvitationTimeout!(
            zim,
            ZIMConverter.oZIMCallInvitationTimeoutInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInviteesAnsweredTimeout':
        if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

        ZIMEventHandler.onCallInviteesAnsweredTimeout!(
            zim, (map['invitees'] as List).cast<String>(), map['callID']);
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
      case 'messageExportingProgress':
        int? progressID = map['progressID'];
        int exportedMessageCount = map['exportedMessageCount'];
        int totalMessageCount = map['totalMessageCount'];
        ZIMMessageExportingProgress? progress =
        ZIMCommonData.messageExportingProgressMap[progressID ?? 0];
        if (progress != null) {
          progress(exportedMessageCount, totalMessageCount);
        }
        break;
      case 'messageImportingProgress':
        int? progressID = map['progressID'];
        int importedMessageCount = map['importedMessageCount'];
        int totalMessageCount = map['totalMessageCount'];
        ZIMMessageImportingProgress? progress =
        ZIMCommonData.messageImportingProgressMap[progressID ?? 0];
        if (progress != null) {
          progress(importedMessageCount, totalMessageCount);
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
        List<ZIMRevokeMessage> messageList = List<ZIMRevokeMessage>.from(
            ZIMConverter.oZIMMessageList(map['messageList']));
        ZIMEventHandler.onMessageRevokeReceived!(zim, messageList);
        break;
      case 'onMessageReceiptChanged':
        if (ZIMEventHandler.onMessageReceiptChanged == null) return;
        List<ZIMMessageReceiptInfo> infos = [];
        ZIMManager.writeLog(
            "Flutter onMessageReceiptChanged eventImpl,map:" + map.toString());
        for (Map infoModel in map['infos']) {
          infos.add(ZIMConverter.oZIMMessageReceiptInfo(infoModel));
        }
        ZIMEventHandler.onMessageReceiptChanged!(zim, infos);
        break;
      case 'onBroadcastMessageReceived':
        if (ZIMEventHandler.onBroadcastMessageReceived == null) return;
        ZIMEventHandler.onBroadcastMessageReceived!(
            zim, ZIMConverter.oZIMMessage(map['message']));
        break;
      case 'onConversationMessageReceiptChanged':
        if (ZIMEventHandler.onConversationMessageReceiptChanged == null) return;
        List<ZIMMessageReceiptInfo> infos = [];
        for (Map infoModel in map['infos']) {
          infos.add(ZIMConverter.oZIMMessageReceiptInfo(infoModel));
        }
        ZIMEventHandler.onConversationMessageReceiptChanged!(zim, infos);
        break;
      case 'onCallInvitationCreated':
        if (ZIMEventHandler.onCallInvitationCreated == null) return;
        ZIMEventHandler.onCallInvitationCreated!(
            zim,
            ZIMConverter.oZIMCallInvitationCreatedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallInvitationEnded':
        if (ZIMEventHandler.onCallInvitationEnded == null) return;
        ZIMEventHandler.onCallInvitationEnded!(
            zim,
            ZIMConverter.oZIMCallInvitationEndedInfo(map['info']),
            map['callID']);
        break;
      case 'onCallUserStateChanged':
        if (ZIMEventHandler.onCallUserStateChanged == null) return;
        String callID = map['callID'];
        ZIMEventHandler.onCallUserStateChanged!(zim,
            ZIMConverter.oZIMCallUserStateChangedInfo(map['info']), callID);
        break;
      case 'onMessageReactionsChanged':
        if (ZIMEventHandler.onMessageReactionsChanged == null) return;
        List<ZIMMessageReaction> reactions = List<ZIMMessageReaction>.from(ZIMConverter.oZIMMessageReactionList(map['reactions']));
        ZIMEventHandler.onMessageReactionsChanged!(zim,reactions);
        break;
      case 'onFriendInfoUpdated':
        if (ZIMEventHandler.onFriendInfoUpdated == null) return;
        List<ZIMFriendInfo> friendInfoList =  ZIMConverter.oZIMFriendInfoList(map['friendInfoList']);
        ZIMEventHandler.onFriendInfoUpdated!(zim, friendInfoList);
        break;
      case 'onFriendListChanged':
        if (ZIMEventHandler.onFriendListChanged == null) return;
        ZIMFriendListChangeAction action = ZIMFriendListChangeActionExtension.mapValue[map['action']]!;
        List<ZIMFriendInfo> friendInfoList = ZIMConverter.oZIMFriendInfoList(map['friendInfoList']);
        ZIMEventHandler.onFriendListChanged!(zim, friendInfoList ,action);
        break;

      case 'onFriendApplicationUpdated':
        if (ZIMEventHandler.onFriendApplicationUpdated == null) return;
        List<ZIMFriendApplicationInfo> friendApplicationInfoList = ZIMConverter.oZIMFriendApplicationInfoList(map['friendApplicationInfoList']);
        ZIMEventHandler.onFriendApplicationUpdated!(zim, friendApplicationInfoList);
        break;
      case 'onFriendApplicationListChanged':
        if (ZIMEventHandler.onFriendApplicationListChanged == null) return;
        List<ZIMFriendApplicationInfo> friendApplicationInfoList = ZIMConverter.oZIMFriendApplicationInfoList(map['friendApplicationInfoList']);
        ZIMFriendApplicationListChangeAction action = ZIMFriendApplicationListChangeActionExtension.mapValue[map['action']]!;
        ZIMEventHandler.onFriendApplicationListChanged!(zim,friendApplicationInfoList ,action);
        break;
      case 'onBlacklistChanged':
        if (ZIMEventHandler.onBlacklistChanged == null) return;
        ZIMBlacklistChangeAction action =
            ZIMBlacklistChangeActionExtension.mapValue[map['action']]!;
        List<ZIMUserInfo> userList =
            ZIMConverter.oZIMUserInfoList(map['userList']);
        ZIMEventHandler.onBlacklistChanged!(zim, userList ,action);
        break;
      case 'onGroupMutedInfoUpdated':
        if(ZIMEventHandler.onGroupMutedInfoUpdated == null) return;
        ZIMGroupMuteInfo muteInfo = ZIMConverter.oZIMGroupMuteInfo(map['groupMuteInfo']);
        ZIMGroupOperatedInfo operatedInfo = ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']);
        String groupID = map['groupID'];
        ZIMEventHandler.onGroupMutedInfoUpdated!(zim,muteInfo,operatedInfo,groupID);
        break;
      case 'onGroupVerifyInfoUpdated':
        if(ZIMEventHandler.onGroupVerifyInfoUpdated == null) return;
        ZIMGroupVerifyInfo verifyInfo = ZIMConverter.oZIMGroupVerifyInfo(map['verifyInfo']);
        ZIMGroupOperatedInfo operatedInfo = ZIMConverter.oZIMGroupOperatedInfo(map['operatedInfo']);
        String groupID = map['groupID'];
        ZIMEventHandler.onGroupVerifyInfoUpdated!(zim, verifyInfo, operatedInfo, groupID);
        break;
      case 'onGroupApplicationListChanged':

        if(ZIMEventHandler.onGroupApplicationListChanged == null) return;
        List<ZIMGroupApplicationInfo> applicationList = ZIMConverter.oZIMGroupApplicationInfoList(map['applicationList']);
        ZIMGroupApplicationListChangeAction action = ZIMGroupApplicationListChangeActionExtension.mapValue[map['action']]!;
        ZIMEventHandler.onGroupApplicationListChanged!(zim, applicationList, action);
        break;
      case 'onGroupApplicationUpdated':
        try{
          if(ZIMEventHandler.onGroupApplicationUpdated == null) return;
          List<ZIMGroupApplicationInfo> applicationList = ZIMConverter.oZIMGroupApplicationInfoList(map['applicationList']);
          ZIMEventHandler.onGroupApplicationUpdated!(zim, applicationList);
        } catch (error,e) {
          ZIMError zim_error = ZIMError(code: -1, message: error.toString()+e.toString());
          ZIMEventHandler.onError!(zim,zim_error);
        };
        break;
      case 'onUserRuleUpdated':
        if(ZIMEventHandler.onUserRuleUpdated == null) return;
        ZIMUserRule userRule = ZIMConverter.oZIMUserRule(map['userRule']);
        ZIMEventHandler.onUserRuleUpdated!(zim,userRule);
        break;
      default:
        break;
    }
  }
}

