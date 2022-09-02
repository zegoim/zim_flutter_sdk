import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/chat/chat_without_conversation/room/room_chat_page.dart';

import '../../items/dia_log_items/error_dia_log.dart';

class JoinRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<JoinRoomPage> {
  String targetRoomID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Join Room',
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
                          targetRoomID = value;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 0, left: 15, right: 15),
                            border: InputBorder.none,
                            labelText: 'Room ID'),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: (() async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        try {
                          ZIMRoomJoinedResult result = await ZIM.getInstance()!.joinRoom(targetRoomID);

                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                            return RoomChatPage(roomID: result.roomInfo.baseInfo.roomID,roomName: result.roomInfo.baseInfo.roomName,);
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
