import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_text_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_text_msg_cell.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';

typedef MessageListUpdateCallBack = void Function(
    List<Widget> converWidgetList);

class ConverModel {
  ConverModel({required this.conversation}) {
    registerPeerEvent();
    getMoreMessageWidgetList();
  }
  ZIMConversation conversation;
  List<ZIMMessage> _myMessageList = [];
  List<Widget> _messageWidgetList = [];
  MessageListUpdateCallBack? subscriber;

  List<Widget> getCurrentMessageWidgetList() {
    return _messageWidgetList;
  }

  getMoreMessageWidgetList() async {
    ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
    queryConfig.count = 20;
    try {
      queryConfig.nextMessage = _myMessageList.last;
    } catch (onerror) {
      queryConfig.nextMessage = null;
    }
    try {
      ZIMMessageQueriedResult result = await ZIM
          .getInstance()
          .queryHistoryMessage(
              conversation.conversationID, conversation.type, queryConfig);

      //renew message list
      result.messageList.addAll(_myMessageList);
      _myMessageList = result.messageList;

      //renew message widget list
      List<Widget> oldMessageWidgetList =
          cnvMessageToWidget(result.messageList);
      oldMessageWidgetList.addAll(_messageWidgetList);
      _messageWidgetList = oldMessageWidgetList;

      //
      if (subscriber != null) subscriber!(_messageWidgetList);
    } on PlatformException catch (onError) {
      log(onError.code);
    }
  }

  sendTextMessage(String message) async {
    ZIMTextMessage textMessage = ZIMTextMessage(message: message);
    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    switch (conversation.type) {
      case ZIMConversationType.peer:
        try {
          ZIMMessageSentResult result = await ZIM.getInstance().sendPeerMessage(
              textMessage, conversation.conversationID, sendConfig);
          _myMessageList.add(result.message);
          SendTextMsgCell cell =
              SendTextMsgCell(message: (result.message as ZIMTextMessage));
          _messageWidgetList.add(cell);
          if (subscriber != null) subscriber!(_messageWidgetList);
        } on PlatformException catch (onError) {}
        break;
      default:
    }
  }

  List<Widget> cnvMessageToWidget(List<ZIMMessage> messageList) {
    List<Widget> widgetList = [];

    for (ZIMMessage message in messageList) {
      var cell;
      switch (message.type) {
        case ZIMMessageType.text:
          if (message.senderUserID == UserModel.shared().userInfo!.userID) {
            cell = SendTextMsgCell(message: (message as ZIMTextMessage));
          } else {
            cell = ReceiceTextMsgCell(message: (message as ZIMTextMessage));
          }
          break;
        default:
      }
      widgetList.add(cell);
    }
    return widgetList;
  }

  updateMessageWidgetList(MessageListUpdateCallBack callBack) {
    subscriber = callBack;
  }

  registerPeerEvent() {
    ZIMEventHandler.onReceivePeerMessage = (messageList, fromUserID) {
      if (fromUserID != conversation.conversationID) {
        return;
      }
      _myMessageList.addAll(messageList);
      for (ZIMMessage message in messageList) {
        switch (message.type) {
          case ZIMMessageType.text:
            ReceiceTextMsgCell cell =
                ReceiceTextMsgCell(message: (message as ZIMTextMessage));
            _messageWidgetList.add(cell);
            if (subscriber != null) subscriber!(_messageWidgetList);
            break;
          default:
        }
      }
    };
  }
}
