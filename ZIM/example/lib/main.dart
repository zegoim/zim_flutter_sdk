import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
    ZIMEventHandler.connectionStateChanged = connectionStateChanged;
    ZIMEventHandler.connectionStateChanged =
        (ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
      print(state);
      print(event);
      print(extendedData);
    };
    await ZIM.getInstance().create(2845718148);
    try {
      await ZIM.getInstance().login('9999', '',
          '04AAAAAGJeX6YAEHh0OW80dHRydTZvZzk2bDkAcLYmuuOm3WkEmLIfvxavR5bJM7Xx5PSshKjS0wo127wCzuUcQyE6vQyzcmdZaPUrovsu/CcgVac8w/ITGEbtcN0jXIHVCEwq6OB3mGDvF5xtosghn0LfpzFSg+7yd1vxQVNvKadQO+j7kjo4yslPRPw=');
    } on PlatformException catch (error) {
      print(error.code);
    }
    ;

    ZIM
        .getInstance()
        .login('9999', '', '22')
        .then((value) {})
        .catchError((onError) {
      if (onError is PlatformException) {
        print(onError.code);
        print(onError.message);
      }
    });
    //if (result.errorInfo.code != ZIMErrorCode.success) print('loginfaild');
    ZIM.getInstance().createRoom(ZIMRoomInfo());
    ZIM.getInstance().createRoom(ZIMRoomInfo(), ZIMRoomAdvancedConfig());
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
