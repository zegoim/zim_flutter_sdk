import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClearChatLogsItem extends StatefulWidget {
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
          Text(
            'clear chat logs',
            style: TextStyle(color: Colors.red),
            textScaleFactor: 1.2,
            
          ),
        ],
      ),
    );
  }
}
