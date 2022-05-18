import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:zim/zim.dart';
import 'zim_example_event_hander.dart';

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
    ZIMExampleEventHander.loadEventHandler();
    await ZIM.getInstance().create(2845718148);
    try {
      await ZIM.getInstance().login(ZIMUserInfo(userID: 'fluttertest1'),
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    } on PlatformException catch (error) {
      print(error.code);
    }
    ;
    ZIMRoomInfo roomInfo = ZIMRoomInfo(roomID: '111');
    ZIMRoomAdvancedConfig advancedConfig = ZIMRoomAdvancedConfig();
    await ZIM.getInstance().enterRoom(roomInfo, advancedConfig);
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

    // ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
    // ZIMMessageSendConfig config =
    //     ZIMMessageSendConfig(priority: ZIMMessagePriority.high);
    // // await ZIM.getInstance().sendPeerMessage(txtMsg, '510', config);
    // ZIMConversationDeleteConfig deleteConfig = ZIMConversationDeleteConfig();
    // deleteConfig.isAlsoDeleteServerConversation = true;
    // ZIMRoomInfo roomInfo = ZIMRoomInfo(roomID: 'flutterTestRoom1');
    // ZIMRoomAdvancedConfig roomAdvancedConfig = ZIMRoomAdvancedConfig();
    // roomAdvancedConfig.roomAttributes = {'flutter_key': 'flutter_value'};
    // roomAdvancedConfig.roomDestroyDelayTime = 10;
    // await ZIM
    //     .getInstance()
    //     .createRoom(roomInfo, roomAdvancedConfig)
    //     .then((value) => {value.roomInfo});

    // await ZIM
    //     .getInstance()
    //     .queryRoomAllAttributes('flutterTestRoom1')
    //     .then((value) => {});
    // await ZIM.getInstance().setConversationNotificationStatus(
    //     ZIMConversationNotificationStatus.doNotDisturb,
    //     '510',
    //     ZIMConversationType.peer);
    // await ZIM
    //     .getInstance()
    //     .deleteConversation('510', ZIMConversationType.peer, deleteConfig);

    ZIMGroupInfo groupInfo = ZIMGroupInfo();
    String groupID = '222';
    groupInfo.groupID = groupID;
    groupInfo.groupName = 'flutterGroupName';
    await ZIM.getInstance().joinGroup('777');
    ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
    queryConfig.count = 10;

    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();

    await ZIM.getInstance().sendGroupMessage(
        ZIMTextMessage(message: 'message1'), '777', sendConfig);
    await ZIM
        .getInstance()
        .queryHistoryMessage('777', ZIMConversationType.group, queryConfig)
        .then((value) => {print(value.conversationID)});
    // ZIMGroupAdvancedConfig advancedConfig = ZIMGroupAdvancedConfig();
    // advancedConfig.groupAttributes = {'key1': 'value1'};
    // advancedConfig.groupNotice = 'testNotice';
    // await ZIM
    //     .getInstance()
    //     .createGroup(groupInfo, [], advancedConfig)
    //     .then((value) => {});
    // await ZIM.getInstance().joinGroup('444');
    // await ZIM
    //     .getInstance()
    //     .setConversationNotificationStatus(
    //         ZIMConversationNotificationStatus.doNotDisturb,
    //         '444',
    //         ZIMConversationType.group)
    //     .then((value) => {print('success')});
    // ZIMCallInviteConfig callInviteConfig = ZIMCallInviteConfig();
    // callInviteConfig.timeout = 5;
    // callInviteConfig.extendedData = 'test';
    // await ZIM.getInstance().callInvite(['888'], callInviteConfig);
    // ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
    // ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    // await ZIM
    //     .getInstance()
    //     .sendPeerMessage(txtMsg, '888', sendConfig)
    //     .then((value) => {});
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
