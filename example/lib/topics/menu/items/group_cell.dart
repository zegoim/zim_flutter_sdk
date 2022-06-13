import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupListCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
              child: Icon(
                Icons.group,
                size: 45,
              ),
            ),
            Column(
                    //垂直方向居中对齐
                    mainAxisAlignment: MainAxisAlignment.center,
                    //水平方向靠左对齐
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'group name',
                        style:
                            TextStyle(fontSize: 16.0, color: Color(0xFF353535)),
                        maxLines: 1,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 8.0)),
                      Text(
                        'groupID',
                        style:
                            TextStyle(fontSize: 14.0, color: Color(0xFFa9a9a9)),
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