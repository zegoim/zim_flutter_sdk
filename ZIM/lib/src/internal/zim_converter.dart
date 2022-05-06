import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
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

    List<ZIMUserInfo> userList = [];
    for (Map userInfoMap in userListBasic) {
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = userInfoMap['userID'];
      userInfo.userName = userInfoMap['userName'];
      userList.add(userInfo);
    }

    List<ZIMErrorUserInfo> errorUserList = [];
    for (Map userInfoMap in errorUserListBasic) {
      ZIMErrorUserInfo errorUserInfo = ZIMErrorUserInfo();
      errorUserInfo.userID = userInfoMap['userID'];
      errorUserInfo.reason = userInfoMap['reason'];
      errorUserList.add(errorUserInfo);
    }

    return ZIMUsersInfoQueriedResult(
        userList: userList, errorUserList: errorUserList);
  }

  static Map cnvZIMConversationQueryConfigObjectToMap(
      ZIMConversationQueryConfig config) {
    Map queryConfigMap = {};
    queryConfigMap['count'] = config.count;
    if (config.nextConversation != null) {
      queryConfigMap['nextConversation'] =
          cnvZIMConversationObjectToMap(config.nextConversation!);
    }
    return queryConfigMap;
  }

  static Map cnvZIMConversationObjectToMap(ZIMConversation conversation) {
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
    switch (message.type) {
      case ZIMMessageType.unKnown:
        break;
      case ZIMMessageType.text:
        ZIMTextMessage txtMsg = (message as ZIMTextMessage);
        messageMap['message'] = txtMsg.message;
        break;
      case ZIMMessageType.command:
        ZIMCommandMessage cmdMsg = (message as ZIMCommandMessage);
        messageMap['message'] = cmdMsg.message;
        break;
      case ZIMMessageType.barrage:
        ZIMBarrageMessage brgMsg = (message as ZIMBarrageMessage);
        messageMap['message'] = brgMsg.message;
        break;
      default:
        break;
    }
    return messageMap;
  }

  static ZIMMessage cnvZIMMessageMapToObject(Map resultMap) {
    ZIMMessage message = ZIMMessage();
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
    switch (message.type) {
      case ZIMMessageType.unKnown:
        return message;
      case ZIMMessageType.text:
        ZIMTextMessage txtMsg = (message as ZIMTextMessage);
        txtMsg.message = resultMap['message'];
        return txtMsg;
      case ZIMMessageType.command:
        ZIMCommandMessage cmdMsg = (message as ZIMCommandMessage);
        cmdMsg.message = resultMap['message'];
        return cmdMsg;
      case ZIMMessageType.barrage:
        ZIMBarrageMessage brgMsg = (message as ZIMBarrageMessage);
        brgMsg.message = resultMap['message'];
        return brgMsg;
      default:
        return message;
    }
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
    ZIMConversationType conversationType = resultMap['conversationType'];
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

  static ZIMConversationChangeInfo cnvZIMConversationChangeInfoMapToObject(
      Map conversationChangeInfoMap) {
    ZIMConversationChangeInfo conversationChangeInfo =
        ZIMConversationChangeInfo();
    conversationChangeInfo.event = conversationChangeInfoMap['event'];
    Map conversationMap = conversationChangeInfoMap['conversation'];
    conversationChangeInfo.conversation =
        cnvZIMConversationMapToObject(conversationMap);
    return conversationChangeInfo;
  }

  static Map cnvZIMMessageSendConfigObjectToMap(
      ZIMMessageSendConfig sendConfig) {
    Map sendConfigMap = {};
    if (sendConfig.pushConfig != null) {
      sendConfigMap['pushConfig'] =
          cnvZIMPushConfigObjectToMap(sendConfig.pushConfig!);
    }
    sendConfigMap['priority'] =
        ZIMMessagePriorityExtension.valueMap[sendConfig.priority];
    return sendConfigMap;
  }

  static Map cnvZIMPushConfigObjectToMap(ZIMPushConfig pushConfig) {
    Map pushConfigMap = {};
    pushConfigMap['title'] = pushConfig.title;
    pushConfigMap['content'] = pushConfig.content;
    if (pushConfig.extendedData != null) {
      pushConfigMap['extendedData'] = pushConfig.extendedData!;
    } else {
      pushConfigMap['extendedData'] = "";
    }
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

}
