import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js';

import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';
import 'package:zego_zim/src/internal/zim_common_data.dart';
import 'package:zego_zim/src/internal/zim_engine.dart';
import 'package:zego_zim/src/internal/zim_manager.dart';
import 'package:zego_zim/src/zim_defines.dart';
import 'package:zego_zim/src/zim_defines_web.dart';
import 'package:zego_zim/src/zim_event_handler.dart';


/// A web implementation of the ZimFlutterSdkPlatform of the ZimFlutterSdk plugin.
class ZegoZimPlugin {
  /// Constructs a ZegoZimPluginWeb
  ZegoZimPlugin();

  static Map<String, ZIM> handleMap = {};

  static final StreamController _evenController = StreamController();

  static void registerWith(Registrar registrar) {
    //ZimFlutterSdkPlatform.instance = ZimFlutterSdkWeb();
    final MethodChannel channel = MethodChannel(
      'zego_zim_plugin',
      const StandardMethodCodec(),
      registrar,
    );

    final eventChannel = PluginEventChannel(
        'zim_event_handler',
        const StandardMethodCodec(),
        registrar);

    final pluginInstance = ZegoZimPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
    eventChannel.setController(ZegoZimPlugin._evenController);

    _evenController.stream.listen((event) {
      _eventListener(event);
    });

    // var element = ScriptElement()
    //   ..src = 'assets/packages/zego_zim/assets/index.js'
    //   ..type = 'application/javascript';

    // document.body!.append(element);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getVersion':
        return getVersion();
      case 'create':
        return create(call.arguments["handle"], call.arguments['config']);
      case 'destroy':
        return destroy();
      case 'setLogConfig':
        return setLogConfig(call.arguments["logPath"], call.arguments["logSize"]);
      case 'setCacheConfig':
        return setCacheConfig();
      case 'login':
        return login(call.arguments['userID'], call.arguments['userName'],
            call.arguments['token']);
      case 'logout':
        return logout();
      case 'createRoom':
        return createRoom(call.arguments["roomInfo"], null);
      case 'enterRoom':
        return enterRoom(call.arguments["roomInfo"], call.arguments["config"]);
      case 'joinRoom':
        return joinRoom(call.arguments["roomID"]);
      case 'leaveRoom':
        return leaveRoom(call.arguments["roomID"]);
      case 'queryRoomMemberList':
        return queryRoomMemberList(call.arguments["roomID"], call.arguments["config"]);
      case 'queryRoomOnlineMemberCount':
        return queryRoomOnlineMemberCount(call.arguments["roomID"]);
      case 'queryRoomAllAttributes':
        return queryRoomAllAttributes(call.arguments["roomID"]);
      case 'setRoomAttributes':
        return setRoomAttributes(call.arguments["roomAttributes"], call.arguments["roomID"], call.arguments["config"]);
      case 'deleteRoomAttributes':
        return deleteRoomAttributes(call.arguments["keys"], call.arguments["roomID"], call.arguments["config"]);
      case 'beginRoomAttributesBatchOperation':
        return beginRoomAttributesBatchOperation(call.arguments["roomID"], call.arguments["config"]);
      case 'endRoomAttributesBatchOperation':
        return endRoomAttributesBatchOperation(call.arguments["roomID"]);
      case 'createRoomWithConfig':
        return createRoom(call.arguments["roomInfo"], call.arguments["config"]);
      case 'renewToken':
        return renewToken(call.arguments["token"]);
      case 'queryUsersInfo':
        return queryUsersInfo(call.arguments["userIDs"], call.arguments["config"]);
      case 'queryConversationList':
        return queryConversationList(call.arguments["config"]);
      case 'updateUserName':
        return updateUserName(call.arguments["userName"]);
      case 'updateUserAvatarUrl':
        return updateUserAvatarUrl(call.arguments["userAvatarUrl"]);
      case 'updateUserExtendedData':
        return updateUserExtendedData(call.arguments["extendedData"]);
      case 'clearConversationUnreadMessageCount':
        return clearConversationUnreadMessageCount(call.arguments["conversationID"], call.arguments["conversationType"]);
      case 'queryHistoryMessage':
        return queryHistoryMessage(call.arguments["conversationID"], call.arguments["conversationType"], call.arguments["config"]);
      case 'sendMediaMessage':
        return sendMediaMessage(call.arguments["message"], call.arguments["toConversationID"], call.arguments["conversationType"], call.arguments["config"], call.arguments["progressID"]);
      case 'downloadMediaFile':
        return downloadMediaFile(call.arguments["message"], call.arguments["fileType"], call.arguments["progressID"]);
      case 'sendPeerMessage':
        return sendPeerMessage(call.arguments["message"], call.arguments["toUserID"], call.arguments["config"]);
      case 'sendRoomMessage':
        return sendRoomMessage(call.arguments["message"], call.arguments["toRoomID"], call.arguments["config"]);
      case 'sendGroupMessage':
        return sendGroupMessage(call.arguments["message"], call.arguments["toGroupID"], call.arguments["config"]);
      case 'deleteMessages':
        return deleteMessages(call.arguments["messageList"], call.arguments["conversationID"], call.arguments["conversationType"], call.arguments["config"]);
      case 'createGroup':
        return createGroup(call.arguments["groupInfo"], call.arguments["userIDs"], call.arguments["config"]);
      case 'joinGroup':
        return joinGroup(call.arguments["groupID"]);
      case 'leaveGroup':
        return leaveGroup(call.arguments["groupID"]);
      case 'dismissGroup':
        return dismissGroup(call.arguments["groupID"]);
      case 'inviteUsersIntoGroup':
        return inviteUsersIntoGroup(call.arguments["userIDs"], call.arguments["groupID"]);
      case 'kickGroupMembers':
        return kickGroupMembers(call.arguments["userIDs"], call.arguments["groupID"]);
      case 'transferGroupOwner':
        return transferGroupOwner(call.arguments["toUserID"], call.arguments["groupID"]);
      case 'updateGroupName':
        return updateGroupName(call.arguments["groupName"], call.arguments["groupID"]);
      case 'updateGroupAvatarUrl':
        return updateGroupAvatarUrl(call.arguments["groupAvatarUrl"], call.arguments["groupID"]);
      case 'updateGroupNotice':
        return updateGroupNotice(call.arguments["groupNotice"], call.arguments["groupID"]);
      case 'queryGroupInfo':
        return queryGroupInfo(call.arguments["groupID"]);
      case 'queryGroupList':
        return queryGroupList();
      case 'setGroupAttributes':
        return setGroupAttributes(call.arguments["groupAttributes"], call.arguments["groupID"]);
      case 'deleteGroupAttributes':
        return deleteGroupAttributes(call.arguments["keys"], call.arguments["groupID"]);
      case 'queryGroupAttributes':
        return queryGroupAttributes(call.arguments["keys"], call.arguments["groupID"]);
      case 'queryGroupAllAttributes':
        return queryGroupAllAttributes(call.arguments["groupID"]);
      case 'setGroupMemberRole':
        return setGroupMemberRole(call.arguments["role"], call.arguments["forUserID"], call.arguments["groupID"]);
      case 'setGroupMemberNickname':
        return setGroupMemberNickname(call.arguments["nickname"], call.arguments["forUserID"], call.arguments["groupID"]);
      case 'queryGroupMemberInfo':
        return queryGroupMemberInfo(call.arguments["userID"], call.arguments["groupID"]);
      case 'queryGroupMemberList':
        return queryGroupMemberList(call.arguments["groupID"], call.arguments["config"]);
      case 'deleteConversation':
        return deleteConversation(call.arguments["conversationID"], call.arguments["conversationType"], call.arguments["config"]);
      case 'setConversationNotificationStatus':
        return setConversationNotificationStatus(call.arguments["status"], call.arguments["conversationID"], call.arguments["conversationType"]);
      case 'callInvite':
        return callInvite(call.arguments["invitees"], call.arguments["config"]);
      case 'callCancel':
        return callCancel(call.arguments["invitees"], call.arguments["callID"], call.arguments["config"]);
      case 'callAccept':
        return callAccept(call.arguments["callID"], call.arguments["config"]);
      case 'callReject':
        return callReject(call.arguments["callID"], call.arguments["config"]);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'zim for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  static void _eventListener(dynamic event) {
    final data = json.decode(event["data"]);
    ZIM zim = event["zim"];
    ZIMEngine? _zim = ZIMManager.engineMap[getHandle(zim)];

    if (_zim != null) {
      switch(event["ev"]) {
        case "connectionStateChanged":
          return connectionStateChangedHandle(_zim, data);
        case "error":
          return errorHandle(_zim, data);
        case "tokenWillExpire":
          return tokenWillExpireHandle(_zim, data);
        case "receiveRoomMessage":
          return receiveRoomMessageHandle(_zim, data);
        case "roomStateChanged":
          return roomStateChangedHandle(_zim, data);
        case "roomAttributesUpdated":
          return roomAttributesUpdatedHandle(_zim, data);
        case "roomAttributesBatchUpdated":
          return roomAttributesBatchUpdatedHandle(_zim, data);
        case "roomMemberJoined":
          return roomMemberJoinedHandle(_zim, data);
        case "roomMemberLeft":
          return roomMemberLeftHandle(_zim, data);
        case "receivePeerMessage":
          return receivePeerMessageHandle(_zim, data);
        case "receiveGroupMessage":
          return receiveGroupMessageHandle(_zim, data);
        case "groupStateChanged":
          return groupStateChangedHandle(_zim, data);
        case "groupNameUpdated":
          return groupNameUpdatedHandle(_zim, data);
        case "groupAvatarUrlUpdated":
          return groupAvatarUrlUpdatedHandle(_zim, data);
        case "groupNoticeUpdated":
          return groupNoticeUpdatedHandle(_zim, data);
        case "groupAttributesUpdated":
          return groupAttributesUpdatedHandle(_zim, data);
        case "groupMemberStateChanged":
          return groupMemberStateChangedHandle(_zim, data);
        case "groupMemberInfoUpdated":
          return groupMemberInfoUpdatedHandle(_zim, data);
        case "callInvitationReceived":
          return callInvitationReceivedHandle(_zim, data);
        case "callInvitationCancelled":
          return callInvitationCancelledHandle(_zim, data);
        case "callInvitationTimeout":
          return callInvitationTimeoutHandle(_zim, data);
        case "callInvitationAccepted":
          return callInvitationAcceptedHandle(_zim, data);
        case "callInvitationRejected":
          return callInvitationRejectedHandle(_zim, data);
        case "callInviteesAnsweredTimeout":
          return callInviteesAnsweredTimeoutHandle(_zim, data);
        case "conversationChanged":
          return conversationChangedHandle(_zim, data);
        case "conversationTotalUnreadMessageCountUpdated":
          return conversationTotalUnreadMessageCountUpdatedHandle(_zim, data);
      }
    }


  }

  static String getHandle(ZIM zim) {
    var handle = "";
    handleMap.forEach((key, val) {
      if (val == zim) {
        handle = key;
      }
    });

    return handle;
  }

  static String getVersion() {
    return ZIM.getVersion();
  }

  static Future<void> create(String handle, dynamic appConfig) async {
    ZIMAppConfigWeb _appConfig = ZIMAppConfigWeb(appID: appConfig["appID"]);

    ZIM? zim = ZIM.create(_appConfig);

    if (zim != null) {
      handleMap[handle] = zim;
    }

    ZIM.setEventHandler(
      allowInterop((dynamic zim, event, String data) {
        _evenController.add({'zim': zim, 'ev': event, 'data': data});
    }));
    return Future.value();
  }

  static Future<void> destroy() async {
    ZIM.destroy();

    return Future.value();
  }

  static Future<void> setLogConfig(String logPath, int logSize) {
    // window.console.warn(config);

    // ZIM.getInstance()?.setLogConfig(config);

    return Future.value();
  }

  static void setCacheConfig() {
    return;
  }

  Future<void> login( String userID, String userName, String token) async {

    ZIMUserInfoWeb _userInfo = ZIMUserInfoWeb(userID: userID, userName: userName);

    if (ZIM.getInstance() == null) {
      return Future.value();
    }

    final promise = ZIM.getInstance()!.login(_userInfo, token);

    final Future<void> loginFuture = promiseToFuture(promise);

    await loginFuture;

    return Future.value();
  }

  logout() {
    ZIM.getInstance()?.logout();
  }

  Future<Map<dynamic, dynamic>> queryConversationList(dynamic config) async {
    final Map<dynamic, dynamic> map = {};
    map["conversationList"] = [];

    final count = config["count"];
    final nextConversation = config["nextConversation"];

    ZIMConversationQueryConfigWeb _config = ZIMConversationQueryConfigWeb(count:count, nextConversation: nextConversation);

    final result = await promiseToFuture(ZIM.getInstance()!.queryConversationList(_config));

    return Future.value({
      "conversationList": result.conversationList
    });
  }

  Future<Map<dynamic, dynamic>> updateUserAvatarUrl(String userAvatarUrl)async {
    final result = await promiseToFuture(ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl));

    return Future.value({"userAvatarUrl": result.userAvatarUrl});
  }

  Future<Map<dynamic,dynamic>> updateUserName(String userName) async {

    final result = await promiseToFuture(ZIM.getInstance()!.updateUserName(userName));

    return {"userName": result.userName};
  }

  Future<Map<dynamic,dynamic>> updateUserExtendedData(String extendedData) async {

    final result = await promiseToFuture(ZIM.getInstance()!.updateUserExtendedData(extendedData));

    return {"extendedData": result.extendedData};
  }

  Future<Map<dynamic,dynamic>> renewToken(String token) async {

    var _result = await promiseToFuture(ZIM.getInstance()!.renewToken(token));

    return {"token": _result.token};
  }

  Future<Map<dynamic,dynamic>> queryUsersInfo(dynamic userIDs, dynamic config) async {
    window.console.warn(userIDs);
    ZIMUsersInfoQueryConfigWeb _config = ZIMUsersInfoQueryConfigWeb(isQueryFromServer: config["isQueryFromServer"]);

    var _result = await promiseToFuture(ZIM.getInstance()!.queryUsersInfo(userIDs, _config));

    return {
      "userList": _result.userList,
      "errorUserList": _result.errorUserList
    };
  }

  Future<Map<dynamic, dynamic>> clearConversationUnreadMessageCount(String conversationID, int conversationType) async {
    Map result = await promiseToFuture(ZIM.getInstance()!.clearConversationUnreadMessageCount(conversationID, conversationType));

    window.console.error(result);

    return result;
  }

  Future<Map<dynamic, dynamic>> queryHistoryMessage(String conversationID, int conversationType, dynamic config) async {
    var nextMessage = config["nextMessage"];
    var count = config["count"];
    var reverse = config["reverse"];
    var result = {};

    try {
      ZIMMessageQueryConfigWeb _config = ZIMMessageQueryConfigWeb(nextMessage: nextMessage, count: count, reverse: reverse);

      final _result = await promiseToFuture(ZIM.getInstance()!.queryHistoryMessage(conversationID, conversationType, _config));

      result = {
        "conversationID": _result.conversationID,
        "conversationType": _result.conversationType,
        "messageList": []
      };

      _result.messageList.forEach((messageObj)  {
        result["messageList"].add({
          "localMessageID": messageObj.localMessageID,
          "messageID": messageObj.messageID,
          "senderUserID": messageObj.senderUserID,
          "timestamp": messageObj.timestamp,
          "conversationID": messageObj.conversationID,
          "conversationType": messageObj.conversationType,
          "direction": messageObj.direction,
          "sentStatus": messageObj.sentStatus,
          "orderKey": messageObj.orderKey,
          "conversationSeq": messageObj.conversationSeq
        });
      });
    } on PlatformException catch (error) {
      result = {};
    }

    return result;
  }

  Future<Map<dynamic, dynamic>> createRoom(dynamic roomInfo, dynamic config) async {
    var result = {};
    var _result;
    final roomID = roomInfo["roomID"];
    final roomName = roomInfo["roomName"];

    ZIMRoomInfoWeb _roomInfo = ZIMRoomInfoWeb(roomID: roomID, roomName: roomName);

    if (config != null) {
      final roomAttributes = config["roomAttributes"];
      final roomDestroyDelayTime = config["roomDestroyDelayTime"];

      ZIMRoomAdvancedConfigWeb _config = ZIMRoomAdvancedConfigWeb(roomAttributes: roomAttributes, roomDestroyDelayTime: roomDestroyDelayTime);
      _result = await promiseToFuture(ZIM.getInstance()!.createRoom(_roomInfo, _config));
    } else {
      _result = await promiseToFuture(ZIM.getInstance()!.createRoom(_roomInfo, null));
    }

    result = {
      "roomInfo": {
        "baseInfo": {
          "roomID": _result.roomInfo.baseInfo.roomID,
          "roomName":  _result.roomInfo.baseInfo.roomName
        }
      }
    };

    return result;
  }

  Future<Map<dynamic, dynamic>> enterRoom(dynamic roomInfo, dynamic config) async {
    var result = {};
    var _result;
    final roomID = roomInfo["roomID"];
    final roomName = roomInfo["roomName"];

    ZIMRoomInfoWeb _roomInfo = ZIMRoomInfoWeb(roomID: roomID,roomName: roomName);

    if (config != null) {
      final roomAttributes = config["roomAttributes"];
      final roomDestroyDelayTime = config["roomDestroyDelayTime"];

      ZIMRoomAdvancedConfigWeb _config = ZIMRoomAdvancedConfigWeb(roomAttributes: roomAttributes, roomDestroyDelayTime: roomDestroyDelayTime);
      _result = await promiseToFuture(ZIM.getInstance()!.enterRoom(_roomInfo, _config));
    } else {
      _result = await promiseToFuture(ZIM.getInstance()!.enterRoom(_roomInfo, null));
    }

    result = {
      "roomInfo": {
        "baseInfo": {
          "roomID": _result.roomInfo.baseInfo.roomID,
          "roomName":  _result.roomInfo.baseInfo.roomName
        }
      }
    };

    return result;
   }

  Future<Map<dynamic, dynamic>> joinRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinRoom(roomID));

    return {
      "roomInfo":{
        "baseInfo": {
          "roomID": result.roomInfo.baseInfo.roomID,
          "roomName": result.roomInfo.baseInfo.roomName
        }
      }
    };
  }

  Future<Map<dynamic, dynamic>> leaveRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveRoom(roomID));

    return {
      "roomID": result.roomID
    };
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberList(String roomID, dynamic config) async {
    final count = config["count"];
    final nextFlag = config["nextFlag"];
    ZIMRoomMemberQueryConfigWeb _config = ZIMRoomMemberQueryConfigWeb(count: count, nextFlag: nextFlag);

    final _result = await promiseToFuture(ZIM.getInstance()!.queryRoomMemberList(roomID, _config));

    final result = {
      "roomID": _result.roomID,
      "nextFlag": _result.nextFlag,
      "memberList": []
    };

    _result.memberList.forEach((member) {
      result["memberList"].add({
        "userID": member.userID,
        "userName": member.userName
      });
    });


    return result;
  }

  Future<Map<dynamic, dynamic>> queryRoomOnlineMemberCount(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryRoomOnlineMemberCount(roomID));

    return {
      "roomID": result.roomID,
      "count": result.count
    };
  }

  Future<Map<dynamic, dynamic>> queryRoomAllAttributes(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryRoomAllAttributes(roomID));

    return {
      "roomID": result.roomID,
      "roomAttributes": result.roomAttributes
    };
  }

  Future<Map<dynamic, dynamic>> setRoomAttributes(Map roomAttributes, String roomID, dynamic config) async {
    final isDeleteAfterOwnerLeft = config["isDeleteAfterOwnerLeft"];
    final isForce = config["isForce"];
    final isUpdateOwner = config["isUpdateOwner"];
    ZIMRoomAttributesSetConfigWeb _config = ZIMRoomAttributesSetConfigWeb(isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft, isForce: isForce, isUpdateOwner: isUpdateOwner);

    final _result = await promiseToFuture(ZIM.getInstance()!.setRoomAttributes(roomAttributes, roomID, _config));

    final result = {
      "roomID": _result.roomID,
      "errorKeys": []
    };

    _result.errorKeys.forEach((error) {
      result["errorKeys"].add(error);
    });

    return result;
  }

  Future<Map<dynamic, dynamic>> deleteRoomAttributes(dynamic keys, String roomID, dynamic config) async {
    final isForce = config["isForce"];
    ZIMRoomAttributesDeleteConfigWeb _config = ZIMRoomAttributesDeleteConfigWeb(isForce: isForce);

    final result = await promiseToFuture(ZIM.getInstance()!.deleteRoomAttributes(keys, roomID, _config));

    return {
      "roomID": result.roomID,
      "errorKeys": result.errorKeys
    };
  }

  Future<void> beginRoomAttributesBatchOperation(String roomID, dynamic config) async {
    final isForce = config["isForce"];
    final isDeleteAfterOwnerLeft = config["isDeleteAfterOwnerLeft"];
    final isUpdateOwner = config["isDeleteAfterOwnerLeft"];
    ZIMRoomAttributesBatchOperationConfigWeb _config = ZIMRoomAttributesBatchOperationConfigWeb(isForce: isForce, isDeleteAfterOwnerLeft: isDeleteAfterOwnerLeft, isUpdateOwner: isUpdateOwner);

    await promiseToFuture(ZIM.getInstance()!.beginRoomAttributesBatchOperation(roomID, _config));

    return;
  }

  Future<Map<dynamic, dynamic>> endRoomAttributesBatchOperation(String roomID) async {

    final result = await promiseToFuture(ZIM.getInstance()!.endRoomAttributesBatchOperation(roomID));

    return {
      "roomID": result.roomID
    };
  }

  Future<Map<dynamic, dynamic>> sendMediaMessage(dynamic message,String toConversationID, dynamic conversationType, dynamic config, int progressID) async {
    ZIMMediaMessageBaseWeb _message = ZIMMediaMessageBaseWeb(
      type: message["type"],
      fileLocalPath: message["fileLocalPath"],
      fileDownloadUrl: message["fileDownloadUrl"],
      fileName: message["fileName"],
      fileSize: message["fileSize"]
    );

    ZIMPushConfigWeb _pushConfig = ZIMPushConfigWeb(content: config["pushConfig"]["content"], title: config["pushConfig"]["title"], extendedData: config["pushConfig"]["extendedData"]);


    ZIMMessageSendConfigWeb _config = ZIMMessageSendConfigWeb(priority: config["priority"], pushConfig: _pushConfig);

    ZIMMediaDownloadingProgress? progress = ZIMCommonData.mediaDownloadingProgressMap[progressID];

    final result = await promiseToFuture(ZIM.getInstance()!.sendMediaMessage(_message, toConversationID, conversationType, _config, allowInterop((message, currentFileSize, totalFileSize) {
      ZIMMessage zimMessage = ZIMMessage();
      zimMessage.conversationID = message.conversationID;
      zimMessage.conversationSeq = message.conversationSeq;
      zimMessage.messageID = message.messageID;
      zimMessage.senderUserID = message.senderUserID;
      zimMessage.timestamp = message.timestamp;
      zimMessage.orderKey = message.orderKey;
      zimMessage.localMessageID = message.localMessageID;
      zimMessage.type = ZIMMessageType.values[message.type];
      zimMessage.direction = ZIMMessageDirection.values[message.direction];
      zimMessage.sentStatus = ZIMMessageSentStatus.values[message.sendStatus];
      zimMessage.conversationType = ZIMConversationType.values[message.conversationType];

      if (progress != null) {
        progress(zimMessage ,currentFileSize, totalFileSize);
      }
    })));

    final _result = result["message"];

    ZIMMessage _zimMessage = ZIMMessage();
    _zimMessage.conversationID = _result.conversationID;
    _zimMessage.conversationSeq = _result.conversationSeq;
    _zimMessage.messageID = _result.messageID;
    _zimMessage.senderUserID = _result.senderUserID;
    _zimMessage.timestamp = _result.timestamp;
    _zimMessage.orderKey = _result.orderKey;
    _zimMessage.localMessageID = _result.localMessageID;
    _zimMessage.type = ZIMMessageType.values[_result.type];
    _zimMessage.direction = ZIMMessageDirection.values[_result.direction];
    _zimMessage.sentStatus = ZIMMessageSentStatus.values[_result.sendStatus];
    _zimMessage.conversationType = ZIMConversationType.values[_result.conversationType];


    return {
      "message": _zimMessage
    };
  }

  Future<Map<dynamic, dynamic>> downloadMediaFile(dynamic message, dynamic fileType, int progressID) async {

    return {};
  }

  Future<Map<dynamic, dynamic>> sendPeerMessage(dynamic message, String toUserID, dynamic config) async  {
    ZIMMessageBaseWeb _message = ZIMMessageBaseWeb(message: message["message"], type: message["type"]);
    ZIMPushConfigWeb _pushConfig = ZIMPushConfigWeb(content: config["pushConfig"]["content"], title: config["pushConfig"]["title"], extendedData: config["pushConfig"]["extendedData"]);

    ZIMMessageSendConfigWeb _config = ZIMMessageSendConfigWeb(priority: config["priority"], pushConfig: _pushConfig);

    final result = await promiseToFuture(ZIM.getInstance()!.sendPeerMessage(_message, toUserID, _config));

    final _result = result["message"];

    ZIMMessage _zimMessage = ZIMMessage();
    _zimMessage.conversationID = _result.conversationID;
    _zimMessage.conversationSeq = _result.conversationSeq;
    _zimMessage.messageID = _result.messageID;
    _zimMessage.senderUserID = _result.senderUserID;
    _zimMessage.timestamp = _result.timestamp;
    _zimMessage.orderKey = _result.orderKey;
    _zimMessage.localMessageID = _result.localMessageID;
    _zimMessage.type = ZIMMessageType.values[_result.type];
    _zimMessage.direction = ZIMMessageDirection.values[_result.direction];
    _zimMessage.sentStatus = ZIMMessageSentStatus.values[_result.sendStatus];
    _zimMessage.conversationType = ZIMConversationType.values[_result.conversationType];


    return {
      "message": _zimMessage
    };
  }

  Future <Map<dynamic, dynamic>> sendRoomMessage(dynamic message, String toRoomID, dynamic config) async {
    ZIMMessageBaseWeb _message = ZIMMessageBaseWeb(message: message["message"], type: message["type"]);
    ZIMPushConfigWeb _pushConfig = ZIMPushConfigWeb(content: config["pushConfig"]["content"], title: config["pushConfig"]["title"], extendedData: config["pushConfig"]["extendedData"]);

    ZIMMessageSendConfigWeb _config = ZIMMessageSendConfigWeb(priority: config["priority"], pushConfig: _pushConfig);

    final result = await promiseToFuture(ZIM.getInstance()!.sendRoomMessage(_message, toRoomID, _config));

    final _result = result["message"];

    ZIMMessage _zimMessage = ZIMMessage();
    _zimMessage.conversationID = _result.conversationID;
    _zimMessage.conversationSeq = _result.conversationSeq;
    _zimMessage.messageID = _result.messageID;
    _zimMessage.senderUserID = _result.senderUserID;
    _zimMessage.timestamp = _result.timestamp;
    _zimMessage.orderKey = _result.orderKey;
    _zimMessage.localMessageID = _result.localMessageID;
    _zimMessage.type = ZIMMessageType.values[_result.type];
    _zimMessage.direction = ZIMMessageDirection.values[_result.direction];
    _zimMessage.sentStatus = ZIMMessageSentStatus.values[_result.sendStatus];
    _zimMessage.conversationType = ZIMConversationType.values[_result.conversationType];


    return {
      "message": _zimMessage
    };
  }

  Future <Map<dynamic, dynamic>> sendGroupMessage(dynamic message, String toGroupID, dynamic config) async {
    ZIMMessageBaseWeb _message = ZIMMessageBaseWeb(message: message["message"], type: message["type"]);
    ZIMPushConfigWeb _pushConfig = ZIMPushConfigWeb(content: config["pushConfig"]["content"], title: config["pushConfig"]["title"], extendedData: config["pushConfig"]["extendedData"]);

    ZIMMessageSendConfigWeb _config = ZIMMessageSendConfigWeb(priority: config["priority"], pushConfig: _pushConfig);

    final result = await promiseToFuture(ZIM.getInstance()!.sendGroupMessage(_message, toGroupID, _config));

    final _result = result["message"];

    ZIMMessage _zimMessage = ZIMMessage();
    _zimMessage.conversationID = _result.conversationID;
    _zimMessage.conversationSeq = _result.conversationSeq;
    _zimMessage.messageID = _result.messageID;
    _zimMessage.senderUserID = _result.senderUserID;
    _zimMessage.timestamp = _result.timestamp;
    _zimMessage.orderKey = _result.orderKey;
    _zimMessage.localMessageID = _result.localMessageID;
    _zimMessage.type = ZIMMessageType.values[_result.type];
    _zimMessage.direction = ZIMMessageDirection.values[_result.direction];
    _zimMessage.sentStatus = ZIMMessageSentStatus.values[_result.sendStatus];
    _zimMessage.conversationType = ZIMConversationType.values[_result.conversationType];


    return {
      "message": _zimMessage
    };
  }

  Future <Map<dynamic, dynamic>> deleteMessages(dynamic messageList, String conversationID, dynamic conversationType, dynamic config) async {
    ZIMMessageDeleteConfigWeb _config = ZIMMessageDeleteConfigWeb(isAlsoDeleteServerMessage: config["isAlsoDeleteServerMessage"]);

    final result = await promiseToFuture(ZIM.getInstance()!.deleteMessages(messageList, conversationID, conversationType, config));

    return {
      conversationID: result.conversationID,
      conversationType: result.conversationType
    };
  }

  Future <Map<dynamic, dynamic>> deleteAllMessage(String conversationID, dynamic conversationType, dynamic config) async {
    ZIMMessageDeleteConfigWeb _config = ZIMMessageDeleteConfigWeb(isAlsoDeleteServerMessage: config["isAlsoDeleteServerMessage"]);

    final result = await promiseToFuture(ZIM.getInstance()!.deleteAllMessage(conversationID, conversationType, config));

    return {
      conversationID: result.conversationID,
      conversationType: result.conversationType
    };
  }

  Future <Map<dynamic, dynamic>> createGroup(dynamic groupInfo, dynamic userIDs, dynamic config) async {
    final groupID = groupInfo["groupID"];
    final groupAvatarUrl = groupInfo["groupAvatarUrl"];
    final groupName = groupInfo["groupName"];
    ZIMGroupInfoWeb _groupInfo = ZIMGroupInfoWeb(groupID: groupID, groupAvatarUrl: groupAvatarUrl, groupName: groupName);
    ZIMGroupAdvancedConfigWeb? _config;

    if (config != null) {
      final groupNotice = config["groupNotice"];
      final groupAttributes = config["groupAttributes"];
      _config = ZIMGroupAdvancedConfigWeb(groupAttributes: groupAttributes, groupNotice: groupNotice);
    }

    final result = await promiseToFuture(ZIM.getInstance()!.createGroup(_groupInfo, userIDs, _config));

    jsonDecode(JsObject.fromBrowserObject(result.groupInfo.groupAttributes).toString());

    Map resultMap = {
      "groupInfo": {
        "baseInfo": {
          "groupID": result.groupInfo.baseInfo.groupID,
          "groupName": result.groupInfo.baseInfo.groupName,
          "groupAvatarUrl": result.groupInfo.baseInfo.groupAvatarUrl
        },
        "groupNotice": result.groupInfo.groupNotice,
        "groupAttributes": {}
      },
      "userList": [],
      "errorUserList": []
    };

    result.userList.forEach((user){
      resultMap["userList"].add({
        "userID": user.userID,
        "userName": user.userName,
        "memberRole": user.memberRole,
        "memberNickname": user.memberNickname is String ? user.memberNickname : "",
        "memberAvatarUrl": user.memberAvatarUrl is String ? user.memberAvatarUrl : ""
      });
    });

    result.errorUserList.forEach((user){
      resultMap["errorUserList"].add({
        "userID": user.userID,
        "reason": user.userID
      });
    });

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> joinGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinGroup(groupID));
    return {
      "groupInfo": {
        "baseInfo": {
          "groupID": result.groupInfo.baseInfo.groupID,
          "groupName": result.groupInfo.baseInfo.groupName,
          "groupAvatarUrl": result.groupInfo.baseInfo.groupAvatarUrl
        },
        "groupNotice": result.groupInfo.groupNotice,
        "groupAttributes": result.groupInfo.groupAttributes
      }
    };
  }

  Future <Map<dynamic, dynamic>> leaveGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveGroup(groupID));

    return {
      "groupID": result.groupID
    };
  }

  Future <Map<dynamic, dynamic>> dismissGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.dismissGroup(groupID));

    return {
      "groupID": result.groupID
    };
  }

  Future <Map<dynamic, dynamic>> inviteUsersIntoGroup(List<String> userIDs, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.inviteUsersIntoGroup(userIDs, groupID));

    final resultMap = {
      "groupID": result.groupID,
      "userList": [],
      "errorUserList": []
    };

    result.userList.forEach((user){
      resultMap["userList"].add({
        "userID": user.userID,
        "userName": user.userName,
        "memberRole": user.memberRole,
        "memberNickname": user.memberNickname is String ? user.memberNickname : "",
        "memberAvatarUrl": user.memberAvatarUrl is String ? user.memberAvatarUrl : ""
      });
    });

    result.errorUserList.forEach((user){
      resultMap["errorUserList"].add({
        "userID": user.userID,
        "reason": user.userID
      });
    });

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> kickGroupMembers(List<String> userIDs, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.kickGroupMembers(userIDs, groupID));

    final resultMap = {
      "groupID": result.groupID,
      "kickedUserIDList": result.kickedUserIDList,
      "errorUserList": []
    };

    result.errorUserList.forEach((user){
      resultMap["errorUserList"].add({
        "userID": user.userID,
        "reason": user.userID
      });
    });

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> transferGroupOwner(String toUserID, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.transferGroupOwner(toUserID, groupID));

    return {
      "groupID": result.groupID,
      "toUserID": result.toUserID
    };
  }

  Future <Map<dynamic, dynamic>> updateGroupName(String groupName, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.updateGroupName(groupName, groupID));

    return {
      "groupID": result.groupID,
      "groupName": result.groupName
    };
  }

  Future <Map<dynamic, dynamic>> updateGroupAvatarUrl(String groupAvatarUrl, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.updateGroupAvatarUrl(groupAvatarUrl, groupID));

    return {
      "groupID": result.groupID,
      "groupAvatarUrl": result.groupAvatarUrl
    };
  }

  Future <Map<dynamic, dynamic>> updateGroupNotice(String groupNotice, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.updateGroupNotice(groupNotice, groupID));

    return {
      "groupID": result.groupID,
      "groupNotice": result.groupNotice
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupInfo(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupInfo(groupID));

    window.console.warn(JsObject.fromBrowserObject(result.groupInfo.groupAttributes));

    return {
      "groupInfo": {
        "baseInfo": {
          "groupID": result.groupInfo.baseInfo.groupID,
          "groupName": result.groupInfo.baseInfo.groupName,
          "groupAvatarUrl": result.groupInfo.baseInfo.groupAvatarUrl is String? result.groupInfo.baseInfo.groupAvatarUrl : ""
        },
        "groupNotice": result.groupInfo.groupNotice is String? result.groupInfo.groupNotice : "",
        "groupAttributes": {}
      }
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupList() async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupList());

    return {
      "groupList": result.groupList
    };
  }

  Future <Map<dynamic, dynamic>> setGroupAttributes(Map<dynamic, dynamic> groupAttributes, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setGroupAttributes(groupAttributes, groupID));

    return {
      "groupID": result.groupID,
      "errorKeys": result.errorKeys
    };
  }

  Future <Map<dynamic, dynamic>> deleteGroupAttributes(List<String> keys, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.deleteGroupAttributes(keys, groupID));

    return {
      "groupID": result.groupID,
      "errorKeys": result.errorKeys
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupAttributes(List<String> keys, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupAttributes(keys, groupID));

    return {
      "groupID": result.groupID,
      "groupAttributes": JsObject.fromBrowserObject(result.groupAttributes)
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupAllAttributes(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupAllAttributes(groupID));

    return {
      "groupID": result.groupID,
      "groupAttributes": result.groupAttributes
    };
  }

  Future <Map<dynamic, dynamic>> setGroupMemberRole(int role, String forUserID, String groupID,) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setGroupMemberRole(role, forUserID, groupID));

    return {
      "groupID": result.groupID,
      "forUserID": result.forUserID,
      "role": result.role
    };
  }

  Future <Map<dynamic, dynamic>> setGroupMemberNickname(String nickname, String forUserID, String groupID,) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setGroupMemberNickname(nickname, forUserID, groupID));

    return {
      "groupID": result.groupID,
      "forUserID": result.forUserID,
      "nickname": result.nickname
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupMemberInfo(String userID, String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupMemberInfo(userID, groupID));

    return {
      "groupID": result.groupID,
      "userInfo": {
        "userID": result.userInfo.userID,
        "userName": result.userInfo.userName,
        "memberRole": result.userInfo.memberRole,
        "memberNickname": result.userInfo.memberNickname is String? result.userInfo.memberNickname : "",
        "memberAvatarUrl": result.userInfo.memberAvatarUrl is String? result.userInfo.memberAvatarUrl : ""
      }
    };
  }

  Future <Map<dynamic, dynamic>> queryGroupMemberList(String groupID, dynamic config) async {
    ZIMGroupMemberQueryConfigWeb? _config;

    if (config != null) {
      final count = config["count"];
      final nextFlag = config["nextFlag"];

      _config = ZIMGroupMemberQueryConfigWeb(count: count,nextFlag: nextFlag);
    }

    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupMemberList(groupID, _config));

    Map resultMap = {
      "groupID": result.groupID,
      "nextFlag": result.nextFlag,
      "userList": []
    };

    result.userList.forEach((user) {
      resultMap["userList"].add({
        "userID": user.userID,
        "userName": user.userName,
        "memberRole": user.memberRole,
        "memberNickname": user.memberNickname is String ? user.memberNickname : "",
        "memberAvatarUrl": user.memberAvatarUrl is String ? user.memberAvatarUrl : ""
      });
    });

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> deleteConversation(String conversationID,dynamic conversationType, dynamic config) async {
    ZIMConversationDeleteConfigWeb? _config;
    if (config != null) {
      bool isAlsoDeleteServerConversation = config["isAlsoDeleteServerConversation"];
      _config = ZIMConversationDeleteConfigWeb(isAlsoDeleteServerConversation: isAlsoDeleteServerConversation);
    }

    final result = await promiseToFuture(ZIM.getInstance()!.deleteConversation(conversationID, conversationType, _config));

    return {
      "conversationID": result.conversationID,
      "conversationType": result.conversationType
    };
  }

  Future <Map<dynamic, dynamic>> setConversationNotificationStatus(dynamic status, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setConversationNotificationStatus(status, conversationID, conversationType));

    return {
      "conversationID": result.conversationID,
      "conversationType": result.conversationType
    };
  }

  Future <Map<dynamic, dynamic>> callInvite(List<String> invitees, dynamic config) async {
    ZIMCallInviteConfigWeb? _config;

    if (config != null) {
      final extendedData = config["extendedData"];
      ZIMCallInviteConfigWeb _config = ZIMCallInviteConfigWeb(extendedData: extendedData);
    }

    final result = await promiseToFuture(ZIM.getInstance()!.callInvite(invitees, _config));

    Map resultMap = {
      "callID": result.callID,
      "info": {
        "timeout": result.timeout,
        "errorInvitees": []
      }
    };

    result.errorInvitees.forEach((invite) {
      resultMap["info"]["errorInvitees"].add({
        "userID": invite.userID,
        "state": invite.state
      });
    });

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> callCancel(List<String> invitees, String callID, dynamic config) async {
    final extendedData = config["extendedData"];
    ZIMCallCancelConfigWeb _config = ZIMCallCancelConfigWeb(extendedData: extendedData);

    final result = await promiseToFuture(ZIM.getInstance()!.callCancel(invitees, callID, _config));

    Map resultMap = {
      "callID": result.callID,
      "errorInvitees": result.errorInvitees
    };

    return resultMap;
  }

  Future <Map<dynamic, dynamic>> callAccept(String callID, dynamic config) async {
    final extendedData = config["extendedData"];
    ZIMCallAcceptConfigWeb _config = ZIMCallAcceptConfigWeb(extendedData: extendedData);

    final result = await promiseToFuture(ZIM.getInstance()!.callAccept(callID, _config));

    return {
      "callID": result.callID
    };
  }

  Future <Map<dynamic, dynamic>> callReject(String callID, dynamic config) async {
    final extendedData = config["extendedData"];
    ZIMCallRejectConfigWeb _config = ZIMCallRejectConfigWeb(extendedData: extendedData);

    final result = await promiseToFuture(ZIM.getInstance()!.callReject(callID, _config));

    return {
      "callID": result.callID
    };
  }

  static void connectionStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConnectionStateChanged == null) return;

    Map<dynamic, dynamic> extendedData = {};

    if (data["extendedData"] != null && data["extendedData"] != "") {
      extendedData = json.decode(data["extendedData"]);
    }


    ZIMConnectionState? _state = ZIMConnectionState.values[data["state"]];
    ZIMConnectionEvent? _event = ZIMConnectionEvent.values[data["event"]];

    ZIMEventHandler.onConnectionStateChanged!(zim, _state, _event, extendedData);
  }

  static void errorHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onError == null) return;


    ZIMEventHandler.onError!(zim, ZIMError(code: data["code"], message: data["message"]));


  }

  static void tokenWillExpireHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onTokenWillExpire == null) return;

    final second = data["second"];

    ZIMEventHandler.onTokenWillExpire!(zim, second);

  }

  static void receiveRoomMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveRoomMessage == null) return;

    List<ZIMMessage> messageList = [];
    final fromConversationID =  data["fromConversationID"];

    data["messageList"].forEach((msg)  {
      ZIMMessage zMsg = ZIMMessage();
      zMsg.localMessageID = msg.localMessageID;
      zMsg.messageID = msg.messageID;
      zMsg.senderUserID = msg.senderUserID;
      zMsg.timestamp = msg.timestamp;
      zMsg.conversationID = msg.conversationID;
      zMsg.conversationType = ZIMConversationType.values[msg.conversationType];
      zMsg.direction = ZIMMessageDirection.values[msg.direction];
      zMsg.sentStatus = ZIMMessageSentStatus.values[msg.sentStatus];
      zMsg.orderKey = msg.orderKey;
      zMsg.conversationSeq = msg.conversationSeq;

      messageList.add(zMsg);
    });

    ZIMEventHandler.onReceiveRoomMessage!(zim, messageList, fromConversationID);

  }

  static void roomStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomStateChanged == null) return;

    Map<dynamic, dynamic> extendedData = {};

    if (data["extendedData"] != null && data["extendedData"] != "") {
      extendedData = json.decode(data["extendedData"]);
    }

    ZIMRoomState _state = ZIMRoomState.values[data["state"]];
    ZIMRoomEvent _event = ZIMRoomEvent.values[data["event"]];

    ZIMEventHandler.onRoomStateChanged!(zim, _state, _event, extendedData, data["roomID"]);
  }

  static void roomAttributesUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

    final infos = data["infos"];
    String roomID = data["roomID"];

    infos.forEach((info) {

        ZIMRoomAttributesUpdateAction action = ZIMRoomAttributesUpdateAction.values[info.action];

        ZIMEventHandler.onRoomAttributesUpdated!(zim, ZIMRoomAttributesUpdateInfo(action: action, roomAttributes: info.roomAttributes), roomID);

    });

  }

  static void roomAttributesBatchUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

    final infos = data["infos"];
    String roomID = data["roomID"];

    List<ZIMRoomAttributesUpdateInfo> list = [];

    infos.forEach((info) {
      ZIMRoomAttributesUpdateAction action = ZIMRoomAttributesUpdateAction.values[info.action];

      list.add(ZIMRoomAttributesUpdateInfo(action: action, roomAttributes: info.roomAttributes));

    });

    ZIMEventHandler.onRoomAttributesBatchUpdated!(zim, list, roomID);
  }

  static void roomMemberJoinedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberJoined == null) return;

    final memberList = data["memberList"];
    String roomID = data["roomID"];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = member.userID;
      userInfo.userName = member.userName;

      list.add(userInfo);
    });

    ZIMEventHandler.onRoomMemberJoined!(zim, list, roomID);
  }

  static void roomMemberLeftHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberLeft == null) return;

    final memberList = data["memberList"];
    String roomID = data["roomID"];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = member.userID;
      userInfo.userName = member.userName;

      list.add(userInfo);
    });

    ZIMEventHandler.onRoomMemberLeft!(zim, list, roomID);
  }

  static void receivePeerMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceivePeerMessage == null) return;

    final messageList = data["memberList"];
    String fromConversationID = data["fromConversationID"];
    List<ZIMMessage> list = [];

    messageList.forEach((message) {
      ZIMMessage msg = ZIMMessage();
      msg.type = ZIMMessageType.values[message.type];
      msg.messageID = message.messageID;
      msg.localMessageID = message.localMessageID;
      msg.senderUserID = message.senderUserID;
      msg.conversationID = message.conversationID;
      msg.direction = ZIMMessageDirection.values[message.direction];
      msg.sentStatus = ZIMMessageSentStatus.values[message.sentStatus];
      msg.conversationType = ZIMConversationType.values[message.conversationType];
      msg.timestamp = message.timestamp;
      msg.conversationSeq = message.conversationSeq;
      msg.orderKey = message.orderKey;

      list.add(msg);
    });

    ZIMEventHandler.onReceivePeerMessage!(zim, list, fromConversationID);
  }

  static void receiveGroupMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveGroupMessage == null) return;

    final messageList = data["memberList"];
    String fromConversationID = data["fromConversationID"];
    List<ZIMMessage> list = [];

    messageList.forEach((message) {
      ZIMMessage msg = ZIMMessage();
      msg.type = ZIMMessageType.values[message.type];
      msg.messageID = message.messageID;
      msg.localMessageID = message.localMessageID;
      msg.senderUserID = message.senderUserID;
      msg.conversationID = message.conversationID;
      msg.direction = ZIMMessageDirection.values[message.direction];
      msg.sentStatus = ZIMMessageSentStatus.values[message.sentStatus];
      msg.conversationType = ZIMConversationType.values[message.conversationType];
      msg.timestamp = message.timestamp;
      msg.conversationSeq = message.conversationSeq;
      msg.orderKey = message.orderKey;

      list.add(msg);
    });

    ZIMEventHandler.onReceiveGroupMessage!(zim, list, fromConversationID);
  }

  static void groupStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupStateChanged == null) return;

    final state = ZIMGroupState.values[data["state"]];
    final event = ZIMGroupEvent.values[data["event"]];
    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);

    ZIMGroupInfo baseInfo = ZIMGroupInfo();
    baseInfo.groupID = data["groupInfo"].baseInfo.groupID;
    baseInfo.groupName = data["groupInfo"].baseInfo.groupName;
    baseInfo.groupAvatarUrl = data["groupInfo"].baseInfo.groupAvatarUrl;

    ZIMGroupFullInfo fullInfo = ZIMGroupFullInfo(baseInfo: baseInfo);
    fullInfo.groupNotice = data["groupInfo"].groupNotice;
    fullInfo.groupAttributes = data["groupInfo"].groupAttributes;
    fullInfo.notificationStatus = ZIMGroupMessageNotificationStatus.values[data["groupInfo"].notificationStatus];

    ZIMEventHandler.onGroupStateChanged!(zim, state, event, info, fullInfo);
  }

  static void groupNameUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNameUpdated == null) return;

    final groupName = data["groupName"];
    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);

    ZIMEventHandler.onGroupNameUpdated!(zim, groupName, info, groupID);
  }

  static void groupAvatarUrlUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;

    final groupAvatarUrl = data["groupAvatarUrl"];
    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);


    ZIMEventHandler.onGroupAvatarUrlUpdated!(zim, groupAvatarUrl, info, groupID);
  }

  static void groupNoticeUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNoticeUpdated == null) return;


    final groupNotice = data["groupNotice"];
    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);


    ZIMEventHandler.onGroupNoticeUpdated!(zim, groupNotice, info, groupID);
  }

  static void groupAttributesUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

    List<ZIMGroupAttributesUpdateInfo> list = [];
    List<dynamic> infoList = data["infoList"];

    infoList.forEach((info) {
      ZIMGroupAttributesUpdateInfo atr = ZIMGroupAttributesUpdateInfo();
      atr.action = ZIMGroupAttributesUpdateAction.values[info.action];
      atr.groupAttributes = info.groupAttributes;
      list.add(atr);
    });

    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);



    ZIMEventHandler.onGroupAttributesUpdated!(zim, list, info, groupID);
  }

  static void groupMemberStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

    final groupID = data["groupID"];
    ZIMGroupMemberState state = ZIMGroupMemberState.values[data["state"]];
    ZIMGroupMemberEvent event = ZIMGroupMemberEvent.values[data["event"]];
    List<dynamic> userList = data["userList"];
    List<ZIMGroupMemberInfo> list = [];

    userList.forEach((user) {
      ZIMGroupMemberInfo info = ZIMGroupMemberInfo();
      info.userID = user.userID;
      info.userName = user.userName;
      info.memberRole = user.memberRole;
      info.memberNickname = user.memberNickname;
      info.memberAvatarUrl = user.memberAvatarUrl;

      list.add(info);
    });

    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);


    ZIMEventHandler.onGroupMemberStateChanged!(zim, state, event, list, info, groupID);
  }

  static void groupMemberInfoUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

    List<dynamic> userList = data["userList"];
    List<ZIMGroupMemberInfo> list = [];

    userList.forEach((user) {
      ZIMGroupMemberInfo info = ZIMGroupMemberInfo();
      info.userID = user.userID;
      info.userName = user.userName;
      info.memberRole = user.memberRole;
      info.memberNickname = user.memberNickname;
      info.memberAvatarUrl = user.memberAvatarUrl;

      list.add(info);
    });

    final groupID = data["groupID"];
    final userID = data["operatedInfo"].userID;
    final userName = data["operatedInfo"].userID;
    final memberNickname = data["operatedInfo"].memberNickname;
    final memberRole = data["operatedInfo"].memberRole;

    ZIMGroupMemberInfo operatedUserInfo = ZIMGroupMemberInfo();

    operatedUserInfo.userID = data["operatedInfo"].operatedUserInfo.userID;
    operatedUserInfo.userName = data["operatedInfo"].operatedUserInfo.userName;
    operatedUserInfo.memberRole = data["operatedInfo"].operatedUserInfo.memberRole;
    operatedUserInfo.memberNickname = data["operatedInfo"].operatedUserInfo.memberNickname;
    operatedUserInfo.memberAvatarUrl = data["operatedInfo"].operatedUserInfo.memberAvatarUrl;

    ZIMGroupOperatedInfo info = ZIMGroupOperatedInfo(operatedUserInfo: operatedUserInfo, userID: userID,userName: userName, memberNickname: memberNickname, memberRole: memberRole);

    ZIMEventHandler.onGroupMemberInfoUpdated!(zim, list, info, groupID);
  }

  static void callInvitationReceivedHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationReceived == null) return;

    ZIMCallInvitationReceivedInfo receivedInfo = ZIMCallInvitationReceivedInfo ();
    receivedInfo.inviter = data["inviter"];
    receivedInfo.extendedData = data["extendedData"];
    receivedInfo.timeout = data["timeout"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationReceived!(zim, receivedInfo, callID);
  }

  static void callInvitationCancelledHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationCancelled == null) return;

    ZIMCallInvitationCancelledInfo cancelledInfo = ZIMCallInvitationCancelledInfo ();
    cancelledInfo.inviter = data["inviter"];
    cancelledInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationCancelled!(zim, cancelledInfo, callID);
  }

  static void callInvitationTimeoutHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationTimeout == null) return;

    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationTimeout!(zim, callID);
  }

  static void callInvitationAcceptedHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationAccepted == null) return;

    ZIMCallInvitationAcceptedInfo acceptedInfo = ZIMCallInvitationAcceptedInfo();
    acceptedInfo.invitee = data["invitee"];
    acceptedInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationAccepted!(zim, acceptedInfo, callID);
  }

  static void callInvitationRejectedHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationRejected == null) return;

    ZIMCallInvitationRejectedInfo rejectedInfo = ZIMCallInvitationRejectedInfo();
    rejectedInfo.invitee = data["invitee"];
    rejectedInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationRejected!(zim, rejectedInfo, callID);
  }

  static void callInviteesAnsweredTimeoutHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

    List<String> invitees = data["invitees"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInviteesAnsweredTimeout!(zim, invitees, callID);
  }

  static void conversationChangedHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationChanged == null) return;

    List<ZIMConversationChangeInfo> list = [];
    List<dynamic> infoList = data["infoList"];

    infoList.forEach((info) {
      ZIMConversationChangeInfo changeInfo = ZIMConversationChangeInfo();
      ZIMConversation conversation = ZIMConversation();
      conversation.conversationID = info.conversation.conversationID;
      conversation.conversationName = info.conversation.conversationName;
      conversation.conversationAvatarUrl = info.conversation.conversationAvatarUrl;
      conversation.type = ZIMConversationType.values[info.conversation.type];
      conversation.unreadMessageCount = info.conversation.unreadMessageCount;
      conversation.orderKey = info.conversation.orderKey;
      conversation.notificationStatus = ZIMConversationNotificationStatus.values[info.conversation.notificationStatus];
      final lastMessage = ZIMMessage();

      lastMessage.localMessageID = info.conversation.lastMessage.localMessageID;
      lastMessage.messageID = info.conversation.lastMessage.messageID;
      lastMessage.senderUserID = info.conversation.lastMessage.senderUserID;
      lastMessage.timestamp = info.conversation.lastMessage.timestamp;
      lastMessage.conversationID = info.conversation.lastMessage.conversationID;
      lastMessage.conversationType = ZIMConversationType.values[info.conversation.lastMessage.conversationType];
      lastMessage.direction = ZIMMessageDirection.values[info.conversation.lastMessage.direction];
      lastMessage.sentStatus = ZIMMessageSentStatus.values[info.conversation.lastMessage.sentStatus];
      lastMessage.orderKey = info.conversation.lastMessage.orderKey;
      lastMessage.conversationSeq = info.conversation.lastMessage.conversationSeq;

      conversation.lastMessage = lastMessage;

      changeInfo.conversation = conversation;
      changeInfo.event = ZIMConversationEvent.values[info.event];
    });


    ZIMEventHandler.onConversationChanged!(zim, list);
  }

  static void conversationTotalUnreadMessageCountUpdatedHandle (ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated == null) return;

    int count = data["totalUnreadMessageCount"];

    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(zim, count);
  }

}
