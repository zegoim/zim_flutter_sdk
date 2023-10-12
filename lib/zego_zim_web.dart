import 'dart:async';
import 'dart:convert';
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
      case 'clearAllConversationsUnreadMessageCount':
        return clearAllConversationsUnreadMessageCount();
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
      case 'deleteAllConversations':
        return deleteAllConversations(call.arguments["config"]);
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
      case 'callQuit':
        return callQuit(call.arguments["callID"], call.arguments["config"]);
      case 'callEnd':
        return callEnd(call.arguments["callID"], call.arguments["config"]);
      case 'callingInvite':
        return callingInvite(call.arguments["invitees"], call.arguments["callID"], call.arguments["config"]);
      case 'queryCallInvitationList':
        return queryCallInvitationList(call.arguments["config"]);
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
        return setRoomMembersAttributes(
            call.arguments["attributes"],
            call.arguments["roomID"],
            call.arguments["userIDs"],
            call.arguments["config"]);
      case 'sendConversationMessageReceiptRead':
        return sendConversationMessageReceiptRead(
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'sendMessageReceiptsRead':
        return sendMessageReceiptsRead(
            call.arguments["messageList"],
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'queryMessageReceiptsInfo':
        return queryMessageReceiptsInfo(
            call.arguments["messageList"],
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'queryGroupMessageReceiptReadMemberList':
        return queryGroupMessageReceiptReadMemberList(call.arguments["message"],
            call.arguments["groupID"], call.arguments["config"]);
      case 'queryGroupMessageReceiptUnreadMemberList':
        return queryGroupMessageReceiptUnreadMemberList(
            call.arguments["message"],
            call.arguments["groupID"],
            call.arguments["config"]);
      case 'revokeMessage':
        return revokeMessage(
            call.arguments["message"], call.arguments["config"]);
      case 'queryConversationPinnedList':
        return queryConversationPinnedList(call.arguments["config"]);
      case 'updateConversationPinnedState':
        return updateConversationPinnedState(
            call.arguments["isPinned"],
            call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'queryRoomMembers':
        return queryRoomMembers(
            call.arguments["userIDs"], call.arguments["roomID"]);
      case 'queryConversation':
        return queryConversation(call.arguments["conversationID"],
            call.arguments["conversationType"]);
      case 'searchLocalConversations':
        return searchLocalConversations(call.arguments["config"]);
      case 'searchGlobalLocalMessages':
        return searchGlobalLocalMessages(call.arguments["config"]);
      case 'searchLocalMessages':
        return searchLocalMessages(call.arguments["conversationID"], call.arguments["conversationType"], call.arguments["config"]);
      case 'searchLocalGroups':
        return searchLocalGroups(call.arguments["config"]);
      case 'searchLocalGroupMembers':
        return searchLocalGroupMembers(call.arguments["groupID"], call.arguments["config"]);
      case 'addMessageReaction':
        return addMessageReaction(call.arguments["reactionType"], call.arguments["message"]);
      case 'deleteMessageReaction':
        return deleteMessageReaction(call.arguments["reactionType"], call.arguments["message"]);
      case 'queryMessageReactionUserList':
        return queryMessageReactionUserList(call.arguments["message"], call.arguments["config"]);
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
        // case "callStateChanged":
        //   return callStateChangedHandle(_zim, data);
        case "callUserStateChanged":
          return callUserStateChangedHandle(_zim, data);
        case "callInvitationEnded":
          return callInvitationEndedHandle(_zim, data);
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
        case "messageSentStatusChanged":
          return messageSentStatusChangedHandle(_zim, data);
        case "messageReactionsChanged":
          return messageReactionsChangedHandle(_zim, data);
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

    await loginFuture.catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return Future.value();
  }

  logout() {
    ZIM.getInstance()?.logout();
  }

  Future<Map<dynamic, dynamic>> queryConversationList(dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.queryConversationList(_config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

    resultMap["conversationList"].forEach((conversation) {
      var index = resultMap["conversationList"].indexOf(conversation);
      resultMap["conversationList"][index]["lastMessage"] = convertZIMMessage(
          resultMap["conversationList"][index]["lastMessage"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> updateUserAvatarUrl(
      String userAvatarUrl) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserName(String userName) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.updateUserName(userName))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserExtendedData(
      String extendedData) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateUserExtendedData(extendedData))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> renewToken(String token) async {
    var result = await promiseToFuture(ZIM.getInstance()!.renewToken(token))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryUsersInfo(
      dynamic userIDs, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryUsersInfo(userIDs, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> clearConversationUnreadMessageCount(
      String conversationID, int conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .clearConversationUnreadMessageCount(
                conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<void> clearAllConversationsUnreadMessageCount () async  {
    await promiseToFuture(ZIM
            .getInstance()!
            .clearAllConversationsUnreadMessageCount())
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });
    return;
  }

  Future<Map<dynamic, dynamic>> queryHistoryMessage(
      String conversationID, int conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryHistoryMessage(conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap["messageList"].forEach((message) {
      var index = resultMap["messageList"].indexOf(message);
      resultMap["messageList"][index] =
          convertZIMMessage(resultMap["messageList"][index]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> createRoom(
      dynamic roomInfo, dynamic config) async {
    Object _roomInfo = mapToJSObj(roomInfo);
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.createRoom(_roomInfo, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> enterRoom(
      dynamic roomInfo, dynamic config) async {
    Object _roomInfo = mapToJSObj(roomInfo);
    Object _config = mapToJSObj(config);
    final result =
        await promiseToFuture(ZIM.getInstance()!.enterRoom(_roomInfo, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> joinRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinRoom(roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> leaveRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveRoom(roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberList(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMemberList(roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });
    Map resultMap = jsObjectToMap(result);

    resultMap["nextFlag"] =
        resultMap["nextFlag"] is String ? resultMap["nextFlag"] : "";

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryRoomOnlineMemberCount(
      String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomOnlineMemberCount(roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomAllAttributes(String roomID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryRoomAllAttributes(roomID))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setRoomAttributes(
      Map roomAttributes, String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setRoomAttributes(mapToJSObj(roomAttributes), roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteRoomAttributes(
      dynamic keys, String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteRoomAttributes(keys, roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<void> beginRoomAttributesBatchOperation(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    await promiseToFuture(ZIM
            .getInstance()!
            .beginRoomAttributesBatchOperation(roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return;
  }

  Future<Map<dynamic, dynamic>> endRoomAttributesBatchOperation(
      String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.endRoomAttributesBatchOperation(roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            mapToJSObj(notification)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            ZIM.getInstance()!.sendPeerMessage(_message, toUserID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> sendRoomMessage(
      dynamic message, String toRoomID, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.sendRoomMessage(_message, toRoomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupMessage(
      dynamic message, String toGroupID, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.sendGroupMessage(_message, toGroupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return handleSendMessageResult(result);
  }

  Future<Map<dynamic, dynamic>> deleteMessages(dynamic messageList,
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.deleteMessages(
            messageList, conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteAllMessage(
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .deleteAllMessage(conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> createGroup(
      dynamic groupInfo, dynamic userIDs, dynamic config) async {
    Object _groupInfo = mapToJSObj(groupInfo);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.createGroup(_groupInfo, userIDs, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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

  Future<Map<dynamic, dynamic>> joinGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinGroup(groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

    resultMap["groupInfo"]["groupNotice"] =
        isString(resultMap["groupInfo"]["groupNotice"]);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> leaveGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveGroup(groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> dismissGroup(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.dismissGroup(groupID))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> inviteUsersIntoGroup(
      dynamic userIDs, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.inviteUsersIntoGroup(userIDs, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            ZIM.getInstance()!.kickGroupMembers(userIDs, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> transferGroupOwner(
      String toUserID, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.transferGroupOwner(toUserID, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupName(
      String groupName, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupName(groupName, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupAvatarUrl(groupAvatarUrl, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupNotice(
      String groupNotice, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupNotice(groupNotice, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupInfo(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryGroupInfo(groupID))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

    resultMap["groupInfo"]["baseInfo"]["groupAvatarUrl"] =
        isString(resultMap["groupInfo"]["baseInfo"]["groupAvatarUrl"]);
    resultMap["groupInfo"]["baseInfo"]["groupName"] =
        isString(resultMap["groupInfo"]["baseInfo"]["groupName"]);
    resultMap["groupInfo"]["groupNotice"] =
        isString(resultMap["groupInfo"]["groupNotice"]);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryGroupList() async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupList())
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

    resultMap["groupList"].forEach((group) {
      var index = resultMap["groupList"].indexOf(group);
      resultMap["groupList"][index]["baseInfo"]["groupAvatarUrl"] =
          isString(resultMap["groupList"][index]["baseInfo"]["groupAvatarUrl"]);
      resultMap["groupList"][index]["baseInfo"]["groupName"] =
          isString(resultMap["groupList"][index]["baseInfo"]["groupName"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> setGroupAttributes(
      Map<dynamic, dynamic> groupAttributes, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.setGroupAttributes(groupAttributes, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteGroupAttributes(keys, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupAttributes(keys, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAllAttributes(String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupAllAttributes(groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberRole(
    int role,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.setGroupMemberRole(role, forUserID, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberNickname(
    String nickname,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setGroupMemberNickname(nickname, forUserID, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberInfo(
      String userID, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupMemberInfo(userID, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            ZIM.getInstance()!.queryGroupMemberList(groupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            .deleteConversation(conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<void> deleteAllConversations(dynamic config) async {
    Object _config = mapToJSObj(config);

    await promiseToFuture(ZIM
            .getInstance()!
            .deleteAllConversations(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return ;
  }

  Future<Map<dynamic, dynamic>> setConversationNotificationStatus(
      dynamic status, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setConversationNotificationStatus(
                status, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callInvite(
      dynamic invitees, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callInvite(invitees, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            ZIM.getInstance()!.callCancel(invitees, callID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
        await promiseToFuture(ZIM.getInstance()!.callAccept(callID, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callReject(
      String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callReject(callID, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<void> callQuit(
      String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    await promiseToFuture(ZIM.getInstance()!.callQuit(callID, _config));

    return;
  }

  Future<void> callEnd(
      String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    await promiseToFuture(ZIM.getInstance()!.callEnd(callID, _config));

    return;
  }

  Future<Map<dynamic, dynamic>> callingInvite(
     dynamic invitees, String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callingInvite(invitees, callID, _config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryCallInvitationList(dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.queryCallInvitationList(_config));

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberAttributesList(
      String roomID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMemberAttributesList(roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMembersAttributes(
      dynamic userIDs, String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMembersAttributes(userIDs, roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
            mapToJSObj(notification)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
                _message, conversationID, conversationType, senderUserID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = handleSendMessageResult(result);
    resultMap["messageID"] = messageID;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> setRoomMembersAttributes(
      Map attributes, String roomID, dynamic userIDs, dynamic config) async {
    final _attributes = mapToJSObj(attributes);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setRoomMembersAttributes(_attributes, userIDs, roomID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendConversationMessageReceiptRead(
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendConversationMessageReceiptRead(
                conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendMessageReceiptsRead(dynamic messageList,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendMessageReceiptsRead(
                messageList, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessageReceiptsInfo(dynamic messageList,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessageReceiptsInfo(
                messageList, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptReadMemberList(
      dynamic message, String groupID, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMessageReceiptReadMemberList(_message, groupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptUnreadMemberList(
      dynamic message, String groupID, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMessageReceiptUnreadMemberList(
                _message, groupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> revokeMessage(
      dynamic message, dynamic config) async {
    final _message = mapToJSObj(message);
    final _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.revokeMessage(_message, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryConversationPinnedList(
      dynamic config) async {
    final _config = mapToJSObj((config));

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryConversationPinnedList(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap["conversationList"].forEach((conversation) {
      var index = resultMap["conversationList"].indexOf(conversation);
      resultMap["conversationList"][index]["lastMessage"] = convertZIMMessage(
          resultMap["conversationList"][index]["lastMessage"]);
    });

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> updateConversationPinnedState(
      bool isPinned, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateConversationPinnedState(
                isPinned, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMembers(
      dynamic userIDs, String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMembers(userIDs, roomID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryConversation(
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryConversation(conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap["conversation"]["lastMessage"] =
        convertZIMMessage(resultMap["conversation"]["lastMessage"]);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalConversations(dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalConversations(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    for (var infoMap in resultMap["conversationSearchInfoList"]) {
      for (var messageMap in infoMap["messageList"]) {
        messageMap = convertZIMMessage(messageMap);
      }
    }

    resultMap["nextFlag"] = resultMap["nextFlag"] is int ? resultMap["nextFlag"] : 0;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchGlobalLocalMessages(dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchGlobalLocalMessages(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    for (var messageMap in resultMap["messageList"]) {
      messageMap = convertZIMMessage(messageMap);
    }

    if (resultMap["nextMessage"] != null) {
      resultMap["nextMessage"] = convertZIMMessage(resultMap["nextMessage"]);
    }

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalMessages(String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalMessages(conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    for (var messageMap in resultMap["messageList"]) {
      messageMap = convertZIMMessage(messageMap);
    }

    if (resultMap["nextMessage"] != null) {
      resultMap["nextMessage"] = convertZIMMessage(resultMap["nextMessage"]);
    }

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalGroups(dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalGroups(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalGroupMembers(String groupID, dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalGroupMembers(groupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> addMessageReaction(String reactionType, dynamic message) async {
    Object _message = mapToJSObj(message);
    final result = await promiseToFuture(ZIM.getInstance()!.addMessageReaction(reactionType, _message)).catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> deleteMessageReaction(String reactionType, dynamic message) async {
    Object _message = mapToJSObj(message);
    final result = await promiseToFuture(ZIM.getInstance()!.deleteMessageReaction(reactionType, _message)).catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;

  }

  Future<Map<dynamic, dynamic>> queryMessageReactionUserList(dynamic message, dynamic config)async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(ZIM.getInstance()!.queryMessageReactionUserList(_message, _config)).catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap["message"]["reactions"] =
        resultMap["message"]["reactions"] == null
            ? [] : resultMap["reactions"].forEach((reactionMap) {
                      reactionMap["messageID"] = reactionMap["messageID"] is int
                          ? reactionMap["messageID"]
                          : int.parse(reactionMap["messageID"]);
                   });

    resultMap["message"]["isBroadcastMessage"] = resultMap["message"]["isBroadcastMessage"] is bool
      ? resultMap["message"]["isBroadcastMessage"]
        : false;

    return resultMap;
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
      extendedData = Map.from(data["extendedData"]);
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
      final roomAttributes = info["roomAttributes"];
      Map<String, String> mapRoomAttributes =
          Map<String, String>.from(roomAttributes);
      ZIMRoomAttributesUpdateAction action =
          ZIMRoomAttributesUpdateAction.values[info["action"]];

      ZIMEventHandler.onRoomAttributesUpdated!(
          zim,
          ZIMRoomAttributesUpdateInfo(
              action: action, roomAttributes: mapRoomAttributes),
          roomID);
    });
  }

  static void roomAttributesBatchUpdatedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

    final infos = data["infos"];
    String roomID = data["roomID"];

    List<ZIMRoomAttributesUpdateInfo> list = [];

    infos.forEach((info) {
      final roomAttributes = info["roomAttributes"];
      Map<String, String> mapRoomAttributes =
          Map<String, String>.from(roomAttributes);

      ZIMRoomAttributesUpdateAction action =
          ZIMRoomAttributesUpdateAction.values[info["action"]];

      list.add(ZIMRoomAttributesUpdateInfo(
          action: action, roomAttributes: mapRoomAttributes));
    });

    ZIMEventHandler.onRoomAttributesBatchUpdated!(zim, list, roomID);
  }

  static void roomMemberJoinedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onRoomMemberJoined == null) return;

    final memberList = data["memberList"];
    String roomID = data["roomID"];
    List<ZIMUserInfo> list = [];

    memberList.forEach((member) {
      Map memberMap = Map.from(member);
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
      Map memberMap = Map.from(member);
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
      Map<String, String> mapGroupAttributes =
          Map.from(info["groupAttributes"]);
      ZIMGroupAttributesUpdateInfo atr = ZIMGroupAttributesUpdateInfo();
      atr.action = ZIMGroupAttributesUpdateAction.values[info["action"]];
      atr.groupAttributes = mapGroupAttributes;
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

    String callID = data["callID"];
    ZIMConverter.oZIMCallInvitationReceivedInfo(data);

    ZIMEventHandler.onCallInvitationReceived!(zim, ZIMConverter.oZIMCallInvitationReceivedInfo(data), callID);
  }

  static void callInvitationCancelledHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationCancelled == null) return;

    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationCancelled!(zim, ZIMConverter.oZIMCallInvitationCancelledInfo(data), callID);
  }

  static void callInvitationTimeoutHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationTimeout == null) return;

    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationTimeout!(zim, ZIMConverter.oZIMCallInvitationTimeoutInfo(data), callID);
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

  // static void callStateChangedHandle(ZIMEngine zim, dynamic data) {
  //   if (ZIMEventHandler.onCallStateChanged == null) return;
  //   ZIMCallStateChangeInfo callStateChangeInfo = ZIMCallStateChangeInfo();
  //   callStateChangeInfo.callID = data["callID"];
  //   callStateChangeInfo.state = ZIMCallStateExtension.mapValue[data["state"]]!;
  //   callStateChangeInfo.callDuration = data["callDuration"];
  //   callStateChangeInfo.userDuration = data["userDuration"];
  //   callStateChangeInfo.extendedData = data["extendedData"];
  //   callStateChangeInfo.timeout = data["timeout"];
  //   callStateChangeInfo.callUserInfo = ZIMConverter.oZIMCallUserInfo(data['callUserInfo']);
  //   ZIMEventHandler.onCallStateChanged!(zim, callStateChangeInfo);
  // }

  static void callUserStateChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallUserStateChanged == null) return;
    String callID = data['callID'];
    ZIMCallUserStateChangeInfo callUserStateChangedInfo = ZIMConverter.oZIMCallUserStateChangedInfo(data);
    ZIMEventHandler.onCallUserStateChanged!(zim, ZIMConverter.oZIMCallUserStateChangedInfo(data),callID);
  }

  static void callInvitationEndedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onCallInvitationEnded == null) return;
    String callID = data["callID"];

    ZIMEventHandler.onCallInvitationEnded!(zim, ZIMConverter.oZIMCallInvitationEndedInfo(data), callID);
  }

  static void conversationChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onConversationChanged == null) return;

    List<dynamic> infoList = data["infoList"];

    infoList.forEach((info) {
      if (info["conversation"]["lastMessage"] != null) {
        info["conversation"]["lastMessage"] =
          convertZIMMessage(info["conversation"]["lastMessage"]);
      }
    });

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

  static void conversationMessageReceiptChangedHandle(
      ZIMEngine zim, dynamic data) {
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
      ZIMRevokeMessage message =
          ZIMConverter.oZIMMessage(map) as ZIMRevokeMessage;

      messageList.add(message);
    });

    ZIMEventHandler.onMessageRevokeReceived!(zim, messageList);
  }

  static void messageSentStatusChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageSentStatusChanged == null) {
      return;
    }
    final _infos = data["infos"];
    _infos.forEach((info) {
      info["message"] = convertZIMMessage(info["message"]);
      info["reason"] = info["reason"] is String ? info["reason"]: "";
    });
    List<ZIMMessageSentStatusChangeInfo> infos =
        ZIMConverter.oMessageSentStatusChangeInfoList(_infos);

    ZIMEventHandler.onMessageSentStatusChanged!(zim, infos);
  }

  static void messageReactionsChangedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onMessageReactionsChanged == null) {
      return;
    }

    data["reactions"].forEach((reactionMap) {
      reactionMap["messageID"] = int.parse(reactionMap["messageID"]);
    });

    List<ZIMMessageReaction> reactions =
        ZIMConverter.oZIMMessageReactionList(data["reactions"]);

    ZIMEventHandler.onMessageReactionsChanged!(zim, reactions);
  }

  static void broadcastMessageReceivedHandle(ZIMEngine zim, dynamic data) {
    if (ZIMEventHandler.onBroadcastMessageReceived == null) {
      return;
    }

    data["message"] = convertZIMMessage(data["message"]);

    ZIMMessage message = ZIMConverter.oZIMMessage(data["message"]);

    ZIMEventHandler.onBroadcastMessageReceived!(zim, message);
  }

  static Map handleSendMessageResult(dynamic result) {
    Map resultMap = jsObjectToMap(result);
    resultMap["message"]["localMessageID"] =
        int.parse(resultMap["message"]["localMessageID"]);
    resultMap["message"]["messageID"] =
        int.parse(resultMap["message"]["messageID"]);
    resultMap["message"]["isUserInserted"] =
        resultMap["message"]["isUserInserted"] is bool
            ? resultMap["message"]["isUserInserted"]
            : false;

    resultMap["message"]["reactions"] =
        resultMap["message"]["reactions"] == null
            ? [] : resultMap["reactions"].forEach((reactionMap) {
                      reactionMap["messageID"] = reactionMap["messageID"] is int
                          ? reactionMap["messageID"]
                          : int.parse(reactionMap["messageID"]);
                   });

    resultMap["message"]["isBroadcastMessage"] = resultMap["message"]["isBroadcastMessage"] is bool
      ? resultMap["message"]["isBroadcastMessage"]
        : false;

    return resultMap;
  }

  static void handleReceiveMessage(List<dynamic> messageList) {
    messageList.forEach((msgMap) {
      msgMap["messageID"] = int.parse(msgMap["messageID"]);
      msgMap["localMessageID"] = msgMap["localMessageID"] is String
          ? int.parse(msgMap["localMessageID"])
          : 0;
      msgMap["orderKey"] = msgMap["orderKey"] is int ? msgMap["orderKey"] : 0;
      msgMap["isUserInserted"] =
          msgMap["isUserInserted"] is bool ? msgMap["isUserInserted"] : false;
      msgMap["extendedData"] =
          msgMap["extendedData"] is String ? msgMap["extendedData"] : "";
      msgMap["conversationSeq"] =
          msgMap["conversationSeq"] is int ? msgMap["conversationSeq"] : 0;
      msgMap["receiptStatus"] =
          msgMap["receiptStatus"] is int ? msgMap["receiptStatus"] : 0;

      if (msgMap["type"] == 2) {
        msgMap["message"] = convertToUint8List(msgMap["message"]);
      }
    });
  }

  // static Map handleGroupResultMap(Map groupBaseInfo) {
  //   groupBaseInfo["groupAvatarUrl"] = isString(groupBaseInfo["groupAvatarUrl"]);
  //   groupBaseInfo["groupNamne"] = isString(groupBaseInfo["groupNamne"]);

  //   return groupBaseInfo;
  // }

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

  static ZIMMessage getZIMMessage(Object messageObj) {
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
    zimMessage.isUserInserted = messageMap["isUserInserted"] is bool
        ? messageMap["isUserInserted"]
        : false;
    zimMessage.extendedData =
        messageMap["extendedData"] is String ? messageMap["extendedData"] : "";

    return zimMessage;
  }

  static Map convertZIMMessage(Map messageMap) {
    ZIMMessageType msgType =
        ZIMMessageTypeExtension.mapValue[messageMap['type']]!;

    messageMap["messageID"] = messageMap["messageID"] is int
        ? messageMap["messageID"]
        : int.parse(messageMap["messageID"]);
    messageMap["localMessageID"] = int.parse((messageMap["localMessageID"]));
    messageMap["isUserInserted"] = messageMap["isUserInserted"] is bool
        ? messageMap["isUserInserted"]
        : false;
    messageMap["orderKey"] =
        messageMap["orderKey"] is int ? messageMap["orderKey"] : 0;
    messageMap["extendedData"] =
        messageMap["extendedData"] is String ? messageMap["extendedData"] : "";
    messageMap["fileLocalPath"] = messageMap["fileLocalPath"] is String
        ? messageMap["fileLocalPath"]
        : "";
    messageMap["isBroadcastMessage"] = messageMap["isBroadcastMessage"] is bool
        ? messageMap["isBroadcastMessage"]
        : false;

    if (messageMap["reactions"] != null) {
      messageMap["reactions"].forEach((reactionMap) {
        reactionMap["messageID"] = reactionMap["messageID"] is int
            ? reactionMap["messageID"]
            : int.parse(reactionMap["messageID"]);
      });
    } else {
      messageMap["reactions"] = [];
    }

    switch (msgType) {
      case ZIMMessageType.image:
        messageMap["thumbnailLocalPath"] =
            messageMap["thumbnailLocalPath"] is String
                ? messageMap["thumbnailLocalPath"]
                : "";
        messageMap["largeImageLocalPath"] =
            messageMap["largeImageLocalPath"] is String
                ? messageMap["largeImageLocalPath"]
                : "";
        break;
      case ZIMMessageType.video:
        messageMap["videoFirstFrameLocalPath"] =
            messageMap["videoFirstFrameLocalPath"] is String
                ? messageMap["videoFirstFrameLocalPath"]
                : "";
        break;
      default:
        break;
    }

    return messageMap;
  }

  static Uint8List convertToUint8List(dynamic data) {
    final list = <int>[];
    data.forEach((i) {
      list.add(i);
    });

    final uint8List = Uint8List.fromList(list);
    return uint8List;
  }
}
