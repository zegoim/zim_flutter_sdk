#import "ZIMPluginConverter.h"
#import <Flutter/Flutter.h>
@interface ZIMPluginConverter()


@end


@implementation ZIMPluginConverter

+(nullable ZIMAppConfig*)oZIMAppConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMAppConfig *config = [[ZIMAppConfig alloc] init];
    config.appID = [[configDic safeObjectForKey:@"appID"] unsignedIntValue];
    config.appSign = [configDic safeObjectForKey:@"appSign"];
    return config;
}

+(nullable ZIMUserInfoQueryConfig*)oZIMUserInfoQueryConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMUserInfoQueryConfig *config = [[ZIMUserInfoQueryConfig alloc] init];
    config.isQueryFromServer = [[configDic safeObjectForKey:@"isQueryFromServer"] boolValue];
    return config;
}

+(nullable NSDictionary *)mZIMErrorObject:(nullable ZIMError *)errorInfo{
    if(errorInfo == nil || errorInfo == NULL || [errorInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
    [errorInfoDic safeSetObject:[NSNumber numberWithInt:(int)errorInfo.code] forKey:@"code"];
    [errorInfoDic safeSetObject:errorInfo.message forKey:@"message"];
    return errorInfoDic;
}

+(nullable NSDictionary *)mZIMUserFullInfo:(nullable ZIMUserFullInfo *)userFullInfo{
    if(userFullInfo == nil || userFullInfo == NULL || [userFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *userFullInfoDic = [[NSMutableDictionary alloc] init];
    [userFullInfoDic safeSetObject:userFullInfo.userAvatarUrl forKey:@"userAvatarUrl"];
    [userFullInfoDic safeSetObject:userFullInfo.extendedData forKey:@"extendedData"];
    NSDictionary *baseInfodic = [ZIMPluginConverter mZIMUserInfo:userFullInfo.baseInfo];
    [userFullInfoDic safeSetObject:baseInfodic forKey:@"baseInfo"];
    return userFullInfoDic;
}

+(nullable NSDictionary *)mZIMUserInfo:(nullable ZIMUserInfo *)userInfo{
    if(userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic safeSetObject:userInfo.userID forKey:@"userID"];
    [userInfoDic safeSetObject:userInfo.userName forKey:@"userName"];
    return userInfoDic;
}

+(nullable NSArray *)mZIMUserInfoList:(nullable NSArray<ZIMUserInfo *> *)userInfoList{
    if(userInfoList == nil || userInfoList == NULL || [userInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicZIMUserInfoList = [[NSMutableArray alloc] init];
    for (ZIMUserInfo *userInfo in userInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMUserInfo:userInfo];
        [basicZIMUserInfoList safeAddObject:userInfoDic];
    }
    return basicZIMUserInfoList;
}

+(nullable ZIMConversation *)oZIMConversation:(nullable NSDictionary *)conversationDic{
    if(conversationDic == nil || conversationDic == NULL || [conversationDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMConversation *conversation = [[ZIMConversation alloc] init];
    conversation.conversationID = (NSString *)[conversationDic objectForKey:@"conversationID"];
    conversation.conversationName = (NSString *)[conversationDic objectForKey:@"conversationName"];
    conversation.conversationAvatarUrl = (NSString *)[conversationDic objectForKey:@"conversationAvatarUrl"];
    conversation.type = ((NSNumber *)[conversationDic objectForKey:@"type"]).intValue;
    conversation.notificationStatus = ((NSNumber *)[conversationDic objectForKey:@"notificationStatus"]).intValue;
    conversation.unreadMessageCount = ((NSNumber *)[conversationDic objectForKey:@"unreadMessageCount"]).intValue;
    conversation.orderKey = ((NSNumber *)[conversationDic objectForKey:@"orderKey"]).longLongValue;
    conversation.lastMessage = [ZIMPluginConverter oZIMMessage:(NSDictionary *)[conversationDic objectForKey:@"lastMessage"]];
    return conversation;
}

+(nullable NSDictionary *)mZIMConversation:(nullable ZIMConversation *)conversation{
    if(conversation == nil || conversation == NULL || [conversation isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *conversationDic = [[NSMutableDictionary alloc] init];
    [conversationDic safeSetObject:conversation.conversationID forKey:@"conversationID"];
    [conversationDic safeSetObject:conversation.conversationName forKey:@"conversationName"];
    [conversationDic safeSetObject:conversation.conversationAvatarUrl forKey:@"conversationAvatarUrl"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.type] forKey:@"type"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.notificationStatus] forKey:@"notificationStatus"];
    [conversationDic safeSetObject:[NSNumber numberWithUnsignedInt:conversation.unreadMessageCount] forKey:@"unreadMessageCount"];
    [conversationDic safeSetObject:[NSNumber numberWithLongLong:conversation.orderKey] forKey:@"orderKey"];
    [conversationDic safeSetObject:[ZIMPluginConverter mZIMMessage:conversation.lastMessage] forKey:@"lastMessage"];
    return conversationDic;
    
}

+(nullable NSArray *)mZIMConversationList:(nullable NSArray<ZIMConversation *> *)conversationList{
    if(conversationList == nil || conversationList == NULL || [conversationList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *conversationBasicList = [[NSMutableArray alloc] init];
    for (ZIMConversation *conversation in conversationList) {
        [conversationBasicList safeAddObject:[ZIMPluginConverter mZIMConversation:conversation]];
    }
    return conversationBasicList;
}

+(nullable NSArray *)mConversationChangeInfoList:(nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    if(conversationChangeInfoList == nil || conversationChangeInfoList == NULL || [conversationChangeInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicChangeInfoList = [[NSMutableArray alloc] init];
    for (ZIMConversationChangeInfo *changeInfo in conversationChangeInfoList) {
        NSDictionary *changeInfoDic = [ZIMPluginConverter mConversationChangeInfo:changeInfo];
        [basicChangeInfoList safeAddObject:changeInfoDic];
    }
    return basicChangeInfoList;
}

+(nullable NSDictionary *)mConversationChangeInfo:(nullable ZIMConversationChangeInfo *)changeInfo{
    if(changeInfo == nil || changeInfo == NULL || [changeInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *changeInfoDic = [[NSMutableDictionary alloc] init];
    [changeInfoDic safeSetObject:[NSNumber numberWithInt:(int)changeInfo.event] forKey:@"event"];
    NSDictionary *conversationDic = [ZIMPluginConverter mZIMConversation:changeInfo.conversation];
    [changeInfoDic safeSetObject:conversationDic forKey:@"conversation"];
    return changeInfoDic;
}

+(nullable ZIMMessage *)oZIMMessage:(nullable NSDictionary *)messageDic{
    if(messageDic == nil || messageDic == NULL || [messageDic isEqual:[NSNull null]]){
        return nil;
    }
    id msg;
    ZIMMessageType msgType = ((NSNumber *)[messageDic safeObjectForKey:@"type"]).intValue;
    switch (msgType) {
        case ZIMMessageTypeUnknown:{
            msg = [[ZIMMessage alloc] init];
            break;
        }
        case ZIMMessageTypeText:{
            msg = [[ZIMTextMessage alloc] init];
            ((ZIMTextMessage *)msg).message = (NSString *)[messageDic safeObjectForKey:@"message"];
            break;
        }
        case ZIMMessageTypeCommand:{
            msg = [[ZIMCommandMessage alloc] init];
            ((ZIMCommandMessage *)msg).message = ((FlutterStandardTypedData *)[messageDic safeObjectForKey:@"message"]).data;
            break;
        }
        case ZIMMessageTypeBarrage:{
            msg = [[ZIMBarrageMessage alloc] init];
            ((ZIMBarrageMessage *)msg).message = (NSString *)[messageDic safeObjectForKey:@"message"];
            break;
        }
        case ZIMMessageTypeFile:{
            msg = [[ZIMFileMessage alloc] init];
            break;
        }
        case ZIMMessageTypeAudio:{
            msg = [[ZIMAudioMessage alloc] init];
             
            ((ZIMAudioMessage *)msg).audioDuration = ((NSNumber *)[messageDic safeObjectForKey:@"audioDuration"]).unsignedIntValue;
            break;
        }
        case ZIMMessageTypeVideo:{
            msg = [[ZIMVideoMessage alloc] init];
            ((ZIMVideoMessage *)msg).videoDuration = ((NSNumber *)[messageDic safeObjectForKey:@"videoDuration"]).unsignedIntValue;
            [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic safeObjectForKey:@"videoFirstFrameDownloadUrl"] forKey:@"videoFirstFrameDownloadUrl"];
            [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic safeObjectForKey:@"videoFirstFrameLocalPath"] forKey:@"videoFirstFrameLocalPath"];
            [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic safeObjectForKey:@"videoFirstFrameHeight"] forKey:@"videoFirstFrameHeight"];
            [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic safeObjectForKey:@"videoFirstFrameWidth"] forKey:@"videoFirstFrameWidth"];
            break;
        }
        case ZIMMessageTypeImage:{
            msg = [[ZIMImageMessage alloc] init];
            ((ZIMImageMessage *)msg).thumbnailDownloadUrl = [messageDic safeObjectForKey:@"thumbnailDownloadUrl"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"thumbnailLocalPath"] forKey:@"thumbnailLocalPath"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageDownloadUrl"] forKey:@"largeImageDownloadUrl"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageLocalPath"] forKey:@"largeImageLocalPath"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"originalImageHeight"] forKey:@"originalImageHeight"];
                        [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"originalImageWidth"] forKey:@"originalImageWidth"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageHeight"] forKey:@"largeImageHeight"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageWidth"] forKey:@"largeImageWidth"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"thumbnailHeight"] forKey:@"thumbnailHeight"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"thumbnailWidth"] forKey:@"thumbnailWidth"];
            break;
        }
        default:
            break;
    }
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"type"]  forKey:@"type"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"messageID"]  forKey:@"messageID"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"localMessageID"]  forKey:@"localMessageID"];
    [msg safeSetValue:(NSString *)[messageDic objectForKey:@"senderUserID"]  forKey:@"senderUserID"];
    [msg safeSetValue:(NSString *)[messageDic objectForKey:@"conversationID"] forKey:@"conversationID"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"direction"]  forKey:@"direction"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"sentStatus"]  forKey:@"sentStatus"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"conversationType"]  forKey:@"conversationType"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"timestamp"]  forKey:@"timestamp"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"conversationSeq"]  forKey:@"conversationSeq"];
    [msg safeSetValue:(NSNumber *)[messageDic objectForKey:@"orderKey"]  forKey:@"orderKey"];
    
    if([msg isKindOfClass:[ZIMMediaMessage class]]){
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileLocalPath"]  forKey:@"fileLocalPath"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileDownloadUrl"] forKey:@"fileDownloadUrl"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileUID"] forKey:@"fileUID"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileName"] forKey:@"fileName"];
        [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"fileSize"] forKey:@"fileSize"];
    }
    
    return msg;
}

+(nullable NSDictionary *)mZIMMessage:(nullable ZIMMessage *)message{
    if(message == nil || message == NULL || [message isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
    
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.type] forKey:@"type"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.messageID] forKey:@"messageID"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.localMessageID] forKey:@"localMessageID"];

    [messageDic safeSetObject:message.senderUserID  forKey:@"senderUserID"];
    [messageDic safeSetObject:message.conversationID forKey:@"conversationID"];
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.direction] forKey:@"direction"];
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.sentStatus] forKey:@"sentStatus"];

    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.conversationType] forKey:@"conversationType"];

    [messageDic safeSetObject:[NSNumber numberWithUnsignedLongLong:message.timestamp] forKey:@"timestamp"];

    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.conversationSeq] forKey:@"conversationSeq"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.orderKey] forKey:@"orderKey"];
    
    if([message isKindOfClass:[ZIMMediaMessage class]]){
        ZIMMediaMessage *mediaMsg = (ZIMMediaMessage *)message;
        [messageDic safeSetObject:mediaMsg.fileLocalPath forKey:@"fileLocalPath"];
        [messageDic safeSetObject:mediaMsg.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [messageDic safeSetObject:mediaMsg.fileUID forKey:@"fileUID"];
        [messageDic safeSetObject:mediaMsg.fileName forKey:@"fileName"];
        [messageDic safeSetObject:[NSNumber numberWithLongLong:mediaMsg.fileSize] forKey:@"fileSize"];
        
    }
    
    switch (message.type) {
        case ZIMMessageTypeUnknown:{
            break;
        }
        case ZIMMessageTypeText:{
            ZIMTextMessage *txtMsg = (ZIMTextMessage *)message;
            [messageDic safeSetObject:txtMsg.message forKey:@"message"];
            break;
        }
        case ZIMMessageTypeCommand:{
            ZIMCommandMessage *cmdMsg = (ZIMCommandMessage *)message;
            [messageDic safeSetObject:[FlutterStandardTypedData typedDataWithBytes:cmdMsg.message] forKey:@"message"];
            break;
        }
        case ZIMMessageTypeBarrage:{
            ZIMBarrageMessage *brgMsg = (ZIMBarrageMessage *)message;
            [messageDic safeSetObject:brgMsg.message forKey:@"message"];
            break;
        }
        case ZIMMessageTypeFile:{
            break;
        }
        case ZIMMessageTypeImage:{
            ZIMImageMessage *imgMsg = (ZIMImageMessage *)message;
            [messageDic safeSetObject:imgMsg.thumbnailDownloadUrl forKey:@"thumbnailDownloadUrl"];
            [messageDic safeSetObject:imgMsg.thumbnailLocalPath forKey:@"thumbnailLocalPath"];
            [messageDic safeSetObject:imgMsg.largeImageDownloadUrl forKey:@"largeImageDownloadUrl"];
            [messageDic safeSetObject:imgMsg.largeImageLocalPath forKey:@"largeImageLocalPath"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.originalImageSize.height] forKey:@"originalImageHeight"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.originalImageSize.width] forKey:@"originalImageWidth"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.largeImageSize.height] forKey:@"largeImageHeight"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.largeImageSize.width] forKey:@"largeImageWidth"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.thumbnailSize.height] forKey:@"thumbnailHeight"];
            [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.thumbnailSize.width] forKey:@"thumbnailWidth"];
            break;
        }
        case ZIMMessageTypeVideo:{
            ZIMVideoMessage *videoMsg = (ZIMVideoMessage *)message;
            [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:videoMsg.videoDuration] forKey:@"videoDuration"];
            [messageDic safeSetObject:videoMsg.videoFirstFrameDownloadUrl forKey:@"videoFirstFrameDownloadUrl"];
            [messageDic safeSetObject:videoMsg.videoFirstFrameLocalPath forKey:@"videoFirstFrameLocalPath"];
            [messageDic safeSetObject:[NSNumber numberWithInt:videoMsg.videoFirstFrameSize.height] forKey:@"videoFirstFrameHeight"];
            [messageDic safeSetObject:[NSNumber numberWithInt:videoMsg.videoFirstFrameSize.width] forKey:@"videoFirstFrameWidth"];
            break;
        }
        case ZIMMessageTypeAudio:{
            ZIMAudioMessage *audioMsg = (ZIMAudioMessage *)message;
            [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:audioMsg.audioDuration] forKey:@"audioDuration"];
            break;
        }
        default:
            break;
    }
    return messageDic;
}

+(nullable NSArray *)mZIMMessageList:(nullable NSArray<ZIMMessage *>*)messageList{
    if(messageList == nil || messageList == NULL || [messageList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessage *msg in messageList) {
        [DicArr addObject:[ZIMPluginConverter mZIMMessage:msg]];
    }
    return DicArr;
}

+(nullable NSArray<ZIMMessage *>*)oZIMMessageList:(nullable NSArray *)basicList{
    if(basicList == nil || basicList == NULL || [basicList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray<ZIMMessage *> *messageList = [[NSMutableArray alloc] init];
    for (NSDictionary *msgDic in basicList) {
        [messageList addObject:[ZIMPluginConverter oZIMMessage:msgDic]];
    }
    return messageList;
}

+(nullable ZIMMessageDeleteConfig *)oZIMMessageDeleteConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageDeleteConfig * deleteConfig = [[ZIMMessageDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerMessage = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerMessage"]).boolValue;
    return deleteConfig;
}

+(nullable NSDictionary *)mZIMMessageDeleteConfig:(nullable ZIMMessageDeleteConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithBool:config.isAlsoDeleteServerMessage] forKey:@"isAlsoDeleteServerMessage"];
    return configDic;
    
}


+(nullable ZIMConversationDeleteConfig *)oZIMConversationDeleteConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMConversationDeleteConfig *deleteConfig = [[ZIMConversationDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerConversation = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerConversation"]).boolValue;
    return deleteConfig;
}

+(nullable ZIMMessageSendConfig *)oZIMMessageSendConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageSendConfig *sendConfig = [[ZIMMessageSendConfig alloc] init];
    sendConfig.priority = ((NSNumber *)[configDic objectForKey:@"priority"]).intValue;
    sendConfig.pushConfig = [ZIMPluginConverter oZIMPushConfig:[configDic objectForKey:@"pushConfig"]];
    return sendConfig;
}

+(nullable ZIMPushConfig *)oZIMPushConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title = (NSString *)[configDic objectForKey:@"title"];
    pushConfig.content = (NSString *)[configDic objectForKey:@"content"];
    pushConfig.extendedData = (NSString *)[configDic objectForKey:@"extendedData"];
    return pushConfig;
}

+(nullable ZIMMessageQueryConfig *)oZIMMessageQueryConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.nextMessage = [ZIMPluginConverter oZIMMessage:[configDic objectForKey:@"nextMessage"]];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).intValue;
    config.reverse = ((NSNumber *)[configDic objectForKey:@"reverse"]).boolValue;
    return config;
}

+(nullable ZIMRoomInfo *)oZIMRoomInfo:(nullable NSDictionary *)roomInfoDic{
    if(roomInfoDic == nil || roomInfoDic == NULL || [roomInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomInfo *roomInfo = [[ZIMRoomInfo alloc] init];
    roomInfo.roomID = [roomInfoDic objectForKey:@"roomID"];
    roomInfo.roomName = [roomInfoDic objectForKey:@"roomName"];
    return roomInfo;
}

+(nullable NSDictionary *)mZIMRoomInfo:(nullable ZIMRoomInfo *)roomInfo{
    if(roomInfo == nil || roomInfo == NULL || [roomInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomInfoDic = [[NSMutableDictionary alloc] init];
    [roomInfoDic safeSetObject:roomInfo.roomID forKey:@"roomID"];
    [roomInfoDic safeSetObject:roomInfo.roomName forKey:@"roomName"];
    return roomInfoDic;
}

+(nullable NSDictionary *)mZIMRoomFullInfo:(nullable ZIMRoomFullInfo *)roomFullInfo{
    if(roomFullInfo == nil || roomFullInfo == NULL || [roomFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *baseInfoDic = [ZIMPluginConverter mZIMRoomInfo:roomFullInfo.baseInfo];
    [roomFullInfoDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return roomFullInfoDic;
}

+(nullable ZIMRoomAdvancedConfig *)oZIMRoomAdvancedConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAdvancedConfig *config = [[ZIMRoomAdvancedConfig alloc] init];
    config.roomAttributes = [configDic safeObjectForKey:@"roomAttributes"];
    config.roomDestroyDelayTime = ((NSNumber *)[configDic objectForKey:@"roomDestroyDelayTime"]).unsignedIntValue;
    return config;
}

+(nullable ZIMRoomMemberQueryConfig *)oZIMRoomMemberQueryConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomMemberQueryConfig *config = [[ZIMRoomMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = (NSString *)[configDic objectForKey:@"nextFlag"];
    return config;
}

+(nullable ZIMRoomAttributesSetConfig *)oZIMRoomAttributesSetConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesSetConfig *config = [[ZIMRoomAttributesSetConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    return config;
}

+(nullable ZIMRoomAttributesDeleteConfig *)oZIMRoomAttributesDeleteConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesDeleteConfig *config = [[ZIMRoomAttributesDeleteConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    return config;
}

+(nullable ZIMRoomAttributesBatchOperationConfig *)oZIMRoomAttributesBatchOperationConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesBatchOperationConfig *config = [[ZIMRoomAttributesBatchOperationConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    
    return config;
}

+(nullable NSDictionary *)mZIMRoomAttributesUpdateInfo:(nullable ZIMRoomAttributesUpdateInfo *)updateInfo{
    if(updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *basicUpdateInfo = [[NSMutableDictionary alloc] init];
    [basicUpdateInfo safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [basicUpdateInfo safeSetObject:updateInfo.roomAttributes forKey:@"roomAttributes"];
    return basicUpdateInfo;
}

+(nullable NSArray *)mZIMRoomAttributesUpdateInfoList:(nullable NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList{
    if(updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicUpadteInfoList = [[NSMutableArray alloc] init];
    for (ZIMRoomAttributesUpdateInfo *updateInfo in updateInfoList) {
        NSDictionary *updateInfoDic = [ZIMPluginConverter mZIMRoomAttributesUpdateInfo:updateInfo];
        [basicUpadteInfoList safeAddObject:updateInfoDic];
    }
    return basicUpadteInfoList;
}

+(nullable ZIMGroupInfo *)oZIMGroupInfo:(nullable NSDictionary *)groupInfoDic{
    if(groupInfoDic == nil || groupInfoDic == NULL || [groupInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupID = [groupInfoDic objectForKey:@"groupID"];
    info.groupName = [groupInfoDic objectForKey:@"groupName"];
    info.groupAvatarUrl = [groupInfoDic objectForKey:@"groupAvatarUrl"];
    return info;
}

+(nullable NSDictionary *)mZIMGroupInfo:(nullable ZIMGroupInfo *)groupInfo{
    if(groupInfo == nil || groupInfo == NULL || [groupInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupInfoDic = [[NSMutableDictionary alloc] init];
    [groupInfoDic safeSetObject:groupInfo.groupID forKey:@"groupID"];
    [groupInfoDic safeSetObject:groupInfo.groupName forKey:@"groupName"];
    [groupInfoDic safeSetObject:groupInfo.groupAvatarUrl forKey:@"groupAvatarUrl"];
    return groupInfoDic;
}

+(nullable NSDictionary *)mZIMGroupMemberInfo:(nullable ZIMGroupMemberInfo *)memberInfo{
    if(memberInfo == nil || memberInfo == NULL || [memberInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *memberInfoDic = (NSMutableDictionary *)[ZIMPluginConverter mZIMUserInfo:memberInfo];
    [memberInfoDic safeSetObject:memberInfo.memberNickname forKey:@"memberNickname"];
    [memberInfoDic safeSetObject:[NSNumber numberWithInt:memberInfo.memberRole] forKey:@"memberRole"];
    [memberInfoDic safeSetObject:memberInfo.userID forKey:@"userID"];
    [memberInfoDic safeSetObject:memberInfo.userName forKey:@"userName"];
    [memberInfoDic safeSetObject:memberInfo.memberAvatarUrl forKey:@"memberAvatarUrl"];
    return memberInfoDic;
    
    
    
    
    
    
}

+(nullable NSArray *)mZIMGroupMemberInfoList:(nullable NSArray<ZIMGroupMemberInfo *> *)memberInfoList{
    if(memberInfoList == nil || memberInfoList == NULL || [memberInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupMemberInfo *info in memberInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMGroupMemberInfo:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)mZIMErrorUserInfo:(nullable ZIMErrorUserInfo *)errorUserInfo{
    if(errorUserInfo == nil || errorUserInfo == NULL || [errorUserInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
    [errorUserInfoDic safeSetObject:errorUserInfo.userID forKey:@"userID"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:errorUserInfo.reason] forKey:@"reason"];
    return errorUserInfoDic;
}

+(nullable NSArray *)mZIMErrorUserInfoList:(nullable NSArray<ZIMErrorUserInfo *> *)errorUserInfoList{
    if(errorUserInfoList == nil || errorUserInfoList == NULL || [errorUserInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMErrorUserInfo *errorUserInfo in errorUserInfoList) {
        NSDictionary *errorUserInfoDic = [ZIMPluginConverter mZIMErrorUserInfo:errorUserInfo];
        [basicList safeAddObject:errorUserInfoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)mZIMGroupFullInfo:(nullable ZIMGroupFullInfo *)groupFullInfo{
    if(groupFullInfo == nil || groupFullInfo == NULL || [groupFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupInfo:groupFullInfo.baseInfo];
    [groupFullInfoDic safeSetObject:groupInfoDic forKey:@"baseInfo"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupNotice forKey:@"groupNotice"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupAttributes forKey:@"groupAttributes"];
    [groupFullInfoDic safeSetObject:[NSNumber numberWithInt:(int)groupFullInfo.notificationStatus] forKey:@"notificationStatus"];
    return groupFullInfoDic;
}

+(nullable NSDictionary *)mZIMGroupAdvancedConfig:(nullable ZIMGroupAdvancedConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:config.groupNotice forKey:@"groupNotice"];
    [configDic safeSetObject:config.groupAttributes forKey:@"groupAttributes"];
    return configDic;
}

+(nullable ZIMGroupAdvancedConfig *)oZIMGroupAdvancedConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupAdvancedConfig *config = [[ZIMGroupAdvancedConfig alloc] init];
    config.groupAttributes = [configDic safeObjectForKey:@"groupAttributes"];
    config.groupNotice = [configDic safeObjectForKey:@"groupNotice"];
    return config;
}

+(nullable NSDictionary*)mZIMGroup:(nullable ZIMGroup *)group{
    if(group == nil || group == NULL || [group isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupDic = [[NSMutableDictionary alloc] init];
    [groupDic safeSetObject:[NSNumber numberWithInt:(int)group.notificationStatus] forKey:@"notificationStatus"];
    NSDictionary *baseInfoDic = [ZIMPluginConverter mZIMGroupInfo:group.baseInfo];
    [groupDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return groupDic;
}

+(nullable NSArray*)mZIMGroupList:(nullable NSArray<ZIMGroup *> *)groupList{
    if(groupList == nil || groupList == NULL || [groupList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicGroupList = [[NSMutableArray alloc] init];
    for (ZIMGroup *group in groupList) {
        NSDictionary *groupDic = [ZIMPluginConverter mZIMGroup:group];
        [basicGroupList safeAddObject:groupDic];
    }
    return basicGroupList;
}

+(nullable NSDictionary *)mZIMGroupMemberQueryConfig:(nullable ZIMGroupMemberQueryConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.count] forKey:@"count"];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.nextFlag] forKey:@"nextFlag"];
    return configDic;
}

+(nullable ZIMGroupMemberQueryConfig *)oZIMGroupMemberQueryConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupMemberQueryConfig *config = [[ZIMGroupMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic safeObjectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = ((NSNumber *)[configDic safeObjectForKey:@"nextFlag"]).unsignedIntValue;
    return config;
}

//+(nullable NSDictionary *)cnv

+(nullable NSDictionary *)mZIMGroupOperatedInfo:(nullable ZIMGroupOperatedInfo *)operatedInfo{
    if(operatedInfo == nil || operatedInfo == NULL || [operatedInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *operatedInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *operatedUserInfoDic = [ZIMPluginConverter mZIMGroupMemberInfo:operatedInfo.operatedUserInfo];
    [operatedInfoDic safeSetObject:operatedUserInfoDic forKey:@"operatedUserInfo"];
    return operatedInfoDic;
}

+(nullable NSDictionary *)mZIMGroupAttributesUpdateInfo:(nullable ZIMGroupAttributesUpdateInfo *)updateInfo{
    if(updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *updateInfoDic = [[NSMutableDictionary alloc] init];
    [updateInfoDic safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [updateInfoDic safeSetObject:updateInfo.groupAttributes forKey:@"groupAttributes"];
    return updateInfoDic;
}

+(nullable NSArray *)mZIMGroupAttributesUpdateInfoList:(nullable NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfoList{
    if(updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupAttributesUpdateInfo *info in updateInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMGroupAttributesUpdateInfo:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)mZIMCallUserInfo:(ZIMCallUserInfo *)callUserInfo{
    if(callUserInfo == nil || callUserInfo == NULL || [callUserInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *callUserInfoDic = [[NSMutableDictionary alloc] init];
    [callUserInfoDic safeSetObject:callUserInfo.userID forKey:@"userID"];
    [callUserInfoDic safeSetObject:[NSNumber numberWithInt:(int)callUserInfo.state] forKey:@"state"];
    return callUserInfoDic;
}

+(nullable NSArray *)mZIMCallUserInfoList:(NSArray<ZIMCallUserInfo *> *)callUserInfoList{
    if(callUserInfoList == nil || callUserInfoList == NULL || [callUserInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMCallUserInfo *userInfo in callUserInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMCallUserInfo:userInfo];
        [basicList safeAddObject:userInfoDic];
    }
    return basicList;
}

+(nullable ZIMCallInviteConfig *)oZIMCallInviteConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallInviteConfig *config = [[ZIMCallInviteConfig alloc] init];
    config.timeout = ((NSNumber *)[configDic safeObjectForKey:@"timeout"]).unsignedIntValue;
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable NSDictionary *)mZIMCallInvitationSentInfo:(nullable ZIMCallInvitationSentInfo *)info{
    if(info == nil || info == NULL || [info isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:info.errorInvitees] forKey:@"errorInvitees"];
    return infoDic;
}

+(nullable ZIMCallCancelConfig *)oZIMCallCancelConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallCancelConfig *config = [[ZIMCallCancelConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable ZIMCallAcceptConfig *)oZIMCallAcceptConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallAcceptConfig *config = [[ZIMCallAcceptConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable ZIMCallRejectConfig *)oZIMCallRejectConfig:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallRejectConfig *config = [[ZIMCallRejectConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

@end
