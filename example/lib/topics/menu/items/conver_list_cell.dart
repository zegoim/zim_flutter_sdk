import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:badges/badges.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_chat_page.dart';

import '../../chat/chat_with_conversation/peer/peer_chat_page.dart';

class ConverListCell extends StatefulWidget {
  ZIMConversation conversation;

  ConverListCell(ZIMConversation zimConversation)
      : conversation = zimConversation;

  String getTitleValue() {
    String targetTitle;
    if (conversation.conversationName != '') {
      targetTitle = conversation.conversationName;
    } else {
      targetTitle = conversation.conversationID;
    }
    return targetTitle;
  }

  bool get isShowBadge {
    if (conversation.unreadMessageCount == 0) {
      return false;
    } else {
      return true;
    }
  }

  String getTime() {
    if (conversation.lastMessage == null) {
      return '';
    }
    // 时间显示，刚刚，x分钟前

    // 当前时间
    int timeStamp = (conversation.lastMessage!.timestamp / 1000).round();

    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    // 对比
    int _distance = time - timeStamp;
    if (_distance <= 60) {
      //return 'now';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (_distance <= 3600) {
      // return '${(_distance / 60).floor()} mintues ago';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (_distance <= 43200) {
      // return '${(_distance / 60 / 60).floor()} hours ago';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else {
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'YY/MM/DD hh:mm', toInt: false)}';
    }
  }

  // 时间戳转时间
  String CustomStamp_str({
    int? Timestamp, // 为空则显示当前时间
    String? Date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
    bool toInt = true, // 去除0开头
  }) {
    Timestamp ??= (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    String Time_str =
        (DateTime.fromMillisecondsSinceEpoch(Timestamp * 1000)).toString();

    dynamic Date_arr = Time_str.split(' ')[0];
    dynamic Time_arr = Time_str.split(' ')[1];

    String YY = Date_arr.split('-')[0];
    String MM = Date_arr.split('-')[1];
    String DD = Date_arr.split('-')[2];

    String hh = Time_arr.split(':')[0];
    String mm = Time_arr.split(':')[1];
    String ss = Time_arr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      MM = (int.parse(MM)).toString();
      DD = (int.parse(DD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (Date == null) {
      return Time_str;
    }

    Date = Date.replaceAll('YY', YY)
        .replaceAll('MM', MM)
        .replaceAll('DD', DD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);

    return Date;
  }

  IconData getAvatar() {
    IconData targetIcon;
    switch (conversation.type) {
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
    if (conversation.lastMessage == null) return '';
    switch (conversation.lastMessage!.type) {
      case ZIMMessageType.text:
        targetMessage = (conversation.lastMessage as ZIMTextMessage).message;
        break;
      case ZIMMessageType.command:
        targetMessage = '[cmd]';
        break;
      case ZIMMessageType.barrage:
        targetMessage = (conversation.lastMessage as ZIMBarrageMessage).message;
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
  State<StatefulWidget> createState() => _MyState();
}

class _MyState extends State<ConverListCell> {
  @override
  Widget build(BuildContext context) {
    //最外层容器
    return GestureDetector(
      onTap: () {
        switch (widget.conversation.type) {
          case ZIMConversationType.peer:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return PeerChatPage(
                    conversationID: widget.conversation.conversationID,
                    conversationName: widget.conversation.conversationName,
                  );
                }),
              ),
            );
            break;
          case ZIMConversationType.group:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return GroupChatPage(
                    conversationID: widget.conversation.conversationID,
                    conversationName: widget.conversation.conversationName,
                  );
                }),
              ),
            );
            break;
          default:
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
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
              child: Badge(
                showBadge: widget.isShowBadge,
                toAnimate: false,
                badgeContent: Text(
                  widget.conversation.unreadMessageCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Icon(
                    widget.getAvatar(),
                    size: 45,
                  ),
                ),
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
                    widget.getTitleValue(),
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF353535)),
                    maxLines: 1,
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(
                    widget.getLastMessageValue(),
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
                child: Column(
                  children: [
                    Text(
                      widget.getTime(),
                      style: const TextStyle(
                          fontSize: 14.0, color: Color(0xFFa9a9a9)),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
