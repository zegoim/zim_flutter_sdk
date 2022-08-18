#import "ZegoZimPlugin.h"
#import <ZIM/ZIM.h>
#import <ZIM/ZIMEventHandler.h>
#import "ZIMPluginConverter.h"
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
#import "ZIMMethodHandler.h"
#import "ZIMEventHandler.h"

static ZIM *zim;

static ZegoZimPlugin *instance;
@interface ZegoZimPlugin()<ZIMEventHandler,FlutterStreamHandler>

@property (nonatomic, strong) id<FlutterPluginRegistrar> registrar;

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;

@end

@implementation ZegoZimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_zim_plugin"
            binaryMessenger:[registrar messenger]];
    instance = [[ZegoZimPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.methodChannel = channel;
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"zim_event_handler" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    instance.eventChannel = eventChannel;
    
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    [[ZIMMethodHandler sharedInstance] setEventSinks:events];
    [[ZIMEventHandler sharedInstance] setEventSinks:events];
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    //self.events = nil;
    [[ZIMMethodHandler sharedInstance] setEventSinks:nil];
    [[ZIMEventHandler sharedInstance] setEventSinks:nil];
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:result:", call.method]);
    
    if (![[ZIMMethodHandler sharedInstance] respondsToSelector:selector]) {
        result(FlutterMethodNotImplemented);
        return;
    }
    
    NSMethodSignature *signature = [[ZIMMethodHandler sharedInstance] methodSignatureForSelector:selector];

    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];

    invocation.target = [ZIMMethodHandler sharedInstance];
    invocation.selector = selector;

    [invocation setArgument:&call atIndex:2];
    [invocation setArgument:&result atIndex:3];

    [invocation invoke];
    
}

@end
