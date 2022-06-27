import 'package:flutter/material.dart';

import 'create_group_page.dart';
import 'create_peer_page.dart';
import 'create_room_page.dart';
import 'join_group_page.dart';
import 'join_room_page.dart';

class MenuRightPopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.add_sharp,
        color: Colors.black,
      ),
      onSelected: (value) {
        switch (value) {
          case 'createPeer':
            //TODO
            break;
          default:
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'createPeer',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.person_add_alt_outlined,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Create Peer'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CreatePeerPage();
              })));
            },
          ),
          PopupMenuItem<String>(
            value: 'createRoom',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.home_work_outlined,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Create Room'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CreateRoomPage();
              })));
            },
          ),
          PopupMenuItem<String>(
            value: 'joinRoom',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.home_work,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Join Room'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return JoinRoomPage();
              })));
            },
          ),
          PopupMenuItem<String>(
            value: 'createGroup',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.group_add_outlined,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Create Group'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CreateGroupPage();
              })));
            },
          ),
          PopupMenuItem<String>(
            value: 'joinGroup',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.group_add,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Join Group'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return JoinGroupPage();
              })));
            },
          ),
        ];
      },
    );
  }
}
