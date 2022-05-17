// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zim/zim.dart';

void main() {
  group("static mod", () {
    testWidgets('getVersion', (WidgetTester tester) async {
      expect(await ZIM.getInstance().getVersion(), '2.1.1.612');
    });

    testWidgets('create', (WidgetTester tester) async {
      await ZIM.getInstance().create(2845718148);
    });

    testWidgets('destroy', (WidgetTester tester) async {
      await ZIM.getInstance().destroy();
    });

    // testWidgets('setLogConfig', (WidgetTester tester) async {
    //   ZIMLogConfig config = ZIMLogConfig(logPath: 'logPath', logSize: 10);
    //   await ZIM.getInstance().setLogConfig(config);
    // });

    // testWidgets('setCacheConfig', (WidgetTester tester) async {
    //   ZIMCacheConfig config = ZIMCacheConfig(cachePath: 'cachePath');
    //   await ZIM.getInstance().setCacheConfig(config);
    // });
  });

  group('login mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
    });

    tearDown(() async {
      await ZIM.getInstance().destroy();
    });

    testWidgets('login_uploadLog_logout', (WidgetTester tester) async {
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
      await ZIM.getInstance().uploadLog();
      await ZIM.getInstance().logout();
    });
  });

  group('main mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDown(() async {
      await ZIM.getInstance().destroy();
    });

    testWidgets('queryUsersInfo', (WidgetTester tester) async {
      await ZIM.getInstance().queryUsersInfo(['510']).then(
          (value) => {expect(value.userList.first.userID, '510')});
    });
  });

  group('room_mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDown(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });
    testWidgets('create_room', (WidgetTester tester) async {
      ZIMRoomInfo roomInfo = ZIMRoomInfo(roomID: 'flutterTestRoom1');
      await ZIM.getInstance().createRoom(roomInfo);
    });
  });

  group('msg_mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });
    tearDown(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    testWidgets('send_c2c_msg', (WidgetTester tester) async {
      ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
      ZIMMessageSendConfig sendConfig =
          ZIMMessageSendConfig(priority: ZIMMessagePriority.high);
      await ZIM
          .getInstance()
          .sendPeerMessage(txtMsg, '510', sendConfig)
          .then((value) => {});
    });
  });

  group('conv_mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
      await ZIM.getInstance().login('fluttertest1', '',
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDown(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    testWidgets('send_c2c_msg', (WidgetTester tester) async {
      ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
      ZIMMessageSendConfig sendConfig =
          ZIMMessageSendConfig(priority: ZIMMessagePriority.high);
      await ZIM
          .getInstance()
          .sendPeerMessage(txtMsg, '510', sendConfig)
          .then((value) => {});
    });

    testWidgets('que_conv_list', (WidgetTester tester) async {
      ZIMConversationQueryConfig config = ZIMConversationQueryConfig();
      config.count = 20;
      await ZIM.getInstance().queryConversationList(config).then((value) => {});
    });

    testWidgets('clear_conv', (WidgetTester tester) async {
      await ZIM
          .getInstance()
          .clearConversationUnreadMessageCount('510', ZIMConversationType.peer);
    });

    // testWidgets('set_conv_note', (WidgetTester tester) async {
    //   await ZIM
    //       .getInstance()
    //       .setConversationNotificationStatus(
    //           ZIMConversationNotificationStatus.doNotDisturb,
    //           '510',
    //           ZIMConversationType.peer)
    //       .catchError((onError) {
    //     onError as PlatformException;
    //     expect(onError.code, '6000001');
    //   });
    // });

    testWidgets('dele_conv', (WidgetTester tester) async {
      ZIMConversationDeleteConfig deleteConfig = ZIMConversationDeleteConfig();
      deleteConfig.isAlsoDeleteServerConversation = true;
      await ZIM
          .getInstance()
          .deleteConversation('510', ZIMConversationType.peer, deleteConfig);
    });
  });
}
