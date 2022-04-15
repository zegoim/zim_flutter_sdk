import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import 'zim_define.dart';

abstract class ZIM {
  static ZIM getInstance() {
    return ZIMImpl.getInstance();
  }

  Future<String> getVersion();

//MARK: -Main
  Future<void> create(int appID);

  Future<void> destroy();

  Future<void> setLogConfig(ZIMLogConfig config);

  Future<void> setCacheConfig(ZIMCacheConfig config);

  Future<ZIMLoggedInResult> login(String userID, String userName, String token);

  Future<void> logout();

  Future<ZIMTokenRenewedResult> renewToken(String token);

  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(List<String> userIDs);

//MARK: -Conversation
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config);

  Future<ZIMConversationDeletedResult> deleteConversation(String conversationID,
      ZIMConversationType conversationType, ZIMMessageDeleteConfig config);

  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversation, ZIMConversationType conversationType);

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

  //MARK: -createRoom
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]);
}
