import 'package:flutter/cupertino.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_text_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_text_msg_cell.dart';

import '../../login/user_model.dart';

class MsgConverter {
  static List<Widget> cnvMessageToWidget(List<ZIMMessage> messageList) {
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
}
