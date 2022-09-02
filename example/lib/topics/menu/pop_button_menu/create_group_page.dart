import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_chat_page.dart';

import '../../items/dia_log_items/error_dia_log.dart';

class CreateGroupPage extends StatefulWidget {
  String targetGroupID = '';
  String targetGroupName = '';
  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Group',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
          shadowColor: Colors.white,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
              );
            },
          ),
        ),
        body: GestureDetector(
            onTap: (() {
              FocusScope.of(context).requestFocus(FocusNode());
            }),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.25),
                        borderRadius: BorderRadius.circular((20.0)),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          widget.targetGroupID = value;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 0, left: 15, right: 15),
                            border: InputBorder.none,
                            labelText: 'Group ID'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.25),
                        borderRadius: BorderRadius.circular((20.0)),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          widget.targetGroupName = value;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 0, left: 15, right: 15),
                            border: InputBorder.none,
                            labelText: 'Group Name'),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: (() async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        try {
                          ZIMGroupInfo zimGroupInfo = ZIMGroupInfo();
                          zimGroupInfo.groupID = widget.targetGroupID;
                          zimGroupInfo.groupName = widget.targetGroupName;
                          ZIMGroupCreatedResult result = await ZIM
                              .getInstance()
                              !.createGroup(zimGroupInfo, []);
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return GroupChatPage(
                                conversationID:
                                    result.groupInfo.baseInfo.groupID,
                                conversationName:
                                    result.groupInfo.baseInfo.groupName);
                          })));
                        } on PlatformException catch (onError) {
                          ErrorDiaLog.showFailedDialog(
                              context, onError.code, onError.message!);
                        }
                      }),
                      child: const Text('OK'),
                    ),
                  ],
                ))));
  }
}
