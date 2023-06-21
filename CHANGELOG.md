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
