import 'dart:async';
import 'package:zim/src/internal/zim_converter.dart';
import 'package:zim/zim.dart';

import '../zim_api.dart';
import 'package:flutter/services.dart';
import '../zim_defines.dart';
import 'zim_defines_extension.dart';
import '../zim_error_code.dart';

class ZIMImpl implements ZIM {
  static const MethodChannel _channel = MethodChannel('zim');
  static ZIMImpl? _zimImpl;

  /// Used to receive the native event stream
  static StreamSubscription<dynamic>? streamSubscription;

  static ZIMImpl getInstance() {
    _zimImpl ??= ZIMImpl();
    return _zimImpl!;
  }

  @override
  Future<String> getVersion() async {
    final String resultStr = await _channel.invokeMethod('getVersion');
    return resultStr;
  }

  @override
  Future<void> setLogConfig(ZIMLogConfig config) {
    // TODO: implement setLogConfig
    throw UnimplementedError();
  }

  @override
  Future<void> setCacheConfig(ZIMCacheConfig config) {
    // TODO: implement setCacheConfig
    throw UnimplementedError();
  }

  @override
  Future<void> create(int appID) async {
    return await _channel.invokeMethod("create", {"appID": appID});
  }

  @override
  Future<void> destroy() async {
    return await _channel.invokeMethod("destroy");
  }

  @override
  Future<void> login(String userID, String userName, String token) async {
    return await _channel.invokeMethod(
        "login", {"userID": userID, "userName": userName, "token": token});
  }

  @override
  Future<void> logout() async {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<ZIMTokenRenewedResult> renewToken(String token) async {
    // TODO: implement renewToken
    throw UnimplementedError();
  }

  @override
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(List<String> userIDs) async {
    // TODO: implement queryUsersInfo
    throw UnimplementedError();
  }

  @override
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config) async {
    // TODO: implement queryConversationList
    throw UnimplementedError();
  }

  @override
  Future<ZIMConversationDeletedResult> deleteConversation(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    // TODO: implement deleteConversation
    throw UnimplementedError();
  }

  @override
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversation, ZIMConversationType conversationType) async {
    // TODO: implement clearConversationUnreadMessageCount
    throw UnimplementedError();
  }

  @override
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType) async {
    // TODO: implement setConversationNotificationStatus
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config) async {
    // TODO: implement sendPeerMessage
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config) async {
    // TODO: implement sendGroupMessage
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config) async {
    // TODO: implement sendRoomMessage
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageQueryConfig config) async {
    // TODO: implement queryHistoryMessage
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageDeletedResult> deleteAllMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    // TODO: implement deleteAllMessage
    throw UnimplementedError();
  }

  @override
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    // TODO: implement deleteMessages
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]) async {
    // TODO: implement createRoom

    if (config == null) {
      print('没填');
    } else {
      print('填了');
    }
    ZIMRoomCreatedResult result =
        ZIMRoomCreatedResult(roomInfo: ZIMRoomFullInfo());
    return result;
  }

  @override
  Future<ZIMRoomJoinedResult> joinRoom(String roomID) async {
    // TODO: implement joinRoom
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomLeftResult> leaveRoom(String roomID) async {
    // TODO: implement leaveRoom
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config) async {
    // TODO: implement queryRoomMemberList
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID) async {
    // TODO: implement queryRoomOnlineMemberCount
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig? config) async {
    // TODO: implement setRoomAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
      List<String> keys,
      String roomID,
      ZIMRoomAttributesDeleteConfig? config) async {
    // TODO: implement deleteRoomAttributes
    throw UnimplementedError();
  }

  @override
  Future<void> beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig? config) async {
    // TODO: implement beginRoomAttributesBatchOperation
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID) async {
    // TODO: implement endRoomAttributesBatchOperation
    throw UnimplementedError();
  }

  @override
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(
      String roomID) async {
    // TODO: implement queryRoomAllAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]) async {
    // TODO: implement createGroup
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID) async {
    // TODO: implement dismissGroup
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupJoinedResult> joinGroup(String groupID) async {
    // TODO: implement joinGroup
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupLeftResult> leaveGroup(String groupID) async {
    // TODO: implement leaveGroup
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID) async {
    // TODO: implement inviteUsersIntoGroup
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID) async {
    // TODO: implement kickGroupMembers
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID) async {
    // TODO: implement transferGroupOwner
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID) async {
    // TODO: implement updateGroupName
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID) async {
    // TODO: implement updateGroupNotice
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID) async {
    // TODO: implement queryGroupInfo
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID) async {
    // TODO: implement setGroupAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID) async {
    // TODO: implement deleteGroupAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID) async {
    // TODO: implement queryGroupAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID) async {
    // TODO: implement queryGroupAllAttributes
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      ZIMGroupMemberRole role, String forUserID, String groupID) async {
    // TODO: implement setGroupMemberRole
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID) async {
    // TODO: implement setGroupMemberNickname
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID) async {
    // TODO: implement queryGroupMemberInfo
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupListQueriedResult> queryGroupList() async {
    // TODO: implement queryGroupList
    throw UnimplementedError();
  }

  @override
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config) async {
    // TODO: implement queryGroupMemberList
    throw UnimplementedError();
  }

  @override
  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    // TODO: implement callInvite
    throw UnimplementedError();
  }

  @override
  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    // TODO: implement callCancel
    throw UnimplementedError();
  }

  @override
  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config) async {
    // TODO: implement callAccept
    throw UnimplementedError();
  }

  @override
  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config) async {
    // TODO: implement callReject
    throw UnimplementedError();
  }

  @override
  Future<void> setEventHander(id) {
    // TODO: implement setEventHander
    throw UnimplementedError();
  }
}
