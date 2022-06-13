import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/text_bubble.dart';

class ReceiceTextMsgCell extends StatefulWidget {
  ZIMTextMessage message;

  ReceiceTextMsgCell({required this.message});

  @override
  State<StatefulWidget> createState() => _MyCellState();
}

class _MyCellState extends State<ReceiceTextMsgCell> {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.message.senderUserID),
                  SizedBox(
                    height: 5,
                  ),
                  TextBubble(
                      widget.message.message,
                      Colors.white,
                      Colors.black,
                      5,
                      5)
                ],
              ),
            ),
          ],
        ));
  }
}
