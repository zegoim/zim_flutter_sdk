import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import 'zim_defines.dart';

abstract class ZIM {
  static ZIM getInstance() {
    return ZIMImpl.getInstance();
  }

  Future<String> getVersion();

//MARK: - Main
  Future<void> create(int appID);

  Future<void> destroy();

  Future<void> setLogConfig(ZIMLogConfig config);

  Future<void> setCacheConfig(ZIMCacheConfig config);

  Future<void> login(String userID, String userName, String token);

  Future<void> logout();

  Future<void> uploadLog();

  Future<ZIMTokenRenewedResult> renewToken(String token);

  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(List<String> userIDs);

//MARK: - Conversation
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config);

  Future<ZIMConversationDeletedResult> deleteConversation(String conversationID,
      ZIMConversationType conversationType, ZIMMessageDeleteConfig config);

  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType);

  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType);

//MARK: -Message
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config);

  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config);

  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config);

  Future<ZIMMessageQueriedResult> queryHistoryMessage(String conversationID,
      ZIMConversationType conversationType, ZIMMessageQueryConfig config);

  Future<ZIMMessageDeletedResult> deleteAllMessage(String conversationID,
      ZIMConversationType conversationType, ZIMMessageDeleteConfig config);

  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config);

//MARK: - createRoom
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]);

  Future<ZIMRoomJoinedResult> joinRoom(String roomID);

  Future<ZIMRoomLeftResult> leaveRoom(String roomID);

  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config);

  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID);

  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig? config);

  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
      List<String> keys, String roomID, ZIMRoomAttributesDeleteConfig? config);

  Future<void> beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig? config);

  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID);

  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(String roomID);

//MARK: - Group
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]);

  Future<ZIMGroupDismissedResult> dismissGroup(String groupID);

  Future<ZIMGroupJoinedResult> joinGroup(String groupID);

  Future<ZIMGroupLeftResult> leaveGroup(String groupID);

  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID);

  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID);

  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID);

  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID);

  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID);

  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID);

  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID);

  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID);

  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID);

  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID);

  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      ZIMGroupMemberRole role, String forUserID, String groupID);

  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID);

  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID);

  Future<ZIMGroupListQueriedResult> queryGroupList();

  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config);

//MARK: - CallInvite

  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config);

  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config);

  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config);

  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config);
}
