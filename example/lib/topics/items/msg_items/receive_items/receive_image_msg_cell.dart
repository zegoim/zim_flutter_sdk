

import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/downloading_progress_model.dart';

import '../bubble/image_bubble.dart';

class ReceiveImageMsgCell extends StatefulWidget {
  ZIMImageMessage message;
  double? progress;
  DownloadingProgressModel? downloadingProgressModel;
  ZIMMediaDownloadingProgress? downloadingProgress;

  ReceiveImageMsgCell(
      {required this.message,
      required this.downloadingProgress,
      required this.downloadingProgressModel}) {}

  get isUpLoading {
    if (message.sentStatus == ZIMMessageSentStatus.sending) {
      return true;
    } else {
      return false;
    }
  }

  get isUpLoadFailed {
    if (message.sentStatus == ZIMMessageSentStatus.failed) {
      return true;
    } else {
      return false;
    }
  }

  @override
  State<StatefulWidget> createState() => ReceiveImageMsgCellState();
}

class ReceiveImageMsgCellState extends State<ReceiveImageMsgCell> {
   checkIsdownload() async {
    if (widget.message.fileLocalPath == '') {
      ZIMMediaDownloadedResult result = await ZIM
          .getInstance()
          !.downloadMediaFile(widget.message, ZIMMediaFileType.originalFile,
              (message, currentFileSize, totalFileSize) {});
      setState(() {
        widget.message = result.message as ZIMImageMessage;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    checkIsdownload();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.person,
            size: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.message.senderUserID),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageBubble(filelocalPath: widget.message.fileLocalPath)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
