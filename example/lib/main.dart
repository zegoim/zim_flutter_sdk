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
  ZIMAppConfig appConfig = ZIMAppConfig();
  appConfig.appID = 2845718148;
  appConfig.appSign = "3b816217d8ef304a81181690c053e4c68b178dc3e7cd450a47b44485a9c795ce";
  ZIM.create(appConfig);
  ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
  sendConfig.pushConfig = ZIMPushConfig();
  ZIMVoIPConfig voIPConfig = ZIMVoIPConfig();
  voIPConfig.iOSVoIPHasVideo = true;
  voIPConfig.iOSVoIPHandleValue = "510";
  voIPConfig.iOSVoIPHandleType = ZIMCXHandleType.generic;

  ZIMPushConfig pushConfig = ZIMPushConfig();
  pushConfig.title = "title";
  pushConfig.content = "content";
  pushConfig.payload = "payload";
  pushConfig.resourcesID = "resourceid";
  pushConfig.voIPConfig = voIPConfig;
  sendConfig.pushConfig = pushConfig;

  ZIM.getInstance()!.sendMessage(ZIMTextMessage(message: 'message'), "toConversationID", ZIMConversationType.peer, sendConfig);
}
