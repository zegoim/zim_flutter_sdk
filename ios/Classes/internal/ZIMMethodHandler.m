//
//  ZIMMethodHandler.m
//  zego_zim
//
//  Created by lizhanpeng on 2022/7/25.
//

#import "ZIMMethodHandler.h"
#import "NSArray+Log.h"
#import "NSDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSObject+safeInvoke.h"
#import "ZIMEventHandler.h"
#import "ZIMPluginConverter.h"

@interface ZIMMethodHandler ()

@property (nonatomic, strong) FlutterEventSink events;

@property (nonatomic, strong) NSMutableDictionary<NSString *, ZIM *> *engineMap;

@end

@implementation ZIMMethodHandler

- (void)setEventSinks:(FlutterEventSink)sink {
    self.events = sink;
}

+ (instancetype)sharedInstance {
    static ZIMMethodHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[ZIMMethodHandler alloc] init];
    });
    return instance;
}

- (void)getVersion:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([ZIM getVersion]);
}

- (void)create:(FlutterMethodCall *)call result:(FlutterResult)result {
    ZIM *oldZIM = [ZIM getInstance];
    if (oldZIM) {
        [oldZIM destroy];
    }
    NSString *handle = [call.arguments objectForKey:@"handle"];

    [ZIM setAdvancedConfigWithKey:@"zim_cross_platform" value:@"flutter"];
    NSDictionary *appConfigDic = [call.arguments objectForKey:@"config"];
    ZIMAppConfig *appConfig = [ZIMPluginConverter oZIMAppConfig:appConfigDic];
    ZIM *zim = [ZIM createWithAppConfig:appConfig];
    if (zim) {
        [self.engineMap safeSetObject:zim forKey:handle];
        [[ZIMEventHandler sharedInstance].engineEventMap setObject:handle forKey:zim];
        [zim setEventHandler:[ZIMEventHandler sharedInstance]];
    }
    result(nil);
}

- (void)destroy:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (zim) {
        [zim destroy];
        [self.engineMap removeObjectForKey:handle];
        [[ZIMEventHandler sharedInstance].engineEventMap removeObjectForKey:zim];
    }

    result(nil);
}

- (void)setLogConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    ZIMLogConfig *logConfig = [[ZIMLogConfig alloc] init];
    logConfig.logPath = [call.arguments objectForKey:@"logPath"];
    logConfig.logSize = [[call.arguments objectForKey:@"logSize"] unsignedLongLongValue];
    [ZIM setLogConfig:logConfig];
    result(nil);
}

- (void)setCacheConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    ZIMCacheConfig *cacheConfig = [[ZIMCacheConfig alloc] init];
    cacheConfig.cachePath = [call.arguments objectForKey:@"cachePath"];
    [ZIM setCacheConfig:cacheConfig];
    result(nil);
}

- (void)setAdvancedConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *key = [call.arguments objectForKey:@"key"];
    NSString *value = [call.arguments objectForKey:@"value"];
    [ZIM setAdvancedConfigWithKey:key value:value];
    result(nil);
}

- (void)setGeofencingConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSArray<NSNumber *> *areaList = [call.arguments objectForKey:@"areaList"];
    ZIMGeofencingType type = [[call.arguments objectForKey:@"type"] integerValue];
    BOOL callback = [ZIM setGeofencingConfigWithAreaList:areaList type:type];
    result([NSNumber numberWithBool:callback]);
}

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *userID = [call.arguments objectForKey:@"userID"];
    ZIMLoginConfig *loginConfig =
        [ZIMPluginConverter oZIMLoginConfig:[call.arguments objectForKey:@"config"]];

    [zim loginWithUserID:userID
                  config:loginConfig
                callback:^(ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      result(nil);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    [zim logout];
    result(nil);
}

- (void)uploadLog:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    [zim uploadLog:^(ZIMError *_Nonnull errorInfo) {
      if (errorInfo.code == 0) {
          result(nil);
      } else {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
      }
    }];
}

- (void)renewToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputToken = [call.arguments objectForKey:@"token"];
    [zim renewToken:inputToken
           callback:^(NSString *_Nonnull token, ZIMError *_Nonnull errorInfo) {
             if (errorInfo.code == 0) {
                 NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                 [resultDic safeSetObject:token forKey:@"token"];
                 result(resultDic);
             } else {
                 result([FlutterError
                     errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                           message:errorInfo.message
                           details:nil]);
             }
           }];
}

- (void)updateUserName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputUserName = [call.arguments objectForKey:@"userName"];
    [zim updateUserName:inputUserName
               callback:^(NSString *_Nonnull userName, ZIMError *_Nonnull errorInfo) {
                 if (errorInfo.code == 0) {
                     NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                     [resultDic safeSetObject:userName forKey:@"userName"];
                     result(resultDic);
                 } else {
                     result([FlutterError
                         errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                               message:errorInfo.message
                               details:nil]);
                 }
               }];
}

- (void)updateUserAvatarUrl:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *updateUserAvatarUrl = [call.arguments objectForKey:@"userAvatarUrl"];
    [zim updateUserAvatarUrl:updateUserAvatarUrl
                    callback:^(NSString *_Nonnull userAvatarUrl, ZIMError *_Nonnull errorInfo) {
                      if (errorInfo.code == 0) {
                          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                          [resultDic safeSetObject:userAvatarUrl forKey:@"userAvatarUrl"];
                          result(resultDic);
                      } else {
                          result([FlutterError
                              errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                    message:errorInfo.message
                                    details:nil]);
                      }
                    }];
}

- (void)updateUserExtendedData:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *updateUserExtendedData = [call.arguments objectForKey:@"extendedData"];
    [zim
        updateUserExtendedData:updateUserExtendedData
                      callback:^(NSString *_Nonnull extendedData, ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic safeSetObject:extendedData forKey:@"extendedData"];
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)updateUserOfflinePushRule:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMUserOfflinePushRule *offlinePushRule = [ZIMPluginConverter
        oZIMUserOfflinePushRule:[call.arguments objectForKey:@"offlinePushRule"]];

    [zim updateUserOfflinePushRule:offlinePushRule
                          callback:^(ZIMUserOfflinePushRule *_Nonnull offlinePushRule,
                                     ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                                [resultDic
                                    safeSetObject:[ZIMPluginConverter
                                                      mZIMUserOfflinePushRule:offlinePushRule]
                                           forKey:@"offlinePushRule"];
                                result(resultDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)queryUsersStatus:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim queryUsersStatusByUserIDs:userIDs
                          callback:^(NSArray<ZIMUserStatus *> *_Nonnull userStatusList,
                                     NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                     ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                                [resultDic
                                    setObject:[ZIMPluginConverter mZIMUserStatusList:userStatusList]
                                       forKey:@"userStatusList"];
                                [resultDic setObject:[ZIMPluginConverter
                                                         mZIMErrorUserInfoList:errorUserList]
                                              forKey:@"errorUserList"];
                                result(resultDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)subscribeUsersStatus:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    ZIMUserStatusSubscribeConfig *config =
        [ZIMPluginConverter oZIMUserStatusSubscribeConfig:[call.arguments objectForKey:@"config"]];
    [zim subscribeUsersStatus:userIDs
                       config:config
                     callback:^(NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                ZIMError *_Nonnull errorInfo) {
                       if (errorInfo.code == 0) {
                           NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                           [resultDic
                               setObject:[ZIMPluginConverter mZIMErrorUserInfoList:errorUserList]
                                  forKey:@"errorUserList"];
                           result(resultDic);
                       } else {
                           result([FlutterError
                               errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
                       }
                     }];
}

- (void)unsubscribeUsersStatus:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim
        unsubscribeUsersStatus:userIDs
                      callback:^(NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic
                                setObject:[ZIMPluginConverter mZIMErrorUserInfoList:errorUserList]
                                   forKey:@"errorUserList"];
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)querySubscribedUserStatusList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMSubscribedUserStatusQueryConfig *config = [ZIMPluginConverter
        oZIMSubscribedUserStatusQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim querySubscribedUserStatusListWithConfig:config
                                        callback:^(NSArray<ZIMUserStatusSubscription *>
                                                       *_Nonnull userStatusSubscriptionList,
                                                   ZIMError *_Nonnull errorInfo) {
                                          if (errorInfo.code == 0) {
                                              NSMutableDictionary *resultDic =
                                                  [[NSMutableDictionary alloc] init];
                                              [resultDic
                                                  setObject:[ZIMPluginConverter
                                                                mZIMUserStatusSubsciptionList:
                                                                    userStatusSubscriptionList]
                                                     forKey:@"userStatusSubscriptionList"];
                                              result(resultDic);
                                          } else {
                                              result([FlutterError
                                                  errorWithCode:[NSString
                                                                    stringWithFormat:@"%d",
                                                                                     (int)errorInfo
                                                                                         .code]
                                                        message:errorInfo.message
                                                        details:nil]);
                                          }
                                        }];
}

- (void)queryUsersInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    ZIMUsersInfoQueryConfig *config =
        [ZIMPluginConverter oZIMUserInfoQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryUsersInfo:userIDs
                 config:config
               callback:^(NSArray<ZIMUserFullInfo *> *_Nonnull userList,
                          NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                          ZIMError *_Nonnull errorInfo) {
                 if (errorInfo.code == 0) {
                     NSMutableArray *userListBasic = [[NSMutableArray alloc] init];
                     for (ZIMUserFullInfo *userFullInfo in userList) {
                         NSDictionary *userFullInfoDic =
                             [ZIMPluginConverter mZIMUserFullInfo:userFullInfo];
                         [userListBasic addObject:userFullInfoDic];
                     }
                     NSMutableArray *errorUserListBasic = [[NSMutableArray alloc] init];
                     for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                         NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
                         [errorUserInfoDic safeSetObject:errorUserInfo.userID forKey:@"userID"];
                         [errorUserInfoDic
                             safeSetObject:[NSNumber numberWithUnsignedInt:errorUserInfo.reason]
                                    forKey:@"reason"];
                         [errorUserListBasic addObject:errorUserInfoDic];
                     }
                     NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                     [resultDic safeSetObject:userListBasic forKey:@"userList"];
                     [resultDic safeSetObject:errorUserListBasic forKey:@"errorUserList"];
                     result(resultDic);
                 } else {
                     result([FlutterError
                         errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                               message:errorInfo.message
                               details:nil]);
                 }
               }];
}

- (void)querySelfUserInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    [zim querySelfUserInfo:^(ZIMSelfUserInfo *_Nonnull selfUserInfo, ZIMError *_Nonnull errorInfo) {
      if (errorInfo.code == 0) {
          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic setObject:[ZIMPluginConverter mZIMSelfUserInfo:selfUserInfo]
                        forKey:@"selfUserInfo"];
          result(resultDic);
      } else {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
      }
    }];
}

- (void)queryConversationList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSDictionary *configDic = [call.arguments objectForKey:@"config"];
    ZIMConversationQueryConfig *config = [[ZIMConversationQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextConversation = [ZIMPluginConverter
        oZIMConversation:(NSDictionary *)[configDic objectForKey:@"nextConversation"]];

    ZIMConversationFilterOption *option =
        [ZIMPluginConverter oZIMConversationFilterOption:[call.arguments objectForKey:@"option"]];

    if (option == nil) {
        [zim
            queryConversationListWithConfig:config
                                   callback:^(NSArray<ZIMConversation *> *_Nonnull conversationList,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSArray *conversationBasicList = [ZIMPluginConverter
                                             mZIMConversationList:conversationList];
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:conversationBasicList
                                                           forKey:@"conversationList"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
    } else {
        [zim
            queryConversationListWithConfig:config
                                     option:option
                                   callback:^(NSArray<ZIMConversation *> *_Nonnull conversationList,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSArray *conversationBasicList = [ZIMPluginConverter
                                             mZIMConversationList:conversationList];
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:conversationBasicList
                                                           forKey:@"conversationList"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
    }
}

- (void)queryConversationTotalUnreadCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMConversationTotalUnreadMessageCountQueryConfig *queryConfig = [ZIMPluginConverter
        oZIMConversationTotalUnreadMessageCountQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryConversationTotalUnreadMessageCountWithConfig:queryConfig
                                                   callback:^(unsigned int unreadMessageCount,
                                                              ZIMError *_Nonnull errorInfo) {
                                                     if (errorInfo.code == 0) {
                                                         NSMutableDictionary *resultDic =
                                                             [[NSMutableDictionary alloc] init];
                                                         [resultDic
                                                             setObject:@(unreadMessageCount)
                                                                forKey:@"unreadMessageCount"];
                                                         result(resultDic);
                                                     } else {
                                                         result([FlutterError
                                                             errorWithCode:
                                                                 [NSString
                                                                     stringWithFormat:@"%d",
                                                                                      (int)errorInfo
                                                                                          .code]
                                                                   message:errorInfo.message
                                                                   details:nil]);
                                                     }
                                                   }];
}

- (void)queryConversation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputConversationID = [call.arguments objectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    [zim queryConversation:inputConversationID
          conversationType:inputConversationType
                  callback:^(ZIMConversation *conversation, ZIMError *errorInfo) {
                    if (errorInfo.code == 0) {
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];

                        [resultDic safeSetObject:[ZIMPluginConverter mZIMConversation:conversation]
                                          forKey:@"conversation"];
                        result(resultDic);
                    } else {
                        result([FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                  message:errorInfo.message
                                  details:nil]);
                    }
                  }];
}

- (void)deleteConversation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputConversationID = [call.arguments objectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMConversationDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMConversationDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteConversation:inputConversationID
           conversationType:inputConversationType
                     config:deleteConfig
                   callback:^(NSString *_Nonnull conversationID,
                              ZIMConversationType conversationType, ZIMError *_Nonnull errorInfo) {
                     if (errorInfo.code == 0) {
                         NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                         [resultDic safeSetObject:conversationID forKey:@"conversationID"];
                         [resultDic safeSetObject:[NSNumber numberWithInt:(int)conversationType]
                                           forKey:@"conversationType"];
                         result(resultDic);
                     } else {
                         result([FlutterError
                             errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                   message:errorInfo.message
                                   details:nil]);
                     }
                   }];
}

- (void)deleteAllConversations:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMConversationDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMConversationDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteAllConversationsWithConfig:deleteConfig
                                 callback:^(ZIMError *_Nonnull errorInfo) {
                                   if (errorInfo.code == 0) {
                                       result(nil);
                                   } else {
                                       result([FlutterError
                                           errorWithCode:[NSString
                                                             stringWithFormat:@"%d",
                                                                              (int)errorInfo.code]
                                                 message:errorInfo.message
                                                 details:nil]);
                                   }
                                 }];
}

- (void)queryConversationPinnedList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSDictionary *configDic = [call.arguments objectForKey:@"config"];
    ZIMConversationQueryConfig *queryConfig = [[ZIMConversationQueryConfig alloc] init];
    queryConfig.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    queryConfig.nextConversation = [ZIMPluginConverter
        oZIMConversation:(NSDictionary *)[configDic objectForKey:@"nextConversation"]];
    [zim queryConversationPinnedListWithConfig:queryConfig
                                      callback:^(
                                          NSArray<ZIMConversation *> *_Nonnull conversationList,
                                          ZIMError *_Nonnull errorInfo) {
                                        if (errorInfo.code == 0) {
                                            NSArray *conversationBasicList = [ZIMPluginConverter
                                                mZIMConversationList:conversationList];
                                            NSMutableDictionary *resultDic =
                                                [[NSMutableDictionary alloc] init];
                                            [resultDic safeSetObject:conversationBasicList
                                                              forKey:@"conversationList"];
                                            result(resultDic);
                                        } else {
                                            result([FlutterError
                                                errorWithCode:[NSString
                                                                  stringWithFormat:@"%d",
                                                                                   (int)errorInfo
                                                                                       .code]
                                                      message:errorInfo.message
                                                      details:nil]);
                                        }
                                      }];
}

- (void)updateConversationPinnedState:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *inputConversationID = [call.arguments objectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    bool isPinned = ((NSNumber *)[call.arguments safeObjectForKey:@"isPinned"]).boolValue;
    [zim
        updateConversationPinnedState:isPinned
                       conversationID:inputConversationID
                     conversationType:inputConversationType
                             callback:^(NSString *_Nonnull conversationID,
                                        ZIMConversationType conversationType,
                                        ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSMutableDictionary *resultDic =
                                       [[NSMutableDictionary alloc] init];
                                   [resultDic safeSetObject:conversationID
                                                     forKey:@"conversationID"];
                                   [resultDic
                                       safeSetObject:[NSNumber numberWithInt:(int)conversationType]
                                              forKey:@"conversationType"];
                                   result(resultDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)clearConversationUnreadMessageCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputConversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    [zim
        clearConversationUnreadMessageCount:inputConversationID
                           conversationType:inputConversationType
                                   callback:^(NSString *_Nonnull conversationID,
                                              ZIMConversationType conversationType,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:conversationID
                                                           forKey:@"conversationID"];
                                         [resultDic
                                             safeSetObject:[NSNumber
                                                               numberWithInt:(int)conversationType]
                                                    forKey:@"conversationType"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)clearConversationTotalUnreadMessageCount:(FlutterMethodCall *)call
                                          result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    [zim clearConversationTotalUnreadMessageCount:^(ZIMError *_Nonnull errorInfo) {
      if (errorInfo.code == 0) {
          result(nil);
      } else {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
      }
    }];
}

- (void)setConversationNotificationStatus:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    int status = ((NSNumber *)[call.arguments objectForKey:@"status"]).intValue;
    NSString *inputConversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;

    [zim setConversationNotificationStatus:status
                            conversationID:inputConversationID
                          conversationType:inputConversationType
                                  callback:^(NSString *_Nonnull conversationID,
                                             ZIMConversationType conversationType,
                                             ZIMError *_Nonnull errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSMutableDictionary *resultDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultDic safeSetObject:conversationID
                                                          forKey:@"conversationID"];
                                        [resultDic
                                            safeSetObject:[NSNumber
                                                              numberWithInt:(int)conversationType]
                                                   forKey:@"conversationType"];
                                        result(resultDic);
                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)setConversationMark:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSNumber *markType = [call.arguments objectForKey:@"markType"];
    BOOL enable = [[call.arguments objectForKey:@"enable"] boolValue];
    NSArray<ZIMConversationBaseInfo *> *baseInfos =
        [ZIMPluginConverter oZIMConversationBaseInfoList:[call.arguments objectForKey:@"infos"]];

    [zim
        setConversationMark:markType
                     enable:enable
          conversationInfos:baseInfos
                   callback:^(NSArray<ZIMConversationBaseInfo *> *_Nonnull failedConversationInfos,
                              ZIMError *_Nonnull errorInfo) {
                     if (errorInfo.code == 0) {
                         NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                         [resultDic
                             safeSetObject:[ZIMPluginConverter
                                               mZIMConversationBaseInfoList:failedConversationInfos]
                                    forKey:@"failedConversationInfos"];
                         result(resultDic);
                     } else {
                         result([FlutterError
                             errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                   message:errorInfo.message
                                   details:nil]);
                     }
                   }];
}

- (void)insertMessageToLocalDB:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *inputMessage =
        [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *inputConversationID = (NSString *)[call.arguments safeObjectForKey:@"conversationID"];
    int inputConversationType =
        ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    NSString *senderUserID = (NSString *)[call.arguments safeObjectForKey:@"senderUserID"];
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    [zim
        insertMessageToLocalDB:inputMessage
                conversationID:inputConversationID
              conversationType:inputConversationType
                  senderUserID:senderUserID
                      callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                        NSDictionary *messageModel = [ZIMPluginConverter mZIMMessage:message];
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic safeSetObject:messageModel forKey:@"message"];
                        [resultDic safeSetObject:messageID forKey:@"messageID"];
                        if (errorInfo.code == 0) {
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:resultDic]);
                        }
                      }];
}

- (void)updateMessageLocalExtendedData:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *inputMessage =
        [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *inputLocalExtendedData =
        (NSString *)[call.arguments safeObjectForKey:@"localExtendedData"];

    [zim updateMessageLocalExtendedData:inputLocalExtendedData
                                message:inputMessage
                               callback:^(ZIMMessage *_Nonnull message,
                                          ZIMError *_Nonnull errorInfo) {
                                 NSDictionary *messageModel =
                                     [ZIMPluginConverter mZIMMessage:message];
                                 NSMutableDictionary *resultDic =
                                     [[NSMutableDictionary alloc] init];
                                 [resultDic safeSetObject:messageModel forKey:@"message"];
                                 if (errorInfo.code == 0) {
                                     result(resultDic);
                                 } else {
                                     result([FlutterError
                                         errorWithCode:[NSString
                                                           stringWithFormat:@"%d",
                                                                            (int)errorInfo.code]
                                               message:errorInfo.message
                                               details:resultDic]);
                                 }
                               }];
}

- (void)sendMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    NSNumber *messageAttachedCallbackID =
        [call.arguments safeObjectForKey:@"messageAttachedCallbackID"];
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toConversationID = (NSString *)[call.arguments safeObjectForKey:@"toConversationID"];
    int conversationType =
        ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments safeObjectForKey:@"config"]];
    ZIMMessageSendNotification *sendNotification = [[ZIMMessageSendNotification alloc] init];
    sendNotification.onMessageAttached = ^(ZIMMessage *_Nonnull message) {
      if (messageAttachedCallbackID == nil) {
          return;
      }
      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
      [resultDic safeSetObject:handle forKey:@"handle"];
      [resultDic safeSetObject:@"onMessageAttached" forKey:@"method"];
      [resultDic safeSetObject:messageID forKey:@"messageID"];
      [resultDic safeSetObject:messageAttachedCallbackID forKey:@"messageAttachedCallbackID"];
      [resultDic safeSetObject:messageDic forKey:@"message"];
      self.events(resultDic);
    };
    [zim sendMessage:message
        toConversationID:toConversationID
        conversationType:conversationType
                  config:sendConfig
            notification:sendNotification
                callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                  NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                  NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                  [resultDic safeSetObject:messageDic forKey:@"message"];
                  [resultDic safeSetObject:messageID forKey:@"messageID"];
                  if (errorInfo.code == 0) {
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:resultDic]);
                  }
                }];
}

- (void)sendPeerMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toUserID = (NSString *)[call.arguments objectForKey:@"toUserID"];
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendPeerMessage:message
                toUserID:toUserID
                  config:sendConfig
                callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                      [resultDic safeSetObject:messageDic forKey:@"message"];
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)sendRoomMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toRoomID = (NSString *)[call.arguments objectForKey:@"toRoomID"];
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendRoomMessage:message
                toRoomID:toRoomID
                  config:sendConfig
                callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                      [resultDic safeSetObject:messageDic forKey:@"message"];
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)sendGroupMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMessage *message =
        [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *toGroupID = (NSString *)[call.arguments objectForKey:@"toGroupID"];
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendGroupMesage:message
               toGroupID:toGroupID
                  config:sendConfig
                callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                      [resultDic safeSetObject:messageDic forKey:@"message"];
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)sendMediaMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter
        oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *toConversationID = [call.arguments safeObjectForKey:@"toConversationID"];
    int conversationType =
        ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments safeObjectForKey:@"config"]];
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];
    NSNumber *messageAttachedCallbackID =
        [call.arguments safeObjectForKey:@"messageAttachedCallbackID"];
    ZIMMediaMessageSendNotification *sendNotification =
        [[ZIMMediaMessageSendNotification alloc] init];
    sendNotification.onMediaUploadingProgress =
        ^(ZIMMediaMessage *_Nonnull message, unsigned long long currentFileSize,
          unsigned long long totalFileSize) {
          if (progressID == nil) {
              return;
          }
          NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:handle forKey:@"handle"];
          [resultDic safeSetObject:@"uploadMediaProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:messageID forKey:@"messageID"];
          [resultDic safeSetObject:messageDic forKey:@"message"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize]
                            forKey:@"currentFileSize"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize]
                            forKey:@"totalFileSize"];
          self.events(resultDic);
        };
    sendNotification.onMessageAttached = ^(ZIMMessage *_Nonnull message) {
      if (messageAttachedCallbackID == nil) {
          return;
      }
      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
      [resultDic safeSetObject:handle forKey:@"handle"];
      [resultDic safeSetObject:@"onMessageAttached" forKey:@"method"];
      [resultDic safeSetObject:messageID forKey:@"messageID"];
      [resultDic safeSetObject:messageAttachedCallbackID forKey:@"messageAttachedCallbackID"];
      [resultDic safeSetObject:messageDic forKey:@"message"];
      self.events(resultDic);
    };
    [zim sendMediaMessage:message
         toConversationID:toConversationID
         conversationType:conversationType
                   config:sendConfig
             notification:sendNotification
                 callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                   NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                   NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                   [resultMtDic safeSetObject:messageID forKey:@"messageID"];
                   [resultMtDic safeSetObject:messageDic forKey:@"message"];
                   if (errorInfo.code == 0) {
                       result(resultMtDic);
                   } else {
                       result([FlutterError
                           errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                 message:errorInfo.message
                                 details:resultMtDic]);
                   }
                 }];
}

- (void)sendConversationMessageReceiptRead:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments safeObjectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType =
        [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim sendConversationMessageReceiptRead:conversationID
                           conversationType:conversationType
                                   callback:^(NSString *_Nonnull conversationID,
                                              ZIMConversationType conversationType,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultMtDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultMtDic safeSetObject:conversationID
                                                             forKey:@"conversationID"];
                                         [resultMtDic
                                             safeSetObject:[NSNumber numberWithUnsignedInteger:
                                                                         conversationType]
                                                    forKey:@"conversationType"];
                                         result(resultMtDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)setConversationDraft:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments safeObjectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *draft = [call.arguments safeObjectForKey:@"draft"];
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType =
        [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim
        setConversationDraft:draft
              conversationID:conversationID
            conversationType:conversationType
                    callback:^(NSString *_Nonnull conversationID,
                               ZIMConversationType conversationType, ZIMError *_Nonnull errorInfo) {
                      if (errorInfo.code == 0) {
                          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                          [resultDic safeSetObject:conversationID forKey:@"conversationID"];
                          [resultDic
                              safeSetObject:[NSNumber numberWithUnsignedInteger:conversationType]
                                     forKey:@"conversationType"];
                          result(resultDic);
                      } else {
                          result([FlutterError
                              errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                    message:errorInfo.message
                                    details:nil]);
                      }
                    }];
}

- (void)sendMessageReceiptsRead:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments safeObjectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<ZIMMessage *> *messageList =
        [ZIMPluginConverter oZIMMessageList:[call.arguments safeObjectForKey:@"messageList"]];
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType =
        [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim
        sendMessageReceiptsRead:messageList
                 conversationID:conversationID
               conversationType:conversationType
                       callback:^(NSString *_Nonnull conversationID,
                                  ZIMConversationType conversationType,
                                  NSArray<NSNumber *> *_Nonnull errorMessageIDs,
                                  ZIMError *_Nonnull errorInfo) {
                         if (errorInfo.code == 0) {
                             NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                             [resultMtDic safeSetObject:conversationID forKey:@"conversationID"];
                             [resultMtDic
                                 safeSetObject:[NSNumber numberWithUnsignedInteger:conversationType]
                                        forKey:@"conversationType"];
                             [resultMtDic safeSetObject:errorMessageIDs forKey:@"errorMessageIDs"];
                             result(resultMtDic);
                         } else {
                             result([FlutterError
                                 errorWithCode:[NSString
                                                   stringWithFormat:@"%d", (int)errorInfo.code]
                                       message:errorInfo.message
                                       details:nil]);
                         }
                       }];
}

- (void)queryMessageReceiptsInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<ZIMMessage *> *messageList =
        [ZIMPluginConverter oZIMMessageList:[call.arguments safeObjectForKey:@"messageList"]];
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType =
        [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim queryMessageReceiptsInfoByMessageList:messageList
                                conversationID:conversationID
                              conversationType:conversationType
                                      callback:^(NSArray<ZIMMessageReceiptInfo *> *_Nonnull infos,
                                                 NSArray<NSString *> *_Nonnull errorMessageIDs,
                                                 ZIMError *_Nonnull errorInfo) {
                                        if (errorInfo.code == 0) {
                                            NSMutableDictionary *resultMtDic =
                                                [[NSMutableDictionary alloc] init];
                                            NSMutableArray *infosModel =
                                                [[NSMutableArray alloc] init];
                                            for (ZIMMessageReceiptInfo *info in infos) {
                                                [infosModel
                                                    safeAddObject:[ZIMPluginConverter
                                                                      mZIMMessageReceiptInfo:info]];
                                            }
                                            [resultMtDic safeSetObject:infosModel forKey:@"infos"];
                                            [resultMtDic safeSetObject:errorMessageIDs
                                                                forKey:@"errorMessageIDs"];
                                            result(resultMtDic);
                                        } else {
                                            result([FlutterError
                                                errorWithCode:[NSString
                                                                  stringWithFormat:@"%d",
                                                                                   (int)errorInfo
                                                                                       .code]
                                                      message:errorInfo.message
                                                      details:nil]);
                                        }
                                      }];
}

- (void)queryGroupMessageReceiptReadMemberList:(FlutterMethodCall *)call
                                        result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message =
        [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMessageReceiptMemberQueryConfig *queryConfig = [ZIMPluginConverter
        oZIMGroupMessageReceiptMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        queryGroupMessageReceiptReadMemberListByMessage:message
                                                groupID:groupID
                                                 config:queryConfig
                                               callback:^(
                                                   NSString *_Nonnull groupID,
                                                   NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                                                   unsigned int nextFlag,
                                                   ZIMError *_Nonnull errorInfo) {
                                                 if (errorInfo.code == 0) {
                                                     NSMutableDictionary *resultMtDic =
                                                         [[NSMutableDictionary alloc] init];
                                                     [resultMtDic
                                                         safeSetObject:
                                                             [ZIMPluginConverter
                                                                 mZIMGroupMemberInfoList:userList]
                                                                forKey:@"userList"];
                                                     [resultMtDic safeSetObject:groupID
                                                                         forKey:@"groupID"];
                                                     [resultMtDic
                                                         safeSetObject:
                                                             [NSNumber
                                                                 numberWithUnsignedInt:nextFlag]
                                                                forKey:@"nextFlag"];
                                                     result(resultMtDic);
                                                 } else {
                                                     result([FlutterError
                                                         errorWithCode:[NSString
                                                                           stringWithFormat:
                                                                               @"%d",
                                                                               (int)errorInfo.code]
                                                               message:errorInfo.message
                                                               details:nil]);
                                                 }
                                               }];
}

- (void)queryGroupMessageReceiptUnreadMemberList:(FlutterMethodCall *)call
                                          result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message =
        [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMessageReceiptMemberQueryConfig *queryConfig = [ZIMPluginConverter
        oZIMGroupMessageReceiptMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        queryGroupMessageReceiptUnreadMemberListByMessage:message
                                                  groupID:groupID
                                                   config:queryConfig
                                                 callback:^(NSString *_Nonnull groupID,
                                                            NSArray<ZIMGroupMemberInfo *>
                                                                *_Nonnull userList,
                                                            unsigned int nextFlag,
                                                            ZIMError *_Nonnull errorInfo) {
                                                   if (errorInfo.code == 0) {
                                                       NSMutableDictionary *resultMtDic =
                                                           [[NSMutableDictionary alloc] init];
                                                       [resultMtDic
                                                           safeSetObject:
                                                               [ZIMPluginConverter
                                                                   mZIMGroupMemberInfoList:userList]
                                                                  forKey:@"userList"];
                                                       [resultMtDic safeSetObject:groupID
                                                                           forKey:@"groupID"];
                                                       [resultMtDic
                                                           safeSetObject:
                                                               [NSNumber
                                                                   numberWithUnsignedInt:nextFlag]
                                                                  forKey:@"nextFlag"];
                                                       result(resultMtDic);
                                                   } else {
                                                       result([FlutterError
                                                           errorWithCode:[NSString
                                                                             stringWithFormat:
                                                                                 @"%d",
                                                                                 (int)
                                                                                     errorInfo.code]
                                                                 message:errorInfo.message
                                                                 details:nil]);
                                                   }
                                                 }];
}

- (void)revokeMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message =
        [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    ZIMMessageRevokeConfig *revokeConfig =
        [ZIMPluginConverter oZIMMessageRevokeConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim revokeMessage:message
                config:revokeConfig
              callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                if (errorInfo.code == 0) {
                    NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                    [resultMtDic safeSetObject:[ZIMPluginConverter mZIMMessage:message]
                                        forKey:@"message"];
                    result(resultMtDic);
                } else {
                    result([FlutterError
                        errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                              message:errorInfo.message
                              details:nil]);
                }
              }];
}

- (void)downloadMediaFile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter
        oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    int fileType = ((NSNumber *)[call.arguments safeObjectForKey:@"fileType"]).intValue;
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];

    [zim downloadMediaFileWithMessage:message
        fileType:fileType
        progress:^(ZIMMessage *_Nonnull message, unsigned long long currentFileSize,
                   unsigned long long totalFileSize) {
          if (progressID == nil) {
              return;
          }
          NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:handle forKey:@"handle"];
          [resultDic safeSetObject:@"downloadMediaFileProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:messageDic forKey:@"message"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize]
                            forKey:@"currentFileSize"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize]
                            forKey:@"totalFileSize"];
          self.events(resultDic);
        }
        callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
          if (errorInfo.code == 0) {
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
              [resultMtDic safeSetObject:messageDic forKey:@"message"];
              result(resultMtDic);
          } else {
              result([FlutterError
                  errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                        message:errorInfo.message
                        details:nil]);
          }
        }];
}

- (void)queryHistoryMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageQueryConfig *queryConfig =
        [ZIMPluginConverter oZIMMessageQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim
        queryHistoryMessageByConversationID:conversationID
                           conversationType:conversationType
                                     config:queryConfig
                                   callback:^(NSString *_Nonnull conversationID,
                                              ZIMConversationType conversationType,
                                              NSArray<ZIMMessage *> *_Nonnull messageList,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSArray *MsgDicList =
                                             [ZIMPluginConverter mZIMMessageList:messageList];
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:conversationID
                                                           forKey:@"conversationID"];
                                         [resultDic
                                             safeSetObject:[NSNumber
                                                               numberWithInt:(int)conversationType]
                                                    forKey:@"conversationType"];
                                         [resultDic safeSetObject:MsgDicList forKey:@"messageList"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)queryMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray<NSNumber *> *messageSeqs = [call.arguments objectForKey:@"messageSeqs"];
    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    [zim queryMessagesByMessageSeqs:messageSeqs
                     conversationID:conversationID
                   conversationType:(ZIMConversationType)conversationType
                           callback:^(NSString *_Nonnull conversationID,
                                      ZIMConversationType conversationType,
                                      NSArray<ZIMMessage *> *_Nonnull messageList,
                                      ZIMError *_Nonnull errorInfo) {
                             if (errorInfo.code == 0) {
                                 NSArray *MsgDicList =
                                     [ZIMPluginConverter mZIMMessageList:messageList];
                                 NSMutableDictionary *resultDic =
                                     [[NSMutableDictionary alloc] init];
                                 [resultDic safeSetObject:conversationID forKey:@"conversationID"];
                                 [resultDic
                                     safeSetObject:[NSNumber numberWithInt:(int)conversationType]
                                            forKey:@"conversationType"];
                                 [resultDic safeSetObject:MsgDicList forKey:@"messageList"];
                                 result(resultDic);
                             } else {
                                 result([FlutterError
                                     errorWithCode:[NSString
                                                       stringWithFormat:@"%d", (int)errorInfo.code]
                                           message:errorInfo.message
                                           details:nil]);
                             }
                           }];
}

- (void)deleteAllMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMMessageDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteAllMessageByConversationID:conversationID
                         conversationType:conversationType
                                   config:deleteConfig
                                 callback:^(NSString *_Nonnull conversationID,
                                            ZIMConversationType conversationType,
                                            ZIMError *_Nonnull errorInfo) {
                                   if (errorInfo.code == 0) {
                                       NSMutableDictionary *resultDic =
                                           [[NSMutableDictionary alloc] init];
                                       [resultDic safeSetObject:conversationID
                                                         forKey:@"conversationID"];
                                       [resultDic
                                           safeSetObject:[NSNumber
                                                             numberWithInt:(int)conversationType]
                                                  forKey:@"conversationType"];
                                       result(resultDic);
                                   } else {
                                       result([FlutterError
                                           errorWithCode:[NSString
                                                             stringWithFormat:@"%d",
                                                                              (int)errorInfo.code]
                                                 message:errorInfo.message
                                                 details:nil]);
                                   }
                                 }];
}

- (void)deleteAllConversationMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMessageDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMMessageDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteAllConversationMessagesWithConfig:deleteConfig
                                        callback:^(ZIMError *_Nonnull errorInfo) {
                                          if (errorInfo.code == 0) {
                                              result(nil);
                                          } else {
                                              result([FlutterError
                                                  errorWithCode:[NSString
                                                                    stringWithFormat:@"%d",
                                                                                     (int)errorInfo
                                                                                         .code]
                                                        message:errorInfo.message
                                                        details:nil]);
                                          }
                                        }];
}

- (void)deleteMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray *messageList =
        [ZIMPluginConverter oZIMMessageList:[call.arguments objectForKey:@"messageList"]];
    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMMessageDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteMessages:messageList
          conversationID:conversationID
        conversationType:conversationType
                  config:deleteConfig
                callback:^(NSString *_Nonnull conversationID, ZIMConversationType conversationType,
                           ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                      [resultDic safeSetObject:conversationID forKey:@"conversationID"];
                      [resultDic safeSetObject:[NSNumber numberWithInt:(int)conversationType]
                                        forKey:@"conversationType"];
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)replyMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter
        oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    ZIMMediaMessage *toOriginalMessage = (ZIMMediaMessage *)[ZIMPluginConverter
        oZIMMessage:[call.arguments safeObjectForKey:@"toOriginalMessage"]];
    ZIMMessageSendConfig *sendConfig =
        [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments safeObjectForKey:@"config"]];
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];
    NSNumber *messageAttachedCallbackID =
        [call.arguments safeObjectForKey:@"messageAttachedCallbackID"];
    ZIMMessageSendNotification *sendNotification = [[ZIMMessageSendNotification alloc] init];
    sendNotification.onMediaUploadingProgress =
        ^(ZIMMediaMessage *_Nonnull message, unsigned long long currentFileSize,
          unsigned long long totalFileSize) {
          if (progressID == nil) {
              return;
          }
          NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:handle forKey:@"handle"];
          [resultDic safeSetObject:@"uploadMediaProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:messageID forKey:@"messageID"];
          [resultDic safeSetObject:messageDic forKey:@"message"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize]
                            forKey:@"currentFileSize"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize]
                            forKey:@"totalFileSize"];
          self.events(resultDic);
        };
    sendNotification.onMessageAttached = ^(ZIMMessage *_Nonnull message) {
      if (messageAttachedCallbackID == nil) {
          return;
      }
      NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
      [resultDic safeSetObject:handle forKey:@"handle"];
      [resultDic safeSetObject:@"onMessageAttached" forKey:@"method"];
      [resultDic safeSetObject:messageID forKey:@"messageID"];
      [resultDic safeSetObject:messageAttachedCallbackID forKey:@"messageAttachedCallbackID"];
      [resultDic safeSetObject:messageDic forKey:@"message"];
      self.events(resultDic);
    };
    [zim replyMessage:message
        toOriginalMessage:toOriginalMessage
                   config:sendConfig
             notification:sendNotification
                 callback:^(ZIMMessage *_Nonnull message, ZIMError *_Nonnull errorInfo) {
                   NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                   NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
                   [resultMtDic safeSetObject:messageID forKey:@"messageID"];
                   [resultMtDic safeSetObject:messageDic forKey:@"message"];
                   if (errorInfo.code == 0) {
                       result(resultMtDic);
                   } else {
                       result([FlutterError
                           errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                 message:errorInfo.message
                                 details:resultMtDic]);
                   }
                 }];
}

- (void)queryMessageRepliedList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter
        oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    ZIMMessageRepliedListQueryConfig *config = [ZIMPluginConverter
        oZIMMessageRepliedListQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryMessageRepliedListByMessage:message
                                   config:config
                                 callback:^(NSArray<ZIMMessage *> *_Nonnull messageList,
                                            long long nextFlag,
                                            ZIMMessageRootRepliedInfo *_Nonnull rootRepliedInfo,
                                            ZIMError *_Nonnull errorInfo) {
                                   if (errorInfo.code == 0) {
                                       NSArray *MsgDicList =
                                           [ZIMPluginConverter mZIMMessageList:messageList];
                                       NSDictionary *infoDic = [ZIMPluginConverter
                                           mZIMMessageRootRepliedInfo:rootRepliedInfo];
                                       NSMutableDictionary *resultDic =
                                           [[NSMutableDictionary alloc] init];
                                       [resultDic safeSetObject:@(nextFlag) forKey:@"nextFlag"];
                                       [resultDic safeSetObject:MsgDicList forKey:@"messageList"];
                                       [resultDic safeSetObject:infoDic forKey:@"rootRepliedInfo"];
                                       NSString *infoStr = [NSString
                                           stringWithFormat:@"Auto test ,rootRepliedInfo:%@",
                                                            infoDic];
                                       NSString *compressedString1 =
                                           [infoStr stringByReplacingOccurrencesOfString:@"\n"
                                                                              withString:@""];
                                       // 去掉制表符
                                       NSString *compressedString2 = [compressedString1
                                           stringByReplacingOccurrencesOfString:@"\t"
                                                                     withString:@""];
                                       // 去掉空格
                                       NSString *compressedString3 = [compressedString2
                                           stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@""];

                                       [self writeLog:compressedString3];

                                       result(resultDic);
                                   } else {
                                       result([FlutterError
                                           errorWithCode:[NSString
                                                             stringWithFormat:@"%d",
                                                                              (int)errorInfo.code]
                                                 message:errorInfo.message
                                                 details:nil]);
                                   }
                                 }];
}

- (void)searchLocalMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageSearchConfig *config =
        [ZIMPluginConverter oZIMMessageSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim
        searchLocalMessagesByConversationID:conversationID
                           conversationType:(ZIMConversationType)conversationType
                                     config:config
                                   callback:^(NSString *_Nonnull conversationID,
                                              ZIMConversationType conversationType,
                                              NSArray<ZIMMessage *> *_Nonnull messageList,
                                              ZIMMessage *__nullable nextMessage,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:conversationID
                                                           forKey:@"conversationID"];
                                         [resultDic safeSetObject:@(conversationType)
                                                           forKey:@"conversationType"];
                                         [resultDic safeSetObject:[ZIMPluginConverter
                                                                      mZIMMessageList:messageList]
                                                           forKey:@"messageList"];
                                         if (nextMessage) {
                                             [resultDic safeSetObject:[ZIMPluginConverter
                                                                          mZIMMessage:nextMessage]
                                                               forKey:@"nextMessage"];
                                         } else {
                                             [resultDic safeSetObject:[NSNull null]
                                                               forKey:@"nextMessage"];
                                         }
                                         result(resultDic);

                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)searchGlobalLocalMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMMessageSearchConfig *config =
        [ZIMPluginConverter oZIMMessageSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim
        searchGlobalLocalMessagesWithConfig:config
                                   callback:^(NSArray<ZIMMessage *> *_Nonnull messageList,
                                              ZIMMessage *_Nullable nextMessage,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:[ZIMPluginConverter
                                                                      mZIMMessageList:messageList]
                                                           forKey:@"messageList"];
                                         if (nextMessage) {
                                             [resultDic safeSetObject:[ZIMPluginConverter
                                                                          mZIMMessage:nextMessage]
                                                               forKey:@"nextMessage"];
                                         } else {
                                             [resultDic safeSetObject:[NSNull null]
                                                               forKey:@"nextMessage"];
                                         }
                                         result(resultDic);

                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)searchLocalConversations:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMConversationSearchConfig *config = [ZIMPluginConverter
        oZIMConversationMessageGlobalSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim
        searchLocalConversationsWithConfig:config
                                  callback:^(
                                      NSArray<ZIMConversationSearchInfo *> *_Nonnull globalInfoList,
                                      unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSMutableDictionary *resultDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultDic
                                            safeSetObject:[ZIMPluginConverter
                                                              mZIMConversationMessageSearchInfoList:
                                                                  globalInfoList]
                                                   forKey:@"conversationSearchInfoList"];
                                        [resultDic safeSetObject:@(nextFlag) forKey:@"nextFlag"];
                                        result(resultDic);

                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)enterRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMRoomInfo *roomInfo =
        [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];
    ZIMRoomAdvancedConfig *config =
        [ZIMPluginConverter oZIMRoomAdvancedConfig:[call.arguments objectForKey:@"config"]];
    [zim enterRoom:roomInfo
            config:config
          callback:^(ZIMRoomFullInfo *_Nonnull roomInfo, ZIMError *_Nonnull errorInfo) {
            if (errorInfo.code == 0) {
                NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                [resultDic safeSetObject:roomInfoDic forKey:@"roomInfo"];
                result(resultDic);
            } else {
                result([FlutterError
                    errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                          message:errorInfo.message
                          details:nil]);
            }
          }];
}

- (void)switchRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *fromRoomID = [call.arguments objectForKey:@"fromRoomID"];
    bool isCreateWhenRoomNotExisted =
        ((NSNumber *)[call.arguments safeObjectForKey:@"isCreateWhenRoomNotExisted"]).boolValue;
    ZIMRoomInfo *toRoomInfo =
        [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"toRoomInfo"]];
    ZIMRoomAdvancedConfig *config =
        [ZIMPluginConverter oZIMRoomAdvancedConfig:[call.arguments objectForKey:@"config"]];

    [zim switchRoomFromRoomID:fromRoomID
                        toRoomInfo:toRoomInfo
        isCreateWhenRoomNotExisted:isCreateWhenRoomNotExisted
                            config:config
                          callback:^(ZIMRoomFullInfo *_Nonnull roomInfo,
                                     ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSDictionary *roomInfoDic =
                                    [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
                                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                                [resultDic safeSetObject:roomInfoDic forKey:@"roomInfo"];
                                result(resultDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)createRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMRoomInfo *roomInfo =
        [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];

    [zim createRoom:roomInfo
           callback:^(ZIMRoomFullInfo *_Nonnull roomInfo, ZIMError *_Nonnull errorInfo) {
             if (errorInfo.code == 0) {
                 NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
                 NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                 [resultDic safeSetObject:roomInfoDic forKey:@"roomInfo"];
                 result(resultDic);
             } else {
                 result([FlutterError
                     errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                           message:errorInfo.message
                           details:nil]);
             }
           }];
}

- (void)createRoomWithConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMRoomInfo *roomInfo =
        [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];
    ZIMRoomAdvancedConfig *config =
        [ZIMPluginConverter oZIMRoomAdvancedConfig:[call.arguments objectForKey:@"config"]];

    [zim createRoom:roomInfo
             config:config
           callback:^(ZIMRoomFullInfo *_Nonnull roomInfo, ZIMError *_Nonnull errorInfo) {
             if (errorInfo.code == 0) {
                 NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
                 NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                 [resultDic safeSetObject:roomInfoDic forKey:@"roomInfo"];
                 result(resultDic);
             } else {
                 result([FlutterError
                     errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                           message:errorInfo.message
                           details:nil]);
             }
           }];
}

- (void)joinRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    [zim joinRoom:roomID
         callback:^(ZIMRoomFullInfo *_Nonnull roomInfo, ZIMError *_Nonnull errorInfo) {
           if (errorInfo.code == 0) {
               NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
               NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
               [resultDic safeSetObject:roomInfoDic forKey:@"roomInfo"];
               result(resultDic);
           } else {
               result([FlutterError
                   errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                         message:errorInfo.message
                         details:nil]);
           }
         }];
}

- (void)leaveRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *inputRoomID = [call.arguments objectForKey:@"roomID"];
    [zim leaveRoom:inputRoomID
          callback:^(NSString *_Nonnull roomID, ZIMError *_Nonnull errorInfo) {
            if (errorInfo.code == 0) {
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                [resultDic safeSetObject:roomID forKey:@"roomID"];
                result(resultDic);
            } else {
                result([FlutterError
                    errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                          message:errorInfo.message
                          details:nil]);
            }
          }];
}

- (void)leaveAllRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    [zim leaveAllRoom:^(NSArray<NSString *> *_Nonnull roomIDList, ZIMError *_Nonnull errorInfo) {
      if (errorInfo.code == 0) {
          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic setObject:roomIDList forKey:@"roomIDList"];
          result(resultDic);
      } else {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
      }
    }];
}

- (void)queryRoomMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];

    ZIMRoomMemberQueryConfig *config =
        [ZIMPluginConverter oZIMRoomMemberQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryRoomMemberListByRoomID:roomID
                              config:config
                            callback:^(NSString *_Nonnull roomID,
                                       NSArray<ZIMUserInfo *> *_Nonnull memberList,
                                       NSString *_Nonnull nextFlag, ZIMError *_Nonnull errorInfo) {
                              if (errorInfo.code == 0) {
                                  NSArray *basicMemberList =
                                      [ZIMPluginConverter mZIMUserInfoList:memberList];
                                  NSMutableDictionary *resultDic =
                                      [[NSMutableDictionary alloc] init];
                                  [resultDic safeSetObject:roomID forKey:@"roomID"];
                                  [resultDic safeSetObject:basicMemberList forKey:@"memberList"];
                                  [resultDic safeSetObject:nextFlag forKey:@"nextFlag"];
                                  result(resultDic);
                              } else {
                                  result([FlutterError
                                      errorWithCode:[NSString
                                                        stringWithFormat:@"%d", (int)errorInfo.code]
                                            message:errorInfo.message
                                            details:nil]);
                              }
                            }];
}

- (void)queryRoomMembers:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    [zim queryRoomMembersByUserIDs:userIDs
                            roomID:roomID
                          callback:^(NSString *roomID, NSArray<ZIMRoomMemberInfo *> *userList,
                                     NSArray<ZIMErrorUserInfo *> *errorUserList,
                                     ZIMError *errorInfo) {
                            if (errorInfo.code == 0) {
                                NSArray *basicMemberList =
                                    [ZIMPluginConverter mZIMRoomMemberInfoList:userList];
                                NSArray *basicErrorUserList =
                                    [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];

                                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                                [resultDic safeSetObject:roomID forKey:@"roomID"];
                                [resultDic safeSetObject:basicMemberList forKey:@"memberList"];
                                [resultDic safeSetObject:basicErrorUserList
                                                  forKey:@"errorUserList"];
                                result(resultDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)queryRoomOnlineMemberCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];

    [zim queryRoomOnlineMemberCountByRoomID:roomID
                                   callback:^(NSString *_Nonnull roomID, unsigned int count,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:roomID forKey:@"roomID"];
                                         [resultDic
                                             safeSetObject:[NSNumber numberWithUnsignedInt:count]
                                                    forKey:@"count"];
                                         ;
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)setRoomAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    NSDictionary<NSString *, NSString *> *roomAttributes =
        [call.arguments objectForKey:@"roomAttributes"];
    ZIMRoomAttributesSetConfig *setConfig =
        [ZIMPluginConverter oZIMRoomAttributesSetConfig:[call.arguments objectForKey:@"config"]];
    [zim setRoomAttributes:roomAttributes
                    roomID:roomID
                    config:setConfig
                  callback:^(NSString *_Nonnull roomID, NSArray<NSString *> *_Nonnull errorKeys,
                             ZIMError *_Nonnull errorInfo) {
                    if (errorInfo.code == 0) {
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic safeSetObject:roomID forKey:@"roomID"];
                        [resultDic safeSetObject:errorKeys forKey:@"errorKeys"];
                        result(resultDic);
                    } else {
                        result([FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                  message:errorInfo.message
                                  details:nil]);
                    }
                  }];
}

- (void)deleteRoomAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    NSArray<NSString *> *keys = [call.arguments objectForKey:@"keys"];
    ZIMRoomAttributesDeleteConfig *config =
        [ZIMPluginConverter oZIMRoomAttributesDeleteConfig:[call.arguments objectForKey:@"config"]];
    [zim deleteRoomAttributesByKeys:keys
                             roomID:roomID
                             config:config
                           callback:^(NSString *_Nonnull roomID,
                                      NSArray<NSString *> *_Nonnull errorKeys,
                                      ZIMError *_Nonnull errorInfo) {
                             if (errorInfo.code == 0) {
                                 NSMutableDictionary *resultDic =
                                     [[NSMutableDictionary alloc] init];
                                 [resultDic safeSetObject:roomID forKey:@"roomID"];
                                 [resultDic safeSetObject:errorKeys forKey:@"errorKeys"];
                                 result(resultDic);
                             } else {
                                 result([FlutterError
                                     errorWithCode:[NSString
                                                       stringWithFormat:@"%d", (int)errorInfo.code]
                                           message:errorInfo.message
                                           details:nil]);
                             }
                           }];
}

- (void)beginRoomAttributesBatchOperation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    ZIMRoomAttributesBatchOperationConfig *config = [ZIMPluginConverter
        oZIMRoomAttributesBatchOperationConfig:[call.arguments objectForKey:@"config"]];

    [zim beginRoomAttributesBatchOperationWithRoomID:roomID config:config];
    result(nil);
}

- (void)endRoomAttributesBatchOperation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];

    [zim
        endRoomAttributesBatchOperationWithRoomID:roomID
                                         callback:^(NSString *_Nonnull roomID,
                                                    ZIMError *_Nonnull errorInfo) {
                                           if (errorInfo.code == 0) {
                                               NSMutableDictionary *resultDic =
                                                   [[NSMutableDictionary alloc] init];
                                               [resultDic safeSetObject:roomID forKey:@"roomID"];
                                               result(resultDic);
                                           } else {
                                               result([FlutterError
                                                   errorWithCode:[NSString
                                                                     stringWithFormat:@"%d",
                                                                                      (int)errorInfo
                                                                                          .code]
                                                         message:errorInfo.message
                                                         details:nil]);
                                           }
                                         }];
}

- (void)queryRoomAllAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *roomID = [call.arguments objectForKey:@"roomID"];

    [zim queryRoomAllAttributesByRoomID:roomID
                               callback:^(
                                   NSString *_Nonnull roomID,
                                   NSDictionary<NSString *, NSString *> *_Nonnull roomAttributes,
                                   ZIMError *_Nonnull errorInfo) {
                                 if (errorInfo.code == 0) {
                                     NSMutableDictionary *resultDic =
                                         [[NSMutableDictionary alloc] init];
                                     [resultDic safeSetObject:roomID forKey:@"roomID"];
                                     [resultDic safeSetObject:roomAttributes
                                                       forKey:@"roomAttributes"];
                                     result(resultDic);
                                 } else {
                                     result([FlutterError
                                         errorWithCode:[NSString
                                                           stringWithFormat:@"%d",
                                                                            (int)errorInfo.code]
                                               message:errorInfo.message
                                               details:nil]);
                                 }
                               }];
}

- (void)setRoomMembersAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    NSDictionary *attributes = [call.arguments safeObjectForKey:@"attributes"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    ZIMRoomMemberAttributesSetConfig *setConfig = [ZIMPluginConverter
        oZIMRoomMemberAttributesSetConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        setRoomMembersAttributes:attributes
                         userIDs:userIDs
                          roomID:roomID
                          config:setConfig
                        callback:^(NSString *_Nonnull roomID,
                                   NSArray<ZIMRoomMemberAttributesOperatedInfo *> *_Nonnull infos,
                                   NSArray<NSString *> *_Nonnull errorUserList,
                                   ZIMError *_Nonnull errorInfo) {
                          if (errorInfo.code == 0) {
                              NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                              NSMutableArray *infosArr = [[NSMutableArray alloc] init];
                              for (ZIMRoomMemberAttributesOperatedInfo *info in infos) {
                                  [infosArr
                                      safeAddObject:[ZIMPluginConverter
                                                        mZIMRoomMemberAttributesOperatedInfo:info]];
                              }
                              [resultDic safeSetObject:infosArr forKey:@"infos"];
                              [resultDic safeSetObject:errorUserList forKey:@"errorUserList"];
                              [resultDic safeSetObject:roomID forKey:@"roomID"];
                              result(resultDic);
                          } else {
                              result([FlutterError
                                  errorWithCode:[NSString
                                                    stringWithFormat:@"%d", (int)errorInfo.code]
                                        message:errorInfo.message
                                        details:nil]);
                          }
                        }];
}

- (void)queryRoomMembersAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    [zim
        queryRoomMembersAttributesByUserIDs:userIDs
                                     roomID:roomID
                                   callback:^(
                                       NSString *_Nonnull roomID,
                                       NSArray<ZIMRoomMemberAttributesInfo *> *_Nonnull infos,
                                       ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         NSMutableArray *infosModel = [[NSMutableArray alloc] init];
                                         for (ZIMRoomMemberAttributesInfo *info in infos) {
                                             [infosModel
                                                 safeAddObject:
                                                     [ZIMPluginConverter
                                                         mZIMRoomMemberAttributesInfo:info]];
                                         }
                                         [resultDic safeSetObject:roomID forKey:@"roomID"];
                                         [resultDic safeSetObject:infosModel forKey:@"infos"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)queryRoomMemberAttributesList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    ZIMRoomMemberAttributesQueryConfig *queryConfig = [ZIMPluginConverter
        oZIMRoomMemberAttributesQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryRoomMemberAttributesListByRoomID:roomID
                                        config:queryConfig
                                      callback:^(
                                          NSString *_Nonnull roomID,
                                          NSArray<ZIMRoomMemberAttributesInfo *> *_Nonnull infos,
                                          NSString *_Nonnull nextFlag,
                                          ZIMError *_Nonnull errorInfo) {
                                        if (errorInfo.code == 0) {
                                            NSMutableDictionary *resultDic =
                                                [[NSMutableDictionary alloc] init];
                                            NSMutableArray *infosModel =
                                                [[NSMutableArray alloc] init];
                                            for (ZIMRoomMemberAttributesInfo *info in infos) {
                                                [infosModel
                                                    safeAddObject:
                                                        [ZIMPluginConverter
                                                            mZIMRoomMemberAttributesInfo:info]];
                                            }
                                            [resultDic safeSetObject:roomID forKey:@"roomID"];
                                            [resultDic safeSetObject:nextFlag forKey:@"nextFlag"];
                                            [resultDic safeSetObject:infosModel forKey:@"infos"];
                                            result(resultDic);
                                        } else {
                                            result([FlutterError
                                                errorWithCode:[NSString
                                                                  stringWithFormat:@"%d",
                                                                                   (int)errorInfo
                                                                                       .code]
                                                      message:errorInfo.message
                                                      details:nil]);
                                        }
                                      }];
}

- (void)createGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMGroupInfo *groupInfo =
        [ZIMPluginConverter oZIMGroupInfo:[call.arguments objectForKey:@"groupInfo"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim createGroup:groupInfo
             userIDs:userIDs
            callback:^(ZIMGroupFullInfo *_Nonnull groupInfo,
                       NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                       NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                       ZIMError *_Nonnull errorInfo) {
              if (errorInfo.code == 0) {
                  NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
                  NSArray *basicErrorUserList =
                      [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
                  NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
                  NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                  [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
                  [resultDic safeSetObject:basicUserList forKey:@"userList"];
                  [resultDic safeSetObject:basicErrorUserList forKey:@"errorUserList"];
                  result(resultDic);
              } else {
                  result([FlutterError
                      errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                            message:errorInfo.message
                            details:nil]);
              }
            }];
}

- (void)createGroupWithConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMGroupInfo *groupInfo =
        [ZIMPluginConverter oZIMGroupInfo:[call.arguments objectForKey:@"groupInfo"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];

    ZIMGroupAdvancedConfig *config =
        [ZIMPluginConverter oZIMGroupAdvancedConfig:[call.arguments objectForKey:@"config"]];
    [zim createGroup:groupInfo
             userIDs:userIDs
              config:config
            callback:^(ZIMGroupFullInfo *_Nonnull groupInfo,
                       NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                       NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                       ZIMError *_Nonnull errorInfo) {
              if (errorInfo.code == 0) {
                  NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
                  NSArray *basicErrorUserList =
                      [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
                  NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
                  NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                  [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
                  [resultDic safeSetObject:basicUserList forKey:@"userList"];
                  [resultDic safeSetObject:basicErrorUserList forKey:@"errorUserList"];
                  result(resultDic);
              } else {
                  result([FlutterError
                      errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                            message:errorInfo.message
                            details:nil]);
              }
            }];
}

- (void)joinGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim joinGroup:groupID
          callback:^(ZIMGroupFullInfo *_Nonnull groupInfo, ZIMError *_Nonnull errorInfo) {
            if (errorInfo.code == 0) {
                NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
                result(resultDic);
            } else {
                result([FlutterError
                    errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                          message:errorInfo.message
                          details:nil]);
            }
          }];
}

- (void)dismissGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim dismissGroup:groupID
             callback:^(NSString *_Nonnull groupID, ZIMError *_Nonnull errorInfo) {
               if (errorInfo.code == 0) {
                   NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                   [resultDic safeSetObject:groupID forKey:@"groupID"];
                   result(resultDic);
               } else {
                   result([FlutterError
                       errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                             message:errorInfo.message
                             details:nil]);
               }
             }];
}

- (void)leaveGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim leaveGroup:groupID
           callback:^(NSString *_Nonnull groupID, ZIMError *_Nonnull errorInfo) {
             if (errorInfo.code == 0) {
                 NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                 [resultDic safeSetObject:groupID forKey:@"groupID"];
                 result(resultDic);
             } else {
                 result([FlutterError
                     errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                           message:errorInfo.message
                           details:nil]);
             }
           }];
}

- (void)inviteUsersIntoGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim inviteUsersIntoGroup:userIDs
                      groupID:groupID
                     callback:^(NSString *_Nonnull groupID,
                                NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                                NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                ZIMError *_Nonnull errorInfo) {
                       if (errorInfo.code == 0) {
                           NSArray *basicUserList =
                               [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
                           NSArray *basicErrorUserList =
                               [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
                           NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                           [resultDic safeSetObject:groupID forKey:@"groupID"];
                           [resultDic safeSetObject:basicUserList forKey:@"userList"];
                           [resultDic safeSetObject:basicErrorUserList forKey:@"errorUserList"];
                           result(resultDic);
                       } else {
                           result([FlutterError
                               errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
                       }
                     }];
}

- (void)kickGroupMembers:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim kickGroupMembers:userIDs
                  groupID:groupID
                 callback:^(NSString *_Nonnull groupID,
                            NSArray<NSString *> *_Nonnull kickedUserIDList,
                            NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                            ZIMError *_Nonnull errorInfo) {
                   if (errorInfo.code == 0) {
                       NSArray *basicErrorUserList =
                           [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
                       NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                       [resultDic safeSetObject:groupID forKey:@"groupID"];
                       [resultDic safeSetObject:kickedUserIDList forKey:@"kickedUserIDList"];
                       [resultDic safeSetObject:basicErrorUserList forKey:@"errorUserList"];
                       result(resultDic);

                   } else {
                       result([FlutterError
                           errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                 message:errorInfo.message
                                 details:nil]);
                   }
                 }];
}

- (void)transferGroupOwner:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *userID = [call.arguments objectForKey:@"toUserID"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim transferGroupOwnerToUserID:userID
                            groupID:groupID
                           callback:^(NSString *_Nonnull groupID, NSString *_Nonnull toUserID,
                                      ZIMError *_Nonnull errorInfo) {
                             if (errorInfo.code == 0) {
                                 NSMutableDictionary *resultDic =
                                     [[NSMutableDictionary alloc] init];
                                 [resultDic safeSetObject:groupID forKey:@"groupID"];
                                 [resultDic safeSetObject:toUserID forKey:@"toUserID"];
                                 result(resultDic);
                             } else {
                                 result([FlutterError
                                     errorWithCode:[NSString
                                                       stringWithFormat:@"%d", (int)errorInfo.code]
                                           message:errorInfo.message
                                           details:nil]);
                             }
                           }];
}

- (void)updateGroupName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupName = [call.arguments objectForKey:@"groupName"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupName:groupName
                 groupID:groupID
                callback:^(NSString *_Nonnull groupID, NSString *_Nonnull groupName,
                           ZIMError *_Nonnull errorInfo) {
                  if (errorInfo.code == 0) {
                      NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                      [resultDic safeSetObject:groupID forKey:@"groupID"];
                      [resultDic safeSetObject:groupName forKey:@"groupName"];
                      result(resultDic);
                  } else {
                      result([FlutterError
                          errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                message:errorInfo.message
                                details:nil]);
                  }
                }];
}

- (void)updateGroupAvatarUrl:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupAvatarUrl = [call.arguments objectForKey:@"groupAvatarUrl"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupAvatarUrl:groupAvatarUrl
                      groupID:groupID
                     callback:^(NSString *_Nonnull groupID, NSString *_Nonnull groupAvatarUrl,
                                ZIMError *_Nonnull errorInfo) {
                       if (errorInfo.code == 0) {
                           NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                           [resultDic safeSetObject:groupID forKey:@"groupID"];
                           [resultDic safeSetObject:groupAvatarUrl forKey:@"groupAvatarUrl"];
                           result(resultDic);
                       } else {
                           result([FlutterError
                               errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
                       }
                     }];
}

- (void)updateGroupAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupAlias = [call.arguments objectForKey:@"groupAlias"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupAlias:groupAlias
                  groupID:groupID
                 callback:^(NSString *_Nonnull groupID, NSString *_Nonnull groupAlias,
                            ZIMError *_Nonnull errorInfo) {
                   if (errorInfo.code == 0) {
                       NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                       [resultDic safeSetObject:groupID forKey:@"groupID"];
                       [resultDic safeSetObject:groupAlias forKey:@"groupAlias"];
                       result(resultDic);
                   } else {
                       result([FlutterError
                           errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                 message:errorInfo.message
                                 details:nil]);
                   }
                 }];
}

- (void)updateGroupJoinMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    int mode = ((NSNumber *)[call.arguments objectForKey:@"mode"]).intValue;
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupJoinMode:mode
                     groupID:groupID
                    callback:^(NSString *_Nonnull groupID, ZIMGroupJoinMode mode,
                               ZIMError *_Nonnull errorInfo) {
                      if (errorInfo.code == 0) {
                          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                          [resultDic safeSetObject:groupID forKey:@"groupID"];
                          [resultDic safeSetObject:@(mode) forKey:@"mode"];
                          result(resultDic);
                      } else {
                          result([FlutterError
                              errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                    message:errorInfo.message
                                    details:nil]);
                      }
                    }];
}

- (void)updateGroupInviteMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    int mode = ((NSNumber *)[call.arguments objectForKey:@"mode"]).intValue;
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupInviteMode:mode
                       groupID:groupID
                      callback:^(NSString *_Nonnull groupID, ZIMGroupInviteMode mode,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic safeSetObject:groupID forKey:@"groupID"];
                            [resultDic safeSetObject:@(mode) forKey:@"mode"];
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)updateGroupBeInviteMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    int mode = ((NSNumber *)[call.arguments objectForKey:@"mode"]).intValue;
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupBeInviteMode:mode
                         groupID:groupID
                        callback:^(NSString *_Nonnull groupID, ZIMGroupBeInviteMode mode,
                                   ZIMError *_Nonnull errorInfo) {
                          if (errorInfo.code == 0) {
                              NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                              [resultDic safeSetObject:groupID forKey:@"groupID"];
                              [resultDic safeSetObject:@(mode) forKey:@"mode"];
                              result(resultDic);
                          } else {
                              result([FlutterError
                                  errorWithCode:[NSString
                                                    stringWithFormat:@"%d", (int)errorInfo.code]
                                        message:errorInfo.message
                                        details:nil]);
                          }
                        }];
}

- (void)sendGroupJoinApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupJoinApplicationSendConfig *config = [ZIMPluginConverter
        oZIMGroupJoinApplicationSendConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim sendGroupJoinApplicationToGroupID:groupID
                                    config:config
                                  callback:^(NSString *_Nonnull groupID, ZIMError *errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSMutableDictionary *resultDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultDic safeSetObject:groupID forKey:@"groupID"];
                                        result(resultDic);
                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)acceptGroupJoinApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupJoinApplicationAcceptConfig *config = [ZIMPluginConverter
        oZIMGroupJoinApplicationAcceptConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSString *userID = [call.arguments objectForKey:@"userID"];
    [zim
        acceptGroupJoinApplicationFromUserID:userID
                                     groupID:groupID
                                      config:config
                                    callback:^(NSString *_Nonnull groupID,
                                               NSString *_Nonnull userID,
                                               ZIMError *_Nonnull errorInfo) {
                                      if (errorInfo.code == 0) {
                                          NSMutableDictionary *resultDic =
                                              [[NSMutableDictionary alloc] init];
                                          [resultDic safeSetObject:groupID forKey:@"groupID"];
                                          [resultDic safeSetObject:userID forKey:@"userID"];
                                          result(resultDic);
                                      } else {
                                          result([FlutterError
                                              errorWithCode:[NSString
                                                                stringWithFormat:@"%d",
                                                                                 (int)
                                                                                     errorInfo.code]
                                                    message:errorInfo.message
                                                    details:nil]);
                                      }
                                    }];
}

- (void)rejectGroupJoinApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupJoinApplicationRejectConfig *config = [ZIMPluginConverter
        oZIMGroupJoinApplicationRejectConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSString *userID = [call.arguments objectForKey:@"userID"];
    [zim
        rejectGroupJoinApplicationFromUserID:userID
                                     groupID:groupID
                                      config:config
                                    callback:^(NSString *_Nonnull groupID,
                                               NSString *_Nonnull userID,
                                               ZIMError *_Nonnull errorInfo) {
                                      if (errorInfo.code == 0) {
                                          NSMutableDictionary *resultDic =
                                              [[NSMutableDictionary alloc] init];
                                          [resultDic safeSetObject:groupID forKey:@"groupID"];
                                          [resultDic safeSetObject:userID forKey:@"userID"];
                                          result(resultDic);
                                      } else {
                                          result([FlutterError
                                              errorWithCode:[NSString
                                                                stringWithFormat:@"%d",
                                                                                 (int)
                                                                                     errorInfo.code]
                                                    message:errorInfo.message
                                                    details:nil]);
                                      }
                                    }];
}

- (void)sendGroupInviteApplications:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupInviteApplicationSendConfig *config = [ZIMPluginConverter
        oZIMGroupInviteApplicationSendConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    [zim
        sendGroupInviteApplicationsToUserIDs:userIDs
                                     groupID:groupID
                                      config:config
                                    callback:^(NSString *_Nonnull groupID,
                                               NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                               ZIMError *_Nonnull errorInfo) {
                                      if (errorInfo.code == 0) {
                                          NSArray *basicErrorUserList = [ZIMPluginConverter
                                              mZIMErrorUserInfoList:errorUserList];
                                          NSMutableDictionary *resultDic =
                                              [[NSMutableDictionary alloc] init];
                                          [resultDic safeSetObject:groupID forKey:@"groupID"];
                                          [resultDic safeSetObject:basicErrorUserList
                                                            forKey:@"errorUserList"];
                                          result(resultDic);
                                      } else {
                                          result([FlutterError
                                              errorWithCode:[NSString
                                                                stringWithFormat:@"%d",
                                                                                 (int)
                                                                                     errorInfo.code]
                                                    message:errorInfo.message
                                                    details:nil]);
                                      }
                                    }];
}

- (void)acceptGroupInviteApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupInviteApplicationAcceptConfig *config = [ZIMPluginConverter
        oZIMGroupInviteApplicationAcceptConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSString *inviterUserID = [call.arguments objectForKey:@"inviterUserID"];
    [zim acceptGroupInviteApplicationFromInviterUserID:inviterUserID
                                               groupID:groupID
                                                config:config
                                              callback:^(ZIMGroupFullInfo *_Nonnull groupInfo,
                                                         NSString *_Nonnull inviterUserID,
                                                         ZIMError *_Nonnull errorInfo) {
                                                if (errorInfo.code == 0) {
                                                    NSDictionary *groupInfoDic = [ZIMPluginConverter
                                                        mZIMGroupFullInfo:groupInfo];
                                                    NSMutableDictionary *resultDic =
                                                        [[NSMutableDictionary alloc] init];
                                                    [resultDic safeSetObject:inviterUserID
                                                                      forKey:@"inviterUserID"];
                                                    [resultDic safeSetObject:groupInfoDic
                                                                      forKey:@"groupInfo"];
                                                    result(resultDic);
                                                } else {
                                                    result([FlutterError
                                                        errorWithCode:[NSString
                                                                          stringWithFormat:
                                                                              @"%d",
                                                                              (int)errorInfo.code]
                                                              message:errorInfo.message
                                                              details:nil]);
                                                }
                                              }];
}

- (void)rejectGroupInviteApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupInviteApplicationRejectConfig *config = [ZIMPluginConverter
        oZIMGroupInviteApplicationRejectConfig:[call.arguments objectForKey:@"config"]];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSString *inviterUserID = [call.arguments objectForKey:@"inviterUserID"];
    [zim rejectGroupInviteApplicationFromInviterUserID:inviterUserID
                                               groupID:groupID
                                                config:config
                                              callback:^(NSString *_Nonnull groupID,
                                                         NSString *_Nonnull inviterUserID,
                                                         ZIMError *_Nonnull errorInfo) {
                                                if (errorInfo.code == 0) {
                                                    NSMutableDictionary *resultDic =
                                                        [[NSMutableDictionary alloc] init];
                                                    [resultDic safeSetObject:inviterUserID
                                                                      forKey:@"inviterUserID"];
                                                    [resultDic safeSetObject:groupID
                                                                      forKey:@"groupID"];
                                                    result(resultDic);
                                                } else {
                                                    result([FlutterError
                                                        errorWithCode:[NSString
                                                                          stringWithFormat:
                                                                              @"%d",
                                                                              (int)errorInfo.code]
                                                              message:errorInfo.message
                                                              details:nil]);
                                                }
                                              }];
}

- (void)queryGroupApplicationList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMGroupApplicationListQueryConfig *config = [ZIMPluginConverter
        oZIMGroupApplicationListQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim
        queryGroupApplicationListWithConfig:config
                                   callback:^(
                                       NSArray<ZIMGroupApplicationInfo *> *_Nonnull applicationList,
                                       unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSArray *applicationListDic = [ZIMPluginConverter
                                             mZIMGroupApplicationInfoList:applicationList];
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic
                                             safeSetObject:[NSNumber
                                                               numberWithUnsignedLongLong:nextFlag]
                                                    forKey:@"nextFlag"];
                                         [resultDic safeSetObject:applicationListDic
                                                           forKey:@"applicationList"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)updateGroupNotice:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupNotice = [call.arguments objectForKey:@"groupNotice"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupNotice:groupNotice
                   groupID:groupID
                  callback:^(NSString *_Nonnull groupID, NSString *_Nonnull groupNotice,
                             ZIMError *_Nonnull errorInfo) {
                    if (errorInfo.code == 0) {
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic safeSetObject:groupID forKey:@"groupID"];
                        [resultDic safeSetObject:groupNotice forKey:@"groupNotice"];
                        result(resultDic);
                    } else {
                        result([FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                  message:errorInfo.message
                                  details:nil]);
                    }
                  }];
}

- (void)muteGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    bool isMute = ((NSNumber *)[call.arguments safeObjectForKey:@"isMute"]).boolValue;
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    ZIMGroupMuteConfig *config =
        [ZIMPluginConverter oZIMGroupMuteConfig:[call.arguments objectForKey:@"config"]];
    [zim muteGroup:isMute
           groupID:groupID
            config:config
          callback:^(NSString *_Nonnull groupID, BOOL isMuted, ZIMGroupMuteInfo *_Nonnull info,
                     ZIMError *_Nonnull errorInfo) {
            if (errorInfo.code == 0) {
                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                NSDictionary *groupMuteInfoDic = [ZIMPluginConverter mZIMGroupMuteInfo:info];
                [resultDic safeSetObject:groupID forKey:@"groupID"];
                [resultDic safeSetObject:[NSNumber numberWithBool:isMuted] forKey:@"isMute"];
                [resultDic safeSetObject:groupMuteInfoDic forKey:@"info"];
                result(resultDic);
            } else {
                result([FlutterError
                    errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                          message:errorInfo.message
                          details:nil]);
            }
          }];
}

- (void)muteGroupMembers:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    bool isMute = ((NSNumber *)[call.arguments safeObjectForKey:@"isMute"]).boolValue;
    NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    ZIMGroupMemberMuteConfig *config =
        [ZIMPluginConverter oZIMGroupMemberMuteConfig:[call.arguments objectForKey:@"config"]];
    [zim muteGroupMembers:isMute
                  userIDs:userIDs
                  groupID:groupID
                   config:config
                 callback:^(NSString *_Nonnull groupID, BOOL isMuted, int duration,
                            NSArray<NSString *> *_Nonnull mutedMemberIDs,
                            NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                            ZIMError *_Nonnull errorInfo) {
                   if (errorInfo.code == 0) {
                       NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                       NSArray *basicErrorUserList =
                           [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
                       [resultDic safeSetObject:groupID forKey:@"groupID"];
                       [resultDic safeSetObject:[NSNumber numberWithBool:isMuted] forKey:@"isMute"];
                       [resultDic safeSetObject:[NSNumber numberWithInt:duration]
                                         forKey:@"duration"];
                       [resultDic safeSetObject:mutedMemberIDs forKey:@"mutedMemberIDs"];
                       [resultDic safeSetObject:basicErrorUserList forKey:@"errorUserList"];
                       result(resultDic);
                   } else {
                       result([FlutterError
                           errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                 message:errorInfo.message
                                 details:nil]);
                   }
                 }];
}

- (void)queryGroupMemberMutedList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMemberMutedListQueryConfig *config = [ZIMPluginConverter
        oZIMGroupMemberMutedListQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryGroupMemberMutedListByGroupID:groupID
                                     config:config
                                   callback:^(NSString *_Nonnull groupID,
                                              unsigned long long nextFlag,
                                              NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSArray *basicUserList =
                                             [ZIMPluginConverter mZIMGroupMemberInfoList:userList];

                                         NSMutableDictionary *resultMtDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                         [resultMtDic
                                             safeSetObject:[NSNumber
                                                               numberWithUnsignedLongLong:nextFlag]
                                                    forKey:@"nextFlag"];
                                         [resultMtDic safeSetObject:basicUserList
                                                             forKey:@"userList"];
                                         result(resultMtDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)queryGroupInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim queryGroupInfoByGroupID:groupID
                        callback:^(ZIMGroupFullInfo *_Nonnull groupInfo,
                                   ZIMError *_Nonnull errorInfo) {
                          if (errorInfo.code == 0) {
                              NSDictionary *groupInfoDic =
                                  [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
                              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                              [resultMtDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
                              result(resultMtDic);
                          } else {
                              result([FlutterError
                                  errorWithCode:[NSString
                                                    stringWithFormat:@"%d", (int)errorInfo.code]
                                        message:errorInfo.message
                                        details:nil]);
                          }
                        }];
}

- (void)setGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    NSDictionary *groupAttributes = [call.arguments objectForKey:@"groupAttributes"];
    [zim setGroupAttributes:groupAttributes
                    groupID:groupID
                   callback:^(NSString *_Nonnull groupID, NSArray<NSString *> *_Nonnull errorKeys,
                              ZIMError *_Nonnull errorInfo) {
                     if (errorInfo.code == 0) {
                         NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                         [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                         [resultMtDic safeSetObject:errorKeys forKey:@"errorKeys"];
                         result(resultMtDic);
                     } else {
                         result([FlutterError
                             errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                   message:errorInfo.message
                                   details:nil]);
                     }
                   }];
}

- (void)deleteGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    NSArray *keys = [call.arguments safeObjectForKey:@"keys"];
    [zim deleteGroupAttributesByKeys:keys
                             groupID:groupID
                            callback:^(NSString *_Nonnull groupID,
                                       NSArray<NSString *> *_Nonnull errorKeys,
                                       ZIMError *_Nonnull errorInfo) {
                              if (errorInfo.code == 0) {
                                  NSMutableDictionary *resultMtDic =
                                      [[NSMutableDictionary alloc] init];
                                  [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                  [resultMtDic safeSetObject:errorKeys forKey:@"errorKeys"];
                                  result(resultMtDic);
                              } else {
                                  result([FlutterError
                                      errorWithCode:[NSString
                                                        stringWithFormat:@"%d", (int)errorInfo.code]
                                            message:errorInfo.message
                                            details:nil]);
                              }
                            }];
}

- (void)queryGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    NSArray *keys = [call.arguments safeObjectForKey:@"keys"];
    [zim
        queryGroupAttributesByKeys:keys
                           groupID:groupID
                          callback:^(NSString *_Nonnull groupID,
                                     NSDictionary<NSString *, NSString *> *_Nonnull groupAttributes,
                                     ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSMutableDictionary *resultMtDic =
                                    [[NSMutableDictionary alloc] init];
                                [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                [resultMtDic safeSetObject:groupAttributes
                                                    forKey:@"groupAttributes"];
                                result(resultMtDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)queryGroupAllAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    [zim queryGroupAllAttributesByGroupID:groupID
                                 callback:^(
                                     NSString *_Nonnull groupID,
                                     NSDictionary<NSString *, NSString *> *_Nonnull groupAttributes,
                                     ZIMError *_Nonnull errorInfo) {
                                   if (errorInfo.code == 0) {
                                       NSMutableDictionary *resultMtDic =
                                           [[NSMutableDictionary alloc] init];
                                       [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                       [resultMtDic safeSetObject:groupAttributes
                                                           forKey:@"groupAttributes"];
                                       result(resultMtDic);
                                   } else {
                                       result([FlutterError
                                           errorWithCode:[NSString
                                                             stringWithFormat:@"%d",
                                                                              (int)errorInfo.code]
                                                 message:errorInfo.message
                                                 details:nil]);
                                   }
                                 }];
}

- (void)setGroupMemberRole:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMGroupMemberRole role = ((NSNumber *)[call.arguments safeObjectForKey:@"role"]).intValue;
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];

    NSString *forUserID = [call.arguments safeObjectForKey:@"forUserID"];
    [zim setGroupMemberRole:role
                  forUserID:forUserID
                    groupID:groupID
                   callback:^(NSString *_Nonnull groupID, NSString *_Nonnull forUserID,
                              ZIMGroupMemberRole role, ZIMError *_Nonnull errorInfo) {
                     if (errorInfo.code == 0) {
                         NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                         [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                         [resultMtDic safeSetObject:forUserID forKey:@"forUserID"];
                         [resultMtDic safeSetObject:[NSNumber numberWithInt:role] forKey:@"role"];
                         result(resultMtDic);
                     } else {
                         result([FlutterError
                             errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                   message:errorInfo.message
                                   details:nil]);
                     }
                   }];
}

- (void)setGroupMemberNickname:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *nickname = [call.arguments safeObjectForKey:@"nickname"];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    NSString *forUserID = [call.arguments safeObjectForKey:@"forUserID"];
    [zim
        setGroupMemberNickname:nickname
                     forUserID:forUserID
                       groupID:groupID
                      callback:^(NSString *_Nonnull groupID, NSString *_Nonnull forUserID,
                                 NSString *_Nonnull nickname, ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                            [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                            [resultMtDic safeSetObject:forUserID forKey:@"forUserID"];
                            [resultMtDic safeSetObject:nickname forKey:@"nickname"];
                            result(resultMtDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)queryGroupMemberInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *userID = [call.arguments safeObjectForKey:@"userID"];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    [zim queryGroupMemberInfoByUserID:userID
                              groupID:groupID
                             callback:^(NSString *_Nonnull groupID,
                                        ZIMGroupMemberInfo *_Nonnull userInfo,
                                        ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSDictionary *userInfoDic =
                                       [ZIMPluginConverter mZIMGroupMemberInfo:userInfo];
                                   NSMutableDictionary *resultMtDic =
                                       [[NSMutableDictionary alloc] init];
                                   [resultMtDic safeSetObject:userInfoDic forKey:@"userInfo"];
                                   [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                   result(resultMtDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)queryGroupList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    [zim queryGroupList:^(NSArray<ZIMGroup *> *_Nonnull groupList, ZIMError *_Nonnull errorInfo) {
      if (errorInfo.code == 0) {
          NSArray *basicGroupList = [ZIMPluginConverter mZIMGroupList:groupList];
          NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
          [resultMtDic safeSetObject:basicGroupList forKey:@"groupList"];
          result(resultMtDic);
      } else {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
      }
    }];
}

- (void)queryGroupMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMemberQueryConfig *config =
        [ZIMPluginConverter oZIMGroupMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        queryGroupMemberListByGroupID:groupID
                               config:config
                             callback:^(NSString *_Nonnull groupID,
                                        NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                                        unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSArray *basicUserList =
                                       [ZIMPluginConverter mZIMGroupMemberInfoList:userList];

                                   NSMutableDictionary *resultMtDic =
                                       [[NSMutableDictionary alloc] init];
                                   [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                   [resultMtDic safeSetObject:basicUserList forKey:@"userList"];
                                   [resultMtDic
                                       safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag]
                                              forKey:@"nextFlag"];
                                   result(resultMtDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)queryGroupMemberCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    [zim queryGroupMemberCountByGroupID:groupID
                               callback:^(NSString *_Nonnull groupID, unsigned int count,
                                          ZIMError *_Nonnull errorInfo) {
                                 if (errorInfo.code == 0) {
                                     NSMutableDictionary *resultMtDic =
                                         [[NSMutableDictionary alloc] init];
                                     [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                     [resultMtDic
                                         safeSetObject:[NSNumber numberWithUnsignedInt:count]
                                                forKey:@"count"];
                                     result(resultMtDic);
                                 } else {
                                     result([FlutterError
                                         errorWithCode:[NSString
                                                           stringWithFormat:@"%d",
                                                                            (int)errorInfo.code]
                                               message:errorInfo.message
                                               details:nil]);
                                 }
                               }];
}

- (void)searchLocalGroups:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMGroupSearchConfig *config =
        [ZIMPluginConverter oZIMGroupSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim searchLocalGroupsWithConfig:config
                            callback:^(NSArray<ZIMGroupSearchInfo *> *_Nonnull groupSearchInfoList,
                                       unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                              if (errorInfo.code == 0) {
                                  NSMutableDictionary *resultMtDic =
                                      [[NSMutableDictionary alloc] init];
                                  [resultMtDic
                                      safeSetObject:[ZIMPluginConverter
                                                        mZIMGroupSearchInfoList:groupSearchInfoList]
                                             forKey:@"groupSearchInfoList"];
                                  [resultMtDic safeSetObject:@(nextFlag) forKey:@"nextFlag"];
                                  result(resultMtDic);

                              } else {
                                  result([FlutterError
                                      errorWithCode:[NSString
                                                        stringWithFormat:@"%d", (int)errorInfo.code]
                                            message:errorInfo.message
                                            details:nil]);
                              }
                            }];
}

- (void)searchLocalGroupMembers:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMemberSearchConfig *config =
        [ZIMPluginConverter oZIMGroupMemberSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim searchLocalGroupMembersByGroupID:groupID
                                   config:config
                                 callback:^(NSString *_Nonnull groupID,
                                            NSArray<ZIMGroupMemberInfo *> *_Nonnull userList,
                                            unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                                   if (errorInfo.code == 0) {
                                       NSMutableDictionary *resultMtDic =
                                           [[NSMutableDictionary alloc] init];
                                       [resultMtDic safeSetObject:groupID forKey:@"groupID"];
                                       [resultMtDic
                                           safeSetObject:[ZIMPluginConverter
                                                             mZIMGroupMemberInfoList:userList]
                                                  forKey:@"userList"];
                                       [resultMtDic safeSetObject:@(nextFlag) forKey:@"nextFlag"];
                                       result(resultMtDic);

                                   } else {
                                       result([FlutterError
                                           errorWithCode:[NSString
                                                             stringWithFormat:@"%d",
                                                                              (int)errorInfo.code]
                                                 message:errorInfo.message
                                                 details:nil]);
                                   }
                                 }];
}

- (void)callInvite:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
    ZIMCallInviteConfig *config =
        [ZIMPluginConverter oZIMCallInviteConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        callInviteWithInvitees:invitees
                        config:config
                      callback:^(NSString *_Nonnull callID,
                                 ZIMCallInvitationSentInfo *_Nonnull info,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                            [resultMtDic safeSetObject:callID forKey:@"callID"];
                            NSDictionary *infoDic =
                                [ZIMPluginConverter mZIMCallInvitationSentInfo:info];
                            [resultMtDic safeSetObject:infoDic forKey:@"info"];
                            result(resultMtDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)callingInvite:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
    ZIMCallingInviteConfig *config =
        [ZIMPluginConverter oZIMCallingInviteConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim callingInviteWithInvitees:invitees
                            callID:callID
                            config:config
                          callback:^(NSString *_Nonnull callID,
                                     ZIMCallingInvitationSentInfo *_Nonnull info,
                                     ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSMutableDictionary *resultMtDic =
                                    [[NSMutableDictionary alloc] init];
                                [resultMtDic safeSetObject:callID forKey:@"callID"];
                                NSDictionary *infoDic =
                                    [ZIMPluginConverter mZIMCallingInvitationSentInfo:info];
                                [resultMtDic safeSetObject:infoDic forKey:@"info"];
                                result(resultMtDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)callQuit:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallQuitConfig *config =
        [ZIMPluginConverter oZIMCallQuitConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim callQuit:callID
           config:config
         callback:^(NSString *callID, ZIMCallQuitSentInfo *info, ZIMError *errorInfo) {
           if (errorInfo.code == 0) {
               NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
               [resultMtDic safeSetObject:callID forKey:@"callID"];
               NSDictionary *infoDic = [ZIMPluginConverter mZIMCallQuitSentInfo:info];
               [resultMtDic safeSetObject:infoDic forKey:@"info"];
               result(resultMtDic);
           } else {
               result([FlutterError
                   errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                         message:errorInfo.message
                         details:nil]);
           }
         }];
}

- (void)callEnd:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallEndConfig *config =
        [ZIMPluginConverter oZIMCallEndConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim callEnd:callID
          config:config
        callback:^(NSString *callID, ZIMCallEndedSentInfo *info, ZIMError *errorInfo) {
          if (errorInfo.code == 0) {
              NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
              [resultMtDic safeSetObject:callID forKey:@"callID"];
              NSDictionary *infoDic = [ZIMPluginConverter mZIMCallEndSentInfo:info];
              [resultMtDic safeSetObject:infoDic forKey:@"info"];
              result(resultMtDic);
          } else {
              result([FlutterError
                  errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                        message:errorInfo.message
                        details:nil]);
          }
        }];
}

- (void)queryCallList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMCallInvitationQueryConfig *config =
        [ZIMPluginConverter oZIMQueryCallListConfig:[call.arguments safeObjectForKey:@"config"]];

    [zim queryCallInvitationListWithConfig:config
                                  callback:^(NSArray<ZIMCallInfo *> *_Nonnull callList,
                                             long long nextFlag, ZIMError *_Nonnull errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSArray *basicCallInfoList =
                                            [ZIMPluginConverter mZIMCallInfoList:callList];

                                        NSMutableDictionary *resultMtDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultMtDic safeSetObject:basicCallInfoList
                                                            forKey:@"callList"];
                                        [resultMtDic
                                            safeSetObject:[NSNumber numberWithLongLong:nextFlag]
                                                   forKey:@"nextFlag"];
                                        result(resultMtDic);
                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)callCancel:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallCancelConfig *config =
        [ZIMPluginConverter oZIMCallCancelConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim
        callCancelWithInvitees:invitees
                        callID:callID
                        config:config
                      callback:^(NSString *_Nonnull callID,
                                 NSArray<NSString *> *_Nonnull errorInvitees,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                            [resultMtDic safeSetObject:callID forKey:@"callID"];
                            [resultMtDic safeSetObject:errorInvitees forKey:@"errorInvitees"];
                            result(resultMtDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)callAccept:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallAcceptConfig *config =
        [ZIMPluginConverter oZIMCallAcceptConfig:[call.arguments safeObjectForKey:@"config"]];

    [zim callAcceptWithCallID:callID
                       config:config
                     callback:^(NSString *_Nonnull callID, ZIMError *_Nonnull errorInfo) {
                       if (errorInfo.code == 0) {
                           NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                           [resultMtDic safeSetObject:callID forKey:@"callID"];
                           result(resultMtDic);
                       } else {
                           result([FlutterError
                               errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
                       }
                     }];
}

- (void)callReject:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallRejectConfig *config =
        [ZIMPluginConverter oZIMCallRejectConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim callRejectWithCallID:callID
                       config:config
                     callback:^(NSString *_Nonnull callID, ZIMError *_Nonnull errorInfo) {
                       if (errorInfo.code == 0) {
                           NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                           [resultMtDic safeSetObject:callID forKey:@"callID"];
                           result(resultMtDic);
                       } else {
                           result([FlutterError
                               errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                     message:errorInfo.message
                                     details:nil]);
                       }
                     }];
}

- (void)callJoin:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallJoinConfig *config =
        [ZIMPluginConverter oZIMCallJoinConfig:[call.arguments safeObjectForKey:@"config"]];

    [zim callJoin:callID
           config:config
         callback:^(NSString *_Nonnull callID, ZIMCallJoinSentInfo *_Nonnull info,
                    ZIMError *_Nonnull errorInfo) {
           if (errorInfo.code == 0) {
               NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
               NSMutableDictionary *callJoinInfoMap = [[NSMutableDictionary alloc] init];
               [callJoinInfoMap setObject:info.extendedData forKey:@"extendedData"];
               [callJoinInfoMap
                   setObject:[ZIMPluginConverter mZIMCallUserInfoList:info.callUserList]
                      forKey:@"callUserList"];
               [callJoinInfoMap setObject:[NSNumber numberWithLongLong:info.createTime]
                                   forKey:@"createTime"];
               [callJoinInfoMap setObject:[NSNumber numberWithLongLong:info.joinTime]
                                   forKey:@"joinTime"];
               [resultMtDic setObject:callJoinInfoMap forKey:@"info"];
               [resultMtDic setObject:callID forKey:@"callID"];
               result(resultMtDic);
           } else {
               result([FlutterError
                   errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                         message:errorInfo.message
                         details:nil]);
           }
         }];
}

- (void)addMessageReaction:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *reactionType = [call.arguments safeObjectForKey:@"reactionType"];
    [zim addMessageReaction:reactionType
                    message:message
                   callback:^(ZIMMessageReaction *_Nonnull reaction, ZIMError *_Nonnull errorInfo) {
                     if (errorInfo.code == 0) {
                         NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                         NSDictionary *reactionDic =
                             [ZIMPluginConverter mZIMMessageReaction:reaction];
                         [resultMtDic safeSetObject:reactionDic forKey:@"reaction"];
                         result(resultMtDic);
                     } else {
                         result([FlutterError
                             errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                   message:errorInfo.message
                                   details:nil]);
                     }
                   }];
}
- (void)deleteMessageReaction:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *reactionType = [call.arguments safeObjectForKey:@"reactionType"];
    [zim deleteMessageReaction:reactionType
                       message:message
                      callback:^(ZIMMessageReaction *_Nonnull reaction,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
                            NSDictionary *reactionDic =
                                [ZIMPluginConverter mZIMMessageReaction:reaction];
                            [resultMtDic safeSetObject:reactionDic forKey:@"reaction"];
                            result(resultMtDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)queryMessageReactionUserList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    ZIMMessageReactionUserQueryConfig *config = [ZIMPluginConverter
        oZIMMessageReactionUsersQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryMessageReactionUserListByMessage:message
                                        config:config
                                      callback:^(
                                          ZIMMessage *_Nonnull message,
                                          NSArray<ZIMMessageReactionUserInfo *> *_Nonnull userList,
                                          NSString *_Nonnull reactionType, long long nextFlag,
                                          int totalCount, ZIMError *_Nonnull errorInfo) {
                                        if (errorInfo.code == 0) {
                                            NSMutableDictionary *resultMtDic =
                                                [[NSMutableDictionary alloc] init];
                                            NSDictionary *messageDic =
                                                [ZIMPluginConverter mZIMMessage:message];
                                            NSArray *userListDic = [ZIMPluginConverter
                                                mZIMMessageReactionUserInfoList:userList];

                                            [resultMtDic safeSetObject:messageDic
                                                                forKey:@"message"];
                                            [resultMtDic safeSetObject:userListDic
                                                                forKey:@"userList"];
                                            [resultMtDic safeSetObject:reactionType
                                                                forKey:@"reactionType"];
                                            [resultMtDic
                                                safeSetObject:
                                                    [NSNumber numberWithUnsignedLongLong:nextFlag]
                                                       forKey:@"nextFlag"];
                                            [resultMtDic
                                                safeSetObject:
                                                    [NSNumber numberWithUnsignedInteger:totalCount]
                                                       forKey:@"totalCount"];
                                            result(resultMtDic);
                                        } else {
                                            result([FlutterError
                                                errorWithCode:[NSString
                                                                  stringWithFormat:@"%d",
                                                                                   (int)errorInfo
                                                                                       .code]
                                                      message:errorInfo.message
                                                      details:nil]);
                                        }
                                      }];
}
- (void)queryCombineMessageDetail:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMCombineMessage *message =
        [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];

    [zim queryCombineMessageDetailByMessage:message
                                   callback:^(ZIMCombineMessage *_Nonnull message,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableDictionary *resultMtDic =
                                             [[NSMutableDictionary alloc] init];
                                         NSDictionary *messageDic =
                                             [ZIMPluginConverter mZIMMessage:message];
                                         [resultMtDic safeSetObject:messageDic forKey:@"message"];
                                         result(resultMtDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)addUsersToBlacklist:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim addUsersToBlacklistWithUserIDs:userIDs
                               callback:^(NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                          ZIMError *_Nonnull errorInfo) {
                                 if (errorInfo.code == 0) {
                                     NSMutableArray *errorUserListBasic =
                                         [[NSMutableArray alloc] init];
                                     for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                                         NSMutableDictionary *errorUserInfoDic =
                                             [[NSMutableDictionary alloc] init];
                                         [errorUserInfoDic safeSetObject:errorUserInfo.userID
                                                                  forKey:@"userID"];
                                         [errorUserInfoDic
                                             safeSetObject:[NSNumber
                                                               numberWithUnsignedInt:errorUserInfo
                                                                                         .reason]
                                                    forKey:@"reason"];
                                         [errorUserListBasic addObject:errorUserInfoDic];
                                     }
                                     NSMutableDictionary *resultDic =
                                         [[NSMutableDictionary alloc] init];
                                     [resultDic safeSetObject:errorUserListBasic
                                                       forKey:@"errorUserList"];
                                     result(resultDic);
                                 } else {
                                     result([FlutterError
                                         errorWithCode:[NSString
                                                           stringWithFormat:@"%d",
                                                                            (int)errorInfo.code]
                                               message:errorInfo.message
                                               details:nil]);
                                 }
                               }];
}

- (void)removeUsersFromBlacklist:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim
        removeUsersFromBlacklistWithUserIDs:userIDs
                                   callback:^(NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                              ZIMError *_Nonnull errorInfo) {
                                     if (errorInfo.code == 0) {
                                         NSMutableArray *errorUserListBasic =
                                             [[NSMutableArray alloc] init];
                                         for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                                             NSMutableDictionary *errorUserInfoDic =
                                                 [[NSMutableDictionary alloc] init];
                                             [errorUserInfoDic safeSetObject:errorUserInfo.userID
                                                                      forKey:@"userID"];
                                             [errorUserInfoDic
                                                 safeSetObject:[NSNumber numberWithUnsignedInt:
                                                                             errorUserInfo.reason]
                                                        forKey:@"reason"];
                                             [errorUserListBasic addObject:errorUserInfoDic];
                                         }
                                         NSMutableDictionary *resultDic =
                                             [[NSMutableDictionary alloc] init];
                                         [resultDic safeSetObject:errorUserListBasic
                                                           forKey:@"errorUserList"];
                                         result(resultDic);
                                     } else {
                                         result([FlutterError
                                             errorWithCode:[NSString
                                                               stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                                   message:errorInfo.message
                                                   details:nil]);
                                     }
                                   }];
}

- (void)checkUserIsInBlackList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *userID = [call.arguments objectForKey:@"userID"];
    [zim checkUserIsInBlacklistByUserID:userID
                               callback:^(BOOL isUserInBlacklist, ZIMError *_Nonnull errorInfo) {
                                 if (errorInfo.code == 0) {
                                     NSMutableDictionary *resultDic =
                                         [[NSMutableDictionary alloc] init];
                                     [resultDic
                                         safeSetObject:[NSNumber numberWithBool:isUserInBlacklist]
                                                forKey:@"isUserInBlacklist"];
                                     result(resultDic);
                                 } else {
                                     result([FlutterError
                                         errorWithCode:[NSString
                                                           stringWithFormat:@"%d",
                                                                            (int)errorInfo.code]
                                               message:errorInfo.message
                                               details:nil]);
                                 }
                               }];
}

- (void)queryBlackList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMBlacklistQueryConfig *queryConfig =
        [ZIMPluginConverter oZIMBlacklistQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryBlacklistWithConfig:queryConfig
                         callback:^(NSArray<ZIMUserInfo *> *_Nonnull blacklist,
                                    unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                           if (errorInfo.code == 0) {
                               NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                               [resultDic
                                   safeSetObject:[ZIMPluginConverter mZIMUserInfoList:blacklist]
                                          forKey:@"blacklist"];
                               [resultDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag]
                                                 forKey:@"nextFlag"];
                               result(resultDic);
                           } else {
                               result([FlutterError
                                   errorWithCode:[NSString
                                                     stringWithFormat:@"%d", (int)errorInfo.code]
                                         message:errorInfo.message
                                         details:nil]);
                           }
                         }];
}

- (void)addFriend:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendAddConfig *addConfig =
        [ZIMPluginConverter oZIMFriendAddConfig:[call.arguments objectForKey:@"config"]];
    NSString *userID = [call.arguments objectForKey:@"userID"];

    [zim addFriendByUserID:userID
                    config:addConfig
                  callback:^(ZIMFriendInfo *_Nonnull friendInfo, ZIMError *_Nonnull errorInfo) {
                    if (errorInfo.code == 0) {
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic safeSetObject:[ZIMPluginConverter mZIMFriendInfo:friendInfo]
                                          forKey:@"friendInfo"];
                        result(resultDic);
                    } else {
                        result([FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                  message:errorInfo.message
                                  details:nil]);
                    }
                  }];
}

- (void)sendFriendApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendApplicationSendConfig *sendConfig = [ZIMPluginConverter
        oZIMFriendApplicationSendConfig:[call.arguments objectForKey:@"config"]];
    NSString *userID = [call.arguments objectForKey:@"userID"];
    [zim
        sendFriendApplicationToUserID:userID
                               config:sendConfig
                             callback:^(ZIMFriendApplicationInfo *_Nonnull friendApplicationInfo,
                                        ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSMutableDictionary *resultDic =
                                       [[NSMutableDictionary alloc] init];
                                   [resultDic
                                       safeSetObject:[ZIMPluginConverter mZIMFriendApplicationInfo:
                                                                             friendApplicationInfo]
                                              forKey:@"applicationInfo"];
                                   result(resultDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)searchLocalFriends:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendSearchConfig *config =
        [ZIMPluginConverter oZIMFriendSearchConfig:[call.arguments objectForKey:@"config"]];
    [zim
        searchLocalFriendsWithConfig:config
                            callback:^(NSArray<ZIMFriendInfo *> *_Nonnull friendInfos,
                                       unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                              if (errorInfo.code == 0) {
                                  NSMutableDictionary *resultDic =
                                      [[NSMutableDictionary alloc] init];
                                  [resultDic safeSetObject:[ZIMPluginConverter
                                                               mZIMFriendInfoList:friendInfos]
                                                    forKey:@"friendInfos"];
                                  [resultDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag]
                                                    forKey:@"nextFlag"];
                                  result(resultDic);
                              } else {
                                  result([FlutterError
                                      errorWithCode:[NSString
                                                        stringWithFormat:@"%d", (int)errorInfo.code]
                                            message:errorInfo.message
                                            details:nil]);
                              }
                            }];
}

- (void)deleteFriends:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendDeleteConfig *deleteConfig =
        [ZIMPluginConverter oZIMFriendDeleteConfig:[call.arguments objectForKey:@"config"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim
        deleteFriendsByUserIDs:userIDs
                        config:deleteConfig
                      callback:^(NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                 ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableArray *errorUserListBasic = [[NSMutableArray alloc] init];
                            for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                                NSMutableDictionary *errorUserInfoDic =
                                    [[NSMutableDictionary alloc] init];
                                [errorUserInfoDic safeSetObject:errorUserInfo.userID
                                                         forKey:@"userID"];
                                [errorUserInfoDic
                                    safeSetObject:[NSNumber
                                                      numberWithUnsignedInt:errorUserInfo.reason]
                                           forKey:@"reason"];
                                [errorUserListBasic addObject:errorUserInfoDic];
                            }
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic safeSetObject:errorUserListBasic forKey:@"errorUserList"];
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)checkFriendsRelation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendRelationCheckConfig *checkConfig =
        [ZIMPluginConverter oZIMFriendRelationCheckConfig:[call.arguments objectForKey:@"config"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim
        checkFriendsRelationByUserIDs:userIDs
                               config:checkConfig
                             callback:^(NSArray<ZIMFriendRelationInfo *> *friendRelationInfoList,
                                        NSArray<ZIMErrorUserInfo *> *_Nonnull errorUserList,
                                        ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSMutableArray *errorUserListBasic =
                                       [[NSMutableArray alloc] init];
                                   for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                                       NSMutableDictionary *errorUserInfoDic =
                                           [[NSMutableDictionary alloc] init];
                                       [errorUserInfoDic safeSetObject:errorUserInfo.userID
                                                                forKey:@"userID"];
                                       [errorUserInfoDic
                                           safeSetObject:[NSNumber
                                                             numberWithUnsignedInt:errorUserInfo
                                                                                       .reason]
                                                  forKey:@"reason"];
                                       [errorUserListBasic addObject:errorUserInfoDic];
                                   }
                                   NSMutableDictionary *resultDic =
                                       [[NSMutableDictionary alloc] init];
                                   [resultDic safeSetObject:errorUserListBasic
                                                     forKey:@"errorUserList"];
                                   [resultDic
                                       safeSetObject:[ZIMPluginConverter mZIMFriendRelationInfoList:
                                                                             friendRelationInfoList]
                                              forKey:@"relationInfos"];
                                   result(resultDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)updateFriendAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *friendAlias = [call.arguments objectForKey:@"friendAlias"];
    NSString *userID = [call.arguments objectForKey:@"userID"];
    [zim updateFriendAlias:friendAlias
                    userID:userID
                  callback:^(ZIMFriendInfo *_Nonnull friendInfo, ZIMError *_Nonnull errorInfo) {
                    if (errorInfo.code == 0) {
                        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                        [resultDic safeSetObject:[ZIMPluginConverter mZIMFriendInfo:friendInfo]
                                          forKey:@"friendInfo"];
                        result(resultDic);
                    } else {
                        result([FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                  message:errorInfo.message
                                  details:nil]);
                    }
                  }];
}

- (void)updateFriendAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *userID = [call.arguments objectForKey:@"userID"];
    NSDictionary<NSString *, NSString *> *friendAttributes =
        [call.arguments objectForKey:@"friendAttributes"];

    [zim
        updateFriendAttributes:friendAttributes
                        userID:userID
                      callback:^(ZIMFriendInfo *_Nonnull friendInfo, ZIMError *_Nonnull errorInfo) {
                        if (errorInfo.code == 0) {
                            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                            [resultDic safeSetObject:[ZIMPluginConverter mZIMFriendInfo:friendInfo]
                                              forKey:@"friendInfo"];
                            result(resultDic);
                        } else {
                            result([FlutterError
                                errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                                      message:errorInfo.message
                                      details:nil]);
                        }
                      }];
}

- (void)queryFriendsInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim
        queryFriendsInfoByUserIDs:userIDs
                         callback:^(NSArray<ZIMFriendInfo *> *_Nonnull friendInfoList,
                                    NSArray<ZIMErrorUserInfo *> *_Nullable errorUserList,
                                    ZIMError *_Nonnull errorInfo) {
                           if (errorInfo.code == 0) {
                               NSMutableArray *errorUserListBasic = [[NSMutableArray alloc] init];
                               for (ZIMErrorUserInfo *errorUserInfo in errorUserList) {
                                   NSMutableDictionary *errorUserInfoDic =
                                       [[NSMutableDictionary alloc] init];
                                   [errorUserInfoDic safeSetObject:errorUserInfo.userID
                                                            forKey:@"userID"];
                                   [errorUserInfoDic
                                       safeSetObject:[NSNumber
                                                         numberWithUnsignedInt:errorUserInfo.reason]
                                              forKey:@"reason"];
                                   [errorUserListBasic addObject:errorUserInfoDic];
                               }
                               NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                               [resultDic safeSetObject:errorUserListBasic forKey:@"errorUserList"];
                               [resultDic safeSetObject:[ZIMPluginConverter
                                                            mZIMFriendInfoList:friendInfoList]
                                                 forKey:@"friendInfos"];
                               result(resultDic);
                           } else {
                               result([FlutterError
                                   errorWithCode:[NSString
                                                     stringWithFormat:@"%d", (int)errorInfo.code]
                                         message:errorInfo.message
                                         details:nil]);
                           }
                         }];
}

- (void)acceptFriendApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *userID = [call.arguments objectForKey:@"userID"];
    ZIMFriendApplicationAcceptConfig *config = [ZIMPluginConverter
        oZIMFriendApplicationAcceptConfig:[call.arguments objectForKey:@"config"]];
    [zim acceptFriendApplicationFromUserID:userID
                                    config:config
                                  callback:^(ZIMFriendInfo *_Nonnull friendInfo,
                                             ZIMError *_Nonnull errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSMutableDictionary *resultDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultDic safeSetObject:[ZIMPluginConverter
                                                                     mZIMFriendInfo:friendInfo]
                                                          forKey:@"friendInfo"];
                                        result(resultDic);
                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)rejectFriendApplication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *userID = [call.arguments objectForKey:@"userID"];
    ZIMFriendApplicationRejectConfig *config = [ZIMPluginConverter
        oZIMFriendApplicationRejectConfig:[call.arguments objectForKey:@"config"]];
    [zim rejectFriendApplicationFromUserID:userID
                                    config:config
                                  callback:^(ZIMUserInfo *_Nonnull userInfo,
                                             ZIMError *_Nonnull errorInfo) {
                                    if (errorInfo.code == 0) {
                                        NSMutableDictionary *resultDic =
                                            [[NSMutableDictionary alloc] init];
                                        [resultDic
                                            safeSetObject:[ZIMPluginConverter mZIMUserInfo:userInfo]
                                                   forKey:@"userInfo"];
                                        result(resultDic);
                                    } else {
                                        result([FlutterError
                                            errorWithCode:[NSString
                                                              stringWithFormat:@"%d",
                                                                               (int)errorInfo.code]
                                                  message:errorInfo.message
                                                  details:nil]);
                                    }
                                  }];
}

- (void)queryFriendList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMFriendListQueryConfig *config =
        [ZIMPluginConverter oZIMFriendListQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryFriendListWithConfig:config
                          callback:^(NSArray<ZIMFriendInfo *> *_Nonnull friendInfoList,
                                     unsigned int nextFlag, ZIMError *_Nonnull errorInfo) {
                            if (errorInfo.code == 0) {
                                NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
                                [resultDic safeSetObject:[ZIMPluginConverter
                                                             mZIMFriendInfoList:friendInfoList]
                                                  forKey:@"friendList"];
                                [resultDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag]
                                                  forKey:@"nextFlag"];
                                result(resultDic);
                            } else {
                                result([FlutterError
                                    errorWithCode:[NSString
                                                      stringWithFormat:@"%d", (int)errorInfo.code]
                                          message:errorInfo.message
                                          details:nil]);
                            }
                          }];
}

- (void)queryFriendApplicationList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMFriendApplicationListQueryConfig *config = [ZIMPluginConverter
        oZIMFriendApplicationListQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim
        queryFriendApplicationListWithConfig:config
                                    callback:^(NSArray<ZIMFriendApplicationInfo *>
                                                   *_Nullable friendApplicationInfoList,
                                               unsigned int nextFlag,
                                               ZIMError *_Nonnull errorInfo) {
                                      if (errorInfo.code == 0) {
                                          NSMutableDictionary *resultDic =
                                              [[NSMutableDictionary alloc] init];
                                          [resultDic
                                              safeSetObject:[ZIMPluginConverter
                                                                mZIMFriendApplicationInfoList:
                                                                    friendApplicationInfoList]
                                                     forKey:@"applicationList"];
                                          [resultDic
                                              safeSetObject:[NSNumber
                                                                numberWithUnsignedInt:nextFlag]
                                                     forKey:@"nextFlag"];
                                          result(resultDic);
                                      } else {
                                          result([FlutterError
                                              errorWithCode:[NSString
                                                                stringWithFormat:@"%d",
                                                                                 (int)
                                                                                     errorInfo.code]
                                                    message:errorInfo.message
                                                    details:nil]);
                                      }
                                    }];
}

- (void)exportLocalMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *folderPath = [call.arguments objectForKey:@"folderPath"];
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];
    ZIMMessageExportConfig *config = [[ZIMMessageExportConfig alloc] init];

    [zim exportLocalMessagesToFolderPath:folderPath
        config:config
        progress:^(unsigned long long exportedMessageCount, unsigned long long totalMessageCount) {
          if (progressID == nil) {
              return;
          }

          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:handle forKey:@"handle"];
          [resultDic safeSetObject:@"messageExportingProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:exportedMessageCount]
                            forKey:@"exportedMessageCount"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalMessageCount]
                            forKey:@"totalMessageCount"];
          self.events(resultDic);
        }
        callback:^(ZIMError *_Nonnull errorInfo) {
          if (errorInfo.code == 0) {
              result(nil);
          } else {
              result([FlutterError
                  errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                        message:errorInfo.message
                        details:nil]);
          }
        }];
}

- (void)importLocalMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    NSString *folderPath = [call.arguments objectForKey:@"folderPath"];
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];
    ZIMMessageImportConfig *config = [[ZIMMessageImportConfig alloc] init];

    [zim importLocalMessagesFromFolderPath:folderPath
        config:config
        progress:^(unsigned long long importedMessageCount, unsigned long long totalMessageCount) {
          if (progressID == nil) {
              return;
          }

          NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
          [resultDic safeSetObject:handle forKey:@"handle"];
          [resultDic safeSetObject:@"messageImportingProgress" forKey:@"method"];
          [resultDic safeSetObject:progressID forKey:@"progressID"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:importedMessageCount]
                            forKey:@"importedMessageCount"];
          [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalMessageCount]
                            forKey:@"totalMessageCount"];
          self.events(resultDic);
        }
        callback:^(ZIMError *_Nonnull errorInfo) {
          if (errorInfo.code == 0) {
              result(nil);
          } else {
              result([FlutterError
                  errorWithCode:[NSString stringWithFormat:@"%d", (int)errorInfo.code]
                        message:errorInfo.message
                        details:nil]);
          }
        }];
}

- (void)clearLocalFileCache:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMFileCacheClearConfig *config =
        [ZIMPluginConverter oZIMFileCacheClearConfig:[call.arguments objectForKey:@"config"]];

    [zim
        clearLocalFileCacheWithConfig:config
                             callback:^(ZIMError *_Nonnull errorInfo) {
                               if (errorInfo.code == 0) {
                                   result(nil);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)queryLocalFileCache:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if (!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }

    ZIMFileCacheQueryConfig *config =
        [ZIMPluginConverter oZIMFileCacheQueryConfig:[call.arguments objectForKey:@"config"]];

    [zim
        queryLocalFileCacheWithConfig:config
                             callback:^(ZIMFileCacheInfo *fileCacheInfo, ZIMError *errorInfo) {
                               if (errorInfo.code == 0) {
                                   NSMutableDictionary *resultDic =
                                       [[NSMutableDictionary alloc] init];

                                   [resultDic safeSetObject:[ZIMPluginConverter
                                                                mZIMFileCacheInfo:fileCacheInfo]
                                                     forKey:@"fileCacheInfo"];
                                   result(resultDic);
                               } else {
                                   result([FlutterError
                                       errorWithCode:[NSString stringWithFormat:@"%d",
                                                                                (int)errorInfo.code]
                                             message:errorInfo.message
                                             details:nil]);
                               }
                             }];
}

- (void)writeLog:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *log = [call.arguments objectForKey:@"logString"];
    [self writeLog:log];
}

- (void)writeLog:(NSString *)log {
    Class ZIM = NSClassFromString(@"ZIM");
    if ([[NSClassFromString(@"ZIM") alloc] init] != nil) {
        SEL selector = NSSelectorFromString(@"writeCustomLog:moduleName:");
        IMP imp = [ZIM methodForSelector:selector];
        void (*func)(id, SEL, NSString *, NSString *) =
            (void (*)(id, SEL, NSString *, NSString *))imp;
        func(ZIM, selector, log, @"Auto Test");
    }
}
#pragma mark - Getter
- (NSMutableDictionary *)engineMap {
    if (!_engineMap) {
        _engineMap = [[NSMutableDictionary alloc] init];
    }
    return _engineMap;
}
@end
