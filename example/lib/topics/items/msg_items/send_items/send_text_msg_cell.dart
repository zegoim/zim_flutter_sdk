import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/text_bubble.dart';

class SendTextMsgCell extends StatefulWidget {
  ZIMTextMessage message;

  
  SendTextMsgCell({required this.message});
  @override
  State<StatefulWidget> createState() => _MyCellState();
}

class _MyCellState extends State<SendTextMsgCell> {

  

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.message.senderUserID),
                  SizedBox(
                    height: 5,
                  ),
                  TextBubble(
                      widget.message.message,
                      Colors.green.shade300,
                      Colors.black,
                      5,
                      5)
                ],
              ),
            ),
            Icon(
              Icons.person,
              size: 50,
            ),
          ],
        ));
  }
}
