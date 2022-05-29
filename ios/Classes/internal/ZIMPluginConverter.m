#import "ZIMPluginConverter.h"
#import <Flutter/Flutter.h>
@interface ZIMPluginConverter()


@end


@implementation ZIMPluginConverter

+(nullable NSDictionary *)cnvZIMErrorObjectToDic:(nullable ZIMError *)errorInfo{
    if(errorInfo == nil || errorInfo == NULL || [errorInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
    [errorInfoDic safeSetObject:[NSNumber numberWithInt:(int)errorInfo.code] forKey:@"code"];
    [errorInfoDic safeSetObject:errorInfo.message forKey:@"message"];
    return errorInfoDic;
}

+(nullable NSDictionary *)cnvZIMUserInfoObjectToBasic:(nullable ZIMUserInfo *)userInfo{
    if(userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic safeSetObject:userInfo.userID forKey:@"userID"];
    [userInfoDic safeSetObject:userInfo.userName forKey:@"userName"];
    return userInfoDic;
}

+(nullable NSArray *)cnvZIMUserInfoListTobasicList:(nullable NSArray<ZIMUserInfo *> *)userInfoList{
    if(userInfoList == nil || userInfoList == NULL || [userInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicZIMUserInfoList = [[NSMutableArray alloc] init];
    for (ZIMUserInfo *userInfo in userInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter cnvZIMUserInfoObjectToBasic:userInfo];
        [basicZIMUserInfoList safeAddObject:userInfoDic];
    }
    return basicZIMUserInfoList;
}

+(nullable ZIMConversation *)cnvZIMConversationDicToObject:(nullable NSDictionary *)conversationDic{
    if(conversationDic == nil || conversationDic == NULL || [conversationDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMConversation *conversation = [[ZIMConversation alloc] init];
    conversation.conversationID = (NSString *)[conversationDic objectForKey:@"conversationID"];
    conversation.conversationName = (NSString *)[conversationDic objectForKey:@"conversationName"];
    conversation.type = ((NSNumber *)[conversationDic objectForKey:@"type"]).intValue;
    conversation.notificationStatus = ((NSNumber *)[conversationDic objectForKey:@"notificationStatus"]).intValue;
    conversation.unreadMessageCount = ((NSNumber *)[conversationDic objectForKey:@"unreadMessageCount"]).intValue;
    conversation.orderKey = ((NSNumber *)[conversationDic objectForKey:@"orderKey"]).longLongValue;
    conversation.lastMessage = [ZIMPluginConverter cnvZIMMessageDicToObject:(NSDictionary *)[conversationDic objectForKey:@"lastMessage"]];
    return conversation;
}

+(nullable NSDictionary *)cnvZIMConversationObjectToDic:(nullable ZIMConversation *)conversation{
    if(conversation == nil || conversation == NULL || [conversation isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *conversationDic = [[NSMutableDictionary alloc] init];
    [conversationDic safeSetObject:conversation.conversationID forKey:@"conversationID"];
    [conversationDic safeSetObject:conversation.conversationName forKey:@"conversationName"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.type] forKey:@"type"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.notificationStatus] forKey:@"notificationStatus"];
    [conversationDic safeSetObject:[NSNumber numberWithUnsignedInt:conversation.unreadMessageCount] forKey:@"unreadMessageCount"];
    [conversationDic safeSetObject:[NSNumber numberWithLongLong:conversation.orderKey] forKey:@"orderKey"];
    [conversationDic safeSetObject:[ZIMPluginConverter cnvZIMMessageObjectToDic:conversation.lastMessage] forKey:@"lastMessage"];
    return conversationDic;
    
}

+(nullable NSArray *)cnvZIMConversationListObjectToBasic:(nullable NSArray<ZIMConversation *> *)conversationList{
    if(conversationList == nil || conversationList == NULL || [conversationList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *conversationBasicList = [[NSMutableArray alloc] init];
    for (ZIMConversation *conversation in conversationList) {
        [conversationBasicList safeAddObject:[ZIMPluginConverter cnvZIMConversationObjectToDic:conversation]];
    }
    return conversationBasicList;
}

+(nullable NSArray *)cnvConversationChangeInfoListToBasicList:(nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    if(conversationChangeInfoList == nil || conversationChangeInfoList == NULL || [conversationChangeInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicChangeInfoList = [[NSMutableArray alloc] init];
    for (ZIMConversationChangeInfo *changeInfo in conversationChangeInfoList) {
        NSDictionary *changeInfoDic = [ZIMPluginConverter cnvConversationChangeInfoObjectToDic:changeInfo];
        [basicChangeInfoList safeAddObject:changeInfoDic];
    }
    return basicChangeInfoList;
}

+(nullable NSDictionary *)cnvConversationChangeInfoObjectToDic:(nullable ZIMConversationChangeInfo *)changeInfo{
    if(changeInfo == nil || changeInfo == NULL || [changeInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *changeInfoDic = [[NSMutableDictionary alloc] init];
    [changeInfoDic safeSetObject:[NSNumber numberWithInt:(int)changeInfo.event] forKey:@"event"];
    NSDictionary *conversationDic = [ZIMPluginConverter cnvZIMConversationObjectToDic:changeInfo.conversation];
    [changeInfoDic safeSetObject:conversationDic forKey:@"conversation"];
    return changeInfoDic;
}

+(nullable ZIMMessage *)cnvZIMMessageDicToObject:(nullable NSDictionary *)messageDic{
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
            break;
        }
        case ZIMMessageTypeImage:{
            msg = [[ZIMImageMessage alloc] init];
            ((ZIMImageMessage *)msg).thumbnailDownloadUrl = [messageDic safeObjectForKey:@"thumbnailDownloadUrl"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"thumbnailLocalPath"] forKey:@"thumbnailLocalPath"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageDownloadUrl"] forKey:@"largeImageDownloadUrl"];
            [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageLocalPath"] forKey:@"largeImageLocalPath"];
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

+(nullable NSDictionary *)cnvZIMMessageObjectToDic:(nullable ZIMMessage *)message{
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
            break;
        }
        case ZIMMessageTypeVideo:{
            ZIMVideoMessage *videoMsg = (ZIMVideoMessage *)message;
            [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:videoMsg.videoDuration] forKey:@"videoDuration"];
            [messageDic safeSetObject:videoMsg.videoFirstFrameDownloadUrl forKey:@"videoFirstFrameDownloadUrl"];
            [messageDic safeSetObject:videoMsg.videoFirstFrameLocalPath forKey:@"videoFirstFrameLocalPath"];
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

+(nullable NSArray *)cnvZIMMessageListToDicList:(nullable NSArray<ZIMMessage *>*)messageList{
    if(messageList == nil || messageList == NULL || [messageList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessage *msg in messageList) {
        [DicArr addObject:[ZIMPluginConverter cnvZIMMessageObjectToDic:msg]];
    }
    return DicArr;
}

+(nullable NSArray<ZIMMessage *>*)cnvBasicListToZIMMessageList:(nullable NSArray *)basicList{
    if(basicList == nil || basicList == NULL || [basicList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray<ZIMMessage *> *messageList = [[NSMutableArray alloc] init];
    for (NSDictionary *msgDic in basicList) {
        [messageList addObject:[ZIMPluginConverter cnvZIMMessageDicToObject:msgDic]];
    }
    return messageList;
}

+(nullable ZIMMessageDeleteConfig *)cnvZIMMessageDeleteConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageDeleteConfig * deleteConfig = [[ZIMMessageDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerMessage = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerMessage"]).boolValue;
    return deleteConfig;
}

+(nullable NSDictionary *)cnvZIMMessageDeleteConfigObjectToDic:(nullable ZIMMessageDeleteConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithBool:config.isAlsoDeleteServerMessage] forKey:@"isAlsoDeleteServerMessage"];
    return configDic;
    
}


+(nullable ZIMConversationDeleteConfig *)cnvZIMConversationDeleteConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMConversationDeleteConfig *deleteConfig = [[ZIMConversationDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerConversation = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerConversation"]).boolValue;
    return deleteConfig;
}

+(nullable ZIMMessageSendConfig *)cnvZIMMessageSendConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageSendConfig *sendConfig = [[ZIMMessageSendConfig alloc] init];
    sendConfig.priority = ((NSNumber *)[configDic objectForKey:@"priority"]).intValue;
    sendConfig.pushConfig = [ZIMPluginConverter cnvZIMPushConfigDicToObject:[configDic objectForKey:@"pushConfig"]];
    return sendConfig;
}

+(nullable ZIMPushConfig *)cnvZIMPushConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title = (NSString *)[configDic objectForKey:@"title"];
    pushConfig.content = (NSString *)[configDic objectForKey:@"content"];
    pushConfig.extendedData = (NSString *)[configDic objectForKey:@"extendedData"];
    return pushConfig;
}

+(nullable ZIMMessageQueryConfig *)cnvZIMMessageQueryConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.nextMessage = [ZIMPluginConverter cnvZIMMessageDicToObject:[configDic objectForKey:@"nextMessage"]];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).intValue;
    config.reverse = ((NSNumber *)[configDic objectForKey:@"reverse"]).boolValue;
    return config;
}

+(nullable ZIMRoomInfo *)cnvZIMRoomInfoBasicToObject:(nullable NSDictionary *)roomInfoDic{
    if(roomInfoDic == nil || roomInfoDic == NULL || [roomInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomInfo *roomInfo = [[ZIMRoomInfo alloc] init];
    roomInfo.roomID = [roomInfoDic objectForKey:@"roomID"];
    roomInfo.roomName = [roomInfoDic objectForKey:@"roomName"];
    return roomInfo;
}

+(nullable NSDictionary *)cnvZIMRoomInfoObjectToBasic:(nullable ZIMRoomInfo *)roomInfo{
    if(roomInfo == nil || roomInfo == NULL || [roomInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomInfoDic = [[NSMutableDictionary alloc] init];
    [roomInfoDic safeSetObject:roomInfo.roomID forKey:@"roomID"];
    [roomInfoDic safeSetObject:roomInfo.roomName forKey:@"roomName"];
    return roomInfoDic;
}

+(nullable NSDictionary *)cnvZIMRoomFullInfoObjectToDic:(nullable ZIMRoomFullInfo *)roomFullInfo{
    if(roomFullInfo == nil || roomFullInfo == NULL || [roomFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *baseInfoDic = [ZIMPluginConverter cnvZIMRoomInfoObjectToBasic:roomFullInfo.baseInfo];
    [roomFullInfoDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return roomFullInfoDic;
}

+(nullable ZIMRoomAdvancedConfig *)cnvZIMRoomAdvancedConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAdvancedConfig *config = [[ZIMRoomAdvancedConfig alloc] init];
    config.roomAttributes = [configDic safeObjectForKey:@"roomAttributes"];
    config.roomDestroyDelayTime = ((NSNumber *)[configDic objectForKey:@"roomDestroyDelayTime"]).unsignedIntValue;
    return config;
}

+(nullable ZIMRoomMemberQueryConfig *)cnvZIMRoomMemberQueryConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomMemberQueryConfig *config = [[ZIMRoomMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = (NSString *)[configDic objectForKey:@"nextFlag"];
    return config;
}

+(nullable ZIMRoomAttributesSetConfig *)cnvZIMRoomAttributesSetConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesSetConfig *config = [[ZIMRoomAttributesSetConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    return config;
}

+(nullable ZIMRoomAttributesDeleteConfig *)cnvZIMRoomAttributesDeleteConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesDeleteConfig *config = [[ZIMRoomAttributesDeleteConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    return config;
}

+(nullable ZIMRoomAttributesBatchOperationConfig *)cnvZIMRoomAttributesBatchOperationConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesBatchOperationConfig *config = [[ZIMRoomAttributesBatchOperationConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    
    return config;
}

+(nullable NSDictionary *)cnvZIMRoomAttributesUpdateInfoObjectToDic:(nullable ZIMRoomAttributesUpdateInfo *)updateInfo{
    if(updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *basicUpdateInfo = [[NSMutableDictionary alloc] init];
    [basicUpdateInfo safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [basicUpdateInfo safeSetObject:updateInfo.roomAttributes forKey:@"roomAttributes"];
    return basicUpdateInfo;
}

+(nullable NSArray *)cnvZIMRoomAttributesUpdateInfoListToBasicList:(nullable NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList{
    if(updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicUpadteInfoList = [[NSMutableArray alloc] init];
    for (ZIMRoomAttributesUpdateInfo *updateInfo in updateInfoList) {
        NSDictionary *updateInfoDic = [ZIMPluginConverter cnvZIMRoomAttributesUpdateInfoObjectToDic:updateInfo];
        [basicUpadteInfoList safeAddObject:updateInfoDic];
    }
    return basicUpadteInfoList;
}

+(nullable ZIMGroupInfo *)cnvZIMGroupInfoDicToObject:(nullable NSDictionary *)groupInfoDic{
    if(groupInfoDic == nil || groupInfoDic == NULL || [groupInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupID = [groupInfoDic objectForKey:@"groupID"];
    info.groupName = [groupInfoDic objectForKey:@"groupName"];
    return info;
}

+(nullable NSDictionary *)cnvZIMGroupInfoObjectToDic:(nullable ZIMGroupInfo *)groupInfo{
    if(groupInfo == nil || groupInfo == NULL || [groupInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupInfoDic = [[NSMutableDictionary alloc] init];
    [groupInfoDic safeSetObject:groupInfo.groupID forKey:@"groupID"];
    [groupInfoDic safeSetObject:groupInfo.groupName forKey:@"groupName"];
    return groupInfoDic;
}

+(nullable NSDictionary *)cnvZIMGroupMemberInfoObjectToDic:(nullable ZIMGroupMemberInfo *)memberInfo{
    if(memberInfo == nil || memberInfo == NULL || [memberInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *memberInfoDic = (NSMutableDictionary *)[ZIMPluginConverter cnvZIMUserInfoObjectToBasic:memberInfo];
    [memberInfoDic safeSetObject:memberInfo.memberNickname forKey:@"memberNickname"];
    [memberInfoDic safeSetObject:[NSNumber numberWithInt:memberInfo.memberRole] forKey:@"memberRole"];
    [memberInfoDic safeSetObject:memberInfo.userID forKey:@"userID"];
    [memberInfoDic safeSetObject:memberInfo.userName forKey:@"userName"];
    return memberInfoDic;
    
    
    
    
    
    
}

+(nullable NSArray *)cnvZIMGroupMemberInfoListToBasicList:(nullable NSArray<ZIMGroupMemberInfo *> *)memberInfoList{
    if(memberInfoList == nil || memberInfoList == NULL || [memberInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupMemberInfo *info in memberInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter cnvZIMGroupMemberInfoObjectToDic:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)cnvZIMErrorUserInfoToDic:(nullable ZIMErrorUserInfo *)errorUserInfo{
    if(errorUserInfo == nil || errorUserInfo == NULL || [errorUserInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
    [errorUserInfoDic safeSetObject:errorUserInfo.userID forKey:@"userID"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:errorUserInfo.reason] forKey:@"reason"];
    return errorUserInfoDic;
}

+(nullable NSArray *)cnvZIMErrorUserInfoListToBasicList:(nullable NSArray<ZIMErrorUserInfo *> *)errorUserInfoList{
    if(errorUserInfoList == nil || errorUserInfoList == NULL || [errorUserInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMErrorUserInfo *errorUserInfo in errorUserInfoList) {
        NSDictionary *errorUserInfoDic = [ZIMPluginConverter cnvZIMErrorUserInfoToDic:errorUserInfo];
        [basicList safeAddObject:errorUserInfoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)cnvZIMGroupFullInfoObjectToDic:(nullable ZIMGroupFullInfo *)groupFullInfo{
    if(groupFullInfo == nil || groupFullInfo == NULL || [groupFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupInfoObjectToDic:groupFullInfo.baseInfo];
    [groupFullInfoDic safeSetObject:groupInfoDic forKey:@"baseInfo"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupNotice forKey:@"groupNotice"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupAttributes forKey:@"groupAttributes"];
    [groupFullInfoDic safeSetObject:[NSNumber numberWithInt:(int)groupFullInfo.notificationStatus] forKey:@"notificationStatus"];
    return groupFullInfoDic;
}

+(nullable NSDictionary *)cnvZIMGroupAdvancedConfigObjectToDic:(nullable ZIMGroupAdvancedConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:config.groupNotice forKey:@"groupNotice"];
    [configDic safeSetObject:config.groupAttributes forKey:@"groupAttributes"];
    return configDic;
}

+(nullable ZIMGroupAdvancedConfig *)cnvZIMGroupAdvancedConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupAdvancedConfig *config = [[ZIMGroupAdvancedConfig alloc] init];
    config.groupAttributes = [configDic safeObjectForKey:@"groupAttributes"];
    config.groupNotice = [configDic safeObjectForKey:@"groupNotice"];
    return config;
}

+(nullable NSDictionary*)cnvZIMGroupObjectToDic:(nullable ZIMGroup *)group{
    if(group == nil || group == NULL || [group isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupDic = [[NSMutableDictionary alloc] init];
    [groupDic safeSetObject:[NSNumber numberWithInt:(int)group.notificationStatus] forKey:@"notificationStatus"];
    NSDictionary *baseInfoDic = [ZIMPluginConverter cnvZIMGroupInfoObjectToDic:group.baseInfo];
    [groupDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return groupDic;
}

+(nullable NSArray*)cnvZIMGroupListToBasicList:(nullable NSArray<ZIMGroup *> *)groupList{
    if(groupList == nil || groupList == NULL || [groupList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicGroupList = [[NSMutableArray alloc] init];
    for (ZIMGroup *group in groupList) {
        NSDictionary *groupDic = [ZIMPluginConverter cnvZIMGroupObjectToDic:group];
        [basicGroupList safeAddObject:groupDic];
    }
    return basicGroupList;
}

+(nullable NSDictionary *)cnvZIMGroupMemberQueryConfigObjectToDic:(nullable ZIMGroupMemberQueryConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.count] forKey:@"count"];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.nextFlag] forKey:@"nextFlag"];
    return configDic;
}

+(nullable ZIMGroupMemberQueryConfig *)cnvZIMGroupMemberQueryConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupMemberQueryConfig *config = [[ZIMGroupMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic safeObjectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = ((NSNumber *)[configDic safeObjectForKey:@"nextFlag"]).unsignedIntValue;
    return config;
}

//+(nullable NSDictionary *)cnv

+(nullable NSDictionary *)cnvZIMGroupOperatedInfoObjectToDic:(nullable ZIMGroupOperatedInfo *)operatedInfo{
    if(operatedInfo == nil || operatedInfo == NULL || [operatedInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *operatedInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *operatedUserInfoDic = [ZIMPluginConverter cnvZIMGroupMemberInfoObjectToDic:operatedInfo.operatedUserInfo];
    [operatedInfoDic safeSetObject:operatedUserInfoDic forKey:@"operatedUserInfo"];
    return operatedInfoDic;
}

+(nullable NSDictionary *)cnvZIMGroupAttributesUpdateInfoObjectToDic:(nullable ZIMGroupAttributesUpdateInfo *)updateInfo{
    if(updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *updateInfoDic = [[NSMutableDictionary alloc] init];
    [updateInfoDic safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [updateInfoDic safeSetObject:updateInfo.groupAttributes forKey:@"groupAttributes"];
    return updateInfoDic;
}

+(nullable NSArray *)cnvZIMGroupAttributesUpdateInfoListToBasicList:(nullable NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfoList{
    if(updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupAttributesUpdateInfo *info in updateInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter cnvZIMGroupAttributesUpdateInfoObjectToDic:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+(nullable NSDictionary *)cnvZIMCallUserInfoObjectToDic:(ZIMCallUserInfo *)callUserInfo{
    if(callUserInfo == nil || callUserInfo == NULL || [callUserInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *callUserInfoDic = [[NSMutableDictionary alloc] init];
    [callUserInfoDic safeSetObject:callUserInfo.userID forKey:@"userID"];
    [callUserInfoDic safeSetObject:[NSNumber numberWithInt:(int)callUserInfo.state] forKey:@"state"];
    return callUserInfoDic;
}

+(nullable NSArray *)cnvZIMCallUserInfoListToBasicList:(NSArray<ZIMCallUserInfo *> *)callUserInfoList{
    if(callUserInfoList == nil || callUserInfoList == NULL || [callUserInfoList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMCallUserInfo *userInfo in callUserInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter cnvZIMCallUserInfoObjectToDic:userInfo];
        [basicList safeAddObject:userInfoDic];
    }
    return basicList;
}

+(nullable ZIMCallInviteConfig *)cnvZIMCallInviteConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallInviteConfig *config = [[ZIMCallInviteConfig alloc] init];
    config.timeout = ((NSNumber *)[configDic safeObjectForKey:@"timeout"]).unsignedIntValue;
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable NSDictionary *)cnvZIMCallInvitationSentInfoObjectToDic:(nullable ZIMCallInvitationSentInfo *)info{
    if(info == nil || info == NULL || [info isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [infoDic safeSetObject:[ZIMPluginConverter cnvZIMCallUserInfoListToBasicList:info.errorInvitees] forKey:@"errorInvitees"];
    return infoDic;
}

+(nullable ZIMCallCancelConfig *)cnvZIMCallCancelConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallCancelConfig *config = [[ZIMCallCancelConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable ZIMCallAcceptConfig *)cnvZIMCallAcceptConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallAcceptConfig *config = [[ZIMCallAcceptConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+(nullable ZIMCallRejectConfig *)cnvZIMCallRejectConfigDicToObject:(nullable NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMCallRejectConfig *config = [[ZIMCallRejectConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

@end
