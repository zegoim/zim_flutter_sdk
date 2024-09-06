import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
// In order to *not* need this ignore, consider extracting the 'web' version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js;
import 'dart:js';

import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zego_zim/src/internal/web/zim_event_handler_web.dart';
import 'package:zego_zim/src/internal/zim_common_data.dart';
import 'package:zego_zim/src/zim_defines.dart';
import 'package:zego_zim/src/internal/web/zim_defines_web.dart';

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
      ZIMEventHandlerWeb.eventListener(event);
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
        return create(call.arguments['handle'], call.arguments['config']);
      case 'destroy':
        return destroy();
      case 'setLogConfig':
        return setLogConfig(call.arguments['logLevel']);
      case 'setCacheConfig':
        return setCacheConfig();
      case 'setAdvancedConfig':
        return setAdvancedConfig(
            call.arguments['key'], call.arguments['value']);
      case 'login':
        return login(call.arguments['userID'], call.arguments['config']);
      case 'logout':
        return logout();
      case 'createRoom':
        return createRoom(call.arguments['roomInfo'], null);
      case 'enterRoom':
        return enterRoom(call.arguments['roomInfo'], call.arguments['config']);
      case 'joinRoom':
        return joinRoom(call.arguments['roomID']);
      case 'leaveRoom':
        return leaveRoom(call.arguments['roomID']);
      case 'queryRoomMemberList':
        return queryRoomMemberList(
            call.arguments['roomID'], call.arguments['config']);
      case 'queryRoomOnlineMemberCount':
        return queryRoomOnlineMemberCount(call.arguments['roomID']);
      case 'queryRoomAllAttributes':
        return queryRoomAllAttributes(call.arguments['roomID']);
      case 'setRoomAttributes':
        return setRoomAttributes(call.arguments['roomAttributes'],
            call.arguments['roomID'], call.arguments['config']);
      case 'deleteRoomAttributes':
        return deleteRoomAttributes(call.arguments['keys'],
            call.arguments['roomID'], call.arguments['config']);
      case 'beginRoomAttributesBatchOperation':
        return beginRoomAttributesBatchOperation(
            call.arguments['roomID'], call.arguments['config']);
      case 'endRoomAttributesBatchOperation':
        return endRoomAttributesBatchOperation(call.arguments['roomID']);
      case 'createRoomWithConfig':
        return createRoom(call.arguments['roomInfo'], call.arguments['config']);
      case 'renewToken':
        return renewToken(call.arguments['token']);
      case 'queryUsersInfo':
        return queryUsersInfo(
            call.arguments['userIDs'], call.arguments['config']);
      case 'queryConversationList':
        return queryConversationList(
            call.arguments['config'], call.arguments['option']);
      case 'updateUserName':
        return updateUserName(call.arguments['userName']);
      case 'updateUserAvatarUrl':
        return updateUserAvatarUrl(call.arguments['userAvatarUrl']);
      case 'updateUserExtendedData':
        return updateUserExtendedData(call.arguments['extendedData']);
      case 'clearConversationUnreadMessageCount':
        return clearConversationUnreadMessageCount(
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'clearConversationTotalUnreadMessageCount':
        return clearConversationTotalUnreadMessageCount();
      case 'queryHistoryMessage':
        return queryHistoryMessage(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'sendMediaMessage':
        return sendMediaMessage(
            call.arguments['message'],
            call.arguments['toConversationID'],
            call.arguments['conversationType'],
            call.arguments['config'],
            call.arguments['messageID'],
            call.arguments['progressID'],
            call.arguments['messageAttachedCallbackID']);
      case 'downloadMediaFile':
        return downloadMediaFile(call.arguments['message'],
            call.arguments['fileType'], call.arguments['progressID']);
      // case 'sendPeerMessage':
      //   return sendPeerMessage(call.arguments['message'],
      //       call.arguments['toUserID'], call.arguments['config']);
      // case 'sendRoomMessage':
      //   return sendRoomMessage(call.arguments['message'],
      //       call.arguments['toRoomID'], call.arguments['config']);
      // case 'sendGroupMessage':
      //   return sendGroupMessage(call.arguments['message'],
      //       call.arguments['toGroupID'], call.arguments['config']);
      case 'deleteMessages':
        return deleteMessages(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType'],
            call.arguments['config']);
      case 'deleteAllMessage':
        return deleteAllMessage(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'createGroup':
        return createGroup(call.arguments['groupInfo'],
            call.arguments['userIDs'], call.arguments['config']);
      case 'joinGroup':
        return joinGroup(call.arguments['groupID']);
      case 'leaveGroup':
        return leaveGroup(call.arguments['groupID']);
      case 'dismissGroup':
        return dismissGroup(call.arguments['groupID']);
      case 'inviteUsersIntoGroup':
        return inviteUsersIntoGroup(
            call.arguments['userIDs'], call.arguments['groupID']);
      case 'kickGroupMembers':
        return kickGroupMembers(
            call.arguments['userIDs'], call.arguments['groupID']);
      case 'transferGroupOwner':
        return transferGroupOwner(
            call.arguments['toUserID'], call.arguments['groupID']);
      case 'updateGroupName':
        return updateGroupName(
            call.arguments['groupName'], call.arguments['groupID']);
      case 'updateGroupAvatarUrl':
        return updateGroupAvatarUrl(
            call.arguments['groupAvatarUrl'], call.arguments['groupID']);
      case 'updateGroupNotice':
        return updateGroupNotice(
            call.arguments['groupNotice'], call.arguments['groupID']);
      case 'queryGroupInfo':
        return queryGroupInfo(call.arguments['groupID']);
      case 'queryGroupList':
        return queryGroupList();
      case 'setGroupAttributes':
        return setGroupAttributes(
            call.arguments['groupAttributes'], call.arguments['groupID']);
      case 'deleteGroupAttributes':
        return deleteGroupAttributes(
            call.arguments['keys'], call.arguments['groupID']);
      case 'queryGroupAttributes':
        return queryGroupAttributes(
            call.arguments['keys'], call.arguments['groupID']);
      case 'queryGroupAllAttributes':
        return queryGroupAllAttributes(call.arguments['groupID']);
      case 'setGroupMemberRole':
        return setGroupMemberRole(call.arguments['role'],
            call.arguments['forUserID'], call.arguments['groupID']);
      case 'setGroupMemberNickname':
        return setGroupMemberNickname(call.arguments['nickname'],
            call.arguments['forUserID'], call.arguments['groupID']);
      case 'queryGroupMemberInfo':
        return queryGroupMemberInfo(
            call.arguments['userID'], call.arguments['groupID']);
      case 'queryGroupMemberList':
        return queryGroupMemberList(
            call.arguments['groupID'], call.arguments['config']);
      case 'deleteConversation':
        return deleteConversation(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'deleteAllConversations':
        return deleteAllConversations(call.arguments['config']);
      case 'setConversationNotificationStatus':
        return setConversationNotificationStatus(
            call.arguments['status'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'callInvite':
        return callInvite(call.arguments['invitees'], call.arguments['config']);
      case 'callCancel':
        return callCancel(call.arguments['invitees'], call.arguments['callID'],
            call.arguments['config']);
      case 'callAccept':
        return callAccept(call.arguments['callID'], call.arguments['config']);
      case 'callReject':
        return callReject(call.arguments['callID'], call.arguments['config']);
      case 'callQuit':
        return callQuit(call.arguments['callID'], call.arguments['config']);
      case 'callEnd':
        return callEnd(call.arguments['callID'], call.arguments['config']);
      case 'callJoin':
        return callJoin(call.arguments['callID'], call.arguments['config']);
      case 'callingInvite':
        return callingInvite(call.arguments['invitees'],
            call.arguments['callID'], call.arguments['config']);
      case 'queryCallInvitationList':
        return queryCallInvitationList(call.arguments['config']);
      case 'queryRoomMemberAttributesList':
        return queryRoomMemberAttributesList(
            call.arguments['roomID'], call.arguments['config']);
      case 'queryRoomMembersAttributes':
        return queryRoomMembersAttributes(
            call.arguments['userIDs'], call.arguments['roomID']);
      case 'sendMessage':
        return sendMessage(
            call.arguments['message'],
            call.arguments['toConversationID'],
            call.arguments['conversationType'],
            call.arguments['config'],
            call.arguments['messageAttachedCallbackID'],
            call.arguments['messageID']);
      case 'insertMessageToLocalDB':
        return insertMessageToLocalDB(
            call.arguments['message'],
            call.arguments['messageID'],
            call.arguments['conversationID'],
            call.arguments['conversationType'],
            call.arguments['senderUserID']);
      case 'setRoomMembersAttributes':
        return setRoomMembersAttributes(
            call.arguments['attributes'],
            call.arguments['roomID'],
            call.arguments['userIDs'],
            call.arguments['config']);
      case 'sendConversationMessageReceiptRead':
        return sendConversationMessageReceiptRead(
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'sendMessageReceiptsRead':
        return sendMessageReceiptsRead(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryMessageReceiptsInfo':
        return queryMessageReceiptsInfo(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryGroupMessageReceiptReadMemberList':
        return queryGroupMessageReceiptReadMemberList(call.arguments['message'],
            call.arguments['groupID'], call.arguments['config']);
      case 'queryGroupMessageReceiptUnreadMemberList':
        return queryGroupMessageReceiptUnreadMemberList(
            call.arguments['message'],
            call.arguments['groupID'],
            call.arguments['config']);
      case 'revokeMessage':
        return revokeMessage(
            call.arguments['message'], call.arguments['config']);
      case 'queryConversationPinnedList':
        return queryConversationPinnedList(call.arguments['config']);
      case 'updateConversationPinnedState':
        return updateConversationPinnedState(
            call.arguments['isPinned'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryRoomMembers':
        return queryRoomMembers(
            call.arguments['userIDs'], call.arguments['roomID']);
      case 'queryConversation':
        return queryConversation(call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'searchLocalConversations':
        return searchLocalConversations(call.arguments['config']);
      case 'searchGlobalLocalMessages':
        return searchGlobalLocalMessages(call.arguments['config']);
      case 'searchLocalMessages':
        return searchLocalMessages(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'searchLocalGroups':
        return searchLocalGroups(call.arguments['config']);
      case 'searchLocalGroupMembers':
        return searchLocalGroupMembers(
            call.arguments['groupID'], call.arguments['config']);
      case 'addMessageReaction':
        return addMessageReaction(
            call.arguments['reactionType'], call.arguments['message']);
      case 'deleteMessageReaction':
        return deleteMessageReaction(
            call.arguments['reactionType'], call.arguments['message']);
      case 'queryMessageReactionUserList':
        return queryMessageReactionUserList(
            call.arguments['message'], call.arguments['config']);
      case 'setGeofencingConfig':
        return setGeofencingConfig(
            call.arguments['areaList'], call.arguments['type']);
      case 'setConversationDraft':
        return setConversationDraft(
            call.arguments['draft'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);

      case 'muteGroup':
        return muteGroup(call.arguments['isMute'], call.arguments['groupID'],
            call.arguments['config']);
      case 'muteGroupMembers':
        return muteGroupMembers(
            call.arguments['isMute'],
            call.arguments['userIDs'],
            call.arguments['groupID'],
            call.arguments['config']);
      case 'queryGroupMemberMutedList':
        return queryGroupMemberMutedList(
            call.arguments['groupID'], call.arguments['config']);
      case 'addFriend':
        return addFriend(call.arguments['userID'], call.arguments['config']);
      case 'deleteFriends':
        return deleteFriends(
            call.arguments['userIDs'], call.arguments['config']);
      case 'checkFriendsRelation':
        return checkFriendsRelation(
            call.arguments['userIDs'], call.arguments['config']);
      case 'updateFriendAlias':
        return updateFriendAlias(
            call.arguments['friendAlias'], call.arguments['userID']);
      case 'updateFriendAttributes':
        return updateFriendAttributes(
            call.arguments['friendAttributes'], call.arguments['userID']);
      case 'acceptFriendApplication':
        return acceptFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'rejectFriendApplication':
        return rejectFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'queryFriendsInfo':
        return queryFriendsInfo(call.arguments['userIDs']);
      case 'queryFriendList':
        return queryFriendList(call.arguments['config']);
      case 'queryFriendApplicationList':
        return queryFriendApplicationList(call.arguments['config']);
      case 'addUsersToBlacklist':
        return addUsersToBlacklist(call.arguments['userIDs']);
      case 'removeUsersFromBlacklist':
        return removeUsersFromBlacklist(call.arguments['userIDs']);
      case 'checkUserIsInBlackList':
        return checkUserIsInBlacklist(call.arguments['userID']);
      case 'queryBlackList':
        return queryBlacklist(call.arguments['config']);
      case 'deleteAllConversationMessages':
        return deleteAllConversationMessages(call.arguments['config']);
      case 'queryCombineMessageDetail':
        return queryCombineMessageDetail(call.arguments['message']);
      case 'searchLocalFriends':
        return searchLocalFriends(call.arguments['config']);
      case 'sendFriendApplication':
        return sendFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'updateUserOfflinePushRule':
        return updateUserOfflinePushRule(call.arguments['offlinePushRule']);
      case 'querySelfUserInfo':
        return querySelfUserInfo();
      case 'replyMessage':
        return replyMessage(
            call.arguments['message'],
            call.arguments['toOriginalMessage'],
            call.arguments['config'],
            call.arguments['progressID'],
            call.arguments['messageAttachedCallbackID']);
      case 'queryMessageRepliedList':
        return queryMessageRepliedList(
            call.arguments['message'], call.arguments['config']);
      case 'queryConversationTotalUnreadCount':
        return queryConversationTotalUnreadMessageCount(
            call.arguments['config']);
      case 'updateGroupJoinMode':
        return updateGroupJoinMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'updateGroupInviteMode':
        return updateGroupInviteMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'updateGroupBeInviteMode':
        return updateGroupBeInviteMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'sendGroupJoinApplication':
        return sendGroupJoinApplication(
            call.arguments['groupID'], call.arguments['config']);
      case 'acceptGroupJoinApplication':
        return acceptGroupJoinApplication(call.arguments['userID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'rejectGroupJoinApplication':
        return rejectGroupJoinApplication(call.arguments['userID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'sendGroupInviteApplications':
        return sendGroupInviteApplications(call.arguments['userIDs'],
            call.arguments['groupID'], call.arguments['config']);
      case 'acceptGroupInviteApplication':
        return acceptGroupInviteApplication(call.arguments['inviterUserID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'rejectGroupInviteApplication':
        return rejectGroupInviteApplication(call.arguments['inviterUserID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'queryGroupApplicationList':
        return queryGroupApplicationList(call.arguments['config']);
      case 'writeLog':
        return writeLog(call.arguments['logString']);
      case 'queryMessages':
        return queryMessages(
            call.arguments['messageSeqs'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'setConversationMark':
        return setConversationMark(call.arguments['markType'],
            call.arguments['enable'], call.arguments['infos']);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'zim for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<Map<dynamic, dynamic>> queryMessages(dynamic messageSeqs,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessages(messageSeqs, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });
    Map resultMap = jsObjectToMap(result);
    return resultMap;
  }

  static void writeLog(String logString) {
    window.console.info(logString);
  }

  static String getHandle(ZIM zim) {
    var handle = '';
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
    Map config = {'logLevel': logLevel};

    ZIM.getInstance()?.setLogConfig(mapToJSObj(config));

    return Future.value();
  }

  static void setCacheConfig() {
    return;
  }

  static void setAdvancedConfig(String key, String value) {
    ZIM.setAdvancedConfig(key, value);
  }

  static bool setGeofencingConfig(dynamic areaList, dynamic type) {
    return ZIM.setGeofencingConfig(areaList, type);
  }

  Future<void> login(String userID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final promise = ZIM.getInstance()!.login(userID, _config);

    final Future<void> loginFuture = promiseToFuture(promise);

    await loginFuture.catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return Future.value();
  }

  logout() {
    ZIM.getInstance()?.logout();
  }

  Future<Map<dynamic, dynamic>> queryConversationList(
      dynamic config, dynamic option) async {
    Object _config = mapToJSObj(config);
    Object _option = mapToJSObj(option);
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryConversationList(_config, _option))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

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

  Future<void> clearConversationTotalUnreadMessageCount() async {
    await promiseToFuture(
            ZIM.getInstance()!.clearConversationTotalUnreadMessageCount())
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

    resultMap['nextFlag'] =
        resultMap['nextFlag'] is String ? resultMap['nextFlag'] : '';

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
      'onMessageAttached':
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          ZIMMessage zimMessage = getZIMMessage(message);
          callback(zimMessage);
        }
      }),
      'onMediaUploadingProgress':
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

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> downloadMediaFile(
      dynamic message, dynamic fileType, int progressID) async {
    return {};
  }

  // Future<Map<dynamic, dynamic>> sendPeerMessage(
  //     dynamic message, String toUserID, dynamic config) async {
  //   Object _message = mapToJSObj(message);
  //   Object _config = mapToJSObj(config);

  //   final result = await promiseToFuture(
  //           ZIM.getInstance()!.sendPeerMessage(_message, toUserID, _config))
  //       .catchError((e) {
  //     throw PlatformException(code: e.code.toString(), message: e.message);
  //   });

  //   return jsObjectToMap(result);
  // }

  // Future<Map<dynamic, dynamic>> sendRoomMessage(
  //     dynamic message, String toRoomID, dynamic config) async {
  //   Object _message = mapToJSObj(message);
  //   Object _config = mapToJSObj(config);

  //   final result = await promiseToFuture(
  //           ZIM.getInstance()!.sendRoomMessage(_message, toRoomID, _config))
  //       .catchError((e) {
  //     throw PlatformException(code: e.code.toString(), message: e.message);
  //   });

  //   return jsObjectToMap(result);
  // }

  // Future<Map<dynamic, dynamic>> sendGroupMessage(
  //     dynamic message, String toGroupID, dynamic config) async {
  //   Object _message = mapToJSObj(message);
  //   Object _config = mapToJSObj(config);

  //   final result = await promiseToFuture(
  //           ZIM.getInstance()!.sendGroupMessage(_message, toGroupID, _config))
  //       .catchError((e) {
  //     throw PlatformException(code: e.code.toString(), message: e.message);
  //   });

  //   return jsObjectToMap(result);
  // }

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

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> joinGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinGroup(groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

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

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryGroupList() async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupList())
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    Map resultMap = jsObjectToMap(result);

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

    await promiseToFuture(ZIM.getInstance()!.deleteAllConversations(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return;
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
      'callID': _resultMap['callID'],
      'info': {'timeout': _resultMap['timeout'], 'errorInvitees': []}
    };

    _resultMap['errorInvitees'].forEach((invite) {
      resultMap['info']['errorInvitees'].add({
        'userID': invite['userID'],
        'state': invite['state'] is int ? invite['state'] : invite['userState']
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
      'callID': _resultMap['callID'],
      'info': {'timeout': _resultMap['timeout'], 'errorInvitees': []}
    };

    _resultMap['errorInvitees'].forEach((invite) {
      resultMap['info']['errorInvitees'].add({
        'userID': invite['userID'],
        'state': invite['state'] is int ? invite['state'] : invite['userState']
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

  Future<Map<dynamic, dynamic>> callJoin(String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callJoin(callID, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callQuit(String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callQuit(callID, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callEnd(String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result =
        await promiseToFuture(ZIM.getInstance()!.callEnd(callID, _config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callingInvite(
      dynamic invitees, String callID, dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.callingInvite(invitees, callID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryCallInvitationList(dynamic config) async {
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryCallInvitationList(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

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
      'onMessageAttached': allowInterop((message) {
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

    Map resultMap = jsObjectToMap(result);

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

    Map resultMap = jsObjectToMap(result);

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

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalConversations(dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalConversations(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap['nextFlag'] =
        resultMap['nextFlag'] is int ? resultMap['nextFlag'] : 0;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchGlobalLocalMessages(
      dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchGlobalLocalMessages(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalMessages(
      String conversationID, dynamic conversationType, dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalMessages(conversationID, conversationType, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalGroups(dynamic config) async {
    Object _config = mapToJSObj(config);
    final result =
        await promiseToFuture(ZIM.getInstance()!.searchLocalGroups(_config))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> searchLocalGroupMembers(
      String groupID, dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalGroupMembers(groupID, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> addMessageReaction(
      String reactionType, dynamic message) async {
    Object _message = mapToJSObj(message);
    final result = await promiseToFuture(
            ZIM.getInstance()!.addMessageReaction(reactionType, _message))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> deleteMessageReaction(
      String reactionType, dynamic message) async {
    Object _message = mapToJSObj(message);
    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteMessageReaction(reactionType, _message))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryMessageReactionUserList(
      dynamic message, dynamic config) async {
    Object _message = mapToJSObj(message);
    Object _config = mapToJSObj(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryMessageReactionUserList(_message, _config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);

    resultMap['message']['reactions'] =
        resultMap['message']['reactions'] == null
            ? []
            : resultMap['reactions'].forEach((reactionMap) {
                reactionMap['messageID'] = reactionMap['messageID'] is int
                    ? reactionMap['messageID']
                    : int.parse(reactionMap['messageID']);
              });

    resultMap['message']['isBroadcastMessage'] =
        resultMap['message']['isBroadcastMessage'] is bool
            ? resultMap['message']['isBroadcastMessage']
            : false;

    return resultMap;
  }

  Future<Map<dynamic, dynamic>> setConversationDraft(
      String draft, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setConversationDraft(draft, conversationID, conversationType))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setConversationMark(
      int markType, bool enable, dynamic conversationInfos) async {
    List<Object> jsInfos = [];
    for (Map info in conversationInfos) {
      jsInfos.add(mapToJSObj(info));
    }

    final result = await promiseToFuture(
            ZIM.getInstance()!.setConversationMark(markType, enable, jsInfos))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    final resultMap = jsObjectToMap(result);
    return resultMap;
  }

  Future<Map<dynamic, dynamic>> queryConversationTotalUnreadMessageCount(
      dynamic config) async {
    Object _config = mapToJSObj(config);
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryConversationTotalUnreadMessageCount(_config))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });
    final resultMap = jsObjectToMap(result);
    return resultMap;
  }

  Future<Map<dynamic, dynamic>> muteGroup(
      bool isMute, String groupID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.muteGroup(isMute, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> muteGroupMembers(
      bool isMute, dynamic userIDs, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .muteGroupMembers(isMute, userIDs, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberMutedList(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMemberMutedList(groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> addFriend(String userID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.addFriend(userID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteFriends(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteFriends(userIDs, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> checkFriendsRelation(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .checkFriendsRelation(userIDs, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateFriendAlias(
      String friendAlias, String userID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateFriendAlias(friendAlias, userID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateFriendAttributes(
      dynamic friendAttributes, String userID) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateFriendAttributes(mapToJSObj(friendAttributes), userID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptFriendApplication(userID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectFriendApplication(userID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendsInfo(dynamic userIDs) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryFriendsInfo(userIDs))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendList(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryFriendList(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendApplicationList(
      dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryFriendApplicationList(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> addUsersToBlacklist(dynamic userIDs) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.addUsersToBlacklist(userIDs))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> removeUsersFromBlacklist(
      dynamic userIDs) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.removeUsersFromBlacklist(userIDs))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> checkUserIsInBlacklist(String userID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.checkUserIsInBlacklist(userID))
            .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryBlacklist(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryBlacklist(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<void> deleteAllConversationMessages(dynamic config) async {
    promiseToFuture(ZIM
            .getInstance()!
            .deleteAllConversationMessages(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return;
  }

  Future<Map<dynamic, dynamic>> queryCombineMessageDetail(
      dynamic message) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryCombineMessageDetail(mapToJSObj(message)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchLocalFriends(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalFriends(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendFriendApplication(userID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserOfflinePushRule(
      dynamic offlinePushRule) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateUserOfflinePushRule(mapToJSObj(offlinePushRule)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> querySelfUserInfo() async {
    final result = await promiseToFuture(ZIM.getInstance()!.querySelfUserInfo())
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> replyMessage(
      dynamic message,
      dynamic replyMessage,
      dynamic config,
      int progressID,
      int messageAttachedCallbackID) async {
    Map notification = {
      'onMessageAttached':
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          ZIMMessage zimMessage = getZIMMessage(message);
          callback(zimMessage);
        }
      }),
      'onMediaUploadingProgress':
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMediaDownloadingProgress? progress =
            ZIMCommonData.mediaDownloadingProgressMap[progressID];

        if (progress != null) {
          ZIMMessage zimMessage = getZIMMessage(message);
          progress(zimMessage, currentFileSize, totalFileSize);
        }
      })
    };

    final result = await promiseToFuture(ZIM.getInstance()!.replyMessage(
            mapToJSObj(message),
            mapToJSObj(replyMessage),
            mapToJSObj(config),
            mapToJSObj(notification)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessageRepliedList(
      dynamic message, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessageRepliedList(mapToJSObj(message), mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupJoinMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupJoinMode(mode, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupInviteMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupInviteMode(mode, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupBeInviteMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupBeInviteMode(mode, groupID))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupJoinApplication(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendGroupJoinApplication(groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptGroupJoinApplication(
      String userID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptGroupJoinApplication(userID, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectGroupJoinApplication(
      String userID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectGroupJoinApplication(userID, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupInviteApplications(
      dynamic userIDs, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendGroupInviteApplications(userIDs, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptGroupInviteApplication(
                inviterUserID, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectGroupInviteApplication(
                inviterUserID, groupID, mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupApplicationList(
      dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupApplicationList(mapToJSObj(config)))
        .catchError((e) {
      throw PlatformException(code: e.code.toString(), message: e.message);
    });

    return jsObjectToMap(result);
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

  static ZIMMessage getZIMMessage(Object messageObj) {
    Map messageMap = jsObjectToMap(messageObj);
    ZIMMessage zimMessage = ZIMMessage();
    zimMessage.conversationID = messageMap['conversationID'];
    zimMessage.conversationSeq = messageMap['conversationSeq'];
    zimMessage.messageID = int.parse(messageMap['messageID']);
    zimMessage.senderUserID = messageMap['senderUserID'];
    zimMessage.timestamp = messageMap['timestamp'];
    zimMessage.orderKey = messageMap['orderKey'];
    zimMessage.localMessageID = int.parse(messageMap['localMessageID']);
    zimMessage.type = ZIMMessageType.values[messageMap['type']];
    zimMessage.direction = ZIMMessageDirection.values[messageMap['direction']];
    zimMessage.sentStatus =
        ZIMMessageSentStatus.values[messageMap['sentStatus']];
    zimMessage.conversationType =
        ZIMConversationType.values[messageMap['conversationType']];
    zimMessage.isUserInserted = messageMap['isUserInserted'] is bool
        ? messageMap['isUserInserted']
        : false;
    zimMessage.extendedData =
        messageMap['extendedData'] is String ? messageMap['extendedData'] : '';

    return zimMessage;
  }
}
