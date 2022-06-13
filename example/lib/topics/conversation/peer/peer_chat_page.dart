import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/conversation/conver_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_list.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list_cell.dart';

import '../../items/msg_items/msg_common_bottom_dia_log_box.dart';

class PeerChatPage extends StatefulWidget {
  ConverModel _myModel;
  PeerChatPage(ZIMConversation conversation)
      : _myModel = ConverModel(conversation: conversation);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<PeerChatPage> {

  String getAppBarTitleStringValue() {
    if (widget._myModel.conversation.conversationName != '') {
      return widget._myModel.conversation.conversationName;
    } else {
      return widget._myModel.conversation.conversationID;
    }
  }

  @override
  appBarTitle() {
    return Text(
      getAppBarTitleStringValue(),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(),
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
        child: MsgList(converModel: widget._myModel),
      ),
      backgroundColor: Colors.grey[100],
      bottomSheet: BottomDiaLogBox(myModel: widget._myModel),
    );
  }
}
