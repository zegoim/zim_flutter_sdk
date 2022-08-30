import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

class ClearChatLogsItem extends StatefulWidget {
  ClearChatLogsItem(
      {required this.conversationID, required this.conversationType});
  String conversationID;
  ZIMConversationType conversationType;
  @override
  State<StatefulWidget> createState() => ClearChatLogsItemState();
}

class ClearChatLogsItemState extends State<ClearChatLogsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9)),
            top: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
      ),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              ZIM.getInstance()!.deleteAllMessage(widget.conversationID,
                  widget.conversationType, ZIMMessageDeleteConfig());
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'clear chat logs',
              style: TextStyle(color: Colors.red),
              textScaleFactor: 1.2,
            ),
          )
        ],
      ),
    );
  }
}
