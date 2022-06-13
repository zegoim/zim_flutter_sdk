import 'package:flutter/material.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list.dart';
import 'package:zego_zim_example/topics/menu/items/group_list.dart';
import 'package:zego_zim_example/topics/menu/items/left_drawer.dart';
import 'package:zego_zim_example/topics/menu/pop_button_menu/create_peer_page.dart';

class MenuPage extends StatefulWidget {
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
        {
          _converList ??= ConverList();
          return _converList;
        }
      case 1:
        {
          _groupList ??= GroupList();
          return _groupList;
        }

      default:
    }
  }

  recentAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        {
          return const Text(
            'ZEGO IM',
            style: TextStyle(color: Colors.black),
          );
        }
      case 1:
        {
          return const Text(
            'Group List',
            style: TextStyle(color: Colors.black),
          );
        }

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: recentAppBarTitle(),
        backgroundColor: Colors.white70,
        shadowColor: Colors.white,

        actions: <Widget>[
          //导航栏
          PopupMenuButton(
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
                  child: Text('create peer'),
                  onTap: () async{
                    await Future.delayed(Duration.zero);
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return CreatePeerPage();
                    })));
                  },
                ),
                PopupMenuItem<String>(
                  value: 'createRoom',
                  child: Text('create room'),
                ),
                PopupMenuItem<String>(
                  value: 'joinRoom',
                  child: Text('join room'),
                ),
                PopupMenuItem<String>(
                  value: 'createGroup',
                  child: Text('create group'),
                ),
                PopupMenuItem<String>(
                  value: 'joinGroup',
                  child: Text('join group'),
                ),
              ];
            },
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.add_sharp),
          //   color: Colors.black,
          // )
        ],
        //返回按钮
        //Icon(Icons.arrow_back)
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.format_list_bulleted_sharp),
            color: Colors.black,
          );
        }),
      ),
      drawer: Left_drawer(),
      body: recentItem(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.format_list_bulleted_sharp),
          )
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
