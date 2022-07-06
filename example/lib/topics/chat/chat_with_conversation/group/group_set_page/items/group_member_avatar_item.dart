import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/avatar_items/user_avatar_item.dart';

class GroupMemberAvatarItem extends StatefulWidget {
  GroupMemberAvatarItem({required this.groupMemberInfo});
  ZIMGroupMemberInfo groupMemberInfo;
  @override
  State<StatefulWidget> createState() => GroupMemberAvatarItemState();
}

class GroupMemberAvatarItemState extends State<GroupMemberAvatarItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints(maxWidth: 100,maxHeight: 100),
      child: Column(
        children: [
          UserAvatarItem(),
          Text(
            widget.groupMemberInfo.userID,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
