import 'dart:async';
import 'package:flutter/services.dart';
import 'zim_common_data.dart';
import 'zim_converter.dart';
import '../zim_api.dart';
import '../zim_defines.dart';
import 'zim_manager.dart';
import 'zim_event_handler_impl.dart';
import 'zim_defines_extension.dart';

class ZIMEngine implements ZIM {
  String handle;
  int appID;
  String appSign;
  MethodChannel channel;
  ZIMEngine(
      {required this.handle,
      required this.channel,
      required this.appID,
      required this.appSign});

  @override
  destroy() {
    if (ZIMManager.destroyEngine(handle)) {
      channel.invokeMethod("destroy", {"handle": handle});
      // TODO: Remove another map
      // ZIMEventHandlerImpl.unregisterEventHandler();
    }
  }

  @override
  Future<void> login(ZIMUserInfo userInfo, [String? token]) async {
    return await channel.invokeMethod("login", {
      "handle": handle,
      "userID": userInfo.userID,
      "userName": userInfo.userName,
      "token": token
    });
  }

  @override
  logout() {
    channel.invokeMethod('logout', {"handle": handle});
  }

  @override
  Future<void> uploadLog() async {
    return await channel.invokeMethod('uploadLog', {"handle": handle});
  }

  @override
  Future<ZIMTokenRenewedResult> renewToken(String token) async {
    Map resultMap = await channel
        .invokeMethod('renewToken', {'handle': handle, 'token': token});
    return ZIMConverter.oTokenRenewedResult(resultMap);
  }

  @override
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDs, ZIMUserInfoQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryUsersInfo', {
      'handle': handle,
      'userIDs': userIDs,
      'config': ZIMConverter.mZIMUserInfoQueryConfig(config)
    });

    return ZIMConverter.oZIMUsersInfoQueriedResult(resultMap);
  }

  @override
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
      String extendedData) async {
    Map resultMap = await channel.invokeMethod('updateUserExtendedData',
        {'handle': handle, 'extendedData': extendedData});
    return ZIMConverter.oZIMUserExtendedDataUpdatedResult(resultMap);
  }

  @override
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName) async {
    Map resultMap = await channel.invokeMethod(
        'updateUserName', {'handle': handle, 'userName': userName});
    return ZIMConverter.oZIMUserNameUpdatedResult(resultMap);
  }

  @override
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryConversationList', {
      'handle': handle,
      'config': ZIMConverter.mZIMConversationQueryConfig(config)
    });
    return ZIMConverter.oZIMConversationListQueriedResult(resultMap);
  }

  @override
  Future<ZIMConversationDeletedResult> deleteConversation(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMConversationDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteConversation', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.mZIMConversationDeleteConfig(config)
    });
    return ZIMConverter.oZIMConversationDeletedResult(resultMap);
  }

  @override
  Future<void> deleteAllConversations(
      ZIMConversationDeleteConfig config) async {
    return await channel.invokeMethod('deleteAllConversations', {
      'handle': handle,
      'config': ZIMConverter.mZIMConversationDeleteConfig(config)
    });
  }

  @override
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('clearConversationUnreadMessageCount', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter.oZIMConversationUnreadMessageCountClearedResult(
        resultMap);
  }

  @override
  Future<void>
  clearConversationTotalUnreadMessageCount() async {
    return await channel.invokeMethod('clearConversationTotalUnreadMessageCount', {
      'handle': handle,
    });
  }

  @override
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType) async {
    Map resultMap =
        await channel.invokeMethod('setConversationNotificationStatus', {
      'handle': handle,
      'status': ZIMConversationNotificationStatusExtension.valueMap[status],
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter.oZIMConversationNotificationStatusSetResult(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendPeerMessage', {
      'handle': handle,
      'message': ZIMConverter.mZIMMessage(message),
      'toUserID': toUserID,
      'config': ZIMConverter.mZIMMessageSendConfig(config)
    });
    return ZIMConverter.oZIMMessageSentResult(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendGroupMessage', {
      'handle': handle,
      'message': ZIMConverter.mZIMMessage(message),
      'toGroupID': toGroupID,
      'config': ZIMConverter.mZIMMessageSendConfig(config)
    });
    return ZIMConverter.oZIMMessageSentResult(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config) async {
    Map resultMap = await channel.invokeMethod('sendRoomMessage', {
      'handle': handle,
      'message': ZIMConverter.mZIMMessage(message),
      'toRoomID': toRoomID,
      'config': ZIMConverter.mZIMMessageSendConfig(config)
    });
    return ZIMConverter.oZIMMessageSentResult(resultMap);
  }

  @override
  Future<ZIMMediaDownloadedResult> downloadMediaFile(ZIMMediaMessage message,
      ZIMMediaFileType fileType, ZIMMediaDownloadingProgress? progress) async {
    Map resultMap;
    if (progress != null) {
      int progressID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaDownloadingProgressMap[progressID] = progress;
      resultMap = await channel.invokeMethod('downloadMediaFile', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'fileType': ZIMMediaFileTypeExtension.valueMap[fileType],
        'progressID': progressID
      });
      ZIMCommonData.mediaDownloadingProgressMap.remove(progressID);
    } else {
      resultMap = await channel.invokeMethod('downloadMediaFile', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'fileType': ZIMMediaFileTypeExtension.valueMap[fileType]
      });
    }
    return ZIMConverter.oZIMMediaDownloadedResult(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaMessageSendNotification? notification) async {
    Map resultMap;
    int messageID = ZIMCommonData.getSequence();
    int? progressID;
    int? messageAttachedCallbackID;
    if (notification?.onMediaUploadingProgress != null) {
      progressID = ZIMCommonData.getSequence();
      ZIMCommonData.mediaUploadingProgressMap[progressID] =
          notification!.onMediaUploadingProgress!;
    }
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    try {
      resultMap = await channel.invokeMethod('sendMediaMessage', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'toConversationID': toConversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType],
        'config': ZIMConverter.mZIMMessageSendConfig(config),
        'messageID': messageID,
        'progressID': progressID,
        'messageAttachedCallbackID': messageAttachedCallbackID
      });
      return ZIMConverter.oZIMMessageSentResult(resultMap);
    } on PlatformException catch (e) {
      resultMap = e.details;
      ZIMMessageSentResult result =
          ZIMConverter.oZIMMessageSentResult(resultMap);
      result.message.sentStatus = ZIMMessageSentStatus.failed;
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.mediaUploadingProgressMap.remove(progressID);
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
    }
  }

  @override
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryHistoryMessage', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.mZIMMessageQueryConfig(config)
    });
    return ZIMConverter.oZIMMessageQueriedResult(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteAllMessage(
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteAllMessage', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.mZIMMessageDeleteConfig(config)
    });
    return ZIMConverter.oZIMMessageDeletedResult(resultMap);
  }

  @override
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteMessages', {
      'handle': handle,
      'messageList': ZIMConverter.mZIMMessageList(messageList),
      'conversationID': conversationID,
      'conversationType':
          ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.mZIMMessageDeleteConfig(config)
    });
    return ZIMConverter.oZIMMessageDeletedResult(resultMap);
  }

  @override
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]) async {
    Map resultMap;
    if (config == null) {
      resultMap = await channel.invokeMethod('createRoom',
          {'handle': handle, 'roomInfo': ZIMConverter.mZIMRoomInfo(roomInfo)});
    } else {
      resultMap = await channel.invokeMethod('createRoomWithConfig', {
        'handle': handle,
        'roomInfo': ZIMConverter.mZIMRoomInfo(roomInfo),
        'config': ZIMConverter.mZIMRoomAdvancedConfig(config)
      });
    }
    return ZIMConverter.oZIMRoomCreatedResult(resultMap);
  }

  @override
  Future<ZIMRoomJoinedResult> joinRoom(String roomID) async {
    Map resultMap = await channel
        .invokeMethod('joinRoom', {'handle': handle, 'roomID': roomID});
    return ZIMConverter.oZIMRoomJoinedResult(resultMap);
  }

  @override
  Future<ZIMRoomEnteredResult> enterRoom(
      ZIMRoomInfo roomInfo, ZIMRoomAdvancedConfig config) async {
    Map resultMap;
    resultMap = await channel.invokeMethod('enterRoom', {
      'handle': handle,
      'roomInfo': ZIMConverter.mZIMRoomInfo(roomInfo),
      'config': ZIMConverter.mZIMRoomAdvancedConfig(config)
    });
    //}
    return ZIMConverter.oZIMRoomEnteredResult(resultMap);
  }

  @override
  Future<ZIMRoomLeftResult> leaveRoom(String roomID) async {
    Map resultMap = await channel
        .invokeMethod('leaveRoom', {'handle': handle, 'roomID': roomID});
    return ZIMConverter.oZIMRoomLeftResult(resultMap);
  }

  @override
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryRoomMemberList', {
      'handle': handle,
      'roomID': roomID,
      'config': ZIMConverter.mZIMRoomMemberQueryConfig(config)
    });
    return ZIMConverter.oZIMRoomMemberQueriedResult(resultMap);
  }

  @override
  Future<ZIMRoomMembersQueriedResult> queryRoomMembers(
      List<String> userIDs, String roomID) async {
    Map resultMap = await channel.invokeMethod('queryRoomMembers', {
      'handle': handle,
      'roomID': roomID,
      'userIDs': userIDs
    });
    return ZIMConverter.oZIMRoomMembersQueriedResult(resultMap);
  }

  @override
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'queryRoomOnlineMemberCount', {'handle': handle, 'roomID': roomID});
    return ZIMConverter.oZIMRoomOnlineMemberCountQueriedResult(resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig config) async {
    Map resultMap = await channel.invokeMethod('setRoomAttributes', {
      'handle': handle,
      'roomAttributes': roomAttributes,
      'roomID': roomID,
      'config': ZIMConverter.mZIMRoomAttributesSetConfig(config)
    });
    return ZIMConverter.oZIMRoomAttributesOperatedCallResult(resultMap);
  }

  @override
  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
      List<String> keys,
      String roomID,
      ZIMRoomAttributesDeleteConfig config) async {
    Map resultMap = await channel.invokeMethod('deleteRoomAttributes', {
      'handle': handle,
      'keys': keys,
      'roomID': roomID,
      "config": ZIMConverter.mZIMRoomAttributesDeleteConfig(config)
    });
    return ZIMConverter.oZIMRoomAttributesOperatedCallResult(resultMap);
  }

  @override
  void beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig config) async {
    return await channel.invokeMethod('beginRoomAttributesBatchOperation', {
      'handle': handle,
      'roomID': roomID,
      'config': ZIMConverter.mZIMRoomAttributesBatchOperationConfig(config)
    });
  }

  @override
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'endRoomAttributesBatchOperation',
        {'handle': handle, 'roomID': roomID});
    return ZIMConverter.oZIMRoomAttributesBatchOperatedResult(resultMap);
  }

  @override
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(
      String roomID) async {
    Map resultMap = await channel.invokeMethod(
        'queryRoomAllAttributes', {'handle': handle, 'roomID': roomID});
    return ZIMConverter.oZIMRoomAttributesQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]) async {
    Map resultMap;
    if (config == null) {
      resultMap = await channel.invokeMethod('createGroup', {
        'handle': handle,
        'groupInfo': ZIMConverter.mZIMGroupInfo(groupInfo),
        'userIDs': userIDs
      });
    } else {
      resultMap = await channel.invokeMethod('createGroupWithConfig', {
        'handle': handle,
        'groupInfo': ZIMConverter.mZIMGroupInfo(groupInfo),
        'userIDs': userIDs,
        'config': ZIMConverter.mZIMGroupAdvancedConfig(config)
      });
    }
    return ZIMConverter.oZIMGroupCreatedResult(resultMap);
  }

  @override
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('dismissGroup', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupDismissedResult(resultMap);
  }

  @override
  Future<ZIMGroupJoinedResult> joinGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('joinGroup', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupJoinedResult(resultMap);
  }

  @override
  Future<ZIMGroupLeftResult> leaveGroup(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('leaveGroup', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupLeftResult(resultMap);
  }

  @override
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID) async {
    Map resultMap = await channel.invokeMethod('inviteUsersIntoGroup',
        {'handle': handle, 'userIDs': userIDs, 'groupID': groupID});
    return ZIMConverter.oZIMGroupUsersInvitedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID) async {
    Map resultMap = await channel.invokeMethod('kickGroupMembers',
        {'handle': handle, 'userIDs': userIDs, 'groupID': groupID});
    return ZIMConverter.oZIMGroupMemberKickedResult(resultMap);
  }

  @override
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('transferGroupOwner',
        {'handle': handle, 'toUserID': toUserID, 'groupID': groupID});
    return ZIMConverter.oZIMGroupOwnerTransferredResult(resultMap);
  }

  @override
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupName',
        {'handle': handle, 'groupName': groupName, 'groupID': groupID});
    return ZIMConverter.oZIMGroupNameUpdatedResult(resultMap);
  }

  @override
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupNotice',
        {'handle': handle, 'groupNotice': groupNotice, 'groupID': groupID});
    return ZIMConverter.oZIMGroupNoticeUpdatedResult(resultMap);
  }

  @override
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID) async {
    Map resultMap = await channel
        .invokeMethod('queryGroupInfo', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupInfoQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupAttributes', {
      'handle': handle,
      'groupAttributes': groupAttributes,
      'groupID': groupID
    });
    return ZIMConverter.oZIMGroupAttributesOperatedResult(resultMap);
  }

  @override
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await channel.invokeMethod('deleteGroupAttributes',
        {'handle': handle, 'keys': keys, 'groupID': groupID});
    return ZIMConverter.oZIMGroupAttributesOperatedResult(resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID) async {
    Map resultMap = await channel.invokeMethod('queryGroupAttributes',
        {'handle': handle, 'keys': keys, 'groupID': groupID});
    return ZIMConverter.oZIMGroupAttributesQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID) async {
    Map resultMap = await channel.invokeMethod(
        'queryGroupAllAttributes', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupAttributesQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      int role, String forUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupMemberRole', {
      'handle': handle,
      'role': role,
      'forUserID': forUserID,
      'groupID': groupID
    });
    return ZIMConverter.oZIMGroupMemberRoleUpdatedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID) async {
    Map resultMap = await channel.invokeMethod('setGroupMemberNickname', {
      'handle': handle,
      'nickname': nickname,
      'forUserID': forUserID,
      'groupID': groupID
    });
    return ZIMConverter.oZIMGroupMemberNicknameUpdatedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID) async {
    Map resultMap = await channel.invokeMethod('queryGroupMemberInfo',
        {'handle': handle, 'userID': userID, 'groupID': groupID});
    return ZIMConverter.oZIMGroupMemberInfoQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
      String groupID) async {
    Map resultMap = await channel.invokeMethod(
        'queryGroupMemberCount', {'handle': handle, 'groupID': groupID});
    return ZIMConverter.oZIMGroupMemberCountQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupListQueriedResult> queryGroupList() async {
    Map resultMap =
        await channel.invokeMethod('queryGroupList', {'handle': handle});
    return ZIMConverter.oZIMGroupListQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryGroupMemberList', {
      'handle': handle,
      'groupID': groupID,
      'config': ZIMConverter.mZIMGroupMemberQueryConfig(config)
    });
    return ZIMConverter.oZIMGroupMemberListQueriedResult(resultMap);
  }

  @override
  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config) async {
    Map resultMap = await channel.invokeMethod('callInvite', {
      'handle': handle,
      'invitees': invitees,
      'config': ZIMConverter.mZIMCallInviteConfig(config)
    });
    return ZIMConverter.oZIMCallInvitationSentResult(resultMap);
  }

  @override
  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config) async {
    Map resultMap = await channel.invokeMethod('callCancel', {
      'handle': handle,
      'invitees': invitees,
      'callID': callID,
      'config': ZIMConverter.mZIMCallCancelConfig(config)
    });
    return ZIMConverter.oZIMCallCancelSentResult(resultMap);
  }

  @override
  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config) async {
    Map resultMap = await channel.invokeMethod('callAccept', {
      'handle': handle,
      'callID': callID,
      'config': ZIMConverter.mZIMCallAcceptConfig(config)
    });
    return ZIMConverter.oZIMCallAcceptanceSentResult(resultMap);
  }

  @override
  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config) async {
    Map resultMap = await channel.invokeMethod('callReject', {
      'handle': handle,
      'callID': callID,
      'config': ZIMConverter.cnvZIMCallRejectConfigObjectToMap(config)
    });
    return ZIMConverter.oZIMCallRejectionSentResult(resultMap);
  }

  @override
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
      String userAvatarUrl) async {
    Map resultMap = await channel.invokeMethod('updateUserAvatarUrl',
        {'handle': handle, 'userAvatarUrl': userAvatarUrl});
    return ZIMConverter.oZIMUserAvatarUrlUpdatedResult(resultMap);
  }

  @override
  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    Map resultMap = await channel.invokeMethod('updateGroupAvatarUrl', {
      'handle': handle,
      'groupAvatarUrl': groupAvatarUrl,
      'groupID': groupID
    });
    return ZIMConverter.oZIMGroupAvatarUrlUpdatedResult(resultMap);
  }

  @override
  Future<ZIMRoomMemberAttributesListQueriedResult>
      queryRoomMemberAttributesList(
          String roomID, ZIMRoomMemberAttributesQueryConfig config) async {
    Map resultMap =
        await channel.invokeMethod('queryRoomMemberAttributesList', {
      'handle': handle,
      'roomID': roomID,
      'config': ZIMConverter.mZIMRoomMemberAttributesQueryConfig(config)
    });
    return ZIMConverter.oZIMRoomMemberAttributesListQueriedResult(resultMap);
  }

  @override
  Future<ZIMRoomMembersAttributesQueriedResult> queryRoomMembersAttributes(
      List<String> userIDs, String roomID) async {
    Map resultMap = await channel.invokeMethod('queryRoomMembersAttributes',
        {'handle': handle, 'roomID': roomID, 'userIDs': userIDs});
    return ZIMConverter.oZIMRoomMembersAttributesQueriedResult(resultMap);
  }

  @override
  Future<ZIMRoomMembersAttributesOperatedResult> setRoomMembersAttributes(
      Map<String, String> attributes,
      List<String> userIDs,
      String roomID,
      ZIMRoomMemberAttributesSetConfig config) async {
    Map resultMap = await channel.invokeMethod('setRoomMembersAttributes', {
      'handle': handle,
      'attributes': attributes,
      'roomID': roomID,
      'userIDs': userIDs,
      'config': ZIMConverter.mZIMRoomMemberAttributesSetConfig(config)
    });
    return ZIMConverter.oZIMRoomMembersAttributesOperatedResult(resultMap);
  }

  @override
  Future<ZIMMessageSentResult> sendMessage(
      ZIMMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      [ZIMMessageSendNotification? notification]) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;
    int? messageAttachedCallbackID;
    if (notification?.onMessageAttached != null) {
      messageAttachedCallbackID = ZIMCommonData.getSequence();
      ZIMCommonData.zimMessageAttachedCallbackMap[messageAttachedCallbackID] =
          notification!.onMessageAttached!;
    }
    try {
      Map resultMap = await channel.invokeMethod('sendMessage', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'toConversationID': toConversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType],
        'config': ZIMConverter.mZIMMessageSendConfig(config),
        'messageAttachedCallbackID': messageAttachedCallbackID,
        'messageID': messageID
      });
      ZIMMessageSentResult result =
          ZIMConverter.oZIMMessageSentResult(resultMap);
      // ios 2.5.0 桥层bug 临时规避方法，后续删除
      if (config.hasReceipt == true) {
        result.message.receiptStatus = ZIMMessageReceiptStatus.processing;
      }
      return result;
    } on PlatformException catch (e) {
      Map resultMap = e.details;
      ZIMMessageSentResult result =
          ZIMConverter.oZIMMessageSentResult(resultMap);
      result.message.sentStatus = ZIMMessageSentStatus.failed;
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
      ZIMCommonData.zimMessageAttachedCallbackMap
          .remove(messageAttachedCallbackID);
    }
  }

  @override
  Future<ZIMMessageInsertedResult> insertMessageToLocalDB(
      ZIMMessage message,
      String conversationID,
      ZIMConversationType conversationType,
      String senderUserID) async {
    int messageID = ZIMCommonData.getSequence();
    ZIMCommonData.messsageMap[messageID] = message;
    try {
      Map resultMap = await channel.invokeMethod('insertMessageToLocalDB', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'messageID': messageID,
        'conversationID': conversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType],
        'senderUserID': senderUserID
      });
      return ZIMConverter.oZIMMessageInsertedResult(resultMap);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } finally {
      ZIMCommonData.messsageMap.remove(messageID);
    }
  }

  @override
  Future<ZIMConversationMessageReceiptReadSentResult> sendConversationMessageReceiptRead(
      String conversationID,
      ZIMConversationType conversationType) async {
      Map resultMap = await channel.invokeMethod('sendConversationMessageReceiptRead', {
        'handle': handle,
        'conversationID': conversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType]
      });
      return ZIMConverter.oZIMConversationMessageReceiptReadSentResult(resultMap);
  }

  @override
  Future<ZIMMessageReceiptsReadSentResult> sendMessageReceiptsRead(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType) async {
      Map resultMap = await channel.invokeMethod('sendMessageReceiptsRead', {
        'handle': handle,
        'messageList': ZIMConverter.mZIMMessageList(messageList),
        'conversationID': conversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType]
      });
      return ZIMConverter.oZIMMessageReceiptReadSentResult(resultMap);
  }

  @override
  Future<ZIMMessageReceiptsInfoQueriedResult> queryMessageReceiptsInfo(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType) async {
      Map resultMap = await channel.invokeMethod('queryMessageReceiptsInfo', {
        'handle': handle,
        'messageList': ZIMConverter.mZIMMessageList(messageList),
        'conversationID': conversationID,
        'conversationType':
            ZIMConversationTypeExtension.valueMap[conversationType]
      });
      return ZIMConverter.oZIMMessageReceiptsInfoQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupMessageReceiptMemberListQueriedResult> queryGroupMessageReceiptReadMemberList(
      ZIMMessage message,
      String groupID,
      ZIMGroupMessageReceiptMemberQueryConfig config) async {
      Map resultMap = await channel.invokeMethod('queryGroupMessageReceiptReadMemberList', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'groupID': groupID,
        'config':ZIMConverter.mZIMGroupMessageReceiptMemberQueryConfig(config)
      });
      return ZIMConverter.oZIMGroupMessageReceiptMemberListQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupMessageReceiptMemberListQueriedResult> queryGroupMessageReceiptUnreadMemberList(
      ZIMMessage message,
      String groupID,
      ZIMGroupMessageReceiptMemberQueryConfig config) async {
      Map resultMap = await channel.invokeMethod('queryGroupMessageReceiptUnreadMemberList', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'groupID': groupID,
        'config':ZIMConverter.mZIMGroupMessageReceiptMemberQueryConfig(config)
      });
      return ZIMConverter.oZIMGroupMessageReceiptMemberListQueriedResult(resultMap);
  }

  @override
  Future<ZIMMessageRevokedResult> revokeMessage(
      ZIMMessage message,
      ZIMMessageRevokeConfig config) async {
      Map resultMap = await channel.invokeMethod('revokeMessage', {
        'handle': handle,
        'message': ZIMConverter.mZIMMessage(message),
        'config':ZIMConverter.mZIMMessageRevokeConfig(config)
      });
      return ZIMConverter.oZIMMessageRevokedResult(resultMap);
  }

  @override
  Future<ZIMMessageLocalExtendedDataUpdatedResult>
  updateMessageLocalExtendedData(String localExtendedData, ZIMMessage message) async{
    Map resultMap = await channel.invokeMethod('updateMessageLocalExtendedData', {
      'handle': handle,
      'localExtendedData': localExtendedData,
      'message': ZIMConverter.mZIMMessage(message)
    });
    return ZIMConverter.oZIMMessageLocalExtendedDataUpdatedResult(resultMap);
  }

  @override
  Future<ZIMMessagesSearchedResult> searchLocalMessages(String conversationID, ZIMConversationType conversationType, ZIMMessageSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalMessages', {
      'handle': handle,
      'conversationID': conversationID,
      'conversationType':
      ZIMConversationTypeExtension.valueMap[conversationType],
      'config': ZIMConverter.mZIMMessageSearchConfig(config)
    });
    return ZIMConverter.oZIMMessagesSearchedResult(resultMap);
  }

  @override
  Future<ZIMMessagesGlobalSearchedResult> searchGlobalLocalMessages(ZIMMessageSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchGlobalLocalMessages', {
      'handle': handle,
      'config': ZIMConverter.mZIMMessageSearchConfig(config)
    });
    return ZIMConverter.oZIMMessagesGlobalSearchedResult(resultMap);
  }

  @override
  Future<ZIMConversationsSearchedResult> searchLocalConversations(ZIMConversationSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalConversations', {
      'handle': handle,
      'config': ZIMConverter.mZIMConversationSearchConfig(config)
    });
    return ZIMConverter.oZIMConversationsSearchedResult(resultMap);
  }

  @override
  Future<ZIMConversationPinnedListQueriedResult> queryConversationPinnedList(
      ZIMConversationQueryConfig config) async{
    Map resultMap = await channel.invokeMethod('queryConversationPinnedList',{
      'handle': handle,
      'config': ZIMConverter.mZIMConversationQueryConfig(config)
    });
    return ZIMConverter.oZIMConversationPinnedListQueriedResult(resultMap);
  }

  @override
  Future<ZIMConversationPinnedStateUpdatedResult> updateConversationPinnedState(bool isPinned, String conversationID, ZIMConversationType conversationType) async{
    Map resultMap = await channel.invokeMethod('updateConversationPinnedState',{
      'handle': handle,
      'isPinned':isPinned,
      'conversationID':conversationID,
      'conversationType': ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter.oZIMConversationPinnedStateUpdatedResult(resultMap);
  }

  @override
  Future<ZIMConversationQueriedResult> queryConversation(String conversationID,
      ZIMConversationType conversationType) async{
    Map resultMap = await channel.invokeMethod('queryConversation',{
      'handle': handle,
      'conversationID':conversationID,
      'conversationType': ZIMConversationTypeExtension.valueMap[conversationType]
    });
    return ZIMConverter.oZIMConversationQueriedResult(resultMap);
  }


  @override
  Future<ZIMCallEndSentResult> callEnd(
      String callID, ZIMCallEndConfig config) async{
    Map resultMap = await channel.invokeMethod('callEnd',{
      'handle': handle,
      'callID': callID,
      'config': ZIMConverter.mZIMCallEndConfig(config)
    });
    return ZIMConverter.oZIMCallEndSentResult(resultMap);
  }

  @override
  Future<ZIMCallQuitSentResult> callQuit(String callID, ZIMCallQuitConfig config) async {
    Map resultMap = await channel.invokeMethod('callQuit',{
      'handle': handle,
      'callID': callID,
      'config': ZIMConverter.mZIMCallQuitConfig(config)
    });
    return ZIMConverter.oZIMCallQuitSentResult(resultMap);
  }

  @override
  Future<ZIMCallingInvitationSentResult> callingInvite(List<String> invitees, String callID,ZIMCallingInviteConfig config) async {
    Map resultMap = await channel.invokeMethod('callingInvite',{
      'handle': handle,
      'invitees': invitees,
      'callID': callID,
      'config': ZIMConverter.mZIMCallingInviteConfig(config)
    });
    return ZIMConverter.oZIMCallingInvitationSentResult(resultMap);
  }

  @override
  Future<ZIMCallInvitationListQueriedResult> queryCallInvitationList(ZIMCallInvitationQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryCallList',{
      'handle': handle,
      'config': ZIMConverter.mZIMQueryCallListConfig(config)
    });
    return ZIMConverter.oZIMCallListQueriedResult(resultMap);
  }

  @override
  Future<ZIMGroupsSearchedResult> searchLocalGroups(ZIMGroupSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalGroups',{
      'handle': handle,
      'config': ZIMConverter.mZIMGroupSearchConfig(config)
    });
    return ZIMConverter.oZIMGroupsSearchedResult(resultMap);
  }

  @override
  Future<ZIMGroupMembersSearchedResult> searchLocalGroupMembers(String groupID, ZIMGroupMemberSearchConfig config) async {
    Map resultMap = await channel.invokeMethod('searchLocalGroupMembers',{
      'handle': handle,
      'groupID': groupID,
      'config': ZIMConverter.mZIMGroupMemberSearchConfig(config)
    });
    return ZIMConverter.oZIMGroupMembersSearchedResult(resultMap);
  }
  @override
  Future<ZIMMessageReactionAddedResult> addMessageReaction (
      String reactionType, ZIMMessage message) async {
    Map resultMap = await channel.invokeMethod('addMessageReaction', {
      'handle': handle,
      'reactionType': reactionType,
      'message': ZIMConverter.mZIMMessage(message)
    });
    return ZIMConverter.oZIMAddMessageReactionResult(resultMap);
  }

  @override
  Future<ZIMMessageReactionDeletedResult> deleteMessageReaction (
      String reactionType, ZIMMessage message) async {
    Map resultMap = await channel.invokeMethod('deleteMessageReaction', {
      'handle': handle,
      'reactionType': reactionType,
      'message': ZIMConverter.mZIMMessage(message)
    });
    return ZIMConverter.oZIMDeleteMessageReactionResult(resultMap);
  }

  @override
  Future<ZIMMessageReactionUserListQueriedResult> queryMessageReactionUserList (
      ZIMMessage message, ZIMMessageReactionUsersQueryConfig config) async {
    Map resultMap = await channel.invokeMethod('queryMessageReactionUserList', {
      'handle': handle,
      'message': ZIMConverter.mZIMMessage(message),
      'config': ZIMConverter.mZIMMessageReactionUsersQueryConfig(config),
    });
    return ZIMConverter.oZIMReactionUsersQueryResult(resultMap);
  }

  @override
  Future<ZIMCallJoinSentResult> callJoin(String callID, ZIMCallJoinConfig config) async {
    Map resultMap = await channel.invokeMethod('callJoin',{
      'handle':handle,
      'callID':callID,
      'config': ZIMConverter.mZIMCallJoinConfig(config)
    });
    return ZIMConverter.oZIMCallJoinSentResult(resultMap);
  }

  @override
  Future<void> importLocalMessages(String folderPath, ZIMMessageImportConfig config, ZIMMessageImportingProgress? progress) async {
    if (progress != null) {
      int progressID = ZIMCommonData.getSequence();
      ZIMCommonData.messageImportingProgressMap[progressID] = progress;
      return await channel.invokeMethod("importLocalMessages", {
        "handle": handle,
        "folderPath": folderPath,
        "config": {},
        'progressID': progressID
      });
      ZIMCommonData.messageImportingProgressMap.remove(progressID);
    } else {
      return await channel.invokeMethod("importLocalMessages", {
        "handle": handle,
        "folderPath": folderPath,
        "config": {}
      });
    }
  }

  @override
  Future<void> exportLocalMessages(String folderPath, ZIMMessageExportConfig config, ZIMMessageExportingProgress? progress) async{
    if (progress != null) {
      int progressID = ZIMCommonData.getSequence();
      ZIMCommonData.messageExportingProgressMap[progressID] = progress;
      return await channel.invokeMethod("exportLocalMessages", {
        "handle": handle,
        "folderPath": folderPath,
        "config": {},
        'progressID': progressID
      });
      ZIMCommonData.messageExportingProgressMap.remove(progressID);
    } else {
      return await channel.invokeMethod("exportLocalMessages", {
        "handle": handle,
        "folderPath": folderPath,
        "config": {}
      });
    }
  }


}
