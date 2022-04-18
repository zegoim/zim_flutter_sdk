import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
export 'package:flutter/services.dart';
import 'package:zim/zim.dart';

import 'zim_errorCode.dart';

enum ZIMConnectionState { disconnected, connecting, connected, reconnecting }

enum ZIMRoomState { disconnected, connecting, connected }

enum ZIMConnectionEvent {
  success,
  activeLogin,
  loginTimeout,
  interrupted,
  kickedOut
}

enum ZIMRoomEvent {
  success,
  interrupted,
  disconnected,
  roomNotExist,
  acticeCreate,
  createFailed,
  activeEnter,
  enterFailed,
  kickedOut
}

enum ZIMMessagePriority { low, medium, high }

enum ZIMMessageType { unKnown, text, command, barrage }

enum ZIMRoomAttributesUpdateAction { set, delete }

enum ZIMMessageDirection { send, receive }

enum ZIMMessageSentStatus { sending, success, failed }

enum ZIMConversationType { peer, room, group }

enum ZIMConversationEvent { added, updated, disabled }

enum ZIMConversationNotificationStatus { notify, doNotDisturb }

enum ZIMGroupEvent { created, dismissed, joined, invited, left, kickedout }

enum ZIMGroupState { quit, enter }

enum ZIMGroupMemberEvent { joined, left, kickedout, invited }

enum ZIMGroupMemberState { quit, enter }

enum ZIMGroupAttributesUpdateAction { set, delete }

enum ZIMGroupMessageNotificationStatus { notify, doNotDisturb }

enum ZIMCallUserState {
  inviting,
  accepted,
  rejected,
  cancelled,
  offline,
  received
}

enum ZIMCallRejectState { busy, reject }

typedef ZIMGroupMemberRole = int;

class ZIMError {
  ZIMErrorCode? code;
  String message = "";
}

class ZIMLogConfig {
  String logPath = "";
  int logSize = 0;
}

class ZIMCacheConfig {
  String cachePath = "";
}

class ZIMPushConfig {
  String title = "";
  String content = "";
  String extendedData = "";
}

class ZIMMessageSendConfig {
  ZIMPushConfig pushConfig = ZIMPushConfig();
  ZIMMessagePriority priority = ZIMMessagePriority.low;
}

class ZIMUserInfo {
  String userID = "";
  String userName = "";
}

class ZIMMessage {
  ZIMMessageType type = ZIMMessageType.text;
  int messageID = 0;
  int localMessageID = 0;
  String senderUserID = "";
  String conversationID = "";
  ZIMMessageDirection direction = ZIMMessageDirection.send;
  ZIMMessageSentStatus sentStatus = ZIMMessageSentStatus.success;
  ZIMConversationType conversationType = ZIMConversationType.peer;
  int timestamp = 0;
  int conversationSeq = 0;
  int orderKey = 0;
}

class ZIMTextMessage extends ZIMMessage {
  String message = "";

  static ZIMTextMessage initWithMessage(String message) {
    ZIMTextMessage textMessage = ZIMTextMessage();
    textMessage.message = message;
    return textMessage;
  }
}

class ZIMCommandMessage extends ZIMMessage {
  Uint8List message = Uint8List(0);

  static ZIMCommandMessage initWithMessage(Uint8List message) {
    ZIMCommandMessage commandMessage = ZIMCommandMessage();
    commandMessage.message = message;
    return commandMessage;
  }
}

class ZIMBarrageMessage extends ZIMMessage {
  String message = "";
  static ZIMTextMessage initWithMessage(String message) {
    ZIMTextMessage textMessage = ZIMTextMessage();
    textMessage.message = message;
    return textMessage;
  }
}

class ZIMConversation {
  String conversationID = "";
  String conversationName = "";
  ZIMConversationType type = ZIMConversationType.peer;
  ZIMConversationNotificationStatus notificationStatus =
      ZIMConversationNotificationStatus.notify;
  int unreadMessageCount = 0;
  ZIMMessage? lastMessage;
  int orderKey = 0;
}

class ZIMConversationQueryConfig {
  ZIMConversation? nextConversation;
  int count = 0;
}

class ZIMConversationDeleteConfig {
  bool isAlsoDeleteServerConversation = false;
}

class ZIMConversationChangeInfo {
  ZIMConversationEvent event = ZIMConversationEvent.added;
  ZIMConversation? conversation;
}

class ZIMRoomInfo {
  String roomID = "";
  String roomName = "";
}

class ZIMRoomFullInfo {
  ZIMRoomInfo? baseInfo;
}

class ZIMMessageQueryConfig {
  ZIMMessage? nextMessage;
  int count = 0;
  bool reverse = false;
}

class ZIMMessageDeleteConfig {
  bool isAlsoDeleteServerMessage = false;
}

class ZIMRoomMemberQueryConfig {
  String nextFlag = "";
  int count = 0;
}

class ZIMRoomAdvancedConfig {
  Map<String, String>? roomAttributes;
  int roomDestroyDelayTime = 0;
}

class ZIMRoomAttributesSetConfig {
  bool isForce = false;
  bool isDeleteAfterOwnerLeft = false;
  bool isUpdateOwner = false;
}

class ZIMRoomAttributesBatchOperationConfig {
  bool isForce = false;
  bool isDeleteAfterOwnerLeft = false;
  bool isUpdateOwner = false;
}

class ZIMRoomAttributesDeleteConfig {
  bool isForce = false;
}

class ZIMRoomAttributesUpdateInfo {
  ZIMRoomAttributesUpdateAction action = ZIMRoomAttributesUpdateAction.set;
}

class ZIMErrorUserInfo {
  String userID = "";
  int reason = 0;
}

class ZIMGroupInfo {
  String groupID = "";
  String groupName = "";
}

class ZIMGroupFullInfo {
  ZIMGroupInfo? baseInfo;
  String groupNotice = "";
  Map<String, String>? groupAttributes;
  ZIMGroupMessageNotificationStatus notificationStatus =
      ZIMGroupMessageNotificationStatus.notify;
}

class ZIMGroup {
  ZIMGroupInfo? baseInfo;
  ZIMGroupMessageNotificationStatus notificationStatus =
      ZIMGroupMessageNotificationStatus.notify;
}

class ZIMGroupMemberInfo extends ZIMUserInfo {
  String memberNickname = "";
  ZIMGroupMemberRole memberRole = 1;
}

class ZIMGroupOperatedInfo {
  ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();
}

class ZIMGroupMemberQueryConfig {
  int count = 0;
  int nextFlag = 0;
}

class ZIMGroupAdvancedConfig {
  String groupNotice = "";
  Map<String, String>? groupAttributes;
}

class ZIMGroupAttributesUpdateInfo {
  ZIMGroupAttributesUpdateAction action = ZIMGroupAttributesUpdateAction.set;
  Map<String, String>? groupAttributes;
}

class ZIMCallUserInfo {
  String userID = "";
  ZIMCallUserState state = ZIMCallUserState.accepted;
}

class ZIMCallInviteConfig {
  int timeout = 0;
  String extendedData = "";
}

class ZIMCallCancelConfig {
  String extendedData = "";
}

class ZIMCallAcceptConfig {
  String extendedData = "";
}

class ZIMCallRejectConfig {
  String extendedData = "";
}

class ZIMCallInvitationSentInfo {
  int timeout = 0;
  List<ZIMCallUserInfo>? errorInvitees;
}

class ZIMCallInvitationReceivedInfo {
  int timeout = 0;
  String inviter = "";
  String extendedData = "";
}

class ZIMCallInvitationCancelledInfo {
  String inviter = "";
  String extendedData = "";
}

class ZIMCallInvitationAcceptedInfo {
  String invitee = "";
  String extendedData = "";
}

class ZIMCallInvitationRejectedInfo {
  String invitee = "";
  String extendedData = "";
}

class ZIMCallInvitationTimeoutInfo {
  String inviter = "";
}

//MARK : Result

class ZIMLoggedInResult {
  ZIMError errorInfo;
  ZIMLoggedInResult({required this.errorInfo});
}

class ZIMTokenRenewedResult {
  String token;
  ZIMError errorInfo;
  ZIMTokenRenewedResult({required this.token, required this.errorInfo});
}

class ZIMUsersInfoQueriedResult {
  List<ZIMUserInfo> userList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMError errorInfo;
  ZIMUsersInfoQueriedResult(
      {required this.userList,
      required this.errorUserList,
      required this.errorInfo});
}

class ZIMConversationListQueriedResult {
  List<ZIMConversation> conversationList;
  ZIMError errorInfo;
  ZIMConversationListQueriedResult(
      {required this.conversationList, required this.errorInfo});
}

class ZIMConversationDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMError errorInfo;
  ZIMConversationDeletedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.errorInfo});
}

class ZIMConversationUnreadMessageCountClearedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMError errorInfo;
  ZIMConversationUnreadMessageCountClearedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.errorInfo});
}

class ZIMConversationNotificationStatusSetResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMError errorInfo;
  ZIMConversationNotificationStatusSetResult(
      {required this.conversationID,
      required this.conversationType,
      required this.errorInfo});
}

class ZIMMessageSentResult {
  ZIMMessage message;
  ZIMError errorInfo;
  ZIMMessageSentResult({required this.message, required this.errorInfo});
}

class ZIMMessageQueriedResult {
  String conversationID;
  ZIMConversationType conversationType;
  List<ZIMMessage> messageList;
  ZIMError errorInfo;
  ZIMMessageQueriedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.messageList,
      required this.errorInfo});
}

class ZIMMessageDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMError errorInfo;
  ZIMMessageDeletedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.errorInfo});
}

class ZIMRoomCreatedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMError errorInfo;
  ZIMRoomCreatedResult({required this.roomInfo, required this.errorInfo});
}

class ZIMRoomJoinedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMError errorInfo;
  ZIMRoomJoinedResult({required this.roomInfo, required this.errorInfo});
}

class ZIMRoomLeftResult {
  String roomID;
  ZIMError errorInfo;
  ZIMRoomLeftResult({required this.roomID, required this.errorInfo});
}

class ZIMRoomMemberQueriedResult {
  String roomID;
  ZIMRoomMemberQueryConfig config;
  ZIMRoomMemberQueriedResult({required this.roomID, required this.config});
}

class ZIMRoomOnlineMemberCountQueriedResult {
  String roomID;
  int count;
  ZIMError errorInfo;
  ZIMRoomOnlineMemberCountQueriedResult(
      {required this.roomID, required this.count, required this.errorInfo});
}

class ZIMRoomAttributesOperatedCallResult {
  String roomID;
  List<String> errorKeys;
  ZIMError errorInfo;
  ZIMRoomAttributesOperatedCallResult(
      {required this.roomID, required this.errorKeys, required this.errorInfo});
}

class ZIMRoomAttributesBatchOperatedResult {
  String roomID;
  ZIMError errorInfo;
  ZIMRoomAttributesBatchOperatedResult(
      {required this.roomID, required this.errorInfo});
}

class ZIMRoomAttributesQueriedResult {
  String roomID;
  Map<String, String> roomAttributes;
  ZIMError errorInfo;
  ZIMRoomAttributesQueriedResult(
      {required this.roomID,
      required this.roomAttributes,
      required this.errorInfo});
}

class ZIMGroupCreatedResult {
  ZIMGroupInfo groupInfo;
  List<String> userIDs;
  ZIMGroupCreatedResult({required this.groupInfo, required this.userIDs});
}

class ZIMGroupDismissedResult {
  String groupID;
  ZIMError errorInfo;
  ZIMGroupDismissedResult({required this.groupID, required this.errorInfo});
}

class ZIMGroupJoinedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMError errorInfo;
  ZIMGroupJoinedResult({required this.groupInfo, required this.errorInfo});
}

class ZIMGroupLeftResult {
  String groupID;
  ZIMError errorInfo;
  ZIMGroupLeftResult({required this.groupID, required this.errorInfo});
}

class ZIMGroupUsersInvitedResult {
  String groupID;
  List<String> kickedUserIDList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupUsersInvitedResult(
      {required this.groupID,
      required this.kickedUserIDList,
      required this.errorUserList});
}

class ZIMGroupMemberKickedResult {
  String groupID;
  List<String> kickedUserIDList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMError errorInfo;
  ZIMGroupMemberKickedResult(
      {required this.groupID,
      required this.kickedUserIDList,
      required this.errorUserList,
      required this.errorInfo});
}

class ZIMGroupOwnerTransferredResult {
  String groupID;
  String toUserID;
  ZIMError errorInfo;
  ZIMGroupOwnerTransferredResult(
      {required this.groupID, required this.toUserID, required this.errorInfo});
}

class ZIMGroupNameUpdatedResult {
  String groupID;
  String groupName;
  ZIMError errorInfo;
  ZIMGroupNameUpdatedResult(
      {required this.groupID,
      required this.groupName,
      required this.errorInfo});
}

class ZIMGroupNoticeUpdatedResult {
  String groupID;
  String groupNotice;
  ZIMError errorInfo;
  ZIMGroupNoticeUpdatedResult(
      {required this.groupID,
      required this.groupNotice,
      required this.errorInfo});
}

class ZIMGroupInfoQueriedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMError errorInfo;
  ZIMGroupInfoQueriedResult({required this.groupInfo, required this.errorInfo});
}

class ZIMGroupAttributesOperatedResult {
  String groupID;
  List<String> errorKeys;
  ZIMError errorInfo;
  ZIMGroupAttributesOperatedResult(
      {required this.groupID,
      required this.errorKeys,
      required this.errorInfo});
}

class ZIMGroupAttributesQueriedResult {
  String groupID;
  Map<String, String> groupAttributes;
  ZIMError errorInfo;
  ZIMGroupAttributesQueriedResult(
      {required this.groupID,
      required this.groupAttributes,
      required this.errorInfo});
}

class ZIMGroupMemberRoleUpdatedResult {
  String groupID;
  String forUserID;
  ZIMGroupMemberRole role;
  ZIMError errorInfo;
  ZIMGroupMemberRoleUpdatedResult(
      {required this.groupID,
      required this.forUserID,
      required this.role,
      required this.errorInfo});
}

class ZIMGroupMemberNicknameUpdatedResult {
  String groupID;
  String forUserID;
  String nickname;
  ZIMError errorInfo;
  ZIMGroupMemberNicknameUpdatedResult(
      {required this.groupID,
      required this.forUserID,
      required this.nickname,
      required this.errorInfo});
}

class ZIMGroupMemberInfoQueriedResult {
  String groupID;
  ZIMGroupMemberInfo userInfo;
  ZIMError errorInfo;
  ZIMGroupMemberInfoQueriedResult(
      {required this.groupID, required this.userInfo, required this.errorInfo});
}

class ZIMGroupListQueriedResult {
  List<ZIMGroup> groupList;
  ZIMError errorInfo;
  ZIMGroupListQueriedResult({required this.groupList, required this.errorInfo});
}

class ZIMGroupMemberListQueriedResult {
  String groupID;
  List<ZIMGroupMemberInfo> userList;
  int nextFlag;
  ZIMError errorInfo;
  ZIMGroupMemberListQueriedResult(
      {required this.groupID,
      required this.userList,
      required this.nextFlag,
      required this.errorInfo});
}

class ZIMCallInvitationSentResult {
  String callID;
  List<String> errorInvitees;
  ZIMError errorInfo;
  ZIMCallInvitationSentResult(
      {required this.callID,
      required this.errorInvitees,
      required this.errorInfo});
}

class ZIMCallCancelSentResult {
  String callID;
  List<String> errorInvitees;
  ZIMError errorInfo;
  ZIMCallCancelSentResult(
      {required this.callID,
      required this.errorInvitees,
      required this.errorInfo});
}

class ZIMCallAcceptanceSentResult {
  String callID;
  ZIMError errorInfo;
  ZIMCallAcceptanceSentResult({required this.callID, required this.errorInfo});
}

class ZIMCallRejectionSentResult {
  String callID;
  ZIMError errorInfo;
  ZIMCallRejectionSentResult({required this.callID, required this.errorInfo});
}
