import 'dart:async';
import 'package:flutter/services.dart';
import 'zim_common_data.dart';
import 'zim_converter.dart';
import 'zim_event_handler_impl.dart';
import '../zim_api.dart';
import '../zim_defines.dart';
import 'zim_defines_extension.dart';

class ZIMImpl implements ZIM {
  static const MethodChannel _channel = MethodChannel('zego_zim_plugin');
  static ZIMImpl? _zimImpl;

  /// Used to receive the native event stream
  static StreamSubscription<dynamic>? streamSubscription;

  static ZIMImpl getInstance() {
    _zimImpl ??= ZIMImpl();
    ZIMEventHandlerImpl.registerEventHandler();
    return _zimImpl!;
  }

  @override
  Future<String> getVersion() async {
    final String resultStr = await _channel.invokeMethod('getVersion');
    return resultStr;
  }

  @override
  Future<void> create(ZIMAppConfig config) async {
    return await _channel.invokeMethod("create",
        {"appConfig": ZIMConverter.cnvZIMAppConfigObjectToMap(config)});
  }

  @override
  Future<void> destroy() async {
    return await _channel.invokeMethod("destroy");
  }

  @override
  Future<void> setLogConfig(ZIMLogConfig config) async {
    return await _channel.invokeMethod(
        'setLogConfig', {'logPath': config.logPath, 'logSize': config.logSize});
  }

  @override
  Future<void> setCacheConfig(ZIMCacheConfig config) async {
    return await _channel
        .invokeMethod('setCacheConfig', {'cachePath': config.cachePath});
  }

  @override
  Future<void> login(ZIMUserInfo userInfo, String token) async {
    return await _channel.invokeMethod("login", {
      "userID": userInfo.userID,
      "userName": userInfo.userName,
      "token": token
    });
  }

  @override
  Future<void> logout() async {
    return await _channel.invokeMethod('logout');
  }

  @override
  Future<void> uploadLog() async {
    return await _channel.invokeMethod('uploadLog');
  }

  @override
  Future<ZIMTokenRenewedResult> renewToken(String token) async {
    Map resultMap = await _channel.invokeMethod('renewToken', {'token': token});
    return ZIMConverter.cnvTokenRenewedMapToObject(resultMap);
  }

  @override
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDs, ZIMUserInfoQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryUsersInfo', {
      'userIDs': userIDs,
      'config': ZIMConverter.cnvZIMUserInfoQueryConfigObjectToMap(config)
    });

    return ZIMConverter.cnvZIMUsersInfoQueriedMapToObject(resultMap);
  }

  @override
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
      String extendedData) async {
    Map resultMap = await _channel
        .invokeMethod('updateUserExtendedData', {'extendedData': extendedData});
    return ZIMConverter.cnvZIMUserExtendedDataUpdatedMapToObject(resultMap);
  }

  @override
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName) async {
    Map resultMap =
        await _channel.invokeMethod('updateUserName', {'userName': userName});
    return ZIMConverter.cnvZIMUserNameUpdatedMapToObject(resultMap);
  }

  @override
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryConversationList', {
      'config': ZIMConverter.cnvZIMConversationQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMConversationListQueriedMapToObject(resultMap);
  }

  @override
  Future<ZIMConversationDeletedResult> deleteConversation(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMConversationDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteConversation', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMConversationDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMConversationDeletedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType) async {
    Map resultMap =
        await _channel.invokeMethod('clearConversationUnreadMessageCount', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter
        .cnvZIMConversationUnreadMessageCountClearedResultMapToObject(
            resultMap);
  }

  @override
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType) async {
    Map resultMap =
        await _channel.invokeMethod('setConversationNotificationStatus', {
      'status': ZIMConversationNotificationStatusExtension.valueMap[status],
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter
        .cnvZIMConversationNotificationStatusSetResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendPeerMessage', {
      'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
      'toUserID': toUserID,
      'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendGroupMessage', {
      'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
      'toGroupID': toGroupID,
      'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config) async {
    Map resultMap = await _channel.invokeMethod('sendRoomMessage', {
      'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
      'toRoomID': toRoomID,
      'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMediaDownloadedResult> downloadMediaFile(ZIMMediaMessage message,
      ZIMMediaFileType fileType, ZIMMediaDownloadingProgress? progress) async {
    Map resultMap;
    if (progress != null) {
      int progressID = ZIMCommonData.progressSequence + 1;
      ZIMCommonData.progressSequence = ZIMCommonData.progressSequence + 1;
      ZIMCommonData.mediaDownloadingProgressMap[progressID] = progress;
      resultMap = await _channel.invokeMethod('downloadMediaFile', {
        'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
        'fileType': ZIMMediaFileTypeExtension.valueMap[fileType],
        'progressID': progressID
      });
      ZIMCommonData.mediaDownloadingProgressMap.remove(progressID);
    } else {
      resultMap = await _channel.invokeMethod('downloadMediaFile', {
        'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
        'fileType': ZIMMediaFileTypeExtension.valueMap[fileType]
      });
    }
    return ZIMConverter.cnvZIMMediaDownloadedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaUploadingProgress? progress) async {
    Map resultMap;
    if (progress != null) {
      int progressID = ZIMCommonData.progressSequence + 1;
      ZIMCommonData.progressSequence = ZIMCommonData.progressSequence + 1;
      ZIMCommonData.mediaUploadingProgressMap[progressID] = progress;
      resultMap = await _channel.invokeMethod('sendMediaMessage', {
        'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
        'toConversationID': toConversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType],
        'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config),
        'progressID': progressID
      });
      ZIMCommonData.mediaUploadingProgressMap.remove(progressID);
    } else {
      resultMap = await _channel.invokeMethod('sendMediaMessage', {
        'message': ZIMConverter.cnvZIMMessageObjectToMap(message),
        'toConversationID': toConversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType],
        'config': ZIMConverter.cnvZIMMessageSendConfigObjectToMap(config)
      });
    }
    return ZIMConverter.cnvZIMMessageSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryHistoryMessage', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteAllMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteAllMessage', {
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageDeletedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteMessages', {
      'messageList': ZIMConverter.cnvZIMMessageListObjectToMap(messageList),
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.cnvZIMMessageDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMMessageDeletedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]) async {
    Map resultMap;
    if (config == null) {
      resultMap = await _channel.invokeMethod('createRoom',
          {'roomInfo': ZIMConverter.cnvZIMRoomInfoObjectToMap(roomInfo)});
    } else {
      resultMap = await _channel.invokeMethod('createRoomWithConfig', {
        'roomInfo': ZIMConverter.cnvZIMRoomInfoObjectToMap(roomInfo),
        'config': ZIMConverter.cnvZIMRoomAdvancedConfigObjectToMap(config)
      });
    }
    return ZIMConverter.cnvZIMRoomCreatedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomJoinedResult> joinRoom(String roomID) async {
    Map resultMap = await _channel.invokeMethod('joinRoom', {'roomID': roomID});
    return ZIMConverter.cnvZIMRoomJoinedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomEnteredResult> enterRoom(
      ZIMRoomInfo roomInfo, ZIMRoomAdvancedConfig config) async {
    Map resultMap;
    // if (config == null) {
    //   resultMap = await _channel.invokeMethod('enterRoom',
    //       {'roomInfo': ZIMConverter.cnvZIMRoomInfoObjectToMap(roomInfo)});
    // } else {
    resultMap = await _channel.invokeMethod('enterRoom', {
      'roomInfo': ZIMConverter.cnvZIMRoomInfoObjectToMap(roomInfo),
      'config': ZIMConverter.cnvZIMRoomAdvancedConfigObjectToMap(config)
    });
    //}
    return ZIMConverter.cnvZIMRoomEnteredResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomLeftResult> leaveRoom(String roomID) async {
    Map resultMap =
        await _channel.invokeMethod('leaveRoom', {'roomID': roomID});
    return ZIMConverter.cnvZIMRoomLeftResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryRoomMemberList', {
      'roomID': roomID,
      'config': ZIMConverter.cnvZIMRoomMemberQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMRoomMemberQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID) async {
    Map resultMap = await _channel
        .invokeMethod('queryRoomOnlineMemberCount', {'roomID': roomID});
    return ZIMConverter.cnvZIMRoomOnlineMemberCountQueriedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig config) async {
    Map resultMap = await _channel.invokeMethod('setRoomAttributes', {
      'roomAttributes': roomAttributes,
      'roomID': roomID,
      'config': ZIMConverter.cnvZIMRoomAttributesSetConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMRoomAttributesOperatedCallResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
      List<String> keys,
      String roomID,
      ZIMRoomAttributesDeleteConfig config) async {
    Map resultMap = await _channel.invokeMethod('deleteRoomAttributes', {
      'keys': keys,
      'roomID': roomID,
      "config": ZIMConverter.cnvZIMRoomAttributesDeleteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMRoomAttributesOperatedCallResultMapToObject(
        resultMap);
  }

  @override
  Future<void> beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig config) async {
    return await _channel.invokeMethod('beginRoomAttributesBatchOperation', {
      'roomID': roomID,
      'config':
          ZIMConverter.cnvZIMRoomAttributesBatchOperationConfigObjectToMap(
              config)
    });
  }

  @override
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID) async {
    Map resultMap = await _channel
        .invokeMethod('endRoomAttributesBatchOperation', {'roomID': roomID});
    return ZIMConverter.cnvZIMRoomAttributesBatchOperatedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(
      String roomID) async {
    Map resultMap = await _channel
        .invokeMethod('queryRoomAllAttributes', {'roomID': roomID});
    return ZIMConverter.cnvZIMRoomAttributesQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]) async {
    Map resultMap;
    if (config == null) {
      resultMap = await _channel.invokeMethod('createGroup', {
        'groupInfo': ZIMConverter.cnvZIMGroupInfoObjectToMap(groupInfo),
        'userIDs': userIDs
      });
    } else {
      resultMap = await _channel.invokeMethod('createGroupWithConfig', {
        'groupInfo': ZIMConverter.cnvZIMGroupInfoObjectToMap(groupInfo),
        'userIDs': userIDs,
        'config': ZIMConverter.cnvZIMGroupAdvancedConfigObjectToMap(config)
      });
    }
    return ZIMConverter.cnvZIMGroupCreatedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID) async {
    Map resultMap =
        await _channel.invokeMethod('dismissGroup', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupDismissedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupJoinedResult> joinGroup(String groupID) async {
    Map resultMap =
        await _channel.invokeMethod('joinGroup', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupJoinedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupLeftResult> leaveGroup(String groupID) async {
    Map resultMap =
        await _channel.invokeMethod('leaveGroup', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupLeftResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'inviteUsersIntoGroup', {'userIDs': userIDs, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupUsersInvitedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'kickGroupMembers', {'userIDs': userIDs, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupMemberKickedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'transferGroupOwner', {'toUserID': toUserID, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupOwnerTransferredResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'updateGroupName', {'groupName': groupName, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupNameUpdatedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'updateGroupNotice', {'groupNotice': groupNotice, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupNoticeUpdatedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID) async {
    Map resultMap =
        await _channel.invokeMethod('queryGroupInfo', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupInfoQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID) async {
    Map resultMap = await _channel.invokeMethod('setGroupAttributes',
        {'groupAttributes': groupAttributes, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupAttributesOperatedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'deleteGroupAttributes', {'keys': keys, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupAttributesOperatedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'queryGroupAttributes', {'keys': keys, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupAttributesQueriedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID) async {
    Map resultMap = await _channel
        .invokeMethod('queryGroupAllAttributes', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupAttributesQueriedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      int role, String forUserID, String groupID) async {
    Map resultMap = await _channel.invokeMethod('setGroupMemberRole',
        {'role': role, 'forUserID': forUserID, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupMemberRoleUpdatedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID) async {
    Map resultMap = await _channel.invokeMethod('setGroupMemberNickname',
        {'nickname': nickname, 'forUserID': forUserID, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupMemberNicknameUpdatedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID) async {
    Map resultMap = await _channel.invokeMethod(
        'queryGroupMemberInfo', {'userID': userID, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupMemberInfoQueriedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
      String groupID) async {
    Map resultMap = await _channel
        .invokeMethod('queryGroupMemberCount', {'groupID': groupID});
    return ZIMConverter.cnvZIMGroupMemberCountQueriedResultMapToObject(
        resultMap);
  }

  @override
  Future<ZIMGroupListQueriedResult> queryGroupList() async {
    Map resultMap = await _channel.invokeMethod('queryGroupList');
    return ZIMConverter.cnvZIMGroupListQueriedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config) async {
    Map resultMap = await _channel.invokeMethod('queryGroupMemberList', {
      'groupID': groupID,
      'config': ZIMConverter.cnvZIMGroupMemberQueryConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMGroupMemberListQueriedResultMapToResult(
        resultMap);
  }

  @override
  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    Map resultMap = await _channel.invokeMethod('callInvite', {
      'invitees': invitees,
      'config': ZIMConverter.cnvZIMCallInviteConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMCallInvitationSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    Map resultMap = await _channel.invokeMethod('callCancel', {
      'invitees': invitees,
      'callID': callID,
      'config': ZIMConverter.cnvZIMCallCancelConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMCallCancelSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config) async {
    Map resultMap = await _channel.invokeMethod('callAccept', {
      'callID': callID,
      'config': ZIMConverter.cnvZIMCallAcceptConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMCallAcceptanceSentResultMapToObject(resultMap);
  }

  @override
  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config) async {
    Map resultMap = await _channel.invokeMethod('callReject', {
      'callID': callID,
      'config': ZIMConverter.cnvZIMCallRejectConfigObjectToMap(config)
    });
    return ZIMConverter.cnvZIMCallRejectionSentResultMapToObject(resultMap);
  }

    @override
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
      String userAvatarUrl) async {
    Map resultMap = await _channel
        .invokeMethod('updateUserAvatarUrl', {'userAvatarUrl': userAvatarUrl});
    return ZIMConverter.cnvZIMUserAvatarUrlUpdatedResultMapToObject(resultMap);
  }

  @override
  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    Map resultMap = await _channel.invokeMethod('updateGroupAvatarUrl',
        {'groupAvatarUrl': groupAvatarUrl, 'groupID': groupID});
    return ZIMConverter.cnvZIMGroupAvatarUrlUpdatedResultMapToObject(resultMap);
  }
}
