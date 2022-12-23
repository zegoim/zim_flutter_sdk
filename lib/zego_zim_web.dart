import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js;
import 'dart:js';

import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zego_zim/src/internal/zim_common_data.dart';
import 'package:zego_zim/src/internal/zim_converter.dart';
import 'package:zego_zim/src/internal/zim_defines_extension.dart';
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

  static final StreamController _evenController = StreamController.broadcast();

  static void registerWith(Registrar registrar) {
    //ZimFlutterSdkPlatform.instance = ZimFlutterSdkWeb();
    final MethodChannel channel = MethodChannel(
      'zego_zim_plugin',
      const StandardMethodCodec(),
      registrar,
    );

    final eventChannel = PluginEventChannel(
        'zim_event_handler', const StandardMethodCodec(), registrar);

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
        return setLogConfig(call.arguments["logLevel"]);
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
        return queryRoomMemberList(
            call.arguments["roomID"], call.arguments["config"]);
      case 'queryRoomOnlineMemberCount':
        return queryRoomOnlineMemberCount(call.arguments["roomID"]);
      case 'queryRoomAllAttributes':
        return queryRoomAllAttributes(call.arguments["roomID"]);
      case 'setRoomAttributes':
        return setRoomAttributes(call.arguments["roomAttributes"],
            call.arguments["roomID"], call.arguments["config"]);
      case 'deleteRoomAttributes':
        return deleteRoomAttributes(call.arguments["keys"],
            call.arguments["roomID"], call.arguments["config"]);
      case 'beginRoomAttributesBatchOperation':
        return beginRoomAttributesBatchOperation(
            call.arguments["roomID"], call.arguments["config"]);
      case 'endRoomAttributesBatchOperation':
        return endRoomAttributesBatchOperation(call.arguments["roomID"]);
      case 'createRoomWithConfig':
        return createRoom(call.arguments["roomInfo"], call.arguments["config"]);
      case 'renewToken':
        return renewToken(call.arguments["token"]);
      case 'queryUsersInfo':
        return queryUsersInfo(
            call.arguments["userIDs"], call.arguments["config"]);
      case 'queryConversationList':
        return queryConversationList(call.arguments["config"]);
      case 'updateUserName':
        return updateUserName(call.arguments["userName"]);
      case 'updateUserAvatarUrl':
        return updateUserAvatarUrl(call.arguments["userAvatarUrl"]);
      case 'updateUserExtendedData':
        return updateUserExtendedData(call.arguments["extendedData"]);
      case 'clearConversationUnreadMessageCount':
        return clearConversationUnreadMessageCount(
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'queryHistoryMessage':
        return queryHistoryMessage(call.arguments["conversationID"],
            call.arguments["conversationType"], call.arguments["config"]);
      case 'sendMediaMessage':
        return sendMediaMessage(
            call.arguments["message"],
            call.arguments["toConversationID"],
            call.arguments["conversationType"],
            call.arguments["config"],
            call.arguments["messageID"],
            call.arguments["progressID"],
            call.arguments["messageAttachedCallbackID"]);
      case 'downloadMediaFile':
        return downloadMediaFile(call.arguments["message"],
            call.arguments["fileType"], call.arguments["progressID"]);
      case 'sendPeerMessage':
        return sendPeerMessage(call.arguments["message"],
            call.arguments["toUserID"], call.arguments["config"]);
      case 'sendRoomMessage':
        return sendRoomMessage(call.arguments["message"],
            call.arguments["toRoomID"], call.arguments["config"]);
      case 'sendGroupMessage':
        return sendGroupMessage(call.arguments["message"],
            call.arguments["toGroupID"], call.arguments["config"]);
      case 'deleteMessages':
        return deleteMessages(
            call.arguments["messageList"],
            call.arguments["conversationID"],
            call.arguments["conversationType"],
            call.arguments["config"]);
      case 'deleteAllMessage':
        return deleteAllMessage(call.arguments["conversationID"],
            call.arguments["conversationType"], call.arguments["config"]);
      case 'createGroup':
        return createGroup(call.arguments["groupInfo"],
            call.arguments["userIDs"], call.arguments["config"]);
      case 'joinGroup':
        return joinGroup(call.arguments["groupID"]);
      case 'leaveGroup':
        return leaveGroup(call.arguments["groupID"]);
      case 'dismissGroup':
        return dismissGroup(call.arguments["groupID"]);
      case 'inviteUsersIntoGroup':
        return inviteUsersIntoGroup(
            call.arguments["userIDs"], call.arguments["groupID"]);
      case 'kickGroupMembers':
        return kickGroupMembers(
            call.arguments["userIDs"], call.arguments["groupID"]);
      case 'transferGroupOwner':
        return transferGroupOwner(
            call.arguments["toUserID"], call.arguments["groupID"]);
      case 'updateGroupName':
        return updateGroupName(
            call.arguments["groupName"], call.arguments["groupID"]);
      case 'updateGroupAvatarUrl':
        return updateGroupAvatarUrl(
            call.arguments["groupAvatarUrl"], call.arguments["groupID"]);
      case 'updateGroupNotice':
        return updateGroupNotice(
            call.arguments["groupNotice"], call.arguments["groupID"]);
      case 'queryGroupInfo':
        return queryGroupInfo(call.arguments["groupID"]);
      case 'queryGroupList':
        return queryGroupList();
      case 'setGroupAttributes':
        return setGroupAttributes(
            call.arguments["groupAttributes"], call.arguments["groupID"]);
      case 'deleteGroupAttributes':
        return deleteGroupAttributes(
            call.arguments["keys"], call.arguments["groupID"]);
      case 'queryGroupAttributes':
        return queryGroupAttributes(
            call.arguments["keys"], call.arguments["groupID"]);
      case 'queryGroupAllAttributes':
        return queryGroupAllAttributes(call.arguments["groupID"]);
      case 'setGroupMemberRole':
        return setGroupMemberRole(call.arguments["role"],
            call.arguments["forUserID"], call.arguments["groupID"]);
      case 'setGroupMemberNickname':
        return setGroupMemberNickname(call.arguments["nickname"],
            call.arguments["forUserID"], call.arguments["groupID"]);
      case 'queryGroupMemberInfo':
        return queryGroupMemberInfo(
            call.arguments["userID"], call.arguments["groupID"]);
      case 'queryGroupMemberList':
        return queryGroupMemberList(
            call.arguments["groupID"], call.arguments["config"]);
      case 'deleteConversation':
        return deleteConversation(call.arguments["conversationID"],
            call.arguments["conversationType"], call.arguments["config"]);
      case 'setConversationNotificationStatus':
        return setConversationNotificationStatus(
            call.arguments["status"],
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'callInvite':
        return callInvite(call.arguments["invitees"], call.arguments["config"]);
      case 'callCancel':
        return callCancel(call.arguments["invitees"], call.arguments["callID"],
            call.arguments["config"]);
      case 'callAccept':
        return callAccept(call.arguments["callID"], call.arguments["config"]);
      case 'callReject':
        return callReject(call.arguments["callID"], call.arguments["config"]);
      case 'queryRoomMemberAttributesList':
        return queryRoomMemberAttributesList(
            call.arguments["roomID"], call.arguments["config"]);
      case 'queryRoomMembersAttributes':
        return queryRoomMembersAttributes(
            call.arguments["userIDs"], call.arguments["roomID"]);
      case 'sendMessage':
        return sendMessage(
            call.arguments["message"],
            call.arguments["toConversationID"],
            call.arguments["conversationType"],
            call.arguments["config"],
            call.arguments["messageAttachedCallbackID"],
            call.arguments["messageID"]);
      case 'insertMessageToLocalDB':
        return insertMessageToLocalDB(
            call.arguments["message"],
            call.arguments["messageID"],
            call.arguments["conversationID"],
            call.arguments["conversationType"],
            call.arguments["senderUserID"]);
      case 'setRoomMembersAttributes':
        return setRoomMembersAttributes(call.arguments["attributes"], call.arguments["roomID"], call.arguments["userIDs"], call.arguments["config"]);
      case 'sendConversationMessageReceiptRead':
        return sendConversationMessageReceiptRead(call.arguments["conversationID"], call.arguments["conversationType"]);
      case 'sendMessageReceiptsRead':
        return sendMessageReceiptsRead(call.arguments["messageList"], call.arguments["conversationID"], call.arguments["conversationType"]);
      case 'queryMessageReceiptsInfo':
        return queryMessageReceiptsInfo(call.arguments["messageList"], call.arguments["conversationID"], call.arguments["conversationType"]);
      case 'queryGroupMessageReceiptReadMemberList':
        return queryGroupMessageReceiptReadMemberList(call.arguments["message"], call.arguments["groupID"], call.arguments["config"]);
      case 'queryGroupMessageReceiptUnreadMemberList':
        return queryGroupMessageReceiptUnreadMemberList(call.arguments["message"], call.arguments["groupID"], call.arguments["config"]);
      case 'revokeMessage':
        return revokeMessage(call.arguments["message"], call.arguments["config"]);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'zim for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  static void _eventListener(dynamic event) {
    final data = json.decode(event["data"]);
    String handle = event["handle"];
    ZIMEngine? _zim = ZIMManager.engineMap[handle];

    if (_zim != null) {
      switch (event["ev"]) {
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
        case "conversationMessageReceiptChanged":
          return conversationMessageReceiptChangedHandle(_zim, data);
        case "messageReceiptChanged":
          return messageReceiptChangedHandle(_zim, data);
        case "messageRevokeReceived":
          return messageRevokeReceivedHandle(_zim, data);
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
    Object _appConfig = mapToJSObj(appConfig);

    ZIM? zim = ZIM.create(_appConfig);

    if (zim != null) {
      handleMap[handle] = zim;
    } else if (handleMap.isNotEmpty) {
      handleMap[handle] = handleMap.values.first;
    }

    ZIM.setEventHandler(allowInterop((dynamic zim, event, String data) {
      String handle = getHandle(zim);
      _evenController.add({'handle': handle, 'ev': event, 'data': data});
    }));
    return Future.value();
  }

  static Future<void> destroy() async {
    ZIM.destroy();

    return Future.value();
  }

  static Future<void> setLogConfig(int logLevel) {
    Map config = {"logLevel": logLevel};

    ZIM.getInstance()?.setLogConfig(mapToJSObj(config));

    return Future.value();
  }

  static void setCacheConfig() {
    return;
  }

  Future<void> login(String userID, String userName, String token) async {
    ZIMUserInfoWeb _userInfo =
        ZIMUserInfoWeb(userID: userID, userName: userName);

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
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.queryConversationList(_config));

    Map resultMap = jsObjectToMap(result);

    resultMap["conversationList"].forEach((conversation) {
      var index = resultMap["conversationList"].indexOf(conversation);
      resultMap["conversationList"][index]["lastMessage"]["localMessageID"] =
          int.parse(resultMap["conversationList"][index]["lastMessage"]
              ["localMessageID"]);
      resultMap["conversationList"][index]["lastMessage"]["messageID"] =
          int.parse(
              resultMap["conversationList"][index]["lastMessage"]["messageID"]);
      resultMap["conversationList"][index]["lastMessage"]["isUserInserted"] =
          resultMap["conversationList"][index]["lastMessage"]["isUserInserted"] is bool ? resultMap["conversationList"][index]["lastMessage"]["isUserInserted"] : false;
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> updateUserAvatarUrl(
      String userAvatarUrl) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserName(String userName) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.updateUserName(userName));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserExtendedData(
      String extendedData) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.updateUserExtendedData(extendedData));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> renewToken(String token) async {
    var result = await promiseToFuture(ZIM.getInstance()!.renewToken(token));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryUsersInfo(
      dynamic userIDs, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.queryUsersInfo(userIDs, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> clearConversationUnreadMessageCount(
      String conversationID, int conversationType) async {
    final result = await promiseToFuture(ZIM
        .getInstance()!
        .clearConversationUnreadMessageCount(conversationID, conversationType));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryHistoryMessage(
      String conversationID, int conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
        .getInstance()!
        .queryHistoryMessage(conversationID, conversationType, _config));

    final resultMap = jsObjectToMap(result);

    resultMap["messageList"].forEach((message) {
      var index = resultMap["messageList"].indexOf(message);
      resultMap["messageList"][index]["localMessageID"] =
          int.parse(resultMap["messageList"][index]["localMessageID"]);
      resultMap["messageList"][index]["messageID"] =
          int.parse(resultMap["messageList"][index]["messageID"]);
      resultMap["messageList"][index]["isUserInserted"] =
          resultMap["messageList"][index]["isUserInserted"] is bool ? resultMap["messageList"][index]["isUserInserted"] : false;
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> createRoom(
      dynamic roomInfo, dynamic config) async {
    Object _roomInfo = mapToJSObj(roomInfo);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.createRoom(_roomInfo, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> enterRoom(
      dynamic roomInfo, dynamic config) async {
    Object _roomInfo = mapToJSObj(roomInfo);
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.enterRoom(_roomInfo, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> joinRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinRoom(roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> leaveRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveRoom(roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberList(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.queryRoomMemberList(roomID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomOnlineMemberCount(
      String roomID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryRoomOnlineMemberCount(roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomAllAttributes(String roomID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryRoomAllAttributes(roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setRoomAttributes(
      Map roomAttributes, String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
        .getInstance()!
        .setRoomAttributes(mapToJSObj(roomAttributes), roomID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteRoomAttributes(
      dynamic keys, String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.deleteRoomAttributes(keys, roomID, _config));

    return jsObjectToMap(result);
  }

  Future<void> beginRoomAttributesBatchOperation(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    await promiseToFuture(
        ZIM.getInstance()!.beginRoomAttributesBatchOperation(roomID, _config));

    return;
  }

  Future<Map<dynamic, dynamic>> endRoomAttributesBatchOperation(
      String roomID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.endRoomAttributesBatchOperation(roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendMediaMessage(
      dynamic message,
      String toConversationID,
      dynamic conversationType,
      dynamic config,
      int messageID,
      int progressID,
      int messageAttachedCallbackID) async {
    Object _message = mapToJSObj(message);

    Object _config = mapToJSObj(config);

    Map notification = {
      "onMessageAttached":
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          ZIMMessage zimMessage = getZIMMessage(message);
          callback(zimMessage);
        }
      }),
      "onMediaUploadingProgress":
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMediaDownloadingProgress? progress =
            ZIMCommonData.mediaDownloadingProgressMap[progressID];

        if (progress != null) {
          ZIMMessage zimMessage = getZIMMessage(message);
          progress(zimMessage, currentFileSize, totalFileSize);
        }
      })
    };

    ZIMMediaDownloadingProgress? progress =
        ZIMCommonData.mediaDownloadingProgressMap[progressID];

    final result = await promiseToFuture(ZIM.getInstance()!.sendMediaMessage(
        _message,
        toConversationID,
        conversationType,
        _config,
        mapToJSObj(notification)));

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> downloadMediaFile(
      dynamic message, dynamic fileType, int progressID) async {
    return {};
  }

  Future<Map<dynamic, dynamic>> sendPeerMessage(
      dynamic message, String toUserID, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.sendPeerMessage(_message, toUserID, _config));

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> sendRoomMessage(
      dynamic message, String toRoomID, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.sendRoomMessage(_message, toRoomID, _config));

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupMessage(
      dynamic message, String toGroupID, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.sendGroupMessage(_message, toGroupID, _config));

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> deleteMessages(dynamic messageList,
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.deleteMessages(
        messageList, conversationID, conversationType, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteAllMessage(
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
        .getInstance()!
        .deleteAllMessage(conversationID, conversationType, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> createGroup(
      dynamic groupInfo, dynamic userIDs, dynamic config) async {
    Object _groupInfo = mapToJSObj(groupInfo);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.createGroup(_groupInfo, userIDs, _config));

    Map resultMap = jsObjectToMap(result);

    resultMap["userList"].forEach((user) {
      var index = resultMap["userList"].indexOf(user);
      resultMap["userList"][index]["memberNickname"] =
          resultMap["userList"][index]["memberNickname"] is String
              ? resultMap["userList"][index]["memberNickname"]
              : "";
      resultMap["userList"][index]["memberAvatarUrl"] =
          resultMap["userList"][index]["memberAvatarUrl"] is String
              ? resultMap["userList"][index]["memberAvatarUrl"]
              : "";
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> joinGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinGroup(groupID));

    Map resultMap = jsObjectToMap(result);

    resultMap["groupInfo"]["groupNotice"] =
        resultMap["groupInfo"]["groupNotice"] is String
            ? resultMap["groupInfo"]["groupNotice"]
            : "";

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> leaveGroup(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.leaveGroup(groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> dismissGroup(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.dismissGroup(groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> inviteUsersIntoGroup(
      dynamic userIDs, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.inviteUsersIntoGroup(userIDs, groupID));

    Map resultMap = jsObjectToMap(result);

    resultMap["userList"].forEach((user) {
      var index = resultMap["userList"].indexOf(user);
      resultMap["userList"][index]["memberNickname"] =
          isString(resultMap["userList"][index]["memberNickname"]);
      resultMap["userList"][index]["memberAvatarUrl"] =
          isString(resultMap["userList"][index]["memberAvatarUrl"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> kickGroupMembers(
      dynamic userIDs, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.kickGroupMembers(userIDs, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> transferGroupOwner(
      String toUserID, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.transferGroupOwner(toUserID, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupName(
      String groupName, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.updateGroupName(groupName, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.updateGroupAvatarUrl(groupAvatarUrl, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupNotice(
      String groupNotice, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.updateGroupNotice(groupNotice, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupInfo(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryGroupInfo(groupID));

    Map resultMap = jsObjectToMap(result);

    resultMap["groupInfo"]["baseInfo"]["groupAvatarUrl"] =
        isString(resultMap["groupInfo"]["baseInfo"]["groupAvatarUrl"]);
    resultMap["groupInfo"]["groupNotice"] =
        isString(resultMap["groupInfo"]["groupNotice"]);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryGroupList() async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupList());

    Map resultMap = jsObjectToMap(result);

    resultMap["groupList"].forEach((group) {
      var index = resultMap["groupList"].indexOf(group);
      resultMap["groupList"][index]["baseInfo"]["groupAvatarUrl"] =
          isString(resultMap["groupList"][index]["baseInfo"]["groupAvatarUrl"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> setGroupAttributes(
      Map<dynamic, dynamic> groupAttributes, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.setGroupAttributes(groupAttributes, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.deleteGroupAttributes(keys, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryGroupAttributes(keys, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAllAttributes(String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryGroupAllAttributes(groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberRole(
    int role,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.setGroupMemberRole(role, forUserID, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberNickname(
    String nickname,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(ZIM
        .getInstance()!
        .setGroupMemberNickname(nickname, forUserID, groupID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberInfo(
      String userID, String groupID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryGroupMemberInfo(userID, groupID));

    Map resultMap = jsObjectToMap(result);

    resultMap["userInfo"]["memberNickname"] =
        isString(resultMap["userInfo"]["memberNickname"]);
    resultMap["userInfo"]["memberAvatarUrl"] =
        isString(resultMap["userInfo"]["memberAvatarUrl"]);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberList(
      String groupID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.queryGroupMemberList(groupID, _config));

    Map resultMap = jsObjectToMap(result);

    resultMap["userList"].forEach((user) {
      var index = resultMap["userList"].indexOf(user);
      resultMap["userList"][index]["memberNickname"] =
          isString(resultMap["userList"][index]["memberNickname"]);
      resultMap["userList"][index]["memberAvatarUrl"] =
          isString(resultMap["userList"][index]["memberAvatarUrl"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> deleteConversation(
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
        .getInstance()!
        .deleteConversation(conversationID, conversationType, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setConversationNotificationStatus(
      dynamic status, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
        .getInstance()!
        .setConversationNotificationStatus(
            status, conversationID, conversationType));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callInvite(
      dynamic invitees, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callInvite(invitees, _config));

    Map _resultMap = jsObjectToMap(result);

    Map resultMap = {
      "callID": _resultMap["callID"],
      "info": {"timeout": _resultMap["timeout"], "errorInvitees": []}
    };

    _resultMap["errorInvitees"].forEach((invite) {
      resultMap["info"]["errorInvitees"].add({
        "userID": invite["userID"],
        "state": invite["state"] is int ? invite["state"] : invite["userState"]
      });
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> callCancel(
      dynamic invitees, String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.callCancel(invitees, callID, _config));

    Map _resultMap = jsObjectToMap(result);

    Map resultMap = {
      "callID": _resultMap["callID"],
      "info": {"timeout": _resultMap["timeout"], "errorInvitees": []}
    };

    _resultMap["errorInvitees"].forEach((invite) {
      resultMap["info"]["errorInvitees"].add({
        "userID": invite["userID"],
        "state": invite["state"] is int ? invite["state"] : invite["userState"]
      });
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> callAccept(
      String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callAccept(callID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callReject(
      String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callReject(callID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberAttributesList(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
        ZIM.getInstance()!.queryRoomMemberAttributesList(roomID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMembersAttributes(
      dynamic userIDs, String roomID) async {
    final result = await promiseToFuture(
        ZIM.getInstance()!.queryRoomMembersAttributes(userIDs, roomID));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendMessage(
      dynamic message,
      String toConversationID,
      dynamic conversationType,
      dynamic config,
      int? messageAttachedCallbackID,
      int messageID) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    Map notification = {
      "onMessageAttached": allowInterop((message) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          ZIMMessage zimMessage = getZIMMessage(message);

          callback(zimMessage);
        }
      })
    };

    final result = await promiseToFuture(ZIM.getInstance()!.sendMessage(
        _message,
        toConversationID,
        conversationType,
        _config,
        mapToJSObj(notification)));

    Map resultMap = handleSendMessageResult(result);
    resultMap["messageID"] = messageID;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> insertMessageToLocalDB(
      dynamic message,
      int messageID,
      String conversationID,
      dynamic conversationType,
      String senderUserID) async {
    Object _message = mapToJSObj(message);
    final result = await promiseToFuture(ZIM
        .getInstance()!
        .insertMessageToLocalDB(
            _message, conversationID, conversationType, senderUserID));

    Map resultMap = handleSendMessageResult(result);
    resultMap["messageID"] = messageID;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> setRoomMembersAttributes(Map attributes, String roomID, dynamic userIDs, dynamic config) async {
    final _attributes = mapToJSObj(attributes);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.setRoomMembersAttributes(_attributes, userIDs, roomID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendConversationMessageReceiptRead(String conversationID, dynamic conversationType) async {

    final result = await promiseToFuture(ZIM.getInstance()!.sendConversationMessageReceiptRead(conversationID, conversationType));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendMessageReceiptsRead(dynamic messageList, String conversationID, dynamic conversationType) async {

    final result = await promiseToFuture(ZIM.getInstance()!.sendMessageReceiptsRead(messageList, conversationID, conversationType));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessageReceiptsInfo(dynamic messageList, String conversationID, dynamic conversationType) async {

    final result = await promiseToFuture(ZIM.getInstance()!.queryMessageReceiptsInfo(messageList, conversationID, conversationType));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptReadMemberList(dynamic message, String groupID, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupMessageReceiptReadMemberList(_message, groupID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptUnreadMemberList(dynamic message, String groupID, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupMessageReceiptUnreadMemberList(_message, groupID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> revokeMessage(dynamic message, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.revokeMessage(_message, _config));

    return jsObjectToMap(result);
  }

  static void connectionStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConnectionStateChanged == null) return;

    Map<dynamic, dynamic> extendedData = {};

    if (data["extendedData"] != null && data["extendedData"] != "") {
      extendedData = json.decode(data["extendedData"]);
    }

    ZIMConnectionState? _state = ZIMConnectionState.values[data["state"]];
    ZIMConnectionEvent? _event = ZIMConnectionEvent.values[data["event"]];

    ZIMEventHandler.onConnectionStateChanged!(
        zim, _state, _event, extendedData);
  }

  static void errorHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onError == null) return;

    final code = data["code"];
    final message = data["message"];

    ZIMEventHandler.onError!(zim, ZIMError(code: code, message: message));
  }

  static void tokenWillExpireHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onTokenWillExpire == null) return;

    final second = data["second"];

    ZIMEventHandler.onTokenWillExpire!(zim, second);
  }

  static void receiveRoomMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveRoomMessage == null) return;

    final fromConversationID = data["fromConversationID"];

    handleReceiveMessage(data['messageList']);
    List<ZIMMessage> messageList =
        ZIMConverter.oZIMMessageList(data['messageList']);

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

    ZIMEventHandler.onRoomStateChanged!(
        zim, _state, _event, extendedData, data["roomID"]);
  }

  static void roomAttributesUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

    final infos = data["infos"];
    String roomID = data["roomID"];

    infos.forEach((info) {
      Map infoMap = jsObjectToMap(info);
      ZIMRoomAttributesUpdateAction action =
          ZIMRoomAttributesUpdateAction.values[infoMap["action"]];

      ZIMEventHandler.onRoomAttributesUpdated!(
          zim,
          ZIMRoomAttributesUpdateInfo(
              action: action, roomAttributes: infoMap["roomAttributes"]),
          roomID);
    });
  }

  static void roomAttributesBatchUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

    final infos = data["infos"];
    String roomID = data["roomID"];

    List<ZIMRoomAttributesUpdateInfo> list = [];

    infos.forEach((info) {
      Map infoMap = jsObjectToMap(info);

      ZIMRoomAttributesUpdateAction action =
          ZIMRoomAttributesUpdateAction.values[infoMap["action"]];

      list.add(ZIMRoomAttributesUpdateInfo(
          action: action, roomAttributes: infoMap["roomAttributes"]));
    });

    ZIMEventHandler.onRoomAttributesBatchUpdated!(zim, list, roomID);
  }

  static void roomMemberJoinedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberJoined == null) return;

    final memberList = data["memberList"];
    String roomID = data["roomID"];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      Map memberMap = jsObjectToMap(member);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = memberMap["userID"];
      userInfo.userName = memberMap["userName"];

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
      Map memberMap = jsObjectToMap(member);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = memberMap["userID"];
      userInfo.userName = memberMap["userName"];

      list.add(userInfo);
    });

    ZIMEventHandler.onRoomMemberLeft!(zim, list, roomID);
  }

  static void receivePeerMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceivePeerMessage == null) return;

    String fromConversationID = data["fromConversationID"];
    handleReceiveMessage(data["messageList"]);
    List<ZIMMessage> messageList =
        ZIMConverter.oZIMMessageList(data['messageList']);

    ZIMEventHandler.onReceivePeerMessage!(zim, messageList, fromConversationID);
  }

  static void receiveGroupMessageHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onReceiveGroupMessage == null) return;

    String fromConversationID = data["fromConversationID"];
    handleReceiveMessage(data["messageList"]);
    List<ZIMMessage> messageList =
        ZIMConverter.oZIMMessageList(data['messageList']);

    ZIMEventHandler.onReceiveGroupMessage!(
        zim, messageList, fromConversationID);
  }

  static void groupStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupStateChanged == null) return;

    final state = ZIMGroupState.values[data["state"]];
    final event = ZIMGroupEvent.values[data["event"]];

    ZIMEventHandler.onGroupStateChanged!(
        zim,
        state,
        event,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        ZIMConverter.oZIMGroupFullInfo(data['groupInfo'])!);
  }

  static void groupNameUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNameUpdated == null) return;

    final groupName = data["groupName"];
    final groupID = data["groupID"];

    ZIMEventHandler.onGroupNameUpdated!(zim, groupName,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupAvatarUrlUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;

    final groupAvatarUrl = data["groupAvatarUrl"];
    final groupID = data["groupID"];

    ZIMEventHandler.onGroupAvatarUrlUpdated!(zim, groupAvatarUrl,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupNoticeUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

    final groupNotice = data["groupNotice"];
    final groupID = data["groupID"];

    ZIMEventHandler.onGroupNoticeUpdated!(zim, groupNotice,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupAttributesUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

    List<ZIMGroupAttributesUpdateInfo> list = [];
    List<dynamic> infoList = data["infoList"];

    infoList.forEach((info) {
      Map infoMap = jsObjectToMap(info);
      ZIMGroupAttributesUpdateInfo atr = ZIMGroupAttributesUpdateInfo();
      atr.action = ZIMGroupAttributesUpdateAction.values[infoMap["action"]];
      atr.groupAttributes = infoMap["groupAttributes"];
      list.add(atr);
    });

    final groupID = data["groupID"];

    ZIMEventHandler.onGroupAttributesUpdated!(zim, list,
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']), groupID);
  }

  static void groupMemberStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

    final groupID = data["groupID"];
    ZIMGroupMemberState state = ZIMGroupMemberState.values[data["state"]];
    ZIMGroupMemberEvent event = ZIMGroupMemberEvent.values[data["event"]];

    ZIMEventHandler.onGroupMemberStateChanged!(
        zim,
        state,
        event,
        ZIMConverter.oZIMGroupMemberInfoList(data['userList']),
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        groupID);
  }

  static void groupMemberInfoUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

    final groupID = data["groupID"];

    ZIMEventHandler.onGroupMemberInfoUpdated!(
        zim,
        ZIMConverter.oZIMGroupMemberInfoList(data['userList']),
        ZIMConverter.oZIMGroupOperatedInfo(data['operatedInfo']),
        groupID);
  }

  static void callInvitationReceivedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationReceived == null) return;

    ZIMCallInvitationReceivedInfo receivedInfo =
        ZIMCallInvitationReceivedInfo();
    receivedInfo.inviter = data["inviter"];
    receivedInfo.extendedData = data["extendedData"];
    receivedInfo.timeout = data["timeout"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationReceived!(zim, receivedInfo, callID);
  }

  static void callInvitationCancelledHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationCancelled == null) return;

    ZIMCallInvitationCancelledInfo cancelledInfo =
        ZIMCallInvitationCancelledInfo();
    cancelledInfo.inviter = data["inviter"];
    cancelledInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationCancelled!(zim, cancelledInfo, callID);
  }

  static void callInvitationTimeoutHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationTimeout == null) return;

    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationTimeout!(zim, callID);
  }

  static void callInvitationAcceptedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationAccepted == null) return;

    ZIMCallInvitationAcceptedInfo acceptedInfo =
        ZIMCallInvitationAcceptedInfo();
    acceptedInfo.invitee = data["invitee"];
    acceptedInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationAccepted!(zim, acceptedInfo, callID);
  }

  static void callInvitationRejectedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationRejected == null) return;

    ZIMCallInvitationRejectedInfo rejectedInfo =
        ZIMCallInvitationRejectedInfo();
    rejectedInfo.invitee = data["invitee"];
    rejectedInfo.extendedData = data["extendedData"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationRejected!(zim, rejectedInfo, callID);
  }

  static void callInviteesAnsweredTimeoutHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

    dynamic invitees = data["invitees"];
    String callID = data["callID"];

    ZIMEventHandler.onCallInviteesAnsweredTimeout!(zim, invitees, callID);
  }

  static void conversationChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationChanged == null) return;

    List<dynamic> infoList = data["infoList"];

    handleConversationList(infoList);

    List<ZIMConversationChangeInfo> conversationChangeInfoList =
        ZIMConverter.oZIMConversationChangeInfoList(infoList);

    ZIMEventHandler.onConversationChanged!(zim, conversationChangeInfoList);
  }

  static void conversationTotalUnreadMessageCountUpdatedHandle(
      ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated == null) {
      return;
    }

    int count = data["totalUnreadMessageCount"];

    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(zim, count);
  }

  static void messageReceiptChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageReceiptChanged == null) {
      return;
    }

    final _infos = data["infos"];
    List<ZIMMessageReceiptInfo> infos = [];

    _infos.forEach((map) {
      ZIMMessageReceiptInfo info = ZIMConverter.oZIMMessageReceiptInfo(map);

      _infos.add(info);
    });

    ZIMEventHandler.onMessageReceiptChanged!(zim, infos);

  }

  static void conversationMessageReceiptChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationMessageReceiptChanged == null) {
      return;
    }

    final _infos = data["infos"];
    List<ZIMMessageReceiptInfo> infos = [];

    _infos.forEach((map) {
      ZIMMessageReceiptInfo info = ZIMConverter.oZIMMessageReceiptInfo(map);

      _infos.add(info);
    });

    ZIMEventHandler.onConversationMessageReceiptChanged!(zim, infos);
  }

  static void messageRevokeReceivedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageRevokeReceived == null) {
      return;
    }
    final _messageList = data["messageList"];
    List<ZIMRevokeMessage> messageList = [];

    handleReceiveMessage(_messageList);

    _messageList.forEach((map) {
      ZIMRevokeMessage message = ZIMConverter.oZIMMessage(map) as ZIMRevokeMessage;

      messageList.add(message);
    });

    ZIMEventHandler.onMessageRevokeReceived!(zim, messageList);
  }

  static Map handleSendMessageResult(dynamic result) {
    Map resultMap = jsObjectToMap(result);
    resultMap["message"]["localMessageID"] =
        int.parse(resultMap["message"]["localMessageID"]);
    resultMap["message"]["messageID"] =
        int.parse(resultMap["message"]["messageID"]);
    resultMap["message"]["isUserInserted"] =
          resultMap["message"]["isUserInserted"] is bool ? resultMap["message"]["isUserInserted"] : false;

    return resultMap;
  }

  static void handleReceiveMessage(List<dynamic> messageList) {
    messageList.forEach((msgMap) {
      msgMap["messageID"] = int.parse(msgMap["messageID"]);
      msgMap["localMessageID"] = msgMap["localMessageID"] is String
          ? int.parse(msgMap["localMessageID"])
          : 0;
      msgMap["orderKey"] = msgMap["orderKey"] is int ? msgMap["orderKey"] : 0;
      msgMap["isUserInserted"] = msgMap["isUserInserted"] is bool ? msgMap["isUserInserted"] : false;
    });
  }

  static void handleConversationList(List<dynamic> infoList) {
    infoList.forEach((info) {
      final infoConversation = info["conversation"];
      final infoConversationLastMessage = infoConversation["lastMessage"];

      if (infoConversationLastMessage != null) {
        infoConversationLastMessage["localMessageID"] =
            infoConversationLastMessage["localMessageID"] is String
                ? int.parse(infoConversationLastMessage["localMessageID"])
                : 0;
        infoConversationLastMessage["messageID"] =
            infoConversationLastMessage["messageID"] is String
                ? int.parse(infoConversationLastMessage["messageID"])
                : infoConversationLastMessage["messageID"];
        infoConversationLastMessage["orderKey"] =
            infoConversationLastMessage["orderKey"] is int
                ? infoConversationLastMessage["orderKey"]
                : 0;
        infoConversationLastMessage["conversationSeq"] =
            infoConversationLastMessage["conversationSeq"] is int
                ? infoConversationLastMessage["conversationSeq"]
                : int.parse(infoConversationLastMessage["conversationSeq"]);
        infoConversationLastMessage["isUserInserted"] =
            infoConversationLastMessage["isUserInserted"] is bool
                ? infoConversationLastMessage["isUserInserted"]
                : false;
      }
    });
  }

  static Object mapToJSObj(Map<dynamic, dynamic>? a) {
    var object = js.newObject();

    if (a == null) {
      return object;
    }

    a.forEach((k, v) {
      var key = k;
      var value = v;
      js.setProperty(object, key, value);
    });
    return object;
  }

  static Map jsObjectToMap(dynamic obj) {
    String resultStr = ZIM.toJSON(obj);

    Map resultMap = jsonDecode(resultStr);

    return resultMap;
  }

  static String isString(param) {
    return param is String ? param : "";
  }

  ZIMMessage getZIMMessage(Object messageObj) {
    Map messageMap = jsObjectToMap(messageObj);
    ZIMMessage zimMessage = ZIMMessage();
    zimMessage.conversationID = messageMap["conversationID"];
    zimMessage.conversationSeq = messageMap["conversationSeq"];
    zimMessage.messageID = int.parse(messageMap["messageID"]);
    zimMessage.senderUserID = messageMap["senderUserID"];
    zimMessage.timestamp = messageMap["timestamp"];
    zimMessage.orderKey = messageMap["orderKey"];
    zimMessage.localMessageID = int.parse(messageMap["localMessageID"]);
    zimMessage.type = ZIMMessageType.values[messageMap["type"]];
    zimMessage.direction = ZIMMessageDirection.values[messageMap["direction"]];
    zimMessage.sentStatus =
        ZIMMessageSentStatus.values[messageMap["sentStatus"]];
    zimMessage.conversationType =
        ZIMConversationType.values[messageMap["conversationType"]];
    zimMessage.isUserInserted =
        messageMap["isUserInserted"] is bool ? messageMap["isUserInserted"] : false;

    return zimMessage;
  }
}
