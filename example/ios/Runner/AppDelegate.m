#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "TokenPlugin.h"

@interface AppDelegate () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// methodChannel
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [TokenPlugin registerWithRegistrar:[self registrarForPlugin:@"TokenPlugin"]];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
