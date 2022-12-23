import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/downloading_progress_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_image_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_video_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_video_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/uploading_progress_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_bottom_box/msg_bottom_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_converter.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_image_msg_cell.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';

import '../../../items/msg_items/msg_bottom_box/msg_normal_bottom_box.dart';

import '../../../items/msg_items/receive_items/receive_text_msg_cell.dart';
import '../../../items/msg_items/send_items/send_text_msg_cell.dart';
import '../../../items/msg_items/msg_list.dart';

class PeerChatPage extends StatefulWidget {
  PeerChatPage({required this.conversationID, required this.conversationName}) {
    ZIM.getInstance()!.clearConversationUnreadMessageCount(
        conversationID, ZIMConversationType.peer);
    clearUnReadMessage();
  }
  String conversationID;
  String conversationName;
  double sendTextFieldBottomMargin = 40;
  bool emojiShowing = false;
  List<ZIMMessage> _historyZIMMessageList = <ZIMMessage>[];
  List<Widget> _historyMessageWidgetList = <Widget>[];

  double progress = 0.0;

  bool queryHistoryMsgComplete = false;

  clearUnReadMessage() {
    ZIM.getInstance()!.clearConversationUnreadMessageCount(
        conversationID, ZIMConversationType.peer);
  }

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<PeerChatPage> {
  String get appBarTitleValue {
    if (widget.conversationName != '') {
      return widget.conversationName;
    } else {
      return widget.conversationID;
    }
  }

  @override
  void initState() {
    registerZIMEvent();
    if (widget._historyZIMMessageList.isEmpty) {
      queryMoreHistoryMessageWidgetList();
    }
    super.initState();
  }

  @override
  void dispose() {
    unregisterZIMEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitleValue,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
        shadowColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: (() {
                  setState(() {
                    MsgBottomModel.nonselfOnTapResponse();
                  });
                }),
                child: Container(
                  color: Colors.grey[100],
                  alignment: Alignment.topCenter,
                  child: MsgList(
                    widget._historyMessageWidgetList,
                    loadMoreHistoryMsg: () {
                      queryMoreHistoryMessageWidgetList();
                    },
                  ),
                )),
          ),
          MsgNormalBottomBox(
            sendTextFieldonSubmitted: (message) {
              sendTextMessage(message);
            },
            onCameraIconButtonOnPressed: (path) {
              sendMediaMessage(path, ZIMMessageType.image);
            },
            onImageIconButtonOnPressed: (path) {
              sendMediaMessage(path, ZIMMessageType.image);
            },
            onVideoIconButtonOnPressed: (path) {
              sendMediaMessage(path, ZIMMessageType.video);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
    );
  }

  sendTextMessage(String message) async {
    ZIMTextMessage textMessage = ZIMTextMessage(message: message);
    textMessage.senderUserID = UserModel.shared().userInfo!.userID;
    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    widget._historyZIMMessageList.add(textMessage);

    SendTextMsgCell cell = SendTextMsgCell(message: textMessage);
    setState(() {
      widget._historyMessageWidgetList.add(cell);
    });
    try {
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMessage(
          textMessage,
          widget.conversationID,
          ZIMConversationType.peer,
          sendConfig, ZIMMessageSendNotification(onMessageAttached: ((message) async {
      })));

      int index = widget._historyZIMMessageList
          .lastIndexWhere((element) => element == textMessage);
      widget._historyZIMMessageList[index] = result.message;
      SendTextMsgCell cell =
          SendTextMsgCell(message: (result.message as ZIMTextMessage));

      setState(() {
        widget._historyMessageWidgetList[index] = cell;
      });
    } on PlatformException catch (onError) {
      log('send error,code:' + onError.code + 'message:' + onError.message!);
      setState(() {
        int index = widget._historyZIMMessageList
            .lastIndexWhere((element) => element == textMessage);
        widget._historyZIMMessageList[index].sentStatus =
            ZIMMessageSentStatus.failed;
        SendTextMsgCell cell = SendTextMsgCell(
            message: (widget._historyZIMMessageList[index] as ZIMTextMessage));
        widget._historyMessageWidgetList[index] = cell;
      });
    }
  }

  sendMediaMessage(String? path, ZIMMessageType messageType) async {
    if (path == null) return;
    ZIMMediaMessage mediaMessage =
        MsgConverter.mediaMessageFactory(path, messageType);
    mediaMessage.senderUserID = UserModel.shared().userInfo!.userID;
    UploadingprogressModel uploadingprogressModel = UploadingprogressModel();
    Widget sendMsgCell = MsgConverter.sendMediaMessageCellFactory(
        mediaMessage, uploadingprogressModel);

    setState(() {
      widget._historyZIMMessageList.add(mediaMessage);
      widget._historyMessageWidgetList.add(sendMsgCell);
    });
    try {
      log(mediaMessage.fileLocalPath);
      ZIMMediaMessageSendNotification notification =
          ZIMMediaMessageSendNotification(
        onMediaUploadingProgress: (message, currentFileSize, totalFileSize) {
          uploadingprogressModel.uploadingprogress!(
              message, currentFileSize, totalFileSize);
        },
      );
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMediaMessage(
          mediaMessage,
          widget.conversationID,
          ZIMConversationType.peer,
          ZIMMessageSendConfig(),
          notification);
      int index = widget._historyZIMMessageList
          .lastIndexWhere((element) => element == mediaMessage);
      Widget resultCell = MsgConverter.sendMediaMessageCellFactory(
          result.message as ZIMMediaMessage, null);
      setState(() {
        widget._historyMessageWidgetList[index] = resultCell;
      });
    } on PlatformException catch (onError) {
      int index = widget._historyZIMMessageList
          .lastIndexWhere((element) => element == mediaMessage);
      widget._historyZIMMessageList[index].sentStatus =
          ZIMMessageSentStatus.failed;
      Widget failedCell = MsgConverter.sendMediaMessageCellFactory(
          widget._historyZIMMessageList[index] as ZIMMediaMessage, null);
      setState(() {
        widget._historyMessageWidgetList[index] = failedCell;
      });
    }
  }

  queryMoreHistoryMessageWidgetList() async {
    if (widget.queryHistoryMsgComplete) {
      return;
    }

    ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
    queryConfig.count = 20;
    queryConfig.reverse = true;
    try {
      queryConfig.nextMessage = widget._historyZIMMessageList.first;
    } catch (onerror) {
      queryConfig.nextMessage = null;
    }
    try {
      ZIMMessageQueriedResult result = await ZIM
          .getInstance()!
          .queryHistoryMessage(
              widget.conversationID, ZIMConversationType.peer, queryConfig);
      if (result.messageList.length < 20) {
        widget.queryHistoryMsgComplete = true;
      }
      List<Widget> oldMessageWidgetList =
          MsgConverter.cnvMessageToWidget(result.messageList);
      result.messageList.addAll(widget._historyZIMMessageList);
      widget._historyZIMMessageList = result.messageList;

      oldMessageWidgetList.addAll(widget._historyMessageWidgetList);
      widget._historyMessageWidgetList = oldMessageWidgetList;

      setState(() {});
    } on PlatformException catch (onError) {
      //log(onError.code);
    }
  }

  registerZIMEvent() {
    ZIMEventHandler.onReceivePeerMessage = (zim, messageList, fromUserID) {
      if (fromUserID != widget.conversationID) {
        return;
      }
      widget.clearUnReadMessage();
      widget._historyZIMMessageList.addAll(messageList);
      for (ZIMMessage message in messageList) {
        switch (message.type) {
          case ZIMMessageType.text:
            ReceiveTextMsgCell cell =
                ReceiveTextMsgCell(message: (message as ZIMTextMessage));
            widget._historyMessageWidgetList.add(cell);
            break;
          case ZIMMessageType.image:
            if ((message as ZIMImageMessage).fileLocalPath == "") {
              DownloadingProgressModel downloadingProgressModel =
                  DownloadingProgressModel();

              ReceiveImageMsgCell resultCell;
              ZIM
                  .getInstance()!
                  .downloadMediaFile(message, ZIMMediaFileType.originalFile,
                      (message, currentFileSize, totalFileSize) {})
                  .then((value) => {
                        resultCell = ReceiveImageMsgCell(
                            message: (value.message as ZIMImageMessage),
                            downloadingProgress: null,
                            downloadingProgressModel: downloadingProgressModel),
                        widget._historyMessageWidgetList.add(resultCell),
                        setState(() {})
                      });
            } else {
              ReceiveImageMsgCell resultCell = ReceiveImageMsgCell(
                  message: message,
                  downloadingProgress: null,
                  downloadingProgressModel: null);
              widget._historyMessageWidgetList.add(resultCell);
            }

            break;
          case ZIMMessageType.video:
            if ((message as ZIMVideoMessage).fileLocalPath == "") {
              ReceiveVideoMsgCell resultCell;
              ZIM
                  .getInstance()!
                  .downloadMediaFile(message, ZIMMediaFileType.originalFile,
                      (message, currentFileSize, totalFileSize) {})
                  .then((value) => {
                        resultCell = ReceiveVideoMsgCell(
                            message: value.message as ZIMVideoMessage,
                            downloadingProgressModel: null),
                        widget._historyMessageWidgetList.add(resultCell),
                        setState(() {})
                      });
            } else {
              ReceiveVideoMsgCell resultCell = ReceiveVideoMsgCell(
                  message: message, downloadingProgressModel: null);
              widget._historyMessageWidgetList.add(resultCell);
              setState(() {});
            }
            break;
          default:
        }
      }
      setState(() {});
    };
  }

  unregisterZIMEvent() {
    ZIMEventHandler.onReceivePeerMessage = null;
  }
}
