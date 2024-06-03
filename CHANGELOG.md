## 2.16.0
### Features

**Server-Side Call Invitation Management**
- Supports initiating, accepting, and rejecting call invitations on the server side.

**Server-Side Mute Management**
- Supports muting groups and specific group members on the server side.

**Server-Side Group Member Role Setting**
- Supports modifying group member roles on the server side.

### Improvements and Optimizations

**Receipt Optimization**
- Includes real-time awareness of receipt expiration status, supports offline query of receipt details, and supports querying receipt details for groups with more than 100 members.

**Call Invitation**
- Supports advanced mode call invitations, allowing a specific userID to be passed in the callCancel interface to cancel the call for that user only, without affecting the overall call status.

### 2. API Refactoring
> 💥 Please note to developers that there are breaking changes starting from version 2.13.0, so please read the following guidelines when upgrading from the old version to the new version.

For advanced mode call invitations, in the new version of callCancel, if the userIDs parameter contains userID, the interface will only cancel the invitation for that called user. If the userIDs parameter is empty, the interface will cancel invitations for all called users.

For the old version of the callCancelWithInvitees interface, regardless of whether the userIDs parameter is empty or not, it will cancel invitations for all called users.

Since the old version of the ZIM SDK is not compatible with the individual cancelation logic, if you need to retain the cancelation logic implemented with the old version of ZIM while using the individual cancelation feature of the new version, please isolate the call functions between the new and old versions of ZIM.



## 2.15.0

### New Features

#### Group Roles
- **Description:** Added a new group role "Administrator" with most of the group owner capabilities, including modifying nicknames for regular members, retracting messages from regular members, kicking members, and muting individual members and specific group roles.
- **Relevant API:** `setGroupMemberRole`
- **Additional Information:** For more details on group roles and their permissions, please refer to [Group Member Management - Setting Group Member Roles](#).

#### Group Entry Validation
- **Description:** Added properties `joinMode`, `inviteMode`, and `beInviteMode` to `ZIMGroupAdvancedConfig` to support setting group entry validation modes, invite modes, and invitee validation modes during group creation. This facilitates group owners and administrators in restricting external user entries.
- **Relevant APIs:**
  - `createGroup`
  - `ZIMGroupAdvancedConfig > joinMode`
  - `ZIMGroupAdvancedConfig > inviteMode`
  - `ZIMGroupAdvancedConfig > beInviteMode`
  - `sendGroupJoinApplication`
  - `acceptGroupJoinApplication`
  - `rejectGroupJoinApplication`
  - `sendGroupInviteApplications`
  - `acceptGroupInviteApplication`
  - `rejectGroupInviteApplication`
  - `queryGroupApplicationList`
  - `updateGroupJoinMode`
  - `updateGroupInviteMode`
  - `updateGroupBeInviteMode`
- **Additional Information:** For more details on API usage, please refer to [Group Management](#).

#### Tips Messages
- **Description:** Support converting certain group actions (like creating or dissolving a group) into special type messages (Tips). Developers can construct and display descriptions of related events in the UI based on group message callbacks.
- **Relevant API:** 
  - `ZIMMessageType > TIPS`
  - `onReceiveGroupMessage`
- **Additional Information:** For types of Tips messages and extensions, and how to handle them after receipt, please refer to [Receiving Tips Messages](#).

#### Custom Push Rules
- **Description:** Supports users in multi-login scenarios to decide which platforms should receive offline push notifications, and query current offline push rules.
- **Relevant APIs:**
  - `updateUserOfflinePushRule`
  - `querySelfUserInfo`

#### Message Export and Import
- **Description:** Supports exporting local terminal history messages for backup, useful for transferring chat history when switching devices or recovering deleted messages.
- **Relevant APIs:**
  - `exportLocalMessages`
  - `importLocalMessages`

#### Cache Management
- **Description:** Supports querying the current login user's local cache file size and clearing local cache.
- **Relevant APIs:**
  - `queryLocalFileCache`
  - `clearLocalFileCache`

#### Leave All Rooms
- **Description:** Supports users in multi-room scenarios to exit all rooms at once; also useful for developers to exit a single room without needing to pass a `roomID`.
- **Relevant API:** `leaveAllRoom`

#### Data Migration
- **Description:** Supports users in migrating user data to the ZIM service via the ZIM server interface.
- **Relevant API:** See [Migration Scheme](#).

#### Server-side Query Conversation List
- **Description:** Supports server-side pagination to query the latest 1000 conversations (both single and group chats) of a user.
- **Relevant API:** See [Query Conversation List](#).

#### Server-side Query Historical Messages
- **Description:** Supports server-side pagination to query historical messages list of specified single chat or group chat conversations.
- **Relevant APIs:**
  - `Query Single Chat Conversation Messages List`
  - `Query Group Chat Conversation Messages List`

#### Modify Group Specifications on Server-side
- **Description:** Supports modifying the group's entry validation mode, invite mode, invite target verification mode, and group member cap on the server-side.
- **Relevant API:** Modify group specification restrictions

### Improvements and Optimizations

#### Invite Delivery Detection
- **Description:** Added a configuration parameter `enableNotReceivedCheck` to detect if a call invitation reaches the callee, allowing the caller to quickly be aware of the callee's network status and provide notifications.
- **Relevant API:** `ZIMCallInviteConfig > enableNotReceivedCheck`

#### Server-side Create Group Interface New Parameter
- **Description:** Added `CreateGroupTime` parameter, supporting the setting of the event time for creating groups.
- **Relevant API:** Create group

#### Server-side Add Group Member Interface New Parameter
- **Description:** Added `GroupMemberInfos` parameter, supporting the definition of group joining time and mode for new members.
- **Relevant API:** Create group

## 2.14.1
### Fix some issue.

## 2.14.0
### New Features

- **Merge Forwarding**
  - Support users in forwarding and merging messages after sending or receiving messages. Users can construct a merged message body and pass it to the send message interface for forwarding and merging. Query the detailed contents of merged messages.

  **Related Interfaces:**
  - `ZIMCombineMessage`
  - `sendMessage`
  - `queryCombineMessageDetail`

- **Mention in Messages**
  - Allow users to mention specific users (even if not in the current conversation) or mention all members in a conversation when sending messages.

  **Related Interfaces:**
  - `ZIMMessage > mentionedUserIDs`
  - `ZIMMessage > isMentionAll`

- **Delete Messages**
  - Enable users to delete all messages in a conversation at once.

  **Related Interface:**
  - `deleteAllConversationMessages`

- **Save Conversation Draft**
  - ZIM supports saving conversation drafts locally even after exiting individual and group chat sessions for later editing.

  **Related Interface:**
  - `setConversationDraft`

- **Individual Chat Mute**
  - In addition to "Group Chat Mute," now support muting individual chat sessions. No notification will be pushed when new messages are received in individual chat sessions.

  **Related Interface:**
  - `setConversationNotificationStatus`

- **Speech Prohibition**
  - Support group owners in implementing group muting and muting specific group members. Group muting includes muting all members, regular members, and members with specific roles.

  **Related Interfaces:**
  - `muteGroup`
  - `muteGroupMembers`

- **Friend Management**
  - Users can directly add and delete friends, view friend lists, send friend requests, accept or reject friend requests, view friend request lists, check other users' friend relationships, query or modify friend information, and search for friends.

  **Related Interfaces:**
  - `addFriend`
  - `deleteFriends`
  - `sendFriendApplication`
  - `acceptFriendApplication`
  - `rejectFriendApplication`
  - `checkFriendsRelation`
  - `queryFriendList`
  - `queryFriendApplicationList`
  - `updateFriendAlias`
  - `updateFriendAttributes`
  - `queryFriendsInfo`
  - `searchLocalFriends`

- **Set Security Audit Sensitive Words**
  - With security audit enabled, support developers in adding additional sensitive words. When users send messages containing sensitive words, the message is audited, and the content is replaced or intercepted.

- **Server-Side Conversation Mute**
  - Support setting server-side mute status for group chat and individual chat sessions.

  **Related Interface:**
  - `setConversationMessageMute`

- **Server-Side Pin Conversations**
  - Support setting the pinned status of conversations on the server.

  **Related Interface:**
  - `pinConversation`

- **Server-Side Modify Group Information**
  - Support modifying the avatar, name, and announcement of a pinned group on the server.

- **Server-Side Friend Management**
  - Support adding and deleting friends, querying friend lists, checking friend relationships, updating friend remarks, and updating friend attributes on the server.

  **Related Interfaces:**
  - `batchAddFriends`
  - `batchSendFriendApplication`
  - `batchDeleteFriends`
  - `queryFriendList`
  - `checkFriendsRelation`
  - `updateFriendAlias`
  - `updateFriendAttributes`

- **Server-Side Blacklist Management**
  - Support batch blocking, unblocking, querying, and checking blacklist relationships on the server.

  **Related Interfaces:**
  - `batchBlockUsers`
  - `batchUnblockUsers`
  - `queryBlacklist`
  - `checkBlacklistRelation`

- **Help Translate the Above Chinese Release Notes into Markdown**

---

### Recommendations for Users

Users who have upgraded to version 2.13.0 are strongly recommended to update to version 2.13.1 to address the aforementioned issues and ensure optimal performance and stability.

## 2.13.1
### Bug Fixes
Avatar Update Issue: Fixed an issue where updating user avatars was not functioning properly. Users can now update their avatars without encountering any errors.
Message Query Crash: Resolved a crash that occurred when querying messages with specific content. The message retrieval process is now robust and crash-free.
Pre-embedded Logic Error: Corrected a pre-embedded logic flaw that would cause crashes when mixing SDK versions 2.13.0 and 2.14.0 in future use. Users are advised to update to the latest version to prevent potential instability.
Media Message Error Status Code: Amended an issue where the incorrect status code was returned in the error messages for media download failures. Error responses now correctly reflect the accurate status code.
Recommendations for Users
Users who have upgraded to version 2.13.0 are strongly recommended to update to version 2.13.1 to address the aforementioned issues and ensure optimal performance and stability.

## 2.13.0+1
    Fix some issue.
## 2.13.0
### 1. Feature
1、Users can log in to the IM service offline and access local SDK data.
2、Users can query their own blacklist, block the specified user (no longer receive messages from the user), remove the user from the blacklist, and check whether the specified user is in the blacklist.
3、Support for inserting local messages into room sessions.
4、Support for withdrawing single chat messages and group chat messages from the server-side call interface.
5、Support from the server interface to modify user information, including user nicknames, avatars and so on.
6、Roomids up to 128 bytes are now supported.
7、ZIMUserInfo and ZIMGroupMemberInfo added the userAvatarUrl field, which is used to set or describe the user profile picture address.
8、The SuccessList parameter was added. The member parameters include UserId, MsgId, and MsgSeq, indicating information about the user who successfully accepted the message. MsgSeq can be used to withdraw a single chat message.
9、Added MsgSeq, which can be used to withdraw group chat messages.
10、Added the user_list field to batch return information about the users who receive messages.This field has a value only if the developer invokes the server-side interface to send a single chat message.
### 2. API Refactoring
> 💥 Please note to developers that there are breaking changes starting from version 2.13.0, so please read the following guidelines when upgrading from the old version to the new version.

  login have a breaking changed.

* old version usage:
```dart
  var userInfo = { userID: 'xxxx', userName: 'xxxx' };
  var token = '';
  zim.login(userInfo, token)
  .then(function () {
  })
  .catch(function (err) {
  });
```

* new version usage:
```dart
  try{
      ZIMLoginConfig loginConfig = ZIMLoginConfig();
      loginConfig.userName = 'userName';
      loginConfig.token = '';
      loginConfig.isOfflineLogin = false;
      await ZIM.getInstance()?.login('zego', loginConfig);
  } on PlatformException catch(onError){
      onError.code;
      onError.message;
  }
```

## 2.12.2
Fix known problems.
## 2.12.1
Fix known problems.
## 2.12.0
### 1. Feature
1、Geofencing: Offers geofencing services to ensure IM data is stored locally in the operating region, suitable for high-security scenarios overseas.
2、Group Message Management: Supports new members automatically receiving group's historical messages when joining a group.
3、One-Click Read: Supports clearing all conversations' message unread counts and total unread message count.
4、Call Invitation: Supports inviting external users to join advanced mode calls, or internal users to switch devices.
5、Delete All Conversation Lists: Supports clearing the current conversation list.
6、Server-Side Addition of Group Member Interface: Supports adding specified users to a group.
7、Server-Side Dissolution of Group Interface: Supports dissolving a specified group.
8、Server-Side Transfer of Group Ownership Interface: Supports transferring group ownership to a specified group member.
9、Server-Side Setting of Group Member Nickname Interface: Supports setting nicknames for specific group members.
10、Server-Side Messages with Receipts: When sending individual or group messages through the server, it is possible to attach a receipt function.
11、Server-Side Login Logout Callback: When a user logs in or out, ZIM server will actively callback to notify the developer's server.
12、All-Member Offline Push: When using the server-side interface for all-member push, it supports selecting the push type to implement offline push.

### 2. Improved Optimization Items
1、Login Logic Optimization: Optimizes the login logic to avoid abnormal device kicking each other out in weak network conditions.
2、Call Creation Server Callback: The call creation server callback adds a 'caller' field to indicate the user initiating the call. For more details, please refer to the Call Creation Callback.

## 2.11.0
### 1. Feature
1、Dual-platform or multi-platform login policies can be configured. Users can log in to the same account on multiple platforms and devices at the same time, enabling communication between sessions, messages, and groups. For details about the impact of multi-login on other functions, see Multi-Login.This feature is only available for users of the Pro or Flagship packages, who need to contact ZEGO Technical Support to configure a login policy.
2、Added the supported types of server signaling messages.
3、Optimized the top placement logic after deleting a session.


## 2.10.0

### 1. Feature
1、Support for single chat and group chat messages to react (that is, position), generally can be used for scenes such as emoticons reply messages, can also be used to initiate group voting, confirm group results and other operations. In addition, it also supports deleting statements made by oneself, and querying user information related to a statement.
2、New the SenderUnaware field allows the client with FromUserId (sender user ID) in the request parameter to be unaware of the transmission after a single-chat message is sent through the server.
3、Supports sending messages with specific content to all online users (including message sending users themselves), such as text, pictures, etc. This function is suitable for all staff activity announcements, gifts across the room floating screen and other scenes.
4、This interface enables you to query whether the specified user is in the target room.
## 2.9.0

### 1. Feature
1、Call invitation Added mode,The new advanced mode allows users to invite, exit, and end a call during a call.
2、In a group session, the group owner can withdraw messages sent by others.
3、Supports sending pictures, files, audio, video, custom, and bullet-screen messages through the server interface. For details, see MessageBody.
4、You can invoke the downloadMediaFile interface to download rich media messages from external urls.
5、Added a message extension field that is visible only to the local end. This field can be updated to display the message translation status or other content.
6、Search the local messages of single or all single chat and group chat sessions by keyword, user ID, etc., and obtain the list of messages that meet the conditions; You can also search for sessions based on local messages.
7、Search group names based on keywords, and group member names and nicknames can be included in the search scope.
8、Search for group member names in a specified group based on keywords, and group member nicknames are included in the search range.
9、Optimized the common call invitation mode. Within the call invitation timeout period, an offline user can be notified immediately after receiving a call invitation.

### 2. Deprecated
1、Added onCallUserStateChanged to allow developers to listen to call status changes of users in call invitations. Replace the original call invite callback onCallInvitationAccepted, onCallInvitationRejected and onCallInviteesAnsweredTimeout.
2、Original static void Function(ZIM zim, String callID)? onCallInvitationTimeout is deprecated,please use static void Function(ZIM zim, ZIMCallInvitationTimeoutInfo info, String callID)? onCallInvitationTimeout instead.

## 2.8.0+4

Fix known problems.

## 2.8.0+3

Fix known problems.

## 2.8.0+2

Fix known problems.

## 2.8.0+1

Fix known problems.

## 2.8.0

### 1. Feature
1、You can select the sessions that you want to view first and place them at the top of the session list.
2、Added user-defined message types. Developers can customize message types, such as vote type, relay type, and video card type, and complete message parsing. The ZIM SDK is not responsible for defining and parsing the specific content of custom messages.
3、The specified session ID is used to query details about the session.
4、By specifying several userids and Roomids, query whether the target user is in the specified room, so as to carry out business logic design, such as inviting Lianmai.You can query information about a maximum of 10 users at a time.
5、By setting the server callback, ZIM sends a request to the developer server when the user sends a single chat, group chat or room chat message. The developer can:The violation message was intercepted.Create a whitelist of users.
6、By setting the server callback, ZIM sends a request to the developer server after the user has successfully or failed to send a single chat, group chat, or room message. The developer can:Messages sent by users are recorded in real time.Collect statistics on the messages sent by users.In a live screen recording scenario, the chat record is embedded into the recorded video through the time stamp of the recorded video.
7、Support to call the server interface, specify user information (user ID, etc.), developers can implement a request, register more than one user.A maximum of 100 users can be registered at a time.
8、Support to call the server interface to obtain the ID of all groups in the App.
9、You can invoke the server interface, specify the group ID, and obtain the member list of the corresponding group.
10、Supports calling server interface, specifying group ID and user ID, batch group members.You can remove a maximum of 50 group members at a time.

### 2. Deprecated
1、ZIMMessageType discards system messages (value 30), developers are encouraged to use custom messages with more functionality (value 200) instead.
2、Since version 2.8.0, ZIM no longer supports iOS 11.0 and the developer's iOS Deployment Target (minimum support version) has been upgraded to iOS 11.0.
3、As of version 2.8.0, the ZIM iOS SDK no longer supports the 32-bit armv7 architecture.

## 2.7.1
1、Fixed some error.

## 2.7.0
### 1. Feature
1、Optimized the blank setting logic for user userName during login.
2、Optimize session message pull timing.
3、Optimize the timing of network disconnection and reconnection.

## 2.6.0+1
Fix known problems.

## 2.6.0
### 1. Feature
1、ZIMMessage adds an extendedData field that allows users to pass in information such as user avatar and nickname for real-time display when a chat session sends a message.
2、Added message status event, Developers can refine the logic of message delivery status by listening for this callback. According to the change of message status, the developer can make corresponding reminders on the UI.
3、Added callbacks related to call invitation on the server.

## 2.5.0+2
report platform type.

## 2.5.0+1
1、Fixed an extended data property naming error.
2、Fixed some windows platform convert bug.
3、zego_zim podspec add a configuration used to make bitcode disabled by default.

## 2.5.0
### 1. Feature
1、Support message return receipt.
2、Support revoke message.
3、Now call invite support  offline push(ios、android).


## 2.4.0

### 1. Feature

1、Now when sendMessage sendMediaMessage API is used, the object passed in is the same address as the object for result.
2、Support insert message in local DataBase.
3、Support set and query room member attributes like room attributes.

### 2. API Refactoring
> 💥 Please note to developers that there are breaking changes starting from version 2.4.0, so please read the following guidelines when upgrading from the old version to the new version.

sendMediaMessage have a breaking changed.

* old version usage:
```dart
Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaUploadingProgress? progress);
      ZIMMediaMessageSendNotification? notification);
```

* new version usage:
```dart
  Future<ZIMMessageSentResult> sendMediaMessage(
      ZIMMediaMessage message,
      String toConversationID,
      ZIMConversationType conversationType,
      ZIMMessageSendConfig config,
      ZIMMediaMessageSendNotification? notification);
```


## 2.3.4

- fix web platform type check compatibility issues

## 2.3.3

- Release version, update native SDK dependency version to 2.3.3

## 2.3.0

### 1. Feature

1. Support hot reload and hot restart.
2. Support the setting of user avatars, group avatars and the acquisition of conversation avatars.
3. Support to obtain the width and height information of the original image, large image and thumbnail of the image message.

### 2. Support for more platforms

* Since 2.3.0, ZIM has supported the use of macOS and Windows platforms. However, it is currently in the **Beta** version, and developers are advised to use it carefully.

### 3. API Refactoring

> 💥 Please note to developers that there are breaking changes starting from version 2.3.0, so please read the following guidelines when upgrading from the old version to the new version.

#### 1. Make `create` function from member function to static function, and changing the return value from `Future<ZIM>` to `ZIM?`. When you using ZIM, please call this API first. Also, you should remove the keyword `await`.

* old version usage:
```dart
await ZIM.getInstance().create(12345678);
```

* new version usage:
```dart
ZIMAppConfig appConfig = ZIMAppConfig();
appConfig.appID = 12345678;
appConfig.appSign = 'abcdefg...';

ZIM.create(appConfig);
```

#### 2. Change the return value of `getInstance` from `ZIM` to `ZIM?`, so you should deal with null safety. In fact, every API you need to adjust, the following only shows one of the API.

* old version usage:
```dart
await ZIM.getInstance().login(userInfo, token);
```

* new version usage:
```dart
await ZIM.getInstance()!.login(userInfo, token);
```

#### 3. Add ZIM instance param for callback. In fact, every callback you need to adjust, the following only shows one of the callback.

* old version usage:
```dart
ZIMEventHandler.onConnectionStateChanged = (state, event, extendedData) {
    // to do something...
};
```

* new version usage:
```dart
ZIMEventHandler.onConnectionStateChanged = (zim, state, event, extendedData) {
    // to do something...
};
```

#### 4. Remove unnecessary Future return values ​​from some APIs, so you don't need to `await` the retuen value. It contains [destroy] 、[logout]、[setLogConfig]、[setCacheConfig]、[beginRoomAttributesBatchOperation].

* old version usage:
```dart
await ZIM.getInstance().setLogConfig(config);
......

await ZIM.getInstance().setCacheConfig(config);
......

await ZIM.getInstance().beginRoomAttributesBatchOperation(roomID, config);
......

await ZIM.getInstance().logout();
......

await ZIM.getInstance().destroy();
......


```

* new version usage:

```dart
ZIM.setLogConfig(config);
......

ZIM.setCacheConfig(config);
......

ZIM.getInstance()!.beginRoomAttributesBatchOperation(roomID, config);
......

ZIM.getInstance()!.logout();
......

ZIM.getInstance()!.destroy();
......


```


## 2.2.3

- Release version, update native SDK dependency version to 2.2.3

## 2.2.1

- fixd renewtoken method pass token param error

## 2.2.0

- Release version, update native SDK dependency version to 2.2.1

## 2.1.6

- Release version, update native SDK dependency version to 2.1.6

## 2.1.5

- Release version, update native SDK dependency version to 2.1.5

## 2.1.2

- Fix some bug about converted, with native SDK dependency version 2.1.1

## 2.1.1

- Release version, with native SDK dependency version 2.1.1

## 0.9.0

- Test version, with native SDK dependency version 2.1.1
