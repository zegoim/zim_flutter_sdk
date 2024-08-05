import 'dart:convert';

import '../../../zego_zim.dart';
import '../zim_converter.dart';
import '../zim_defines_extension.dart';
import '../zim_engine.dart';
import '../zim_manager.dart';

class ZIMEventHandlerWeb {
  static void eventListener(dynamic event) {
    final data = json.decode(event['data']);
    String handle = event['handle'];
    ZIMEngine? _zim = ZIMManager.engineMap[handle];

    if (_zim != null) {
      print("510 ev:"+event['ev']);
      switch (event['ev']) {
        case 'connectionStateChanged':
          return connectionStateChanged(_zim, data);
        case 'error':
          return error(_zim, data);
        case 'tokenWillExpire':
          return tokenWillExpire(_zim, data);
        case 'receiveRoomMessage':
          return receiveRoomMessage(_zim, data);
        case 'roomStateChanged':
          return roomStateChanged(_zim, data);
        case 'roomAttributesUpdated':
          return roomAttributesUpdated(_zim, data);
        case 'roomAttributesBatchUpdated':
          return roomAttributesBatchUpdated(_zim, data);
        case 'roomMemberJoined':
          return roomMemberJoined(_zim, data);
        case 'roomMemberLeft':
          return roomMemberLeft(_zim, data);
        case 'receivePeerMessage':
          return receivePeerMessage(_zim, data);
        case 'receiveGroupMessage':
          return receiveGroupMessage(_zim, data);
        case 'groupStateChanged':
          return groupStateChanged(_zim, data);
        case 'groupNameUpdated':
          return groupNameUpdated(_zim, data);
        case 'groupAvatarUrlUpdated':
          return groupAvatarUrlUpdated(_zim, data);
        case 'groupNoticeUpdated':
          return groupNoticeUpdated(_zim, data);
        case 'groupAttributesUpdated':
          return groupAttributesUpdated(_zim, data);
        case 'groupMemberStateChanged':
          return groupMemberStateChanged(_zim, data);
        case 'groupMemberInfoUpdated':
          return groupMemberInfoUpdated(_zim, data);
        case 'callInvitationReceived':
          return callInvitationReceived(_zim, data);
        case 'callInvitationCancelled':
          return callInvitationCancelled(_zim, data);
        case 'callInvitationTimeout':
          return callInvitationTimeout(_zim, data);
        case 'callUserStateChanged':
          return callUserStateChanged(_zim, data);
        case 'callInvitationEnded':
          return callInvitationEnded(_zim, data);
        case 'conversationChanged':
          return conversationChanged(_zim, data);
        case 'conversationTotalUnreadMessageCountUpdated':
          return conversationTotalUnreadMessageCountUpdated(_zim, data);
        case 'conversationMessageReceiptChanged':
          return conversationMessageReceiptChanged(_zim, data);
        case 'messageReceiptChanged':
          return messageReceiptChanged(_zim, data);
        case 'messageRevokeReceived':
          return messageRevokeReceived(_zim, data);
        case 'messageSentStatusChanged':
          return messageSentStatusChanged(_zim, data);
        case 'messageReactionsChanged':
          return messageReactionsChanged(_zim, data);
        case 'userInfoUpdated':
          return userInfoUpdated(_zim, data);
        case 'messageDeleted':
          return messageDeleted(_zim, data);
        case 'conversationsAllDeleted':
          return conversationsAllDeleted(_zim, data);
        case 'blacklistChanged':
          return blacklistChanged(_zim, data);
        case 'groupMutedInfoUpdated':
          return groupMutedInfoUpdated(_zim, data);
        case 'friendListChanged':
          return friendListChanged(_zim, data);
        case 'friendInfoUpdated':
          return friendInfoUpdated(_zim, data);
        case 'friendApplicationListChanged':
          return friendApplicationListChanged(_zim, data);
        case 'friendApplicationUpdated':
          return friendApplicationUpdated(_zim, data);
        case 'callInvitationCreated':
          return callInvitationCreated(_zim, data);
        case 'userRuleUpdated':
          return userRuleUpdated(_zim, data);
        case 'groupVerifyInfoUpdated':
          return groupVerifyInfoUpdated(_zim, data);
        case 'groupApplicationListChanged':
          return groupApplicationListChanged(_zim, data);
        case 'groupApplicationUpdated':
          return groupApplicationUpdated(_zim, data);
        case 'messageRepliedCountChanged':
          return messageRepliedCountChanged(_zim, data);
        case 'messageRepliedInfoChanged':
          return messageRepliedInfoChanged(_zim, data);
      }
    }
  }

  static void messageRepliedInfoChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageRepliedInfoChanged == null) return;
    List<ZIMMessage> messageList = ZIMConverter.oZIMMessageList(data['messageList']);
    ZIMEventHandler.onMessageRepliedInfoChanged!(zim,messageList);
  }

  static void messageRepliedCountChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageRepliedCountChanged == null) return;
    List<ZIMMessageRootRepliedCountInfo> infos = ZIMConverter.oZIMMessageRootRepliedCountInfoList(data['infos']);
    ZIMEventHandler.onMessageRepliedCountChanged!(zim,infos);
  }

  static void connectionStateChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConnectionStateChanged == null) return;

    Map<dynamic, dynamic> extendedData = {};

    if (data['extendedData'] != null && data['extendedData'] != '') {
      extendedData = json.decode(data['extendedData']);
    }

    ZIMConnectionState? _state = ZIMConnectionState.values[data['state']];
    ZIMConnectionEvent? _event = ZIMConnectionEvent.values[data['event']];

    ZIMEventHandler.onConnectionStateChanged!(
        zim, _state, _event, extendedData);
  }

  static void error(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onError == null) return;

    final code = data['code'];
    final message = data['message'];

    ZIMEventHandler.onError!(zim, ZIMError(code: code, message: message));
  }

  static void tokenWillExpire(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onTokenWillExpire == null) return;

    final second = data['second'];

    ZIMEventHandler.onTokenWillExpire!(zim, second);
  }

  static void receiveRoomMessage(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveRoomMessage == null) return;

    final fromConversationID = data['fromConversationID'];
    List<ZIMMessage> messageList =
    ZIMConverter.oZIMMessageList(data['messageList']);

    ZIMEventHandler.onReceiveRoomMessage!(zim, messageList, fromConversationID);
  }

  static void roomStateChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomStateChanged == null) return;

    Map<dynamic, dynamic> extendedData = {};

    if (data['extendedData'] != null && data['extendedData'] != '') {
      extendedData = jsonDecode(data['extendedData']);
    }

    ZIMRoomState _state = ZIMRoomState.values[data['state']];
    ZIMRoomEvent _event = ZIMRoomEvent.values[data['event']];

    ZIMEventHandler.onRoomStateChanged!(
        zim, _state, _event, extendedData, data['roomID']);
  }

  static void roomAttributesUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

    final infos = data['infos'];
    String roomID = data['roomID'];

    infos.forEach((info) {
      final roomAttributes = info['roomAttributes'];
      Map<String, String> mapRoomAttributes =
      Map<String, String>.from(roomAttributes);
      ZIMRoomAttributesUpdateAction action =
      ZIMRoomAttributesUpdateActionExtension.mapValue[info['action']]!;

      ZIMEventHandler.onRoomAttributesUpdated!(
          zim,
          ZIMRoomAttributesUpdateInfo(
              action: action, roomAttributes: mapRoomAttributes),
          roomID);
    });
  }

  static void roomAttributesBatchUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

    final infos = data['infos'];
    String roomID = data['roomID'];

    List<ZIMRoomAttributesUpdateInfo> list = [];

    infos.forEach((info) {
      final roomAttributes = info['roomAttributes'];
      Map<String, String> mapRoomAttributes =
      Map<String, String>.from(roomAttributes);

      ZIMRoomAttributesUpdateAction action =
      ZIMRoomAttributesUpdateActionExtension.mapValue[info['action']]!;

      list.add(ZIMRoomAttributesUpdateInfo(
          action: action, roomAttributes: mapRoomAttributes));
    });

    ZIMEventHandler.onRoomAttributesBatchUpdated!(zim, list, roomID);
  }

  static void roomMemberJoined(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberJoined == null) return;

    final memberList = data['memberList'];
    String roomID = data['roomID'];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      Map memberMap = Map.from(member);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = memberMap['userID'];
      userInfo.userName = memberMap['userName'];

      list.add(userInfo);
    });

    ZIMEventHandler.onRoomMemberJoined!(zim, list, roomID);
  }

  static void roomMemberLeft(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberLeft == null) return;

    final memberList = data['memberList'];
    String roomID = data['roomID'];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      Map memberMap = Map.from(member);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = memberMap['userID'];
      userInfo.userName = memberMap['userName'];

      list.add(userInfo);
    });

    ZIMEventHandler.onRoomMemberLeft!(zim, list, roomID);
  }

  static void receivePeerMessage(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceivePeerMessage == null) return;

    String fromConversationID = data['fromConversationID'];
    List<ZIMMessage> messageList =
    ZIMConverter.oZIMMessageList(data['messageList']);

    ZIMEventHandler.onReceivePeerMessage!(zim, messageList, fromConversationID);
  }

  static void receiveGroupMessage(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveGroupMessage == null) return;

    String fromConversationID = data['fromConversationID'];
    List<ZIMMessage> messageList =
    ZIMConverter.oZIMMessageList(data['messageList']);

    ZIMEventHandler.onReceiveGroupMessage!(
        zim, messageList, fromConversationID);
  }

  static void groupStateChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupStateChanged == null) return;

    final state = ZIMGroupState.values[data['state']];
    final event = ZIMGroupEvent.values[data['event']];

    ZIMEventHandler.onGroupStateChanged!(
        zim,
        state,
        event,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        ZIMConverter.oZIMGroupFullInfo(data['groupInfo'])!);
  }

  static void groupNameUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNameUpdated == null) return;

    final groupName = data['groupName'];
    final groupID = data['groupID'];

    ZIMEventHandler.onGroupNameUpdated!(zim, groupName,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupAvatarUrlUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;

    final groupAvatarUrl = data['groupAvatarUrl'];
    final groupID = data['groupID'];

    ZIMEventHandler.onGroupAvatarUrlUpdated!(zim, groupAvatarUrl,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupNoticeUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

    final groupNotice = data['groupNotice'];
    final groupID = data['groupID'];

    ZIMEventHandler.onGroupNoticeUpdated!(zim, groupNotice,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupAttributesUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

    List<ZIMGroupAttributesUpdateInfo> list = [];
    List<dynamic> infoList = data['infoList'];

    infoList.forEach((info) {
      Map<String, String> mapGroupAttributes =
      Map.from(info['groupAttributes']);
      ZIMGroupAttributesUpdateInfo atr = ZIMGroupAttributesUpdateInfo();
      atr.action = ZIMGroupAttributesUpdateAction.values[info['action']];
      atr.groupAttributes = mapGroupAttributes;
      list.add(atr);
    });

    final groupID = data['groupID'];

    ZIMEventHandler.onGroupAttributesUpdated!(zim, list,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupMemberStateChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

    final groupID = data['groupID'];
    ZIMGroupMemberState state = ZIMGroupMemberState.values[data['state']];
    ZIMGroupMemberEvent event = ZIMGroupMemberEvent.values[data['event']];

    ZIMEventHandler.onGroupMemberStateChanged!(
        zim,
        state,
        event,
        ZIMConverter.oZIMGroupMemberInfoList(data['userList']),
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        groupID);
  }

  static void groupMemberInfoUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

    final groupID = data['groupID'];

    ZIMEventHandler.onGroupMemberInfoUpdated!(
        zim,
        ZIMConverter.oZIMGroupMemberInfoList(data['userList']),
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        groupID);
  }

  static void callInvitationReceived(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationReceived == null) return;

    String callID = data['callID'];

    ZIMEventHandler.onCallInvitationReceived!(zim, ZIMConverter.oZIMCallInvitationReceivedInfo(data), callID);
  }

  static void callInvitationCancelled(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationCancelled == null) return;

    String callID = data['callID'];

    ZIMEventHandler.onCallInvitationCancelled!(zim, ZIMConverter.oZIMCallInvitationCancelledInfo(data), callID);
  }

  static void callInvitationTimeout(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationTimeout == null) return;

    String callID = data['callID'];

    ZIMEventHandler.onCallInvitationTimeout!(zim, ZIMConverter.oZIMCallInvitationTimeoutInfo(data), callID);
  }

  static void callUserStateChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallUserStateChanged == null) return;
    String callID = data['callID'];
    ZIMEventHandler.onCallUserStateChanged!(zim, ZIMConverter.oZIMCallUserStateChangedInfo(data), callID);
  }

  static void callInvitationEnded(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationEnded == null) return;
    String callID = data['callID'];

    ZIMEventHandler.onCallInvitationEnded!(zim, ZIMConverter.oZIMCallInvitationEndedInfo(data), callID);
  }

  static void conversationChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationChanged == null) return;

    List<ZIMConversationChangeInfo> conversationChangeInfoList =
    ZIMConverter.oZIMConversationChangeInfoList(data['infoList']);

    ZIMEventHandler.onConversationChanged!(zim, conversationChangeInfoList);
  }

  static void conversationTotalUnreadMessageCountUpdated(
      ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated == null) {
      return;
    }

    int count = data['totalUnreadMessageCount'];

    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(zim, count);
  }

  static void messageReceiptChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageReceiptChanged == null) {
      return;
    }

    List<ZIMMessageReceiptInfo> infos = [];

    data['infos'].forEach((map) {
      ZIMMessageReceiptInfo info = ZIMConverter.oZIMMessageReceiptInfo(map);

      infos.add(info);
    });

    ZIMEventHandler.onMessageReceiptChanged!(zim, infos);
  }

  static void conversationMessageReceiptChanged(
      ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationMessageReceiptChanged == null) {
      return;
    }

    List<ZIMMessageReceiptInfo> infos = [];

    data['infos'].forEach((map) {
      ZIMMessageReceiptInfo info = ZIMConverter.oZIMMessageReceiptInfo(map);

      infos.add(info);
    });

    ZIMEventHandler.onConversationMessageReceiptChanged!(zim, infos);
  }

  static void messageRevokeReceived(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageRevokeReceived == null) {
      return;
    }

    List<ZIMRevokeMessage> messageList = [];

    data['messageList'].forEach((map) {
      ZIMRevokeMessage message =
      ZIMConverter.oZIMMessage(map) as ZIMRevokeMessage;

      messageList.add(message);
    });

    ZIMEventHandler.onMessageRevokeReceived!(zim, messageList);
  }

  static void messageSentStatusChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageSentStatusChanged == null) {
      return;
    }

    List<ZIMMessageSentStatusChangeInfo> infos =
    ZIMConverter.oMessageSentStatusChangeInfoList(data['infos']);

    ZIMEventHandler.onMessageSentStatusChanged!(zim, infos);
  }

  static void messageReactionsChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageReactionsChanged == null) {
      return;
    }

    List<ZIMMessageReaction> reactions =
    ZIMConverter.oZIMMessageReactionList(data['reactions']);

    ZIMEventHandler.onMessageReactionsChanged!(zim, reactions);
  }

  static void broadcastMessageReceived(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onBroadcastMessageReceived == null) {
      return;
    }

    ZIMMessage message = ZIMConverter.oZIMMessage(data['message']);

    ZIMEventHandler.onBroadcastMessageReceived!(zim, message);
  }

  static void userInfoUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onUserInfoUpdated == null) {
      return;
    }

    ZIMUserFullInfo userFullInfo = ZIMConverter.oZIMUserFullInfo(data['info']);

    ZIMEventHandler.onUserInfoUpdated!(zim, userFullInfo);
  }

  static void messageDeleted(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageDeleted == null) {
      return;
    }

    ZIMMessageDeletedInfo deletedInfo = ZIMConverter.oZIMMessageDeletedInfo(data);

    ZIMEventHandler.onMessageDeleted!(zim, deletedInfo);
  }

  static void conversationsAllDeleted(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationsAllDeleted == null) {
      return;
    }

    ZIMConversationsAllDeletedInfo deletedInfo = ZIMConverter.oZIMConversationsAllDeletedInfo(data);

    ZIMEventHandler.onConversationsAllDeleted!(zim, deletedInfo);
  }

  static void blacklistChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onBlacklistChanged == null) {
      return;
    }

    ZIMBlacklistChangeAction action = ZIMBlacklistChangeActionExtension.mapValue[data['action']]!;
    List<ZIMUserInfo> userList = ZIMConverter.oZIMUserInfoList(data['userList'] ?? []);

    ZIMEventHandler.onBlacklistChanged!(zim, userList ,action);
  }

  static void groupMutedInfoUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMutedInfoUpdated == null) {
      return;
    }

    ZIMGroupMuteInfo groupMuteInfo = ZIMConverter.oZIMGroupMuteInfo(data['mutedInfo']);
    ZIMGroupOperatedInfo operatedInfo = ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']);
    String groupID = data['groupID'];

    ZIMEventHandler.onGroupMutedInfoUpdated!(zim, groupMuteInfo, operatedInfo, groupID);
  }

  static void friendListChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onFriendListChanged == null) {
      return;
    }

    ZIMFriendListChangeAction action = ZIMFriendListChangeActionExtension.mapValue[data['action']]!;
    List<ZIMFriendInfo> friendList = ZIMConverter.oZIMFriendInfoList(data['friendList'] ?? []);

    ZIMEventHandler.onFriendListChanged!(zim, friendList, action);
  }

  static void friendInfoUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onFriendInfoUpdated == null) {
      return;
    }

    List<ZIMFriendInfo> friendList = ZIMConverter.oZIMFriendInfoList(data['friendList'] ?? []) ?? [];

    ZIMEventHandler.onFriendInfoUpdated!(zim, friendList);
  }

  static void friendApplicationListChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onFriendApplicationListChanged == null) {
      return;
    }

    ZIMFriendApplicationListChangeAction action = ZIMFriendApplicationListChangeActionExtension.mapValue[data['action']]!;
    List<ZIMFriendApplicationInfo> applicationList = ZIMConverter.oZIMFriendApplicationInfoList(data['applicationList']);

    ZIMEventHandler.onFriendApplicationListChanged!(zim, applicationList, action );
  }

  static void friendApplicationUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onFriendApplicationUpdated == null) {
      return;
    }

    List<ZIMFriendApplicationInfo> applicationList = ZIMConverter.oZIMFriendApplicationInfoList(data['applicationList']);

    ZIMEventHandler.onFriendApplicationUpdated!(zim, applicationList);
  }

  static void callInvitationCreated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationCreated == null) {
      return;
    }

    ZIMCallInvitationCreatedInfo info = ZIMConverter.oZIMCallInvitationCreatedInfo(data);
    String callID = data['callID'];

    ZIMEventHandler.onCallInvitationCreated!(zim, info, callID);
  }

  static void userRuleUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onUserRuleUpdated == null) {
      return;
    }
    ZIMUserRule userRule = ZIMConverter.oZIMUserRule(data['userRule']);
    ZIMEventHandler.onUserRuleUpdated!(zim, userRule);
  }

  static void groupVerifyInfoUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupVerifyInfoUpdated == null) {
      return;
    }
    ZIMGroupVerifyInfo verifyInfo = ZIMConverter.oZIMGroupVerifyInfo(data['verifyInfo']);
    ZIMGroupOperatedInfo operatedInfo = ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']);
    String groupID = data['groupID'] ?? '';

    ZIMEventHandler.onGroupVerifyInfoUpdated!(zim, verifyInfo, operatedInfo, groupID);
  }

  static void groupApplicationListChanged(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupApplicationListChanged == null) {
      return;
    }

    List<ZIMGroupApplicationInfo> applicationList = ZIMConverter.oZIMGroupApplicationInfoList(data['applicationList'] ?? []);
    ZIMGroupApplicationListChangeAction action =
    ZIMGroupApplicationListChangeActionExtension.mapValue[data['action']]!;

    ZIMEventHandler.onGroupApplicationListChanged!(zim, applicationList, action);
  }

  static void groupApplicationUpdated(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupApplicationUpdated == null) {
      return;
    }
    List<ZIMGroupApplicationInfo> applicationList = ZIMConverter.oZIMGroupApplicationInfoList(data['applicationList'] ?? []);

    ZIMEventHandler.onGroupApplicationUpdated!(zim, applicationList);
  }
}