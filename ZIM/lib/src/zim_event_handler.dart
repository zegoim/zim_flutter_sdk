import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import 'zim_defines.dart';

class ZIMEventHandler {
  static void Function(
          ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData)?
      connectionStateChanged;

/* Main */
  static void Function(ZIMError errorInfo)? onError;

  static void Function(int second)? tokenWillExpire;

/* Conversation */
  static void Function(
          List<ZIMConversationChangeInfo> conversationChangeInfoList)?
      conversationChanged;

  static void Function(int totalUnreadMessageCount)?
      conversationTotalUnreadMessageCountUpdated;

/* Message */
  static void Function(List<ZIMMessage> messageList, String fromUserID)?
      receivePeerMessage;

  static void Function(List<ZIMMessage> messageList, String fromRoomID)?
      receiveRoomMessage;

  static void Function(List<ZIMMessage> messageList, String fromGroupID)?
      receiveGroupMessage;

/* Room */
  static void Function(List<ZIMUserInfo> memberList, String roomID)?
      roomMemberJoined;

  static void Function(List<ZIMUserInfo> memberList, String roomID)?
      roomMemberLeft;

  static void Function(ZIMRoomState state, ZIMRoomEvent event, Map extendedData,
      String roomID)? roomStateChanged;

  static void Function(ZIMRoomAttributesUpdateInfo updateInfo, String roomID)?
      roomAttributesUpdated;

  static void Function(
          List<ZIMRoomAttributesUpdateInfo> updateInfo, String roomID)?
      roomAttributesBatchUpdated;

/* Group */
  static void Function(
      ZIMGroupState state,
      ZIMGroupEvent event,
      ZIMGroupOperatedInfo operatedInfo,
      ZIMGroupFullInfo groupInfo)? groupStateChanged;

  static void Function(
          String groupName, ZIMGroupOperatedInfo operatedInfo, String groupID)?
      groupNameUpdated;

  static void Function(String groupNotice, ZIMGroupOperatedInfo operatedInfo,
      String groupID)? groupNoticeUpdated;

  static void Function(
      List<ZIMGroupAttributesUpdateInfo> updateInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? groupAttributesUpdated;

  static void Function(
      ZIMGroupMemberState state,
      ZIMGroupMemberEvent event,
      List<ZIMGroupMemberInfo> userList,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? groupMemberStateChanged;

  static void Function(
      List<ZIMGroupMemberInfo> userInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? groupMemberInfoUpdated;

/* Invite */
  static void Function(ZIMCallInvitationReceivedInfo info, String callID)?
      callInvitationReceived;

  static void Function(ZIMCallInvitationCancelledInfo info, String callID)?
      callInvitationCancelled;

  static void Function(ZIMCallInvitationAcceptedInfo info, String callID)?
      callInvitationAccepted;

  static void Function(ZIMCallInvitationRejectedInfo info, String callID)?
      callInvitationRejected;

  static void Function(String callID)? callInvitationTimeout;
}
