#import "ZimPlugin.h"
#import <ZIM/ZIM.h>
static ZIM *zim;
@interface ZimPlugin()


@end

@implementation ZimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zim"
            binaryMessenger:[registrar messenger]];
  ZimPlugin* instance = [[ZimPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getVersion" isEqualToString:call.method]){
      result([ZIM getVersion]);
  }
  else if ([@"create" isEqualToString:call.method]){
      unsigned int AppID = [[call.arguments objectForKey:@"AppID"] unsignedIntValue];
      zim = [ZIM createWithAppID:AppID];
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
          NSDictionary *zimErrorDic = @{@"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
          NSDictionary *resultDic = @{@"ZIMError":zimErrorDic};
          result(resultDic);
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

@end
