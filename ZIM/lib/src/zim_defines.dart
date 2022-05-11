import 'dart:typed_data';
export 'package:flutter/services.dart';

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
  int code;
  String message;
  ZIMError({required this.code, required this.message});
}

class ZIMLogConfig {
  String logPath;
  int logSize;
  ZIMLogConfig({required this.logPath, required this.logSize});
}

class ZIMCacheConfig {
  String cachePath;
  ZIMCacheConfig({required this.cachePath});
}

class ZIMPushConfig {
  String title;
  String content;
  String? extendedData;
  ZIMPushConfig({required this.title, required this.content});
}

class ZIMMessageSendConfig {
  ZIMPushConfig? pushConfig;
  ZIMMessagePriority priority;
  ZIMMessageSendConfig({required this.priority});
}

class ZIMUserInfo {
  String userID = "";
  String? userName;
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
  ZIMRoomAttributesUpdateAction action;
  Map<String, String> roomAttributes;
  ZIMRoomAttributesUpdateInfo(
      {required this.action, required this.roomAttributes});
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

// class ZIMLoggedInResult {
//   ZIMError errorInfo;
//   ZIMLoggedInResult({required this.errorInfo});
// }

class ZIMTokenRenewedResult {
  String token;
  ZIMTokenRenewedResult({required this.token});
}

class ZIMUsersInfoQueriedResult {
  List<ZIMUserInfo> userList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMUsersInfoQueriedResult(
      {required this.userList, required this.errorUserList});
}

class ZIMConversationListQueriedResult {
  List<ZIMConversation> conversationList;

  ZIMConversationListQueriedResult({required this.conversationList});
}

class ZIMConversationDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationDeletedResult(
      {required this.conversationID, required this.conversationType});
}

class ZIMConversationUnreadMessageCountClearedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationUnreadMessageCountClearedResult(
      {required this.conversationID, required this.conversationType});
}

class ZIMConversationNotificationStatusSetResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationNotificationStatusSetResult(
      {required this.conversationID, required this.conversationType});
}

class ZIMMessageSentResult {
  ZIMMessage message;
  ZIMMessageSentResult({required this.message});
}

class ZIMMessageQueriedResult {
  String conversationID;
  ZIMConversationType conversationType;
  List<ZIMMessage> messageList;
  ZIMMessageQueriedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.messageList});
}

class ZIMMessageDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMMessageDeletedResult(
      {required this.conversationID, required this.conversationType});
}

class ZIMRoomCreatedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMRoomCreatedResult({required this.roomInfo});
}

class ZIMRoomJoinedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMRoomJoinedResult({required this.roomInfo});
}

class ZIMRoomLeftResult {
  String roomID;
  ZIMRoomLeftResult({required this.roomID});
}

class ZIMRoomMemberQueriedResult {
  String roomID;
  List<ZIMUserInfo> memberList;
  ZIMRoomMemberQueriedResult({required this.roomID, required this.memberList});
}

class ZIMRoomOnlineMemberCountQueriedResult {
  String roomID;
  int count;
  ZIMRoomOnlineMemberCountQueriedResult(
      {required this.roomID, required this.count});
}

class ZIMRoomAttributesOperatedCallResult {
  String roomID;
  List<String> errorKeys;
  ZIMRoomAttributesOperatedCallResult(
      {required this.roomID, required this.errorKeys});
}

class ZIMRoomAttributesBatchOperatedResult {
  String roomID;
  ZIMRoomAttributesBatchOperatedResult({required this.roomID});
}

class ZIMRoomAttributesQueriedResult {
  String roomID;
  Map<String, String> roomAttributes;
  ZIMRoomAttributesQueriedResult(
      {required this.roomID, required this.roomAttributes});
}

class ZIMGroupCreatedResult {
  ZIMGroupFullInfo groupInfo;
  List<String> userIDs;
  ZIMGroupCreatedResult({required this.groupInfo, required this.userIDs});
}

class ZIMGroupDismissedResult {
  String groupID;
  ZIMGroupDismissedResult({required this.groupID});
}

class ZIMGroupJoinedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMGroupJoinedResult({required this.groupInfo});
}

class ZIMGroupLeftResult {
  String groupID;
  ZIMGroupLeftResult({required this.groupID});
}

class ZIMGroupUsersInvitedResult {
  String groupID;
  List<String> userIDList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupUsersInvitedResult(
      {required this.groupID,
      required this.userIDList,
      required this.errorUserList});
}

class ZIMGroupMemberKickedResult {
  String groupID;
  List<String> kickedUserIDList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupMemberKickedResult(
      {required this.groupID,
      required this.kickedUserIDList,
      required this.errorUserList});
}

class ZIMGroupOwnerTransferredResult {
  String groupID;
  String toUserID;
  ZIMGroupOwnerTransferredResult(
      {required this.groupID, required this.toUserID});
}

class ZIMGroupNameUpdatedResult {
  String groupID;
  String groupName;
  ZIMGroupNameUpdatedResult({required this.groupID, required this.groupName});
}

class ZIMGroupNoticeUpdatedResult {
  String groupID;
  String groupNotice;
  ZIMGroupNoticeUpdatedResult(
      {required this.groupID, required this.groupNotice});
}

class ZIMGroupInfoQueriedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMGroupInfoQueriedResult({required this.groupInfo});
}

class ZIMGroupAttributesOperatedResult {
  String groupID;
  List<String> errorKeys;
  ZIMGroupAttributesOperatedResult(
      {required this.groupID, required this.errorKeys});
}

class ZIMGroupAttributesQueriedResult {
  String groupID;
  Map<String, String> groupAttributes;
  ZIMGroupAttributesQueriedResult(
      {required this.groupID, required this.groupAttributes});
}

class ZIMGroupMemberRoleUpdatedResult {
  String groupID;
  String forUserID;
  ZIMGroupMemberRole role;
  ZIMGroupMemberRoleUpdatedResult(
      {required this.groupID, required this.forUserID, required this.role});
}

class ZIMGroupMemberNicknameUpdatedResult {
  String groupID;
  String forUserID;
  String nickname;
  ZIMGroupMemberNicknameUpdatedResult(
      {required this.groupID, required this.forUserID, required this.nickname});
}

class ZIMGroupMemberInfoQueriedResult {
  String groupID;
  ZIMGroupMemberInfo userInfo;
  ZIMGroupMemberInfoQueriedResult(
      {required this.groupID, required this.userInfo});
}

class ZIMGroupListQueriedResult {
  List<ZIMGroup> groupList;
  ZIMGroupListQueriedResult({required this.groupList});
}

class ZIMGroupMemberListQueriedResult {
  String groupID;
  List<ZIMGroupMemberInfo> userList;
  int nextFlag;
  ZIMGroupMemberListQueriedResult(
      {required this.groupID, required this.userList, required this.nextFlag});
}

class ZIMCallInvitationSentResult {
  String callID;
  List<String> errorInvitees;
  ZIMCallInvitationSentResult(
      {required this.callID, required this.errorInvitees});
}

class ZIMCallCancelSentResult {
  String callID;
  List<String> errorInvitees;
  ZIMCallCancelSentResult({required this.callID, required this.errorInvitees});
}

class ZIMCallAcceptanceSentResult {
  String callID;
  ZIMCallAcceptanceSentResult({required this.callID});
}

class ZIMCallRejectionSentResult {
  String callID;
  ZIMCallRejectionSentResult({required this.callID});
}
