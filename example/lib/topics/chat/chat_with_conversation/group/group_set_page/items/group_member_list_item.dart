import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';

import 'group_member_avatar_item.dart';

class GroupMemberListItem extends StatefulWidget {
  GroupMemberListItem({required this.groupID}) {
    groupMemberQueryConfig.count = 20;
  }

  String groupID;

  ZIMGroupMemberQueryConfig groupMemberQueryConfig =
      ZIMGroupMemberQueryConfig();

  List<ZIMGroupMemberInfo> userList = [];
  List<GroupMemberAvatarItem> userWidgetList = [];
  @override
  State<StatefulWidget> createState() => GroupMemberListItemState();
}

class GroupMemberListItemState extends State<GroupMemberListItem> {
  @override
  void initState() {
    if (widget.userWidgetList.isEmpty) {
      queryMoreGroupMember(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        constraints: BoxConstraints(maxHeight: 300),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
        ),
        child: SingleChildScrollView(
          child: GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 0.8),
              children: widget.userWidgetList),
        ));
  }

  queryMoreGroupMember(bool isFistQuery) async {
    if (widget.groupMemberQueryConfig.nextFlag == 0 && !isFistQuery) {
      return;
    }

    ZIM
        .getInstance()
        !.queryGroupMemberList(widget.groupID, widget.groupMemberQueryConfig)
        .then((value) => {
              setState(() {
                widget.userList.addAll(value.userList);
                widget.groupMemberQueryConfig.nextFlag = value.nextFlag;
                List<GroupMemberAvatarItem> newUserWidgetList = [];
                newUserWidgetList.addAll(widget.userWidgetList);
                newUserWidgetList
                    .addAll(cnvGroupMemberListToWidgetList(value.userList));
                widget.userWidgetList = newUserWidgetList;
              }),
            });
  }

  List<GroupMemberAvatarItem> cnvGroupMemberListToWidgetList(
      List<ZIMGroupMemberInfo> groupMemberList) {
    List<GroupMemberAvatarItem> widgetList = [];
    for (ZIMGroupMemberInfo groupmemberInfo in groupMemberList) {
      GroupMemberAvatarItem groupMemberAvatarItem =
          GroupMemberAvatarItem(groupMemberInfo: groupmemberInfo);
      widgetList.add(groupMemberAvatarItem);
    }
    return widgetList;
  }
}
