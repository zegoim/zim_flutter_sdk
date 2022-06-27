//
//  TokenPlugin.m
//  Runner
//
//  Created by 武耀琳 on 2022/6/14.
//

#import "TokenPlugin.h"
#import "ZegoServerAssistant.h"
static TokenPlugin *instance;
@interface TokenPlugin()<FlutterStreamHandler>

@property (nonatomic, strong) id<FlutterPluginRegistrar> registrar;

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;

@property (nonatomic, strong) FlutterEventSink events;

@end


@implementation TokenPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"token_plugin"
            binaryMessenger:[registrar messenger]];
    instance = [[TokenPlugin alloc] init];
    [registrar addMethodCallDelegate:(id)instance channel:channel];
    instance.methodChannel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"makeToken" isEqualToString:call.method]){
        unsigned int appID = [[call.arguments objectForKey:@"appID"] unsignedIntValue];
        NSString *userID = [call.arguments objectForKey:@"userID"];
        NSString *secret = [call.arguments objectForKey:@"secret"];
        auto tokenResult = ZEGO::SERVER_ASSISTANT::ZegoServerAssistant::GenerateToken(appID, userID.UTF8String,secret.UTF8String, 3600*24*24);
        NSString *token = [NSString stringWithCString:tokenResult.token.c_str() encoding:[NSString defaultCStringEncoding]];
        result(@{@"token":token});
        
    }
}
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.events = nil;
    
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    
    self.events = events;
    
    return nil;
}

@end
