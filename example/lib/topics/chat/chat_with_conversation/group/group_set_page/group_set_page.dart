import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_set_page/items/group_member_list_item.dart';

import 'items/clear_chat_logs_item.dart';
import 'items/delete_and_quit_group_chat_item.dart';
import 'items/group_name_item.dart';
import 'items/group_notice_item.dart';
import 'items/transfer_group_ownership_item.dart';

class GroupSetPage extends StatefulWidget {
  GroupSetPage(
      {required this.myGroupMemberInfo, required this.myGroupFullInfo});
  ZIMGroupMemberInfo myGroupMemberInfo;
  ZIMGroupFullInfo myGroupFullInfo;

  @override
  State<StatefulWidget> createState() => GroupSetPageState();
}

class GroupSetPageState extends State<GroupSetPage> {
  bool isGroupOwner() {
    if (widget.myGroupMemberInfo.memberRole == ZIMGroupMemberRole.owner) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerZIMEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          //  shadowColor: Colors.transparent,
          title: Text(
            'Group Manager',
            style: TextStyle(color: Colors.black),
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
                color: Colors.black,
              );
            },
          ),
        ),
        body: Scrollbar(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GroupMemberListItem(
                    groupID: widget.myGroupFullInfo.baseInfo.groupID,
                  ),
                  GroupSetPageNameItem(
                      groupName: widget.myGroupFullInfo.baseInfo.groupName,
                      groupID: widget.myGroupFullInfo.baseInfo.groupID),
                  GroupSetPageNoticeItem(
                    groupID: widget.myGroupFullInfo.baseInfo.groupID,
                    groupNotice: widget.myGroupFullInfo.groupNotice,
                  ),
                  // Offstage(
                  //   offstage: !isGroupOwner(),
                  //   child: TransferGroupOwnershipItem(),
                  // ),
                  ClearChatLogsItem(conversationID: widget.myGroupFullInfo.baseInfo.groupID,conversationType: ZIMConversationType.group,),
                  DeleteAndQuitGroupChatItem(groupID: widget.myGroupFullInfo.baseInfo.groupID,)
                ],
              ),
            ),
          ),
        ));
  }

  registerZIMEvent() {
    ZIMEventHandler.onGroupNameUpdated = (zim, groupName, operatedInfo, groupID) {
      if (groupID != widget.myGroupFullInfo.baseInfo.groupID) {
        return;
      }
      setState(() {
        widget.myGroupFullInfo.baseInfo.groupName = groupName;
      });
    };

    ZIMEventHandler.onGroupNoticeUpdated =
        (zim, groupNotice, operatedInfo, groupID) {
      if (groupID != widget.myGroupFullInfo.baseInfo.groupID) {
        return;
      }
      setState(() {
        widget.myGroupFullInfo.groupNotice = groupNotice;
      });
    };
  }
}
