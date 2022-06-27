import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSetPageNameItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GroupSetPageNameItemState();
}

class GroupSetPageNameItemState extends State<GroupSetPageNameItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Group Name',
            style: TextStyle(),
            textScaleFactor: 1.2,
          ),
          Expanded(child: Container()),
          Text('ture name',style: TextStyle(color: Colors.grey),),
          IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right_outlined,color: Colors.grey,))
        ],
      ),
    );
  }
}
