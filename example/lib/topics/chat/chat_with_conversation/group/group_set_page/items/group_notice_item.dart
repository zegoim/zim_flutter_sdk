import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSetPageNoticeItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GroupSetPageNoticeItemState();
}

class GroupSetPageNoticeItemState extends State<GroupSetPageNoticeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9)),
            top: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
      ),
      // color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Notice',
                style: TextStyle(),
                textScaleFactor: 1.2,
              ),
              Text(
                'awdawdawdawdawdawd3244134124124124124121231232124124214124awdawd',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
          IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right_outlined,color: Colors.grey,))
        ],
      ),
    );
  }
}
