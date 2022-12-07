import 'dart:typed_data';

/// Connection state.
///
/// Description: The state machine that identifies the current connection state.
///
/// Use cases: It can be used to determine whether the login/logout is successful, and to handle abnormal situations such as network disconnection.
///
/// Caution: Please use it with the connection event parameter.
enum ZIMConnectionState {
  /// Description: Unconnected state, enter this state before logging in and after logging out.
  ///
  /// Use cases: If there is a steady state abnormality in the process of logging in, such as AppID or Token are incorrect, or if the same user name is logged in elsewhere and the local end is kicked out, it will enter this state.
  disconnected,

  /// Description: The state that the connection is being requested. It will enter this state after successful execution login function.
  ///
  /// Use cases: The display of the UI is usually performed using this state. If the connection is interrupted due to poor network quality, the SDK will perform an internal retry and will return to this state.
  connecting,

  /// Description: The state that is successfully connected.
  ///
  /// Use cases: Entering this state indicates that login successfully and the user can use the SDK functions normally.
  connected,

  ///
  /// Description: The state that the reconnection is being requested. It will enter this state after successful execution login function.
  ///
  /// Use cases: The display of the UI is usually performed using this state. If the connection is interrupted due to poor network quality, the SDK will perform an internal retry and will return to this state.
  reconnecting
}

/// Connection state.
///
/// Description: The state machine that identifies the current connection state.
///
/// Use cases: It can be used to judge whether the user enters/exit the room successfully, and handles abnormal situations such as network disconnection.
///
/// Caution: Please use it with the connection event parameter.
enum ZIMRoomState {
  /// Description: Disconnected state.
  ///
  /// Use cases: enter this state before entering the room and after exiting the room.
  disconnected,

  /// Description: The connection state is being requested.
  ///
  /// Use cases: and it will enter this state after the action of entering the room is executed successfully. The application interface is usually displayed through this state.
  connecting,

  /// Description: The connection is successful.
  ///
  /// Use cases: Entering this state means that the room has been successfully entered, and the user can use the room's functions normally.
  connected
}

/// Connection state.
///
/// Description: The state machine that identifies the current connection state.
///
/// Use cases: It can be used to judge whether the user enters/exit the room successfully, and handles abnormal situations such as network disconnection.
///
/// Caution: Please use it with the connection event parameter.
enum ZIMConnectionEvent {
  /// Description: Success.
  success,

  /// Description: The user actively logs in.
  activeLogin,

  /// Description: Connection timed out.
  loginTimeout,

  /// Description: The network connection is temporarily interrupted.
  interrupted,

  /// Description: Being kicked out.
  kickedOut
}

/// The event that caused the room connection status to change.
///
/// Description: The reason for the change of the connection state.
///
/// Use cases: It can be used to determine whether the login/logout is successful, and to handle abnormal situations such as network disconnection.
///
/// Caution: Please use it with the connection state parameter.
enum ZIMRoomEvent {
  /// Description: Success.
  success,

  /// Description: The network in the room is temporarily interrupted.
  interrupted,

  /// Description: The network in the room is disconnected.
  disconnected,

  /// Description: The room not exist.
  roomNotExist,

  /// Description: The user actively creates a room.
  activeCreate,

  /// Description: Failed to create room.
  createFailed,

  /// Description: The user starts to enter the room.
  activeEnter,

  /// Description: user failed to enter the room.
  enterFailed,

  /// Description: user was kicked out of the room.
  kickedOut,

  connectTimeout
}

/// The priority of the message.
///
/// Description: Identifies the priority of a message.
///
/// Use cases: It can be used to set the priority when a message is sent. The higher the priority, the higher the reliability. Low priority may be discarded due to weak network.
///
/// Caution: The higher the priority, the higher the cost.
enum ZIMMessagePriority {
  /// Description: Low priority.
  ///
  /// Use cases: Generally used to send unimportant messages such as barrage message in a room.
  low,

  /// Description: Medium priority.
  ///
  /// Use cases: Generally used to send regular chat messages.
  medium,

  /// Description: High priority.
  ///
  /// Use cases: Generally used to send important information such as gifts and rewards in a room.
  high
}

/// The type of the message.
///
/// Description: Identifies the type of current message.
///
/// Use cases: It can be used to determine what type of message this message is.
///
enum ZIMMessageType {
  /// Description: Unknown message.
  ///
  /// Use cases: A message of an unknown type is received, indicating that the sender may have sent a message type that the user does not support, and the user needs to be advised to update the version.
  unknown,

  /// Description: Normal text message.
  ///
  /// Use cases: Can be used to deliver ordinary text messages.
  text,

  /// Description: Custom binary message.
  ///
  /// Use cases: Can be used to transfer custom binary messages. This message type does not support offline messages and local storage.
  command,

  /// Description: Barrage message.
  ///
  /// Use cases: Can be used for the barrage sent by the live room. This message type does not support offline messages and local storage.
  barrage,

  /// Description: Image message.
  ///
  /// Use cases: Can be used to send image messages, only ".jpg", ".jpeg", ".png", ".bmp", ".gif", ".tiff" image types are supported. After sending the image, the server will generate a large image and a thumbnail of the original image.
  image,

  /// Description: File message.
  ///
  /// Use cases: For sending file messages, no file type restrictions.
  file,

  /// Description: Audio message.
  ///
  /// Use cases: For sending audio messages, only ".mp3" audio type is supported.
  audio,

  /// Description: Video message.
  ///
  /// Use cases: For sending video messages, only ".mp4", ".mov" video types are supported. After sending the video message, the server will generate the first frame of the video file.
  video,

  system,

  revoke
}

enum ZIMMediaFileType {
  /// Original file type, suitable for original images, audio files, and video files. After calling [downloadMediaFile], the SDK will update the fileLocalPath property in [ZIMMediaMessage].
  originalFile,

  /// Large image type. After calling [downloadMediaFile], the SDK will update the largeImageLocalPath property in [ZIMImageMessage].
  largeImage,

  /// Image thumbnail type. After calling [downloadMediaFile], the SDK will update the thumbnailLocalPath property in [ZIMImageMessage].
  thumbnail,

  /// The type of the first frame of the video. After calling [downloadMediaFile], the SDK will update the videoFirstFrameLocalPath property in [ZIMVideoMessage].
  videoFirstFrame
}

enum ZIMRevokeType {
  unknown,
  twoWay,
  oneWay,
}

enum ZIMMessageRevokeStatus {
  unknown,
  selfRevoke,
  systemRevoke,
  serviceAPIRevoke,
  groupAdminRevoke,
  groupOwnerRevoke,
}

/// Room attributes update action.
///
/// Description: Room attributes update action.
enum ZIMRoomAttributesUpdateAction {
  /// Set action.
  set,

  /// Delete action.
  delete
}

/// the direction of the message.
///
/// Description: Describes whether the current message was sent or received.
enum ZIMMessageDirection {
  /// Message has been sent.
  send,

  /// Message accepted.
  receive
}

/// The status of the message being sent.
///
/// Description: Describes the condition of the currently sent message.
enum ZIMMessageSentStatus {
  /// The message is being sent.
  sending,

  /// Message sent successfully.
  success,

  /// Message sending failed.
  failed
}

/// conversation type.
enum ZIMConversationType { peer, room, group }

enum ZIMConversationEvent { added, updated, disabled }

enum ZIMConversationNotificationStatus { notify, doNotDisturb }

/// Description: Group events.
enum ZIMGroupEvent {
  /// Create groups.
  created,

  /// Disband the group.
  dismissed,

  /// Join the group.
  joined,

  /// Invite to the group.
  invited,

  /// Leave the group.
  left,

  /// Kick out of the group.
  kickedout
}

enum ZIMGroupState {
  /// Quit
  quit,

  /// Enter
  enter
}

enum ZIMGroupMemberEvent { joined, left, kickedout, invited }

enum ZIMGroupMemberState { quit, enter }

enum ZIMGroupAttributesUpdateAction { set, delete }

enum ZIMGroupMessageNotificationStatus { notify, doNotDisturb }

enum ZIMMessageReceiptStatus { none, processing, done, expired, failed }

enum ZIMCallUserState {
  inviting,
  accepted,
  rejected,
  cancelled,
  offline,
  received
}

class ZIMGroupMemberRole {
  static const int owner = 1;
  static const int member = 3;
}
// Model

/// Error infomation
///
/// Description: Error infomation.
class ZIMError {
  /// The storage path of the log files. Refer to the official website document for the default path.
  int code = 0;

  /// Error infomation description.
  String message = '';
  ZIMError({required this.code, required this.message});
}

/// Log configuration
///
/// Description: Configure the storage path of log files and the maximum log file size.
class ZIMLogConfig {
  /// The storage path of the log files. Refer to the official website document for the default path.
  String logPath = '';

  /// The maximum log file size (Bytes). The default maximum size is 5MB (5 * 1024 * 1024 Bytes)
  int logSize = 0;

  int? logLevel = 0;
  ZIMLogConfig();
}

class ZIMCacheConfig {
  String cachePath = '';
  ZIMCacheConfig();
}

class ZIMAppConfig {
  int appID = 0;
  String appSign = '';
  ZIMAppConfig();
}

class ZIMUserInfoQueryConfig {
  bool isQueryFromServer = false;
  ZIMUserInfoQueryConfig();
}

/// Description:Offline push configuration.
class ZIMPushConfig {
  /// Description: Used to set the push title.
  String title = '';

  /// Description: Used to set offline push content.
  String content = '';

  /// Description: This parameter is used to set the pass-through field of offline push.
  String payload = '';

  String resourcesID = '';

  ZIMPushConfig();
}

/// Details: Configure message sending.
class ZIMMessageSendConfig {
  /// Description: Configures the offline push function.
  ZIMPushConfig? pushConfig;

  /// Enumeration value used to set message priority. The default value is Low.
  ZIMMessagePriority priority = ZIMMessagePriority.low;

  bool hasReceipt = false;

  ZIMMessageSendConfig();
}

class ZIMGroupMessageReceiptMemberQueryConfig {
  int nextFlag = 0;
  int count = 0;

  ZIMGroupMessageReceiptMemberQueryConfig();
}

class ZIMMessageRevokeConfig {
  String? revokeExtendedData;
  ZIMPushConfig? pushConfig;
}

class ZIMMessageSendNotification {
  ZIMMessageAttachedCallback? onMessageAttached;
  ZIMMessageSendNotification({this.onMessageAttached});
}

class ZIMMediaMessageSendNotification {
  ZIMMessageAttachedCallback? onMessageAttached;
  ZIMMediaUploadingProgress? onMediaUploadingProgress;
  ZIMMediaMessageSendNotification(
      {this.onMessageAttached, this.onMediaUploadingProgress});
}

/// User information object.
///
/// Description: Identifies a unique user.
///
/// Caution: Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur.
/// It is strongly recommended that userID corresponds to the user ID of the business APP,
/// that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID.
/// Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
class ZIMUserInfo {
  /// User ID, a string with a maximum length of 32 bytes or less. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
  String userID = '';

  /// User name, a string with a maximum length of 64 bytes or less.
  String userName = '';
  ZIMUserInfo();
}

class ZIMUserFullInfo {
  ZIMUserInfo baseInfo = ZIMUserInfo();
  String userAvatarUrl = '';
  String extendedData = '';
  ZIMUserFullInfo();
}

class ZIMMessage {
  ZIMMessageType type = ZIMMessageType.unknown;
  int messageID = 0;
  int localMessageID = 0;
  String senderUserID = "";
  String conversationID = "";
  ZIMMessageDirection direction = ZIMMessageDirection.send;
  ZIMMessageSentStatus sentStatus = ZIMMessageSentStatus.sending;
  ZIMConversationType conversationType = ZIMConversationType.peer;
  int timestamp = 0;
  int conversationSeq = 0;
  int orderKey = 0;
  bool isUserInserted = false;
  ZIMMessageReceiptStatus receiptStatus = ZIMMessageReceiptStatus.none;
}

class ZIMTextMessage extends ZIMMessage {
  String message = '';

  ZIMTextMessage({required this.message}) {
    super.type = ZIMMessageType.text;
  }
}

class ZIMCommandMessage extends ZIMMessage {
  Uint8List message;

  ZIMCommandMessage({
    required this.message,
  }) {
    super.type = ZIMMessageType.command;
  }
}

class ZIMBarrageMessage extends ZIMMessage {
  String message = "";
  ZIMBarrageMessage({required this.message}) {
    super.type = ZIMMessageType.barrage;
  }
}

class ZIMMediaMessage extends ZIMMessage {
  String fileLocalPath;
  String fileDownloadUrl = '';
  String fileUID = '';
  String fileName = '';
  int fileSize = 0;
  ZIMMediaMessage({required this.fileLocalPath});

}

class ZIMRevokeMessage extends ZIMMessage {
  ZIMRevokeType revokeType = ZIMRevokeType.unknown;
  ZIMMessageRevokeStatus revokeStatus = ZIMMessageRevokeStatus.unknown;
  int revokeTimestamp = 0;
  String operatedUserID = "";
  String revokeExtendedData = "";
  ZIMMessageType originalMessageType = ZIMMessageType.unknown;
  String originalTextMessageContent = "";

  ZIMRevokeMessage() {
    super.type = ZIMMessageType.revoke;
  }
}

typedef ZIMMediaUploadingProgress = void Function(
    ZIMMessage message, int currentFileSize, int totalFileSize);

typedef ZIMMediaDownloadingProgress = void Function(
    ZIMMessage message, int currentFileSize, int totalFileSize);

typedef ZIMMessageAttachedCallback = void Function(ZIMMessage message);

class ZIMImageMessage extends ZIMMediaMessage {
  String thumbnailDownloadUrl = '';
  String thumbnailLocalPath = '';
  String largeImageDownloadUrl = '';
  String largeImageLocalPath = '';
  int originalImageWidth = 0;
  int originalImageHeight = 0;
  int largeImageWidth = 0;
  int largeImageHeight = 0;
  int thumbnailWidth = 0;
  int thumbnailHeight = 0;
  ZIMImageMessage(String fileLocalPath) : super(fileLocalPath: fileLocalPath) {
    super.type = ZIMMessageType.image;
  }
}

class ZIMFileMessage extends ZIMMediaMessage {
  ZIMFileMessage(String fileLocalPath) : super(fileLocalPath: fileLocalPath) {
    super.type = ZIMMessageType.file;
  }
}

class ZIMAudioMessage extends ZIMMediaMessage {
  int audioDuration = 0;

  ZIMAudioMessage(String fileLocalPath) : super(fileLocalPath: fileLocalPath) {
    super.type = ZIMMessageType.audio;
  }
}

class ZIMVideoMessage extends ZIMMediaMessage {
  int videoDuration = 0;
  String videoFirstFrameDownloadUrl = '';
  String videoFirstFrameLocalPath = '';
  int videoFirstFrameWidth = 0;
  int videoFirstFrameHeight = 0;
  ZIMVideoMessage(String fileLocalPath) : super(fileLocalPath: fileLocalPath) {
    super.type = ZIMMessageType.video;
  }
}

class ZIMSystemMessage extends ZIMMessage {
  String message = '';
  ZIMSystemMessage({required this.message}) {
    super.type = ZIMMessageType.system;
  }
}

class ZIMConversation {
  String conversationID = '';
  String conversationName = '';
  String conversationAvatarUrl = '';
  ZIMConversationType type = ZIMConversationType.peer;
  ZIMConversationNotificationStatus notificationStatus =
      ZIMConversationNotificationStatus.notify;
  int unreadMessageCount = 0;
  ZIMMessage? lastMessage;
  int orderKey = 0;
  ZIMConversation();
}

class ZIMConversationQueryConfig {
  ZIMConversation? nextConversation;
  int count = 0;
  ZIMConversationQueryConfig();
}

class ZIMConversationDeleteConfig {
  bool isAlsoDeleteServerConversation = false;
  ZIMConversationDeleteConfig();
}

class ZIMConversationChangeInfo {
  ZIMConversationEvent event = ZIMConversationEvent.added;
  ZIMConversation? conversation;
  ZIMConversationChangeInfo();
}

class ZIMRoomInfo {
  String roomID = '';
  String roomName = '';
  ZIMRoomInfo();
}

class ZIMRoomFullInfo {
  ZIMRoomInfo baseInfo;
  ZIMRoomFullInfo({required this.baseInfo});
}

class ZIMRoomMemberAttributesSetConfig {
  bool isDeleteAfterOwnerLeft = true;
}

class ZIMRoomMemberAttributesQueryConfig {
  String nextFlag = '';
  int count = 0;
}

class ZIMRoomMemberAttributesInfo {
  String userID = '';
  Map<String, String> attributes = {};
}

class ZIMRoomMemberAttributesUpdateInfo {
  ZIMRoomMemberAttributesInfo attributesInfo = ZIMRoomMemberAttributesInfo();
}

class ZIMRoomMemberAttributesOperatedInfo {
  ZIMRoomMemberAttributesInfo attributesInfo = ZIMRoomMemberAttributesInfo();
  List<String> errorKeys = [];
}

class ZIMRoomOperatedInfo {
  String userID = '';
}

/// Example Query message configuration.
class ZIMMessageQueryConfig {
  /// Description: Query the anchor point of the message.
  /// Required: This parameter is not required for the first query but is required for subsequent paging queries.
  /// Default value: The default value is nil.
  ZIMMessage? nextMessage;

  /// Description: Number of query messages. The default value is 0.
  int count = 0;

  /// Description: Indicates whether the query is in reverse order. The default value is NO.
  bool reverse = false;
  ZIMMessageQueryConfig();
}

/// Delete message configuration.
class ZIMMessageDeleteConfig {
  /// Description: Whether to remove flags for server messages. The default value is YES.
  bool isAlsoDeleteServerMessage = false;
  ZIMMessageDeleteConfig();
}

/// Configuration for querying member.
///
/// Description: When querying member, you need to configure this object.
class ZIMRoomMemberQueryConfig {
  /// Description: The flag of the paging query. For the first query, set this field to an empty string. If the "nextFlag" field of the callback is not an empty string, it needs to be set here to continue the query on the next page.
  String nextFlag = "";

  /// Description: How many messages are retrieved in one query.
  ///
  /// Caution: To obtain messages in pages to reduce overhead, it is recommended to obtain within 100 messages at a time.
  int count = 0;
  ZIMRoomMemberQueryConfig();
}

/// Room advanced config.
class ZIMRoomAdvancedConfig {
  /// Description: Room attributes of a room.
  Map<String, String> roomAttributes = {};
  int roomDestroyDelayTime = 0;
  ZIMRoomAdvancedConfig();
}

/// The behavior attribute set by the room attribute.
class ZIMRoomAttributesSetConfig {
  /// Description: Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  bool isForce = false;

  /// Description: Room attributes are automatically deleted after the owner leaves the room.
  bool isDeleteAfterOwnerLeft = false;

  /// Description: Whether to update the owner of the room attribute involved.
  bool isUpdateOwner = false;
  ZIMRoomAttributesSetConfig();
}

/// The behavior attribute set by the room attribute.
class ZIMRoomAttributesBatchOperationConfig {
  /// Description: Whether the operation is mandatory, that is, the property of the room whose owner is another user can be modified.
  bool isForce = false;

  /// Description: Room attributes are automatically deleted after the owner leaves the room.
  bool isDeleteAfterOwnerLeft = false;

  /// Description: Whether to update the owner of the room attribute involved.
  bool isUpdateOwner = false;
  ZIMRoomAttributesBatchOperationConfig();
}

class ZIMRoomAttributesDeleteConfig {
  /// Description: Whether the operation is mandatory, that is, the property of the room whose owner is another user can be deleted.
  bool isForce = false;
  ZIMRoomAttributesDeleteConfig();
}

/// Notice of Room Attribute Change.
class ZIMRoomAttributesUpdateInfo {
  /// Description: Behavioral information of room attribute change notification.
  ZIMRoomAttributesUpdateAction action;

  /// Description:  Room attributes.
  Map<String, String> roomAttributes;
  ZIMRoomAttributesUpdateInfo(
      {required this.action, required this.roomAttributes});
}

/// When userInfo is queried, the failed userInfo is displayed through this data class.
class ZIMErrorUserInfo {
  /// Description:userID.
  String userID = "";

  /// Description: Description Reason for the query failure.
  int reason = 0;
  ZIMErrorUserInfo();
}

/// group information.
class ZIMGroupInfo {
  /// Description: groupID.
  String groupID = "";

  /// Description: Group name.
  String groupName = "";

  /// Description: Group avatar url.
  String groupAvatarUrl = "";
  ZIMGroupInfo();
}

/// Description: complete group information.
class ZIMGroupFullInfo {
  /// Description: basic group information.
  ZIMGroupInfo baseInfo;

  /// Description: basic group notice.
  String groupNotice = "";

  /// Description: where developers can customize key-value.
  Map<String, String> groupAttributes = {};

  /// Description: group DND status.
  ZIMGroupMessageNotificationStatus notificationStatus =
      ZIMGroupMessageNotificationStatus.notify;

  ZIMGroupFullInfo({required this.baseInfo});
}

/// Description:  group class.
class ZIMGroup {
  /// Description: basic group information.
  ZIMGroupInfo? baseInfo;

  /// Description: group DND status.
  ZIMGroupMessageNotificationStatus notificationStatus =
      ZIMGroupMessageNotificationStatus.notify;
  ZIMGroup();
}

/// Group member information.
class ZIMGroupMemberInfo extends ZIMUserInfo {
  /// Description: Group nickname.
  String memberNickname = "";

  /// Description: group role.
  int memberRole = ZIMGroupMemberRole.member;

  /// Description: group member avatar url.
  String memberAvatarUrl = "";
  ZIMGroupMemberInfo();
}

/// Information that the group has operated on.
class ZIMGroupOperatedInfo {
  /// Description: Group member information.
  /// @Deprecated
  ZIMGroupMemberInfo operatedUserInfo;

  String userID = '';
  String userName = '';
  String memberNickname = '';
  int memberRole = ZIMGroupMemberRole.member;

  ZIMGroupOperatedInfo(
      {required this.operatedUserInfo,
      required this.userID,
      required this.userName,
      required this.memberNickname,
      required this.memberRole});
}

/// group member query configuration.
class ZIMGroupMemberQueryConfig {
  /// Description: count.
  int count = 0;

  /// Description: nextFlag.
  int nextFlag = 0;
  ZIMGroupMemberQueryConfig();
}

/// Group advanced configuration.
class ZIMGroupAdvancedConfig {
  String groupNotice = "";
  Map<String, String>? groupAttributes;
  ZIMGroupAdvancedConfig();
}

/// Group attribute update information.
class ZIMGroupAttributesUpdateInfo {
  /// Description: Group attribute update action.
  ZIMGroupAttributesUpdateAction action = ZIMGroupAttributesUpdateAction.set;

  /// Description: group properties.
  Map<String, String>? groupAttributes;
  ZIMGroupAttributesUpdateInfo();
}

/// Call invitation user information.
class ZIMCallUserInfo {
  /// Description:  userID.
  String userID = "";

  /// Description:  user status.
  ZIMCallUserState state = ZIMCallUserState.accepted;
  ZIMCallUserInfo();
}

/// The behavior property of the Send Call Invitation setting.
class ZIMCallInviteConfig {
  /// Description: The timeout setting of the call invitation, the unit is seconds. The default value is 90s.
  int timeout = 0;

  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";

  ZIMPushConfig? pushConfig;

  ZIMCallInviteConfig();
}

/// Behavior property that cancels the call invitation setting.
class ZIMCallCancelConfig {
  /// Description: Extended field.
  String extendedData = "";
  ZIMCallCancelConfig();
}

/// Behavior property that accept the call invitation setting.
class ZIMCallAcceptConfig {
  /// Description: Extended field.
  String extendedData = "";
  ZIMCallAcceptConfig();
}

/// The behavior property of the reject call invitation setting.
class ZIMCallRejectConfig {
  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";
  ZIMCallRejectConfig();
}

/// Call invitation sent message.
class ZIMCallInvitationSentInfo {
  /// Description: The timeout setting of the call invitation, the unit is seconds.
  int timeout = 0;

  /// Description: User id that has not received a call invitation.
  List<ZIMCallUserInfo> errorInvitees = [];
  ZIMCallInvitationSentInfo();
}

/// Information to accept the call invitation.
class ZIMCallInvitationReceivedInfo {
  /// Description: The timeout setting of the call invitation, the unit is seconds.
  int timeout = 0;

  /// Description: Inviter ID.
  String inviter = "";

  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";
  ZIMCallInvitationReceivedInfo();
}

/// Cancel the call invitation message.
class ZIMCallInvitationCancelledInfo {
  /// Description:  The inviter ID of the call invitation.
  String inviter = "";

  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";
  ZIMCallInvitationCancelledInfo();
}

/// Accept the call invitation message.
class ZIMCallInvitationAcceptedInfo {
  /// Description: Invitee ID.
  String invitee = "";

  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";
  ZIMCallInvitationAcceptedInfo();
}

/// Reject the call invitation message.
class ZIMCallInvitationRejectedInfo {
  /// Description: Invitee ID.
  String invitee = "";

  /// Description: Extended field, through which the inviter can carry information to the invitee.
  String extendedData = "";
  ZIMCallInvitationRejectedInfo();
}

class ZIMCallInvitationTimeoutInfo {
  String inviter = "";
  ZIMCallInvitationTimeoutInfo();
}

class ZIMMessageReceiptInfo {
  String conversationID;
  ZIMConversationType conversationType;
  int messageID;
  ZIMMessageReceiptStatus status;
  int readMemberCount;
  int unreadMemberCount;

  ZIMMessageReceiptInfo(
      {required this.conversationID,
      required this.conversationType,
      required this.messageID,
      required this.status,
      required this.readMemberCount,
      required this.unreadMemberCount});
}

//MARK : Result

/// Callback of the result of renewing the token.
///
/// [token] The renewed token.
class ZIMTokenRenewedResult {
  String token;
  ZIMTokenRenewedResult({required this.token});
}

/// Supported version: 2.0.0 and above.
///
/// Detailed description: Callback after developer queries user information.
///
/// Use cases: The developer can check whether the login succeeded by using [errorCode] in this callback.
///
/// Notification timing: This callback is triggered when a developer invokes the [queryUserInfo] interface.
///
/// Related interface: Run the queryUserInfo command to query information.
///
/// [userList]  List of the userInfo queried.
/// [errorUserList] Failed to query the userInfo list.
class ZIMUsersInfoQueriedResult {
  List<ZIMUserFullInfo> userList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMUsersInfoQueriedResult(
      {required this.userList, required this.errorUserList});
}

class ZIMUserNameUpdatedResult {
  String userName;
  ZIMUserNameUpdatedResult({required this.userName});
}

class ZIMUserAvatarUrlUpdatedResult {
  String userAvatarUrl;
  ZIMUserAvatarUrlUpdatedResult({required this.userAvatarUrl});
}

class ZIMUserExtendedDataUpdatedResult {
  String extendedData;
  ZIMUserExtendedDataUpdatedResult({required this.extendedData});
}

/// Available since: 2.0.0 and above.
///
/// Description: After the session list is queried, the callback is used to return the query result.
///
/// Use cases: The logic after the session list query can be done in this callback.
///
/// When to call /Trigger: Description Triggered when the session list is queried.
///
/// Related APIs: [queryConversationList].
///
/// [conversationList] Session list.
class ZIMConversationListQueriedResult {
  List<ZIMConversation> conversationList;

  ZIMConversationListQueriedResult({required this.conversationList});
}

/// Available since: 2.0.0 and above.
///
/// Description: After a session is deleted, the deletion result is returned using this callback.
///
/// Use cases: You can do the deleted session logic in this callback.
///
/// When to call /Trigger: Description Triggered after the session was deleted.
///
/// Related APIs: [deleteConversation].
///
/// [conversationID] Conversation ID.
/// [conversationType] Conversation type.
class ZIMConversationDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationDeletedResult(
      {required this.conversationID, required this.conversationType});
}

/// Available since: 2.0.0 and above.
///
/// Description: This callback returns the result of clearing a session if the session is not read.
///
/// Use cases: You can do clear unread logic in this callback.
///
/// When to call /Trigger: Triggered after clearing session unread.
///
/// Related APIs: [clearConversationUnreadMessageCount].
///
/// [conversationID]  Conversation ID.
/// [conversationType] Conversation type.
class ZIMConversationUnreadMessageCountClearedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationUnreadMessageCountClearedResult(
      {required this.conversationID, required this.conversationType});
}

/// Available since: 2.0.0 and above.
///
/// Description: This callback returns the result of group notification after the group notification status is set.
///
/// Use cases: You can do the logic after setting the group notification status in this callback.
///
/// When to call /Trigger: Triggered when the group notification status is set.
///
/// Related APIs: [setConversationNotificationStatus].
///
/// [conversationID] conversationID.
/// [conversationType] Conversation type.
class ZIMConversationNotificationStatusSetResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationNotificationStatusSetResult(
      {required this.conversationID, required this.conversationType});
}

/// Callback of the result of sending the message.
///
/// Available since: 1.1.0 or above.
///
/// Description: This callback is triggered when the developer calls the [sendPeerMessage] and [sendRoomMessage] interfaces. The developer can check whether the callback is sent successfully by [errorCode] in the callback.
///
/// [message] The sent message object, from which parameters such as messageID can be obtained. If the sending fails, the messageID parameter in the message will be an empty string.
class ZIMMessageSentResult {
  ZIMMessage message;
  ZIMMessageSentResult({required this.message});
}

class ZIMMessageInsertedResult {
  ZIMMessage message;
  ZIMMessageInsertedResult({required this.message});
}

/// Supported versions: 2.1.0 and above.
///
/// Detail description: The progress callback for downloading media messages.
///
/// Business scenario: The developer can obtain the download progress of the media message through this callback.
///
/// Notification timing: When the developer calls the [downloadMediaFile] interface, this callback will be triggered, and will be triggered multiple times during the download process.
///
/// Related APIs: Through [downloadMediaFile], the download progress will be notified through this callback.
class ZIMMediaDownloadedResult {
  ZIMMessage message;
  ZIMMediaDownloadedResult({required this.message});
}

/// The developer uses this callback to get a list of queried messages, which can be used to display historical messages.
///
/// [messageList] The message list of the query result.
class ZIMMessageQueriedResult {
  String conversationID;
  ZIMConversationType conversationType;
  List<ZIMMessage> messageList;
  ZIMMessageQueriedResult(
      {required this.conversationID,
      required this.conversationType,
      required this.messageList});
}

/// Supported versions: 2.0.0 and above.
///
/// Detail description: After the message is deleted, the result of message deletion is returned through this callback.
///
/// Business scenario: The developer can judge whether the deletion is successful through the [errorCode] in the callback.
///
/// Notification timing: Triggered after calling the delete message interface [deleteMessage].
///
/// Related interface: [deleteMessage].
///
/// [conversationID] Conversation ID.
/// [conversationType] Conversation Type.
class ZIMMessageDeletedResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMMessageDeletedResult(
      {required this.conversationID, required this.conversationType});
}

/// Callback of the result of creating the room.
///
/// Available since: 1.1.0 or above.
///
/// Description: The callback of the result of creating the room.
///
/// Related APIs: Create a room through [createRoom], and the result of the creation will be notified through this callback.
///
/// [roomInfo] Details of the room created. If the creation fails, the roomID parameter in roomInfo will be an empty string.
class ZIMRoomCreatedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMRoomCreatedResult({required this.roomInfo});
}

/// Callback of the result of entering the room.
///
/// Available since: 2.1.0 or above.
///
/// Description: The callback of the result of entering the room.
///
/// Related APIs: Join the room through [enterRoom], and the result of joining will be notified through this callback.
///
/// [roomInfo] Details of the room joined. If the join fails, the roomID parameter in roomInfo will be an empty string.
class ZIMRoomEnteredResult {
  ZIMRoomFullInfo roomInfo;
  ZIMRoomEnteredResult({required this.roomInfo});
}

/// Callback of the result of joining the room.
///
/// Available since: 1.1.0 or above.
///
/// Description: The callback of the result of joining the room.
///
/// Related APIs: Join the room through [joinRoom], and the result of joining will be notified through this callback.
///
/// [roomInfo] Details of the room joined. If the join fails, the roomID parameter in roomInfo will be an empty string.
class ZIMRoomJoinedResult {
  ZIMRoomFullInfo roomInfo;
  ZIMRoomJoinedResult({required this.roomInfo});
}

/// Callback of the result of leaving the room.
///
/// Available since: 1.1.0 or above.
///
/// Description: The callback of the result of leaving the room.
///
/// Related APIs: Leave the room through [leaveRoom], and the result of leaving will be notified through this callback.
class ZIMRoomLeftResult {
  String roomID;
  ZIMRoomLeftResult({required this.roomID});
}

/// Callback of the result of querying the room members list.
///
/// Available since: 1.1.0 or above.
///
/// Description: Callback for the result of querying the room member list.
///
/// Related APIs: Query the list of room members through [queryRoomMember], and the query result will be notified through this callback.
///
/// [memberList] List of members in the room.
/// [nextFlag] The flag of the paging query. If this field is an empty string, the query has been completed. Otherwise, you need to set this value to the "nextFlag" field of ZIMRoomMemberQueryConfig for the next page query.
class ZIMRoomMemberQueriedResult {
  String roomID;
  String nextFlag;
  List<ZIMUserInfo> memberList;
  ZIMRoomMemberQueriedResult(
      {required this.roomID, required this.nextFlag, required this.memberList});
}

/// Callback of the result of querying the online members count in the room.
///
/// Available since:  1.1.0 or above.
///
/// Description: Callback of the result of querying the online members count in the room.
///
/// Related APIs: You can check the online number of people in the room through [queryRoomOnlineMemberCount].
///
/// [count] The number of online members of the room.
class ZIMRoomOnlineMemberCountQueriedResult {
  String roomID;
  int count;
  ZIMRoomOnlineMemberCountQueriedResult(
      {required this.roomID, required this.count});
}

/// Callback of the result of the room attributes operation.
///
/// Available since: 1.3.0.
///
/// Description: The callback of the result of room attributes operation.
class ZIMRoomAttributesOperatedCallResult {
  String roomID;
  List<String> errorKeys;
  ZIMRoomAttributesOperatedCallResult(
      {required this.roomID, required this.errorKeys});
}

/// Callback of the result of the room attributes operation.
///
/// Available since: 1.3.0.
///
/// Description: The callback of the result of room attributes operation.
class ZIMRoomAttributesBatchOperatedResult {
  String roomID;
  ZIMRoomAttributesBatchOperatedResult({required this.roomID});
}

/// Callback of the result of the room attributes quering.
///
/// Available since: 1.3.0.
///
/// Description: The callback of the result of room attributes operation.
///
/// [roomAttributes] Room attributes.
class ZIMRoomAttributesQueriedResult {
  String roomID;
  Map<String, String> roomAttributes;
  ZIMRoomAttributesQueriedResult(
      {required this.roomID, required this.roomAttributes});
}

class ZIMRoomMembersAttributesOperatedResult {
  String roomID = '';
  List<ZIMRoomMemberAttributesOperatedInfo> infos = [];
  List<String> errorUserList = [];
}

class ZIMRoomMembersAttributesQueriedResult {
  String roomID = '';
  List<ZIMRoomMemberAttributesInfo> infos = [];
}

class ZIMRoomMemberAttributesListQueriedResult {
  String roomID = '';
  List<ZIMRoomMemberAttributesInfo> infos = [];
  String nextFlag = '';
}

/// Description: Returns the result of the group creation operation.
///
/// Use cases: After a group creation operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result is returned after the group creation operation is complete.
///
/// Related API: [createGroup] : creates a group.
///
/// [groupInfo] groupInfo.
/// [userList] user list.
/// [errorUserList] errorUserList.
class ZIMGroupCreatedResult {
  ZIMGroupFullInfo groupInfo;
  List<ZIMGroupMemberInfo> userList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupCreatedResult(
      {required this.groupInfo,
      required this.userList,
      required this.errorUserList});
}

/// Description: Returns the result of the group dismiss operation.
///
/// Use cases: After a group disband operation is performed, the success of the operation can be determined by the callback.
///
/// When to call /Trigger: The result of the group disband operation is returned.
///
/// Related API: [createGroup],creates a group. [dismissGroup],dismissGroup.
///
/// [groupID]  Group ID.
class ZIMGroupDismissedResult {
  String groupID;
  ZIMGroupDismissedResult({required this.groupID});
}

/// Description: Returns the result of the group join operation.
///
/// Use cases: After a group join operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the group join operation is returned.
///
/// Related API:[joinGroup] : joins a group. [leaveGroup], leave the group.
class ZIMGroupJoinedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMGroupJoinedResult({required this.groupInfo});
}

/// Description: Returns the result of the group departure operation.
///
/// Use cases: After a group exit operation is performed, the success or failure can be determined by the callback.
///
/// When to call /Trigger: The result of the group departure operation is returned.
///
/// Related API:[leaveGroup], leave the group. [joinGroup], enter the group.
class ZIMGroupLeftResult {
  String groupID;
  ZIMGroupLeftResult({required this.groupID});
}

/// Description: Returns the result of inviting the user to join the group.
///
/// Use cases: After a user is invited to a group, the success or failure can be determined by the callback.
///
/// When to call /Trigger: Results are returned after the user is invited to the group.
///
/// Related API:[inviteUsersIntoGroup] invites users to join the group.
class ZIMGroupUsersInvitedResult {
  String groupID;
  List<ZIMGroupMemberInfo> userList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupUsersInvitedResult(
      {required this.groupID,
      required this.userList,
      required this.errorUserList});
}

/// Description: Returns the result of the kick out group member operation.
///
/// Use cases: After a group member is kicked out, the success or failure can be determined by the callback.
///
/// When to call /Trigger: The result is returned after the group member is kicked out.
///
/// Related API:[kickGroupMembers] Kick out group members.
class ZIMGroupMemberKickedResult {
  String groupID;
  List<String> kickedUserIDList;
  List<ZIMErrorUserInfo> errorUserList;
  ZIMGroupMemberKickedResult(
      {required this.groupID,
      required this.kickedUserIDList,
      required this.errorUserList});
}

/// Description: Returns the result of the group master transfer operation.
///
/// Use cases: After a group master transfer operation is performed, the success of the operation can be determined by this callback.
///
/// When to call /Trigger: The result of the group master transfer operation is returned.
///
/// Related API:[transferGroupOwner], group master transfer.
class ZIMGroupOwnerTransferredResult {
  String groupID;
  String toUserID;
  ZIMGroupOwnerTransferredResult(
      {required this.groupID, required this.toUserID});
}

/// Description: Return result of group name update operation.
///
/// Use cases: After a group name update operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the group name update operation is returned.
///
/// Related API:[updateGroupName], the group name is updated.
class ZIMGroupNameUpdatedResult {
  String groupID;
  String groupName;
  ZIMGroupNameUpdatedResult({required this.groupID, required this.groupName});
}

/// Description: Return result of group avatar url update operation.
///
/// Use cases: After a group avatar url update operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the group avatar url update operation is returned.
///
/// Related API:[updateGroupAvatarUrl], the group name is updated.
class ZIMGroupAvatarUrlUpdatedResult {
  String groupID;
  String groupAvatarUrl;
  ZIMGroupAvatarUrlUpdatedResult(
      {required this.groupID, required this.groupAvatarUrl});
}

/// Description: Return result of group notice update operation.
///
/// Use cases: After a group notice update operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the group notice update operation is returned.
///
/// Related API:[updateGroupNotice], the group notice is updated.
class ZIMGroupNoticeUpdatedResult {
  String groupID;
  String groupNotice;
  ZIMGroupNoticeUpdatedResult(
      {required this.groupID, required this.groupNotice});
}

/// Description: Returns the result of the group dismiss operation.
///
/// Use cases: After a group disband operation is performed, the success of the operation can be determined by the callback.
///
/// When to call /Trigger: The result of the group disband operation is returned.
///
/// Related API: [createGroup],creates a group. [dismissGroup],dismissGroup.
class ZIMGroupInfoQueriedResult {
  ZIMGroupFullInfo groupInfo;
  ZIMGroupInfoQueriedResult({required this.groupInfo});
}

/// Description: Returns the result of the group property operation.
///
/// Use cases: This callback tells you whether a custom property operation is successful.
///
/// When to call /Trigger: The result of the group property operation is returned.
///
/// Related API: [setGroupAttributes], set the room properties. [deleteGroupAttributes], delete the room attribute.
class ZIMGroupAttributesOperatedResult {
  String groupID;
  List<String> errorKeys;
  ZIMGroupAttributesOperatedResult(
      {required this.groupID, required this.errorKeys});
}

/// Description: Returns the result of group attribute query.
///
/// Use cases: This callback is used to determine the success of a custom property query.
///
/// When to call /Trigger: Group attribute query results are returned.
///
/// Related API: [queryGroupAttributes], query room attributes.
class ZIMGroupAttributesQueriedResult {
  String groupID;
  Map<String, String> groupAttributes;
  ZIMGroupAttributesQueriedResult(
      {required this.groupID, required this.groupAttributes});
}

/// Description: Return of the result of the member role update operation.
///
/// Use cases: After a member role update operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the member role update operation is returned.
///
/// Related API:[setGroupMemberRole], the member role is updated.
class ZIMGroupMemberRoleUpdatedResult {
  String groupID;
  String forUserID;
  int role;
  ZIMGroupMemberRoleUpdatedResult(
      {required this.groupID, required this.forUserID, required this.role});
}

/// Description: Return result of group member nickname update operation.
///
/// Use cases: After a group member nickname update operation is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: The result of the group member nickname update operation is returned.
///
/// Related API:[setGroupMemberNickname], the nickname of the group member is updated.
class ZIMGroupMemberNicknameUpdatedResult {
  String groupID;
  String forUserID;
  String nickname;
  ZIMGroupMemberNicknameUpdatedResult(
      {required this.groupID, required this.forUserID, required this.nickname});
}

/// Description: Return of group member query results.
///
/// Use cases: After a group member query is performed, the success or failure can be determined by this callback.
///
/// When to call /Trigger: Group member query results are returned.
///
/// Related API:[queryGroupMemberInfo], queryGroupMemberInfo.
class ZIMGroupMemberInfoQueriedResult {
  String groupID;
  ZIMGroupMemberInfo userInfo;
  ZIMGroupMemberInfoQueriedResult(
      {required this.groupID, required this.userInfo});
}

/// Description: Returns the group list query result.
///
/// Use cases: The success of a group list query can be determined by this callback.
///
/// When to call /Trigger: The result of the group list query is returned.
///
/// Related API:[queryGroupList] to query the group list.
class ZIMGroupListQueriedResult {
  List<ZIMGroup> groupList;
  ZIMGroupListQueriedResult({required this.groupList});
}

/// Description: Returns the result of querying the group member list.
///
/// Use cases: After querying the group member list, you can use the callback to determine whether the query is successful.
///
/// When to call /Trigger: The result is displayed after the group member list is queried.
///
/// Related API:[queryGroupMemberList], query the group member list.
class ZIMGroupMemberListQueriedResult {
  String groupID;
  List<ZIMGroupMemberInfo> userList;
  int nextFlag;
  ZIMGroupMemberListQueriedResult(
      {required this.groupID, required this.userList, required this.nextFlag});
}

class ZIMGroupMemberCountQueriedResult {
  String groupID;
  int count;
  ZIMGroupMemberCountQueriedResult(
      {required this.groupID, required this.count});
}

/// Supported version: 2.0.0.
///
/// Detail description: Operation callback for sending a call invitation.
///
/// Business scenario: After the operation of sending a call invitation is performed, the success or failure can be known through this callback.
///
/// Notification timing: The result is returned after the operation of sending the call invitation is completed.
///
/// Related interface: [callInvite], send a call invitation.
class ZIMCallInvitationSentResult {
  String callID = "";
  ZIMCallInvitationSentInfo info;
  ZIMCallInvitationSentResult({required this.callID, required this.info});
}

/// Supported version: 2.0.0.
///
/// Detail description: The operation callback for canceling the call invitation.
///
/// Business scenario: After canceling the call invitation operation, the success or failure can be known through this callback.
///
/// Notification timing: The result is returned after the cancel call invitation operation is completed.
///
/// Related interface: [callCancel], cancel the call invitation.
class ZIMCallCancelSentResult {
  String callID;
  List<String> errorInvitees;
  ZIMCallCancelSentResult({required this.callID, required this.errorInvitees});
}

/// Supported version: 2.0.0.
///
/// Detail description: The operation callback for accepting the call invitation.
///
/// Business scenario: After accepting the call invitation operation, the success or failure can be known through this callback.
///
/// Notification timing: The result will be returned after accepting the call invitation operation.
///
/// Related interface: [callAccept], accept the call invitation.
class ZIMCallAcceptanceSentResult {
  String callID;
  ZIMCallAcceptanceSentResult({required this.callID});
}

/// Supported version: 2.0.0.
///
/// Detail description: Operation callback for rejecting the call invitation.
///
/// Business scenario: After the operation of rejecting the call invitation is performed, the success or failure can be known through this callback.
///
/// Notification timing: The result is returned after the operation of rejecting the call invitation is completed.
///
/// Related interface: [callReject], rejects the call invitation.
class ZIMCallRejectionSentResult {
  String callID;
  ZIMCallRejectionSentResult({required this.callID});
}

class ZIMConversationMessageReceiptReadSentResult {
  String conversationID;
  ZIMConversationType conversationType;
  ZIMConversationMessageReceiptReadSentResult(
      {required this.conversationID, required this.conversationType});
}

class ZIMMessageReceiptsReadSentResult {
  String conversationID;
  ZIMConversationType conversationType;
  List<int> errorMessageIDs;
  ZIMMessageReceiptsReadSentResult(
      {required this.conversationID,
      required this.conversationType,
      required this.errorMessageIDs});
}

class ZIMMessageReceiptsInfoQueriedResult {
  List<ZIMMessageReceiptInfo> infos;
  List<int> errorMessageIDs;
  ZIMMessageReceiptsInfoQueriedResult(
      {required this.infos, required this.errorMessageIDs});
}

class ZIMGroupMessageReceiptMemberListQueriedResult {
  String groupID;
  int nextFlag;
  List<ZIMGroupMemberInfo> userList;
  ZIMGroupMessageReceiptMemberListQueriedResult(
      {required this.groupID, required this.nextFlag, required this.userList});
}

class ZIMMessageRevokedResult {
  ZIMRevokeMessage message;
  ZIMMessageRevokedResult({required this.message});
}
