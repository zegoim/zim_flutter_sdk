import 'package:flutter/material.dart';

class DeleteAndQuitGroupChatItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeleteAndQuitGroupChatItemState();
}

class DeleteAndQuitGroupChatItemState
    extends State<DeleteAndQuitGroupChatItem> {
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
            'delete and quit group chat',
            style: TextStyle(color: Colors.red),
            textScaleFactor: 1.2,
            
          ),
        ],
      ),
    );
  }
      
}
