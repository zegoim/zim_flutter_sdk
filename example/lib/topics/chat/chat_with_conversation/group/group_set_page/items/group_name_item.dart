import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';

class GroupSetPageNameItem extends StatefulWidget {
  GroupSetPageNameItem({required this.groupName, required this.groupID}) {}
  String newGroupName = '';
  String groupName;
  String groupID;
  @override
  State<StatefulWidget> createState() => GroupSetPageNameItemState();
}

class GroupSetPageNameItemState extends State<GroupSetPageNameItem> {
  get groupName {
    if (widget.groupName == '') {
      return 'unnamed';
    } else {
      return widget.groupName;
    }
  }

  showUpdateGroupNameDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Group Name'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.25),
                      //borderRadius: BorderRadius.circular((20.0)),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        widget.newGroupName = value;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, left: 15, right: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            log('start');
                            ZIMGroupNameUpdatedResult result = await ZIM
                                .getInstance()!
                                .updateGroupName(
                                    widget.newGroupName, widget.groupID);
                            
                            setState(() {
                              widget.groupName = result.groupName;
                            });
                          } on PlatformException catch (onError) {}
                          Navigator.pop(context);
                        },
                        child: Text('OK')),
                  )
                ],
              ));
        });
  }

  @override
  void initState() {
    // queryGroupInfo();
    // registerZIMEvent();

    super.initState();
  }

  // queryGroupInfo() async {
  //   ZIMGroupInfoQueriedResult result =
  //       await ZIM.getInstance().queryGroupInfo(widget.groupID);
  //   setState(() {
  //     widget.groupName = result.groupInfo.baseInfo.groupName;
  //   });
  // }

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
          Text(
            groupName,
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
              onPressed: () {
                showUpdateGroupNameDialog();
              },
              icon: Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  // registerZIMEvent() {
  //   ZIMEventHandler.onGroupNameUpdated = (groupName, operatedInfo, groupID) {
  //     if (groupID != widget.groupID) {
  //       return;
  //     }
  //     setState(() {
  //       widget.groupName = groupName;
  //     });
  //   };
  // }
}
