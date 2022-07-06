import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../../chat/chat_with_conversation/group/group_chat_page.dart';

class GroupListCell extends StatefulWidget {
  ZIMGroup zimGroup;
  GroupListCell({required this.zimGroup});
  @override
  State<StatefulWidget> createState() => _MyState();
}

class _MyState extends State<GroupListCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return GroupChatPage(
                                conversationID:
                                    widget.zimGroup.baseInfo!.groupID,
                                conversationName:
                                    widget.zimGroup.baseInfo!.groupName,);
                          })));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
        ),
        height: 64.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 13.0, right: 13.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Icon(
                  Icons.group,
                  size: 45,
                ),
              ),
            ),
            Column(
              //垂直方向居中对齐
              mainAxisAlignment: MainAxisAlignment.center,
              //水平方向靠左对齐
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.zimGroup.baseInfo!.groupName,
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF353535)),
                  maxLines: 1,
                ),
                Padding(padding: const EdgeInsets.only(top: 8.0)),
                Text(
                  widget.zimGroup.baseInfo!.groupID,
                  style: TextStyle(fontSize: 14.0, color: Color(0xFFa9a9a9)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
