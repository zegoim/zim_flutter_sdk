import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zim/zim.dart';

class ZIMExampleEventHander {
  static loadEventHandler() {
    ZIMEventHandler.onConnectionStateChanged = (state, event, extendedData) {
      print(state);
    };

    ZIMEventHandler.onError = (errorInfo) {
      print('onError');
    };

    ZIMEventHandler.onTokenWillExpire = (second) {};

    ZIMEventHandler.onConversationChanged = (conversationChangeInfoList) {
      print('onConversationChanged');
    };

    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (totalUnreadMessageCount) {
      print('totalUnreadMessageCount');
    };

    ZIMEventHandler.onReceivePeerMessage = (messageList, fromUserID) {
      print('onReceivePeerMessage');
    };

    ZIMEventHandler.onReceiveRoomMessage = (messageList, fromRoomID) {
      print('onReceiveRoomMessage');
    };

    ZIMEventHandler.onReceiveGroupMessage = (messageList, fromGroupID) {
      print('onReceiveGroupMessage');
    };

    ZIMEventHandler.onRoomMemberJoined = (memberList, roomID) {
      print('onRoomMemberJoined');
    };

    ZIMEventHandler.onRoomMemberLeft = (memberList, roomID) {
      print('onRoomMemberLeft');
    };

    ZIMEventHandler.onRoomStateChanged = (state, event, extendedData, roomID) {
      print('onRoomStateChanged');
    };

    ZIMEventHandler.onRoomAttributesUpdated = (updateInfo, roomID) {
      print('onRoomAttributesUpdated');
    };

    ZIMEventHandler.onRoomAttributesBatchUpdated = (updateInfo, roomID) {
      print('onRoomAttributesBatchUpdated');
    };

    ZIMEventHandler.onGroupStateChanged =
        (state, event, operatedInfo, groupInfo) {
      print('onGroupStateChanged');
    };

    ZIMEventHandler.onGroupNameUpdated = (groupName, operatedInfo, groupID) {
      print('onGroupNameUpdated');
    };

    ZIMEventHandler.onGroupNoticeUpdated =
        (groupNotice, operatedInfo, groupID) {
      print('onGroupNoticeUpdated');
    };

    ZIMEventHandler.onGroupAttributesUpdated =
        (updateInfo, operatedInfo, groupID) {
      print('onGroupAttributesUpdated');
    };

    ZIMEventHandler.onGroupMemberStateChanged =
        (state, event, userList, operatedInfo, groupID) {
      print('onGroupMemberStateChanged');
    };

    ZIMEventHandler.onGroupMemberInfoUpdated =
        (userInfo, operatedInfo, groupID) {
      print('onGroupMemberInfoUpdated');
    };

    ZIMEventHandler.onCallInvitationReceived = (info, callID) {
      print('onCallInvitationReceived');
      ZIMCallAcceptConfig config = ZIMCallAcceptConfig();
      config.extendedData = '';
      ZIM.getInstance().callAccept(callID, config);
    };

    ZIMEventHandler.onCallInvitationCancelled = (info, callID) {
      print('onCallInvitationCancelled');
    };

    ZIMEventHandler.onCallInvitationAccepted = (info, callID) {
      print('onCallInvitationAccepted');
    };

    ZIMEventHandler.onCallInvitationRejected = (info, callID) {
      print('onCallInvitationRejected');
    };

    ZIMEventHandler.onCallInvitationTimeout = (callID) {
      print('onCallInvitationTimeout');
    };

    ZIMEventHandler.onCallInviteesAnsweredTimeout = (invitees, callID) {
      print('onCallInviteesAnsweredTimeout');
    };
  }
}
