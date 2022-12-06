//
//  ZIMMethodHandler.m
//  zego_zim
//
//  Created by lizhanpeng on 2022/7/25.
//

#import "ZIMMethodHandler.h"
#import "ZIMPluginConverter.h"
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
#import "ZIMEventHandler.h"

@interface ZIMMethodHandler()

@property (nonatomic, strong) FlutterEventSink events;

@property(nonatomic, strong)NSMutableDictionary<NSString *,ZIM *> *engineMap;

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
    if(oldZIM){
        [oldZIM destroy];
    }
    NSString *handle = [call.arguments objectForKey:@"handle"];
    
    NSDictionary *appConfigDic = [call.arguments objectForKey:@"config"];
    ZIMAppConfig *appConfig = [ZIMPluginConverter oZIMAppConfig:appConfigDic];
    ZIM *zim = [ZIM createWithAppConfig:appConfig];
    if(zim){
        [self.engineMap safeSetObject:zim forKey:handle];
        [[ZIMEventHandler sharedInstance].engineEventMap setObject:handle forKey:zim];
        [zim setEventHandler:[ZIMEventHandler sharedInstance]];
    }
    result(nil);
}

- (void)destroy:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(zim) {
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

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMUserInfo *userInfo = [[ZIMUserInfo alloc] init];
    userInfo.userID = [call.arguments objectForKey:@"userID"];
    userInfo.userName = [call.arguments objectForKey:@"userName"];
    NSString *token = [call.arguments objectForKey:@"token"];
    if(!token || [token isEqual:[NSNull null]]) {
        token = @"";
    }
    [zim loginWithUserInfo:userInfo token:token callback:^(ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            result(nil);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    [zim logout];
    result(nil);
}

- (void)uploadLog:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    [zim uploadLog:^(ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            result(nil);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)renewToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)updateUserName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *userName = [call.arguments objectForKey:@"userName"];
    [zim updateUserName:userName callback:^(NSString * _Nonnull userName, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *resultDic = @{@"userName":userName};
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

-(void)updateUserAvatarUrl:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *updateUserAvatarUrl = [call.arguments objectForKey:@"userAvatarUrl"];
    [zim updateUserAvatarUrl:updateUserAvatarUrl callback:^(NSString * _Nonnull userAvatarUrl, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *resultDic = @{@"userAvatarUrl":userAvatarUrl};
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)updateUserExtendedData:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *updateUserExtendedData = [call.arguments objectForKey:@"extendedData"];
    [zim updateUserExtendedData:updateUserExtendedData callback:^(NSString * _Nonnull extendedData, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *resultDic = @{@"extendedData":extendedData};
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryUsersInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    ZIMUsersInfoQueryConfig *config = [ZIMPluginConverter oZIMUserInfoQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryUsersInfo:userIDs config:config callback:^(NSArray<ZIMUserFullInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableArray *userListBasic = [[NSMutableArray alloc] init];
            for (ZIMUserFullInfo *userFullInfo in userList) {
                NSDictionary *userFullInfoDic = [ZIMPluginConverter mZIMUserFullInfo:userFullInfo];
                [userListBasic addObject:userFullInfoDic];
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


- (void)queryConversationList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSDictionary *configDic = [call.arguments objectForKey:@"config"];
    ZIMConversationQueryConfig *config = [[ZIMConversationQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextConversation = [ZIMPluginConverter oZIMConversation:(NSDictionary *)[configDic objectForKey:@"nextConversation"]];
    [zim queryConversationListWithConfig:config callback:^(NSArray<ZIMConversation *> * _Nonnull conversationList, ZIMError * _Nonnull errorInfo)  {
        if(errorInfo.code == 0){
            NSArray *conversationBasicList = [ZIMPluginConverter mZIMConversationList:conversationList];
            NSDictionary *resultDic = @{@"conversationList":conversationBasicList};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)deleteConversation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *conversationID = [call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMConversationDeleteConfig *deleteConfig = [ZIMPluginConverter oZIMConversationDeleteConfig:[call.arguments objectForKey:@"config"]];
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

- (void)clearConversationUnreadMessageCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)setConversationNotificationStatus:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

-(void)insertMessageToLocalDB:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *conversationID = (NSString *)[call.arguments safeObjectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    NSString *senderUserID = (NSString *)[call.arguments safeObjectForKey:@"senderUserID"];
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    [zim insertMessageToLocalDB:message conversationID:conversationID conversationType:conversationType senderUserID:senderUserID callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        NSDictionary *messageModel = [ZIMPluginConverter mZIMMessage:message];
        NSDictionary *resultDic = @{@"message":messageModel,@"messageID":messageID};
        if(errorInfo.code == 0){
            
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:resultDic]);
        }
    }];
}

-(void)sendMessage:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    NSNumber *messageAttachedCallbackID = [call.arguments safeObjectForKey:@"messageAttachedCallbackID"];
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toConversationID = (NSString *)[call.arguments safeObjectForKey:@"toConversationID"];
    int conversationType = ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments safeObjectForKey:@"config"]];
    ZIMMessageSendNotification *sendNotification = [[ZIMMessageSendNotification alloc] init];
    sendNotification.onMessageAttached = ^(ZIMMessage * _Nonnull message) {
        if(messageAttachedCallbackID == nil){
            return;
        }
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic safeSetObject:@"onMessageAttached" forKey:@"method"];
        [resultDic safeSetObject:messageID forKey:@"messageID"];
        [resultDic safeSetObject:messageAttachedCallbackID forKey:@"messageAttachedCallbackID"];
        [resultDic safeSetObject:messageDic forKey:@"message"];
        self.events(resultDic);
    };
    [zim sendMessage:message toConversationID:toConversationID conversationType:conversationType config:sendConfig notification:sendNotification callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
        NSDictionary *resultDic = @{@"message":messageDic,@"messageID":messageID};
        if(errorInfo.code == 0){
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:resultDic]);
        }
    }];
}

- (void)sendPeerMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toUserID = (NSString *)[call.arguments objectForKey:@"toUserID"];
    ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendPeerMessage:message toUserID:toUserID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
            NSDictionary *resultDic = @{@"message":messageDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)sendRoomMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments objectForKey:@"message"]];
    NSString *toRoomID = (NSString *)[call.arguments objectForKey:@"toRoomID"];
    ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendRoomMessage:message toRoomID:toRoomID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
            NSDictionary *resultDic = @{@"message":messageDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)sendGroupMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *toGroupID = (NSString *)[call.arguments objectForKey:@"toGroupID"];
    ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments objectForKey:@"config"]];
    [zim sendGroupMesage:message toGroupID:toGroupID config:sendConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
            NSDictionary *resultDic = @{@"message":messageDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)sendMediaMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *toConversationID = [call.arguments safeObjectForKey:@"toConversationID"];
    int conversationType = ((NSNumber *)[call.arguments safeObjectForKey:@"conversationType"]).intValue;
    ZIMMessageSendConfig *sendConfig = [ZIMPluginConverter oZIMMessageSendConfig:[call.arguments safeObjectForKey:@"config"]];
    NSNumber *messageID = [call.arguments safeObjectForKey:@"messageID"];
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];
    NSNumber *messageAttachedCallbackID = [call.arguments safeObjectForKey:@"messageAttachedCallbackID"];
    ZIMMediaMessageSendNotification *sendNotification = [[ZIMMediaMessageSendNotification alloc] init];
    sendNotification.onMediaUploadingProgress = ^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        if(progressID == nil){
            return;
        }
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
        
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic safeSetObject:@"uploadMediaProgress" forKey:@"method"];
        [resultDic safeSetObject:progressID forKey:@"progressID"];
        [resultDic safeSetObject:messageID forKey:@"messageID"];
        [resultDic safeSetObject:messageDic forKey:@"message"];
        [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:currentFileSize] forKey:@"currentFileSize"];
        [resultDic safeSetObject:[NSNumber numberWithUnsignedLongLong:totalFileSize] forKey:@"totalFileSize"];
        self.events(resultDic);
    };
    sendNotification.onMessageAttached = ^(ZIMMessage * _Nonnull message) {
        if(messageAttachedCallbackID == nil){
            return;
        }
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];

        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic safeSetObject:@"onMessageAttached" forKey:@"method"];
        [resultDic safeSetObject:messageID forKey:@"messageID"];
        [resultDic safeSetObject:messageAttachedCallbackID forKey:@"messageAttachedCallbackID"];
        [resultDic safeSetObject:messageDic forKey:@"message"];
        self.events(resultDic);
    };
    [zim sendMediaMessage:message toConversationID:toConversationID conversationType:conversationType config:sendConfig notification:sendNotification callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
        [resultMtDic safeSetObject:messageID forKey:@"messageID"];
        [resultMtDic safeSetObject:messageDic forKey:@"message"];
        if(errorInfo.code == 0){
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:resultMtDic]);
        }
    }];
}

- (void)sendConversationMessageReceiptRead:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments safeObjectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType = [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim sendConversationMessageReceiptRead:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:conversationID forKey:@"conversationID"];
            [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInteger:conversationType] forKey:@"conversationType"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)sendMessageReceiptsRead:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments safeObjectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<ZIMMessage *> *messageList = [ZIMPluginConverter oZIMMessageList:[call.arguments safeObjectForKey:@"messageList"]];
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType = [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim sendMessageReceiptsRead:messageList conversationID:conversationID conversationType:conversationType callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<NSNumber *> * _Nonnull errorMessageIDs, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:conversationID forKey:@"conversationID"];
            [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInteger:conversationType] forKey:@"conversationType"];
            [resultMtDic safeSetObject:errorMessageIDs forKey:@"errorMessageIDs"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryMessageReceiptsInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSArray<ZIMMessage *> *messageList = [ZIMPluginConverter oZIMMessageList:[call.arguments safeObjectForKey:@"messageList"]];
    NSString *conversationID = [call.arguments safeObjectForKey:@"conversationID"];
    ZIMConversationType conversationType = [[call.arguments safeObjectForKey:@"conversationType"] unsignedIntegerValue];
    [zim queryMessageReceiptsInfoByMessageList:messageList conversationID:conversationID conversationType:conversationType callback:^(NSArray<ZIMMessageReceiptInfo *> * _Nonnull infos, NSArray<NSString *> * _Nonnull errorMessageIDs, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *infosModel = [[NSMutableArray alloc] init];
            for (ZIMMessageReceiptInfo *info in infos) {
                [infosModel safeAddObject:[ZIMPluginConverter mZIMMessageReceiptInfo:info]];
            }
            [resultMtDic safeSetObject:infosModel forKey:@"infos"];
            [resultMtDic safeSetObject:errorMessageIDs forKey:@"errorMessageIDs"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryGroupMessageReceiptReadMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMessageReceiptMemberQueryConfig *queryConfig = [ZIMPluginConverter oZIMGroupMessageReceiptMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryGroupMessageReceiptReadMemberListByMessage:message groupID:groupID config:queryConfig callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:[ZIMPluginConverter mZIMGroupMemberInfoList:userList] forKey:@"userList"];
            [resultMtDic safeSetObject:groupID forKey:@"groupID"];
            [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag] forKey:@"nextFlag"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryGroupMessageReceiptUnreadMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMessageReceiptMemberQueryConfig *queryConfig = [ZIMPluginConverter oZIMGroupMessageReceiptMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryGroupMessageReceiptUnreadMemberListByMessage:message groupID:groupID config:queryConfig callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:[ZIMPluginConverter mZIMGroupMemberInfoList:userList] forKey:@"userList"];
            [resultMtDic safeSetObject:groupID forKey:@"groupID"];
            [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInt:nextFlag] forKey:@"nextFlag"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)revokeMessage:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    ZIMMessage *message = [ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    ZIMMessageRevokeConfig *revokeConfig = [ZIMPluginConverter oZIMMessageRevokeConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim revokeMessage:message config:revokeConfig callback:^(ZIMMessage * _Nonnull message, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:[ZIMPluginConverter mZIMMessage:message] forKey:@"message"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)downloadMediaFile:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMMediaMessage *message = (ZIMMediaMessage *)[ZIMPluginConverter oZIMMessage:[call.arguments safeObjectForKey:@"message"]];
    int fileType = ((NSNumber *)[call.arguments safeObjectForKey:@"fileType"]).intValue;
    NSNumber *progressID = [call.arguments safeObjectForKey:@"progressID"];

    [zim downloadMediaFileWithMessage:message  fileType:fileType progress:^(ZIMMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        if(progressID == nil){
            return;
        }
        NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
        
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
            NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:message];
            [resultMtDic safeSetObject:messageDic forKey:@"message"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryHistoryMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageQueryConfig *queryConfig = [ZIMPluginConverter oZIMMessageQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryHistoryMessageByConversationID:conversationID conversationType:conversationType config:queryConfig callback:^(NSString * _Nonnull conversationID, ZIMConversationType conversationType, NSArray<ZIMMessage *> * _Nonnull messageList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *MsgDicList = [ZIMPluginConverter mZIMMessageList:messageList];
            
            NSDictionary *resultDic = @{@"conversationID":conversationID,@"conversationType":[NSNumber numberWithInt:(int)conversationType],@"messageList":MsgDicList};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)deleteAllMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageDeleteConfig *deleteConfig = [ZIMPluginConverter oZIMMessageDeleteConfig:[call.arguments objectForKey:@"config"]];
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

- (void)deleteMessages:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray *messageList = [ZIMPluginConverter oZIMMessageList:[call.arguments objectForKey:@"messageList"]];
    NSString *conversationID = (NSString *)[call.arguments objectForKey:@"conversationID"];
    int conversationType = ((NSNumber *)[call.arguments objectForKey:@"conversationType"]).intValue;
    ZIMMessageDeleteConfig *deleteConfig = [ZIMPluginConverter oZIMMessageDeleteConfig:[call.arguments objectForKey:@"config"]];
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

- (void)enterRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMRoomInfo *roomInfo = [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];
    ZIMRoomAdvancedConfig *config = [ZIMPluginConverter oZIMRoomAdvancedConfig:[call.arguments objectForKey:@"config"]];
    [zim enterRoom:roomInfo config:config callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
            NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)createRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMRoomInfo *roomInfo = [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];
    
    [zim createRoom:roomInfo callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
            NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)createRoomWithConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMRoomInfo *roomInfo = [ZIMPluginConverter oZIMRoomInfo:[call.arguments objectForKey:@"roomInfo"]];
    ZIMRoomAdvancedConfig *config = [ZIMPluginConverter oZIMRoomAdvancedConfig:[call.arguments objectForKey:@"config"]];
    
    [zim createRoom:roomInfo config:config callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
            NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)joinRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    [zim joinRoom:roomID callback:^(ZIMRoomFullInfo * _Nonnull roomInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *roomInfoDic = [ZIMPluginConverter mZIMRoomFullInfo:roomInfo];
            NSDictionary *resultDic = @{@"roomInfo":roomInfoDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)leaveRoom:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryRoomMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    
    ZIMRoomMemberQueryConfig *config = [ZIMPluginConverter oZIMRoomMemberQueryConfig:[call.arguments objectForKey:@"config"]];
    [zim queryRoomMemberListByRoomID:roomID config:config callback:^(NSString * _Nonnull roomID, NSArray<ZIMUserInfo *> * _Nonnull memberList, NSString * _Nonnull nextFlag, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *basicMemberList = [ZIMPluginConverter mZIMUserInfoList:memberList];
            NSDictionary *resultDic = @{@"roomID":roomID,@"memberList":basicMemberList,@"nextFlag":nextFlag};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryRoomOnlineMemberCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)setRoomAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    NSDictionary<NSString *,NSString *> *roomAttributes = [call.arguments objectForKey:@"roomAttributes"];
    ZIMRoomAttributesSetConfig *setConfig = [ZIMPluginConverter oZIMRoomAttributesSetConfig:[call.arguments objectForKey:@"config"]];
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

- (void)deleteRoomAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    NSArray<NSString *> *keys = [call.arguments objectForKey:@"keys"];
    ZIMRoomAttributesDeleteConfig *config = [ZIMPluginConverter oZIMRoomAttributesDeleteConfig:[call.arguments objectForKey:@"config"]];
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

- (void)beginRoomAttributesBatchOperation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *roomID = [call.arguments objectForKey:@"roomID"];
    ZIMRoomAttributesBatchOperationConfig *config = [ZIMPluginConverter oZIMRoomAttributesBatchOperationConfig:[call.arguments objectForKey:@"config"]];
    
    [zim beginRoomAttributesBatchOperationWithRoomID:roomID config:config];
    result(nil);
}

- (void)endRoomAttributesBatchOperation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryRoomAllAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)setRoomMembersAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    NSDictionary *attributes = [call.arguments safeObjectForKey:@"attributes"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    ZIMRoomMemberAttributesSetConfig *setConfig = [ZIMPluginConverter oZIMRoomMemberAttributesSetConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim setRoomMembersAttributes:attributes userIDs:userIDs roomID:roomID config:setConfig callback:^(NSString * _Nonnull roomID, NSArray<ZIMRoomMemberAttributesOperatedInfo *> * _Nonnull infos, NSArray<NSString *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *infosArr = [[NSMutableArray alloc] init];
            for (ZIMRoomMemberAttributesOperatedInfo *info in infos) {
                [infosArr safeAddObject:[ZIMPluginConverter mZIMRoomMemberAttributesOperatedInfo:info]];
            }
            [resultDic safeSetObject:infosArr forKey:@"infos"];
            [resultDic safeSetObject:errorUserList forKey:@"errorUserList"];
            [resultDic safeSetObject:roomID forKey:@"roomID"];
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryRoomMembersAttributes:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    NSArray *userIDs = [call.arguments safeObjectForKey:@"userIDs"];
    [zim queryRoomMembersAttributesByUserIDs:userIDs roomID:roomID callback:^(NSString * _Nonnull roomID, NSArray<ZIMRoomMemberAttributesInfo *> * _Nonnull infos, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *infosModel = [[NSMutableArray alloc] init];
            for (ZIMRoomMemberAttributesInfo *info in infos) {
                [infosModel safeAddObject:[ZIMPluginConverter mZIMRoomMemberAttributesInfo:info]];
            }
            [resultDic safeSetObject:roomID forKey:@"roomID"];
            [resultDic safeSetObject:infosModel forKey:@"infos"];
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryRoomMemberAttributesList:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    NSString *roomID = [call.arguments safeObjectForKey:@"roomID"];
    ZIMRoomMemberAttributesQueryConfig *queryConfig = [ZIMPluginConverter oZIMRoomMemberAttributesQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryRoomMemberAttributesListByRoomID:roomID config:queryConfig callback:^(NSString * _Nonnull roomID, NSArray<ZIMRoomMemberAttributesInfo *> * _Nonnull infos, NSString * _Nonnull nextFlag, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *infosModel = [[NSMutableArray alloc] init];
            for (ZIMRoomMemberAttributesInfo *info in infos) {
                [infosModel safeAddObject:[ZIMPluginConverter mZIMRoomMemberAttributesInfo:info]];
            }
            [resultDic safeSetObject:roomID forKey:@"roomID"];
            [resultDic safeSetObject:nextFlag forKey:@"nextFlag"];
            [resultDic safeSetObject:infosModel forKey:@"infos"];
            result(resultDic);
        }else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)createGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMGroupInfo *groupInfo = [ZIMPluginConverter oZIMGroupInfo:[call.arguments objectForKey:@"groupInfo"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    [zim createGroup:groupInfo userIDs:userIDs callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
            NSArray *basicErrorUserList = [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
            NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
            NSDictionary *resultDic = @{@"groupInfo":groupInfoDic,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)createGroupWithConfig:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMGroupInfo *groupInfo = [ZIMPluginConverter oZIMGroupInfo:[call.arguments objectForKey:@"groupInfo"]];
    NSArray<NSString *> *userIDs = [call.arguments objectForKey:@"userIDs"];
    
    ZIMGroupAdvancedConfig *config = [ZIMPluginConverter oZIMGroupAdvancedConfig:[call.arguments objectForKey:@"config"]];
    [zim createGroup:groupInfo userIDs:userIDs config:config callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
            NSArray *basicErrorUserList = [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
            NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
            NSDictionary *resultDic = @{@"groupInfo":groupInfoDic,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)joinGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim joinGroup:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
            NSDictionary *resultDic = @{@"groupInfo":groupInfoDic};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)dismissGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)leaveGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)inviteUsersIntoGroup:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim inviteUsersIntoGroup:userIDs groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
            NSArray *basicErrorUserList = [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];

            NSDictionary *resultDic = @{@"groupID":groupID,@"userList":basicUserList,@"errorUserList":basicErrorUserList};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)kickGroupMembers:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray *userIDs = [call.arguments objectForKey:@"userIDs"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim kickGroupMembers:userIDs groupID:groupID callback:^(NSString * _Nonnull groupID, NSArray<NSString *> * _Nonnull kickedUserIDList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            
            
            NSArray *basicErrorUserList = [ZIMPluginConverter mZIMErrorUserInfoList:errorUserList];
            NSDictionary *resultDic = @{@"groupID":groupID,@"kickedUserIDList":kickedUserIDList,@"errorUserList":basicErrorUserList};
            result(resultDic);
            
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)transferGroupOwner:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *userID = [call.arguments objectForKey:@"toUserID"];
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

- (void)updateGroupName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)updateGroupAvatarUrl:(FlutterMethodCall *)call
                      result:(FlutterResult)result{
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *groupAvatarUrl = [call.arguments objectForKey:@"groupAvatarUrl"];
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim updateGroupAvatarUrl:groupAvatarUrl groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull groupAvatarUrl, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *resultDic = @{@"groupID":groupID,@"groupAvatarUrl":groupAvatarUrl};
            result(resultDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)updateGroupNotice:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryGroupInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *groupID = [call.arguments objectForKey:@"groupID"];
    [zim queryGroupInfoByGroupID:groupID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)setGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)deleteGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryGroupAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryGroupAllAttributes:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)setGroupMemberRole:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    ZIMGroupMemberRole role = ((NSNumber *)[call.arguments safeObjectForKey:@"role"]).intValue;
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];

    NSString *forUserID = [call.arguments safeObjectForKey:@"forUserID"];
    [zim setGroupMemberRole:role forUserID:forUserID groupID:groupID callback:^(NSString * _Nonnull groupID, NSString * _Nonnull forUserID, ZIMGroupMemberRole role, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:groupID forKey:@"groupID"];
            [resultMtDic safeSetObject:forUserID forKey:@"forUserID"];
            [resultMtDic safeSetObject:[NSNumber numberWithInt:role] forKey:@"role"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)setGroupMemberNickname:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
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

- (void)queryGroupMemberInfo:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *userID = [call.arguments safeObjectForKey:@"userID"];
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    [zim queryGroupMemberInfoByUserID:userID groupID:groupID callback:^(NSString * _Nonnull groupID, ZIMGroupMemberInfo * _Nonnull userInfo, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSDictionary *userInfoDic = [ZIMPluginConverter mZIMGroupMemberInfo:userInfo];
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

- (void)queryGroupList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    [zim queryGroupList:^(NSArray<ZIMGroup *> * _Nonnull groupList, ZIMError * _Nonnull errorInfo) {
        if (errorInfo.code == 0) {
            NSArray *basicGroupList = [ZIMPluginConverter mZIMGroupList:groupList];
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:basicGroupList forKey:@"groupList"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)queryGroupMemberList:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    ZIMGroupMemberQueryConfig *config = [ZIMPluginConverter oZIMGroupMemberQueryConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim queryGroupMemberListByGroupID:groupID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSArray *basicUserList = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
            
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

- (void)queryGroupMemberCount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *groupID = [call.arguments safeObjectForKey:@"groupID"];
    [zim queryGroupMemberCountByGroupID:groupID callback:^(NSString * _Nonnull groupID, unsigned int count, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:groupID forKey:@"groupID"];
            [resultMtDic safeSetObject:[NSNumber numberWithUnsignedInt:count] forKey:@"count"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)callInvite:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
    ZIMCallInviteConfig *config = [ZIMPluginConverter oZIMCallInviteConfig:[call.arguments safeObjectForKey:@"config"]];
    [zim callInviteWithInvitees:invitees config:config callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == 0){
            NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] init];
            [resultMtDic safeSetObject:callID forKey:@"callID"];
            NSDictionary *infoDic = [ZIMPluginConverter mZIMCallInvitationSentInfo:info];
            [resultMtDic safeSetObject:infoDic forKey:@"info"];
            result(resultMtDic);
        }
        else{
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%d",(int)errorInfo.code] message:errorInfo.message details:nil]);
        }
    }];
}

- (void)callCancel:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSArray *invitees = [call.arguments safeObjectForKey:@"invitees"];
    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallCancelConfig *config = [ZIMPluginConverter oZIMCallCancelConfig:[call.arguments safeObjectForKey:@"config"]];
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

- (void)callAccept:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallAcceptConfig *config = [ZIMPluginConverter oZIMCallAcceptConfig:[call.arguments safeObjectForKey:@"config"]];
    
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

- (void)callReject:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *handle = [call.arguments objectForKey:@"handle"];
    ZIM *zim = self.engineMap[handle];
    if(!zim) {
        result([FlutterError errorWithCode:@"-1" message:@"no native instance" details:nil]);
        return;
    }
    
    NSString *callID = [call.arguments safeObjectForKey:@"callID"];
    ZIMCallRejectConfig *config = [ZIMPluginConverter oZIMCallRejectConfig:[call.arguments safeObjectForKey:@"config"]];
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

#pragma mark - Getter
- (NSMutableDictionary *)engineMap {
    if (!_engineMap) {
        _engineMap = [[NSMutableDictionary alloc] init];
    }
    return _engineMap;
}
@end

