import 'package:zim/zim.dart';

class IntegrationTestEventHander {
  static loadEventHandler() {
    ZIMEventHandler.onConnectionStateChanged = (state, event, extendedData) {};

    ZIMEventHandler.onError = (errorInfo) {};

    ZIMEventHandler.onTokenWillExpire = (second) {};

    ZIMEventHandler.onConversationChanged = (conversationChangeInfoList) {};

    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (totalUnreadMessageCount) {};

    ZIMEventHandler.onReceivePeerMessage = (messageList, fromUserID) {};

    ZIMEventHandler.onReceiveRoomMessage = (messageList, fromRoomID) {};

    ZIMEventHandler.onReceiveGroupMessage = (messageList, fromGroupID) {};

    ZIMEventHandler.onRoomMemberJoined = (memberList, roomID) {};

    ZIMEventHandler.onRoomMemberLeft = (memberList, roomID) {};

    ZIMEventHandler.onRoomStateChanged =
        (state, event, extendedData, roomID) {};

    ZIMEventHandler.onRoomAttributesUpdated = (updateInfo, roomID) {};

    ZIMEventHandler.onRoomAttributesBatchUpdated = (updateInfo, roomID) {};

    ZIMEventHandler.onGroupStateChanged =
        (state, event, operatedInfo, groupInfo) {};

    ZIMEventHandler.onGroupNameUpdated = (groupName, operatedInfo, groupID) {};

    ZIMEventHandler.onGroupNoticeUpdated =
        (groupNotice, operatedInfo, groupID) {};

    ZIMEventHandler.onGroupAttributesUpdated =
        (updateInfo, operatedInfo, groupID) {};

    ZIMEventHandler.onGroupMemberStateChanged =
        (state, event, userList, operatedInfo, groupID) {};

    ZIMEventHandler.onGroupMemberInfoUpdated =
        (userInfo, operatedInfo, groupID) {};

    ZIMEventHandler.onCallInvitationReceived = (info, callID) {};

    ZIMEventHandler.onCallInvitationCancelled = (info, callID) {};

    ZIMEventHandler.onCallInvitationAccepted = (info, callID) {};

    ZIMEventHandler.onCallInvitationRejected = (info, callID) {};

    ZIMEventHandler.onCallInvitationTimeout = (callID) {};

    ZIMEventHandler.onCallInviteesAnsweredTimeout = (invitees, callID) {};
  }
}
