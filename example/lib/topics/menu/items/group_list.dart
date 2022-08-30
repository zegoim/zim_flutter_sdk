import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zego_zim/zego_zim.dart';
import 'group_cell.dart';

class GroupList extends StatefulWidget {

  List<ZIMGroup> _groupList = <ZIMGroup>[];
  List<GroupListCell> _groupWidgetList = <GroupListCell>[];

  @override
  State<StatefulWidget> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  

  @override
  void initState() {
    updateGroupList();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
              //动态创建一个List<Widget>
              children: widget._groupWidgetList),
        ),
      ),
    );
  }

  updateGroupList() async {
    List<GroupListCell> groupWidgetList = [];
    try {
      ZIMGroupListQueriedResult result =
          await ZIM.getInstance()!.queryGroupList();
      widget._groupList = result.groupList;
      for (ZIMGroup group in widget._groupList) {
        GroupListCell cell = GroupListCell(zimGroup: group);
        groupWidgetList.add(cell);
      }
      widget._groupWidgetList = groupWidgetList;
      setState(() {
        
      });
    } on PlatformException catch (onError) {}
  }
}
