@JS('ZIM')
library zim_web;

import 'package:js/js.dart';
import 'package:zego_zim/src/internal/zim_utils_web.dart';

@JS()
class ZIM {
  external static toJSON(dynamic);
  external static setEventHandler(Function handler);
  external static String getVersion();
  external static ZIM? create(dynamic appConfig);
  external static void destroy();
  external static ZIM? getInstance();
  external void setLogConfig(dynamic config);
  external PromiseJsImpl<void> uploadLog();
  external PromiseJsImpl<dynamic> renewToken(dynamic config);
  external PromiseJsImpl<dynamic> login(ZIMUserInfoWeb userInfo, String token);
  external void logout();
  external PromiseJsImpl<dynamic> updateUserName(String userName);
  external PromiseJsImpl<dynamic> updateUserAvatarUrl(String userAvatarUrl);
  external PromiseJsImpl<dynamic> updateUserExtendedData(String extendedData);
  external PromiseJsImpl<dynamic> queryUsersInfo(
      dynamic userIDs, Object config);
  external PromiseJsImpl<dynamic> createRoom(Object roomInfo, Object? config);
  external PromiseJsImpl<dynamic> enterRoom(Object roomInfo, Object? config);
  external PromiseJsImpl<dynamic> joinRoom(String roomID);
  external PromiseJsImpl<dynamic> leaveRoom(String roomID);
  external PromiseJsImpl<dynamic> queryRoomMemberList(
      String roomID, Object config);
  external PromiseJsImpl<dynamic> queryRoomOnlineMemberCount(String roomID);
  external PromiseJsImpl<dynamic> queryRoomAllAttributes(String roomID);
  external PromiseJsImpl<dynamic> setRoomAttributes(
      dynamic roomAttributes, String roomID, Object config);
  external PromiseJsImpl<dynamic> deleteRoomAttributes(
      dynamic keys, String roomID, Object config);
  external PromiseJsImpl<dynamic> beginRoomAttributesBatchOperation(
      String roomID, Object config);
  external PromiseJsImpl<dynamic> endRoomAttributesBatchOperation(
      String roomID);
  external PromiseJsImpl<dynamic> sendMediaMessage(
      Object message,
      String toConversationID,
      dynamic conversationType,
      Object config,
      dynamic notification);
  external PromiseJsImpl<dynamic> queryHistoryMessage(
      String conversationID, int conversationType, Object config);
  external PromiseJsImpl<dynamic> sendPeerMessage(
      Object message, String toUserID, Object config);
  external PromiseJsImpl<dynamic> sendRoomMessage(
      Object message, String toRoomID, Object config);
  external PromiseJsImpl<dynamic> sendGroupMessage(
      Object message, String toGroupID, Object config);
  external PromiseJsImpl<dynamic> deleteMessages(dynamic messageList,
      String conversationID, dynamic conversationType, Object config);
  external PromiseJsImpl<dynamic> deleteAllMessage(
      String conversationID, dynamic conversationType, Object config);
  external PromiseJsImpl<dynamic> createGroup(
      Object groupInfo, dynamic serIDs, Object? config);
  external PromiseJsImpl<dynamic> joinGroup(String groupID);
  external PromiseJsImpl<dynamic> leaveGroup(String groupID);
  external PromiseJsImpl<dynamic> dismissGroup(String groupID);
  external PromiseJsImpl<dynamic> inviteUsersIntoGroup(
      dynamic userIDs, String groupID);
  external PromiseJsImpl<dynamic> kickGroupMembers(
      dynamic userIDs, String groupID);
  external PromiseJsImpl<dynamic> transferGroupOwner(
      String toUserID, String groupID);
  external PromiseJsImpl<dynamic> updateGroupName(
      String groupName, String groupID);
  external PromiseJsImpl<dynamic> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID);
  external PromiseJsImpl<dynamic> updateGroupNotice(
      String groupNotice, String groupID);
  external PromiseJsImpl<dynamic> queryGroupInfo(String groupID);
  external PromiseJsImpl<dynamic> queryGroupList();
  external PromiseJsImpl<dynamic> setGroupAttributes(
      Map groupAttributes, String groupID);
  external PromiseJsImpl<dynamic> deleteGroupAttributes(
      dynamic keys, String groupID);
  external PromiseJsImpl<dynamic> queryGroupAttributes(
      dynamic keys, String groupID);
  external PromiseJsImpl<dynamic> queryGroupAllAttributes(String groupID);
  external PromiseJsImpl<dynamic> setGroupMemberRole(
      int role, String forUserID, String groupID);
  external PromiseJsImpl<dynamic> setGroupMemberNickname(
      String nickname, String forUserID, String groupID);
  external PromiseJsImpl<dynamic> queryGroupMemberInfo(
      String userID, String groupID);
  external PromiseJsImpl<dynamic> queryGroupMemberList(
      String groupID, Object? config);
  external PromiseJsImpl<dynamic> queryConversationList(Object config);
  external PromiseJsImpl<dynamic> deleteConversation(
      String conversationID, dynamic conversationType, Object? config);
  external PromiseJsImpl<dynamic> clearConversationUnreadMessageCount(
      String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> setConversationNotificationStatus(
      dynamic status, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> callInvite(dynamic invitees, Object? config);
  external PromiseJsImpl<dynamic> callCancel(
      dynamic invitees, String callID, Object config);
  external PromiseJsImpl<dynamic> callAccept(String callID, Object config);
  external PromiseJsImpl<dynamic> callReject(String callID, Object config);
  external PromiseJsImpl<dynamic> queryRoomMemberAttributesList(
      String roomID, Object config);
  external PromiseJsImpl<dynamic> queryRoomMembersAttributes(
      dynamic userIDs, String roomID);
  external PromiseJsImpl<dynamic> sendMessage(
      Object message,
      String toConversationID,
      dynamic conversationType,
      dynamic config,
      Object notification);
  external PromiseJsImpl<dynamic> insertMessageToLocalDB(Object message,
      String conversationID, dynamic conversationType, String senderUserID);
  external PromiseJsImpl<dynamic> setRoomMembersAttributes(dynamic attributes, dynamic userIDs, String roomID, Object config);
  external PromiseJsImpl<dynamic> sendConversationMessageReceiptRead(String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> sendMessageReceiptsRead(dynamic messageList, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryMessageReceiptsInfo(dynamic messageList, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryGroupMessageReceiptReadMemberList(dynamic message, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> queryGroupMessageReceiptUnreadMemberList(dynamic message, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> revokeMessage(dynamic message, dynamic config);
}

@JS()
@anonymous
class ZIMAppConfigWeb {
  external factory ZIMAppConfigWeb({int appID});

  external int get appID;
}

@JS()
@anonymous
class ZIMLogConfig {
  external factory ZIMLogConfig({String logLevel});

  external String get logLevel;
}

@JS()
@anonymous
class ZIMUserInfoWeb {
  external factory ZIMUserInfoWeb({String userID, String userName});

  external String get userID;
  external String get userName;
}

@JS()
@anonymous
class ZIMConversationQueryConfigWeb {
  external factory ZIMConversationQueryConfigWeb(
      {dynamic nextConversation, int count});

  external dynamic get nextConversation;
  external int get count;
}

@JS()
@anonymous
class ZIMUsersInfoQueryConfigWeb {
  external factory ZIMUsersInfoQueryConfigWeb({bool isQueryFromServer});

  external bool get isQueryFromServer;
}

@JS()
@anonymous
class ZIMRoomInfoWeb {
  external factory ZIMRoomInfoWeb({String roomID, String roomName});

  external String get roomID;
  external String get roomName;
}

@JS()
@anonymous
class ZIMRoomAdvancedConfigWeb {
  external factory ZIMRoomAdvancedConfigWeb(
      {dynamic roomAttributes, int roomDestroyDelayTime});

  external dynamic get roomAttributes;
  external int get roomDestroyDelayTime;
}

@JS()
@anonymous
class ZIMRoomMemberQueryConfigWeb {
  external factory ZIMRoomMemberQueryConfigWeb({String nextFlag, int count});

  external dynamic get roomAttributes;
  external int get roomDestroyDelayTime;
}

@JS()
@anonymous
class ZIMRoomAttributesSetConfigWeb {
  external factory ZIMRoomAttributesSetConfigWeb(
      {bool isForce, bool isUpdateOwner, bool isDeleteAfterOwnerLeft});

  external bool get isForce;
  external bool get isUpdateOwner;
  external bool get isDeleteAfterOwnerLeft;
}

@JS()
@anonymous
class ZIMRoomAttributesDeleteConfigWeb {
  external factory ZIMRoomAttributesDeleteConfigWeb({bool isForce});

  external bool get isForce;
}

@JS()
@anonymous
class ZIMRoomAttributesBatchOperationConfigWeb {
  external factory ZIMRoomAttributesBatchOperationConfigWeb(
      {bool isForce, bool isUpdateOwner, bool isDeleteAfterOwnerLeft});

  external bool get isForce;
  external bool get isUpdateOwner;
  external bool get isDeleteAfterOwnerLeft;
}

@JS()
@anonymous
class ZIMMediaMessageBaseWeb {
  external factory ZIMMediaMessageBaseWeb(
      {dynamic type,
      dynamic fileLocalPath,
      String? fileDownloadUrl,
      String? fileName,
      int? fileSize});

  external dynamic get type;
  external dynamic get fileLocalPath;
  external String? get fileDownloadUrl;
  external String? get fileName;
  external int? get fileSize;
}

@JS()
@anonymous
class ZIMMessageSendConfigWeb {
  external factory ZIMMessageSendConfigWeb(
      {dynamic priority, ZIMPushConfigWeb pushConfig});

  external dynamic get priority;
  external ZIMPushConfigWeb get pushConfig;
}

@JS()
@anonymous
class ZIMPushConfigWeb {
  external factory ZIMPushConfigWeb(
      {String title, String content, String extendedData});

  external String get title;
  external String get content;
  external String get extendedData;
}

@JS()
@anonymous
class ZIMMessageQueryConfigWeb {
  external factory ZIMMessageQueryConfigWeb(
      {dynamic nextMessage, int count, bool reverse});

  external dynamic get nextMessage;
  external int get count;
  external bool get reverse;
}

@JS()
@anonymous
class ZIMMessageBaseWeb {
  external factory ZIMMessageBaseWeb({dynamic type, dynamic message});

  external dynamic get type;
  external dynamic get message;
}

@JS()
@anonymous
class ZIMMessageDeleteConfigWeb {
  external factory ZIMMessageDeleteConfigWeb({bool isAlsoDeleteServerMessage});

  external bool get isAlsoDeleteServerMessage;
}

@JS()
@anonymous
class ZIMGroupInfoWeb {
  external factory ZIMGroupInfoWeb(
      {String groupID, String groupName, String groupAvatarUrl});

  external String get groupID;
  external String get groupName;
  external String get groupAvatarUrl;
}

@JS()
@anonymous
class ZIMGroupAdvancedConfigWeb {
  external factory ZIMGroupAdvancedConfigWeb(
      {String groupNotice, dynamic groupAttributes});

  external String get groupNotice;
  external dynamic get groupAttributes;
}

@JS()
@anonymous
class ZIMGroupMemberQueryConfigWeb {
  external factory ZIMGroupMemberQueryConfigWeb({int nextFlag, int count});

  external bool get nextFlag;
  external bool get count;
}

@JS()
@anonymous
class ZIMConversationDeleteConfigWeb {
  external factory ZIMConversationDeleteConfigWeb(
      {bool isAlsoDeleteServerConversation});

  external bool get isAlsoDeleteServerConversation;
}

@JS()
@anonymous
class ZIMCallInviteConfigWeb {
  external factory ZIMCallInviteConfigWeb({int timeout, String extendedData});

  external int get timeout;
  external String get extendedData;
}

@JS()
@anonymous
class ZIMCallCancelConfigWeb {
  external factory ZIMCallCancelConfigWeb({String extendedData});

  external String get extendedData;
}

@JS()
@anonymous
class ZIMCallAcceptConfigWeb {
  external factory ZIMCallAcceptConfigWeb({String extendedData});

  external String get extendedData;
}

@JS()
@anonymous
class ZIMCallRejectConfigWeb {
  external factory ZIMCallRejectConfigWeb({String extendedData});

  external String get extendedData;
}
