#import "ZimPlugin.h"
#import <ZIM/ZIM.h>
#import <ZIM/ZIMEventHandler.h>
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
  else if ([@"destory" isEqualToString:call.method]){
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extendedData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *resultDic = @{@"method":@"onConnectionStateChanged",@"state":[NSNumber numberWithInt:(int)state],@"event":[NSNumber numberWithInt:(int)event],@"extendedData":json};
    _events(resultDic);
}

@end
