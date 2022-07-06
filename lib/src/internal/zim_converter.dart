import '../zim_defines.dart';
import 'zim_defines_extension.dart';

//MARK: Tools
class ZIMConverter {
  static ZIMTokenRenewedResult cnvTokenRenewedMapToObject(Map resultMap) {
    String token = resultMap['token'];

    return ZIMTokenRenewedResult(token: token);
  }

  static ZIMUsersInfoQueriedResult cnvZIMUsersInfoQueriedMapToObject(
      Map resultMap) {
    List userListBasic = resultMap['userList'];
    List errorUserListBasic = resultMap['errorUserList'];

    List<ZIMUserFullInfo> userList = [];
    for (Map userFullInfoMap in userListBasic) {
      userList.add(cnvZIMUserFullInfoMapToObject(userFullInfoMap));
    }

    List<ZIMErrorUserInfo> errorUserList = [];
    for (Map errorUserInfoBasic in errorUserListBasic) {
      errorUserList.add(cnvZIMErrorUserInfoMapToObject(errorUserInfoBasic));
    }

    return ZIMUsersInfoQueriedResult(
        userList: userList, errorUserList: errorUserList);
  }

  static ZIMUserFullInfo cnvZIMUserFullInfoMapToObject(
      Map userFullInfoBasicMap) {
    ZIMUserFullInfo userFullInfo = ZIMUserFullInfo();
    userFullInfo.baseInfo =
        cnvZIMUserInfoMapToObject(userFullInfoBasicMap['baseInfo']);
    userFullInfo.extendedData = userFullInfoBasicMap['extendedData'];
    return userFullInfo;
  }

  static ZIMUserInfo cnvZIMUserInfoMapToObject(Map userInfoBasicMap) {
    ZIMUserInfo userInfo = ZIMUserInfo();
    userInfo.userID = userInfoBasicMap['userID'];
    userInfo.userName = userInfoBasicMap['userName'];
    return userInfo;
  }

  static ZIMErrorUserInfo cnvZIMErrorUserInfoMapToObject(
      Map errorUserInfoBasicMap) {
    ZIMErrorUserInfo errorUserInfo = ZIMErrorUserInfo();
    errorUserInfo.userID = errorUserInfoBasicMap['userID'];
    errorUserInfo.reason = errorUserInfoBasicMap['reason'];
    return errorUserInfo;
  }

  static ZIMUserExtendedDataUpdatedResult
      cnvZIMUserExtendedDataUpdatedMapToObject(Map resultMap) {
    return ZIMUserExtendedDataUpdatedResult(
        extendedData: resultMap['extendedData']);
  }

  static ZIMUserNameUpdatedResult cnvZIMUserNameUpdatedMapToObject(
      Map resultMap) {
    return ZIMUserNameUpdatedResult(userName: resultMap['userName']);
  }


  static List<ZIMErrorUserInfo> cnvBasicListToZIMErrorUserInfoList(
      List basicList) {
    List<ZIMErrorUserInfo> errorUserInfoList = [];
    for (Map errorUserInfoMap in basicList) {
      ZIMErrorUserInfo errorUserInfo =
          cnvZIMErrorUserInfoMapToObject(errorUserInfoMap);
      errorUserInfoList.add(errorUserInfo);
    }
    return errorUserInfoList;
  }

  static Map cnvZIMConversationQueryConfigObjectToMap(
      ZIMConversationQueryConfig config) {
    Map queryConfigMap = {};
    queryConfigMap['count'] = config.count;
    queryConfigMap['nextConversation'] =
        cnvZIMConversationObjectToMap(config.nextConversation);
    return queryConfigMap;
  }

  static Map? cnvZIMConversationObjectToMap(ZIMConversation? conversation) {
    if (conversation == null) return null;
    Map conversationMap = {};
    conversationMap['conversationID'] = conversation.conversationID;
    conversationMap['conversationName'] = conversation.conversationName;
    conversationMap['type'] =
        ZIMConversationTypeExtension.valueMap[conversation.type];
    conversationMap['notificationStatus'] =
        ZIMConversationNotificationStatusExtension
            .valueMap[conversation.notificationStatus];
    conversationMap['unreadMessageCount'] = conversation.unreadMessageCount;
    conversationMap['orderKey'] = conversation.orderKey;
    if (conversation.lastMessage != null) {
      conversationMap['lastMessage'] =
          cnvZIMMessageObjectToMap(conversation.lastMessage!);
    }
    return conversationMap;
  }

  static ZIMConversation cnvZIMConversationMapToObject(Map resultMap) {
    ZIMConversation conversation = ZIMConversation();
    conversation.conversationID = resultMap['conversationID'];
    conversation.conversationName = resultMap['conversationName'];
    conversation.type =
        ZIMConversationTypeExtension.mapValue[resultMap['type']]!;
    conversation.unreadMessageCount = resultMap['unreadMessageCount'];
    conversation.orderKey = resultMap['orderKey'];
    if (resultMap['lastMessage'] != null) {
      conversation.lastMessage =
          cnvZIMMessageMapToObject(resultMap['lastMessage']);
    }
    return conversation;
  }

  static Map cnvZIMMessageObjectToMap(ZIMMessage message) {
    Map messageMap = {};
    messageMap['type'] = ZIMMessageTypeExtension.valueMap[message.type];
    messageMap['messageID'] = message.messageID;
    messageMap['localMessageID'] = message.localMessageID;
    messageMap['senderUserID'] = message.senderUserID;
    messageMap['conversationID'] = message.conversationID;
    messageMap['direction'] =
        ZIMMessageDirectionExtension.valueMap[message.direction];
    messageMap['sentStatus'] =
        ZIMMessageSentStatusExtension.valueMap[message.sentStatus];
    messageMap['conversationType'] =
        ZIMConversationTypeExtension.valueMap[message.conversationType];
    messageMap['timestamp'] = message.timestamp;
    messageMap['conversationSeq'] = message.conversationSeq;
    messageMap['orderKey'] = message.orderKey;
    if (message is ZIMMediaMessage) {
      messageMap['fileLocalPath'] = message.fileLocalPath;
      messageMap['fileDownloadUrl'] = message.fileDownloadUrl;
      messageMap['fileUID'] = message.fileUID;
      messageMap['fileName'] = message.fileName;
      messageMap['fileSize'] = message.fileSize;
    }
    switch (message.type) {
      case ZIMMessageType.unknown:
        break;
      case ZIMMessageType.text:
        message as ZIMTextMessage;
        messageMap['message'] = message.message;
        break;
      case ZIMMessageType.command:
        message as ZIMCommandMessage;
        messageMap['message'] = message.message;
        break;
      case ZIMMessageType.barrage:
        message as ZIMBarrageMessage;
        messageMap['message'] = message.message;
        break;
      case ZIMMessageType.file:
        break;
      case ZIMMessageType.audio:
        message as ZIMAudioMessage;
        messageMap['audioDuration'] = message.audioDuration;
        break;
      case ZIMMessageType.image:
        message as ZIMImageMessage;
        messageMap['thumbnailDownloadUrl'] = message.thumbnailDownloadUrl;
        messageMap['thumbnailLocalPath'] = message.thumbnailLocalPath;
        messageMap['largeImageDownloadUrl'] = message.largeImageDownloadUrl;
        messageMap['largeImageLocalPath'] = message.largeImageLocalPath;
        break;
      case ZIMMessageType.video:
        message as ZIMVideoMessage;
        messageMap['videoDuration'] = message.videoDuration;
        messageMap['videoFirstFrameDownloadUrl'] =
            message.videoFirstFrameDownloadUrl;
        messageMap['videoFirstFrameLocalPath'] =
            message.videoFirstFrameLocalPath;
        break;
      default:
        break;
    }
    return messageMap;
  }

  static ZIMMessage cnvZIMMessageMapToObject(Map resultMap) {
    ZIMMessageType msgType =
        ZIMMessageTypeExtension.mapValue[resultMap['type']]!;
    ZIMMessage message;
    switch (msgType) {
      case ZIMMessageType.unknown:
        message = ZIMMessage();
        break;
      case ZIMMessageType.text:
        message = ZIMTextMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.command:
        message = ZIMCommandMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.barrage:
        message = ZIMBarrageMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.image:
        message = ZIMImageMessage(resultMap['fileLocalPath']);
        message as ZIMImageMessage;
        message.thumbnailDownloadUrl = resultMap['thumbnailDownloadUrl'];
        message.thumbnailLocalPath = resultMap['thumbnailLocalPath'];
        message.largeImageDownloadUrl = resultMap['largeImageDownloadUrl'];
        message.largeImageLocalPath = resultMap['largeImageLocalPath'];
        break;
      case ZIMMessageType.file:
        message = ZIMFileMessage(resultMap['fileLocalPath']);
        message as ZIMFileMessage;
        break;
      case ZIMMessageType.audio:
        message = ZIMAudioMessage(resultMap['fileLocalPath']);
        message as ZIMAudioMessage;
        message.audioDuration = resultMap['audioDuration'];
        break;
      case ZIMMessageType.video:
        message = ZIMVideoMessage(resultMap['fileLocalPath']);
        message as ZIMVideoMessage;
        message.videoDuration = resultMap['videoDuration'];
        message.videoFirstFrameDownloadUrl =
            resultMap['videoFirstFrameDownloadUrl'];
        message.videoFirstFrameLocalPath =
            resultMap['videoFirstFrameLocalPath'];
        break;
      default:
        message = ZIMMessage();
        break;
    }
    message.type = ZIMMessageTypeExtension.mapValue[resultMap['type']]!;
    message.messageID = resultMap['messageID'];
    message.localMessageID = resultMap['localMessageID'];
    message.senderUserID = resultMap['senderUserID'];
    message.conversationID = resultMap['conversationID'];
    message.direction =
        ZIMMessageDirectionExtension.mapValue[resultMap['direction']]!;
    message.sentStatus =
        ZIMMessageSentStatusExtension.mapValue[resultMap['sentStatus']]!;
    message.conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    message.timestamp = resultMap['timestamp'];
    message.conversationSeq = resultMap['conversationSeq'];
    message.orderKey = resultMap['orderKey'];

    if (message is ZIMMediaMessage) {
      message.fileLocalPath = resultMap['fileLocalPath'];
      message.fileDownloadUrl = resultMap['fileDownloadUrl'];
      message.fileUID = resultMap['fileUID'];
      message.fileName = resultMap['fileName'];
      message.fileSize = resultMap['fileSize'];
    }

    return message;
  }

  static List cnvZIMMessageListObjectToMap(List<ZIMMessage> messageList) {
    List messageBasicList = [];
    for (ZIMMessage message in messageList) {
      messageBasicList.add(cnvZIMMessageObjectToMap(message));
    }
    return messageBasicList;
  }

  static List<ZIMMessage> cnvZIMMessageListMapToObject(List messageBasicList) {
    List<ZIMMessage> messageList = [];
    for (Map messageMap in messageBasicList) {
      messageList.add(cnvZIMMessageMapToObject(messageMap));
    }
    return messageList;
  }

  static ZIMConversationListQueriedResult
      cnvZIMConversationListQueriedMapToObject(Map resultMap) {
    List conversationBasicList = resultMap['conversationList'];
    List<ZIMConversation> conversationList = [];
    for (Map conversationBasicMap in conversationBasicList) {
      conversationList.add(cnvZIMConversationMapToObject(conversationBasicMap));
    }
    return ZIMConversationListQueriedResult(conversationList: conversationList);
  }

  static Map cnvZIMConversationDeleteConfigObjectToMap(
      ZIMConversationDeleteConfig config) {
    Map configMap = {};
    configMap['isAlsoDeleteServerConversation'] =
        config.isAlsoDeleteServerConversation;
    return configMap;
  }

  static Map cnvZIMMessageDeleteConfigObjectToMap(
      ZIMMessageDeleteConfig config) {
    Map map = {};
    map['isAlsoDeleteServerMessage'] = config.isAlsoDeleteServerMessage;
    return map;
  }

  static ZIMConversationUnreadMessageCountClearedResult
      cnvZIMConversationUnreadMessageCountClearedResultMapToObject(
          Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMConversationUnreadMessageCountClearedResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static ZIMConversationNotificationStatusSetResult
      cnvZIMConversationNotificationStatusSetResultMapToObject(Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMConversationNotificationStatusSetResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static List<ZIMConversationChangeInfo>
      cnvZIMConversationChangeInfoListBasicToObject(
          List conversationChangeInfoBasicList) {
    List<ZIMConversationChangeInfo> conversationChangeInfoList = [];
    for (Map conversationChangeInfoMap in conversationChangeInfoBasicList) {
      conversationChangeInfoList.add(
          cnvZIMConversationChangeInfoMapToObject(conversationChangeInfoMap));
    }
    return conversationChangeInfoList;
  }

  static ZIMConversationDeletedResult
      cnvZIMConversationDeletedResultMapToObject(Map resultMap) {
    return ZIMConversationDeletedResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!);
  }

  static ZIMConversationChangeInfo cnvZIMConversationChangeInfoMapToObject(
      Map conversationChangeInfoMap) {
    ZIMConversationChangeInfo conversationChangeInfo =
        ZIMConversationChangeInfo();
    conversationChangeInfo.event = ZIMConversationEventExtension
        .mapValue[conversationChangeInfoMap['event']]!;

    Map conversationMap = conversationChangeInfoMap['conversation'];
    conversationChangeInfo.conversation =
        cnvZIMConversationMapToObject(conversationMap);
    return conversationChangeInfo;
  }

  static Map cnvZIMMessageSendConfigObjectToMap(
      ZIMMessageSendConfig sendConfig) {
    Map sendConfigMap = {};
    sendConfigMap['pushConfig'] =
        cnvZIMPushConfigObjectToMap(sendConfig.pushConfig);
    sendConfigMap['priority'] =
        ZIMMessagePriorityExtension.valueMap[sendConfig.priority];
    return sendConfigMap;
  }

  static Map? cnvZIMPushConfigObjectToMap(ZIMPushConfig? pushConfig) {
    if (pushConfig == null) return null;
    Map pushConfigMap = {};
    pushConfigMap['title'] = pushConfig.title;
    pushConfigMap['content'] = pushConfig.content;
    pushConfigMap['extendedData'] = pushConfig.extendedData;
    return pushConfigMap;
  }

  static ZIMMessageSentResult cnvZIMMessageSentResultMapToObject(
      Map resultMap) {
    ZIMMessage message = cnvZIMMessageMapToObject(resultMap['message']);
    return ZIMMessageSentResult(message: message);
  }

  static Map cnvZIMMessageQueryConfigObjectToMap(
      ZIMMessageQueryConfig queryConfig) {
    Map queryConfigMap = {};
    queryConfigMap['count'] = queryConfig.count;
    queryConfigMap['reverse'] = queryConfig.reverse;
    if (queryConfig.nextMessage != null) {
      queryConfigMap['nextMessage'] =
          cnvZIMMessageObjectToMap(queryConfig.nextMessage!);
    } else {
      queryConfigMap['nextMessage'] = null;
    }
    return queryConfigMap;
  }

  static ZIMMessageQueriedResult cnvZIMMessageQueriedResultMapToObject(
      Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    List<ZIMMessage> messageList = [];
    for (Map messageMap in resultMap['messageList']) {
      messageList.add(cnvZIMMessageMapToObject(messageMap));
    }
    return ZIMMessageQueriedResult(
        conversationID: conversationID,
        conversationType: conversationType,
        messageList: messageList);
  }

  static ZIMMessageDeletedResult cnvZIMMessageDeletedResultMapToObject(
      Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMMessageDeletedResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static Map cnvZIMRoomInfoObjectToMap(ZIMRoomInfo roomInfo) {
    Map roomInfoMap = {};
    roomInfoMap['roomID'] = roomInfo.roomID;
    roomInfoMap['roomName'] = roomInfo.roomName;

    return roomInfoMap;
  }

  static ZIMRoomInfo cnvZIMRoomInfoMapToObject(Map roomInfoMap) {
    ZIMRoomInfo roomInfo = ZIMRoomInfo();
    roomInfo.roomID = roomInfoMap["roomID"];
    roomInfo.roomName = roomInfoMap["roomName"];

    return roomInfo;
  }

  static ZIMRoomFullInfo cnvZIMRoomFullInfoMapToObject(Map roomFullInfoMap) {
    ZIMRoomInfo roomInfo =
        cnvZIMRoomInfoMapToObject(roomFullInfoMap["baseInfo"]);
    ZIMRoomFullInfo roomFullInfo = ZIMRoomFullInfo(baseInfo: roomInfo);
    return roomFullInfo;
  }

  static ZIMRoomCreatedResult cnvZIMRoomCreatedResultMapToObject(
      Map resultMap) {
    ZIMRoomFullInfo roomInfo =
        cnvZIMRoomFullInfoMapToObject(resultMap["roomInfo"]);

    return ZIMRoomCreatedResult(roomInfo: roomInfo);
  }

  static ZIMRoomEnteredResult cnvZIMRoomEnteredResultMapToObject(
      Map resultMap) {
    ZIMRoomFullInfo roomInfo =
        cnvZIMRoomFullInfoMapToObject(resultMap["roomInfo"]);

    return ZIMRoomEnteredResult(roomInfo: roomInfo);
  }

  static Map cnvZIMRoomAdvancedConfigObjectToMap(ZIMRoomAdvancedConfig config) {
    Map configMap = {};
    configMap['roomAttributes'] = config.roomAttributes;
    configMap['roomDestroyDelayTime'] = config.roomDestroyDelayTime;
    return configMap;
  }

  static ZIMRoomJoinedResult cnvZIMRoomJoinedResultMapToObject(Map resultMap) {
    return ZIMRoomJoinedResult(
        roomInfo: cnvZIMRoomFullInfoMapToObject(resultMap['roomInfo']));
  }

  static ZIMRoomLeftResult cnvZIMRoomLeftResultMapToObject(Map resultMap) {
    return ZIMRoomLeftResult(roomID: resultMap['roomID']);
  }

  static Map cnvZIMRoomMemberQueryConfigObjectToMap(
      ZIMRoomMemberQueryConfig config) {
    Map configMap = {};
    configMap['nextFlag'] = config.nextFlag;
    configMap['count'] = config.count;
    return configMap;
  }

  static ZIMRoomMemberQueryConfig cnvZIMRoomMemberQueryConfigMapToObject(
      Map configMap) {
    ZIMRoomMemberQueryConfig queryConfig = ZIMRoomMemberQueryConfig();
    queryConfig.count = configMap['count'];
    queryConfig.nextFlag = configMap['nextFlag'];
    return queryConfig;
  }

  static List<ZIMUserInfo> cnvZIMUserInfoListBasicToObject(
      List memberListBasic) {
    List<ZIMUserInfo> memberList = [];
    for (Map memberInfoMap in memberListBasic) {
      memberList.add(cnvZIMUserInfoMapToObject(memberInfoMap));
    }
    return memberList;
  }

  static ZIMRoomMemberQueriedResult cnvZIMRoomMemberQueriedResultMapToObject(
      Map resultMap) {
    return ZIMRoomMemberQueriedResult(
        roomID: resultMap['roomID'],
        nextFlag: resultMap['nextFlag'],
        memberList: cnvZIMUserInfoListBasicToObject(resultMap['memberList']));
  }

  static ZIMRoomOnlineMemberCountQueriedResult
      cnvZIMRoomOnlineMemberCountQueriedResultMapToObject(Map resultMap) {
    return ZIMRoomOnlineMemberCountQueriedResult(
        roomID: resultMap['roomID'], count: resultMap['count']);
  }

  static Map? cnvZIMRoomAttributesSetConfigObjectToMap(
      ZIMRoomAttributesSetConfig? config) {
    Map configMap;
    if (config != null) {
      configMap = {};
      configMap['isForce'] = config.isForce;
      configMap['isDeleteAfterOwnerLeft'] = config.isDeleteAfterOwnerLeft;
      configMap['isUpdateOwner'] = config.isUpdateOwner;
      return configMap;
    } else {
      return null;
    }
  }

  static ZIMRoomAttributesOperatedCallResult
      cnvZIMRoomAttributesOperatedCallResultMapToObject(Map resultMap) {
    return ZIMRoomAttributesOperatedCallResult(
        roomID: resultMap['roomID'],
        errorKeys: (resultMap['errorKeys'] as List).cast<String>());
  }

  static Map? cnvZIMRoomAttributesDeleteConfigObjectToMap(
      ZIMRoomAttributesDeleteConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['isForce'] = config.isForce;
    return configMap;
  }

  static Map? cnvZIMRoomAttributesBatchOperationConfigObjectToMap(
      ZIMRoomAttributesBatchOperationConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['isForce'] = config.isForce;
    configMap['isDeleteAfterOwnerLeft'] = config.isDeleteAfterOwnerLeft;
    configMap['isUpdateOwner'] = config.isUpdateOwner;
    return configMap;
  }

  static ZIMRoomAttributesBatchOperatedResult
      cnvZIMRoomAttributesBatchOperatedResultMapToObject(Map resultMap) {
    return ZIMRoomAttributesBatchOperatedResult(roomID: resultMap['roomID']);
  }

  static ZIMRoomAttributesQueriedResult
      cnvZIMRoomAttributesQueriedResultMapToObject(Map resultMap) {
    Map roomAttributes = resultMap['roomAttributes'];

    return ZIMRoomAttributesQueriedResult(
        roomID: resultMap['roomID'],
        roomAttributes: roomAttributes.cast<String, String>());
  }

  static ZIMRoomAttributesUpdateInfo cnvZIMRoomAttributesUpdateInfoMapToObject(
      Map infoMap) {
    return ZIMRoomAttributesUpdateInfo(
        action:
            ZIMRoomAttributesUpdateActionExtension.mapValue[infoMap['action']]!,
        roomAttributes:
            (infoMap['roomAttributes'] as Map).cast<String, String>());
  }

  static List<ZIMRoomAttributesUpdateInfo>
      cnvZIMRoomAttributesUpdateInfoListBasicToObject(List infoBasicList) {
    List<ZIMRoomAttributesUpdateInfo> infoList = [];
    for (Map infoMap in infoBasicList) {
      infoList.add(cnvZIMRoomAttributesUpdateInfoMapToObject(infoMap));
    }
    return infoList;
  }

  static Map? cnvZIMGroupInfoObjectToMap(ZIMGroupInfo? groupInfo) {
    if (groupInfo == null) {
      return null;
    }
    Map groupInfoMap = {};
    groupInfoMap['groupID'] = groupInfo.groupID;
    groupInfoMap['groupName'] = groupInfo.groupName;
    return groupInfoMap;
  }

  static ZIMGroupInfo? cnvZIMGroupInfoMapToObject(Map? groupInfoMap) {
    if (groupInfoMap == null) {
      return null;
    }
    ZIMGroupInfo groupInfo = ZIMGroupInfo();
    groupInfo.groupID = groupInfoMap['groupID'];
    groupInfo.groupName = groupInfoMap['groupName'];
    return groupInfo;
  }

  static ZIMGroupFullInfo? cnvZIMGroupFullInfoMapToObject(
      Map? groupFullInfoMap) {
    if (groupFullInfoMap == null) {
      return null;
    }
    ZIMGroupFullInfo groupFullInfo = ZIMGroupFullInfo(
        baseInfo: cnvZIMGroupInfoMapToObject(groupFullInfoMap['baseInfo'])!);
    groupFullInfo.groupNotice = groupFullInfoMap['groupNotice'];
    groupFullInfo.groupAttributes =
        (groupFullInfoMap['groupAttributes'] as Map).cast<String, String>();
    return groupFullInfo;
  }

  static Map? cnvZIMGroupAdvancedConfigObjectToMap(
      ZIMGroupAdvancedConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['groupNotice'] = config.groupNotice;
    configMap['groupAttributes'] = config.groupAttributes;
    return configMap;
  }

  static ZIMGroupCreatedResult cnvZIMGroupCreatedResultMapToObject(
      Map resultMap) {
    ZIMGroupFullInfo groupInfo =
        cnvZIMGroupFullInfoMapToObject(resultMap['groupInfo'])!;
    List<String> userList = (resultMap['userList'] as List).cast<String>();
    List<String> errorUserList =
        (resultMap['errorUserList'] as List).cast<String>();
    ZIMGroupCreatedResult result = ZIMGroupCreatedResult(
        groupInfo: groupInfo, userList: userList, errorUserList: errorUserList);
    return result;
  }

  static ZIMGroupDismissedResult cnvZIMGroupDismissedResultMapToObject(
      Map resultMap) {
    return ZIMGroupDismissedResult(groupID: resultMap['groupID']);
  }

  static ZIMGroupJoinedResult cnvZIMGroupJoinedResultMapToObject(
      Map resultMap) {
    ZIMGroupFullInfo groupInfo =
        cnvZIMGroupFullInfoMapToObject(resultMap['groupInfo'])!;
    return ZIMGroupJoinedResult(groupInfo: groupInfo);
  }

  static ZIMGroupLeftResult cnvZIMGroupLeftResultMapToObject(Map resultMap) {
    return ZIMGroupLeftResult(groupID: resultMap['groupID']);
  }

  static ZIMGroupUsersInvitedResult cnvZIMGroupUsersInvitedResultMapToObject(
      Map resultMap) {
    List<ZIMErrorUserInfo> errorUserList =
        cnvBasicListToZIMErrorUserInfoList(resultMap['errorUserList']);
    List<ZIMGroupMemberInfo> userList =
        cnvBasicListToZIMGroupMemberInfoList(resultMap['userList']);
    return ZIMGroupUsersInvitedResult(
        errorUserList: errorUserList,
        groupID: resultMap['groupID'],
        userList: userList);
  }

  static ZIMGroupMemberKickedResult cnvZIMGroupMemberKickedResultMapToObject(
      Map resultMap) {
    List<ZIMErrorUserInfo> errorUserList =
        cnvBasicListToZIMErrorUserInfoList(resultMap['errorUserList']);
    return ZIMGroupMemberKickedResult(
        groupID: resultMap['groupID'],
        kickedUserIDList:
            (resultMap['kickedUserIDList'] as List).cast<String>(),
        errorUserList: errorUserList);
  }

  static ZIMGroupOwnerTransferredResult
      cnvZIMGroupOwnerTransferredResultMapToObject(Map resultMap) {
    return ZIMGroupOwnerTransferredResult(
        groupID: resultMap['groupID'], toUserID: resultMap['toUserID']);
  }

  static ZIMGroupNameUpdatedResult cnvZIMGroupNameUpdatedResultMapToObject(
      Map resultMap) {
    return ZIMGroupNameUpdatedResult(
        groupID: resultMap['groupID'], groupName: resultMap['groupName']);
  }

  static ZIMGroupNoticeUpdatedResult cnvZIMGroupNoticeUpdatedResultMapToObject(
      Map resultMap) {
    return ZIMGroupNoticeUpdatedResult(
        groupID: resultMap['groupID'], groupNotice: resultMap['groupNotice']);
  }

  static ZIMGroupInfoQueriedResult cnvZIMGroupInfoQueriedResultMapToObject(
      Map resultMap) {
    ZIMGroupFullInfo groupInfo =
        cnvZIMGroupFullInfoMapToObject(resultMap['groupInfo'])!;
    return ZIMGroupInfoQueriedResult(groupInfo: groupInfo);
  }

  static ZIMGroupAttributesOperatedResult
      cnvZIMGroupAttributesOperatedResultMapToObject(Map resultMap) {
    return ZIMGroupAttributesOperatedResult(
        groupID: resultMap['groupID'],
        errorKeys: (resultMap['errorKeys'] as List).cast<String>());
  }

  static ZIMGroupAttributesQueriedResult
      cnvZIMGroupAttributesQueriedResultMapToObject(Map resultMap) {
    return ZIMGroupAttributesQueriedResult(
        groupID: resultMap['groupID'],
        groupAttributes:
            (resultMap['groupAttributes'] as Map).cast<String, String>());
  }

  static ZIMGroupMemberRoleUpdatedResult
      cnvZIMGroupMemberRoleUpdatedResultMapToObject(Map resultMap) {
    return ZIMGroupMemberRoleUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'],
        role: resultMap['role']);
  }

  static ZIMGroupMemberNicknameUpdatedResult
      cnvZIMGroupMemberNicknameUpdatedResultMapToObject(Map resultMap) {
    return ZIMGroupMemberNicknameUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'],
        nickname: resultMap['nickname']);
  }

  static ZIMGroupMemberInfo cnvZIMGroupMemberInfoMapToObject(
      Map memberInfoMap) {
    ZIMGroupMemberInfo groupMemberInfo = ZIMGroupMemberInfo();
    groupMemberInfo.userID = memberInfoMap['userID'];
    if (memberInfoMap['userName'] == null) {
      groupMemberInfo.userName = '';
    } else {
      groupMemberInfo.userName = memberInfoMap['userName'];
    }

    groupMemberInfo.memberRole = memberInfoMap['memberRole'];
    groupMemberInfo.memberNickname = memberInfoMap['memberNickname'];
    return groupMemberInfo;
  }

  static List<ZIMGroupMemberInfo> cnvBasicListToZIMGroupMemberInfoList(
      List basicList) {
    List<ZIMGroupMemberInfo> userList = [];
    for (Map memberInfoMap in basicList) {
      userList.add(cnvZIMGroupMemberInfoMapToObject(memberInfoMap));
    }
    return userList;
  }

  static ZIMGroupMemberInfoQueriedResult
      cnvZIMGroupMemberInfoQueriedResultMapToObject(Map resultMap) {
    ZIMGroupMemberInfo userInfo =
        cnvZIMGroupMemberInfoMapToObject(resultMap['userInfo']);
    return ZIMGroupMemberInfoQueriedResult(
        groupID: resultMap['groupID'], userInfo: userInfo);
  }

  static ZIMGroupMemberCountQueriedResult
      cnvZIMGroupMemberCountQueriedResultMapToObject(Map resultMap) {
    return ZIMGroupMemberCountQueriedResult(
        groupID: resultMap['groupID'], count: resultMap['count']);
  }

  static ZIMGroup cnvZIMGroupMapToObject(Map resultMap) {
    ZIMGroup group = ZIMGroup();
    group.notificationStatus = ZIMGroupMessageNotificationStatusEventExtension
        .mapValue[resultMap['notificationStatus']]!;
    group.baseInfo = cnvZIMGroupInfoMapToObject(resultMap['baseInfo']);
    return group;
  }

  static List<ZIMGroup> cnvBasicListToZIMGroupList(List basicGroupList) {
    List<ZIMGroup> groupList = [];
    for (Map groupMap in basicGroupList) {
      groupList.add(cnvZIMGroupMapToObject(groupMap));
    }
    return groupList;
  }

  static ZIMGroupListQueriedResult cnvZIMGroupListQueriedResultMapToObject(
      Map resultMap) {
    List<ZIMGroup> groupList =
        cnvBasicListToZIMGroupList(resultMap['groupList']);
    return ZIMGroupListQueriedResult(groupList: groupList);
  }

  static Map cnvZIMGroupMemberQueryConfigObjectToMap(
      ZIMGroupMemberQueryConfig config) {
    Map configMap = {};
    configMap['count'] = config.count;
    configMap['nextFlag'] = config.nextFlag;
    return configMap;
  }

  static ZIMGroupMemberListQueriedResult
      cnvZIMGroupMemberListQueriedResultMapToResult(Map resultMap) {
    List<ZIMGroupMemberInfo> userList =
        cnvBasicListToZIMGroupMemberInfoList(resultMap['userList']);

    return ZIMGroupMemberListQueriedResult(
        groupID: resultMap['groupID'],
        userList: userList,
        nextFlag: resultMap['nextFlag']);
  }

  static ZIMGroupOperatedInfo cnvZIMGroupOperatedInfoMapToObject(
      Map resultMap) {
    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(
        operatedUserInfo:
            cnvZIMGroupMemberInfoMapToObject(resultMap['operatedUserInfo']));
    return info;
  }

  static ZIMGroupAttributesUpdateInfo
      cnvZIMGroupAttributesUpdateInfoMapToObject(Map infoMap) {
    ZIMGroupAttributesUpdateInfo info = ZIMGroupAttributesUpdateInfo();
    info.action =
        ZIMGroupAttributesUpdateActionExtension.mapValue[infoMap['action']]!;
    info.groupAttributes =
        (infoMap['groupAttributes'] as Map).cast<String, String>();
    return info;
  }

  static List<ZIMGroupAttributesUpdateInfo>
      cnvBasicListToZIMGroupAttributesUpdateInfoList(List basicList) {
    List<ZIMGroupAttributesUpdateInfo> infoList = [];
    for (Map infoMap in basicList) {
      infoList.add(cnvZIMGroupAttributesUpdateInfoMapToObject(infoMap));
    }
    return infoList;
  }

  static Map cnvZIMCallInviteConfigObjectToMap(ZIMCallInviteConfig config) {
    Map configMap = {};
    configMap['timeout'] = config.timeout;
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallUserInfo cnvZIMCallUserInfoMapToObject(Map infoMap) {
    ZIMCallUserInfo userInfo = ZIMCallUserInfo();
    userInfo.userID = infoMap['userID'];
    userInfo.state = ZIMCallUserStateExtension.mapValue[infoMap['state']]!;
    return userInfo;
  }

  static List<ZIMCallUserInfo> cnvBasicToZIMCallUserInfoList(List basicList) {
    List<ZIMCallUserInfo> callUserInfoList = [];
    for (Map infoMap in basicList) {
      callUserInfoList.add(cnvZIMCallUserInfoMapToObject(infoMap));
    }
    return callUserInfoList;
  }

  static ZIMCallInvitationSentInfo cnvZIMCallInvitationSentInfoMapToObject(
      Map infoMap) {
    ZIMCallInvitationSentInfo info = ZIMCallInvitationSentInfo();
    info.timeout = infoMap['timeout'];
    info.errorInvitees =
        cnvBasicToZIMCallUserInfoList(infoMap['errorInvitees']);
    return info;
  }

  static ZIMCallInvitationSentResult cnvZIMCallInvitationSentResultMapToObject(
      Map resultMap) {
    ZIMCallInvitationSentInfo info =
        ZIMConverter.cnvZIMCallInvitationSentInfoMapToObject(resultMap['info']);
    return ZIMCallInvitationSentResult(callID: resultMap['callID'], info: info);
  }

  static Map cnvZIMCallCancelConfigObjectToMap(ZIMCallCancelConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallCancelSentResult cnvZIMCallCancelSentResultMapToObject(
      Map resultMap) {
    return ZIMCallCancelSentResult(
        callID: resultMap['callID'],
        errorInvitees: (resultMap['errorInvitees'] as List).cast<String>());
  }

  static Map cnvZIMCallAcceptConfigObjectToMap(ZIMCallAcceptConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallAcceptanceSentResult cnvZIMCallAcceptanceSentResultMapToObject(
      Map resultMap) {
    return ZIMCallAcceptanceSentResult(callID: resultMap['callID']);
  }

  static Map cnvZIMCallRejectConfigObjectToMap(ZIMCallRejectConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallRejectionSentResult cnvZIMCallRejectionSentResultMapToObject(
      Map resultMap) {
    return ZIMCallRejectionSentResult(callID: resultMap['callID']);
  }

  static ZIMCallInvitationReceivedInfo
      cnvZIMCallInvitationReceivedInfoMapToObject(Map infoMap) {
    ZIMCallInvitationReceivedInfo info = ZIMCallInvitationReceivedInfo();
    info.timeout = infoMap['timeout'];
    info.inviter = infoMap['inviter'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationCancelledInfo
      cnvZIMCallInvitationCancelledInfoMapToObject(Map infoMap) {
    ZIMCallInvitationCancelledInfo info = ZIMCallInvitationCancelledInfo();
    info.inviter = infoMap['inviter'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationAcceptedInfo
      cnvZIMCallInvitationAcceptedInfoMapToObject(Map infoMap) {
    ZIMCallInvitationAcceptedInfo info = ZIMCallInvitationAcceptedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationRejectedInfo
      cnvZIMCallInvitationRejectedInfoMapToObject(Map infoMap) {
    ZIMCallInvitationRejectedInfo info = ZIMCallInvitationRejectedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMMediaDownloadedResult cnvZIMMediaDownloadedResultMapToObject(
      Map resultMap) {
    return ZIMMediaDownloadedResult(
        message: cnvZIMMessageMapToObject(resultMap['message']));
  }
}
