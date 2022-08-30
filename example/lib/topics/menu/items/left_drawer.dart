import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';


import '../../login/login_page.dart';

class Left_drawer extends StatelessWidget {
  const Left_drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.person,
                        size: 40.0,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserModel.shared().userInfo!.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(UserModel.shared().userInfo!.userID)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.arrow_back),
                    title: const Text('logout'),
                    onTap: () async {
                      try {
                        await ZIM.getInstance()!.logout();
                        UserModel.release();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userID', '');
                        await prefs.setString('userName', '');
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: ((context) {
                          return LoginPage();
                        })), (route) => false);
                      } on PlatformException catch (onError) {
                        log('log out error');
                      }
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.settings),
                  //   title: const Text('Manage accounts'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
