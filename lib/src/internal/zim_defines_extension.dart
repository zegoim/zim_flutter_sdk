import '../zim_defines.dart';

extension ZIMConnectionStateExtension on ZIMConnectionState {
  static const valueMap = {
    ZIMConnectionState.disconnected: 0,
    ZIMConnectionState.connecting: 1,
    ZIMConnectionState.connected: 2,
    ZIMConnectionState.reconnecting: 3,
  };
  static const mapValue = {
    0: ZIMConnectionState.disconnected,
    1: ZIMConnectionState.connecting,
    2: ZIMConnectionState.connected,
    3: ZIMConnectionState.reconnecting,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGeofencingTypeExtension on ZIMGeofencingType {
  static const valueMap = {
    ZIMGeofencingType.none:0,
    ZIMGeofencingType.include:1,
    ZIMGeofencingType.exclude:2
  };

  static const mapValue = {
    0:ZIMGeofencingType.none,
    1:ZIMGeofencingType.include,
    2:ZIMGeofencingType.exclude
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomStateExtension on ZIMRoomState {
  static const valueMap = {
    ZIMRoomState.disconnected: 0,
    ZIMRoomState.connecting: 1,
    ZIMRoomState.connected: 2,
  };
  static const mapValue = {
    0: ZIMRoomState.disconnected,
    1: ZIMRoomState.connecting,
    2: ZIMRoomState.connected,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConnectionEventExtension on ZIMConnectionEvent {
  static const valueMap = {
    ZIMConnectionEvent.unknown:-1,
    ZIMConnectionEvent.success: 0,
    ZIMConnectionEvent.activeLogin: 1,
    ZIMConnectionEvent.loginTimeout: 2,
    ZIMConnectionEvent.interrupted: 3,
    ZIMConnectionEvent.kickedOut: 4,
    ZIMConnectionEvent.tokenExpired: 5,
    ZIMConnectionEvent.unregistered: 6
  };
  static const mapValue = {
    -1: ZIMConnectionEvent.unknown,
    0: ZIMConnectionEvent.success,
    1: ZIMConnectionEvent.activeLogin,
    2: ZIMConnectionEvent.loginTimeout,
    3: ZIMConnectionEvent.interrupted,
    4: ZIMConnectionEvent.kickedOut,
    5: ZIMConnectionEvent.tokenExpired,
    6: ZIMConnectionEvent.unregistered
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomEventExtension on ZIMRoomEvent {
  static const valueMap = {
    ZIMRoomEvent.success: 0,
    ZIMRoomEvent.interrupted: 1,
    ZIMRoomEvent.disconnected: 2,
    ZIMRoomEvent.roomNotExist: 3,
    ZIMRoomEvent.activeCreate: 4,
    ZIMRoomEvent.createFailed: 5,
    ZIMRoomEvent.activeEnter: 6,
    ZIMRoomEvent.enterFailed: 7,
    ZIMRoomEvent.kickedOut: 8,
    ZIMRoomEvent.connectTimeout: 9,
    ZIMRoomEvent.kickedOutByOtherDevice: 10
  };
  static const mapValue = {
    0: ZIMRoomEvent.success,
    1: ZIMRoomEvent.interrupted,
    2: ZIMRoomEvent.disconnected,
    3: ZIMRoomEvent.roomNotExist,
    4: ZIMRoomEvent.activeCreate,
    5: ZIMRoomEvent.createFailed,
    6: ZIMRoomEvent.activeEnter,
    7: ZIMRoomEvent.enterFailed,
    8: ZIMRoomEvent.kickedOut,
    9: ZIMRoomEvent.connectTimeout,
    10: ZIMRoomEvent.kickedOutByOtherDevice
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessagePriorityExtension on ZIMMessagePriority {
  static const valueMap = {
    ZIMMessagePriority.low: 1,
    ZIMMessagePriority.medium: 2,
    ZIMMessagePriority.high: 3,
  };
  static const mapValue = {
    1: ZIMMessagePriority.low,
    2: ZIMMessagePriority.medium,
    3: ZIMMessagePriority.high,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageTypeExtension on ZIMMessageType {
  static const valueMap = {
    ZIMMessageType.unknown: 0,
    ZIMMessageType.text: 1,
    ZIMMessageType.command: 2,
    ZIMMessageType.image: 11,
    ZIMMessageType.file: 12,
    ZIMMessageType.audio: 13,
    ZIMMessageType.video: 14,
    ZIMMessageType.barrage: 20,
    ZIMMessageType.system:30,
    ZIMMessageType.revoke:31,
    ZIMMessageType.combine:100,
    ZIMMessageType.custom:200,
  };
  static const mapValue = {
    0: ZIMMessageType.unknown,
    1: ZIMMessageType.text,
    2: ZIMMessageType.command,
    11: ZIMMessageType.image,
    12: ZIMMessageType.file,
    13: ZIMMessageType.audio,
    14: ZIMMessageType.video,
    20: ZIMMessageType.barrage,
    30: ZIMMessageType.system,
    31: ZIMMessageType.revoke,
    100:ZIMMessageType.combine,
    200:ZIMMessageType.custom
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageMentionedTypeExtension on ZIMMessageMentionedType {
  static const valueMap = {
    ZIMMessageMentionedType.unknown: -1,
    ZIMMessageMentionedType.mention_me: 1,
    ZIMMessageMentionedType.mention_all: 2,
    ZIMMessageMentionedType.mention_all_and_me: 3,
  };
  static const mapValue = {
    -1: ZIMMessageMentionedType.unknown,
    1: ZIMMessageMentionedType.mention_me,
    2: ZIMMessageMentionedType.mention_all,
    3: ZIMMessageMentionedType.mention_all_and_me,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMediaFileTypeExtension on ZIMMediaFileType {
  static const valueMap = {
    ZIMMediaFileType.originalFile: 1,
    ZIMMediaFileType.largeImage: 2,
    ZIMMediaFileType.thumbnail: 3,
    ZIMMediaFileType.videoFirstFrame: 4
  };

  static const mapValue = {
    1: ZIMMediaFileType.originalFile,
    2: ZIMMediaFileType.largeImage,
    3: ZIMMediaFileType.thumbnail,
    4: ZIMMediaFileType.videoFirstFrame
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomAttributesUpdateActionExtension
    on ZIMRoomAttributesUpdateAction {
  static const valueMap = {
    ZIMRoomAttributesUpdateAction.set: 0,
    ZIMRoomAttributesUpdateAction.delete: 1,
  };
  static const mapValue = {
    0: ZIMRoomAttributesUpdateAction.set,
    1: ZIMRoomAttributesUpdateAction.delete,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageDirectionExtension on ZIMMessageDirection {
  static const valueMap = {
    ZIMMessageDirection.send: 0,
    ZIMMessageDirection.receive: 1,
  };
  static const mapValue = {
    0: ZIMMessageDirection.send,
    1: ZIMMessageDirection.receive,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageSentStatusExtension on ZIMMessageSentStatus {
  static const valueMap = {
    ZIMMessageSentStatus.sending: 0,
    ZIMMessageSentStatus.success: 1,
    ZIMMessageSentStatus.failed: 2,
  };
  static const mapValue = {
    0: ZIMMessageSentStatus.sending,
    1: ZIMMessageSentStatus.success,
    2: ZIMMessageSentStatus.failed,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationTypeExtension on ZIMConversationType {
  static const valueMap = {
    ZIMConversationType.unknown: -1,
    ZIMConversationType.peer: 0,
    ZIMConversationType.room: 1,
    ZIMConversationType.group: 2,
  };
  static const mapValue = {
    -1: ZIMConversationType.unknown,
    0: ZIMConversationType.peer,
    1: ZIMConversationType.room,
    2: ZIMConversationType.group,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageDeleteTypeExtension on ZIMMessageDeleteType {
  static const valueMap = {
    ZIMMessageDeleteType.messageListDeleted: 0,
    ZIMMessageDeleteType.conversationAllMessagesDeleted: 1,
    ZIMMessageDeleteType.allConversationMessagesDeleted: 2,
  };
  static const mapValue = {
    0: ZIMMessageDeleteType.messageListDeleted,
    1: ZIMMessageDeleteType.conversationAllMessagesDeleted,
    2: ZIMMessageDeleteType.allConversationMessagesDeleted,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationEventExtension on ZIMConversationEvent {
  static const valueMap = {
    ZIMConversationEvent.added: 0,
    ZIMConversationEvent.updated: 1,
    ZIMConversationEvent.disabled: 2,
    ZIMConversationEvent.deleted: 3
  };
  static const mapValue = {
    0: ZIMConversationEvent.added,
    1: ZIMConversationEvent.updated,
    2: ZIMConversationEvent.disabled,
    3: ZIMConversationEvent.deleted
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationNotificationStatusExtension
    on ZIMConversationNotificationStatus {
  static const valueMap = {
    ZIMConversationNotificationStatus.notify: 1,
    ZIMConversationNotificationStatus.doNotDisturb: 2,
  };
  static const mapValue = {
    1: ZIMConversationNotificationStatus.notify,
    2: ZIMConversationNotificationStatus.doNotDisturb,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupEventExtension on ZIMGroupEvent {
  static const valueMap = {
    ZIMGroupEvent.created: 1,
    ZIMGroupEvent.dismissed: 2,
    ZIMGroupEvent.joined: 3,
    ZIMGroupEvent.invited: 4,
    ZIMGroupEvent.left: 5,
    ZIMGroupEvent.kickedout: 6
  };
  static const mapValue = {
    1: ZIMGroupEvent.created,
    2: ZIMGroupEvent.dismissed,
    3: ZIMGroupEvent.joined,
    4: ZIMGroupEvent.invited,
    5: ZIMGroupEvent.left,
    6: ZIMGroupEvent.kickedout,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupStateExtension on ZIMGroupState {
  static const valueMap = {
    ZIMGroupState.quit: 0,
    ZIMGroupState.enter: 1,
  };
  static const mapValue = {
    0: ZIMGroupState.quit,
    1: ZIMGroupState.enter,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMemberEventExtension on ZIMGroupMemberEvent {
  static const valueMap = {
    ZIMGroupMemberEvent.joined: 1,
    ZIMGroupMemberEvent.left: 2,
    ZIMGroupMemberEvent.kickedout: 4,
    ZIMGroupMemberEvent.invited: 5
  };
  static const mapValue = {
    1: ZIMGroupMemberEvent.joined,
    2: ZIMGroupMemberEvent.left,
    4: ZIMGroupMemberEvent.kickedout,
    5: ZIMGroupMemberEvent.invited,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMemberStateExtension on ZIMGroupMemberState {
  static const valueMap = {
    ZIMGroupMemberState.quit: 0,
    ZIMGroupMemberState.enter: 1,
  };
  static const mapValue = {
    0: ZIMGroupMemberState.quit,
    1: ZIMGroupMemberState.enter,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupAttributesUpdateActionExtension
    on ZIMGroupAttributesUpdateAction {
  static const valueMap = {
    ZIMGroupAttributesUpdateAction.set: 0,
    ZIMGroupAttributesUpdateAction.delete: 1,
  };
  static const mapValue = {
    0: ZIMGroupAttributesUpdateAction.set,
    1: ZIMGroupAttributesUpdateAction.delete,
  };
  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMessageNotificationStatusEventExtension
    on ZIMGroupMessageNotificationStatus {
  static const valueMap = {
    ZIMGroupMessageNotificationStatus.notify: 1,
    ZIMGroupMessageNotificationStatus.doNotDisturb: 2
  };
  static const mapValue = {
    1: ZIMGroupMessageNotificationStatus.notify,
    2: ZIMGroupMessageNotificationStatus.doNotDisturb,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCallUserStateExtension on ZIMCallUserState {
  static const valueMap = {
    ZIMCallUserState.unknown: -1,
    ZIMCallUserState.inviting: 0,
    ZIMCallUserState.accepted: 1,
    ZIMCallUserState.rejected: 2,
    ZIMCallUserState.cancelled: 3,
    ZIMCallUserState.offline: 4,
    ZIMCallUserState.received: 5,
    ZIMCallUserState.timeout:6,
    ZIMCallUserState.quited:7,
    ZIMCallUserState.ended:8
  };
  static const mapValue = {
    -1: ZIMCallUserState.unknown,
    0: ZIMCallUserState.inviting,
    1: ZIMCallUserState.accepted,
    2: ZIMCallUserState.rejected,
    3: ZIMCallUserState.cancelled,
    4: ZIMCallUserState.offline,
    5: ZIMCallUserState.received,
    6: ZIMCallUserState.timeout,
    7: ZIMCallUserState.quited,
    8: ZIMCallUserState.ended
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCallStateExtension on ZIMCallState {
  static const valueMap = {
    ZIMCallState.unknown: -1,
    ZIMCallState.started: 1,
    ZIMCallState.ended: 2,
  };
  static const mapValue = {
    -1: ZIMCallState.unknown,
    1: ZIMCallState.started,
    2: ZIMCallState.ended,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageReceiptStatusExtension on ZIMMessageReceiptStatus {
  static const valueMap = {
    ZIMMessageReceiptStatus.none: 0,
    ZIMMessageReceiptStatus.processing: 1,
    ZIMMessageReceiptStatus.done: 2,
    ZIMMessageReceiptStatus.expired: 3,
    ZIMMessageReceiptStatus.failed: 4
  };
  static const mapValue = {
    0: ZIMMessageReceiptStatus.none,
    1: ZIMMessageReceiptStatus.processing,
    2: ZIMMessageReceiptStatus.done,
    3: ZIMMessageReceiptStatus.expired,
    4: ZIMMessageReceiptStatus.failed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageOrderExtension on ZIMMessageOrder {
  static const valueMap = {
    ZIMMessageOrder.descending: 0,
    ZIMMessageOrder.ascending: 1
  };

  static const mapValue = {
    0: ZIMMessageOrder.descending,
    1: ZIMMessageOrder.ascending,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRevokeTypeExtension on ZIMRevokeType {
  static const valueMap = {
    ZIMRevokeType.unknown: -1,
    ZIMRevokeType.twoWay: 0,
    ZIMRevokeType.oneWay: 1,
  };
  static const mapValue = {
    -1:ZIMRevokeType.unknown,
    0: ZIMRevokeType.twoWay,
    1: ZIMRevokeType.oneWay,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageRevokeStatusExtension on ZIMMessageRevokeStatus {
  static const valueMap = {
    ZIMMessageRevokeStatus.unknown: -1,
    ZIMMessageRevokeStatus.selfRevoke: 0,
    ZIMMessageRevokeStatus.systemRevoke: 1,
    ZIMMessageRevokeStatus.serviceAPIRevoke: 2,
    ZIMMessageRevokeStatus.groupAdminRevoke: 3,
    ZIMMessageRevokeStatus.groupOwnerRevoke: 4
  };
  static const mapValue = {
    -1: ZIMMessageRevokeStatus.unknown,
    0: ZIMMessageRevokeStatus.selfRevoke,
    1: ZIMMessageRevokeStatus.systemRevoke,
    2: ZIMMessageRevokeStatus.serviceAPIRevoke,
    3: ZIMMessageRevokeStatus.groupAdminRevoke,
    4: ZIMMessageRevokeStatus.groupOwnerRevoke,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMInvitationModeExtension on ZIMCallInvitationMode {
  static const valueMap = {
    ZIMCallInvitationMode.unknown: -1,
    ZIMCallInvitationMode.general: 0,
    ZIMCallInvitationMode.advanced: 1,
  };

  static const mapValue = {
    -1:ZIMCallInvitationMode.unknown,
    0:ZIMCallInvitationMode.general,
    1:ZIMCallInvitationMode.advanced
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCXHandleTypeExtension on ZIMCXHandleType {
  static const valueMap = {
    ZIMCXHandleType.generic : 1,
    ZIMCXHandleType.phoneNumber : 2,
    ZIMCXHandleType.emailAddress : 3
  };

  static const mapValue = {
    1 : ZIMCXHandleType.generic,
    2: ZIMCXHandleType.phoneNumber,
    3: ZIMCXHandleType.emailAddress
  };

  int get value => valueMap[this]?? - 1;
}

extension ZIMFriendApplicationStateExtension on ZIMFriendApplicationState {
  static const valueMap = {
    ZIMFriendApplicationState.unknown : -1,
    ZIMFriendApplicationState.waiting: 1,
    ZIMFriendApplicationState.accepted: 2,
    ZIMFriendApplicationState.rejected: 3,
    ZIMFriendApplicationState.expired: 4,
    ZIMFriendApplicationState.disabled: 5
  };

  static const mapValue = {
    -1:ZIMFriendApplicationState.unknown,
    1:ZIMFriendApplicationState.waiting,
    2:ZIMFriendApplicationState.accepted,
    3:ZIMFriendApplicationState.rejected,
    4:ZIMFriendApplicationState.expired,
    5:ZIMFriendApplicationState.disabled
  };

  int get value => valueMap[this]?? - 1;
}

extension ZIMFriendApplicationTypeExtension on ZIMFriendApplicationType{
  static const valueMap = {
    ZIMFriendApplicationType.unknown : -1,
    ZIMFriendApplicationType.none : 0,
    ZIMFriendApplicationType.received: 1,
    ZIMFriendApplicationType.sent: 2,
    ZIMFriendApplicationType.both:3
  };

  static const mapValue = {
    -1: ZIMFriendApplicationType.unknown,
    0: ZIMFriendApplicationType.none,
    1: ZIMFriendApplicationType.received,
    2:ZIMFriendApplicationType.sent,
    3:ZIMFriendApplicationType.both
  };

  int get value => valueMap[this]?? - 1;
}



// ZIMFriendDeleteType Enum Extension
extension ZIMFriendDeleteTypeExtension on ZIMFriendDeleteType {
  static const valueMap = {
    ZIMFriendDeleteType.unknown: -1,
    ZIMFriendDeleteType.both: 0,
    ZIMFriendDeleteType.single: 1,
  };

  static const mapValue = {
    -1: ZIMFriendDeleteType.unknown,
    0: ZIMFriendDeleteType.both,
    1: ZIMFriendDeleteType.single,
  };

  int get value => valueMap[this] ?? -1;
}

// ZIMFriendListChangeAction Enum Extension
extension ZIMFriendListChangeActionExtension on ZIMFriendListChangeAction {
  static const valueMap = {
    ZIMFriendListChangeAction.added: 0,
    ZIMFriendListChangeAction.deleted: 1,
  };

  static const mapValue = {
    0: ZIMFriendListChangeAction.added,
    1: ZIMFriendListChangeAction.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendApplicationListChangeActionExtension on ZIMFriendApplicationListChangeAction {
  static const valueMap = {
    ZIMFriendApplicationListChangeAction.added:0,
    ZIMFriendApplicationListChangeAction.deleted:1,
  };

  static const mapValue = {
    0:ZIMFriendApplicationListChangeAction.added,
    1:ZIMFriendApplicationListChangeAction.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

// ZIMFriendRelationCheckType Enum Extension
extension ZIMFriendRelationCheckTypeExtension on ZIMFriendRelationCheckType {
  static const valueMap = {
    ZIMFriendRelationCheckType.unknown: -1,
    ZIMFriendRelationCheckType.both: 0,
    ZIMFriendRelationCheckType.single: 1,
  };

  static const mapValue = {
    -1: ZIMFriendRelationCheckType.unknown,
    0: ZIMFriendRelationCheckType.both,
    1: ZIMFriendRelationCheckType.single,
  };

  int get value => valueMap[this] ?? -1;
}

// ZIMUserRelationType Enum Extension
extension ZIMUserRelationTypeExtension on ZIMUserRelationType {
  static const valueMap = {
    ZIMUserRelationType.unknown: 0,
    ZIMUserRelationType.singleNo: 1,
    ZIMUserRelationType.singleHave: 2,
    ZIMUserRelationType.bothAllNo: 3,
    ZIMUserRelationType.bothSelfHave: 4,
    ZIMUserRelationType.bothOtherHave: 5,
    ZIMUserRelationType.bothAllHave: 6,
  };

  static const mapValue = {
    0: ZIMUserRelationType.unknown,
    1: ZIMUserRelationType.singleNo,
    2: ZIMUserRelationType.singleHave,
    3: ZIMUserRelationType.bothAllNo,
    4: ZIMUserRelationType.bothSelfHave,
    5: ZIMUserRelationType.bothOtherHave,
    6: ZIMUserRelationType.bothAllHave,
  };

  int get value => valueMap[this] ?? -1;
}

// ZIMBlacklistChangedAction Enum Extension
extension ZIMBlacklistChangeActionExtension on ZIMBlacklistChangeAction {
  static const valueMap = {
    ZIMBlacklistChangeAction.added: 0,
    ZIMBlacklistChangeAction.removed: 1,
  };

  static const mapValue = {
    0: ZIMBlacklistChangeAction.added,
    1: ZIMBlacklistChangeAction.removed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMuteModeExtension on ZIMGroupMuteMode{
  static const valueMap = {
    ZIMGroupMuteMode.none : 0,
    ZIMGroupMuteMode.normal : 1,
    ZIMGroupMuteMode.all : 2,
    ZIMGroupMuteMode.custom : 3
  };

  static const mapValue = {
    0 : ZIMGroupMuteMode.none,
    1 : ZIMGroupMuteMode.normal,
    2 : ZIMGroupMuteMode.all,
    3 : ZIMGroupMuteMode.custom
  };
  int get value => valueMap[this] ?? -1;
}
