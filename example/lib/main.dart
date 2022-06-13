import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/menu/menu_page.dart';
import 'package:zego_zim_example/topics/conversation/peer/peer_chat_page.dart';
import 'package:zego_zim_example/topics/menu/pop_button_menu/create_peer_page.dart';
import 'package:zego_zim_example/topics/splash/splash_page.dart';

Future<void> main() async {
  runApp(MaterialApp(
    title: 'ZIM',
    home: //CreatePeerPage(),
    SplashPage(),
  ));
  ZIM.getInstance().create(<#AppID#>);
}

