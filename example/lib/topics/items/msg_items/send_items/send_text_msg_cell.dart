import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../bubble/text_bubble.dart';

class SendTextMsgCell extends StatefulWidget {
  ZIMTextMessage message;

  SendTextMsgCell({required this.message});
  @override
  State<StatefulWidget> createState() => _MyCellState();
}

class _MyCellState extends State<SendTextMsgCell> {
  get isSending {
    if (widget.message.sentStatus == ZIMMessageSentStatus.sending) {
      return true;
    } else {
      return false;
    }
  }

  get isSentFailed {
    if (widget.message.sentStatus == ZIMMessageSentStatus.failed) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.message.senderUserID),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Offstage(
                      offstage: !isSending,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 10),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !isSentFailed,
                      child: Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          )),
                    ),
                    TextBubble(widget.message.message, Colors.green.shade300,
                        Colors.black, 5, 5)
                  ],
                )
              ],
            ),
            Icon(
              Icons.person,
              size: 50,
            ),
          ],
        ));
  }
}
