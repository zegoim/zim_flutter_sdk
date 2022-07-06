import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_chat_page.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/group/group_set_page/group_set_page.dart';
import 'package:zego_zim_example/topics/chat/chat_with_conversation/peer/peer_chat_page.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';

import 'dart:async';

import 'package:zego_zim_example/topics/splash/splash_page.dart';

Future<void> main() async {
  
  runApp(MaterialApp(
    title: 'ZIM',
    debugShowCheckedModeBanner: false,
    home: //GroupSetPage()
        SplashPage(),
    navigatorObservers: [UserModel.shared().routeObserver],
  ));
}
