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
