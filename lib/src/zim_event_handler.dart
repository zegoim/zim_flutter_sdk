import '../zego_zim.dart';

class ZIMEventHandler {
  /// The event callback when the connection state changes.
  ///
  /// [zim] ZIM instance.
  /// [state] The current connection state after changed.
  /// [event] The event that caused the connection state to change.
  /// [extendedData] Extra information when the event occurs, a standard JSON format data.
  static void Function(ZIM zim, ZIMConnectionState state,
      ZIMConnectionEvent event, Map extendedData)? onConnectionStateChanged;

/* Main */

  /// The callback for error information.
  ///
  /// When an exception occurs in the SDK, the callback will prompt detailed information.
  ///
  /// [zim] ZIM instance.
  /// [errorInfo] Error information, please refer to the error codes document.
  static void Function(ZIM zim, ZIMError errorInfo)? onError;

  /// A reminder callback that the token is about to expire.
  ///
  /// [zim] ZIM instance.
  /// [second] The remaining second before the token expires.
  static void Function(ZIM zim, int second)? onTokenWillExpire;

  ///Available since: 2.11.0 or above.
  ///
  ///Description: In the multi-terminal login scenario, after the user modifies their information on device A, other online multi-terminal devices will receive this callback. For offline devices, after the user goes online, they need to call the [ZIM.QueryUsersInfo] interface to actively query user information.
  static void Function(ZIM zim, ZIMUserFullInfo info)? onUserInfoUpdated;

  /// Available since: 2.15.0 and later versions.
  ///
  /// Description:Callback of user rule changes.
  ///
  /// When to Trigger: When the user rule of the current user is changed, all users are notified by the callback.
  static void Function(ZIM zim, ZIMUserRule)? onUserRuleUpdated;

  /// Available since: 2.18.0
  ///
  /// Description: User online status change notification.
  ///
  /// Use cases: This callback can be used when you needs to pay attention to the online status of certain users, for example, the online group members need to be displayed. After subscribing to users through the subscribeUsersStatus method, the online status of the targeted users and the changes of their online status during the validity period of the subscription will be notified to you through this callback.
  ///
  /// When to call /Trigger: After the current user subscribes to the target user for the first time, the event will be triggered if the target user is added to the subscription list for the first time, or the subscribed user's online status or online platform list. In addition, the callback will also be triggered if the current user has opened a multi-terminal login and the online platform has changed.
  ///
  ///
  /// Restrictions: When the userStatusUpdated callback returns the userStatus information of the current user, the onlineStatus will be unknown and the lastUpdateTime will be 0, which cannot truly present the online status. Map the online status of the current user according to connectionStateChanged.
  /// [userStatusList] A list with data about the user's online status.
  static void Function(ZIM zim, List<ZIMUserStatus> userStatusList)?
      onUserStatusUpdated;

  // Supported version: 2.11.0 or later.
  //
  // Description: In the multi-terminal login scenario, after the user deletes the server level message on device A, other online multi-terminal devices will receive this callback..
  static void Function(ZIM zim, ZIMMessageDeletedInfo deletedInfo)?
      onMessageDeleted;

  /// Available since: 2.17.0 and above.
  ///
  /// Description: Query the reply message list.
  ///
  /// Use cases: Developers can use this method to query the entire reply message tree.
  ///
  /// When to call: Callable after login.
  static void Function(ZIM zim, List<ZIMMessage> messageList)?
      onMessageRepliedInfoChanged;

  /// Available since: 2.17.0  or above
  ///
  /// Description: When there is a new reply message, the number of replies to the corresponding root message is notified through this event.
  static void Function(ZIM zim, List<ZIMMessageRootRepliedCountInfo> infos)?
      onMessageRepliedCountChanged;
/* Conversation */

  /// The callback for conversation changed event.
  ///
  ///
  /// [zim] ZIM instance.
  /// [conversationChangeInfoList] conversation list
  static void Function(
          ZIM zim, List<ZIMConversationChangeInfo> conversationChangeInfoList)?
      onConversationChanged;

  /// Available since: 2.12.0 and above.
  ///
  /// Description: When multiple login ends delete all sessions, the local end triggers the callback to notify the local end that all sessions are deleted.
  ///
  /// When to call /Trigger: When another end clears all unread sessions, the local end triggers a notification.
  ///
  /// Related APIs: Triggered by [deleteAllConversations].
  static void Function(ZIM zim, ZIMConversationsAllDeletedInfo info)?
      onConversationsAllDeleted;

  /// The callback for message sent status changed event.
  ///
  ///
  /// [zim] ZIM instance.
  /// [messageSentStatusChangedInfoList] message sent status changed info list
  static void Function(
      ZIM zim,
      List<ZIMMessageSentStatusChangeInfo>
          messageSentStatusChangedInfoList)? onMessageSentStatusChanged;

  /// The callback for conversation total unread message count changed.
  ///
  ///
  /// [zim] ZIM instance.
  /// [totalUnreadMessageCount] total unread message count
  static void Function(ZIM zim, int totalUnreadMessageCount)?
      onConversationTotalUnreadMessageCountUpdated;

  /// Available since: 2.5.0 and above.

  /// Description: When the message receiver has read the session, the message sender knows through this callback.

  /// Trigger: Trigger a notification when the message receiver has read the session.

  /// Related APIs: triggered when the peer calls via [ZIM.sendConversationMessageReceiptRead].
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
      onConversationMessageReceiptChanged;

/* Message */

  /// Deprecated since ZIM 2.18.0, please use  [onPeerMessageReceived] instead.
  /// The callback for receiving peer-to-peer message.
  ///
  /// When receiving peer-to-peer message from other user, you will receive this callback.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [fromUserID] The user ID of the message sender.
  static void Function(
          ZIM zim, List<ZIMMessage> messageList, String fromUserID)?
      onReceivePeerMessage;

  /// Deprecated since ZIM 2.18.0, please use  [onRoomMessageReceived] instead.
  /// The callback for receiving room message.
  ///
  /// This callback will be triggered when new message is received in a room.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [fromRoomID] ID of the room where the message was received.
  static void Function(
          ZIM zim, List<ZIMMessage> messageList, String fromRoomID)?
      onReceiveRoomMessage;

  /// Deprecated since ZIM 2.18.0, please use  [onGroupMessageReceived] instead.
  /// The callback for receiving group message.
  ///
  /// This callback will be triggered when new message is received in a roogroupm.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [fromGroupID] ID of the group where the message was received.
  static void Function(
          ZIM zim, List<ZIMMessage> messageList, String fromGroupID)?
      onReceiveGroupMessage;

  /// The callback for receiving peer-to-peer message.
  ///
  /// When receiving peer-to-peer message from other user, you will receive this callback.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [info] Receive information about the message event.
  /// [fromUserID] The user ID of the message sender.
  static void Function(ZIM zim, List<ZIMMessage> messageList,
      ZIMMessageReceivedInfo info, String fromUserID)? onPeerMessageReceived;

  /// The callback for receiving room message.
  ///
  /// This callback will be triggered when new message is received in a room.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [info] Receive information about the message event.
  /// [fromRoomID] ID of the room where the message was received.
  static void Function(ZIM zim, List<ZIMMessage> messageList,
      ZIMMessageReceivedInfo info, String fromRoomID)? onRoomMessageReceived;

  /// The callback for receiving group message.
  ///
  /// This callback will be triggered when new message is received in a roogroupm.
  ///
  /// [zim] ZIM instance.
  /// [messageList] List of received messages.
  /// [info] Receive information about the message event.
  /// [fromGroupID] ID of the group where the message was received.
  static void Function(ZIM zim, List<ZIMMessage> messageList,
      ZIMMessageReceivedInfo info, String fromGroupID)? onGroupMessageReceived;

  /// Available since: 2.5.0 and above.

  /// Description: When the message receiver confirms that the message has been read, the message sender knows through this callback.

  /// Trigger: Trigger a notification when the message receiver has read the message.

  /// Related APIs: triggered when the peer calls via [ZIM.sendMessageReceiptsRead].
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
      onMessageReceiptChanged;

  /// Available since: 2.5.0  or above.

  /// Description: This callback is received when some one else sends a message and then revoke.

  /// When to call: This callback occurs when a ZIM instance is created with [ZIM.create] and the other user revoke a message.

  /// Related callbacks:You can revoke message to other members via [ZIM.revokeMessage].
  static void Function(ZIM zim, List<ZIMRevokeMessage> messageList)?
      onMessageRevokeReceived;

  /// Supported version: 2.10.0 or later.
  ///
  /// Description: The callback is received when the server interface [SendMessageToAllUsers] sends a message.
  ///
  /// Call time: This callback is received after logging in to the ZIM service and the server call the [SendMessageToAllUsers] interface to send a message.
  static void Function(ZIM zim, ZIMMessage message)? onBroadcastMessageReceived;
/* Room */

  /// Callback when other members join the room.
  ///
  /// Available since: 1.1.0 or above.
  ///
  /// Description: After joining a room, when other members also join this room, they will receive this callback.
  ///
  /// Use cases:When other members in the room join, this callback will be called.
  ///
  /// When to call:  After creating a ZIM instance through [ZIM.create], and the user is in a room joined by other members, you can call this interface.
  ///
  /// Caution: If the user is not currently in this room, this callback will not be called.
  ///
  /// Related APIs: You can use [onRoomMemberLeft] to receive this callback when other room members leave.
  ///
  /// [zim] ZIM instance.
  /// [memberList] List of members who joined the room.
  /// [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
      onRoomMemberJoined;

  /// Callback when other members leave the room.
  ///
  /// Available since: 1.1.0 or above.
  ///
  /// Description: After joining a room, when other members leave the room, they will receive this callback.
  ///
  /// Use cases: When other members in the room leave the room, this callback will be called.
  ///
  /// When to call:  After creating a ZIM instance through [ZIM.create], and the user is in the same room of other members, you can call this interface.
  ///
  /// Caution:If the user is not currently in this room, this callback will not be called.
  ///
  /// Related APIs: You can receive this callback when other room members join through [onRoomMemberJoined].
  ///
  /// [zim] ZIM instance.
  /// [memberList] List of members who left the room.
  /// [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
      onRoomMemberLeft;

  /// event callback when the room connection status changes.
  ///
  /// Available since:  1.1.0 or above.
  ///
  /// Description:event callback when the room connection status changes.
  ///
  /// When to call::After creating a ZIM instance through [ZIM.create], you can call this interface.
  ///
  /// Related APIs:through [onTokenWillExpire], the callback will be received when the token is about to expire.
  ///
  /// [zim] ZIM instance.
  /// [state] The current room connection state after changed.
  /// [event] The event that caused the room connection state to change.
  /// [extendedData] Extra information when the event occurs, a standard JSON string.
  static void Function(ZIM zim, ZIMRoomState state, ZIMRoomEvent event,
      Map extendedData, String roomID)? onRoomStateChanged;

  /// event callback when the room attributes changes.
  ///
  /// Available since:  1.3.0.
  ///
  /// Description:When the room attribute in the room changes, it will be notified through this callback.
  ///
  /// [zim] ZIM instance.
  /// [updateInfo] The info of the room attributes changed.
  /// [roomID] The ID of the room where this event occurred.
  static void Function(
          ZIM zim, ZIMRoomAttributesUpdateInfo updateInfo, String roomID)?
      onRoomAttributesUpdated;

  /// event callback when the room attributes changes.
  ///
  /// Available since:  1.3.0.
  ///
  /// Description:When the room attribute in the room changes, it will be notified through this callback.
  ///
  /// [zim] ZIM instance.
  /// [updateInfo] The infos of the room attributes changed.
  /// [roomID] The ID of the room where this event occurred.
  static void Function(
          ZIM zim, List<ZIMRoomAttributesUpdateInfo> updateInfo, String roomID)?
      onRoomAttributesBatchUpdated;

  /// event callback when room user property update.
  ///
  /// Available since:  2.4.0.
  ///
  /// Description: This callback will be received when a user's property in the room is changed.
  ///
  /// @param zim ZIM instance.
  /// [infos]  The infos of the room member attributes changed.
  /// [operatedInfo] Room operation information.
  /// [roomID] Room ID.
  static void Function(
      ZIM zim,
      List<ZIMRoomMemberAttributesUpdateInfo> infos,
      ZIMRoomOperatedInfo operatedInfo,
      String roomID)? onRoomMemberAttributesUpdated;
/* Group */

  /// Description: callback notification of group status change.
  ///
  /// Use cases: Scenarios that require interaction based on the group status.
  ///
  /// When to call /Trigger: A notification is triggered when a group is created, joined, left, or dismissed.
  ///
  /// Related APIs: [ZIM.createGroup] : creates a group. [ZIM.joinGroup] : joins a group. [ZIM.leaveGroup], leave the group. [ZIM.dismissGroup]; dismiss the group.
  ///
  /// [zim] ZIM instance.
  /// [state] The status of the group after the change.
  /// [event] Group related events.
  /// [operatedInfo] Group information that has been operated.
  /// [groupInfo]  The group info where the group state change occurred.
  static void Function(
      ZIM zim,
      ZIMGroupState state,
      ZIMGroupEvent event,
      ZIMGroupOperatedInfo operatedInfo,
      ZIMGroupFullInfo groupInfo)? onGroupStateChanged;

  /// Description: Group name change notification callback.
  ///
  /// Use cases: If the group name is changed, you need to synchronize the latest group name.
  ///
  /// When to call /Trigger: The group name is changed. Procedure
  ///
  /// Related APIs: [ZIM.updateGroupName] : updates the group name.
  ///
  /// [zim] ZIM instance.
  /// [groupNameChanged] The updated group name.
  /// [operatedInfo] Operation information after the group name is updated.
  /// [groupID] The groupID where the group name update occurred.
  static void Function(ZIM zim, String groupName,
      ZIMGroupOperatedInfo operatedInfo, String groupID)? onGroupNameUpdated;


  /// Description: Group alias change notification callback.
  ///
  /// Use cases: When the group alias is changed, this notification synchronizes the latest group alias to all devices of the user who made the modification.
  ///
  /// When to Trigger: The group alias is changed.
  ///
  /// Related APIs: [updateGroupAlias].
  /// [groupAlias] The updated group alias.
  /// [operatedUserID] The userID of who modifies the group alias.
  /// [groupID] The target group ID.
  static void Function(
          ZIM zim, String groupAlias, String operatedUserID, String groupID)?
      onGroupAliasUpdated;

  /// Description: Group avatar url change notification callback.
  ///
  /// Use cases: If the group avatar url is changed, you need to synchronize the latest group avatar url.
  ///
  /// When to call /Trigger: The group avatar url is changed. Procedure
  ///
  /// Related APIs: [ZIM.updateGroupAvatarUrl] : updates the group avatar url.
  ///
  /// [zim] ZIM instance.
  /// [groupNameChanged] The updated group avatar url.
  /// [operatedInfo] Operation information after the group avatar url is updated.
  /// [groupID] The groupID where the group avatar url update occurred.
  static void Function(
      ZIM zim,
      String groupAvatarUrl,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupAvatarUrlUpdated;

  /// Description: Group bulletin Change notification callback.
  ///
  /// Use cases: If a group bulletin changes, you need to synchronize the latest bulletin content.
  ///
  /// When to call /Trigger: The group bulletin is changed. Procedure
  ///
  /// Related APIs: [ZIM.updateGroupNotice], which updates the group notice.
  ///
  /// [zim] ZIM instance.
  /// [groupNoticeChanged] Updated group announcement.
  /// [operatedInfo] The group announces the updated operation information.
  /// [groupID] The groupID where the group announcement update occurred.
  static void Function(ZIM zim, String groupNotice,
      ZIMGroupOperatedInfo operatedInfo, String groupID)? onGroupNoticeUpdated;

  /// Description: Group attribute change notification callback.
  ///
  /// Use cases: When group attributes are changed, you need to synchronize the latest group attributes.
  ///
  /// When to call /Trigger: Triggered when group properties are set, updated, or deleted.
  ///
  /// Impacts on other APIs:  [ZIM.setGroupAttributes] updates group attributes. [ZIM.deleteGroupAttributes], delete the group attribute.
  ///
  /// [zim] ZIM instance.
  /// [operatedInfo] Operation information after the group attribute is updated.
  /// [updateInfo] Information after group attribute update.
  /// [groupID] The groupID for sending group attribute updates.
  static void Function(
      ZIM zim,
      List<ZIMGroupAttributesUpdateInfo> updateInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupAttributesUpdated;

  /// Description: Group member status change notification callback.
  ///
  /// Use cases: Scenarios that require interaction based on group member states.
  ///
  /// When to call /Trigger: Notification is triggered when a group is created, joined, left, or dismissed, or a user is invited to join or kicked out of the group.
  ///
  /// Related APIs: [ZIM.createGroup] : creates a group. [ZIM.joinGroup] : joins a group. [ZIM.leaveGroup], leave the group. [ZIM.dismissGroup]; dismiss the group. [ZIM.inviteUsersIntoGroup], which invites users to join the group. [ZIM.kickGroupMembers] kicks the user out of the group.
  ///
  /// [zim] ZIM instance.
  /// [state] Updated membership status.
  /// [event] Updated member events.
  /// [userList] Updated member information.
  /// [operatedInfo] Updated operational information.
  /// [groupID] The groupID where the member state change occurred.
  static void Function(
      ZIM zim,
      ZIMGroupMemberState state,
      ZIMGroupMemberEvent event,
      List<ZIMGroupMemberInfo> userList,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupMemberStateChanged;

  /// Description: Return the operation result of changing group member information.
  ///
  /// Use cases: After the basic information of group members is changed, you need to display or interact with group members on the page.
  ///
  /// When to call /Trigger: The result is displayed after the group member information is changed.
  ///
  /// Related APIs: [ZIM.setGroupMemberNickname] : updates the nickname of a group member. [ZIM.setGroupMemberRole] : updates the group member role. [ZIM.transferGroupOwner], group master transfer.
  ///
  /// [zim] ZIM instance.
  /// [operatedInfo] Updated member information.
  /// [userInfo] userInfo.
  /// [groupID] groupID.
  static void Function(
      ZIM zim,
      List<ZIMGroupMemberInfo> userInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupMemberInfoUpdated;

  /// Description: Callback notification for changes in group verification  mode.
  ///
  /// When to trigger: When group verification mode changes.
  ///
  /// Related APIs: [updateGroupJoinMode, updateGroupInviteMode,  updateGroupBeInviteMode], Update the group verification mode.
  static void Function(
      ZIM zim,
      ZIMGroupVerifyInfo verifyInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupVerifyInfoUpdated;

  /// Supported versions: 2.15.0 and above.
  ///
  /// Detail description: This method will be called back when the group application list changes.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [sendGroupJoinApplication], [sendGroupInviteApplications].
  static void Function(ZIM zim, List<ZIMGroupApplicationInfo> applicationList,
          ZIMGroupApplicationListChangeAction action)?
      onGroupApplicationListChanged;

  /// Supported versions: 2.15.0 and above.
  ///
  /// Detail description: This method will be called back when the group application list changes.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [acceptGroupJoinApplication], [rejectGroupJoinApplication], [acceptGroupInviteApplication], [rejectGroupInviteApplication].
  static void Function(ZIM zim, List<ZIMGroupApplicationInfo> applicationList)?
      onGroupApplicationUpdated;

/* Invite */

  /// Supported versions: 2.0.0 and above.
  ///
  /// Detail description: After the inviter initiates a call invitation, the invitee will receive this callback when the invitee is online.
  ///
  /// Business scenario: The invitee will call this callback after the inviter sends a call invitation.
  ///
  /// When to call: After creating a ZIM instance through [ZIM.create].
  ///
  /// Note: If the user is not in the invitation list or not online, this callback will not be called.
  ///
  /// Related interface: [ZIM.callInvite].
  ///
  /// [zim] ZIM instance.
  /// [info] Information about received call invitations.
  /// [callID] Received CallID.
  static void Function(
          ZIM zim, ZIMCallInvitationReceivedInfo info, String callID)?
      onCallInvitationReceived;

  /// Supported versions: 2.0.0 and above.
  ///
  /// Detail description: After the inviter cancels the call invitation, this callback will be received when the invitee is online.
  ///
  /// Business scenario: The invitee will call this callback after the inviter cancels the call invitation.
  ///
  /// When to call: After creating a ZIM instance through [ZIM.create].
  ///
  /// Note: If the user is not in the cancel invitation list or is offline, this callback will not be called.
  ///
  /// Related interface: [ZIM.callCancel].
  ///
  /// [zim] ZIM instance.
  /// [info]  Information about canceled call invitations.
  /// [callID] Cancelled callID.
  static void Function(
          ZIM zim, ZIMCallInvitationCancelledInfo info, String callID)?
      onCallInvitationCancelled;

  /// Deprecated since ZIM 2.9.0, please use  [onCallUserStateChanged] instead.
  /// Supported versions: 2.0.0 and above.
  ///
  /// Detail description: After the invitee accepts the call invitation, this callback will be received when the inviter is online.
  ///
  /// Business scenario: The inviter will receive this callback after the inviter accepts the call invitation.
  ///
  /// When to call: After creating a ZIM instance through [ZIM.create].
  ///
  /// Note: This callback will not be called if the user is not online.
  ///
  /// Related interface: [ZIM.callAccept].
  ///
  /// [zim] ZIM instance.
  /// [info]  Information about the call invitations.
  /// [callID]  callID.
  static void Function(
          ZIM zim, ZIMCallInvitationAcceptedInfo info, String callID)?
      onCallInvitationAccepted;

  /// Deprecated since ZIM 2.9.0, please use  [onCallUserStateChanged] instead.
  /// Available since: 2.0.0 and above.
  ///
  /// Description: This callback will be received when the inviter is online after the inviter rejects the call invitation.
  ///
  /// Use cases: The inviter will receive this callback after the inviter declines the call invitation.
  ///
  /// Default value: After creating a ZIM instance through [ZIM.create] and logging in.
  ///
  /// When to call /Trigger: After creating a ZIM instance through [ZIM.create] and logging in.
  ///
  /// Restrictions: If the user is not the inviter of the call invitation or is not online, the callback will not be received.
  ///
  /// Related APIs:[ZIM.callReject].
  /// [zim] ZIM instance.
  /// [info]  Information about the call invitations.
  /// [callID]  callID.
  static void Function(
          ZIM zim, ZIMCallInvitationRejectedInfo info, String callID)?
      onCallInvitationRejected;

  /// Available since: 2.0.0 and above.
  ///
  /// Description: This callback will be received when the inviter is online after the inviter rejects the call invitation.
  ///
  /// Use cases: The inviter will receive this callback after the inviter declines the call invitation.
  ///
  /// Default value: After creating a ZIM instance through [ZIM.create] and logging in.
  ///
  /// When to call /Trigger: After creating a ZIM instance through [ZIM.create] and logging in.
  ///
  /// Restrictions: If the user is not the inviter of the call invitation or is not online, the callback will not be received.
  ///
  /// Related APIs:[ZIM.callReject].
  ///
  /// [zim] ZIM instance.
  /// [callID]  callID.
  static void Function(
          ZIM zim, ZIMCallInvitationTimeoutInfo info, String callID)?
      onCallInvitationTimeout;

  /// Deprecated since ZIM 2.9.0, please use  [onCallUserStateChanged] instead.
  /// Supported versions: 2.0.0 and above.
  ///
  /// Detail description: When the call invitation times out, the invitee does not respond, and the inviter will receive a callback.
  ///
  /// Business scenario: The invitee does not respond before the timeout period, and the inviter will receive this callback.
  ///
  /// When to call: After creating a ZIM instance through [ZIM.create].
  ///
  /// Note: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  ///
  /// Related interfaces: [ZIM.callInvite], [ZIM.callAccept], [ZIM.callReject].
  ///
  /// [zim] ZIM instance.
  /// [invitees]  Timeout invitee ID.
  /// [callID] callID.
  static void Function(ZIM zim, List<String> invitees, String callID)?
      onCallInviteesAnsweredTimeout;

  /// Supported versions: 2.13.0 and above.
  ///
  /// Detail description: After the caller initiates a call invitation, the caller will receive this callback when the caller is online.
  ///
  /// Business scenario: The caller will call this callback after sends a call invitation.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [callInvite].
  static void Function(
          ZIM zim, ZIMCallInvitationCreatedInfo info, String callID)?
      onCallInvitationCreated;

  /// Supported versions: 2.9.0 and above.
  ///
  /// Detail description: In an advanced call,  a participant ends the call, and all participants will receive this callback.
  ///
  /// Note: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  ///
  /// Related APIs: [ZIM.callEnd]
  /// [zim] ZIM instance.
  /// [callID] Timeout invitee ID.
  /// [info] Information carried by the event callback.
  static void Function(
      ZIM zim,
      ZIMCallInvitationEndedInfo callInvitationEndedInfo,
      String callID)? onCallInvitationEnded;

  /// Supported versions: 2.9.0 and above.
  ///
  /// Detail description: Listen for calling user status changes.
  ///
  /// When to call: After the call invitation is initiated, the calling member accepts, rejects, or exits, or the response times out, the current calling inviting member receives this callback.
  ///
  /// Note: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  ///
  /// Related APIs: [ZIM.callInvite], [ZIM.callingInvite], [ZIM.callAccept], [ZIM.callReject],[ZIM.callQuit].
  ///
  /// [zim] ZIM instance.
  /// [callUserStateChangeInfo] Information about the status change of a call member.
  /// [callID] Unique identifier of the call.
  static void Function(
      ZIM zim,
      ZIMCallUserStateChangeInfo callUserStateChangeInfo,
      String callID)? onCallUserStateChanged;

  /// Supported version: 2.10.0 or later.
  ///
  /// Description: The callback is received when reactions change
  ///
  /// When to Call: This callback can be registered after the ZIM instance is created by [create] and before login.
  ///
  /// When to Trigger: After other users add or delete reactions to messages in private or group chats.
  ///
  /// Related APIs: [ZIM.addMessageReaction]、[ZIM.deleteMessageReaction]
  static void Function(ZIM zim, List<ZIMMessageReaction> infos)?
      onMessageReactionsChanged;

  ///
  /// Supported versions: 2.13.0 and above.
  ///
  /// Detail description: his method will be called back when changes occur in the blacklist.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [addUsersToBlacklist].
  static void Function(
          ZIM zim, List<ZIMUserInfo> userList, ZIMBlacklistChangeAction action)?
      onBlacklistChanged;

  ///
  /// Description: Callback notification for changes in group mute information.
  ///
  /// Use cases: To know the details of changes when group mute information changes.
  ///
  /// When to trigger: When group mute information changes.
  ///
  /// Related APIs: [muteGroup], Group Mute.
  static void Function(
      ZIM zim,
      ZIMGroupMuteInfo groupMuteInfo,
      ZIMGroupOperatedInfo operatedInfo,
      String groupID)? onGroupMutedInfoUpdated;

  /// Supported versions: 2.14.0 and above.
  ///
  /// Detail description: This callback will be triggered when there is an update in the friend information.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [updateFriendAlias] [updateFriendAttributes]
  static void Function(ZIM zim, List<ZIMFriendInfo> friendInfoList)?
      onFriendInfoUpdated;

  ///
  /// Supported versions: 2.14.0 and above.
  ///
  /// Detail description: his method will be called back when changes occur in the friend list.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [addFriend].
  static void Function(ZIM zim, List<ZIMFriendInfo> friendInfoList,
      ZIMFriendListChangeAction action)? onFriendListChanged;

  /// Supported versions: 2.14.0 and above.
  ///
  /// Detail description: The current method will be called when there is an update in the friend request list.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [acceptFriendApplication] [rejectFriendApplication]
  static void Function(
          ZIM zim, List<ZIMFriendApplicationInfo> friendApplicationInfoList)?
      onFriendApplicationUpdated;

  ///
  /// Supported versions: 2.14.0 and above.
  ///
  /// Detail description: This method will be called back when the friend application list changes.
  ///
  /// When to call: After creating a ZIM instance through [create].
  ///
  /// Related APIs: [sendFriendApplication].
  static void Function(
          ZIM zim,
          List<ZIMFriendApplicationInfo> friendApplicationInfoList,
          ZIMFriendApplicationListChangeAction action)?
      onFriendApplicationListChanged;
}
