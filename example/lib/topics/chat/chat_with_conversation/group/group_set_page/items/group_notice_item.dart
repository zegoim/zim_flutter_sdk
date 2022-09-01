import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

class GroupSetPageNoticeItem extends StatefulWidget {
  GroupSetPageNoticeItem({required this.groupNotice, required this.groupID});

  String groupID;
  String newGroupNotice = '';
  String groupNotice;
  @override
  State<StatefulWidget> createState() => GroupSetPageNoticeItemState();
}

class GroupSetPageNoticeItemState extends State<GroupSetPageNoticeItem> {
  get groupNotice {
    if (widget.groupNotice == '') {
      return 'group notice is empty';
    } else {
      return widget.groupNotice;
    }
  }

  showUpdateGroupNoticeDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Group Notice'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 100,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.25),
                      //borderRadius: BorderRadius.circular((20.0)),
                    ),
                    child: TextField(
                      maxLines: 20,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        widget.newGroupNotice = value;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, left: 15, right: 15),
                        border: InputBorder.none,
                        //labelText: 'Group Notice',
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
                          ZIMGroupNoticeUpdatedResult result = await ZIM
                              .getInstance()!
                              .updateGroupNotice(
                                  widget.newGroupNotice, widget.groupID);
                          setState(() {
                            widget.groupNotice = result.groupNotice;
                          });
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
    //  registerZIMEvent();
    super.initState();
  }

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
                groupNotice,
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
          IconButton(
              onPressed: () {
                showUpdateGroupNoticeDialog();
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
  //   ZIMEventHandler.onGroupNoticeUpdated =
  //       (groupNotice, operatedInfo, groupID) {
  //     setState(() {
  //       widget.groupNotice = groupNotice;
  //     });
  //   };
  // }
}
