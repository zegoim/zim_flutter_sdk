import 'dart:typed_data';

import 'package:zego_zim/src/internal/zim_common_data.dart';
import 'package:zego_zim/src/internal/zim_manager.dart';

import '../zim_defines.dart';
import 'zim_defines_extension.dart';

//MARK: Tools
class ZIMConverter {
  static ZIMTokenRenewedResult oTokenRenewedResult(Map resultMap) {
    String token = resultMap['token'];

    return ZIMTokenRenewedResult(token: token);
  }

  static ZIMUsersInfoQueriedResult oZIMUsersInfoQueriedResult(Map resultMap) {
    List userListBasic = resultMap['userList'] ?? [];
    List errorUserListBasic = resultMap['errorUserList'] ?? [];

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
    userFullInfo.baseInfo = oZIMUserInfo(userFullInfoBasicMap['baseInfo'])!;
    userFullInfo.extendedData = userFullInfoBasicMap['extendedData'] ?? '';
    userFullInfo.userAvatarUrl = userFullInfoBasicMap['userAvatarUrl'] ?? '';
    return userFullInfo;
  }

  static ZIMUserInfo oZIMUserInfo(Map userInfoBasicMap,
      [ZIMUserInfo? userInfo]) {

    String? classType = userInfoBasicMap['classType'];
    switch(classType){
      case 'ZIMGroupMemberSimpleInfo':
        userInfo ??= ZIMGroupMemberSimpleInfo();
        break;
      case 'ZIMGroupMemberInfo':
        userInfo ??= ZIMGroupMemberInfo();
        break;
      case 'ZIMFriendInfo':
        userInfo ??= ZIMFriendInfo();
        break;
      case 'ZIMRoomMemberInfo':
        userInfo ??= ZIMRoomMemberInfo();
        break;
      default:
        userInfo ??= ZIMUserInfo();
        break;
    }
    userInfo.userID = userInfoBasicMap['userID'];
    userInfo.userName = userInfoBasicMap['userName'];
    userInfo.userAvatarUrl = userInfoBasicMap['userAvatarUrl'];

    switch(userInfo.runtimeType){
      case ZIMGroupMemberSimpleInfo:
        userInfo as ZIMGroupMemberSimpleInfo;
        userInfo.memberNickname = userInfoBasicMap['memberNickname'];
        userInfo.memberRole = userInfoBasicMap['memberRole'];
        break;
      case ZIMGroupMemberInfo:
        userInfo as ZIMGroupMemberInfo;
        userInfo.memberNickname = userInfoBasicMap['memberNickname'];
        userInfo.memberRole = userInfoBasicMap['memberRole'];
        userInfo.memberAvatarUrl = userInfoBasicMap['memberAvatarUrl'];
        userInfo.muteExpiredTime = userInfoBasicMap['muteExpiredTime'];
        break;
      case ZIMFriendInfo:
        userInfo as ZIMFriendInfo;
        userInfo.friendAlias = userInfoBasicMap['friendAlias'];
        userInfo.createTime = userInfoBasicMap['createTime'];
        userInfo.wording = userInfoBasicMap['wording'];
        userInfo.friendAttributes =
        Map<String, String>.from(userInfoBasicMap['friendAttributes']);
        break;
      default:
        break;
    }
    return userInfo;
  }




  static ZIMRoomMemberInfo oZIMRoomMemberInfo(Map userInfoBasicMap) {
    ZIMRoomMemberInfo userInfo = ZIMRoomMemberInfo();
    userInfo.userID = userInfoBasicMap['userID'];
    userInfo.userName = userInfoBasicMap['userName'];
    return userInfo;
  }

  static ZIMErrorUserInfo oZIMErrorUserInfo(Map errorUserInfoBasicMap) {
    ZIMErrorUserInfo errorUserInfo = ZIMErrorUserInfo();
    errorUserInfo.userID = errorUserInfoBasicMap['userID'];
    errorUserInfo.reason = errorUserInfoBasicMap['reason'] ?? 0;
    return errorUserInfo;
  }

  static ZIMGroupMemberSimpleInfo oZIMGroupMemberSimpleInfo(Map zimGroupMemberSimpleInfoMap) {
    ZIMGroupMemberSimpleInfo info = ZIMGroupMemberSimpleInfo();
    ZIMGroupMemberSimpleInfo groupMemberSimpleInfo = oZIMUserInfo(zimGroupMemberSimpleInfoMap,info) as ZIMGroupMemberSimpleInfo;
    return groupMemberSimpleInfo;
  }


  static ZIMGroupApplicationInfo oZIMGroupApplicationInfo(Map applicationInfoMap) {
    ZIMGroupApplicationInfo applicationInfo = ZIMGroupApplicationInfo(groupInfo: oZIMGroupInfo(applicationInfoMap['groupInfo'])!, applyUser: oZIMUserInfo(applicationInfoMap['applyUser']));
    applicationInfo.createTime = applicationInfoMap['createTime'];
    applicationInfo.updateTime = applicationInfoMap['updateTime'];
    applicationInfo.state = ZIMGroupApplicationStateExtension.mapValue[applicationInfoMap['state']]!;
    if(applicationInfoMap.containsKey('operatedUser') && applicationInfoMap['operatedUser'] != null){
      applicationInfo.operatedUser = oZIMGroupMemberSimpleInfo(applicationInfoMap['operatedUser']);
    }
    applicationInfo.type = ZIMGroupApplicationTypeExtension.mapValue[applicationInfoMap['type']]!;
    applicationInfo.wording = applicationInfoMap['wording'];
    return applicationInfo;
  }


  static ZIMUserExtendedDataUpdatedResult oZIMUserExtendedDataUpdatedResult(
      Map resultMap) {
    return ZIMUserExtendedDataUpdatedResult(
        extendedData: resultMap['extendedData'] ?? '');
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

  static List<ZIMGroupApplicationInfo> oZIMGroupApplicationInfoList(List applicationInfoList){
    List<ZIMGroupApplicationInfo> groupApplicationInfo = [];
    for (Map applicationInfoMap in applicationInfoList) {
      ZIMGroupApplicationInfo applicationInfo = oZIMGroupApplicationInfo(applicationInfoMap);
      groupApplicationInfo.add(applicationInfo);
    }
    return groupApplicationInfo;
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
    conversationMap['conversationAlias'] = conversation.conversationAlias;
    conversationMap['conversationAvatarUrl'] =
        conversation.conversationAvatarUrl;
    conversationMap['type'] =
        ZIMConversationTypeExtension.valueMap[conversation.type];
    conversationMap['notificationStatus'] =
        ZIMConversationNotificationStatusExtension
            .valueMap[conversation.notificationStatus];
    conversationMap['unreadMessageCount'] = conversation.unreadMessageCount;
    conversationMap['orderKey'] = conversation.orderKey;
    conversationMap['isPinned'] = conversation.isPinned;
    conversationMap['draft'] = conversation.draft;
    conversationMap['conversationAlias'] = conversation.conversationAlias;
    if (conversation.lastMessage != null) {
      conversationMap['lastMessage'] = mZIMMessage(conversation.lastMessage!);
    }
    if (conversation is ZIMGroupConversation){
      conversationMap['mutedExpiredTime'] = conversation.mutedExpiredTime;
      conversationMap['isDisabled'] = conversation.isDisabled;
    }
    conversationMap['marks'] = conversation.marks;
    return conversationMap;
  }

  static ZIMConversation oZIMConversation(Map resultMap) {
    var conversation;
    if(ZIMConversationTypeExtension.mapValue[resultMap['type']] == ZIMConversationType.group){
      conversation = ZIMGroupConversation();
      conversation as ZIMGroupConversation;
      conversation.mutedExpiredTime = resultMap['mutedExpiredTime']??0;
      conversation.isDisabled = resultMap['isDisabled']??false;
    }else{
      conversation = ZIMConversation();
    }
    conversation.type =
        ZIMConversationTypeExtension.mapValue[resultMap['type']]!;
    conversation.conversationID = resultMap['conversationID'];
    conversation.conversationAlias = resultMap['conversationAlias'] ?? '';
    conversation.conversationName = resultMap['conversationName'] ?? '';
    conversation.conversationAvatarUrl =
        resultMap['conversationAvatarUrl'] ?? '';
    conversation.unreadMessageCount = resultMap['unreadMessageCount'];
    conversation.orderKey = resultMap['orderKey'];
    if (resultMap['lastMessage'] != null) {
      conversation.lastMessage = oZIMMessage(resultMap['lastMessage']);
    }
    conversation.notificationStatus = ZIMConversationNotificationStatusExtension.mapValue[resultMap['notificationStatus']]!;
    conversation.isPinned = resultMap['isPinned'];
    for (var value in resultMap['mentionedInfoList']??[]) {
      ZIMMessageMentionedInfo info = ZIMMessageMentionedInfo();
      info.fromUserID = value['fromUserID'];
      info.messageID = value['messageID'];
      info.type = ZIMMessageMentionedTypeExtension.mapValue[value['type']]!;
      info.messageSeq = value['messageSeq'];
      conversation.mentionedInfoList.add(info);
    }
    conversation.draft = resultMap['draft'] ?? '';
    conversation.marks = List<int>.from(resultMap['marks'] ?? []);
    return conversation;
  }

  static ZIMConversationFilterOption oZIMConversationFilterOption(Map map){
    ZIMConversationFilterOption option = ZIMConversationFilterOption();

    option.marks = List<int>.from(map['marks']);
    return option;
  }
  static Map? mZIMConversationFilterOption(ZIMConversationFilterOption? option){
    if(option == null){
      return null;
    }
    Map map = {};
    map['marks'] = option.marks;
    List<int> basicConversationTypes = <int>[];
    for(ZIMConversationType type in option.conversationTypes){
      basicConversationTypes.add(type.value);
    }
    map['conversationTypes'] = basicConversationTypes;
    map['isOnlyUnreadConversation'] = option.isOnlyUnreadConversation;
    return map;
  }

  static ZIMConversationBaseInfo oZIMConversationBaseInfo(Map map){
    ZIMConversationBaseInfo baseInfo = ZIMConversationBaseInfo();
    baseInfo.conversationID = map['conversationID'];
    baseInfo.conversationType = ZIMConversationTypeExtension.getEnum(map['conversationType']);
    return baseInfo;
  }

  static Map mZIMConversationBaseInfo(ZIMConversationBaseInfo info){
    Map map = {};
    map['conversationID'] = info.conversationID;
    map['conversationType'] = info.conversationType.value;
    return map;
  }

  static List mZIMConversationBaseInfoList(List<ZIMConversationBaseInfo> infos){
    List list = [];
    for(ZIMConversationBaseInfo info in infos){
      list.add(mZIMConversationBaseInfo(info));
    }
    return list;
  }

  static List<ZIMConversationBaseInfo> oZIMConversationBaseInfoList(List basicInfos){
    List<ZIMConversationBaseInfo> infoList = [];
    for(Map map in basicInfos){
      infoList.add(oZIMConversationBaseInfo(map));
    }
    return infoList;
  }

  static Map mZIMConversationTotalUnreadCountQueryConfig(ZIMConversationTotalUnreadMessageCountQueryConfig config){
    Map map = {};
    map['marks'] = config.marks;
    List<int> basicConversationTypes = <int>[];
    for(ZIMConversationType type in config.conversationTypes){
      basicConversationTypes.add(type.value);
    }
    map['conversationTypes'] = basicConversationTypes;
    return map;
  }

  static Map mZIMMessage(ZIMMessage message) {
    Map messageMap = {};
    messageMap['type'] = ZIMMessageTypeExtension.valueMap[message.type];
    messageMap['messageID'] = message.messageID;
    messageMap['localMessageID'] = message.localMessageID;
    messageMap['messageSeq'] = message.messageSeq;
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
    messageMap['extendedData'] = message.extendedData;
    messageMap['localExtendedData'] = message.localExtendedData;
    messageMap['isBroadcastMessage'] = message.isBroadcastMessage;
    messageMap['isServerMessage'] = message.isServerMessage;
    messageMap['isMentionAll'] = message.isMentionAll;
    messageMap['mentionedUserIDs'] = message.mentionedUserIds;
    messageMap['cbInnerID'] = message.cbInnerID;
    messageMap['rootRepliedCount'] = message.rootRepliedCount;
    if(message.repliedInfo != null) {
      messageMap['repliedInfo'] = mZIMMessageRepliedInfo(message.repliedInfo!);
    }
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
      case ZIMMessageType.custom:
        message as ZIMCustomMessage;
        messageMap['message'] = message.message;
        messageMap['subType'] = message.subType;
        messageMap['searchedContent'] = message.searchedContent;
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
      case ZIMMessageType.combine:
        message as ZIMCombineMessage;
        messageMap['combineID'] = message.combineID;
        messageMap['title'] = message.title;
        messageMap['summary'] = message.summary;
        List<Map> messageListMap = [];
        for (var element in message.messageList) {
          messageListMap.add(mZIMMessage(element));
        }
        messageMap['messageList'] = messageListMap;
        break;
      case ZIMMessageType.tips:
        message as ZIMTipsMessage;
        break;
      default:
        break;
    }
    return messageMap;
  }

  static ZIMMessage oZIMMessage(Map resultMap, [int? messageID]) {
      ZIMMessageType msgType =
          ZIMMessageTypeExtension.mapValue[resultMap['type']] ?? ZIMMessageType.unknown;
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
          resultMap['message'] = resultMap['message'] is Uint8List ? resultMap['message'] : convertToUint8List(resultMap['message']);
          message ??= ZIMCommandMessage(message: resultMap['message']);
          break;
        case ZIMMessageType.barrage:
          message ??= ZIMBarrageMessage(message: resultMap['message']);
          break;
        case ZIMMessageType.image:
          message ??= ZIMImageMessage(resultMap['fileLocalPath'] ?? '');
          message as ZIMImageMessage;
          message.thumbnailDownloadUrl = resultMap['thumbnailDownloadUrl'] ?? '';
          message.thumbnailLocalPath = resultMap['thumbnailLocalPath'] ?? '';
          message.largeImageDownloadUrl =
              resultMap['largeImageDownloadUrl'] ?? '';
          message.largeImageLocalPath = resultMap['largeImageLocalPath'] ?? '';
          message.originalImageHeight = resultMap['originalImageHeight'] ?? 0;
          message.originalImageWidth = resultMap['originalImageWidth'] ?? 0;
          message.largeImageHeight = resultMap['largeImageHeight'] ?? 0;
          message.largeImageWidth = resultMap['largeImageWidth'] ?? 0;
          message.thumbnailHeight = resultMap['thumbnailHeight'] ?? 0;
          message.thumbnailWidth = resultMap['thumbnailWidth'] ?? 0;
          break;
        case ZIMMessageType.file:
          message ??= ZIMFileMessage(resultMap['fileLocalPath'] ?? '');
          message as ZIMFileMessage;
          break;
        case ZIMMessageType.audio:
          message ??= ZIMAudioMessage(resultMap['fileLocalPath'] ?? '');
          message as ZIMAudioMessage;
          message.audioDuration = resultMap['audioDuration'];
          break;
        case ZIMMessageType.video:
          message ??= ZIMVideoMessage(resultMap['fileLocalPath'] ?? '');
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

        case ZIMMessageType.custom:
          message ??= ZIMCustomMessage(
              message: resultMap['message'], subType: resultMap['subType']);
          message as ZIMCustomMessage;
          message.searchedContent = resultMap['searchedContent'];
          break;
        case ZIMMessageType.revoke:
          message ??= ZIMRevokeMessage();
          message as ZIMRevokeMessage;
          message.revokeType =
              ZIMRevokeTypeExtension.mapValue[resultMap['revokeType']] ?? ZIMRevokeType.unknown;
          message.revokeStatus = ZIMMessageRevokeStatusExtension
              .mapValue[resultMap['revokeStatus']] ?? ZIMMessageRevokeStatus.unknown;
          message.revokeTimestamp = resultMap['revokeTimestamp'];
          message.operatedUserID = resultMap['operatedUserID'];
          message.revokeExtendedData = resultMap['revokeExtendedData'] ?? '';
          message.originalMessageType =
              ZIMMessageTypeExtension.mapValue[resultMap['originalMessageType']] ?? ZIMMessageType.unknown;
          message.originalTextMessageContent =
          resultMap['originalTextMessageContent'];
          break;
        case ZIMMessageType.combine:
          List<ZIMMessage> messageList = [];
          List<Map> messageListMap = List<Map>.from(resultMap['messageList']??[]) ;
          for (var element in messageListMap) {
            messageList.add(oZIMMessage(element));
          }
          message ??= ZIMCombineMessage(title:resultMap['title'], summary: resultMap['summary'], messageList: messageList);
          message as ZIMCombineMessage;
          message.combineID = resultMap['combineID'];
          break;
        case ZIMMessageType.tips:
          message ??= ZIMTipsMessage();
          message as ZIMTipsMessage;
          message.event = ZIMTipsMessageEventExtension.mapValue[resultMap['event']]!;
          if(resultMap['operatedUser'] != null){
            message.operatedUser = oZIMUserInfo(resultMap['operatedUser']);
          }
          message.targetUserList = oZIMUserInfoList(resultMap['targetUserList']);
          if(resultMap['changeInfo'] != null){
            message.changeInfo = oZIMTipsMessageChangeInfo(resultMap['changeInfo']);
          }
          break;
        default:
          message ??= ZIMMessage();
          break;
      }
      message.type = ZIMMessageTypeExtension.mapValue[resultMap['type']] ?? ZIMMessageType.unknown;
      message.messageID = resultMap['messageID'] is String
          ? (resultMap['messageID'] ==""?0:int.parse(resultMap['messageID']))
          : resultMap['messageID'];
      message.localMessageID = resultMap['localMessageID'] is String
          ? int.parse(resultMap['localMessageID'])
          : resultMap['localMessageID'];
      message.messageSeq = resultMap['messageSeq'] ?? 0;
      message.senderUserID = resultMap['senderUserID'];
      message.conversationID = resultMap['conversationID'];
      message.direction =
      ZIMMessageDirectionExtension.mapValue[resultMap['direction']]!;
      message.sentStatus =
      ZIMMessageSentStatusExtension.mapValue[resultMap['sentStatus']]!;
      message.conversationType =
      ZIMConversationTypeExtension.mapValue[resultMap['conversationType']]!;
      message.timestamp = resultMap['timestamp'];
      message.conversationSeq = resultMap['conversationSeq'] ?? 0;
      message.orderKey = resultMap['orderKey'] is int ? resultMap['orderKey'] : 0;
      message.isUserInserted = resultMap['isUserInserted'] is bool
          ? resultMap['isUserInserted']
          : false;
      message.receiptStatus =
      ZIMMessageReceiptStatusExtension.mapValue[resultMap['receiptStatus']]!;
      if (message is ZIMMediaMessage) {
        message.fileLocalPath = resultMap['fileLocalPath'] ?? '';
        message.fileDownloadUrl = resultMap['fileDownloadUrl'] ?? '';
        message.fileUID = resultMap['fileUID'] ?? '';
        message.fileName = resultMap['fileName'] ?? '';
        message.fileSize = resultMap['fileSize'] ?? 0;
      }
      message.extendedData = resultMap['extendedData'] is String ? resultMap['extendedData'] : "";
      if (resultMap['reactions'] != null) {
        message.reactions = oZIMMessageReactionList(resultMap['reactions']);
      }
      message.localExtendedData = resultMap['localExtendedData'] is String ? resultMap['localExtendedData'] : "";
      message.isBroadcastMessage = resultMap['isBroadcastMessage'] is bool ? resultMap['isBroadcastMessage'] : false;
      message.isServerMessage = resultMap['isServerMessage'] is bool ? resultMap['isServerMessage'] : false;
      message.isMentionAll = resultMap['isMentionAll'] is bool ? resultMap['isMentionAll'] : false;
      message.mentionedUserIds =  List<String>.from(resultMap['mentionedUserIDs']??[]);
      message.rootRepliedCount = resultMap['rootRepliedCount'] ?? 0;
      if(resultMap['repliedInfo'] != null) {
        message.repliedInfo = ZIMConverter.oZIMMessageRepliedInfo(resultMap['repliedInfo']);
      }
      if (resultMap['cbInnerID'] != null) {
        message.cbInnerID = resultMap['cbInnerID'];
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

  static ZIMConversationPinnedListQueriedResult
      oZIMConversationPinnedListQueriedResult(Map resultMap) {
    List conversationBasicList = resultMap['conversationList'];
    List<ZIMConversation> conversationList = [];
    for (Map conversationBasicMap in conversationBasicList) {
      conversationList.add(oZIMConversation(conversationBasicMap));
    }
    return ZIMConversationPinnedListQueriedResult(
        conversationList: conversationList);
  }

  static ZIMConversationPinnedStateUpdatedResult
      oZIMConversationPinnedStateUpdatedResult(Map resultMap) {
    return ZIMConversationPinnedStateUpdatedResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!);
  }

  static ZIMConversationQueriedResult oZIMConversationQueriedResult(
      Map resultMap) {
    return ZIMConversationQueriedResult(
        conversation: oZIMConversation(resultMap['conversation']));
  }

  static ZIMConversationDraftSetResult oZIMConversationDraftSetResult(Map resultMap) {
    return ZIMConversationDraftSetResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!);
  }

  static ZIMMessageLocalExtendedDataUpdatedResult oZIMMessageLocalExtendedDataUpdatedResult(Map resultMap) {
    return ZIMMessageLocalExtendedDataUpdatedResult(message: oZIMMessage(resultMap['message']));
  }

  static ZIMMessagesSearchedResult oZIMMessagesSearchedResult(Map resultMap) {
    List<ZIMMessage> messageList = [];
    for (Map messageMap in resultMap['messageList']) {
      messageList.add(oZIMMessage(messageMap));
    }

    ZIMMessage? nextMessage;
    if (resultMap['nextMessage'] != null) {
      nextMessage = oZIMMessage(resultMap['nextMessage']);
    }

    return ZIMMessagesSearchedResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!,
        messageList: messageList,
        nextMessage: nextMessage);
  }

  static ZIMMessagesGlobalSearchedResult oZIMMessagesGlobalSearchedResult(
      Map resultMap) {
    List<ZIMMessage> messageList = [];
    for (Map messageMap in resultMap['messageList']) {
      messageList.add(oZIMMessage(messageMap));
    }

    ZIMMessage? nextMessage;
    if (resultMap['nextMessage'] != null) {
      nextMessage = oZIMMessage(resultMap['nextMessage']);
    }

    return ZIMMessagesGlobalSearchedResult(
        messageList: messageList, nextMessage: nextMessage);
  }

  static ZIMConversationSearchInfo oZIMConversationSearchInfo(Map infoMap) {
    List<ZIMMessage> messageList = [];
    for (Map messageMap in infoMap['messageList']) {
      messageList.add(oZIMMessage(messageMap));
    }

    return ZIMConversationSearchInfo(
        conversationID: infoMap['conversationID'],
        conversationType:
            ZIMConversationTypeExtension.mapValue[infoMap['conversationType']]!,
        totalMessageCount: infoMap['totalMessageCount'],
        messageList: messageList);
  }

  static ZIMConversationsAllDeletedInfo oZIMConversationsAllDeletedInfo(
      Map infoMap) {
    ZIMConversationsAllDeletedInfo info =
        ZIMConversationsAllDeletedInfo(count: infoMap['count']);
    return info;
  }

  static ZIMFileCacheInfo oZIMFileCacheInfo(
      Map infoMap) {
    ZIMFileCacheInfo info =
    ZIMFileCacheInfo(totalFileSize: infoMap['totalFileSize']);
    return info;
  }

  static ZIMConversationsSearchedResult oZIMConversationsSearchedResult(
      Map resultMap) {
    List<ZIMConversationSearchInfo> conversationSearchInfoList = [];
    for (Map infoMap in resultMap['conversationSearchInfoList']) {
      conversationSearchInfoList.add(oZIMConversationSearchInfo(infoMap));
    }

    return ZIMConversationsSearchedResult(
        conversationSearchInfoList: conversationSearchInfoList,
        nextFlag: resultMap['nextFlag']);
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

  static List<ZIMMessageSentStatusChangeInfo> oMessageSentStatusChangeInfoList(
      List messageSentStatusChangeInfoBasicList) {
    List<ZIMMessageSentStatusChangeInfo> messageSentStatusChangeInfoList = [];
    for (Map messageSentStatusChangeInfoMap
        in messageSentStatusChangeInfoBasicList) {
      messageSentStatusChangeInfoList
          .add(oZIMMessageSentStatusChangeInfo(messageSentStatusChangeInfoMap));
    }
    return messageSentStatusChangeInfoList;
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

  static ZIMMessageSentStatusChangeInfo oZIMMessageSentStatusChangeInfo(
      Map messageSentStatusChangeInfoMap) {
    ZIMMessageSentStatusChangeInfo messageSentStatusChangeInfo =
        ZIMMessageSentStatusChangeInfo();
    messageSentStatusChangeInfo.status = ZIMMessageSentStatusExtension
        .mapValue[messageSentStatusChangeInfoMap['status']]!;

    Map messageMap = messageSentStatusChangeInfoMap['message'];
    messageSentStatusChangeInfo.message = oZIMMessage(messageMap);
    messageSentStatusChangeInfo.reason =
        messageSentStatusChangeInfoMap['reason'] is String
            ? messageSentStatusChangeInfoMap['reason']
            : '';
    return messageSentStatusChangeInfo;
  }

  static Map mZIMMessageSendConfig(ZIMMessageSendConfig sendConfig) {
    Map sendConfigMap = {};
    sendConfigMap['pushConfig'] = mZIMPushConfig(sendConfig.pushConfig);
    sendConfigMap['priority'] =
        ZIMMessagePriorityExtension.valueMap[sendConfig.priority];
    sendConfigMap['hasReceipt'] = sendConfig.hasReceipt;
    sendConfigMap['isNotifyMentionedUsers'] = sendConfig.isNotifyMentionedUsers;
    return sendConfigMap;
  }

  static Map? mZIMPushConfig(ZIMPushConfig? pushConfig) {
    if (pushConfig == null) return null;
    Map pushConfigMap = {};
    pushConfigMap['title'] = pushConfig.title;
    pushConfigMap['content'] = pushConfig.content;
    pushConfigMap['payload'] = pushConfig.payload;
    pushConfigMap['resourcesID'] = pushConfig.resourcesID;
    pushConfigMap['enableBadge'] = pushConfig.enableBadge;
    pushConfigMap['badgeIncrement'] = pushConfig.badgeIncrement;
    if (pushConfig.voIPConfig != null) {
      pushConfigMap['voIPConfig'] =
          ZIMConverter.mZIMVoIPConfig(pushConfig.voIPConfig!);
    } else {
      pushConfigMap['voIPConfig'] = null;
    }
    return pushConfigMap;
  }

  static ZIMMessageSentResult oZIMMessageSentResult(Map resultMap) {
    ZIMMessage message = oZIMMessage(resultMap['message']);
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

  static ZIMCallCancelSentResult oZIMCallCancelSentResult(Map resultMap) {
    resultMap['errorInvitees'] = resultMap['errorInvitees'] ?? [];

    return ZIMCallCancelSentResult(
        callID: resultMap['callID'],
        errorInvitees: (resultMap['errorInvitees'] as List).cast<String>());
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
    roomInfo.roomName = roomInfoMap['roomName'] ?? '';

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

  static ZIMRoomAllLeftResult oZIMAllRoomLeftResult(Map resultMap) {
    return ZIMRoomAllLeftResult(roomIDs: List<String>.from(resultMap['roomIDList']));
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
    queryConfig.nextFlag = configMap['nextFlag'] ?? '';
    return queryConfig;
  }

  static List<ZIMUserInfo> oZIMUserInfoList(List memberListBasic) {
    List<ZIMUserInfo> memberList = [];
    for (Map memberInfoMap in memberListBasic) {
      memberList.add(oZIMUserInfo(memberInfoMap));
    }
    return memberList;
  }

  static List<ZIMRoomMemberInfo> oZIMRoomMemberInfoList(List memberListBasic) {
    List<ZIMRoomMemberInfo> memberList = [];
    for (Map memberInfoMap in memberListBasic) {
      memberList.add(oZIMRoomMemberInfo(memberInfoMap));
    }
    return memberList;
  }

  static ZIMRoomMemberQueriedResult oZIMRoomMemberQueriedResult(Map resultMap) {
    return ZIMRoomMemberQueriedResult(
        roomID: resultMap['roomID'],
        nextFlag: resultMap['nextFlag'] ?? '',
        memberList: oZIMUserInfoList(resultMap['memberList'] ?? []));
  }

  static ZIMRoomMembersQueriedResult oZIMRoomMembersQueriedResult(
      Map resultMap) {
    return ZIMRoomMembersQueriedResult(
        roomID: resultMap['roomID'],
        errorUserList: oZIMErrorUserInfoList(resultMap['errorUserList'] ?? []),
        memberList: oZIMRoomMemberInfoList(resultMap['memberList'] ?? []));
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
    resultMap['errorKeys'] = resultMap['errorKeys'] ?? [];
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
    Map roomAttributes = resultMap['roomAttributes'] ?? {};

    return ZIMRoomAttributesQueriedResult(
        roomID: resultMap['roomID'],
        roomAttributes: roomAttributes.cast<String, String>());
  }

  static ZIMRoomAttributesUpdateInfo oZIMRoomAttributesUpdateInfo(Map infoMap) {
    infoMap['roomAttributes'] = infoMap['roomAttributes'] ?? {};
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
    map['attributesInfo'] = map['attributesInfo'] ?? {};
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
    groupInfo.groupName = groupInfoMap['groupName'] ?? '';
    groupInfo.groupAvatarUrl = groupInfoMap['groupAvatarUrl'] ?? '';
    return groupInfo;
  }

  static ZIMGroupFullInfo? oZIMGroupFullInfo(Map? groupFullInfoMap) {
    if (groupFullInfoMap == null) {
      return null;
    }
    groupFullInfoMap['groupAttributes'] =
        groupFullInfoMap['groupAttributes'] ?? {};
    ZIMGroupFullInfo groupFullInfo = ZIMGroupFullInfo(
        baseInfo: oZIMGroupInfo(groupFullInfoMap['baseInfo'])!);
    groupFullInfo.groupNotice = groupFullInfoMap['groupNotice'] ?? '';
    groupFullInfo.groupAttributes =
        (groupFullInfoMap['groupAttributes'] as Map).cast<String, String>();
    groupFullInfo.mutedInfo = ZIMConverter.oZIMGroupMuteInfo(groupFullInfoMap['mutedInfo']);
    groupFullInfo.verifyInfo =  ZIMConverter.oZIMGroupVerifyInfo(groupFullInfoMap['verifyInfo']);
    groupFullInfo.maxMemberCount = groupFullInfoMap['maxMemberCount'];
    groupFullInfo.createTime = groupFullInfoMap['createTime'];
    return groupFullInfo;
  }

  static Map? mZIMGroupAdvancedConfig(ZIMGroupAdvancedConfig? config) {
    if (config == null) {
      return null;
    }
    Map configMap = {};
    configMap['groupNotice'] = config.groupNotice;
    configMap['groupAttributes'] = config.groupAttributes;
    configMap['joinMode'] = ZIMGroupJoinModeExtension.valueMap[config.joinMode];
    configMap['inviteMode'] = ZIMGroupInviteModeExtension.valueMap[config.inviteMode];
    configMap['beInviteMode'] = ZIMGroupBeInviteModeExtension.valueMap[config.beInviteMode];
    configMap['maxMemberCount'] = config.maxMemberCount;
    return configMap;
  }

  static ZIMGroupCreatedResult oZIMGroupCreatedResult(Map resultMap) {
    ZIMGroupFullInfo groupInfo = oZIMGroupFullInfo(resultMap['groupInfo'])!;
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList'] ?? []);
    List<ZIMErrorUserInfo> errorUserList =
        oZIMErrorUserInfoList(resultMap['errorUserList'] ?? []);
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
        oZIMErrorUserInfoList(resultMap['errorUserList'] ?? []);
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList'] ?? []);
    return ZIMGroupUsersInvitedResult(
        errorUserList: errorUserList,
        groupID: resultMap['groupID'],
        userList: userList);
  }

  static ZIMGroupMemberKickedResult oZIMGroupMemberKickedResult(Map resultMap) {
    resultMap['kickedUserIDList'] = resultMap['kickedUserIDList'] ?? [];
    List<ZIMErrorUserInfo> errorUserList =
        oZIMErrorUserInfoList(resultMap['errorUserList'] ?? []);
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
        groupID: resultMap['groupID'], groupName: resultMap['groupName'] ?? '');
  }

  static ZIMGroupNoticeUpdatedResult oZIMGroupNoticeUpdatedResult(
      Map resultMap) {
    return ZIMGroupNoticeUpdatedResult(
        groupID: resultMap['groupID'],
        groupNotice: resultMap['groupNotice'] ?? '');
  }

  static ZIMGroupJoinModeUpdatedResult oZIMGroupJoinModeUpdatedResult(
      Map resultMap) {
    return ZIMGroupJoinModeUpdatedResult(
        groupID: resultMap['groupID'],
        mode: ZIMGroupJoinModeExtension.mapValue[resultMap['mode']]!);
  }

  static ZIMGroupInviteModeUpdatedResult oZIMGroupInviteModeUpdatedResult(
      Map resultMap) {
    return ZIMGroupInviteModeUpdatedResult(
        groupID: resultMap['groupID'],
        mode: ZIMGroupInviteModeExtension.mapValue[resultMap['mode']]!);
  }

  static ZIMGroupBeInviteModeUpdatedResult oZIMGroupBeInviteModeUpdatedResult(
      Map resultMap) {
    return ZIMGroupBeInviteModeUpdatedResult(
        groupID: resultMap['groupID'],
        mode: ZIMGroupBeInviteModeExtension.mapValue[resultMap['mode']]!);
  }

  static ZIMGroupInfoQueriedResult oZIMGroupInfoQueriedResult(Map resultMap) {
    ZIMGroupFullInfo groupInfo = oZIMGroupFullInfo(resultMap['groupInfo'])!;
    return ZIMGroupInfoQueriedResult(groupInfo: groupInfo);
  }

  static ZIMGroupAttributesOperatedResult oZIMGroupAttributesOperatedResult(
      Map resultMap) {
    resultMap['errorKeys'] = resultMap['errorKeys'] ?? [];
    return ZIMGroupAttributesOperatedResult(
        groupID: resultMap['groupID'],
        errorKeys: (resultMap['errorKeys'] as List).cast<String>());
  }

  static ZIMGroupAttributesQueriedResult oZIMGroupAttributesQueriedResult(
      Map resultMap) {
    resultMap['groupAttributes'] = resultMap['groupAttributes'] ?? {};
    return ZIMGroupAttributesQueriedResult(
        groupID: resultMap['groupID'],
        groupAttributes:
            (resultMap['groupAttributes'] as Map).cast<String, String>());
  }

  static ZIMGroupMemberRoleUpdatedResult oZIMGroupMemberRoleUpdatedResult(
      Map resultMap) {
    return ZIMGroupMemberRoleUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'] ?? '',
        role: resultMap['role']);
  }

  static ZIMGroupMemberNicknameUpdatedResult
      oZIMGroupMemberNicknameUpdatedResult(Map resultMap) {
    return ZIMGroupMemberNicknameUpdatedResult(
        groupID: resultMap['groupID'],
        forUserID: resultMap['forUserID'] ?? '',
        nickname: resultMap['nickname'] ?? '');
  }

  static ZIMGroupEnterInfo oZIMGroupEnterInfo(Map? groupEnterInfoMap) {
    if (groupEnterInfoMap == null) return ZIMGroupEnterInfo();
    ZIMGroupEnterInfo groupEnterInfo = ZIMGroupEnterInfo();
    if(groupEnterInfoMap.containsKey('operatedUser') && groupEnterInfoMap['operatedUser'] != null){
      groupEnterInfo.operatedUser  = oZIMGroupMemberSimpleInfo(groupEnterInfoMap['operatedUser']);
    }
    groupEnterInfo.enterTime = groupEnterInfoMap['enterTime'] ?? 0;
    groupEnterInfo.enterType = ZIMGroupEnterTypeExtension.mapValue[groupEnterInfoMap['enterType']]!;
    return groupEnterInfo;
  }

  static ZIMGroupMemberInfo oZIMGroupMemberInfo(Map? memberInfoMap) {
    if (memberInfoMap == null) return ZIMGroupMemberInfo();
    ZIMGroupMemberInfo groupMemberInfo = ZIMGroupMemberInfo();
    groupMemberInfo.userID = memberInfoMap['userID'];
    groupMemberInfo.userName = memberInfoMap['userName'] ?? '';
    groupMemberInfo.userAvatarUrl = memberInfoMap['userAvatarUrl'] ?? '';
    groupMemberInfo.memberRole = memberInfoMap['memberRole'];
    groupMemberInfo.memberNickname = memberInfoMap['memberNickname'] ?? '';
    groupMemberInfo.memberAvatarUrl = memberInfoMap['memberAvatarUrl'] ?? '';
    groupMemberInfo.muteExpiredTime = memberInfoMap['muteExpiredTime'] ??0;
    groupMemberInfo.groupEnterInfo = oZIMGroupEnterInfo(memberInfoMap['groupEnterInfo']);
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

  static ZIMGroupSearchInfo oZIMGroupSearchInfo(Map mapInfo) {
    return ZIMGroupSearchInfo(
        groupInfo: oZIMGroupInfo(mapInfo['groupInfo'])!,
        userList: oZIMGroupMemberInfoList(mapInfo['userList']));
  }

  static ZIMGroupListQueriedResult oZIMGroupListQueriedResult(Map resultMap) {
    List<ZIMGroup> groupList = oZIMGroupList(resultMap['groupList'] ?? []);
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
        nextFlag: resultMap['nextFlag'] ?? 0);
  }

  static ZIMGroupsSearchedResult oZIMGroupsSearchedResult(Map resultMap) {
    List<ZIMGroupSearchInfo> groupSearchInfoList = [];
    resultMap['groupSearchInfoList'] = resultMap['groupSearchInfoList'] ?? [];
    for (Map groupSearchInfoMap in resultMap['groupSearchInfoList']) {
      groupSearchInfoList.add(oZIMGroupSearchInfo(groupSearchInfoMap));
    }

    return ZIMGroupsSearchedResult(
        groupSearchInfoList: groupSearchInfoList,
        nextFlag: resultMap['nextFlag'] ?? 0);
  }

  static ZIMGroupMembersSearchedResult oZIMGroupMembersSearchedResult(
      Map resultMap) {
    return ZIMGroupMembersSearchedResult(
        groupID: resultMap['groupID'],
        userList: oZIMGroupMemberInfoList(resultMap['userList']),
        nextFlag: resultMap['nextFlag']);
  }

  static ZIMGroupOperatedInfo oZIMGroupOperatedInfo(Map resultMap) {
    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(
        operatedUserInfo: oZIMGroupMemberInfo(resultMap['operatedUserInfo']),
        userID: resultMap['userID'],
        userName: resultMap['userName'] ?? '',
        memberNickname: resultMap['memberNickname'] ?? '',
        memberRole: resultMap['memberRole']);
    return info;
  }

  static ZIMGroupAttributesUpdateInfo oZIMGroupAttributesUpdateInfo(
      Map infoMap) {
    infoMap['groupAttributes'] = infoMap['groupAttributes'] ?? {};
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
    configMap['mode'] = ZIMInvitationModeExtension.valueMap[config.mode];
    configMap['pushConfig'] = mZIMPushConfig(config.pushConfig);
    configMap['extendedData'] = config.extendedData;
    configMap['enableNotReceivedCheck'] = config.enableNotReceivedCheck;
    return configMap;
  }

  static ZIMCallUserInfo oZIMCallUserInfo(Map infoMap) {
    ZIMCallUserInfo userInfo = ZIMCallUserInfo();
    userInfo.userID = infoMap['userID'];
    userInfo.state = ZIMCallUserStateExtension.mapValue[infoMap['state']]!;
    userInfo.extendedData = infoMap['extendedData'] ?? '';
    return userInfo;
  }

  static List<ZIMCallUserInfo> oZIMCallUserInfoList(List basicList) {
    List<ZIMCallUserInfo> callUserInfoList = [];
    for (Map infoMap in basicList) {
      callUserInfoList.add(oZIMCallUserInfo(infoMap));
    }
    return callUserInfoList;
  }

  static Map mZIMCallUserInfo(ZIMCallUserInfo userInfo){
    Map map = {};
    map['userID'] = userInfo.userID;
    map['state'] = userInfo.state.value;
    map['extendedData'] = userInfo.extendedData;
    return map;
  }

  static List mZIMCallUserInfoList(List<ZIMCallUserInfo> infoList){
    List list = [];
    for(ZIMCallUserInfo userInfo in infoList){
      list.add(mZIMCallUserInfo(userInfo));
    }
    return list;
  }

  static ZIMCallQuitSentInfo oZIMCallQuitSentInfo(Map infoMap) {
    ZIMCallQuitSentInfo info = ZIMCallQuitSentInfo();
    info.createTime = infoMap['createTime'];
    info.acceptTime = infoMap['acceptTime'];
    info.quitTime = infoMap['quitTime'];
    return info;
  }

  static ZIMCallEndedSentInfo oZIMCallEndSentInfo(Map infoMap) {
    ZIMCallEndedSentInfo info = ZIMCallEndedSentInfo();
    info.endTime = infoMap['endTime'];
    info.createTime = infoMap['createTime'];
    info.acceptTime = infoMap['acceptTime'];
    return info;
  }

  static ZIMCallInvitationSentInfo oZIMCallInvitationSentInfo(Map infoMap) {
    ZIMCallInvitationSentInfo info = ZIMCallInvitationSentInfo();
    info.timeout = infoMap['timeout'];
    info.errorUserList = oZIMErrorUserInfoList(infoMap['errorList'] ?? []);
    info.errorInvitees = oZIMCallUserInfoList(infoMap['errorInvitees'] ?? []);
    return info;
  }

  static ZIMCallingInvitationSentInfo oZIMCallingInvitationSentInfo(
      Map infoMap) {
    ZIMCallingInvitationSentInfo info = ZIMCallingInvitationSentInfo();
    info.errorUserList = oZIMErrorUserInfoList(infoMap['errorInvitees'] ?? []);
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
    configMap['pushConfig'] = ZIMConverter.mZIMPushConfig(config.pushConfig);
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static ZIMCallingInvitationSentResult oZIMCallingInvitationSentResult(
      Map resultMap) {
    ZIMCallingInvitationSentInfo info =
        ZIMConverter.oZIMCallingInvitationSentInfo(resultMap['info']);
    return ZIMCallingInvitationSentResult(
        callID: resultMap['callID'], info: info);
  }

  static ZIMCallInvitationListQueriedResult oZIMCallListQueriedResult(
      Map resultMap) {
    resultMap['callList'] = resultMap['callList'] ?? [];
    List<ZIMCallInfo> callInfoList = [];
    for (Map infoMap in resultMap['callList']) {
      ZIMCallInfo callInfo = oZIMCallInfo(infoMap);
      callInfoList.add(callInfo);
    }

    return ZIMCallInvitationListQueriedResult(
        nextFlag: resultMap['nextFlag'], callList: callInfoList);
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
    info.inviter = infoMap['inviter'];
    info.caller = infoMap['caller'];
    info.extendedData = infoMap['extendedData'] ?? '';
    info.mode = ZIMInvitationModeExtension.mapValue[infoMap['mode']]!;
    info.timeout = infoMap['timeout'];
    info.createTime = infoMap['createTime'];
    info.callUserList = oZIMCallUserInfoList(infoMap['callUserList'] ?? []);
    return info;
  }

  static ZIMCallInvitationCancelledInfo oZIMCallInvitationCancelledInfo(
      Map infoMap) {
    ZIMCallInvitationCancelledInfo info = ZIMCallInvitationCancelledInfo();
    info.inviter = infoMap['inviter'];
    info.extendedData = infoMap['extendedData'] ?? '';
    info.mode = ZIMInvitationModeExtension.mapValue[infoMap['mode']]!;
    return info;
  }

  static ZIMCallInvitationTimeoutInfo oZIMCallInvitationTimeoutInfo(
      Map infoMap) {
    ZIMCallInvitationTimeoutInfo info = ZIMCallInvitationTimeoutInfo();

    info.mode = ZIMInvitationModeExtension.mapValue[infoMap['mode']]!;
    return info;
  }

  static ZIMCallInvitationAcceptedInfo oZIMCallInvitationAcceptedInfo(
      Map infoMap) {
    ZIMCallInvitationAcceptedInfo info = ZIMCallInvitationAcceptedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'] ?? '';
    return info;
  }

  static ZIMCallInvitationRejectedInfo oZIMCallInvitationRejectedInfo(
      Map infoMap) {
    ZIMCallInvitationRejectedInfo info = ZIMCallInvitationRejectedInfo();
    info.invitee = infoMap['invitee'];
    info.extendedData = infoMap['extendedData'] ?? '';
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

  static Map mZIMLoginConfig(ZIMLoginConfig config) {
    Map configMap = {};
    configMap['userName']  = config.userName;
    configMap['token'] = config.token;
    configMap['isOfflineLogin'] = config.isOfflineLogin;
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
        userAvatarUrl: resultMap['userAvatarUrl'] ?? '');
  }

  static ZIMGroupAvatarUrlUpdatedResult oZIMGroupAvatarUrlUpdatedResult(
      Map resultMap) {
    return ZIMGroupAvatarUrlUpdatedResult(
        groupID: resultMap['groupID'],
        groupAvatarUrl: resultMap['groupAvatarUrl'] ?? '');
  }

  static Map mZIMRoomMemberAttributesSetConfig(
      ZIMRoomMemberAttributesSetConfig config) {
    Map configMap = {};
    configMap['isDeleteAfterOwnerLeft'] = config.isDeleteAfterOwnerLeft;
    return configMap;
  }

  static ZIMRoomMemberAttributesInfo oZIMRoomMemberAttributesInfo(Map map) {
    map['attributes'] = map['attributes'] ?? {};
    ZIMRoomMemberAttributesInfo info = ZIMRoomMemberAttributesInfo();
    info.userID = map['userID'];
    info.attributes = (map['attributes'] as Map).cast<String, String>();
    return info;
  }

  static ZIMRoomMemberAttributesOperatedInfo
      oZIMRoomMemberAttributesOperatedInfo(Map map) {
    ZIMRoomMemberAttributesOperatedInfo info =
        ZIMRoomMemberAttributesOperatedInfo();
    map['errorKeys'] = map['errorKeys'] ?? [];
    info.errorKeys = (map['errorKeys'] as List).cast<String>();
    info.attributesInfo = oZIMRoomMemberAttributesInfo(map['attributesInfo']);
    return info;
  }

  static ZIMRoomMembersAttributesOperatedResult
      oZIMRoomMembersAttributesOperatedResult(Map resultMap) {
    ZIMRoomMembersAttributesOperatedResult result =
        ZIMRoomMembersAttributesOperatedResult();
    resultMap['errorUserList'] = resultMap['errorUserList'] ?? [];
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
    result.nextFlag = resultMap['nextFlag'] ?? '';
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
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!);
  }

  static ZIMMessageReceiptsReadSentResult oZIMMessageReceiptReadSentResult(
      Map resultMap) {
    resultMap['errorMessageIDs'] = resultMap['errorMessageIDs'] ?? [];
    return ZIMMessageReceiptsReadSentResult(
        conversationID: resultMap['conversationID'],
        conversationType: ZIMConversationTypeExtension
            .mapValue[resultMap['conversationType']]!,
        errorMessageIDs: List.from(resultMap['errorMessageIDs']));
  }

  static ZIMMessageReceiptsInfoQueriedResult
      oZIMMessageReceiptsInfoQueriedResult(Map resultMap) {
    List infosBasic = resultMap['infos'];

    List<ZIMMessageReceiptInfo> infos = [];
    for (Map info in infosBasic) {
      infos.add(oZIMMessageReceiptInfo(info));
    }
    resultMap['errorMessageIDs'] = resultMap['errorMessageIDs'] ?? [];
    return ZIMMessageReceiptsInfoQueriedResult(
        errorMessageIDs: List.from(resultMap['errorMessageIDs']), infos: infos);
  }

  static ZIMMessageReceiptInfo oZIMMessageReceiptInfo(Map infoMap) {
    ZIMManager.writeLog("Flutter oZIMMessageReceiptInfo:" + infoMap.toString());
    ZIMMessageReceiptInfo receiptInfo = ZIMMessageReceiptInfo(
        conversationID: infoMap['conversationID'],
        conversationType:
            ZIMConversationTypeExtension.mapValue[infoMap['conversationType']]!,
        messageID: infoMap['messageID'],
        status: ZIMMessageReceiptStatusExtension.mapValue[infoMap['status']]!,
        readMemberCount: infoMap['readMemberCount'],
        unreadMemberCount: infoMap['unreadMemberCount'],
        isSelfOperated: infoMap['isSelfOperated']);

    return receiptInfo;
  }

  static ZIMGroupMessageReceiptMemberListQueriedResult
      oZIMGroupMessageReceiptMemberListQueriedResult(Map resultMap) {
    List<ZIMGroupMemberInfo> userList =
        oZIMGroupMemberInfoList(resultMap['userList']);

    return ZIMGroupMessageReceiptMemberListQueriedResult(
        groupID: resultMap['groupID'],
        nextFlag: resultMap['nextFlag'] ?? 0,
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

  static Map mZIMMessageSearchConfig(ZIMMessageSearchConfig config) {
    Map configMap = {};
    if (config.nextMessage != null) {
      configMap['nextMessage'] = mZIMMessage(config.nextMessage!);
    } else {
      configMap['nextMessage'] = null;
    }

    List<int> messageTypeList = [];
    for (ZIMMessageType msgType in config.messageTypes) {
      messageTypeList.add(ZIMMessageTypeExtension.valueMap[msgType]!);
    }

    configMap['count'] = config.count;
    configMap['order'] = ZIMMessageOrderExtension.valueMap[config.order];
    configMap['keywords'] = config.keywords;
    configMap['messageTypes'] = messageTypeList;
    configMap['subMessageTypes'] = config.subMessageTypes;
    configMap['senderUserIDs'] = config.senderUserIDs;
    configMap['startTime'] = config.startTime;
    configMap['endTime'] = config.endTime;

    return configMap;
  }

  static Map mZIMConversationSearchConfig(ZIMConversationSearchConfig config) {
    Map configMap = {};

    List<int> messageTypeList = [];
    for (ZIMMessageType msgType in config.messageTypes) {
      messageTypeList.add(ZIMMessageTypeExtension.valueMap[msgType]!);
    }

    configMap['nextFlag'] = config.nextFlag;
    configMap['totalConversationCount'] = config.totalConversationCount;
    configMap['conversationMessageCount'] = config.conversationMessageCount;
    configMap['keywords'] = config.keywords;
    configMap['messageTypes'] = messageTypeList;
    configMap['subMessageTypes'] = config.subMessageTypes;
    configMap['senderUserIDs'] = config.senderUserIDs;
    configMap['startTime'] = config.startTime;
    configMap['endTime'] = config.endTime;

    return configMap;
  }

  static Map mZIMGroupSearchConfig(ZIMGroupSearchConfig config) {
    Map configMap = {};

    configMap['nextFlag'] = config.nextFlag;
    configMap['count'] = config.count;
    configMap['keywords'] = config.keywords;
    configMap['isAlsoMatchGroupMemberUserName'] =
        config.isAlsoMatchGroupMemberUserName;
    configMap['isAlsoMatchGroupMemberNickname'] =
        config.isAlsoMatchGroupMemberNickname;

    return configMap;
  }

  static Map mZIMGroupMemberSearchConfig(ZIMGroupMemberSearchConfig config) {
    Map configMap = {};

    configMap['nextFlag'] = config.nextFlag;
    configMap['count'] = config.count;
    configMap['keywords'] = config.keywords;
    configMap['isAlsoMatchGroupMemberNickname'] =
        config.isAlsoMatchGroupMemberNickname;

    return configMap;
  }

  static ZIMReactionUserInfo oZIMReactionUserInfo(Map userInfoMap) {
    ZIMReactionUserInfo reactionUserInfo =
        ZIMReactionUserInfo(userID: userInfoMap['userID']);
    return reactionUserInfo;
  }

  static ZIMMessageReaction oZIMMessageReaction(Map reactionMap) {
    List<ZIMReactionUserInfo> userList = oZIMReactionUserInfoList(reactionMap);

    ZIMMessageReaction reaction = ZIMMessageReaction(
      conversationID: reactionMap['conversationID'],
      conversationType: ZIMConversationTypeExtension
          .mapValue[reactionMap['conversationType']]!,
      messageID: reactionMap['messageID'] is String
          ? int.parse(reactionMap['messageID'])
          : reactionMap['messageID'],
      totalCount: reactionMap['totalCount'],
      reactionType: reactionMap['reactionType'],
      isSelfIncluded: reactionMap['isSelfIncluded'],
      userList: userList,
    );

    return reaction;
  }

  static List<ZIMMessageReaction> oZIMMessageReactionList(List infosList) {
    List<ZIMMessageReaction> infos = [];
    for (Map infoMap in infosList) {
      infos.add(oZIMMessageReaction(infoMap));
    }
    return infos;
  }

  static ZIMMessageReactionAddedResult oZIMAddMessageReactionResult(
      Map resultMap) {
    Map reactionMap = resultMap['reaction'];

    ZIMMessageReaction reaction = oZIMMessageReaction(reactionMap);

    return ZIMMessageReactionAddedResult(reaction: reaction);
  }

  static Map mZIMMessageReactionUsersQueryConfig(
      ZIMMessageReactionUsersQueryConfig config) {
    Map queryConfigMap = {};
    queryConfigMap['nextFlag'] = config.nextFlag;
    queryConfigMap['count'] = config.count;
    queryConfigMap['reactionType'] = config.reactionType;
    return queryConfigMap;
  }

  static Map mZIMVoIPConfig(ZIMVoIPConfig config) {
    Map map = {};
    map['iOSVoIPHandleType'] =
        ZIMCXHandleTypeExtension.valueMap[config.iOSVoIPHandleType];
    map['iOSVoIPHandleValue'] = config.iOSVoIPHandleValue;
    map['iOSVoIPHasVideo'] = config.iOSVoIPHasVideo;
    return map;
  }

  static ZIMMessageReactionDeletedResult oZIMDeleteMessageReactionResult(
      Map resultMap) {
    Map reactionMap = resultMap['reaction'];

    ZIMMessageReaction reaction = oZIMMessageReaction(reactionMap);

    return ZIMMessageReactionDeletedResult(reaction: reaction);
  }

  static List<ZIMReactionUserInfo> oZIMReactionUserInfoList(Map resultMap) {
    List userListBasic = resultMap['userList'];
    List<ZIMReactionUserInfo> userList = [];
    for (Map userInfoMap in userListBasic) {
      userList.add(oZIMReactionUserInfo(userInfoMap));
    }
    return userList;
  }

  static ZIMMessageReactionUserListQueriedResult oZIMReactionUsersQueryResult(
      Map resultMap) {
    List<ZIMReactionUserInfo> userList = oZIMReactionUserInfoList(resultMap);
    return ZIMMessageReactionUserListQueriedResult(
        message: oZIMMessage(resultMap['message']),
        reactionType: resultMap['reactionType'],
        userList: userList,
        nextFlag: resultMap['nextFlag'] ?? 0,
        totalCount: resultMap['totalCount']);
  }

  static ZIMCallJoinSentInfo oZIMCallJoinSentInfo(Map resultMap) {
    return ZIMCallJoinSentInfo(
        extendedData: resultMap['extendedData'] ?? '',
        createTime: resultMap['createTime'],
        joinTime: resultMap['joinTime'],
        callUserList:
            ZIMConverter.oZIMCallUserInfoList(resultMap['callUserList'] ?? []));
  }

  static ZIMCallJoinSentResult oZIMCallJoinSentResult(Map resultMap) {
    return ZIMCallJoinSentResult(
        callID: resultMap['callID'],
        info: oZIMCallJoinSentInfo(resultMap['info']));
  }

  static Map mZIMCallEndConfig(ZIMCallEndConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    configMap['pushConfig'] = mZIMPushConfig(config.pushConfig);
    return configMap;
  }

  static Map mZIMCallQuitConfig(ZIMCallQuitConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    configMap['pushConfig'] = mZIMPushConfig(config.pushConfig);
    return configMap;
  }

  static Map mZIMCallingInviteConfig(ZIMCallingInviteConfig config) {
    Map configMap = {};
    configMap['pushConfig'] = mZIMPushConfig(config.pushConfig);
    return configMap;
  }

  static Map mZIMQueryCallListConfig(ZIMCallInvitationQueryConfig config) {
    Map configMap = {};
    configMap['count'] = config.count;
    configMap['nextFlag'] = config.nextFlag;
    return configMap;
  }

  static Map mZIMCallJoinConfig(ZIMCallJoinConfig config) {
    Map configMap = {};
    configMap['extendedData'] = config.extendedData;
    return configMap;
  }

  static Map mZIMCallInvitationCreatedInfo(ZIMCallInvitationCreatedInfo info) {
    Map map = {};
    map['caller'] = info.caller;
    map['extendedData'] = info.extendedData;
    map['timeout'] = info.timeout;
    map['createTime'] = info.createTime;
    map['callUserList'] = mZIMCallUserInfoList(info.callUserList);
    return map;
  }

  static ZIMCallInvitationCreatedInfo oZIMCallInvitationCreatedInfo(Map infoMap) {
    ZIMCallInvitationCreatedInfo info = ZIMCallInvitationCreatedInfo();
    info.caller = infoMap['caller'] ?? '';
    info.extendedData = infoMap['extendedData'] ?? '';
    info.timeout = infoMap['timeout'] ?? 0;
    info.createTime = infoMap['createTime'] ?? 0;
    info.callUserList = oZIMCallUserInfoList(infoMap['callUserList']);
    return info;
  }

  static ZIMCallInvitationEndedInfo oZIMCallInvitationEndedInfo(Map infoMap) {
    ZIMCallInvitationEndedInfo info = ZIMCallInvitationEndedInfo();
    info.caller = infoMap['caller'];
    info.operatedUserID = infoMap['operatedUserID'];
    info.extendedData = infoMap['extendedData'] ?? '';
    info.mode = ZIMInvitationModeExtension.mapValue[infoMap['mode']]!;
    info.endTime = infoMap['endTime'];
    return info;
  }

  static ZIMCallUserStateChangeInfo oZIMCallUserStateChangedInfo(
      Map callUserStateChangedInfoMap) {
    ZIMCallUserStateChangeInfo callUserStateChangedInfo =
        ZIMCallUserStateChangeInfo();
    callUserStateChangedInfo.callUserList =
        oZIMCallUserInfoList(callUserStateChangedInfoMap['callUserList']);

    return callUserStateChangedInfo;
  }

  static ZIMCallEndSentResult oZIMCallEndSentResult(Map resultMap) {
    ZIMCallEndedSentInfo callEndSentInfo =
        oZIMCallEndSentInfo(resultMap['info']);
    ZIMCallEndSentResult result = ZIMCallEndSentResult(
        callID: resultMap['callID'], info: callEndSentInfo);
    return result;
  }

  static ZIMCallQuitSentResult oZIMCallQuitSentResult(Map resultMap) {
    ZIMCallQuitSentInfo callQuitSentInfo =
        oZIMCallQuitSentInfo(resultMap['info']);
    ZIMCallQuitSentResult result = ZIMCallQuitSentResult(
        callID: resultMap['callID'], info: callQuitSentInfo);
    return result;
  }

  static ZIMCallInfo oZIMCallInfo(Map map) {
    ZIMCallInfo callInfo = ZIMCallInfo();
    callInfo.callID = map['callID'];
    callInfo.caller = map['caller'];
    callInfo.createTime = map['createTime'];
    callInfo.endTime = map['endTime'];
    callInfo.state = ZIMCallStateExtension.mapValue[map['state']]!;
    callInfo.mode = ZIMInvitationModeExtension.mapValue[map['mode']]!;
    callInfo.extendedData = map['extendedData'] ?? '';
    callInfo.callUserList = oZIMCallUserInfoList(map['callUserList']);
    // callInfo.timeout = map['timeout'];
    // callInfo.callDuration = map['callDuration'];
    // callInfo.userDuration = map['userDuration'];
    return callInfo;
  }

  static ZIMMessageDeletedInfo oZIMMessageDeletedInfo(Map map) {
    return ZIMMessageDeletedInfo(
        conversationID: map['conversationID'],
        conversationType:
            ZIMConversationTypeExtension.mapValue[map['conversationType']]!,
        messageDeleteType: ZIMMessageDeleteTypeExtension.mapValue[map['messageDeleteType']]!,
        isDeleteConversationAllMessage: map['isDeleteConversationAllMessage'],
        messageList: ZIMConverter.oZIMMessageList(map['messageList'] ?? []));
  }

  static ZIMFriendApplicationInfo oZIMFriendApplicationInfo(Map map) {
    ZIMFriendApplicationInfo info = ZIMFriendApplicationInfo();
    info.applyUser = oZIMUserInfo(map['applyUser']);
    info.wording = map['wording'];
    info.createTime = map['createTime'];
    info.updateTime = map['updateTime'];
    info.type = ZIMFriendApplicationTypeExtension.mapValue[map['type']] ??
        ZIMFriendApplicationType.unknown;
    info.state = ZIMFriendApplicationStateExtension.mapValue[map['state']] ??
        ZIMFriendApplicationState.unknown;
    return info;
  }

  static List<ZIMFriendApplicationInfo> oZIMFriendApplicationInfoList(
      List list) {
    List<ZIMFriendApplicationInfo> infoList = [];
    for (Map map in list) {
      infoList.add(oZIMFriendApplicationInfo(map));
    }
    return infoList;
  }

  static Map mZIMFriendApplicationAcceptConfig(
      ZIMFriendApplicationAcceptConfig config) {
    return {
      'friendAlias': config.friendAlias,
      'friendAttributes': config.friendAttributes,
      'pushConfig': mZIMPushConfig(config.pushConfig)
    };
  }

  static ZIMFriendApplicationAcceptedResult oZIMFriendApplicationAcceptedResult(
      Map map) {
    ZIMFriendApplicationAcceptedResult result = ZIMFriendApplicationAcceptedResult(friendInfo: oZIMFriendInfo(map['friendInfo']));
    return result;
  }

  static Map mZIMFriendAddConfig(ZIMFriendAddConfig config) {
    return {
      'wording': config.wording,
      'friendAlias': config.friendAlias,
      'friendAttributes': config.friendAttributes,
    };
  }

  static Map mZIMFriendDeleteConfig(ZIMFriendDeleteConfig config) {
    return {
      'type': config
          .type.value, // Assuming ZIMFriendDeleteType has a value extension
    };
  }

  static ZIMFriendInfo oZIMFriendInfo(Map map, [ZIMFriendInfo? friendInfo]) {
    friendInfo ??= ZIMFriendInfo();
    ZIMUserInfo info = oZIMUserInfo(map, friendInfo);
    return info as ZIMFriendInfo;
  }

  static List<ZIMFriendInfo> oZIMFriendInfoList(List list) {
    ZIMManager.writeLog('oZIMFriendInfoList:' + list.toString());
    List<ZIMFriendInfo> infoList = [];
    for (Map map in list) {
      infoList.add(oZIMFriendInfo(map));
    }
    ZIMManager.writeLog(
        'oZIMFriendInfoList,infoList size:' + infoList.length.toString());
    return infoList;
  }

  static Map mZIMFriendListQueryConfig(ZIMFriendListQueryConfig config) {
    return {
      'count': config.count,
      'nextFlag': config.nextFlag,
    };
  }

  static Map mZIMFriendRelationCheckConfig(
      ZIMFriendRelationCheckConfig config) {
    return {
      'type': ZIMFriendRelationCheckTypeExtension.valueMap[config.type],
    };
  }

  static ZIMFriendRelationInfo oZIMFriendRelationInfo(Map map) {
    return ZIMFriendRelationInfo()
      ..type = ZIMUserRelationTypeExtension.mapValue[map['type']]!
      ..userID = map['userID'] ?? "";
  }

  static List<ZIMFriendRelationInfo> oZIMFriendRelationInfoList(
      List basicList) {
    List<ZIMFriendRelationInfo> infoList = [];
    for (Map map in basicList) {
      infoList.add(oZIMFriendRelationInfo(map));
    }
    return infoList;
  }

  static Map mZIMSendFriendApplicationConfig(
      ZIMFriendApplicationSendConfig config) {
    return {
      'wording': config.wording,
      'friendAlias': config.friendAlias,
      'friendAttributes': config.friendAttributes,
      'pushConfig': config.pushConfig != null
          ? mZIMPushConfig(config.pushConfig!)
          : null, // Assuming mZIMPushConfig is defined
    };
  }

  static Map mZIMFriendApplicationRejectConfig(
      ZIMFriendApplicationRejectConfig config) {
    return {
      'pushConfig': mZIMPushConfig(config.pushConfig),
    };
  }

  static Map mZIMFriendApplicationListQueryConfig(
      ZIMFriendApplicationListQueryConfig config) {
    return {
      'count': config.count,
      'nextFlag': config.nextFlag,
    };
  }

  static Map mZIMBlacklistQueryConfig(ZIMBlacklistQueryConfig config) {
    return {
      'nextFlag': config.nextFlag,
      'count': config.count,
    };
  }

static Map mZIMFriendSearchConfig(ZIMFriendSearchConfig config) {
    return {
      'nextFlag': config.nextFlag,
      'count': config.count,
      'keywords': config.keywords,
      'isAlsoMatchFriendAlias': config.isAlsoMatchFriendAlias,
    };
  }

  static ZIMFriendAddedResult oZIMFriendAddedResult(Map map) {
    return ZIMFriendAddedResult(friendInfo: oZIMFriendInfo(map['friendInfo']));
  }

  static ZIMFriendsSearchedResult oZIMFriendsSearchedResult(Map map) {
    return ZIMFriendsSearchedResult(friendInfos: oZIMFriendInfoList(map['friendInfos']), nextFlag: map['nextFlag']);
  }

  static ZIMFriendAliasUpdatedResult oZIMFriendAliasUpdatedResult(Map map) {
    return ZIMFriendAliasUpdatedResult(friendInfo: oZIMFriendInfo(map['friendInfo']));
  }

  static ZIMFriendApplicationListQueriedResult
      oZIMFriendApplicationListQueriedResult(Map map) {
    ZIMFriendApplicationListQueriedResult result = ZIMFriendApplicationListQueriedResult(applicationList: List<ZIMFriendApplicationInfo>.from(
        map['applicationList'].map((x) => oZIMFriendApplicationInfo(x))),nextFlag:map['nextFlag']);
    return result;
  }

  static ZIMFriendApplicationRejectedResult oZIMFriendApplicationRejectedResult(
      Map map) {
    return ZIMFriendApplicationRejectedResult(userInfo: oZIMUserInfo(map['userInfo']));
  }

  static ZIMFriendAttributesUpdatedResult oZIMFriendAttributesUpdatedResult(
      Map map) {
    return ZIMFriendAttributesUpdatedResult(friendInfo: oZIMFriendInfo(map['friendInfo']));
  }

  static ZIMFriendsDeletedResult oZIMFriendDeletedResult(Map map) {
    return ZIMFriendsDeletedResult(errorUserList: oZIMErrorUserInfoList(
        map['errorUserList'] ?? []));
  }

  static ZIMFriendListQueriedResult oZIMFriendListQueriedResult(Map map) {
    return ZIMFriendListQueriedResult(friendList: oZIMFriendInfoList(map['friendList']),nextFlag: map['nextFlag']);
  }

  static ZIMFriendsRelationCheckedResult oZIMFriendRelationCheckedResult(
      Map map) {
    ZIMFriendsRelationCheckedResult result = ZIMFriendsRelationCheckedResult(relationInfos: oZIMFriendRelationInfoList(map['relationInfos']),errorUserList: oZIMErrorUserInfoList(map['errorUserList']));
    return result;
  }

  static ZIMFriendsInfoQueriedResult oZIMFriendsInfoQueriedResult(Map map) {
    ZIMFriendsInfoQueriedResult result = ZIMFriendsInfoQueriedResult(friendInfos: oZIMFriendInfoList(map['friendInfos']),errorUserList: oZIMErrorUserInfoList(map['errorUserList']));
    return result;
  }

  static ZIMFriendApplicationSentResult oZIMFriendApplicationSentResult(
      Map map) {
    ZIMFriendApplicationSentResult result = ZIMFriendApplicationSentResult(applicationInfo: oZIMFriendApplicationInfo(map['applicationInfo']));
    return result;
  }

  static ZIMBlacklistCheckedResult oZIMBlacklistCheckedResult(Map map) {
    return ZIMBlacklistCheckedResult(isUserInBlacklist:map['isUserInBlacklist']);
  }

  static ZIMBlacklistQueriedResult oZIMBlacklistQueriedResult(Map map) {
    return ZIMBlacklistQueriedResult(blacklist: oZIMUserInfoList(map['blacklist']),nextFlag:map['nextFlag']);
  }

  static ZIMBlacklistUsersAddedResult oZIMBlacklistUsersAddedResult(Map map) {
    return ZIMBlacklistUsersAddedResult(errorUserList: oZIMErrorUserInfoList(map['errorUserList']));
  }

  static ZIMBlacklistUsersRemovedResult oZIMBlacklistUsersRemovedResult(
      Map map) {
    return ZIMBlacklistUsersRemovedResult(errorUserInfoArrayList:oZIMErrorUserInfoList(
        map['errorUserList']) );
  }

  static Map mZIMGroupOperatedInfo(ZIMGroupOperatedInfo info){
    Map map = {};
    map['operatedUserInfo'] = ZIMConverter.mZIMGroupMemberInfo(info.operatedUserInfo);
    map['userID'] = info.userID;
    map['userName'] = info.userName;
    map['memberNickname'] = info.memberNickname;
    map['memberRole'] = info.memberRole;
    return map;
  }

  static ZIMGroupMuteInfo oZIMGroupMuteInfo(Map map) {
    ZIMGroupMuteInfo groupMuteInfo = ZIMGroupMuteInfo();
    groupMuteInfo.mode = ZIMGroupMuteModeExtension.mapValue[map['mode']]!;
    groupMuteInfo.expiredTime = map['expiredTime'];
    groupMuteInfo.roles = List<int>.from(map['roles']);
    return groupMuteInfo;
  }

  static ZIMGroupVerifyInfo oZIMGroupVerifyInfo(Map map) {
    ZIMGroupVerifyInfo verifyInfo = ZIMGroupVerifyInfo();
    verifyInfo.joinMode = ZIMGroupJoinModeExtension.mapValue[map['joinMode']] ?? ZIMGroupJoinMode.any;
    verifyInfo.inviteMode = ZIMGroupInviteModeExtension.mapValue[map['inviteMode']] ?? ZIMGroupInviteMode.any;
    verifyInfo.beInviteMode = ZIMGroupBeInviteModeExtension.mapValue[map['beInviteMode']] ?? ZIMGroupBeInviteMode.none;
    return verifyInfo;
  }

  //供自动化使用，sdk 使用前需要 check
  static Map mZIMGroupMuteInfo(ZIMGroupMuteInfo muteInfo){
    Map map = {};
    map['muteMode'] = muteInfo.mode.value;
    map['muteExpireTime'] = muteInfo.expiredTime;
    map['muteRoles'] = muteInfo.roles;
    return map;
  }

  static Map mZIMGroupMuteConfig(ZIMGroupMuteConfig config){
    Map map = {};
    map['mode'] = ZIMGroupMuteModeExtension.valueMap[config.mode];
    map['duration'] = config.duration;
    map['roles'] = config.roles;
    return map;
  }

  static ZIMGroupMutedResult oZIMGroupMutedResult(Map map){
    ZIMGroupMutedResult result = ZIMGroupMutedResult(groupID: map['groupID'],info: ZIMConverter.oZIMGroupMuteInfo(map['info']),isMute:map['isMute']);
    return result;
  }

  static ZIMGroupMembersMutedResult oZIMGroupMembersMutedResult(Map map){
    ZIMGroupMembersMutedResult result = ZIMGroupMembersMutedResult(groupID:map['groupID'],isMute:map['isMute'],errorUserList:oZIMErrorUserInfoList(map['errorUserList']),mutedMemberIDs:List<String>.from(map['mutedMemberIDs']),duration:map['duration']);
    return result;
  }

  static ZIMGroupMemberMutedListQueriedResult oZIMGroupMemberMutedListQueriedResult(Map map){
    ZIMGroupMemberMutedListQueriedResult result = ZIMGroupMemberMutedListQueriedResult(nextFlag: map['nextFlag'],groupID: map['groupID'],userList: ZIMConverter.oZIMGroupMemberInfoList(map['userList']));
    return result;
  }

  static Map mZIMGroupInviteApplicationAcceptConfig(ZIMGroupInviteApplicationAcceptConfig config){
    Map map = {};
    map['pushConfig'] = config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;

    return map;
  }

  static Map mZIMGroupJoinApplicationAcceptConfig(ZIMGroupJoinApplicationAcceptConfig config){
    Map map = {};
    map['pushConfig'] = config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;
    return map;
  }

  static Map mZIMGroupApplicationListQueryConfig(ZIMGroupApplicationListQueryConfig config){
    Map map = {};
    map['count'] = config.count;
    map['nextFlag'] = config.nextFlag;
    return map;
  }

  static Map mZIMGroupInviteApplicationRejectConfig(ZIMGroupInviteApplicationRejectConfig config){
    Map map = {};
    map['pushConfig'] = config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;
    return map;
  }

  static Map mZIMGroupJoinApplicationRejectConfig(ZIMGroupJoinApplicationRejectConfig config){
    Map map = {};
    map['pushConfig'] = config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;
    return map;
  }

  static Map mZIMGroupInviteApplicationSendConfig(ZIMGroupInviteApplicationSendConfig config){
    Map map = {};
    map['pushConfig'] = config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;
    map['wording'] = config.wording;
    return map;
  }

  static Map mZIMGroupJoinApplicationSendConfig(ZIMGroupJoinApplicationSendConfig config){
    Map map = {};
    map['pushConfig'] =config.pushConfig != null ? mZIMPushConfig(config.pushConfig!) : null;
    map['wording'] = config.wording;
    return map;
  }

  static Map mZIMGroupMemberMuteConfig(ZIMGroupMemberMuteConfig config){
    Map map = {};
    map['duration'] = config.duration;
    return map;
  }

  static Map mZIMFileCacheClearConfig(ZIMFileCacheClearConfig config){
    Map map = {};
    map['endTime'] = config.endTime;
    return map;
  }

  static Map mZIMFileCacheQueryConfig(ZIMFileCacheQueryConfig config){
    Map map = {};
    map['endTime'] = config.endTime;
    return map;
  }

  static Map mZIMGroupMemberMutedListQueryConfig(ZIMGroupMemberMutedListQueryConfig config){
    Map map = {};
    map['nextFlag'] = config.nextFlag;
    map['count'] = config.count;
    return map;
  }

  static Map mZIMUserInfo(ZIMUserInfo userInfo){
    Map map = {};
    map['userID'] = userInfo.userID;
    map['userName'] = userInfo.userName;
    map['userAvatarUrl'] = userInfo.userAvatarUrl;
    switch(userInfo.runtimeType){
      case ZIMGroupMemberSimpleInfo:
        userInfo as ZIMGroupMemberSimpleInfo;
        map['memberNickname'] = userInfo.memberNickname;
        map['memberRole'] = userInfo.memberRole;
        map['classType'] = 'ZIMGroupMemberSimpleInfo';
        break;
      case ZIMGroupMemberInfo:
        userInfo as ZIMGroupMemberInfo;
        map['memberNickname'] = userInfo.memberNickname;
        map['memberRole'] = userInfo.memberRole;
        map['memberAvatarUrl'] = userInfo.memberAvatarUrl;
        map['muteExpiredTime'] = userInfo.muteExpiredTime;
        map['classType'] = 'ZIMGroupMemberInfo';
        break;
      case ZIMFriendInfo:
        userInfo as ZIMFriendInfo;
        map['friendAlias'] = userInfo.friendAlias;
        map['createTime'] = userInfo.createTime;
        map['wording'] = userInfo.wording;
        map['friendAttributes'] = userInfo.friendAttributes;
        map['classType'] = 'ZIMFriendInfo';
        break;
      default:
        map['classType'] = 'ZIMUserInfo';
        break;
    }
    return map;
  }

  static Map mZIMGroupMemberInfo(ZIMGroupMemberInfo memberInfo){
    Map map = ZIMConverter.mZIMUserInfo(memberInfo);
    return map;
  }

  static ZIMTipsMessageChangeInfo oZIMTipsMessageChangeInfo(Map map,[ZIMTipsMessageChangeInfo? info]){
    String? classType = map['classType'];
    switch(classType){
      case 'ZIMTipsMessageGroupChangeInfo':
        info ??= ZIMTipsMessageGroupChangeInfo();
        break;
      case 'ZIMTipsMessageGroupMemberChangeInfo':
        info ??= ZIMTipsMessageGroupMemberChangeInfo();
        break;
      default:
        info ??= ZIMTipsMessageChangeInfo();
        break;
    }
    info.type = ZIMTipsMessageChangeInfoTypeExtension.mapValue[map['type']]!;
    switch(info.runtimeType){
      case ZIMTipsMessageGroupChangeInfo:
        info as ZIMTipsMessageGroupChangeInfo;
        info.groupDataFlag = map['groupDataFlag'];
        info.groupName = map['groupName'];
        info.groupNotice = map['groupNotice'];
        info.groupAvatarUrl = map['groupAvatarUrl'];
        if(map['groupMuteInfo'] != null){
          info.groupMutedInfo = oZIMGroupMuteInfo(map['groupMuteInfo']);
        }
        break;
      case ZIMTipsMessageGroupMemberChangeInfo:
        info as ZIMTipsMessageGroupMemberChangeInfo;
        info.memberRole = map['role'];
        info.muteExpiredTime = map['muteExpiredTime'];
        break;
    }
    return info;
  }

  static Map mZIMTipsMessageChangeInfo(ZIMTipsMessageChangeInfo info){
    Map map = {};
    map['type'] = info.type.value;
    switch(info.runtimeType){
      case ZIMTipsMessageGroupChangeInfo:
        info as ZIMTipsMessageGroupChangeInfo;
        map['groupDataFlag'] = info.groupDataFlag;
        map['groupName'] = info.groupName;
        map['groupNotice'] = info.groupNotice;
        map['groupAvatarUrl'] = info.groupAvatarUrl;
        if(info.groupMutedInfo != null){
          map['groupMuteInfo'] = mZIMGroupMuteInfo(info.groupMutedInfo!);
        }
        break;
      case ZIMTipsMessageGroupMemberChangeInfo:
        info as ZIMTipsMessageGroupMemberChangeInfo;
        map['role'] = info.memberRole;
        map['muteExpiredTime'] = info.muteExpiredTime;
        break;
    }
    return map;
  }

  static ZIMUserOfflinePushRule oZIMUserOfflinePushRule(Map map){
    ZIMUserOfflinePushRule pushRule = ZIMUserOfflinePushRule();

    List<int> basicOnlinePlatforms = List<int>.from(map['onlinePlatforms']);
    List<int> basicNotToReceiveOfflinePushPlatforms = List<int>.from(map['notToReceiveOfflinePushPlatforms']);
    List<ZIMPlatformType> onlinePlatforms = [];
    List<ZIMPlatformType> notToReceiveOfflinePushPlatforms = [];
    for(int i in basicOnlinePlatforms){
      onlinePlatforms.add(ZIMPlatformTypeExtension.mapValue[i]??ZIMPlatformType.unknown);
    }
    for(int i in basicNotToReceiveOfflinePushPlatforms){
      notToReceiveOfflinePushPlatforms.add(ZIMPlatformTypeExtension.mapValue[i]??ZIMPlatformType.unknown);
    }
    pushRule.onlinePlatforms = onlinePlatforms;
    pushRule.notToReceiveOfflinePushPlatforms = notToReceiveOfflinePushPlatforms;
    return pushRule;
  }

  static Map mZIMUserOfflinePushRule(ZIMUserOfflinePushRule offlinePushRule){
    Map map = {};
    List<int> basicOnlinePlatforms = [];
    List<int> basicNotToReceiveOfflinePushPlatforms = [];
    for(ZIMPlatformType i in offlinePushRule.onlinePlatforms){
      basicOnlinePlatforms.add(i.value);
    }
    for(ZIMPlatformType i in offlinePushRule.notToReceiveOfflinePushPlatforms){
      basicNotToReceiveOfflinePushPlatforms.add(i.value);
    }
    map['onlinePlatforms'] = basicOnlinePlatforms;
    map['notToReceiveOfflinePushPlatforms'] = basicNotToReceiveOfflinePushPlatforms;
    return map;
  }

  static ZIMUserRule oZIMUserRule(Map map){
    return ZIMUserRule(offlinePushRule: oZIMUserOfflinePushRule(map['offlinePushRule']));
  }

  static ZIMSelfUserInfo oZIMSelfUserInfo(Map map){
    return ZIMSelfUserInfo(userRule: oZIMUserRule(map['userRule']), userFullInfo: oZIMUserFullInfo(map['userFullInfo']));
  }

  static ZIMSelfUserInfoQueriedResult oZIMSelfUserInfoQueriedResult(Map map){
    return ZIMSelfUserInfoQueriedResult(selfUserInfo: oZIMSelfUserInfo(map['selfUserInfo']));
  }

  static ZIMUserOfflinePushRuleUpdatedResult oZIMUserOfflinePushRuleInfoUpdatedResult(Map map){
    return ZIMUserOfflinePushRuleUpdatedResult(offlinePushRule: oZIMUserOfflinePushRule(map['offlinePushRule']));
  }

  static ZIMConversationMarkSetResult oZIMConversationMarkSetResult(Map map){
    ZIMConversationMarkSetResult result = ZIMConversationMarkSetResult(failedConversationInfos: ZIMConverter.oZIMConversationBaseInfoList(map['failedConversationInfos']));
    return result;
  }

  static ZIMConversationTotalUnreadMessageCountQueriedResult oZIMConversationTotalUnreadCountQueriedResult(Map map){
    return ZIMConversationTotalUnreadMessageCountQueriedResult(unreadMessageCount: map['unreadMessageCount']);
  }

  static Map mZIMMessageRepliedListQueryConfig(ZIMMessageRepliedListQueryConfig config){
    Map map = {};
    map['nextFlag'] = config.nextFlag;
    map['count'] = config.count;
    return map;
  }

  static ZIMMessageRepliedListQueriedResult oZIMMessageRepliedListQueriedResult(Map map){
    ZIMMessageRepliedListQueriedResult result = ZIMMessageRepliedListQueriedResult();
    result.messageList = ZIMConverter.oZIMMessageList(map['messageList']);
    result.nextFlag = map['nextFlag'];
    result.rootRepliedInfo = ZIMConverter.oZIMMessageRootRepliedInfo(map['rootRepliedInfo']);
    return result;
  }

  static ZIMMessageRootRepliedCountInfo oZIMMessageRootRepliedCountInfo(Map map){
    ZIMMessageRootRepliedCountInfo info = ZIMMessageRootRepliedCountInfo();
    info.messageID = map['messageID'] is String
    ? (map['messageID'] ==""?0:int.parse(map['messageID'])) : map['messageID'];
    info.conversationID = map['conversationID'];
    info.conversationType = ZIMConversationTypeExtension.mapValue[map['conversationType']]??ZIMConversationType.unknown;
    info.count = map['count'];
    return info;
  }

  static List<ZIMMessageRootRepliedCountInfo> oZIMMessageRootRepliedCountInfoList(List infoList){
    List<ZIMMessageRootRepliedCountInfo> oList = [];
    for(Map map in infoList){
      oList.add(ZIMConverter.oZIMMessageRootRepliedCountInfo(map));
    }
    return oList;
  }

  static ZIMMessageRootRepliedInfo oZIMMessageRootRepliedInfo(Map map) {
    ZIMMessageRootRepliedInfo info = ZIMMessageRootRepliedInfo();
    if(map['message'] != null) {
      info.message = ZIMConverter.oZIMMessage(map['message']);
    }
    info.state = ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ?? ZIMMessageRepliedInfoState.normal;
    info.senderUserID = map['senderUserID'];
    info.sentTime = map['sentTime'];
    info.repliedCount = map['repliedCount'];

    return info;
  }

  static ZIMMessageRepliedInfo oZIMMessageRepliedInfo(Map map){
    ZIMMessageRepliedInfo repliedInfo = ZIMMessageRepliedInfo();
    repliedInfo.messageID =  map['messageID'] is int ? map['messageID']: int.parse(map['messageID']);
    repliedInfo.messageSeq = map['messageSeq'];
    repliedInfo.senderUserID = map['senderUserID'];
    repliedInfo.sentTime = map['sentTime'];
    repliedInfo.state = ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ?? ZIMMessageRepliedInfoState.normal;
    repliedInfo.messageInfo = ZIMConverter.oZIMMessageLiteInfo(map['messageInfo']);
    
    return repliedInfo;
  }

  static Map mZIMMessageRepliedInfo(ZIMMessageRepliedInfo info){
    Map map = {};
    map['messageID'] = info.messageID;
    map['messageSeq'] = info.messageSeq;
    map['senderUserID'] = info.senderUserID;
    map['sentTime'] = info.sentTime;
    map['state'] = ZIMMessageRepliedInfoStateExtension.valueMap[info.state];
    map['messageInfo'] = mZIMMessageLiteInfo(info.messageInfo);
    
    return map;
  }

  static Map mZIMMessageLiteInfo(ZIMMessageLiteInfo liteInfo){
    Map map = {};
    map['type'] = ZIMMessageTypeExtension.valueMap[liteInfo.type];
    if(liteInfo is ZIMTextMessageLiteInfo){
      map['message'] = liteInfo.message;
    }else if (liteInfo is ZIMCustomMessageLiteInfo){
      map['message'] = liteInfo.message;
      map['subType'] = liteInfo.subType;
    }else if (liteInfo is ZIMCombineMessageLiteInfo){
      map['title'] = liteInfo.title;
      map['summary'] = liteInfo.summary;
    }else if(liteInfo is ZIMImageMessageLiteInfo){
      map['originalImageWidth'] = liteInfo.originalImageWidth;
      map['originalImageHeight'] = liteInfo.originalImageHeight;
      map['thumbnailLocalPath'] = liteInfo.thumbnailLocalPath;
      map['thumbnailDownloadUrl'] = liteInfo.thumbnailDownloadUrl;
      map['thumbnailWidth'] = liteInfo.thumbnailWidth;
      map['thumbnailHeight'] = liteInfo.thumbnailHeight;
      map['largeImageLocalPath'] = liteInfo.largeImageLocalPath;
      map['largeImageDownloadUrl'] = liteInfo.largeImageDownloadUrl;
      map['largeImageWidth'] = liteInfo.largeImageWidth;
      map['largeImageHeight'] = liteInfo.largeImageHeight;
    }else if(liteInfo is ZIMAudioMessageLiteInfo){
      map['audioDuration'] = liteInfo.audioDuration;
    }else if(liteInfo is ZIMVideoMessageLiteInfo){
      map['videoDuration'] = liteInfo.videoDuration;
      map['videoFirstFrameDownloadUrl'] = liteInfo.videoFirstFrameDownloadUrl;
      map['videoFirstFrameLocalPath'] = liteInfo.videoFirstFrameLocalPath;
      map['videoFirstFrameWidth'] = liteInfo.videoFirstFrameWidth;
      map['videoFirstFrameHeight'] = liteInfo.videoFirstFrameHeight;
    }

    if(liteInfo is ZIMMediaMessageLiteInfo){
      map['fileSize'] = liteInfo.fileSize;
      map['fileName'] = liteInfo.fileName;
      map['fileLocalPath'] = liteInfo.fileLocalPath;
      map['fileDownloadUrl'] = liteInfo.fileDownloadUrl;
    }
    return map;
  }
  static ZIMMessageLiteInfo oZIMMessageLiteInfo(Map map){
    ZIMMessageLiteInfo liteInfo;
    ZIMMessageType type = ZIMMessageTypeExtension.mapValue[map['type']]??ZIMMessageType.unknown;
    switch(type){
      case ZIMMessageType.text:
        liteInfo = ZIMTextMessageLiteInfo();
        liteInfo as ZIMTextMessageLiteInfo;
        liteInfo.message = map['message'];
        break;
      case ZIMMessageType.image:
        liteInfo = ZIMImageMessageLiteInfo();
        liteInfo as ZIMImageMessageLiteInfo;
        liteInfo.originalImageHeight = map['originalImageHeight'] ?? 0;
        liteInfo.originalImageWidth = map['originalImageWidth'] ?? 0;
        liteInfo.largeImageHeight = map['largeImageHeight'] ?? 0;
        liteInfo.largeImageWidth = map['largeImageWidth'] ?? 0;
        liteInfo.largeImageLocalPath = map['largeImageLocalPath'] ?? '';
        liteInfo.largeImageDownloadUrl = map['largeImageDownloadUrl'] ?? '';
        liteInfo.thumbnailHeight = map['thumbnailHeight'] ?? 0;
        liteInfo.thumbnailWidth = map['thumbnailWidth'] ?? 0;
        liteInfo.thumbnailLocalPath = map['thumbnailLocalPath'] ?? '';
        liteInfo.thumbnailDownloadUrl = map['thumbnailDownloadUrl'] ?? '';
        break;
      case ZIMMessageType.file:
        liteInfo = ZIMFileMessageLiteInfo();
        liteInfo as ZIMFileMessageLiteInfo;
        break;
      case ZIMMessageType.audio:
        liteInfo = ZIMAudioMessageLiteInfo();
        liteInfo as ZIMAudioMessageLiteInfo;
        liteInfo.audioDuration = map['audioDuration'] ?? 0;
        break;
      case ZIMMessageType.video:
        liteInfo = ZIMVideoMessageLiteInfo();
        liteInfo as ZIMVideoMessageLiteInfo;
        liteInfo.videoDuration = map['videoDuration'] ?? 0;
        liteInfo.videoFirstFrameDownloadUrl = map['videoFirstFrameDownloadUrl'] ?? '';
        liteInfo.videoFirstFrameLocalPath = map['videoFirstFrameLocalPath'] ?? '';
        liteInfo.videoFirstFrameHeight = map['videoFirstFrameHeight'] ?? 0;
        liteInfo.videoFirstFrameWidth = map['videoFirstFrameWidth'] ?? 0;
        break;
      case ZIMMessageType.revoke:
        liteInfo = ZIMRevokeMessageLiteInfo();
        break;
      case ZIMMessageType.custom:
        liteInfo = ZIMCustomMessageLiteInfo();
        liteInfo as ZIMCustomMessageLiteInfo;
        liteInfo.message = map['message'] ?? '';
        liteInfo.subType = map['subType'] ?? 0;
        break;
      case ZIMMessageType.combine:
        liteInfo = ZIMCombineMessageLiteInfo();
        liteInfo as ZIMCombineMessageLiteInfo;
        liteInfo.title = map['title'] ?? '';
        liteInfo.summary = map['summary'] ?? '';
        break;
      case ZIMMessageType.command:
      case ZIMMessageType.tips:
      case ZIMMessageType.system:
      case ZIMMessageType.barrage:
      case ZIMMessageType.unknown:
        liteInfo = ZIMMessageLiteInfo();
        break;
    }
    liteInfo.type = type;
    switch(type){
      case ZIMMessageType.image:
      case ZIMMessageType.file:
      case ZIMMessageType.video:
      case ZIMMessageType.audio:
        liteInfo as ZIMMediaMessageLiteInfo;
        liteInfo.fileSize = map['fileSize'] ?? '';
        liteInfo.fileName = map['fileName'] ?? '';
        liteInfo.fileLocalPath = map['fileLocalPath'] ?? '';
        liteInfo.fileDownloadUrl = map['fileDownloadUrl'] ?? '';
        break;
      default:
        break;
    }
    return liteInfo;
  }

  static Uint8List convertToUint8List(dynamic data) {
    final list = <int>[];
    for(int i = 0; i < data.length; i++) {
      list.add(data[i.toString()]);
    }

    final uint8List = Uint8List.fromList(list);
    return uint8List;
  }

}
