import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zim/zim.dart';

void main() {
  const MethodChannel channel = MethodChannel('zim');

  TestWidgetsFlutterBinding.ensureInitialized();

  Map txtMsgMap = {
    'type': 1,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'message': 'message'
  };

  Map cmdMsgMap = {
    'type': 2,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'message': Uint8List.fromList([0, 1, 2])
  };

  Map BrgMsgMap = {
    'type': 20,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'message': 'message'
  };

  Map imageMsgMap = {
    'type': 11,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'fileLocalPath': 'fileLocalPath',
    'fileDownloadUrl': 'fileDownloadUrl',
    'fileUID': 'fileUID',
    'fileName': 'fileName',
    'fileSize': 10,
    'thumbnailDownloadUrl': 'thumbnailDownloadUrl',
    'thumbnailLocalPath': 'thumbnailLocalPath',
    'largeImageDownloadUrl': 'largeImageDownloadUrl',
    'largeImageLocalPath': 'largeImageLocalPath'
  };

  Map videoMsgMap = {
    'type': 14,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'fileLocalPath': 'fileLocalPath',
    'fileDownloadUrl': 'fileDownloadUrl',
    'fileUID': 'fileUID',
    'fileName': 'fileName',
    'fileSize': 10,
    'videoDuration': 10,
    'videoFirstFrameDownloadUrl': 'videoFirstFrameDownloadUrl',
    'videoFirstFrameLocalPath': 'videoFirstFrameLocalPath',
  };

  Map fileMsgMap = {
    'type': 12,
    'messageID': 123,
    'localMessageID': 234,
    'senderUserID': 'senderUserID',
    'conversationID': 'conversationID',
    'direction': 1,
    'sentStatus': 1,
    'conversationType': 1,
    'timestamp': 10,
    'conversationSeq': 555,
    'orderKey': 20,
    'fileLocalPath': 'fileLocalPath',
    'fileDownloadUrl': 'fileDownloadUrl',
    'fileUID': 'fileUID',
    'fileName': 'fileName',
    'fileSize': 10
  };

  Map conversationMap = {
    'conversationID': '',
    'conversationName': '',
    'type': 2,
    'notificationStatus': 1,
    'unreadMessageCount': 1,
    'orderKey': 1,
    'lastMessage': imageMsgMap
  };

  Map conversation_lastMessage_empty = {
    'conversationID': '',
    'conversationName': '',
    'type': 2,
    'notificationStatus': 1,
    'unreadMessageCount': 1,
    'orderKey': 1,
    'lastMessage': null
  };

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getVersion':
          return '2.1.1';
        case 'create':
          return null;
        case 'destroy':
          return null;
        case 'setLogConfig':
          return null;
        case 'setCacheConfig':
          return null;
        case 'login':
          return null;
        case 'logout':
          return null;
        case 'uploadLog':
          return null;
        case 'renewToken':
          return {"token": "token"};
        case 'queryUsersInfo':
          expect((methodCall.arguments['userIDs'] as List).length, 2);
          return {
            "userList": [
              {'userID': "userID_1", 'userName': 'userName_1'}
            ],
            'errorUserList': [
              {'userID': 'userID_2', 'reason': 0}
            ]
          };
        case 'queryConversationList':
          expect(
              (((methodCall.arguments['config'] as Map)['nextConversation']
                  as Map)['lastMessage'] as Map)['timestamp'],
              10);
          return {
            'conversationList': [conversationMap]
          };
        case 'deleteConversation':
          expect(
              (methodCall.arguments['config']
                  as Map)['isAlsoDeleteServerConversation'],
              true);
          return {'conversationID': 'conversationID', 'conversationType': 2};
        case 'clearConversationUnreadMessageCount':
          expect(methodCall.arguments['conversationID'], 'conversationID');
          expect(methodCall.arguments['conversationType'], 0);
          return {'conversationID': 'conversationID', 'conversationType': 0};
        case 'setConversationNotificationStatus':
          return {'conversationID': 'conversationID', 'conversationType': 1};
        case 'sendPeerMessage':
          return {"message": txtMsgMap};
        case 'sendGroupMessage':
          return {'message': cmdMsgMap};
        case 'sendRoomMessage':
          return {'message': BrgMsgMap};
        case 'downloadMediaFile':
          return {'message': videoMsgMap};
        case 'sendMediaMessage':
          return {'message': fileMsgMap};
        case 'queryHistoryMessage':
          return {
            'conversationID': 'conversationID',
            'conversationType': 1,
            'messageList': [txtMsgMap]
          };
        case 'deleteAllMessage':
          return {'conversationID': 'conversationID', 'conversationType': 2};
        case 'deleteMessages':
          return {
            'conversationID': 'conversationID',
            'conversationType': 1,
            'messageList': [txtMsgMap]
          };
        default:
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getVersion', () async {
    expect(await ZIM.getInstance().getVersion(), '2.1.1');
  });

  test('create', () async {
    await ZIM.getInstance().create(2213);
  });

  test('destroy', () async {
    await ZIM.getInstance().destroy();
  });

  test('setLogConfig', () async {
    ZIMLogConfig config = ZIMLogConfig(logPath: 'logPath', logSize: 5);
    await ZIM.getInstance().setLogConfig(config);
  });

  test('setCacheConfig', () async {
    ZIMCacheConfig config = ZIMCacheConfig(cachePath: 'cachePath');
    await ZIM.getInstance().setCacheConfig(config);
  });

  test('login', () async {
    await ZIM.getInstance().login('userID', 'userName', 'token');
  });

  test('logout', () async {
    await ZIM.getInstance().logout();
  });

  test('uploadLog', () async {
    await ZIM.getInstance().uploadLog();
  });

  test('renewToken', () async {
    await ZIM
        .getInstance()
        .renewToken('token')
        .then((value) => {expect(value.token, 'token')});
  });

  test('queryUsersInfo', () async {
    await ZIM.getInstance().queryUsersInfo(['1', '2']).then((value) => {
          expect(value.errorUserList.first.reason, 0),
          expect(value.userList.isNotEmpty, true)
        });
  });

  test('queryConversationList', () async {
    ZIMConversationQueryConfig config = ZIMConversationQueryConfig();
    config.count = 20;
    config.nextConversation = ZIMConversation();
    config.nextConversation!.lastMessage = ZIMMessage();
    config.nextConversation!.lastMessage!.timestamp = 10;
    await ZIM.getInstance().queryConversationList(config).then((value) =>
        {expect(value.conversationList.first.lastMessage!.timestamp, 10)});
  });

  test('deleteConversation', () async {
    ZIMConversationDeleteConfig config = ZIMConversationDeleteConfig();
    config.isAlsoDeleteServerConversation = true;
    await ZIM
        .getInstance()
        .deleteConversation('conversationID', ZIMConversationType.group, config)
        .then((value) => {
              expect(value.conversationID, 'conversationID'),
              expect(value.conversationType, ZIMConversationType.group)
            });
  });

  test('clearConversationUnreadMessageCount', () async {
    await ZIM
        .getInstance()
        .clearConversationUnreadMessageCount(
            'conversationID', ZIMConversationType.peer)
        .then((value) => {
              expect(value.conversationID, 'conversationID'),
              expect(value.conversationType, ZIMConversationType.peer)
            });
  });

  test('setConversationNotificationStatus', () async {
    await ZIM
        .getInstance()
        .setConversationNotificationStatus(
            ZIMConversationNotificationStatus.notify,
            'conversationID',
            ZIMConversationType.group)
        .then((value) => {
              expect(value.conversationID, 'conversationID'),
              expect(value.conversationType, ZIMConversationType.room)
            });
  });

  test('sendPeerMessage', () async {
    ZIMTextMessage txtMsg = ZIMTextMessage();
    txtMsg.message = 'test msg.';
    ZIMMessageSendConfig sendConfig =
        ZIMMessageSendConfig(priority: ZIMMessagePriority.high);
    await ZIM
        .getInstance()
        .sendPeerMessage(txtMsg, 'toUserID', sendConfig)
        .then((value) =>
            {expect(value.message.sentStatus, ZIMMessageSentStatus.success)});
  });

  test('sendGroupMessage', () async {
    List<int> list = [0, 1, 2];
    Uint8List bytes = Uint8List.fromList(list);
    ZIMCommandMessage cmdMsg = ZIMCommandMessage();
    cmdMsg.message = bytes;
    ZIMMessageSendConfig config =
        ZIMMessageSendConfig(priority: ZIMMessagePriority.medium);
    await ZIM.getInstance().sendGroupMessage(cmdMsg, 'toGroupID', config).then(
        (value) => {
              expect((value.message as ZIMCommandMessage).message,
                  Uint8List.fromList(list))
            });
  });

  test('sendRoomMessage', () async {
    ZIMBarrageMessage message = ZIMBarrageMessage();
    message.message = 'message';
    ZIMMessageSendConfig config =
        ZIMMessageSendConfig(priority: ZIMMessagePriority.low);
    await ZIM.getInstance().sendRoomMessage(message, 'toRoomID', config).then(
        (value) =>
            {expect((value.message as ZIMBarrageMessage).message, 'message')});
  });

  test('downloadMediaFile', () async {
    ZIMVideoMessage message = ZIMVideoMessage(fileLocalPath: 'fileLocalPath');
    await ZIM
        .getInstance()
        .downloadMediaFile(message, ZIMMediaFileType.originalFile,
            (message, currentFileSize, totalFileSize) {})
        .then((value) => {
              expect(
                  (value.message as ZIMVideoMessage).videoFirstFrameLocalPath,
                  'videoFirstFrameLocalPath')
            });
  });

  test('sendMediaMessage', () async {
    ZIMFileMessage message = ZIMFileMessage(fileLocalPath: 'fileLocalPath');
    ZIMMessageSendConfig config =
        ZIMMessageSendConfig(priority: ZIMMessagePriority.low);
    await ZIM
        .getInstance()
        .sendMediaMessage(message, 'toConversationID', ZIMConversationType.peer,
            config, (message, currentFileSize, totalFileSize) {})
        .then((value) =>
            {expect((value.message as ZIMFileMessage).fileUID, 'fileUID')});
  });

  test('queryHistoryMessage', () async {
    ZIMMessageQueryConfig config = ZIMMessageQueryConfig();
    config.count = 20;
    await ZIM
        .getInstance()
        .queryHistoryMessage(
            'conversationID', ZIMConversationType.group, config)
        .then((value) =>
            {expect(value.messageList.first.conversationID, 'conversationID')});
  });

  test('deleteAllMessage', () async {
    ZIMMessageDeleteConfig config = ZIMMessageDeleteConfig();
    config.isAlsoDeleteServerMessage = true;
    await ZIM
        .getInstance()
        .deleteAllMessage('conversationID', ZIMConversationType.group, config)
        .then((value) => {expect(value.conversationID, 'conversationID')});
  });

  test('deleteMessages', () async {
    ZIMMessageDeleteConfig config = ZIMMessageDeleteConfig();
    config.isAlsoDeleteServerMessage = true;
    ZIMTextMessage message = ZIMTextMessage();

    await ZIM.getInstance().deleteMessages([
      message
    ], 'conversationID', ZIMConversationType.room, config).then(
        (value) => {expect(value.conversationID, 'conversationID')});
  });

  test('createRoom', () async {
    ZIMRoomInfo info = ZIMRoomInfo();
    info.roomID = 'roomID';
    info.roomName = 'roomName';

    await ZIM
        .getInstance()
        .createRoom(info)
        .then((value) => {expect(value.roomInfo.baseInfo.roomID, 'roomID')});
  });

  //test('description', body)
}
