import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/key_center/04_token_plugin/04_token_plugin.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list.dart';
import 'package:zego_zim_example/topics/menu/items/group_list.dart';
import 'package:zego_zim_example/topics/menu/items/left_drawer.dart';
import 'package:zego_zim_example/topics/menu/pop_button_menu/pop_button_menu.dart';
import 'package:provider/provider.dart';


class MenuPage extends StatefulWidget {
  int totalUnreadMsg = 0;
  bool isDisConnected = false;
  bool isConnecting = false;
  String recentAppBarTitle = "ZEGO IM";

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ConverList? _converList;
  GroupList? _groupList;

  recentItem() {
    switch (_selectedIndex) {
      case 0:
        _converList ??= ConverList();
        return _converList;
      case 1:
        _groupList ??= GroupList();
        return _groupList;
      default:
    }
  }

  bool get isShowBadge {
    if (widget.totalUnreadMsg == 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    registerZIMEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Offstage(
              offstage: !widget.isDisConnected,
              child: IconButton(
                  onPressed: () async {
                    try {
                      if (widget.isConnecting == true) {
                        return;
                      }
                      String token = await TokenPlugin.makeToken(
                          UserModel.shared().userInfo!.userID);
                      //await ZIM.getInstance().logout();
                      setState(() {
                        widget.isConnecting = true;
                        widget.isDisConnected = false;
                      });
                      await ZIM
                          .getInstance()
                          !.login(UserModel.shared().userInfo!, token);
                      setState(() {
                        widget.isConnecting = false;
                        widget.isDisConnected = false;
                      });
                      log('success');
                    } on PlatformException catch (error) {
                      setState(() {
                        widget.isConnecting = false;
                        widget.isDisConnected = true;
                      });
                      log(error.code.toString() + error.message!);
                    }
                  },
                  icon: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  )),
            ),
            Offstage(
                offstage: !widget.isConnecting,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.grey,
                  ),
                )),
            Text(
              widget.recentAppBarTitle,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white70,
        shadowColor: Colors.white,

        actions: <Widget>[
          //导航栏
          MenuRightPopButton()
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.format_list_bulleted_sharp),
            color: Colors.black,
          );
        }),
      ),
      drawer: const Left_drawer(),
      body: recentItem(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Message",
            icon: Badge(
              showBadge: isShowBadge,
              child: Icon(Icons.message),
              badgeContent: Text(
                widget.totalUnreadMsg.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Group members",
            icon: Icon(Icons.format_list_bulleted_sharp),
          ),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  registerZIMEvent() {
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (zim, totalUnreadMessageCount) {
      setState(() {
        widget.totalUnreadMsg = totalUnreadMessageCount;
      });
    };

    ZIMEventHandler.onConnectionStateChanged = (zim, state, event, extendedData) {
      switch (state) {
        case ZIMConnectionState.connected:
          setState(() {
            widget.isConnecting = false;
            widget.isDisConnected = false;
          });
          break;
        case ZIMConnectionState.connecting:
          setState(() {
            widget.isConnecting = true;
            widget.isDisConnected = false;
          });
          break;
        case ZIMConnectionState.disconnected:
          // switch (event) {
          //   case ZIMConnectionEvent.kickedOut:

          //     break;
          //   default:
          // }
          setState(() {
            widget.isDisConnected = true;
            widget.isConnecting = false;
          });
          break;

        case ZIMConnectionState.reconnecting:
          setState(() {
            widget.isDisConnected = false;
            widget.isConnecting = true;
          });
          break;
        default:
      }
    };
  }
}
