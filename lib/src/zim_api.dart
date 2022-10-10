import 'internal/zim_manager.dart';
import 'zim_defines.dart';

abstract class ZIM {
  /// Get the SDK's instance
  ///
  /// When you need to call [getInstance] to get ZIM instance, Please call [create] first. Otherwise, this API will return null.
  static ZIM? getInstance() {
    return ZIMManager.getInstance();
  }

  /// Gets the SDK's version number.
  ///
  /// When the SDK is running, the developer finds that it does not match the expected situation and submits the problem and related logs to the ZEGO technical staff for locating. The ZEGO technical staff may need the information of the engine version to assist in locating the problem.
  /// Developers can also collect this information as the version information of the engine used by the app, so that the SDK corresponding to each version of the app on the line.
  ///
  /// Available since: 2.1.5.
  ///
  /// Description: Get the SDK version.
  ///
  /// Use cases:
  /// 1. When the SDK is running, the developer finds that it does not match the expected situation and submits the problem and related logs to the ZEGO technical staff for locating. The ZEGO technical staff may need the information of the engine version to assist in locating the problem.
  /// 2. Developers can also collect this information as the version information of the engine used by the app, so that the SDK corresponding to each version of the app on the line.
  ///
  /// When to call : It can be called at any time.
  ///
  /// @return SDK version.
  static Future<String> getVersion() async {
    return await ZIMManager.getVersion();
  }

  /// Set log related configuration.
  ///
  /// [config] Log configuration object.
  static setLogConfig(ZIMLogConfig config) {
    ZIMManager.setLogConfig(config);
  }

  /// Set cache related configuration.
  ///
  /// [config] Log configuration object.

  /// Supported version: 2.1.5 and above.
  ///
  /// Detailed description: Example Set the SDK cache file path. Because the SDK has a default path, it is generally not recommended that you set your own path unless there is a strong need to do so.
  ///
  /// Default value:Android：/storage/Android/data/packageName/files/ZIMCaches
  /// iOS：~/Library/Caches/ZIMCaches
  /// macOS：（sandbox）~/Library/Containers/[Bundle ID]/Data/Library/Caches/ZIMCaches / ~/Library/Caches/ZIMCaches
  /// Windows：C:\Users\[Your UserName]\AppData\[App Name]ZEGO.SDK\ZIMCaches
  ///
  /// Call timing: It must be called before [create].
  ///
  /// Note: If the developer calls after [create], the SDK saves the configuration until it takes effect the next time [Create] is invoked.
  ///
  /// Related callbacks: In addition to getting the login result in the callback parameter, the developer will also receive the [onConnectionStateChanged] callback during the login request and after the login is successful/failed to determine the current user's login status.
  ///
  /// Life cycle: Set before calling [create] and takes effect when calling [create]. If the developer does not set the new logging configuration the next time [create] is created, the previous configuration will still take effect.
  ///
  /// Platform difference: The default path varies with platforms. Please refer to the default value.
  ///
  /// [config] Cache configuration object.
  static setCacheConfig(ZIMCacheConfig config) {
    ZIMManager.setCacheConfig(config);
  }
//MARK: - Main

  /// Create a ZIM instance.
  ///
  /// You need to create and initialize an ZIM instance before calling any other function.
  /// The SDK supports the creation of multiple ZIM instances.
  ///
  /// [ZIMAppConfig] appID and appSign issued by ZEGO for developers, Please apply at the ZEGO console.
  static ZIM? create(ZIMAppConfig config) {
    return ZIMManager.createEngine(config);
  }

  /// Destroy the ZIM instance.
  ///
  /// Used to release resources used by ZIM.
  destroy();

  /// Login, you must log in before using all functions.
  /// [userInfo] Unique ID used to identify the user. Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur.
  /// [token] The token issued by the developer's business server, used to ensure security. The generation rules are detailed in ZEGO document website.
  Future<void> login(ZIMUserInfo userInfo, [String? token]);

  /// Log out of ZIM service.
  logout();

  /// Upload log and call after setting up log path.
  ///
  /// Description: After calling [create] to create an instance, the log report can be called.
  Future<void> uploadLog();

  /// Update the authentication token.
  ///
  /// [token] The token issued by the developer's business server, used to ensure security. The generation rules are detailed in ZEGO document website.
  Future<ZIMTokenRenewedResult> renewToken(String token);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: Through this interface, you can query and obtain the corresponding UserInfo by userID.
  ///
  /// When to call /Trigger: It is available only after calling [create] to create the instance and then calling [login] to login.
  ///
  /// [userIDs] userID list.
  /// [config] query config.
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDs, ZIMUserInfoQueryConfig config);

  /// Available since: 2.2.0 and above.
  ///
  /// Description: Through this interface, you can update your user name.
  ///
  /// When to call /Trigger: It is available only after calling [create] to create the instance and then calling [login] to login.
  ///
  /// [userName] the user name you want to update.
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName);

  /// Available since: 2.3.0 and above.
  ///
  /// Description: Through this interface, you can update your user avatar url.
  ///
  /// When to call /Trigger: It is available only after calling [create] to create the instance and then calling [login] to login.
  ///
  /// [userAvatarUrl] the user avatar url you want to update.
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
      String userAvatarUrl);

  /// Available since: 2.2.0 and above.
  ///
  /// Description: Through this interface, you can update your user extended data.
  ///
  /// When to call /Trigger: It is available only after calling [create] to create the instance and then calling [login] to login.
  ///
  /// [extendedData] the user extended data you want to update.
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
      String extendedData);

//MARK: - Conversation

  /// Available since: 2.1.5 and above.

  /// Description: This method displays the session list of the logged in user.

  /// Use cases: This interface can be invoked to get the data source when you need to display an existing message session after logging in.
  ///
  /// When to call /Trigger: Can be invoked after login.
  ///
  /// Restrictions:There is no limit to the frequency of use, available after login, unavailable after logout.
  ///
  /// Caution: NextConversation is the riveting point of the query message, which can be null for the first query. In subsequent query, the earliest conversation can be used as nextConversation to query earlier sessions. In paging query, Count in [ZIMConversationQueryConfig] fill each pull the number of sessions.
  ///
  /// Related APIs: [deleteConversation] Deletes the session. [clearConversationUnreadMessageCount] clear session readings.
  ///
  /// [config] Configuration for session queries.
  Future<ZIMConversationListQueriedResult> queryConversationList(
      ZIMConversationQueryConfig config);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: This interface is invoked when a session needs to be deleted. All members in the session can invoke this interface.
  ///
  /// Use cases: You can invoke this interface implementation to delete an entire session when it is no longer needed.
  ///
  /// When to call /Trigger: his parameter is invoked when a session needs to be deleted and can be invoked after a ZIM instance is created. The call takes effect after login and becomes invalid after logout.
  ///
  /// [conversationID] conversationID.
  /// [conversationType] conversationtype.
  /// [config] delete the session's configuration.
  Future<ZIMConversationDeletedResult> deleteConversation(String conversationID,
      ZIMConversationType conversationType, ZIMConversationDeleteConfig config);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: Used to clear unread for the current user target session.
  ///
  /// Use cases: This interface is called when a chat page is entered from a session and the original message readings of the session need to be cleared.
  ///
  /// When to call /Trigger: Called when a target needs to be cleared without readings.
  ///
  /// Restrictions: Valid after login, invalid after logout.
  ///
  /// Impacts on other APIs: Calling this method will trigger a total readings not updated callback [onConversationTotalUnreadMessageCountUpdated], would trigger a session to update callbacks [onConversationChanged].
  ///
  /// Related callbacks:[ZIMConversationUnreadMessageCountClearedResult].
  ///
  /// Related APIs:[conversationTotalUnreadMessageCountUpdated]、[conversationChanged].
  ///
  /// [conversationID] conversationID.
  /// [conversationType] conversation type.
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
          String conversationID, ZIMConversationType conversationType);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: This method enables DND by selecting whether the unread of the target session is updated when a message is received.
  ///
  /// Use cases: If the user selects MESSAGE DO not Disturb (DND), the user can call the corresponding method.
  ///
  /// Default value: Message DND is disabled by default.
  ///
  /// When to call /Trigger: If the target session exists after login, invoke this interface if you want to enable the DND status of the target session.
  ///
  /// Restrictions:  Valid after login, invalid after logout.
  ///
  /// Impacts on other APIs: After the DND state is enabled, receiving messages is not triggered [conversationTotalUnreadMessageCountUpdated].
  ///
  /// Related callbacks: [ZIMConversationNotificationStatusSetCallback].
  ///
  /// Related APIs: [conversationTotalUnreadMessageCountUpdated].
  ///
  /// [status] the session notification state.
  /// [conversationID]  conversationID.
  /// [conversationType] conversation type.
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
          ZIMConversationNotificationStatus status,
          String conversationID,
          ZIMConversationType conversationType);

  Future<ZIMMessageSentResult> sendMessage(
      ZIMMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      [ZIMMessageSendNotification? notification]);


  Future<ZIMMessageInsertedResult> insertMessageToLocalDB(
      ZIMMessage message,
      String conversationID,
      ZIMConversationType conversationType,
      String senderUserID);
//MARK: -Message

  /// Available since: 2.1.5 and above.

  /// Description: After this function is called, a message is sent to the specified user. At the same time, a [ZIMMessageSentCallback] callback is received, which can be used to determine whether the message is sent successfully.

  /// Use cases: This function is used in 1V1 chat scenarios.

  /// Call timing/Notification timing: Can be invoked after login.

  /// Caution: Be aware of the [ZIMMessageSentCallback] callback when sending. This callback can be used to determine if the send fails for some reason.Pushconfig Is required only when the offline push function is required.

  /// Usage limit: no more than 10 /s, available after login, unavailable after logout.

  /// Scope of influence: Using this method triggers the [receivePeerMessage] callback of the message receiver and the [onConversationChanged] callback of the sender and receiver. If message DND is not set for the session where the message is sent, Triggers [conversationTotalUnreadMessageCountUpdated] callback.

  /// Related callbacks:[ZIMMessageSentCallback]、[receivePeerMessage]、[onConversationChanged]、[conversationTotalUnreadMessageCountUpdated]。

  /// Related API: [queryHistoryMessage]、[deleteMessageByConversationID]、[deleteMessage]
  ///
  /// [message] The message to be sent.
  /// [toUserID] The ID of the user who will receive the message.
  /// [config] Related configuration for sending single chat messages.
  Future<ZIMMessageSentResult> sendPeerMessage(
      ZIMMessage message, String toUserID, ZIMMessageSendConfig config);

  /// Supported versions: 2.1.5 and above.

  /// Detail description: This interface is called when a group chat message needs to be sent.

  /// Business scenario: This interface can be used when sending group messages.

  /// Call timing/Notification timing: This interface is called when a group chat message needs to be sent.

  /// Usage limit: 10 times/s, available after login, unavailable after logout.

  /// Note: pushconfig only needs to be filled in when you need to use the offline push function. The properties in ZIMMessage are read-only and do not need to be modified.

  /// Scope of influence: Using this method will trigger the receivePeerMessage callback of the message receiver, and will trigger the onConversationChanged callback of the sender and receiver. If the session where the message is located does not have message DND set, the conversationTotalUnreadMessageCountUpdated callback will be triggered.

  /// Related callbacks: [ZIMMessageSentCallback], [receiveGroupMessage], [onConversationChanged], [conversationTotalUnreadMessageCountUpdated].

  /// Related interfaces: [queryHistoryMessage], [deleteMessageByConversationID], [deleteMessage]
  ///
  /// [message] The message to be sent.
  /// [toGroupID] The ID of the user who will receive the message.
  /// [config] Related configuration for sending single chat messages.
  Future<ZIMMessageSentResult> sendGroupMessage(
      ZIMMessage message, String toGroupID, ZIMMessageSendConfig config);

  /// Send room messages.
  ///
  /// Available since: 2.1.5 or above
  ///
  /// Description: When this function is called, the message will be sent in the room. At the same time, the [ZIMMessageSentCallback] callback will be received, which can be used to determine whether the message was sent successfully.
  ///
  /// Use Cases: This feature is required for scenarios where multiple people in the room are chatting.
  ///
  /// [message] The message to be sent.
  /// [toRoomID] The ID of the room which will receive the message.
  /// [config] Related configuration for sending room messages.
  Future<ZIMMessageSentResult> sendRoomMessage(
      ZIMMessage message, String toRoomID, ZIMMessageSendConfig config);

  /// Send media messages.
  /// Supported versions: 2.1.5 and above.
  ///
  /// Detailed description: This method can be used to send messages in single chat, room and group chat.
  ///
  /// Business scenario: When you need to send media to the target user, target message room, and target group chat after logging in, send it through this interface.
  ///
  /// Call timing/Notification timing: It can be called after login.
  ///
  /// Usage limit: no more than 10/s, available after login, unavailable after logout.
  ///
  /// Impact: [onReceivePeerMessage]/[ReceiveGroupMessage] sessions and session-scoped [onReceiveGroupMessage] sessions did not fire message receiver's [ConversationR] fires [onversationTotalUnreadMessageCountUpdated] objection.
  ///
  /// Note: Only required if you need to use the threaded update feature when pushing configuration. Push notifications are not supported, nor are [onContationChanged] and [ConTotalUnreadMessageCountUpdated] supported if media messages are broadcast to the world.
  ///
  /// Related: [ZIMMessageSentCallback], [ZIMMediaUploadingProgress], [onReceivePeMessage], [onReceiveRoomMessage], [onReceiveGroupMessage], [onConversationChanged], [onConversationTotalUnreadMessageCountUpdated].
  ///
  /// Related interfaces: [queryHistoryMessage], [deleteAllMessage], [deleteMessages]
  ///
  /// [message] The message to be sent.
  /// [toConversationID] The ID of the conversation which will receive the message.
  /// [conversationType] The type of the conversation which will receive the message.
  /// [config] Related configuration for sending single chat messages.
  /// [progress] Callback of the progress.
  Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaMessageSendNotification? notification);

  /// Download media message content.
  ///
  /// Supported versions: 2.1.5 and above.
  ///
  /// Detailed description: This method can be used to download the content of media messages, including the original image, large image, thumbnail image, file message, audio message, video message and the first frame of the image message.
  ///
  /// Service scenario: After the user receives a message, if the message is a media message, he can call this API to download its content.
  ///
  /// Invoke timing/notification timing: can be invoked after logging in and receiving a media message.
  ///
  /// [message] The message to be received.
  /// [fileType] Media file type
  /// [progress] Callback of the progress.
  Future<ZIMMediaDownloadedResult> downloadMediaFile(ZIMMediaMessage message,
      ZIMMediaFileType fileType, ZIMMediaDownloadingProgress? progress);

  /// Supported versions: 2.1.5 and above.

  /// Detailed description: This method is used to query historical messages.

  /// Business scenario: When you need to obtain past historical messages, you can call this interface to query historical messages by paging.

  /// Call timing/Notification timing: Called when historical messages need to be queried.

  /// Restrictions: Effective after login, invalid after logout.

  ///
  /// [conversationID] The session ID of the queried historical message.
  /// [conversationType] The type of the queried historical message.
  /// [config]  Query the configuration of historical messages.
  Future<ZIMMessageQueriedResult> queryHistoryMessage(String conversationID,
      ZIMConversationType conversationType, ZIMMessageQueryConfig config);

  /// Supported versions: 2.1.5 and above.
  ///
  /// Detail description: When you need to delete all messages under the target session, call this method.
  ///
  /// Business scenario: If you want to implement a group setting page to clear the chat information under the current session, you can call this interface.
  ///
  /// Call timing/Notify timing: The target session exists and the user is a member of this session.
  ///
  /// Restrictions: Effective after login, invalid after logout.
  ///
  /// Note: The impact of deleting messages is limited to this account, and messages from other accounts will not be deleted.
  ///
  /// Scope of influence: The [conversationChanged] callback is triggered, and if there are unread messages, the [conversationTotalUnreadMessageCountUpdated] callback is triggered.
  ///
  /// Related callback: [ZIMMessageDeletedCallback].
  ///
  /// [conversationID] The session ID of the message to be deleted.
  /// [conversationType]  conversation type.
  /// [config] delete session configuration.
  Future<ZIMMessageDeletedResult> deleteAllMessage(String conversationID,
      ZIMConversationType conversationType, ZIMMessageDeleteConfig config);

  /// Supported versions: 2.1.5 and above.

  /// Detail description: This method implements the function of deleting messages.

  /// Business scenario: The user needs to delete a message. When the user does not need to display a message, this method can be used to delete it.

  /// Call timing/Notification timing: Called when the message needs to be deleted.

  /// Note: The impact of deleting messages is limited to this account.

  /// Restrictions: Effective after login, invalid after logout.

  /// Scope of influence: If the deleted message is the latest message of the session, the [conversationChanged] callback will be triggered, and if the message is unread, the [conversationTotalUnreadMessageCountUpdated] callback will be triggered.
  ///
  /// [messageList] List of deleted messages.
  /// [conversationID] conversation ID.
  /// [conversationType] conversation type.
  /// [config]  Delete the configuration of the message.
  Future<ZIMMessageDeletedResult> deleteMessages(
      List<ZIMMessage> messageList,
      String conversationID,
      ZIMConversationType conversationType,
      ZIMMessageDeleteConfig config);

//MARK: - Room

  /// Create a room.
  ///
  /// Available since: 2.1.5 or above.
  ///
  /// Description: When a room is created, other users can join this room through [joinRoom] function.
  ///
  /// Use cases: When you need to create a multi-person chat scene, you can create a room by this API.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Caution: When everyone leaves the room, the room will be automatically destroyed.
  ///
  /// Related callbacks: The result of the room creation can be obtained through the [ZIMRoomCreatedCallback] callback.
  ///
  /// Related APIs: You can join the room through [joinRoom] and leave the room with [leaveRoom].
  ///
  /// [roomInfo] The configuration information of the room to be created.
  /// [config] The advanced information of the room to be created.
  Future<ZIMRoomCreatedResult> createRoom(ZIMRoomInfo roomInfo,
      [ZIMRoomAdvancedConfig? config]);

  /// Join a room.
  ///
  /// Available since: 2.1.5 or above.
  ///
  /// Description: If the room does not exist, the join fails and you need to call [createRoom] to create the room first.
  ///
  /// Use cases: In a multi-person chat scenario, users can call this interface to enter the room when they need to join the room.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Caution: When everyone leaves the room, the room will be automatically destroyed.
  ///
  /// Related callbacks: The result of joining the room can be obtained through the [ZIMRoomJoinedCallback] callback.
  ///
  /// Related APIs: You can create a room with [createRoom] and leave the room with [leaveRoom].
  ///
  /// [roomID] ID of the room to join.
  Future<ZIMRoomJoinedResult> joinRoom(String roomID);

  /// Supported version: 2.1.5.

  /// Detail description: After calling this API, ZIM will decide whether to create a room or join a room according to whether the user is the first to enter. At the same time, if the first user to enter has room advanced attributes, those attributes will take effect.

  /// Business scenario: When you need to enter a multi-person chat scene with custom attributes, and you do not need to distinguish whether the room is created or added, you can enter a room through this interface.

  /// When to call: It can be called after logging in.

  /// Note: When everyone leaves the room, the room will be automatically destroyed, and a user can be in a maximum of 5 rooms at the same time. [enterRoom] is equivalent to [createRoom] or [joinRoom], so you only need to choose one of the APIs.

  /// Related callbacks: The result of entering the room can be obtained through the [onRoomEntered] callback.

  /// Related interface: You can enter the room through [enterRoom], and leave the room through [leaveRoom].
  Future<ZIMRoomEnteredResult> enterRoom(
      ZIMRoomInfo roomInfo, ZIMRoomAdvancedConfig config);

  /// Leave a room.
  ///
  /// Available since: 2.1.5 or above.
  ///
  /// Description: When users in the room need to leave the room, they can join this room through [leaveRoom].
  ///
  /// Use cases: In the multi-person chat scenario, when users in the room need to leave the room, they can leave the room through this interface.
  ///
  /// When to call: After creating a ZIM instance via [create], it can be called when the user is in the room.
  ///
  /// Caution: If the current user is not in this room, the exit fails. When everyone leaves the room, the room will be automatically destroyed.
  ///
  /// Related callbacks: The result of leaving the room can be obtained through the [ZIMRoomLeftCallback] callback.
  ///
  /// Related APIs: You can create a room through [createRoom] and join a room with [joinRoom].
  ///
  /// [roomID] ID of the room to leave.
  Future<ZIMRoomLeftResult> leaveRoom(String roomID);

  /// Query the list of members in the room.
  ///
  /// Available since: 2.1.5 or above.
  ///
  /// Description: After joining a room, you can use this function to get the list of members in the room.
  ///
  /// Use cases: When a developer needs to obtain a list of room members for other business operations, this interface can be called to obtain a list of members.
  ///
  /// When to call: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, you can call this interface.
  ///
  /// Caution: If the user is not currently in this room, the query fails.
  ///
  /// Related callbacks: Through the [ZIMRoomMemberQueriedCallback] callback, you can get the result of querying the room member list.
  ///
  /// Related APIs: You can check the online number of people in the room through [queryRoomOnlineMemberCount].
  ///
  /// [roomID] ID of the room to query.
  /// [config] Configuration of query room member operation.
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
      String roomID, ZIMRoomMemberQueryConfig config);

  /// Query the number of online members in the room.
  ///
  /// Available since: 2.1.5 or above.
  ///
  /// Description: After joining a room, you can use this function to get the number of online members in the room.
  ///
  /// Use cases: When a developer needs to obtain the number of room members who are online, this interface can be called.
  ///
  /// Calling time: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, this interface can be called.
  ///
  /// Caution: If the user is not currently in this room, the query will fail.
  ///
  /// Related APIs: the room member can be inquired through [queryRoomMember].
  ///
  ///[roomID] ID of the room to query.
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
      String roomID);

  /// Set room attributes (use this for all additions and changes).
  ///
  /// Available since: 2.1.5.
  ///
  /// Description: Used to set room properties.
  ///
  /// [roomAttributes] room attributes will be set.
  /// [roomID] ID of the room to set.
  /// [config] config of the room to set.
  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
      Map<String, String> roomAttributes,
      String roomID,
      ZIMRoomAttributesSetConfig config);

  /// Delete room attributes.
  ///
  /// Available since: 2.1.5.
  ///
  /// Description: Used to delete room attributes.
  ///
  /// [keys] room attributes keys will be deleted.
  /// [roomID] ID of the room to deleted.
  /// [config] config of the room to deleted.
  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
      List<String> keys, String roomID, ZIMRoomAttributesDeleteConfig config);

  /// Open combination room attribute operation.
  ///
  /// Available since: 2.1.5.
  ///
  /// Description: Used to turn on the combination of room attributes.
  ///
  /// [roomID] ID of the room to operation.
  /// [config] config of the room to turn on the combination of room attributes.
  void beginRoomAttributesBatchOperation(
      String roomID, ZIMRoomAttributesBatchOperationConfig config);

  /// Complete the property operation of the combined room.
  ///
  /// Available since: 2.1.5.
  ///
  /// Description: After completing the operation of combining room attributes,
  /// all the setting/deleting operations from the last call to beginRoomAttributesBatchOperation
  /// to this operation will be completed for the room.
  ///
  /// [roomID] ID of the room to operation.
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
      String roomID);

  /// Query all properties of the room.
  ///
  /// Available since: 2.1.5.
  ///
  /// Used to query room attributes.
  ///
  /// [roomID] ID of the room to queried.
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(String roomID);

  Future<ZIMRoomMembersAttributesOperatedResult> setRoomMembersAttributes(
      Map<String, String> attributes,
      List<String> userIDs,
      String roomID,
      ZIMRoomMemberAttributesSetConfig config);

  Future<ZIMRoomMembersAttributesQueriedResult> queryRoomMembersAttributes(
      List<String> userIDs, String roomID);

  Future<ZIMRoomMemberAttributesListQueriedResult>
      queryRoomMemberAttributesList(
          String roomID, ZIMRoomMemberAttributesQueryConfig config);
//MARK: - Group

  /// Available since: 2.1.5 and above.
  ///
  /// Description: You can call this interface to create a group, and the person who calls this interface is the group leader. An empty string if the group name is left blank.
  ///
  /// Use cases: You can use this interface to create a chat scenario and join a group.
  ///
  /// When to call: After you create a ZIM instance with [create] and login with [login].
  ///
  /// Restrictions: Available after login, unavailable after logout. UserIDs support a maximum of 100 users and a group supports a maximum of 500 users.
  ///
  /// Impacts on other APIs: You can use [joinGroup] to join a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  ///
  /// [groupInfo] Configuration information for the group to be created.
  /// [userIDs] List of users invited to the group.
  /// [config]  Create the relevant configuration of the group.
  Future<ZIMGroupCreatedResult> createGroup(
      ZIMGroupInfo groupInfo, List<String> userIDs,
      [ZIMGroupAdvancedConfig? config]);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: When a group is created, you can use [dismissGroup] to dismiss it.
  ///
  /// Use cases: After you create a chat group, you do not need to use this interface to dissolve the group.
  ///
  /// When to call /Trigger: This parameter can be called after a group is created by using [createGroup].
  ///
  /// Caution: A non-group owner cannot dissolve a group.
  ///
  /// Impacts on other APIs: Through callback can get [ZIMGroupDismissedCallback] dissolution results of the room, through [onGroupStateChanged] listen callback can get the room status.
  ///
  /// Related callbacks: You can use [createGroup] to create a group, [joinGroup] to join a group, and [leaveGroup] to leave a group.
  ///
  /// [groupID] The ID of the group to be disbanded.
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, other users can use [joinGroup] to join the group.
  ///
  /// Use cases: This interface is used to join a group in a chat scenario.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Caution: Available after login, unavailable after logout. If you have joined a group, the join succeeds. A group is limited to 500 people and fails to join when it is full.
  ///
  /// Related callbacks: To get the result of joining the room, call [ZIMGroupJoinedCallback].
  ///
  /// Related APIs: You can use [createGroup] to create a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  /// [groupID] The group ID to join.
  Future<ZIMGroupJoinedResult> joinGroup(String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a user joins a group, the user can leave the group through this interface.
  ///
  /// Use cases: This interface is used to exit a chat group.
  ///
  /// When to call /Trigger: It can be invoked after a ZIM instance is created through [create] and logged in.
  ///
  /// Restrictions: Available after login, unavailable after logout.
  ///
  /// Caution: When the group owner quits the group, the identity of the group owner will be automatically transferred to the earliest member who joined the group. When all members exit the group, the group is automatically dissolved.
  ///
  /// Impacts on other APIs: You can use [createGroup] to create a group, [joinGroup] to join a group, or [dismissGroup] to dismiss a group.
  ///
  /// [groupID] The group ID to leave.
  Future<ZIMGroupLeftResult> leaveGroup(String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, users can add multiple users to the group through this interface. The interface can be invoked by both the master and members of the group.
  ///
  /// Use cases: This interface allows you to invite others to join a group chat.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: The maximum number of userIDs users can join the group is 100. If the number of users reaches 100, the interface callback will notify the user. The maximum number of people in a group is 500.
  ///
  /// Caution: This interface does not require the peer's consent or the peer's online status. The service layer determines the number of invited users.
  ///
  /// Related callbacks: Through the callback [ZIMGroupUserInvitedCallback] can add multiple users into the group's results.
  ///
  /// Related APIs: KickGroupMember can be used to kick a target user out of the group.
  /// [groupID] The ID of the group that will invite users to the group.
  /// [userIDs] List of invited users.
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
      List<String> userIDs, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a user joins a group, you can use this method to remove the user from the group.
  ///
  /// Use cases: You can use this method to remove one or more users from the group.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: You can't kick someone unless you're the leader of the group.
  ///
  /// Caution: This interface does not require the peer's consent or the peer's online status. It cannot accept group-related callbacks after being kicked out. History messages and sessions remain after being kicked out and can still enter the group.
  ///
  /// Related callbacks: Through the callback [ZIMGroupMemberKickedCallback] can get the user kicked out the results of the group.
  ///
  /// Related APIs: You can invite a target user into a group through [inviteUsersIntoGroup].
  ///
  /// [groupID] The group ID of the member who will be kicked out.
  /// [userIDs] List of users who have been kicked out of the group.
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
      List<String> userIDs, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, the group owner can use this method to assign the group owner to a specified user.
  ///
  /// Use cases: In a group chat scenario, you can transfer the group master through this interface.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: You cannot transfer a group owner if you are not a group owner.
  ///
  /// Related APIs: Through the callback [ZIMGroupOwnerTransferredCallback] can get the result of the transfer of the group manager.
  /// [toUserID] The converted group owner ID.
  /// [groupID] The group ID of the group owner to be replaced.
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
      String toUserID, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, users can call this method to change the group name.
  ///
  /// Use cases: After creating a group, you need to change the group name.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Group members and group owners can change the group name. The maximum length of the name is 100 bytes.
  ///
  /// Related APIs: Through the callback [ZIMGroupNameUpdatedResult] can get the result of the change of name, through [onGroupNoticeUpdated] can get update group name information.
  ///
  /// [groupName] The updated group name.
  /// [groupID] The group ID whose group name will be updated.
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
      String groupName, String groupID);

  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: When a group is created, users can use this method to update the group bulletin.
  ///
  /// Use cases: You need to update the group bulletin in the group.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Only group members can update the group bulletin. The maximum number of bytes is 300. There is no special character limit.
  ///
  /// [groupID] The group ID of the group announcement that will be updated.
  /// [groupNotice] Pre-updated group announcements.
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
      String groupNotice, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: Query information about a created group.
  ///
  /// Use cases: You need to obtain group information for display.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Related callbacks: Through the callback [ZIMGroupInfoQueriedCallback] can query the result of the group information.
  ///
  /// [groupID] The group ID of the group information to be queried.
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: If a group already exists, all users of the group can use this method to set group properties.
  ///
  /// Use cases: Added extended field information about group description, such as group family, label, and industry category.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Only group members can set group properties.
  ///
  /// Related callbacks: Through the callback [ZIMGroupAttributesOperatedCallback] can get the result of the set of properties.
  ///
  /// Related APIs: [deleteGroupAttributes] can be used to deleteGroupAttributes, [queryGroupAttributes] can be used to queryGroupAttributes, [queryAllGroupAttributes] can be used to queryAllGroupAttributes.
  ///
  /// [groupAttributes] group properties.
  /// [groupID] groupID.
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
      Map<String, String> groupAttributes, String groupID);

  /// Available since: 2.0.0 and above.
  ///
  /// Description: When a group already exists, you can use this method to delete group attributes. Both the master and members of the interface group can be invoked.
  ///
  /// Use cases: Deleted the extended field of the group description.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Only group members can delete group attributes.
  ///
  /// Related callbacks: Through the callback [ZIMGroupAttributesOperatedCallback] can delete the result of the group of attributes.
  ///
  /// Related APIs: You can use [setGroupAttributes] to setGroupAttributes, [queryGroupAttributes] to queryGroupAttributes, and [queryAllGroupAttributes] to queryAllGroupAttributes.
  ///
  /// [groupID]  The group ID of the group attribute to be deleted.
  /// [keys] The key of the group attribute to delete.
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
      List<String> keys, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to query the specified group properties.
  ///
  /// Use cases: You need to query the scenarios to display the specified group attributes.
  ///
  /// When to call /Trigger: After creating a ZIM instance with [create] and logging in with [login].
  ///
  /// Restrictions: Available after login, unavailable after logout.
  ///
  /// Related APIs: [queryAllGroupAttributes] Queries all group attributes.
  ///
  ///  [keys] The key of the group attribute to be queried.
  ///  [groupID] The group ID of the group attribute to be queried.
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
      List<String> keys, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to query all group attributes.
  ///
  /// Use cases: Scenarios where all group attributes need to be queried.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Related callbacks: Through callback can get query [ZIMGroupAttributesQuriedCallback] all the results of the group of attributes.
  ///
  /// Related APIs: [queryGroupAttributes] Queries the attributes of the specified group.
  ///
  /// [groupID] The group ID of all group attributes to be queried.
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
      String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to set the roles of group members.
  ///
  /// Use cases: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// When to call /Trigger: If the primary role of a group is 1 and the default role of other members is 3, you can invoke this interface to change the role.
  ///
  /// Caution: Non-group master unavailable.
  ///
  ///
  /// [role] Set of group roles.
  /// [forUserID] User ID for which group role is set.
  /// [groupID] The group ID of the group role to be set.
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
      int role, String forUserID, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to set nicknames for group members.
  ///
  /// Use cases: Nicknames need to be set for group members.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Available after login, unavailable after logout. The owner of a group can change his or her own nickname, while the members can change only their own nickname.
  ///
  /// Caution: A group name can contain a maximum of 100 characters.
  ///
  /// [nickname]  Set member nickname.
  /// [forUserID] User ID for which group nickname is set.
  /// [groupID] The group ID of the group member's nickname is set.
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
      String nickname, String forUserID, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to query information about a specified group member.
  ///
  /// Use cases: You need to obtain the specified group member information for display or interaction.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Available after login, unavailable after logout.
  ///
  ///
  /// [userID] User ID of the queried member information.
  /// [groupID] The ID of the group whose member information will be queried.
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
      String userID, String groupID);

  /// Available since: 2.1.5 and above.
  ///
  /// Description: Query the list of all groups.
  ///
  /// Use cases: You need to get a list of groups to display.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Available after login, unavailable after logout.
  ///
  Future<ZIMGroupListQueriedResult> queryGroupList();

  /// Available since: 2.1.5 and above.
  ///
  /// Description: After a group is created, you can use this method to query the group member list.
  ///
  /// Use cases: You need to obtain the specified group member list for display or interaction.
  ///
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// Restrictions: Available after login, unavailable after logout.
  ///
  /// [groupID] The group ID of the group member list to be queried.
  /// [config] Group member query configuration.
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
      String groupID, ZIMGroupMemberQueryConfig config);

  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
      String groupID);

//MARK: - CallInvite

  /// Supported versions: 2.1.5 and above.
  ///
  /// Detail description: When the caller initiates a call invitation, the called party can use [callAccept] to accept the call invitation or [callReject] to reject the invitation.
  ///
  /// Business scenario: When you need to initiate a call invitation, you can create a unique callid through this interface to maintain this call invitation.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Note: The call invitation has a timeout period, and the call invitation will end when the timeout period expires.
  ///
  /// [invitees] list of invitees.
  /// [config] Call Invitation Related Configuration.
  Future<ZIMCallInvitationSentResult> callInvite(
      List<String> invitees, ZIMCallInviteConfig config);

  /// Supported versions: 2.1.5 and above.
  ///
  /// Detail description: After the caller initiates a call invitation, the call invitation can be canceled through this interface before the timeout period.
  ///
  /// Business scenario: When you need to cancel the call invitation initiated before, you can cancel the call invitation through this interface.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Note: Canceling the call invitation after the timeout period of the call invitation expires will fail.
  ///
  /// [invitees] List of invitees.
  /// [callID] callID.
  /// [config] Cancel the related configuration of call invitation.
  Future<ZIMCallCancelSentResult> callCancel(
      List<String> invitees, String callID, ZIMCallCancelConfig config);

  /// Supported versions: 2.1.5 and above.
  ///
  /// Detail description: When the calling party initiates a call invitation, the called party can accept the call invitation through this interface.
  ///
  /// Service scenario: When you need to accept the call invitation initiated earlier, you can accept the call invitation through this interface.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Note: The callee will fail to accept an uninvited callid.
  ///
  /// [callID] The call invitation ID to accept.
  /// [config]  config.
  Future<ZIMCallAcceptanceSentResult> callAccept(
      String callID, ZIMCallAcceptConfig config);

  /// Supported versions: 2.1.5 and above.
  ///
  /// Detail description: When the calling party initiates a call invitation, the called party can reject the call invitation through this interface.
  ///
  /// Service scenario: When you need to reject the call invitation initiated earlier, you can use this interface to reject the call invitation.
  ///
  /// When to call: It can be called after creating a ZIM instance through [create].
  ///
  /// Note: The callee will fail to reject the uninvited callid.
  ///
  /// [callID] The ID of the call invitation to be rejected.
  /// [config] Related configuration for rejecting call invitations.
  Future<ZIMCallRejectionSentResult> callReject(
      String callID, ZIMCallRejectConfig config);
}
