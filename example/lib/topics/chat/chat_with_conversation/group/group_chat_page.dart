import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_set_page/group_set_page.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_bottom_box/msg_bottom_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_converter.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';

import '../../../items/msg_items/downloading_progress_model.dart';
import '../../../items/msg_items/msg_bottom_box/msg_normal_bottom_box.dart';
import '../../../items/msg_items/receive_items/receive_image_msg_cell.dart';
import '../../../items/msg_items/receive_items/receive_text_msg_cell.dart';
import '../../../items/msg_items/receive_items/receive_video_msg_cell.dart';
import '../../../items/msg_items/send_items/send_text_msg_cell.dart';
import '../../../items/msg_items/msg_list.dart';
import '../../../items/msg_items/uploading_progress_model.dart';

class GroupChatPage extends StatefulWidget {
  GroupChatPage(
      {required this.conversationID, required this.conversationName}) {
    ZIM.getInstance()!.clearConversationUnreadMessageCount(
        conversationID, ZIMConversationType.group);

    ZIM
        .getInstance()
        !.queryGroupMemberInfo(
            UserModel.shared().userInfo!.userID, conversationID)
        .then((value) => {myGroupMemberInfo = value.userInfo});
    ZIM
        .getInstance()
        !.queryGroupInfo(conversationID)
        .then((value) => {myGroupFullInfo = value.groupInfo});
  }
  String conversationID;
  String conversationName;

  ZIMGroupMemberInfo myGroupMemberInfo = ZIMGroupMemberInfo();

  ZIMGroupFullInfo myGroupFullInfo = ZIMGroupFullInfo(baseInfo: ZIMGroupInfo());

  bool emojiShowing = false;
  bool queryHistoryMsgComplete = false;
  List<ZIMMessage> _historyZIMMessageList = <ZIMMessage>[];
  List<Widget> _historyMessageWidgetList = <Widget>[];

  @override
  State<StatefulWidget> createState() => GroupChatPageState();
}

class GroupChatPageState extends State<GroupChatPage> {
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
              icon: const Icon(
                Icons.arrow_back,
              ),
              color: Colors.black,
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return GroupSetPage(
                    myGroupMemberInfo: widget.myGroupMemberInfo,
                    myGroupFullInfo: widget.myGroupFullInfo,
                  );
                })));
              },
              icon: const Icon(Icons.more_horiz, color: Colors.black))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                setState(() {
                  //FocusScope.of(context).unfocus();
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
              ),
            ),
          ),
          // MsgNormalBottomBox(
          //   sendTextFieldonSubmitted: (value) {
          //     FocusScope.of(context).unfocus();
          //     sendTextMessage(value);
          //   },
          // ),
          MsgNormalBottomBox(sendTextFieldonSubmitted: (message) {
            sendTextMessage(message);
          }, onCameraIconButtonOnPressed: (path) {
            sendMediaMessage(path, ZIMMessageType.image);
          }, onImageIconButtonOnPressed: (path) {
            sendMediaMessage(path, ZIMMessageType.image);
          }, onVideoIconButtonOnPressed: (path) {
            sendMediaMessage(path, ZIMMessageType.video);
          })
        ],
      ),
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
    );
  }

  sendTextMessage(String message) async {
    ZIMTextMessage textMessage = ZIMTextMessage(message: message);
    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    try {
      ZIMMessageSentResult result = await ZIM
          .getInstance()!.sendGroupMessage(textMessage, widget.conversationID, sendConfig);
      widget._historyZIMMessageList.add(result.message);
      SendTextMsgCell cell =
          SendTextMsgCell(message: (result.message as ZIMTextMessage));
      setState(() {
        widget._historyMessageWidgetList.add(cell);
      });
    } on PlatformException catch (onError) {
      log('send error,code:' + onError.code + 'message:' + onError.message!);
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
      ZIMMediaMessageSendNotification notification = ZIMMediaMessageSendNotification(onMediaUploadingProgress: (message, currentFileSize, totalFileSize) {
            uploadingprogressModel.uploadingprogress!(
            message, currentFileSize, totalFileSize);
      },);
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMediaMessage(mediaMessage, widget.conversationID, ZIMConversationType.group, ZIMMessageSendConfig(), notification);

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
          .getInstance()
          !.queryHistoryMessage(
              widget.conversationID, ZIMConversationType.group, queryConfig);
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
    ZIMEventHandler.onReceiveGroupMessage = (zim, messageList, fromUserID) {
      if (fromUserID != widget.conversationID) {
        return;
      }
      widget._historyZIMMessageList.addAll(messageList);
      for (ZIMMessage message in messageList) {
        switch (message.type) {
          case ZIMMessageType.text:
            ReceiveTextMsgCell cell =
                ReceiveTextMsgCell(message: (message as ZIMTextMessage));
            widget._historyMessageWidgetList.add(cell);
            break;
          case ZIMMessageType.image:
            if ((message as ZIMImageMessage).largeImageLocalPath == "") {
              ReceiveImageMsgCell resultCell;
              ZIM
                  .getInstance()
                  !.downloadMediaFile(message, ZIMMediaFileType.largeImage,
                      (message, currentFileSize, totalFileSize) {})
                  .then((value) => {
                        resultCell = ReceiveImageMsgCell(
                            message: (value.message as ZIMImageMessage),
                            downloadingProgress: null,
                            downloadingProgressModel: null),
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
                  .getInstance()
                  !.downloadMediaFile(message, ZIMMediaFileType.originalFile,
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
    ZIMEventHandler.onReceiveGroupMessage = null;
  }
}
