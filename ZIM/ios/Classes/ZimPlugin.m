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
  else if ([@"login" isEqualToString:call.method]){
      ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
      userInfo.userID = [call.arguments objectForKey:@"userID"];
      userInfo.userName = [call.arguments objectForKey:@"userName"];
      NSString *token = [call.arguments objectForKey:@"token"];
      [zim loginWithUserInfo:userInfo token:token callback:^(ZIMError * _Nonnull errorInfo) {
          if(errorInfo.code == 0){
              NSDictionary *zimErrorDic = @{@"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
              NSDictionary *resultDic = @{@"ZIMError":zimErrorDic};
              result(resultDic);
          }else{
              result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
             
          }
      }];
  }
  else if ([@"uploadLog" isEqualToString:call.method]){
      [zim uploadLog:^(ZIMError * _Nonnull errorInfo) {
          NSDictionary *resultDic = @{@"errorCode":[NSNumber numberWithInt:(int)errorInfo.code],@"errorMessage":errorInfo.message};
          result(resultDic);
      }];
  }
  else if ([@"renewToken" isEqualToString:call.method]){
      NSString *token = [call.arguments objectForKey:@"token"];
      [zim renewToken:token callback:^(NSString * _Nonnull token, ZIMError * _Nonnull errorInfo) {
          NSDictionary *errorInfoDic = @{@"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
          NSDictionary *resultDic = @{@"token":token,@"errorInfo":errorInfoDic};
          result(resultDic);
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
    NSDictionary *resultDic = @{@"method":@"connectionStateChanged",@"state":[NSNumber numberWithInt:(int)state],@"event":[NSNumber numberWithInt:(int)event]};
    _events(resultDic);
}

@end
