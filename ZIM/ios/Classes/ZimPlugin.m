#import "ZimPlugin.h"
#import <ZIM/ZIM.h>
#import <ZIM/ZIMEventHandler.h>
#import "ZIMPluginConverter.h"
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
static ZIM *zim;
@interface ZimPlugin()<ZIMEventHandler,FlutterStreamHandler>

@property (nonatomic, strong) id<FlutterPluginRegistrar> registrar;

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;

@property (nonatomic, strong) FlutterEventSink events;

@end

@implementation ZimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zim"
            binaryMessenger:[registrar messenger]];
    ZimPlugin* instance = [[ZimPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.methodChannel = channel;

    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"zim_event_handler" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:(id)instance];
    instance.eventChannel = eventChannel;
    
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    self.events = events;
    
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.events = nil;
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getVersion" isEqualToString:call.method]){
      result([ZIM getVersion]);
  }
  else if ([@"create" isEqualToString:call.method]){
      unsigned int AppID = [[call.arguments objectForKey:@"appID"] unsignedIntValue];
      zim = [ZIM createWithAppID:AppID];
      [zim setEventHandler:self];
      result(nil);
  }
  else if ([@"destroy" isEqualToString:call.method]){
      [zim destroy];
      zim = nil;
      result(nil);
  }
  else if ([@"setLogConfig" isEqualToString:call.method]){
      ZIMLogConfig *logConfig = [[ZIMLogConfig alloc] init];
      logConfig.logPath = [call.arguments objectForKey:@"logPath"];
      logConfig.logSize = [[call.arguments objectForKey:@"logSize"] unsignedLongLongValue];
      [ZIM setLogConfig:logConfig];
      result(nil);
  }
  else if ([@"setCacheConfig" isEqualToString:call.method]){
      ZIMCacheConfig *cacheConfig = [[ZIMCacheConfig alloc] init];
      cacheConfig.cachePath = [call.arguments objectForKey:@"cachePath"];
      [ZIM setCacheConfig:cacheConfig];
      result(nil);
  }
  else if ([@"login" isEqualToString:call.method]){
      ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
      userInfo.userID = [call.arguments objectForKey:@"userID"];
      userInfo.userName = [call.arguments objectForKey:@"userName"];
      NSString *token = [call.arguments objectForKey:@"token"];
      [zim loginWithUserInfo:userInfo token:token callback:^(ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              result(nil);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"logout" isEqualToString:call.method]){
      [zim logout];
      result(nil);
  }
  else if ([@"uploadLog" isEqualToString:call.method]){
      [zim uploadLog:^(ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              result(nil);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"renewToken" isEqualToString:call.method]){
      NSString *token = [call.arguments objectForKey:@"token"];
      [zim renewToken:token callback:^(NSString * _Nonnull token, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"token":token};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryUsersInfo" isEqualToString:call.method]){
      NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
      [zim queryUsersInfo:userIDs callback:^(NSArray<ZIMUserInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableArray *userListBasic = [[NSMutableArray alloc] init];
              for (ZIMUserInfo *userInfo in userList) {
                  NSDictionary *userInfoDic = @{@"userID":userInfo.userID,@"userName":userInfo.userName};
                  [userListBasic addObject:userInfoDic];
              }
              NSMutableArray *errorUserListBasic = [[NSMutableArray alloc] init];
              for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                  NSDictionary *errorUserInfoDic = @{@"userID":errorUserInfo.userID,@"reason":[NSNumber numberWithUnsignedInt:errorUserInfo.reason]};
                  [errorUserListBasic addObject:errorUserInfoDic];
              }
              NSDictionary *resultDic = @{@"userList":userListBasic,@"errorUserList":errorUserList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryConversationList" isEqualToString:call.method]){
      NSDictionary *configDic = [call.arguments objectForKey:@"config"];
      ZIMConversationQueryConfig *config = [[ZIMConversationQueryConfig alloc] init];
      config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
      config.nextConversation = [ZIMPluginConverter cnvZIMConversationDicToObject:(NSDictionary *)[configDic objectForKey:@"nextConversation"]];
      [zim queryConversationListWithConfig:config callback:^(NSArray<ZIMConversation *> * _Nonnull conversationList, ZIMError * _Nonnull errorInfo)  {
          if(errorInfo.code == 0){
              NSArray *conversationBasicList = [ZIMPluginConverter cnvZIMConversationListObjectToBasic:conversationList];
              NSDictionary *resultDic = @{@"conversationList":conversationBasicList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"deleteConversation" isEqualToString:call.method]){
      NSString *conversationID = [call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      ZIMConversationDeleteConfig *deleteConfig = [ZIMPluginConverter cnvZIMConversationDeleteConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim deleteConversation:conversationID conversationType:conversationType config:deleteConfig callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
      
  }
  else if ([@"clearConversationUnreadMessageCount" isEqualToString:call.method]){
      NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      [zim clearConversationUnreadMessageCount:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"setConversationNotificationStatus" isEqualToString: call.method]){
      
      int status = ((NSNumber *)[call.arguments objectForKey:@"status"]).intValue;
      NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      
      [zim setConversationNotificationStatus:status conversationID:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"sendPeerMessage" isEqualToString:call.method]){
      ZIMMessage *message = [ZIMPluginConverter cnvZIMMessageDicToObject:[call.arguments objectForKey:@"message"]];
      NSString *toUserID = (NSString *)[call.arguments objectForKey:@"toUserID"];
      ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter cnvZIMMessageSendConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim sendPeerMessage:message toUserID:toUserID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
              NSDictionary *resultDic = @{@"message":messageDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"sendRoomMessage" isEqualToString:call.method]){
      ZIMMessage *message = [ZIMPluginConverter cnvZIMMessageDicToObject:[call.arguments objectForKey:@"message"]];
      NSString *toRoomID = (NSString *)[call.arguments objectForKey:@"toRoomID"];
      ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter cnvZIMMessageSendConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim sendRoomMessage:message toRoomID:toRoomID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
              NSDictionary *resultDic = @{@"message":messageDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"sendGroupMessage" isEqualToString:call.method]){
      ZIMMessage *message = [ZIMPluginConverter cnvZIMMessageDicToObject:[call.arguments safeObjectForKey:@"message"]];
      NSString *toGroupID = (NSString *)[call.arguments objectForKey:@"toGroupID"];
      ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter cnvZIMMessageSendConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim sendGroupMesage:message toGroupID:toGroupID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
              NSDictionary *resultDic = @{@"message":messageDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"sendMediaMessage" isEqualToString:call.method]){
      ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter cnvZIMMessageDicToObject:[call.arguments safeObjectForKey:@"message"]];
      NSString *toConversationID = [call.arguments safeObjectForKey:@"toConversationID"];
      int conversationType = ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
      ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter cnvZIMMessageSendConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      NSString *progressID = [call.arguments safeObjectForKey:@"progressID"];
      [zim sendMediaMessage:message toConversationID:toConversationID conversationType:conversationType config:sendConfig progress:^(ZIMMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
          if(progressID == nil){
              return;
          }
          NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
          
          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:@"uploadMediaProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:messageDic forKey:@"message"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize] forKey:@"currentFileSize"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize] forKey:@"totalFileSize"];
          self.events(resultDic);
      } callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
              [resultMtDic safeSetObject:messageDic forKey:@"message"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"downloadMediaFile" isEqualToString:call.method]){
      ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter cnvZIMMessageDicToObject:[call.arguments safeObjectForKey:@"message"]];
      int fileType = ((NSNumber *)[call.arguments safeObjectForKey:@"fileType"]).intValue;
      NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];

      [zim downloadMediaFileWithMessage:message  fileType:fileType progress:^(ZIMMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
          if(progressID == nil){
              return;
          }
          NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
          
          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:@"downloadMediaFileProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:messageDic forKey:@"message"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize] forKey:@"currentFileSize"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize] forKey:@"totalFileSize"];
          self.events(resultDic);
      } callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              NSDictionary *messageDic = [ZIMPluginConverter cnvZIMMessageObjectToDic:message];
              [resultMtDic safeSetObject:messageDic forKey:@"message"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryHistoryMessage" isEqualToString:call.method]){
      NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      ZIMMessageQueryConfig *queryConfig = [ZIMPluginConverter cnvZIMMessageQueryConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim queryHistoryMessageByConversationID:conversationID conversationType:conversationType config:queryConfig callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<ZIMMessage *> * _Nonnull messageList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *MsgDicList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
              
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType],@"messageList":MsgDicList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"deleteAllMessage" isEqualToString:call.method]){
      
      NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      ZIMMessageDeleteConfig *deleteConfig = [ZIMPluginConverter cnvZIMMessageDeleteConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim deleteAllMessageByConversationID:conversationID conversationType:conversationType config:deleteConfig callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"deleteMessages" isEqualToString:call.method]){
      NSArray *messageList = [ZIMPluginConverter cnvBasicListToZIMMessageList:[call.arguments objectForKey:@"messageList"]];
      NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
      int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
      ZIMMessageDeleteConfig *deleteConfig = [ZIMPluginConverter cnvZIMMessageDeleteConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim deleteMessages:messageList conversationID:conversationID conversationType:conversationType config:deleteConfig callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"createRoom" isEqualToString:call.method]){
      ZIMRoomInfo *roomInfo = [ZIMPluginConverter cnvZIMRoomInfoBasicToObject:[call.arguments objectForKey:@"roomInfo"]];
      
      [zim createRoom:roomInfo callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *roomInfoDic = [ZIMPluginConverter cnvZIMRoomFullInfoObjectToDic:roomInfo];
              NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"createRoomWithConfig" isEqualToString:call.method]){
      ZIMRoomInfo *roomInfo = [ZIMPluginConverter cnvZIMRoomInfoBasicToObject:[call.arguments objectForKey:@"roomInfo"]];
      ZIMRoomAdvancedConfig *config = [ZIMPluginConverter cnvZIMRoomAdvancedConfigDicToObject:[call.arguments objectForKey:@"config"]];
      
      [zim createRoom:roomInfo config:config callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *roomInfoDic = [ZIMPluginConverter cnvZIMRoomFullInfoObjectToDic:roomInfo];
              NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"joinRoom" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      [zim joinRoom:roomID callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *roomInfoDic = [ZIMPluginConverter cnvZIMRoomFullInfoObjectToDic:roomInfo];
              NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"leaveRoom" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      [zim leaveRoom:roomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryRoomMemberList" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      
      ZIMRoomMemberQueryConfig *config = [ZIMPluginConverter cnvZIMRoomMemberQueryConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim queryRoomMemberListByRoomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<ZIMUserInfo *> * _Nonnull memberList, NSString * _Nonnull nextFlag, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *basicMemberList = [ZIMPluginConverter cnvZIMUserInfoListTobasicList:memberList];
              NSDictionary *resultDic = @{@"memberList":basicMemberList,@"nextFlag":nextFlag};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryRoomOnlineMemberCount" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      
      [zim queryRoomOnlineMemberCountByRoomID:roomID callback:^(NSString * _Nonnull roomID, unsigned int count, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID,@"count":[NSNumber numberWithUnsignedInt:count]};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"setRoomAttributes" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      NSDictionary<NSString *,NSString *> *roomAttributes = [call.arguments objectForKey:@"roomAttributes"];
      ZIMRoomAttributesSetConfig *setConfig = [ZIMPluginConverter cnvZIMRoomAttributesSetConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim setRoomAttributes:roomAttributes roomID:roomID config:setConfig callback:^(NSString * _Nonnull roomID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID,@"errorKeys":errorKeys};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"deleteRoomAttributes" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      NSArray<NSString *> *keys = [call.arguments objectForKey:@"keys"];
      ZIMRoomAttributesDeleteConfig *config = [ZIMPluginConverter cnvZIMRoomAttributesDeleteConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim deleteRoomAttributesByKeys:keys roomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID,@"errorKeys":errorKeys};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"beginRoomAttributesBatchOperation" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      ZIMRoomAttributesBatchOperationConfig *config = [ZIMPluginConverter cnvZIMRoomAttributesBatchOperationConfigDicToObject:[call.arguments objectForKey:@"config"]];
      
      [zim beginRoomAttributesBatchOperationWithRoomID:roomID config:config];
      result(nil);
  }
  else if ([@"endRoomAttributesBatchOperation" isEqualToString:call.method]){
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      
      [zim endRoomAttributesBatchOperationWithRoomID:roomID callback:^(NSString * _Nonnull roomID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryRoomAllAttributes" isEqualToString:call.method]){
      
      NSString *roomID = [call.arguments objectForKey:@"roomID"];
      
      [zim queryRoomAllAttributesByRoomID:roomID callback:^(NSString * _Nonnull roomID, NSDictionary<NSString *,NSString *> * _Nonnull roomAttributes, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"roomID":roomID,@"roomAttributes":roomAttributes};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  
  else if ([@"createGroup" isEqualToString:call.method]){
      
      ZIMGroupInfo *groupInfo = [ZIMPluginConverter cnvZIMGroupInfoDicToObject:[call.arguments objectForKey:@"groupInfo"]];
      NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
      [zim createGroup:groupInfo userIDs:userIDs callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *basicUserList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
              NSArray *basicErrorUserList = [ZIMPluginConverter cnvZIMErrorUserInfoListToBasicList:errorUserList];
              NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
              NSDictionary *resultDic = @{@"groupInfo":groupInfoDic,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
    
  else if ([@"createGroupWithConfig" isEqualToString:call.method]){
      ZIMGroupInfo *groupInfo = [ZIMPluginConverter cnvZIMGroupInfoDicToObject:[call.arguments objectForKey:@"groupInfo"]];
      NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
      
      ZIMGroupAdvancedConfig *config = [ZIMPluginConverter cnvZIMGroupAdvancedConfigDicToObject:[call.arguments objectForKey:@"config"]];
      [zim createGroup:groupInfo userIDs:userIDs config:config callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *basicUserList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
              NSArray *basicErrorUserList = [ZIMPluginConverter cnvZIMErrorUserInfoListToBasicList:errorUserList];
              NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
              NSDictionary *resultDic = @{@"groupInfo":groupInfoDic,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"joinGroup" isEqualToString:call.method]){
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim joinGroup:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
              NSDictionary *resultDic = @{@"groupInfo":groupInfoDic};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"dismissGroup" isEqualToString:call.method]){
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim dismissGroup:groupID callback:^(NSString * _Nonnull groupID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"groupID":groupID};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"leaveGroup" isEqualToString:call.method]){
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim leaveGroup:groupID callback:^(NSString * _Nonnull groupID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"groupID":groupID};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"inviteUsersIntoGroup" isEqualToString:call.method]){
      NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim inviteUsersIntoGroup:userIDs groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *basicUserList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
              NSArray *basicErrorUserList = [ZIMPluginConverter cnvZIMErrorUserInfoListToBasicList:errorUserList];

              NSDictionary *resultDic = @{@"groupID":groupID,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"kickGroupMembers" isEqualToString:call.method]){
      NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim kickGroupMembers:userIDs groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull kickedUserIDList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              
              
              NSArray *basicErrorUserList = [ZIMPluginConverter cnvZIMErrorUserInfoListToBasicList:errorUserList];
              NSDictionary *resultDic = @{@"groupID":groupID,@"kickedUserIDList":kickedUserIDList,@"errorUserList":basicErrorUserList};
              result(resultDic);
              
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"transferGroupOwner" isEqualToString:call.method]){
      NSString *userID = [call.arguments objectForKey:@"userID"];
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim transferGroupOwnerToUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull toUserID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"groupID":groupID,@"toUserID":toUserID};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"updateGroupName" isEqualToString:call.method]){
      NSString *groupName = [call.arguments objectForKey:@"groupName"];
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim updateGroupName:groupName groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupName, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"groupID":groupID,@"groupName":groupName};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"updateGroupNotice" isEqualToString:call.method]){
      NSString *groupNotice = [call.arguments objectForKey:@"groupNotice"];
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim updateGroupNotice:groupNotice groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupNotice, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *resultDic = @{@"groupID":groupID,@"groupNotice":groupNotice};
              result(resultDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupInfo" isEqualToString:call.method]){
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      [zim queryGroupInfoByGroupID:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"setGroupAttributes" isEqualToString:call.method]){
      NSString *groupID = [call.arguments objectForKey:@"groupID"];
      NSDictionary *groupAttributes = [call.arguments objectForKey:@"groupAttributes"];
      [zim setGroupAttributes:groupAttributes groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:errorKeys forKey:@"errorKeys"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"deleteGroupAttributes" isEqualToString:call.method]){
      
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      NSArray *keys = [call.arguments safeObjectForKey:@"keys"];
      [zim deleteGroupAttributesByKeys:keys groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull errorKeys, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:errorKeys forKey:@"errorKeys"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupAttributes" isEqualToString:call.method]){
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      NSArray *keys = [call.arguments safeObjectForKey:@"keys"];
      [zim queryGroupAttributesByKeys:keys groupID:groupID callback:^(NSString * _Nonnull groupID, NSDictionary<NSString *,NSString *> * _Nonnull groupAttributes, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:groupAttributes forKey:@"groupAttributes"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupAllAttributes" isEqualToString:call.method]){
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      [zim queryGroupAllAttributesByGroupID:groupID callback:^(NSString * _Nonnull groupID, NSDictionary<NSString *,NSString *> * _Nonnull groupAttributes, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:groupAttributes forKey:@"groupAttributes"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"setGroupMemberRole" isEqualToString:call.method]){
      
      ZIMGroupMemberRole role = ((NSNumber *)[call.arguments safeObjectForKey:@"role"]).intValue;
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];

      NSString *forUserID = [call.arguments safeObjectForKey:@"forUserID"];
      [zim setGroupMemberRole:role forUserID:forUserID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull forUserID, ZIMGroupMemberRole role, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:forUserID forKey:@"forUserID"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"setGroupMemberNickname" isEqualToString:call.method]){
      
      NSString *nickname = [call.arguments safeObjectForKey:@"nickname"];
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      NSString *forUserID = [call.arguments safeObjectForKey:@"forUserID"];
      [zim setGroupMemberNickname:nickname forUserID:forUserID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull forUserID, NSString * _Nonnull nickname, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:forUserID forKey:@"forUserID"];
              [resultMtDic safeSetObject:nickname forKey:@"nickname"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupMemberInfo" isEqualToString:call.method]){
      NSString *userID = [call.arguments safeObjectForKey:@"userID"];
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      [zim queryGroupMemberInfoByUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, ZIMGroupMemberInfo * _Nonnull userInfo, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *userInfoDic = [ZIMPluginConverter cnvZIMGroupMemberInfoObjectToDic:userInfo];
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:userInfoDic forKey:@"userInfo"];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupList" isEqualToString:call.method]){
      [zim queryGroupList:^(NSArray<ZIMGroup *> * _Nonnull groupList, ZIMError * _Nonnull errorInfo) {
          if (errorInfo.code == 0) {
              NSArray *basicGroupList = [ZIMPluginConverter cnvZIMGroupListToBasicList:groupList];
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:basicGroupList forKey:@"groupList"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"queryGroupMemberList" isEqualToString:call.method]){
      NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
      ZIMGroupMemberQueryConfig *config = [ZIMPluginConverter cnvZIMGroupMemberQueryConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      [zim queryGroupMemberListByGroupID:groupID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSArray *basicUserList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
              
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:groupID forKey:@"groupID"];
              [resultMtDic safeSetObject:basicUserList forKey:@"userList"];
              [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag] forKey:@"nextFlag"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"callInvite" isEqualToString:call.method]){
      NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
      ZIMCallInviteConfig *config = [ZIMPluginConverter cnvZIMCallInviteConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      [zim callInviteWithInvitees:invitees config:config callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:callID forKey:@"callID"];
              NSDictionary *infoDic = [ZIMPluginConverter cnvZIMCallInvitationSentInfoObjectToDic:info];
              [resultMtDic safeSetObject:infoDic forKey:@"info"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"callCancel" isEqualToString:call.method]){
      NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
      NSString *callID = [call.arguments safeObjectForKey:@"callID"];
      ZIMCallCancelConfig *config = [ZIMPluginConverter cnvZIMCallCancelConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      [zim callCancelWithInvitees:invitees callID:callID config:config callback:^(NSString * _Nonnull callID, NSArray<NSString *> * _Nonnull errorInvitees, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:callID forKey:@"callID"];
              [resultMtDic safeSetObject:errorInvitees forKey:@"errorInvitees"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"callAccept" isEqualToString:call.method]){
      NSString *callID = [call.arguments safeObjectForKey:@"callID"];
      ZIMCallAcceptConfig *config = [ZIMPluginConverter cnvZIMCallAcceptConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      
      [zim callAcceptWithCallID:callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:callID forKey:@"callID"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else if ([@"callReject" isEqualToString:call.method]){
      NSString *callID = [call.arguments safeObjectForKey:@"callID"];
      ZIMCallRejectConfig *config = [ZIMPluginConverter cnvZIMCallRejectConfigDicToObject:[call.arguments safeObjectForKey:@"config"]];
      [zim callRejectWithCallID:callID config:config callback:^(NSString * _Nonnull callID, ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:callID forKey:@"callID"];
              result(resultMtDic);
          }
          else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
          }
      }];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}


//MARK: - ZIMEventHandler

- (void)zim:(ZIM *)zim
    connectionStateChanged:(ZIMConnectionState)state
                     event:(ZIMConnectionEvent)event
extendedData:(NSDictionary *)extendedData{
    if(_events == nil){
        return;
    }
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extendedData options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSDictionary *resultDic = @{@"method":@"onConnectionStateChanged",@"state":[NSNumber numberWithInt:(int)state],@"event":[NSNumber numberWithInt:(int)event]};
    NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
    [resultMtDic safeSetObject:extendedData forKey:@"extendedData"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim errorInfo:(ZIMError *)errorInfo{
    if(_events == nil){
        return;
    }
    
    NSDictionary *resultDic = @{@"method":@"onError",@"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim tokenWillExpire:(unsigned int)second{
    if(_events == nil){
        return;
    }
    
    NSDictionary *resultDic = @{@"method":@"onTokenWillExpire",@"second":[NSNumber numberWithUnsignedInt:second]};
    _events(resultDic);
}

// MARK: Conversation
- (void)zim:(ZIM *)zim
conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    if(_events == nil){
        return;
    }
    NSArray *basicList = [ZIMPluginConverter cnvConversationChangeInfoListToBasicList:conversationChangeInfoList];
    NSDictionary *resultDic = @{@"method":@"onConversationChanged",@"conversationChangeInfoList":basicList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount{
    if(_events == nil){
        return;
    }
    NSDictionary *resultDic = @{@"method":@"onConversationTotalUnreadMessageCountUpdated",@"totalUnreadMessageCount":[NSNumber numberWithUnsignedInt:totalUnreadMessageCount]};
    _events(resultDic);
}

// MARK: Message

- (void)zim:(ZIM *)zim
    receivePeerMessage:(NSArray<ZIMMessage *> *)messageList
 fromUserID:(NSString *)fromUserID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceivePeerMessage",@"messageList":basicMessageList,@"fromUserID":fromUserID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList
 fromRoomID:(NSString *)fromRoomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveRoomMessage",@"messageList":basicMessageList,@"fromRoomID":fromRoomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList
fromGroupID:(NSString *)fromGroupID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveGroupMessage",@"messageList":basicMessageList,@"fromGroupID":fromGroupID};
    _events(resultDic);
}

// MARK: Room
- (void)zim:(ZIM *)zim
    roomMemberJoined:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMemberList = [ZIMPluginConverter cnvZIMUserInfoListTobasicList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberJoined",@"roomID":roomID,@"memberList":basicMemberList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomMemberLeft:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMemberList = [ZIMPluginConverter cnvZIMUserInfoListTobasicList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberLeft",@"roomID":roomID,@"memberList":basicMemberList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomStateChanged:(ZIMRoomState)state
               event:(ZIMRoomEvent)event
        extendedData:(NSDictionary *)extendedData
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSDictionary *resultDic = @{@"method":@"onRoomStateChanged",@"state":[NSNumber numberWithInt:(int)state],@"event":[NSNumber numberWithInt:(int)event],@"extendedData":extendedData};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomAttributesUpdated:(ZIMRoomAttributesUpdateInfo *)updateInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSDictionary *updateInfoDic = [ZIMPluginConverter cnvZIMRoomAttributesUpdateInfoObjectToDic:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesUpdated",@"updateInfo":updateInfoDic,@"roomID":roomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomAttributesBatchUpdated:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicUpdateInfoList = [ZIMPluginConverter cnvZIMRoomAttributesUpdateInfoListToBasicList:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesBatchUpdated",@"updateInfo":basicUpdateInfoList,@"roomID":roomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupStateChanged:(ZIMGroupState)state
                event:(ZIMGroupEvent)event
         operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
  groupInfo:(ZIMGroupFullInfo *)groupInfo{
    if(_events == nil){
        return;
    }
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
    [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupNameUpdated:(NSString *)groupName
        operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupName forKey:@"groupName"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupNoticeUpdated:(NSString *)groupNotice
          operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupNotice forKey:@"groupNotice"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupAttributesUpdated:(NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSArray *updateInfoArr = [ZIMPluginConverter cnvZIMGroupAttributesUpdateInfoListToBasicList:updateInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:updateInfoArr forKey:@"updateInfo"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupMemberStateChanged:(ZIMGroupMemberState)state
                      event:(ZIMGroupMemberEvent)event
                   userList:(NSArray<ZIMGroupMemberInfo *> *)userList
               operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSArray *userListArr = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:userListArr forKey:@"userList"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupMemberInfoUpdated:(NSArray<ZIMGroupMemberInfo *> *)userInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    NSArray *basicUserInfoList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userInfo];
    [resultDic safeSetObject:basicUserInfoList forKey:@"userInfo"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *callInvitationReceivedInfoDic = [[NSMutableDictionary alloc] init];
    [callInvitationReceivedInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [callInvitationReceivedInfoDic safeSetObject:info.inviter forKey:@"inviter"];
    [callInvitationReceivedInfoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationReceived" forKey:@"method"];
    [resultDic safeSetObject:callInvitationReceivedInfoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationCancelled:(ZIMCallInvitationCancelledInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.inviter forKey:@"inviter"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationCancelled" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationAccepted:(ZIMCallInvitationAcceptedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationAccepted" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationRejected:(ZIMCallInvitationRejectedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationRejected" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim callInvitationTimeout:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInvitationTimeout" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInviteesAnsweredTimeout:(NSArray<NSString *> *)invitees
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInviteesAnsweredTimeout" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:invitees forKey:@"invitees"];
    _events(resultDic);
}
@end
