import 'package:flutter/material.dart';
import 'group_cell.dart';

class GroupList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
              //动态创建一个List<Widget>
              children: <Widget>[
                GroupListCell()
              ]),
        ),
      ),
    );
  }
}
