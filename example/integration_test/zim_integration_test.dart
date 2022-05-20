import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:zim/zim.dart';
import 'zim_example_test_common_tools.dart';


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
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
    });

    tearDownAll(() async {
      await ZIM.getInstance().destroy();
    });

    testWidgets('login_uploadLog_logout', (WidgetTester tester) async {
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
      await ZIM.getInstance().uploadLog();
      await ZIM.getInstance().logout();
    });
  });

  group('main mod', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDownAll(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    testWidgets('queryUsersInfo', (WidgetTester tester) async {
      await ZIM.getInstance().queryUsersInfo(['510']).then(
          (value) => {expect(value.userList.first.userID, '510')});
    });
  });

  group('enter_room', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });
    tearDownAll(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });
    testWidgets('create_leave_room', (WidgetTester tester) async {
      ZIMRoomInfo roomInfo = ZIMRoomInfo();
      roomInfo.roomID = 'flutterTestRoom1';
      await ZIM.getInstance().createRoom(roomInfo);
      await ZIM.getInstance().leaveRoom('flutterTestRoom1');
    });

    testWidgets('create_leave_room_with_config', (WidgetTester tester) async {
      ZIMRoomInfo roomInfo = ZIMRoomInfo();
      roomInfo.roomID = 'flutterTestRoom2';
      ZIMRoomAdvancedConfig roomAdvancedConfig = ZIMRoomAdvancedConfig();
      roomAdvancedConfig.roomAttributes = {'flutter_key': 'flutter_value'};
      roomAdvancedConfig.roomDestroyDelayTime = 10;
      await ZIM
          .getInstance()
          .createRoom(roomInfo, roomAdvancedConfig)
          .then((value) => {value.roomInfo});

      await ZIM.getInstance().queryRoomAllAttributes('flutterTestRoom2').then(
          (value) =>
              {expect(value.roomAttributes['flutter_key'], 'flutter_value')});
      await ZIM.getInstance().leaveRoom('flutterTestRoom2');
    });
  });
  group('room_activity', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
      ZIMRoomInfo roomInfo = ZIMRoomInfo();
      roomInfo.roomID = 'flutterTestRoom3';
      await ZIM.getInstance().createRoom(roomInfo);
    });
    tearDownAll(() async {
      ZIM.getInstance().leaveRoom('fluttertestRoom3');
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });
    testWidgets('query_room_member_list', (WidgetTester tester) async {
      ZIMRoomMemberQueryConfig config = ZIMRoomMemberQueryConfig();
      config.count = 10;
      await ZIM
          .getInstance()
          .queryRoomMemberList('flutterTestRoom3', config)
          .then((value) =>
              {expect((value.memberList.first).userID, 'fluttertest1')});
    });

    testWidgets('query_room_online_member_count', (WidgetTester tester) async {
      await ZIM
          .getInstance()
          .queryRoomOnlineMemberCount('flutterTestRoom3')
          .then((value) => {
                expect(value.count, 1),
                expect(value.roomID, 'flutterTestRoom3')
              });
    });

    testWidgets('room_attributes_activty', (WidgetTester tester) async {
      ZIMRoomAttributesSetConfig config = ZIMRoomAttributesSetConfig();
      config.isDeleteAfterOwnerLeft = true;
      config.isForce = true;
      config.isUpdateOwner = true;
      await ZIM.getInstance().setRoomAttributes({
        'key2': 'value2'
      }, 'flutterTestRoom3', config).then((value) => {
            expect(value.roomID, 'flutterTestRoom3'),
          });

      await ZIM
          .getInstance()
          .queryRoomAllAttributes('flutterTestRoom3')
          .then((value) => {expect(value.roomAttributes['key2'], 'value2')});

      ZIMRoomAttributesDeleteConfig deleteConfig =
          ZIMRoomAttributesDeleteConfig();
      deleteConfig.isForce = true;
      await ZIM.getInstance().deleteRoomAttributes([
        'key2'
      ], 'flutterTestRoom3', deleteConfig).then(
          (value) => {expect(value.roomID, 'flutterTestRoom3')});
      await ZIM
          .getInstance()
          .queryRoomAllAttributes('flutterTestRoom3')
          .then((value) => {expect(value.roomAttributes['key2'], null)});
    });

    testWidgets('batch_room_attributes_activty', (WidgetTester tester) async {
      ZIMRoomAttributesBatchOperationConfig batchOperationConfig =
          ZIMRoomAttributesBatchOperationConfig();
      await ZIM.getInstance().beginRoomAttributesBatchOperation(
          'flutterTestRoom3', batchOperationConfig);

      ZIMRoomAttributesSetConfig setConfig = ZIMRoomAttributesSetConfig();
      ZIM
          .getInstance()
          .setRoomAttributes({'key2': 'value2'}, 'flutterTestRoom3', setConfig);
      ZIM
          .getInstance()
          .setRoomAttributes({'key3': 'value3'}, 'flutterTestRoom3', setConfig);
      await ZIM
          .getInstance()
          .endRoomAttributesBatchOperation('flutterTestRoom3')
          .then((value) => {expect(value.roomID, 'flutterTestRoom3')});
      await ZIM
          .getInstance()
          .queryRoomAllAttributes('flutterTestRoom3')
          .then((value) => {
                expect(value.roomAttributes['key2'], 'value2'),
                expect(value.roomAttributes['key3'], 'value3')
              });
    });

    testWidgets(
        'batch_room_attributes_activty', (WidgetTester tester) async {});
  });
  group('msg_mod', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';

      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });
    tearDownAll(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    testWidgets('send_c2c_msg', (WidgetTester tester) async {
      ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
      ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
      await ZIM
          .getInstance()
          .sendPeerMessage(txtMsg, '888', sendConfig)
          .then((value) => {});
    });
  });

  group('conv_mod', () {
    setUp(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
      ZIMTextMessage txtMsg = ZIMTextMessage(message: 'message');
      ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
      await ZIM
          .getInstance()
          .sendPeerMessage(txtMsg, '510', sendConfig)
          .then((value) => {expect(value.message.conversationID, '510')});
    });

    tearDown(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
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

    testWidgets('dele_conv', (WidgetTester tester) async {
      ZIMConversationDeleteConfig deleteConfig = ZIMConversationDeleteConfig();
      deleteConfig.isAlsoDeleteServerConversation = true;
      await ZIM
          .getInstance()
          .deleteConversation('510', ZIMConversationType.peer, deleteConfig);
    });
  });

  group('group_mod', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDownAll(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    group('create_dismiss_mod', () {
      ZIMGroupAdvancedConfig advancedConfig = ZIMGroupAdvancedConfig();
      advancedConfig.groupAttributes = {'key1': 'value1'};
      advancedConfig.groupNotice = 'testNotice';

      testWidgets('create_dismiss_group', (WidgetTester tester) async {
        String groupID = 'grouptest0' + ZIMExampleTestCommonTools.uuid;
        ZIMGroupInfo groupInfo = ZIMGroupInfo();
        groupInfo.groupID = groupID;
        groupInfo.groupName = 'flutterGroupName';
        await ZIM.getInstance().createGroup(groupInfo, []).then((value) => {
              expect(
                value.groupInfo.baseInfo.groupID,
                groupID,
              ),
              expect(value.groupInfo.baseInfo.groupName, 'flutterGroupName')
            });
        await ZIM
            .getInstance()
            .dismissGroup(groupID)
            .then((value) => {expect(value.groupID, groupID)});
      });
      testWidgets('create_dismiss_group_with_config',
          (WidgetTester tester) async {
        String groupID = 'grouptest1' + ZIMExampleTestCommonTools.uuid;
        ZIMGroupInfo groupInfo = ZIMGroupInfo();
        groupInfo.groupID = groupID;
        groupInfo.groupName = 'flutterGroupName';
        await ZIM
            .getInstance()
            .createGroup(groupInfo, ['510'], advancedConfig)
            .then((value) => {
                  expect(
                    value.groupInfo.baseInfo.groupID,
                    groupID,
                  ),
                  expect(
                      value.groupInfo.baseInfo.groupName, 'flutterGroupName'),
                  expect(value.groupInfo.groupNotice, 'testNotice'),
                  expect(value.groupInfo.groupAttributes['key1'], 'value1')
                });
        await ZIM
            .getInstance()
            .dismissGroup(groupID)
            .then((value) => {expect(value.groupID, groupID)});
      });
    });

    group('group_activity_1', () {
      String groupID = 'grouptest2' + ZIMExampleTestCommonTools.uuid;
      ZIMGroupInfo groupInfo = ZIMGroupInfo();
      groupInfo.groupID = groupID;
      groupInfo.groupName = 'flutterGroupName';

      setUpAll(() async {
        await ZIM.getInstance().createGroup(groupInfo, ['510']);
      });
      tearDownAll(() async {
        // await ZIM.getInstance().dismissGroup(groupID);
      });

      testWidgets('invite_activity', (WidgetTester tester) async {
        ZIMGroupMemberQueryConfig memberQueryConfig =
            ZIMGroupMemberQueryConfig();
        memberQueryConfig.count = 20;
        bool userExist = false;
        await ZIM
            .getInstance()
            .queryGroupMemberList(groupID, memberQueryConfig)
            .then((value) => {
                  value.userList.forEach((element) {
                    if (element.userID == '510') {
                      userExist = true;
                    }
                  }),
                  expect(userExist, true)
                });

        await ZIM.getInstance().kickGroupMembers(['510'], groupID).then(
            (value) => {expect(value.kickedUserIDList.first, '510')});
        userExist = false;
        await ZIM
            .getInstance()
            .queryGroupMemberList(groupID, memberQueryConfig)
            .then((value) => {
                  value.userList.forEach((element) {
                    if (element.userID == '510') {
                      userExist = true;
                    }
                  }),
                  expect(userExist, false)
                });
        await ZIM.getInstance().inviteUsersIntoGroup(['510'], groupID).then(
            (value) => {
                  expect(value.userList.first.userID, '510'),
                  expect(value.groupID, groupID)
                });
        userExist = false;
        await ZIM
            .getInstance()
            .queryGroupMemberList(groupID, memberQueryConfig)
            .then((value) => {
                  value.userList.forEach((element) {
                    if (element.userID == '510') {
                      userExist = true;
                    }
                  }),
                  expect(userExist, true)
                });
      });
    });

    group('group_activity_2', () {
      String groupID = ZIMExampleTestCommonTools.uuid;
      ZIMGroupInfo groupInfo = ZIMGroupInfo();
      groupInfo.groupID = groupID;
      groupInfo.groupName = 'flutterGroupName';

      setUpAll(() async {
        await ZIM.getInstance().createGroup(groupInfo, ['510']);
      });
      tearDownAll(() async {});

      testWidgets('invite_activity_2', (WidgetTester tester) async {
        await ZIM.getInstance().transferGroupOwner('510', groupID).then(
            (value) => {
                  expect(value.groupID, groupID),
                  expect(value.toUserID, '510')
                });
        await ZIM
            .getInstance()
            .queryGroupMemberInfo('510', groupID)
            .then((value) => {expect(value.userInfo.memberRole, 1)});
      });
    });

    group('group_activity_3', () {
      String groupID = 'grouptest3' + ZIMExampleTestCommonTools.uuid;
      ZIMGroupInfo groupInfo = ZIMGroupInfo();
      groupInfo.groupID = groupID;
      groupInfo.groupName = 'flutterGroupName';

      setUpAll(() async {
        await ZIM.getInstance().createGroup(groupInfo, ['510']);
      });
      tearDownAll(() async {
        await ZIM.getInstance().dismissGroup(groupID);
      });

      testWidgets('updateGroupName', (WidgetTester tester) async {
        await ZIM
            .getInstance()
            .updateGroupName('updateGroupName_test', groupID)
            .then((value) => {
                  expect(value.groupName, 'updateGroupName_test'),
                  expect(value.groupID, groupID)
                });
        await ZIM
            .getInstance()
            .updateGroupNotice('updateGroupNotice_test', groupID);
        await ZIM.getInstance().setGroupAttributes(
            {'key1': 'value1', 'key2': 'value2'},
            groupID).then((value) => {expect(value.groupID, groupID)});
        await ZIM
            .getInstance()
            .queryGroupAllAttributes(groupID)
            .then((value) => {
                  expect(value.groupAttributes['key1'], 'value1'),
                  expect(value.groupAttributes['key2'], 'value2'),
                  expect(value.groupID, groupID)
                });
        await ZIM.getInstance().queryGroupAttributes(['key1'], groupID).then(
            (value) => {
                  expect(value.groupAttributes['key1'], 'value1'),
                  expect(value.groupID, groupID)
                });
        await ZIM.getInstance().deleteGroupAttributes(['key2'], groupID);
        await ZIM.getInstance().queryGroupInfo(groupID).then((value) => {
              expect(value.groupInfo.groupAttributes['key1'], 'value1'),
              expect(value.groupInfo.groupAttributes['key2'], null),
              expect(value.groupInfo.groupNotice, 'updateGroupNotice_test'),
              expect(
                  value.groupInfo.baseInfo.groupName, 'updateGroupName_test'),
              expect(value.groupInfo.baseInfo.groupID, groupID)
            });
        await ZIM
            .getInstance()
            .setGroupMemberRole(4, '510', groupID)
            .then((value) => {
                  expect(value.role, 4),
                  expect(value.forUserID, '510'),
                  expect(value.groupID, groupID)
                });
        await ZIM
            .getInstance()
            .setGroupMemberNickname('testNickname', '510', groupID)
            .then((value) => {
                  expect(value.nickname, 'testNickname'),
                  expect(value.groupID, groupID),
                  expect(value.forUserID, '510')
                });
        await ZIM
            .getInstance()
            .queryGroupMemberInfo('510', groupID)
            .then((value) => {
                  expect(value.userInfo.memberNickname, 'testNickname'),
                  expect(value.userInfo.memberRole, 4),
                  expect(value.userInfo.userID, '510'),
                  expect(value.userInfo.userName, '')
                });
        ZIMGroupMemberQueryConfig groupMemberQueryConfig =
            ZIMGroupMemberQueryConfig();
        groupMemberQueryConfig.count = 20;
        await ZIM
            .getInstance()
            .queryGroupMemberList(groupID, groupMemberQueryConfig)
            .then((value) => {
                  expect(value.groupID, groupID),
                  expect(value.nextFlag, 0),
                  expect(value.userList.length, 2)
                });
        // await ZIM
        //     .getInstance()
        //     .setConversationNotificationStatus(
        //         ZIMConversationNotificationStatus.doNotDisturb,
        //         groupID,
        //         ZIMConversationType.group)
        //     .then((value) => {expect(value.conversationID, groupInfo.groupID)});
      });
    });
    group('group_activity_4', () {
      String groupID = 'grouptest4' + ZIMExampleTestCommonTools.uuid;
      ZIMGroupInfo groupInfo = ZIMGroupInfo();
      groupInfo.groupID = groupID;
      groupInfo.groupName = 'flutterGroupName';

      setUpAll(() async {
        await ZIM.getInstance().createGroup(groupInfo, ['510']);
      });
      tearDownAll(() async {
        await ZIM.getInstance().dismissGroup(groupID);
      });

      testWidgets('groupMsg', (WidgetTester tester) async {
        ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();

        await ZIM.getInstance().sendGroupMessage(
            ZIMTextMessage(message: 'message1'), groupID, sendConfig);
        sleep(const Duration(seconds: 1));
        await ZIM.getInstance().sendGroupMessage(
            ZIMTextMessage(message: 'message2'), groupID, sendConfig);
        sleep(const Duration(seconds: 1));
        await ZIM.getInstance().sendGroupMessage(
            ZIMTextMessage(message: 'message2'), groupID, sendConfig);
        ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
        queryConfig.count = 10;

        ZIMMessage targtMsg = ZIMTextMessage(message: 'message');
        await ZIM
            .getInstance()
            .queryHistoryMessage(
                groupID, ZIMConversationType.group, queryConfig)
            .then((value) => {targtMsg = value.messageList.first});
        ZIMMessageDeleteConfig deleteConfig = ZIMMessageDeleteConfig();
        await ZIM.getInstance().deleteMessages([
          targtMsg
        ], groupID, ZIMConversationType.group, deleteConfig).then(
            (value) => {expect(value.conversationID, groupID)});
        await ZIM
            .getInstance()
            .queryHistoryMessage(
                groupID, ZIMConversationType.group, queryConfig)
            .then((value) => {expect(value.messageList.length, 2)});
        await ZIM
            .getInstance()
            .deleteAllMessage(groupID, ZIMConversationType.group, deleteConfig)
            .then((value) => {expect(value.conversationID, groupID)});
        await ZIM
            .getInstance()
            .queryHistoryMessage(
                groupID, ZIMConversationType.group, queryConfig)
            .then((value) => {expect(value.messageList.length, 0)});
      });
    });
  });

  group('call_invite_mod', () {
    setUpAll(() async {
      await ZIM.getInstance().create(2845718148);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = 'fluttertest1';
      await ZIM.getInstance().login(userInfo,
          '04AAAAAGKi8AUAEDJsN216eWQ4MG5nZzhzMG8AcLEUYLTvW3TFte+hEXgJFMQ1hEcGr1WLkK5PCUwmPiLb0Y6pS9ONoouWJZXvbCReMyOrkTEuQzvyra0Mdsdb8/mf2mOZTdXfzObGe6dYFZfmOObCzLXDgX5883cxdC1IaK1E5h8EXTBej62DBZa0Z3c=');
    });

    tearDownAll(() async {
      await ZIM.getInstance().logout();
      await ZIM.getInstance().destroy();
    });

    testWidgets('callInvite', (WidgetTester tester) async {
      ZIMCallInviteConfig config = ZIMCallInviteConfig();
      config.timeout = 10;
      config.extendedData = 'test';
      String myCallID = '';
      await ZIM.getInstance().callInvite(['510'], config).then((value) => {
            expect(value.callID.isNotEmpty, true),
            myCallID = value.callID,
            expect(value.info.timeout, 10),
            expect(value.info.errorInvitees.length, 0)
          });
      ZIMCallCancelConfig callCancelConfig = ZIMCallCancelConfig();
      callCancelConfig.extendedData = 'test';
      await ZIM
          .getInstance()
          .callCancel(['510'], myCallID, callCancelConfig).then((value) => {
                expect(value.callID, myCallID),
                expect(value.errorInvitees.length, 0)
              });
    });
  });
}
