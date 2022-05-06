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
  Future<void> create(int appID) async {
    return await _channel.invokeMethod("create", {"appID": appID});
  }

  @override
  Future<void> destroy() async {
    return await _channel.invokeMethod("destroy");
  }

  @override
  Future<void> setLogConfig(ZIMLogConfig config) async {
    return await _channel.invokeMethod(
        'setLogConfig', {'logPath': config.logPath, 'logSize': config.logSize});
  }

  @override
  Future<void> setCacheConfig(ZIMCacheConfig config) async {
    return await _channel
        .invokeMethod('setCacheConfig', {'cachePath': config.cachePath});
  }

  @override
  Future<void> login(String userID, String userName, String token) async {
    return await _channel.invokeMethod(
        "login", {"userID": userID, "userName": userName, "token": token});
  }

  @override
  Future<void> logout() async {
    return await _channel.invokeMethod('logout');
  }

  @override
  Future<void> uploadLog() async {
    return await _channel.invokeMethod('uploadLog');
  }

  @override
  Future<ZIMTokenRenewedResult> renewToken(String token) async {
    Map resultMap = await _channel.invokeMethod('renewToken');
    return ZIMConverter.cnvTokenRenewedMapToObject(resultMap);
  }

  @override
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(List<String> userIDs) async {
    Map resultMap =
        await _channel.invokeMethod('queryUsersInfo', {'userIDs': userIDs});

    return ZIMConverter.cnvZIMUsersInfoQueriedMapToObject(resultMap);
  }

  @override
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryConversationList', {
      'config': ZIMConverter.cnvZIMConversationQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMConversationListQueriedMapToObject(resultMap);
  }

  @override
  Future<ZIMConversationDeletedResult> deleteConversation(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    return await _channel.invokeMethod('deleteConversation', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageDeleteConfigObjectToMap(config)
    });
  }

  @override
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType) async {
    Map resultMap =
        await _channel.invokeMethod('clearConversationUnreadMessageCount', {
      'conversationID': conversationID,
      'ZIMConversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter
        .cnvZIMConversationUnreadMessageCountClearedResultMapToObject(
            resultMap);
  }

  @override
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType) async {
    Map resultMap =
        await _channel.invokeMethod('setConversationNotificationStatus', {
      'status': ZIMConversationNotificationStatusExtension.valueMap[status],
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter
        .cnvZIMConversationNotificationStatusSetResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendPeerMessage', {
      'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
      'toUserID': toUserID,
      'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendGroupMessage', {
      'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
      'toGroupID': toGroupID,
      'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendRoomMessage',
        {'message': ZIMConverter.cnvZIMMessageObjectToMap(message)});
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryHistoryMessage', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteAllMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteAllMessage', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageDeletedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteMessages', {
      'messageList': ZIMConverter.cnvZIMMessageListObjectToMap(messageList),
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageDeletedResultMapToObject(resultMap);
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
}
