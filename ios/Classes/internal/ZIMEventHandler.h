//
//  ZIMEventHandler.h
//  Pods
//
//  Created by lizhanpeng on 2022/7/25.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZIMEventHandler : NSObject <ZIMEventHandler>

@property (nonatomic, strong) NSMapTable<ZIM *, NSString *> *engineEventMap;

+ (instancetype)sharedInstance;
- (void)setEventSinks:(nullable FlutterEventSink)sink;

@end

NS_ASSUME_NONNULL_END
