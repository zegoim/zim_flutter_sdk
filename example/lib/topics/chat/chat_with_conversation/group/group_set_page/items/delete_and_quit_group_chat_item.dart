import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';

class DeleteAndQuitGroupChatItem extends StatefulWidget {
  DeleteAndQuitGroupChatItem({required this.groupID});
  String groupID;
  @override
  State<StatefulWidget> createState() => DeleteAndQuitGroupChatItemState();
}

class DeleteAndQuitGroupChatItemState
    extends State<DeleteAndQuitGroupChatItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9)),
            top: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
      ),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              ZIMConversationDeleteConfig deleteConfig =
                    ZIMConversationDeleteConfig();
                deleteConfig.isAlsoDeleteServerConversation = false;
              try {
                ZIM
                    .getInstance()
                    !.leaveGroup(widget.groupID)
                    .then((value) => {
                      ZIM.getInstance()!.deleteConversation(widget.groupID, ZIMConversationType.group, deleteConfig)
                    });
                
                Navigator.pop(context);
                Navigator.pop(context);
              } on PlatformException catch (onError) {}
            },
            child: Text(
              'delete and quit group chat',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
