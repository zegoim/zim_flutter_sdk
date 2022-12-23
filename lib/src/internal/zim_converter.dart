import 'package:zego_zim/src/internal/zim_common_data.dart';

import '../zim_defines.dart';
import 'zim_defines_extension.dart';

//MARK: Tools
class ZIMConverter {
  static ZIMTokenRenewedResult oTokenRenewedResult(Map resultMap) {
    String token = resultMap['token'];

    return ZIMTokenRenewedResult(token: token);
  }

  static ZIMUsersInfoQueriedResult oZIMUsersInfoQueriedResult(Map resultMap) {
    List userListBasic = resultMap['userList'];
    List errorUserListBasic = resultMap['errorUserList'];

    List<ZIMUserFullInfo> userList = [];
    for (Map userFullInfoMap in userListBasic) {
      userList.add(oZIMUserFullInfo(userFullInfoMap));
    }

    List<ZIMErrorUserInfo> errorUserList = [];
    for (Map errorUserInfoBasic in errorUserListBasic) {
      errorUserList.add(oZIMErrorUserInfo(errorUserInfoBasic));
    }

    return ZIMUsersInfoQueriedResult(
        userList: userList, errorUserList: errorUserList);
  }

  static ZIMUserFullInfo oZIMUserFullInfo(Map userFullInfoBasicMap) {
    ZIMUserFullInfo userFullInfo = ZIMUserFullInfo();
    userFullInfo.baseInfo = oZIMUserInfo(userFullInfoBasicMap['baseInfo']);
    userFullInfo.extendedData = userFullInfoBasicMap['extendedData'];
    userFullInfo.userAvatarUrl = userFullInfoBasicMap['userAvatarUrl'];
    return userFullInfo;
  }

  static ZIMUserInfo oZIMUserInfo(Map userInfoBasicMap) {
    ZIMUserInfo userInfo = ZIMUserInfo();
    userInfo.userID = userInfoBasicMap['userID'];
    userInfo.userName = userInfoBasicMap['userName'];
    return userInfo;
  }

  static ZIMErrorUserInfo oZIMErrorUserInfo(Map errorUserInfoBasicMap) {
    ZIMErrorUserInfo errorUserInfo = ZIMErrorUserInfo();
    errorUserInfo.userID = errorUserInfoBasicMap['userID'];
    errorUserInfo.reason = errorUserInfoBasicMap['reason'];
    return errorUserInfo;
  }

  static ZIMUserExtendedDataUpdatedResult oZIMUserExtendedDataUpdatedResult(
      Map resultMap) {
    return ZIMUserExtendedDataUpdatedResult(
        extendedData: resultMap['extendedData']);
  }

  static ZIMUserNameUpdatedResult oZIMUserNameUpdatedResult(Map resultMap) {
    return ZIMUserNameUpdatedResult(userName: resultMap['userName']);
  }

  static List<ZIMErrorUserInfo> oZIMErrorUserInfoList(List basicList) {
    List<ZIMErrorUserInfo> errorUserInfoList = [];
    for (Map errorUserInfoMap in basicList) {
      ZIMErrorUserInfo errorUserInfo = oZIMErrorUserInfo(errorUserInfoMap);
      errorUserInfoList.add(errorUserInfo);
    }
    return errorUserInfoList;
  }

  static Map mZIMConversationQueryConfig(ZIMConversationQueryConfig config) {
    Map queryConfigMap = {};
    queryConfigMap['count'] = config.count;
    queryConfigMap['nextConversation'] =
        mZIMConversation(config.nextConversation);
    return queryConfigMap;
  }

  static Map? mZIMConversation(ZIMConversation? conversation) {
    if (conversation == null) return null;
    Map conversationMap = {};
    conversationMap['conversationID'] = conversation.conversationID;
    conversationMap['conversationName'] = conversation.conversationName;
    conversationMap['conversationAvatarUrl'] =
        conversation.conversationAvatarUrl;
    conversationMap['type'] =
        ZIMConversationTypeExtension.valueMap[conversation.type];
    conversationMap['notificationStatus'] =
        ZIMConversationNotificationStatusExtension
            .valueMap[conversation.notificationStatus];
    conversationMap['unreadMessageCount'] = conversation.unreadMessageCount;
    conversationMap['orderKey'] = conversation.orderKey;
    if (conversation.lastMessage != null) {
      conversationMap['lastMessage'] = mZIMMessage(conversation.lastMessage!);
    }
    return conversationMap;
  }

  static ZIMConversation oZIMConversation(Map resultMap) {
    ZIMConversation conversation = ZIMConversation();
    conversation.conversationID = resultMap['conversationID'];
    conversation.conversationName = resultMap['conversationName'];
    conversation.conversationAvatarUrl = resultMap['conversationAvatarUrl'];
    conversation.type =
        ZIMConversationTypeExtension.mapValue[resultMap['type']]!;
    conversation.unreadMessageCount = resultMap['unreadMessageCount'];
    conversation.orderKey = resultMap['orderKey'];
    if (resultMap['lastMessage'] != null) {
      conversation.lastMessage = oZIMMessage(resultMap['lastMessage']);
    }
    return conversation;
  }

  static Map mZIMMessage(ZIMMessage message) {
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
    messageMap['isUserInserted'] = message.isUserInserted;
    messageMap['receiptStatus'] =
        ZIMMessageReceiptStatusExtension.valueMap[message.receiptStatus];
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
        messageMap['originalImageHeight'] = message.originalImageHeight;
        messageMap['originalImageWidth'] = message.originalImageWidth;
        messageMap['largeImageHeight'] = message.largeImageHeight;
        messageMap['largeImageWidth'] = message.largeImageWidth;
        messageMap['thumbnailHeight'] = message.thumbnailHeight;
        messageMap['thumbnailWidth'] = message.thumbnailWidth;
        break;
      case ZIMMessageType.video:
        message as ZIMVideoMessage;
        messageMap['videoDuration'] = message.videoDuration;
        messageMap['videoFirstFrameDownloadUrl'] =
            message.videoFirstFrameDownloadUrl;
        messageMap['videoFirstFrameLocalPath'] =
            message.videoFirstFrameLocalPath;
        messageMap['videoFirstFrameHeight'] = message.videoFirstFrameHeight;
        messageMap['videoFirstFrameWidth'] = message.videoFirstFrameWidth;
        break;
      case ZIMMessageType.system:
        message as ZIMSystemMessage;
        messageMap['message'] = message.message;
        break;
      case ZIMMessageType.revoke:
        message as ZIMRevokeMessage;
        messageMap['revokeType'] =
            ZIMRevokeTypeExtension.valueMap[message.revokeType];
        messageMap['revokeTimestamp'] = message.revokeTimestamp;
        messageMap['originalMessageType'] =
            ZIMMessageTypeExtension.valueMap[message.originalMessageType];
        messageMap['revokeStatus'] =
            ZIMMessageRevokeStatusExtension.valueMap[message.revokeStatus];
        messageMap['operatedUserID'] = message.operatedUserID;
        messageMap['originalTextMessageContent'] =
            message.originalTextMessageContent;
        messageMap['revokeExtendedData'] = message.revokeExtendedData;
        break;
      default:
        break;
    }
    return messageMap;
  }

  static ZIMMessage oZIMMessage(Map resultMap, [int? messageID]) {
    ZIMMessageType msgType =
        ZIMMessageTypeExtension.mapValue[resultMap['type']]!;
    ZIMMessage? message =
        messageID == null ? null : ZIMCommonData.messsageMap[messageID];
    switch (msgType) {
      case ZIMMessageType.unknown:
        message ??= ZIMMessage();
        break;
      case ZIMMessageType.text:
        message ??= ZIMTextMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.command:
        message ??= ZIMCommandMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.barrage:
        message ??= ZIMBarrageMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.image:
        message ??= ZIMImageMessage(resultMap['fileLocalPath'] ?? "");
        message as ZIMImageMessage;
        message.thumbnailDownloadUrl = resultMap['thumbnailDownloadUrl'];
        message.thumbnailLocalPath = resultMap['thumbnailLocalPath'];
        message.largeImageDownloadUrl = resultMap['largeImageDownloadUrl'];
        message.largeImageLocalPath = resultMap['largeImageLocalPath'];
        message.originalImageHeight = resultMap['originalImageHeight'];
        message.originalImageWidth = resultMap['originalImageWidth'];
        message.largeImageHeight = resultMap['largeImageHeight'];
        message.largeImageWidth = resultMap['largeImageWidth'];
        message.thumbnailHeight = resultMap['thumbnailHeight'];
        message.thumbnailWidth = resultMap['thumbnailWidth'];
        break;
      case ZIMMessageType.file:
        message ??= ZIMFileMessage(resultMap['fileLocalPath'] ?? "");
        message as ZIMFileMessage;
        break;
      case ZIMMessageType.audio:
        message ??= ZIMAudioMessage(resultMap['fileLocalPath'] ?? "");
        message as ZIMAudioMessage;
        message.audioDuration = resultMap['audioDuration'];
        break;
      case ZIMMessageType.video:
        message ??= ZIMVideoMessage(resultMap['fileLocalPath'] ?? "");
        message as ZIMVideoMessage;
        message.videoDuration = resultMap['videoDuration'];
        message.videoFirstFrameDownloadUrl =
            resultMap['videoFirstFrameDownloadUrl'];
        message.videoFirstFrameLocalPath =
            resultMap['videoFirstFrameLocalPath'];
        message.videoFirstFrameHeight = resultMap['videoFirstFrameHeight'];
        message.videoFirstFrameWidth = resultMap['videoFirstFrameWidth'];
        break;
      case ZIMMessageType.system:
        message ??= ZIMSystemMessage(message: resultMap['message']);
        break;
      case ZIMMessageType.revoke:
        message ??= ZIMRevokeMessage();
        message as ZIMRevokeMessage;
        message.revokeType =
            ZIMRevokeTypeExtension.mapValue[resultMap['revokeType']]!;
        message.revokeStatus = ZIMMessageRevokeStatusExtension
            .mapValue[resultMap['revokeStatus']]!;
        message.revokeTimestamp = resultMap['revokeTimestamp'];
        message.operatedUserID = resultMap['operatedUserID'];
        message.revokeExtendedData = resultMap['revokeExtendedData'];
        message.originalMessageType =
            ZIMMessageTypeExtension.mapValue[resultMap['originalMessageType']]!;
        message.originalTextMessageContent =
            resultMap['originalTextMessageContent'];
        break;
      default:
        message ??= ZIMMessage();
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
    message.isUserInserted = resultMap['isUserInserted'];
    message.receiptStatus = ZIMMessageReceiptStatusExtension.mapValue[resultMap['receiptStatus']]!;
    if (message is ZIMMediaMessage) {
      message.fileLocalPath = resultMap['fileLocalPath'];
      message.fileDownloadUrl = resultMap['fileDownloadUrl'];
      message.fileUID = resultMap['fileUID'];
      message.fileName = resultMap['fileName'];
      message.fileSize = resultMap['fileSize'];
    }

    return message;
  }

  static List mZIMMessageList(List<ZIMMessage> messageList) {
    List messageBasicList = [];
    for (ZIMMessage message in messageList) {
      messageBasicList.add(mZIMMessage(message));
    }
    return messageBasicList;
  }

  static List<ZIMMessage> oZIMMessageList(List messageBasicList) {
    List<ZIMMessage> messageList = [];
    for (Map messageMap in messageBasicList) {
      messageList.add(oZIMMessage(messageMap));
    }
    return messageList;
  }

  static ZIMConversationListQueriedResult oZIMConversationListQueriedResult(
      Map resultMap) {
    List conversationBasicList = resultMap['conversationList'];
    List<ZIMConversation> conversationList = [];
    for (Map conversationBasicMap in conversationBasicList) {
      conversationList.add(oZIMConversation(conversationBasicMap));
    }
    return ZIMConversationListQueriedResult(conversationList: conversationList);
  }

  static Map mZIMConversationDeleteConfig(ZIMConversationDeleteConfig config) {
    Map configMap = {};
    configMap['isAlsoDeleteServerConversation'] =
        config.isAlsoDeleteServerConversation;
    return configMap;
  }

  static Map mZIMMessageDeleteConfig(ZIMMessageDeleteConfig config) {
    Map map = {};
    map['isAlsoDeleteServerMessage'] = config.isAlsoDeleteServerMessage;
    return map;
  }

  static ZIMConversationUnreadMessageCountClearedResult
      oZIMConversationUnreadMessageCountClearedResult(Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMConversationUnreadMessageCountClearedResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static ZIMConversationNotificationStatusSetResult
      oZIMConversationNotificationStatusSetResult(Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMConversationNotificationStatusSetResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static List<ZIMConversationChangeInfo> oZIMConversationChangeInfoList(
      List conversationChangeInfoBasicList) {
    List<ZIMConversationChangeInfo> conversationChangeInfoList = [];
    for (Map conversationChangeInfoMap in conversationChangeInfoBasicList) {
      conversationChangeInfoList
          .add(oZIMConversationChangeInfo(conversationChangeInfoMap));
    }
    return conversationChangeInfoList;
  }

  static ZIMConversationDeletedResult oZIMConversationDeletedResult(
      Map resultMap) {
    return ZIMConversationDeletedResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!);
  }

  static ZIMConversationChangeInfo oZIMConversationChangeInfo(
      Map conversationChangeInfoMap) {
    ZIMConversationChangeInfo conversationChangeInfo =
        ZIMConversationChangeInfo();
    conversationChangeInfo.event = ZIMConversationEventExtension
        .mapValue[conversationChangeInfoMap['event']]!;

    Map conversationMap = conversationChangeInfoMap['conversation'];
    conversationChangeInfo.conversation = oZIMConversation(conversationMap);
    return conversationChangeInfo;
  }

  static Map mZIMMessageSendConfig(ZIMMessageSendConfig sendConfig) {
    Map sendConfigMap = {};
    sendConfigMap['pushConfig'] = mZIMPushConfig(sendConfig.pushConfig);
    sendConfigMap['priority'] =
        ZIMMessagePriorityExtension.valueMap[sendConfig.priority];
    sendConfigMap['hasReceipt'] = sendConfig.hasReceipt;
    return sendConfigMap;
  }

  static Map? mZIMPushConfig(ZIMPushConfig? pushConfig) {
    if (pushConfig == null) return null;
    Map pushConfigMap = {};
    pushConfigMap['title'] = pushConfig.title;
    pushConfigMap['content'] = pushConfig.content;
    pushConfigMap['payload'] = pushConfig.payload;
    pushConfigMap['resourcesID'] = pushConfig.resourcesID;
    return pushConfigMap;
  }

  static ZIMMessageSentResult oZIMMessageSentResult(Map resultMap) {
    ZIMMessage message =
        oZIMMessage(resultMap['message'], resultMap['messageID']);
    return ZIMMessageSentResult(message: message);
  }

  static Map mZIMMessageQueryConfig(ZIMMessageQueryConfig queryConfig) {
    Map queryConfigMap = {};
    queryConfigMap['count'] = queryConfig.count;
    queryConfigMap['reverse'] = queryConfig.reverse;
    if (queryConfig.nextMessage != null) {
      queryConfigMap['nextMessage'] = mZIMMessage(queryConfig.nextMessage!);
    } else {
      queryConfigMap['nextMessage'] = null;
    }
    return queryConfigMap;
  }

  static ZIMMessageQueriedResult oZIMMessageQueriedResult(Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    List<ZIMMessage> messageList = [];
    for (Map messageMap in resultMap['messageList']) {
      messageList.add(oZIMMessage(messageMap));
    }
    return ZIMMessageQueriedResult(
        conversationID: conversationID,
        conversationType: conversationType,
        messageList: messageList);
  }

  static ZIMMessageDeletedResult oZIMMessageDeletedResult(Map resultMap) {
    String conversationID = resultMap['conversationID'];
    ZIMConversationType conversationType =
        ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
    return ZIMMessageDeletedResult(
        conversationID: conversationID, conversationType: conversationType);
  }

  static Map mZIMRoomInfo(ZIMRoomInfo roomInfo) {
    Map roomInfoMap = {};
    roomInfoMap['roomID'] = roomInfo.roomID;
    roomInfoMap['roomName'] = roomInfo.roomName;

    return roomInfoMap;
  }

  static ZIMRoomInfo oZIMRoomInfo(Map roomInfoMap) {
    ZIMRoomInfo roomInfo = ZIMRoomInfo();
    roomInfo.roomID = roomInfoMap['roomID'];
    roomInfo.roomName = roomInfoMap['roomName'];

    return roomInfo;
  }

  static ZIMRoomFullInfo oZIMRoomFullInfo(Map roomFullInfoMap) {
    ZIMRoomInfo roomInfo = oZIMRoomInfo(roomFullInfoMap['baseInfo']);
    ZIMRoomFullInfo roomFullInfo = ZIMRoomFullInfo(baseInfo: roomInfo);
    return roomFullInfo;
  }

  static ZIMRoomCreatedResult oZIMRoomCreatedResult(Map resultMap) {
    ZIMRoomFullInfo roomInfo = oZIMRoomFullInfo(resultMap['roomInfo']);

    return ZIMRoomCreatedResult(roomInfo: roomInfo);
  }

  static ZIMRoomEnteredResult oZIMRoomEnteredResult(Map resultMap) {
    ZIMRoomFullInfo roomInfo = oZIMRoomFullInfo(resultMap['roomInfo']);

    return ZIMRoomEnteredResult(roomInfo: roomInfo);
  }

  static Map mZIMRoomAdvancedConfig(ZIMRoomAdvancedConfig config) {
    Map configMap = {};
    configMap['roomAttributes'] = config.roomAttributes;
    configMap['roomDestroyDelayTime'] = config.roomDestroyDelayTime;
    return configMap;
  }

  static ZIMRoomJoinedResult oZIMRoomJoinedResult(Map resultMap) {
    return ZIMRoomJoinedResult(
        roomInfo: oZIMRoomFullInfo(resultMap['roomInfo']));
  }

  static ZIMRoomLeftResult oZIMRoomLeftResult(Map resultMap) {
    return ZIMRoomLeftResult(roomID: resultMap['roomID']);
  }

  static Map mZIMRoomMemberQueryConfig(ZIMRoomMemberQueryConfig config) {
    Map configMap = {};
    configMap['nextFlag'] = config.nextFlag;
    configMap['count'] = config.count;
    return configMap;
  }

  static ZIMRoomMemberQueryConfig oZIMRoomMemberQueryConfig(Map configMap) {
    ZIMRoomMemberQueryConfig queryConfig = ZIMRoomMemberQueryConfig();
    queryConfig.count = configMap['count'];
    queryConfig.nextFlag = configMap['nextFlag'];
    return queryConfig;
  }

  static List<ZIMUserInfo> oZIMUserInfoList(List memberListBasic) {
    List<ZIMUserInfo> memberList = [];
    for (Map memberInfoMap in memberListBasic) {
      memberList.add(oZIMUserInfo(memberInfoMap));
    }
    return memberList;
  }

  static ZIMRoomMemberQueriedResult oZIMRoomMemberQueriedResult(Map resultMap) {
    return ZIMRoomMemberQueriedResult(
        roomID: resultMap['roomID'],
        nextFlag: resultMap['nextFlag'],
        memberList: oZIMUserInfoList(resultMap['memberList']));
  }

  static ZIMRoomOnlineMemberCountQueriedResult
      oZIMRoomOnlineMemberCountQueriedResult(Map resultMap) {
    return ZIMRoomOnlineMemberCountQueriedResult(
        roomID: resultMap['roomID'], count: resultMap['count']);
  }

  static Map? mZIMRoomAttributesSetConfig(ZIMRoomAttributesSetConfig? config) {
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
      oZIMRoomAttributesOperatedCallResult(Map resultMap) {
    return ZIMRoomAttributesOperatedCallResult(
        roomID: resultMap['roomID'],
        errorKeys: (resultMap['errorKeys'] as List).cast<String>());
  }

  static Map? mZIMRoomAttributesDeleteConfig(
      ZIMRoomAttributesDeleteConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['isForce'] = config.isForce;
    return configMap;
  }

  static Map? mZIMRoomAttributesBatchOperationConfig(
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

  static ZIMRoomOperatedInfo oZIMRoomOperatedInfo(Map infoMap) {
    ZIMRoomOperatedInfo operatedInfo = ZIMRoomOperatedInfo();
    operatedInfo.userID = infoMap['userID'];
    return operatedInfo;
  }

  static ZIMRoomAttributesBatchOperatedResult
      oZIMRoomAttributesBatchOperatedResult(Map resultMap) {
    return ZIMRoomAttributesBatchOperatedResult(roomID: resultMap['roomID']);
  }

  static ZIMRoomAttributesQueriedResult oZIMRoomAttributesQueriedResult(
      Map resultMap) {
    Map roomAttributes = resultMap['roomAttributes'];

    return ZIMRoomAttributesQueriedResult(
        roomID: resultMap['roomID'],
        roomAttributes: roomAttributes.cast<String, String>());
  }

  static ZIMRoomAttributesUpdateInfo oZIMRoomAttributesUpdateInfo(Map infoMap) {
    return ZIMRoomAttributesUpdateInfo(
        action:
            ZIMRoomAttributesUpdateActionExtension.mapValue[infoMap['action']]!,
        roomAttributes:
            (infoMap['roomAttributes'] as Map).cast<String, String>());
  }

  static List<ZIMRoomAttributesUpdateInfo> oZIMRoomAttributesUpdateInfoList(
      List infoBasicList) {
    List<ZIMRoomAttributesUpdateInfo> infoList = [];
    for (Map infoMap in infoBasicList) {
      infoList.add(oZIMRoomAttributesUpdateInfo(infoMap));
    }
    return infoList;
  }

  static ZIMRoomMemberAttributesUpdateInfo oZIMRoomMemberAttributesUpdateInfo(
      Map map) {
    ZIMRoomMemberAttributesUpdateInfo updateInfo =
        ZIMRoomMemberAttributesUpdateInfo();
    updateInfo.attributesInfo =
        oZIMRoomMemberAttributesInfo(map['attributesInfo']);
    return updateInfo;
  }

  static Map? mZIMGroupInfo(ZIMGroupInfo? groupInfo) {
    if (groupInfo == null) {
      return null;
    }
    Map groupInfoMap = {};
    groupInfoMap['groupID'] = groupInfo.groupID;
    groupInfoMap['groupName'] = groupInfo.groupName;
    groupInfoMap['groupAvatarUrl'] = groupInfo.groupAvatarUrl;
    return groupInfoMap;
  }

  static ZIMGroupInfo? oZIMGroupInfo(Map? groupInfoMap) {
    if (groupInfoMap == null) {
      return null;
    }
    ZIMGroupInfo groupInfo = ZIMGroupInfo();
    groupInfo.groupID = groupInfoMap['groupID'];
    groupInfo.groupName = groupInfoMap['groupName'];
    groupInfo.groupAvatarUrl = groupInfoMap['groupAvatarUrl'];
    return groupInfo;
  }

  static ZIMGroupFullInfo? oZIMGroupFullInfo(Map? groupFullInfoMap) {
    if (groupFullInfoMap == null) {
      return null;
    }
    ZIMGroupFullInfo groupFullInfo = ZIMGroupFullInfo(
        baseInfo: oZIMGroupInfo(groupFullInfoMap['baseInfo'])!);
    groupFullInfo.groupNotice = groupFullInfoMap['groupNotice'];
    groupFullInfo.groupAttributes =
        (groupFullInfoMap['groupAttributes'] as Map).cast<String, String>();
    return groupFullInfo;
  }

  static Map? mZIMGroupAdvancedConfig(ZIMGroupAdvancedConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['groupNotice'] = config.groupNotice;
    configMap['groupAttributes'] = config.groupAttributes;
    return configMap;
  }

  static ZIMGroupCreatedResult oZIMGroupCreatedResult(Map resultMap) {
    ZIMGroupFullInfo groupInfo = oZIMGroupFullInfo(resultMap['groupInfo'])!;
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList']);
    List<ZIMErrorUserInfo> errorUserList =
        oZIMErrorUserInfoList(resultMap['errorUserList']);
    ZIMGroupCreatedResult result = ZIMGroupCreatedResult(
        groupInfo: groupInfo, userList: userList, errorUserList: errorUserList);
    return result;
  }

  static ZIMGroupDismissedResult oZIMGroupDismissedResult(Map resultMap) {
    return ZIMGroupDismissedResult(groupID: resultMap['groupID']);
  }

  static ZIMGroupJoinedResult oZIMGroupJoinedResult(Map resultMap) {
    ZIMGroupFullInfo groupInfo = oZIMGroupFullInfo(resultMap['groupInfo'])!;
    return ZIMGroupJoinedResult(groupInfo: groupInfo);
  }

  static ZIMGroupLeftResult oZIMGroupLeftResult(Map resultMap) {
    return ZIMGroupLeftResult(groupID: resultMap['groupID']);
  }

  static ZIMGroupUsersInvitedResult oZIMGroupUsersInvitedResult(Map resultMap) {
    List<ZIMErrorUserInfo> errorUserList =
        oZIMErrorUserInfoList(resultMap['errorUserList']);
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList']);
    return ZIMGroupUsersInvitedResult(
        errorUserList: errorUserList,
        groupID: resultMap['groupID'],
        userList: userList);
  }

  static ZIMGroupMemberKickedResult oZIMGroupMemberKickedResult(Map resultMap) {
    List<ZIMErrorUserInfo> errorUserList =
        oZIMErrorUserInfoList(resultMap['errorUserList']);
    return ZIMGroupMemberKickedResult(
        groupID: resultMap['groupID'],
        kickedUserIDList:
            (resultMap['kickedUserIDList'] as List).cast<String>(),
        errorUserList: errorUserList);
  }

  static ZIMGroupOwnerTransferredResult oZIMGroupOwnerTransferredResult(
      Map resultMap) {
    return ZIMGroupOwnerTransferredResult(
        groupID: resultMap['groupID'], toUserID: resultMap['toUserID']);
  }

  static ZIMGroupNameUpdatedResult oZIMGroupNameUpdatedResult(Map resultMap) {
    return ZIMGroupNameUpdatedResult(
        groupID: resultMap['groupID'], groupName: resultMap['groupName']);
  }

  static ZIMGroupNoticeUpdatedResult oZIMGroupNoticeUpdatedResult(
      Map resultMap) {
    return ZIMGroupNoticeUpdatedResult(
        groupID: resultMap['groupID'], groupNotice: resultMap['groupNotice']);
  }

  static ZIMGroupInfoQueriedResult oZIMGroupInfoQueriedResult(Map resultMap) {
    ZIMGroupFullInfo groupInfo = oZIMGroupFullInfo(resultMap['groupInfo'])!;
    return ZIMGroupInfoQueriedResult(groupInfo: groupInfo);
  }

  static ZIMGroupAttributesOperatedResult oZIMGroupAttributesOperatedResult(
      Map resultMap) {
    return ZIMGroupAttributesOperatedResult(
        groupID: resultMap['groupID'],
        errorKeys: (resultMap['errorKeys'] as List).cast<String>());
  }

  static ZIMGroupAttributesQueriedResult oZIMGroupAttributesQueriedResult(
      Map resultMap) {
    return ZIMGroupAttributesQueriedResult(
        groupID: resultMap['groupID'],
        groupAttributes:
            (resultMap['groupAttributes'] as Map).cast<String, String>());
  }

  static ZIMGroupMemberRoleUpdatedResult oZIMGroupMemberRoleUpdatedResult(
      Map resultMap) {
    return ZIMGroupMemberRoleUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'],
        role: resultMap['role']);
  }

  static ZIMGroupMemberNicknameUpdatedResult
      oZIMGroupMemberNicknameUpdatedResult(Map resultMap) {
    return ZIMGroupMemberNicknameUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'],
        nickname: resultMap['nickname']);
  }

  static ZIMGroupMemberInfo oZIMGroupMemberInfo(Map memberInfoMap) {
    ZIMGroupMemberInfo groupMemberInfo = ZIMGroupMemberInfo();
    groupMemberInfo.userID = memberInfoMap['userID'];
    if (memberInfoMap['userName'] == null) {
      groupMemberInfo.userName = '';
    } else {
      groupMemberInfo.userName = memberInfoMap['userName'];
    }

    groupMemberInfo.memberRole = memberInfoMap['memberRole'];
    groupMemberInfo.memberNickname = memberInfoMap['memberNickname'];
    groupMemberInfo.memberAvatarUrl = memberInfoMap['memberAvatarUrl'];
    return groupMemberInfo;
  }

  static List<ZIMGroupMemberInfo> oZIMGroupMemberInfoList(List basicList) {
    List<ZIMGroupMemberInfo> userList = [];
    for (Map memberInfoMap in basicList) {
      userList.add(oZIMGroupMemberInfo(memberInfoMap));
    }
    return userList;
  }

  static ZIMGroupMemberInfoQueriedResult oZIMGroupMemberInfoQueriedResult(
      Map resultMap) {
    ZIMGroupMemberInfo userInfo = oZIMGroupMemberInfo(resultMap['userInfo']);
    return ZIMGroupMemberInfoQueriedResult(
        groupID: resultMap['groupID'], userInfo: userInfo);
  }

  static ZIMGroupMemberCountQueriedResult oZIMGroupMemberCountQueriedResult(
      Map resultMap) {
    return ZIMGroupMemberCountQueriedResult(
        groupID: resultMap['groupID'], count: resultMap['count']);
  }

  static ZIMGroup oZIMGroup(Map resultMap) {
    ZIMGroup group = ZIMGroup();
    group.notificationStatus = ZIMGroupMessageNotificationStatusEventExtension
        .mapValue[resultMap['notificationStatus']]!;
    group.baseInfo = oZIMGroupInfo(resultMap['baseInfo']);
    return group;
  }

  static List<ZIMGroup> oZIMGroupList(List basicGroupList) {
    List<ZIMGroup> groupList = [];
    for (Map groupMap in basicGroupList) {
      groupList.add(oZIMGroup(groupMap));
    }
    return groupList;
  }

  static ZIMGroupListQueriedResult oZIMGroupListQueriedResult(Map resultMap) {
    List<ZIMGroup> groupList = oZIMGroupList(resultMap['groupList']);
    return ZIMGroupListQueriedResult(groupList: groupList);
  }

  static Map mZIMGroupMemberQueryConfig(ZIMGroupMemberQueryConfig config) {
    Map configMap = {};
    configMap['count'] = config.count;
    configMap['nextFlag'] = config.nextFlag;
    return configMap;
  }

  static ZIMGroupMemberListQueriedResult oZIMGroupMemberListQueriedResult(
      Map resultMap) {
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList']);

    return ZIMGroupMemberListQueriedResult(
        groupID: resultMap['groupID'],
        userList: userList,
        nextFlag: resultMap['nextFlag']);
  }

  static ZIMGroupOperatedInfo oZIMGroupOperatedInfo(Map resultMap) {
    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(
        operatedUserInfo: oZIMGroupMemberInfo(resultMap['operatedUserInfo']),
        userID: resultMap['userID'],
        userName: resultMap['userName'],
        memberNickname: resultMap['memberNickname'],
        memberRole: resultMap['memberRole']);
    return info;
  }

  static ZIMGroupAttributesUpdateInfo oZIMGroupAttributesUpdateInfo(
      Map infoMap) {
    ZIMGroupAttributesUpdateInfo info = ZIMGroupAttributesUpdateInfo();
    info.action =
        ZIMGroupAttributesUpdateActionExtension.mapValue[infoMap['action']]!;
    info.groupAttributes =
        (infoMap['groupAttributes'] as Map).cast<String, String>();
    return info;
  }

  static List<ZIMGroupAttributesUpdateInfo> oZIMGroupAttributesUpdateInfoList(
      List basicList) {
    List<ZIMGroupAttributesUpdateInfo> infoList = [];
    for (Map infoMap in basicList) {
      infoList.add(oZIMGroupAttributesUpdateInfo(infoMap));
    }
    return infoList;
  }

  static Map mZIMCallInviteConfig(ZIMCallInviteConfig config) {
    Map configMap = {};
    configMap['timeout'] = config.timeout;
    configMap['extendedData'] = config.extendedData;
    configMap['pushConfig'] = mZIMPushConfig(config.pushConfig);
    return configMap;
  }

  static ZIMCallUserInfo oZIMCallUserInfo(Map infoMap) {
    ZIMCallUserInfo userInfo = ZIMCallUserInfo();
    userInfo.userID = infoMap['userID'];
    userInfo.state = ZIMCallUserStateExtension.mapValue[infoMap['state']]!;
    return userInfo;
  }

  static List<ZIMCallUserInfo> oZIMCallUserInfoList(List basicList) {
    List<ZIMCallUserInfo> callUserInfoList = [];
    for (Map infoMap in basicList) {
      callUserInfoList.add(oZIMCallUserInfo(infoMap));
    }
    return callUserInfoList;
  }

  static ZIMCallInvitationSentInfo oZIMCallInvitationSentInfo(Map infoMap) {
    ZIMCallInvitationSentInfo info = ZIMCallInvitationSentInfo();
    info.timeout = infoMap['timeout'];
    info.errorInvitees = oZIMCallUserInfoList(infoMap['errorInvitees']);
    return info;
  }

  static ZIMCallInvitationSentResult oZIMCallInvitationSentResult(
      Map resultMap) {
    ZIMCallInvitationSentInfo info =
        ZIMConverter.oZIMCallInvitationSentInfo(resultMap['info']);
    return ZIMCallInvitationSentResult(callID: resultMap['callID'], info: info);
  }

  static Map mZIMCallCancelConfig(ZIMCallCancelConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallCancelSentResult oZIMCallCancelSentResult(Map resultMap) {
    return ZIMCallCancelSentResult(
        callID: resultMap['callID'],
        errorInvitees: (resultMap['errorInvitees'] as List).cast<String>());
  }

  static Map mZIMCallAcceptConfig(ZIMCallAcceptConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallAcceptanceSentResult oZIMCallAcceptanceSentResult(
      Map resultMap) {
    return ZIMCallAcceptanceSentResult(callID: resultMap['callID']);
  }

  static Map cnvZIMCallRejectConfigObjectToMap(ZIMCallRejectConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallRejectionSentResult oZIMCallRejectionSentResult(Map resultMap) {
    return ZIMCallRejectionSentResult(callID: resultMap['callID']);
  }

  static ZIMCallInvitationReceivedInfo oZIMCallInvitationReceivedInfo(
      Map infoMap) {
    ZIMCallInvitationReceivedInfo info = ZIMCallInvitationReceivedInfo();
    info.timeout = infoMap['timeout'];
    info.inviter = infoMap['inviter'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationCancelledInfo oZIMCallInvitationCancelledInfo(
      Map infoMap) {
    ZIMCallInvitationCancelledInfo info = ZIMCallInvitationCancelledInfo();
    info.inviter = infoMap['inviter'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationAcceptedInfo oZIMCallInvitationAcceptedInfo(
      Map infoMap) {
    ZIMCallInvitationAcceptedInfo info = ZIMCallInvitationAcceptedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMCallInvitationRejectedInfo oZIMCallInvitationRejectedInfo(
      Map infoMap) {
    ZIMCallInvitationRejectedInfo info = ZIMCallInvitationRejectedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'];
    return info;
  }

  static ZIMMediaDownloadedResult oZIMMediaDownloadedResult(Map resultMap) {
    return ZIMMediaDownloadedResult(message: oZIMMessage(resultMap['message']));
  }

  static Map mZIMAppConfig(ZIMAppConfig config) {
    Map configMap = {};
    configMap['appID'] = config.appID;
    configMap['appSign'] = config.appSign;
    return configMap;
  }

  static Map mZIMUserInfoQueryConfig(ZIMUserInfoQueryConfig config) {
    Map configMap = {};
    configMap['isQueryFromServer'] = config.isQueryFromServer;
    return configMap;
  }

  static ZIMUserAvatarUrlUpdatedResult oZIMUserAvatarUrlUpdatedResult(
      Map resultMap) {
    return ZIMUserAvatarUrlUpdatedResult(
        userAvatarUrl: resultMap['userAvatarUrl']);
  }

  static ZIMGroupAvatarUrlUpdatedResult oZIMGroupAvatarUrlUpdatedResult(
      Map resultMap) {
    return ZIMGroupAvatarUrlUpdatedResult(
        groupID: resultMap['groupID'],
        groupAvatarUrl: resultMap['groupAvatarUrl']);
  }

  static Map mZIMRoomMemberAttributesSetConfig(
      ZIMRoomMemberAttributesSetConfig config) {
    Map configMap = {};
    configMap['isDeleteAfterOwnerLeft'] = config.isDeleteAfterOwnerLeft;
    return configMap;
  }

  static ZIMRoomMemberAttributesInfo oZIMRoomMemberAttributesInfo(Map map) {
    ZIMRoomMemberAttributesInfo info = ZIMRoomMemberAttributesInfo();
    info.userID = map['userID'];
    info.attributes = (map['attributes'] as Map).cast<String, String>();
    return info;
  }

  static ZIMRoomMemberAttributesOperatedInfo
      oZIMRoomMemberAttributesOperatedInfo(Map map) {
    ZIMRoomMemberAttributesOperatedInfo info =
        ZIMRoomMemberAttributesOperatedInfo();
    info.errorKeys = (map['errorKeys'] as List).cast<String>();
    info.attributesInfo = oZIMRoomMemberAttributesInfo(map['attributesInfo']);
    return info;
  }

  static ZIMRoomMembersAttributesOperatedResult
      oZIMRoomMembersAttributesOperatedResult(Map resultMap) {
    ZIMRoomMembersAttributesOperatedResult result =
        ZIMRoomMembersAttributesOperatedResult();

    result.roomID = resultMap['roomID'];
    result.errorUserList = (resultMap['errorUserList'] as List).cast<String>();
    result.infos = [];
    for (Map infoMap in resultMap['infos']) {
      ZIMRoomMemberAttributesOperatedInfo operatedInfo =
          oZIMRoomMemberAttributesOperatedInfo(infoMap);
      result.infos.add(operatedInfo);
    }
    return result;
  }

  static Map mZIMRoomMemberAttributesQueryConfig(
      ZIMRoomMemberAttributesQueryConfig config) {
    Map map = {};
    map['count'] = config.count;
    map['nextFlag'] = config.nextFlag;
    return map;
  }

  static ZIMRoomMemberAttributesListQueriedResult
      oZIMRoomMemberAttributesListQueriedResult(Map resultMap) {
    ZIMRoomMemberAttributesListQueriedResult result =
        ZIMRoomMemberAttributesListQueriedResult();
    result.roomID = resultMap['roomID'];
    result.nextFlag = resultMap['nextFlag'];
    result.infos = [];
    for (Map infoMap in resultMap['infos']) {
      ZIMRoomMemberAttributesInfo info = oZIMRoomMemberAttributesInfo(infoMap);
      result.infos.add(info);
    }
    return result;
  }

  static ZIMRoomMembersAttributesQueriedResult
      oZIMRoomMembersAttributesQueriedResult(Map resultMap) {
    ZIMRoomMembersAttributesQueriedResult result =
        ZIMRoomMembersAttributesQueriedResult();
    result.roomID = resultMap['roomID'];
    result.infos = [];
    for (Map infoMap in resultMap['infos']) {
      ZIMRoomMemberAttributesInfo info = oZIMRoomMemberAttributesInfo(infoMap);
      result.infos.add(info);
    }
    return result;
  }

  static ZIMMessageInsertedResult oZIMMessageInsertedResult(Map resultMap) {
    return ZIMMessageInsertedResult(
        message: oZIMMessage(resultMap['message'], resultMap['messageID']));
  }

  static ZIMConversationMessageReceiptReadSentResult
      oZIMConversationMessageReceiptReadSentResult(Map resultMap) {
    return ZIMConversationMessageReceiptReadSentResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!);
  }

  static ZIMMessageReceiptsReadSentResult oZIMMessageReceiptReadSentResult(
      Map resultMap) {
    return ZIMMessageReceiptsReadSentResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!,
        errorMessageIDs: List.from(resultMap['errorMessageIDs']));
  }

  static ZIMMessageReceiptsInfoQueriedResult
      oZIMMessageReceiptsInfoQueriedResult(Map resultMap) {
    List infosBasic = resultMap['infos'];

    List<ZIMMessageReceiptInfo> infos = [];
    for (Map info in infosBasic) {
      infos.add(oZIMMessageReceiptInfo(info));
    }
    return ZIMMessageReceiptsInfoQueriedResult(
        errorMessageIDs: List.from(resultMap['errorMessageIDs']), infos: infos);
  }

  static ZIMMessageReceiptInfo oZIMMessageReceiptInfo(Map infoMap) {
    ZIMMessageReceiptInfo receiptInfo = ZIMMessageReceiptInfo(
        conversationID: infoMap['conversationID'],
        conversationType: ZIMConversationTypeExtension.mapValue[infoMap['conversationType']]!,
        messageID: infoMap['messageID'],
        status: ZIMMessageReceiptStatusExtension.mapValue[infoMap['status']]!,
        readMemberCount: infoMap['readMemberCount'],
        unreadMemberCount: infoMap['unreadMemberCount']);

    return receiptInfo;
  }

  static ZIMGroupMessageReceiptMemberListQueriedResult
      oZIMGroupMessageReceiptMemberListQueriedResult(Map resultMap) {
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList']);

    return ZIMGroupMessageReceiptMemberListQueriedResult(
        groupID: resultMap['groupID'],
        nextFlag: resultMap['nextFlag'],
        userList: userList);
  }

  static ZIMMessageRevokedResult oZIMMessageRevokedResult(Map resultMap) {
    Map messageMap = resultMap['message'];
    ZIMRevokeMessage revokeMessage =
        oZIMMessage(messageMap) as ZIMRevokeMessage;
    return ZIMMessageRevokedResult(message: revokeMessage);
  }

  static Map mZIMGroupMessageReceiptMemberQueryConfig(
      ZIMGroupMessageReceiptMemberQueryConfig config) {
    Map configMap = {};
    configMap['nextFlag'] = config.nextFlag;
    configMap['count'] = config.count;
    return configMap;
  }

  static Map mZIMMessageRevokeConfig(ZIMMessageRevokeConfig config) {
    Map revokeConfig = {};
    revokeConfig['pushConfig'] = mZIMPushConfig(config.pushConfig);
    revokeConfig['revokeExtendedData'] = config.revokeExtendedData;
    return revokeConfig;
  }
}
