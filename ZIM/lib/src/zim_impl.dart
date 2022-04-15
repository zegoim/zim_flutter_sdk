import 'dart:async';
import 'package:zim/src/zim_converter.dart';

import 'zim_api.dart';
import 'package:flutter/services.dart';
import 'zim_define.dart';
import 'zim_define_extension.dart';
import 'zim_errorCode.dart';
import 'zim_errorCode_extension.dart';

class ZIMImpl implements ZIM {
  static const MethodChannel _channel = MethodChannel('zim');
  static ZIMImpl? _zimImpl;

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
  Future<ZIMLoggedInResult> login(
      String userID, String userName, String token) async {
    Map resultMap = await _channel.invokeMethod(
        "login", {"userID": userID, "userName": userName, "token": token});
    return ZIMConverter.CNVLoggedInMap(resultMap);
  }

  @override
  Future<ZIMTokenRenewedResult> logout() async {
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
    ZIMRoomCreatedResult result = ZIMRoomCreatedResult(
        roomInfo: ZIMRoomFullInfo(), errorInfo: ZIMError());
    return result;
  }
}
