import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/conversation/peer/peer_chat_page.dart';

class ConverListCell extends StatelessWidget {
  ZIMConversation _conversation;

  ConverListCell(ZIMConversation zimConversation)
      : _conversation = zimConversation;

  String getTitleValue() {
    String targetTitle;
    if (_conversation.conversationName != '') {
      targetTitle = _conversation.conversationName;
    } else {
      targetTitle = _conversation.conversationID;
    }
    return targetTitle;
  }

  IconData getAvatar() {
    IconData targetIcon;
    switch (_conversation.type) {
      case ZIMConversationType.peer:
        targetIcon = Icons.person;
        break;
      case ZIMConversationType.room:
        targetIcon = Icons.home_sharp;
        break;
      case ZIMConversationType.group:
        targetIcon = Icons.people;
        break;
      default:
        targetIcon = Icons.person;
    }
    return targetIcon;
  }

  String getLastMessageValue() {
    String targetMessage;
    if (_conversation.lastMessage == null) return '';
    switch (_conversation.lastMessage!.type) {
      case ZIMMessageType.text:
        targetMessage = (_conversation.lastMessage as ZIMTextMessage).message;
        break;
      case ZIMMessageType.command:
        targetMessage = '[cmd]';
        break;
      case ZIMMessageType.barrage:
        targetMessage =
            (_conversation.lastMessage as ZIMBarrageMessage).message;
        break;
      case ZIMMessageType.audio:
        targetMessage = '[audio]';
        break;
      case ZIMMessageType.video:
        targetMessage = '[video]';
        break;
      case ZIMMessageType.file:
        targetMessage = '[file]';
        break;
      case ZIMMessageType.image:
        targetMessage = '[image]';
        break;
      default:
        {
          targetMessage = '[unknown message type]';
        }
    }
    return targetMessage;
  }

  @override
  Widget build(BuildContext context) {
    //最外层容器
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return PeerChatPage(_conversation);
        })));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xFFd9d9d9))),
        ),
        height: 64.0,
        child: Row(
          //垂直方向居中显示
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //展示头像
            Container(
              margin: const EdgeInsets.only(left: 13.0, right: 13.0),
              child:  Icon(
                getAvatar(),
                size: 45,
              ),
            ),
            Expanded(
              //主标题和子标题采用垂直布局
              child: Column(
                //垂直方向居中对齐
                mainAxisAlignment: MainAxisAlignment.center,
                //水平方向靠左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getTitleValue(),
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF353535)),
                    maxLines: 1,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(
                    getLastMessageValue(),
                    style: TextStyle(fontSize: 14.0, color: Color(0xFFa9a9a9)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Container(
              //时间顶部对齐
              alignment: AlignmentDirectional.topStart,
              margin: const EdgeInsets.only(right: 12.0, top: 12.0),
              child: Text(
                DateTime.now().toString(),
                style:
                    const TextStyle(fontSize: 14.0, color: Color(0xFFa9a9a9)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
