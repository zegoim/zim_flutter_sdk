import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (!mounted) return;

    // ZIMEventHandlerImpl.registerEventHandler();
    // ZIMEventHandler.onConnectionStateChanged = connectionStateChanged;
    // ZIMEventHandler.onConnectionStateChanged =
    //     (ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
    //   print(state);
    //   print(event);
    //   print(extendedData);
    // };

    await ZIM.getInstance().create(2845718148);
    try {
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    } on PlatformException catch (error) {
      print(error.code);
    }
    ;

    // await ZIM
    //     .getInstance()
    //     .login('9999', '', '22')
    //     .then((value) {})
    //     .catchError((onError) {
    //   if (onError is PlatformException) {
    //     print(onError.code);
    //     print(onError.message);
    //   }
    // });

    ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
    ZIMMessageSendConfig config =
        ZIMMessageSendConfig(priority: ZIMMessagePriority.high);
    // await ZIM.getInstance().sendPeerMessage(txtMsg, '510', config);
    ZIMConversationDeleteConfig deleteConfig = ZIMConversationDeleteConfig();
    deleteConfig.isAlsoDeleteServerConversation = true;

    // await ZIM.getInstance().setConversationNotificationStatus(
    //     ZIMConversationNotificationStatus.doNotDisturb,
    //     '510',
    //     ZIMConversationType.peer);
    // await ZIM
    //     .getInstance()
    //     .deleteConversation('510', ZIMConversationType.peer, deleteConfig);

    await ZIM
        .getInstance()
        .clearConversationUnreadMessageCount('510', ZIMConversationType.peer);
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

  // connectionStateChanged(
  //     ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData) {
  //   print(state);
  //   print(event);
  //   print(extendedData);
  // }
}
