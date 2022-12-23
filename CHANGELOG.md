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
