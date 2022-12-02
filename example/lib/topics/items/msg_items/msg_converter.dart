import 'package:flutter/cupertino.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_image_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_text_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_video_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_image_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_text_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_video_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/uploading_progress_model.dart';

import '../../login/user_model.dart';

class MsgConverter {
  static List<Widget> cnvMessageToWidget(List<ZIMMessage> messageList) {
    List<Widget> widgetList = [];

    for (ZIMMessage message in messageList) {
      var cell;
      switch (message.type) {
        case (ZIMMessageType.text):
          if (message.senderUserID == UserModel.shared().userInfo!.userID) {
            cell = SendTextMsgCell(message: (message as ZIMTextMessage));
          } else {
            cell = ReceiveTextMsgCell(message: (message as ZIMTextMessage));
          }
          break;
        case ZIMMessageType.image:
          if (message.senderUserID == UserModel.shared().userInfo!.userID) {
            cell = SendImageMsgCell(
              message: message as ZIMImageMessage,
              uploadingprogressModel: null,
            );
          } else {
            cell = ReceiveImageMsgCell(
                message: message as ZIMImageMessage,
                downloadingProgress: null,
                downloadingProgressModel: null);
          }
          break;
        case ZIMMessageType.video:
          if ((message as ZIMVideoMessage).fileLocalPath == '') {
            ZIM.getInstance()!.downloadMediaFile(
                message,
                ZIMMediaFileType.originalFile,
                (message, currentFileSize, totalFileSize) {});
          }
          if (message.senderUserID == UserModel.shared().userInfo!.userID) {
            cell = SendVideoMsgCell(
                message: message,
                uploadingprogressModel: null);
          } else {
            cell = ReceiveVideoMsgCell(
                message: message,
                downloadingProgressModel: null);
          }
          break;
        case ZIMMessageType.revoke:
          ZIMTextMessage textMessage = ZIMTextMessage(message: "");
          textMessage.sentStatus = ZIMMessageSentStatus.success;
          if (message.senderUserID == UserModel.shared().userInfo!.userID) {
            cell = SendTextMsgCell(message: textMessage);
          } else {
            cell = ReceiveTextMsgCell(message: textMessage);
          }
          break;
        default:
      }
      widgetList.add(cell);
    }
    return widgetList;
  }

  static ZIMMediaMessage mediaMessageFactory(
      String path, ZIMMessageType messageType) {
    ZIMMediaMessage mediaMessage;

    switch (messageType) {
      case ZIMMessageType.image:
        mediaMessage = ZIMImageMessage(path);
        break;
      case ZIMMessageType.video:
        mediaMessage = ZIMVideoMessage(path);
        break;
      case ZIMMessageType.audio:
        mediaMessage = ZIMAudioMessage(path);

        break;
      case ZIMMessageType.file:
        mediaMessage = ZIMFileMessage(path);
        break;
      default:
        {
          throw UnimplementedError();
        }
    }
    return mediaMessage;
  }

  static Widget sendMediaMessageCellFactory(
      ZIMMediaMessage message, UploadingprogressModel? uploadingprogressModel) {
    Widget cell;
    switch (message.type) {
      case ZIMMessageType.image:
        cell = SendImageMsgCell(
          message: message as ZIMImageMessage,
          uploadingprogressModel: uploadingprogressModel,
        );
        break;
      case ZIMMessageType.video:
        cell = SendVideoMsgCell(
            message: message as ZIMVideoMessage,
            uploadingprogressModel: uploadingprogressModel);
        break;
      default:
        {
          throw UnimplementedError();
        }
    }
    return cell;
  }

  // static Widget receiveMediaMessageCellFactory(ZIMMediaMessage message) {

  // }
}
