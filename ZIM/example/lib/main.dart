import 'package:flutter/material.dart';
import 'dart:async';

import 'package:zim/zim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // try {
    //   platformVersion = await ZIM.platformVersion ?? 'Unknown platform version';
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    ZIMEventHandlerImpl.registerEventHandler();
    ZIMEventHandler.onConnectionStateChanged = connectionStateChanged;
    ZIMEventHandler.onConnectionStateChanged =
        (ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
      print(state);
      print(event);
      print(extendedData);
    };
    //ZIMMessage fileMsg = ZIMFileMessage();

    ZIMMessage txtMsg = ZIMTextMessage();
    //print(fileMsg is ZIMMediaMessage);
    print(txtMsg is ZIMMediaMessage);
    await ZIM.getInstance().create(2845718148);
    try {
      await ZIM.getInstance().login('510', '',
          '04AAAAAGJ/iRwAEGRiNm95ZTRkcXNuYmx6OGgAcE5Tptt0hDv/whOdCAi3pBAu0j/C7lV3uE0/aVScezQ/h8yUUXUSzf5BJOXWJmdcLVM3Q2dqDFnDQVRVksHvSaxgMf7S4E/r3DsiBzq755z6N1gq6g6WdvRblIbfwUsn+OvzMC3lFTGQzvT2BgR5c+I=');
    } on PlatformException catch (error) {
      print(error.code);
    }
    ;

    // ZIM
    //     .getInstance()
    //     .login('9999', '', '22')
    //     .then((value) {})
    //     .catchError((onError) {
    //   if (onError is PlatformException) {
    //     print(onError.code);
    //     print(onError.message);
    //   }
    // });
    //if (result.errorInfo.code != ZIMErrorCode.success) print('loginfaild');
    ZIM.getInstance().createRoom(ZIMRoomInfo());
    ZIM.getInstance().createRoom(ZIMRoomInfo(), ZIMRoomAdvancedConfig());
    ZIM.getInstance().setConversationNotificationStatus(
        ZIMConversationNotificationStatus.notify,
        'id',
        ZIMConversationType.group);
    setState(() {
      //_platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  connectionStateChanged(
      ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
    print(state);
    print(event);
    print(extendedData);
  }
}
