#import "ZIMPluginConverter.h"
#import <Flutter/Flutter.h>
@interface ZIMPluginConverter()


@end


@implementation ZIMPluginConverter

+(NSDictionary *)cnvZIMErrorObjectToDic:(ZIMError *)errorInfo{
    if(errorInfo == nil || errorInfo == NULL || [errorInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
    [errorInfoDic safeSetObject:[NSNumber numberWithInt:(int)errorInfo.code] forKey:@"code"];
    [errorInfoDic safeSetObject:errorInfo.message forKey:@"message"];
    return errorInfoDic;
}

+(NSDictionary *)cnvZIMUserInfoObjectToBasic:(ZIMUserInfo *)userInfo{
    if(userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic safeSetObject:userInfo.userID forKey:@"userID"];
    [userInfoDic safeSetObject:userInfo.userName forKey:@"userName"];
    return userInfoDic;
}

+(NSArray *)cnvZIMUserInfoListTobasicList:(NSArray<ZIMUserInfo *> *)userInfoList{
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

+(ZIMConversation *)cnvZIMConversationDicToObject:(NSDictionary *)conversationDic{
    if(conversationDic == nil){
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

+(NSDictionary *)cnvZIMConversationObjectToDic:(ZIMConversation *)conversation{
    if(conversation == nil){
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

+(NSArray *)cnvZIMConversationListObjectToBasic:(NSArray<ZIMConversation *> *)conversationList{
    if(conversationList == nil || conversationList == NULL || [conversationList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *conversationBasicList = [[NSMutableArray alloc] init];
    for (ZIMConversation *conversation in conversationList) {
        [conversationBasicList safeAddObject:[ZIMPluginConverter cnvZIMConversationObjectToDic:conversation]];
    }
    return conversationBasicList;
}

+(NSArray *)cnvConversationChangeInfoListToBasicList:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
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

+(NSDictionary *)cnvConversationChangeInfoObjectToDic:(ZIMConversationChangeInfo *)changeInfo{
    if(changeInfo == nil || changeInfo == NULL || [changeInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *changeInfoDic = [[NSMutableDictionary alloc] init];
    [changeInfoDic safeSetObject:[NSNumber numberWithInt:(int)changeInfo.event] forKey:@"event"];
    NSDictionary *conversationDic = [ZIMPluginConverter cnvZIMConversationObjectToDic:changeInfo.conversation];
    [changeInfoDic safeSetObject:conversationDic forKey:@"conversation"];
    return changeInfoDic;
}

+(ZIMMessage *)cnvZIMMessageDicToObject:(NSDictionary *)messageDic{
    if(messageDic == nil){
        return nil;
    }
    ZIMMessage *message = [[ZIMMessage alloc] init];
    [message safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"type"]  forKey:@"type"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"messageID"]  forKey:@"messageID"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"localMessageID"]  forKey:@"localMessageID"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"senderUserID"]  forKey:@"senderUserID"];
    [message safeSetValue:(NSString *)[messageDic objectForKey:@"conversationID"] forKey:@"conversationID"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"direction"]  forKey:@"direction"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"sentStatus"]  forKey:@"sentStatus"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"conversationType"]  forKey:@"conversationType"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"timestamp"]  forKey:@"timestamp"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"conversationSeq"]  forKey:@"conversationSeq"];
    [message safeSetValue:(NSNumber *)[messageDic objectForKey:@"orderKey"]  forKey:@"orderKey"];
    switch (message.type) {
        case ZIMMessageTypeUnknown:{
            return message;
        }
        case ZIMMessageTypeText:{
            ZIMTextMessage *txtMsg = (ZIMTextMessage *)message;
            txtMsg.message = (NSString *)[messageDic safeObjectForKey:@"message"];
            return txtMsg;
        }
        case ZIMMessageTypeCommand:{
            ZIMCommandMessage *cmdMsg = (ZIMCommandMessage *)message;
            cmdMsg.message = ((FlutterStandardTypedData *)[messageDic safeObjectForKey:@"message"]).data;
            return cmdMsg;
        }
        case ZIMMessageTypeBarrage:{
            ZIMBarrageMessage *brgMsg = (ZIMBarrageMessage *)message;
            brgMsg.message = (NSString *)[messageDic safeObjectForKey:@"message"];
            return brgMsg;
        }
        default:
            break;
    }
}

+(NSDictionary *)cnvZIMMessageObjectToDic:(ZIMMessage *)message{
    if(message == nil){
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
        default:
            break;
    }
    return messageDic;
}

+(NSArray *)cnvZIMMessageListToDicList:(NSArray<ZIMMessage *>*)messageList{
    if(messageList == nil || messageList == NULL || [messageList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessage *msg in messageList) {
        [DicArr addObject:[ZIMPluginConverter cnvZIMMessageObjectToDic:msg]];
    }
    return DicArr;
}

+(NSArray<ZIMMessage *>*)cnvBasicListToZIMMessageList:(NSArray *)basicList{
    if(basicList == nil || basicList == NULL || [basicList isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableArray<ZIMMessage *> *messageList = [[NSMutableArray alloc] init];
    for (NSDictionary *msgDic in basicList) {
        [messageList addObject:[ZIMPluginConverter cnvZIMMessageDicToObject:msgDic]];
    }
    return messageList;
}

+(ZIMMessageDeleteConfig *)cnvZIMMessageDeleteConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageDeleteConfig * deleteConfig = [[ZIMMessageDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerMessage = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerMessage"]).boolValue;
    return deleteConfig;
}

+(NSDictionary *)cnvZIMMessageDeleteConfigObjectToDic:(ZIMMessageDeleteConfig *)config{
    if(config == nil || config == NULL || [config isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithBool:config.isAlsoDeleteServerMessage] forKey:@"isAlsoDeleteServerMessage"];
    return configDic;
    
}


+(ZIMConversationDeleteConfig *)cnvZIMConversationDeleteConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMConversationDeleteConfig *deleteConfig = [[ZIMConversationDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerConversation = ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerConversation"]).boolValue;
    return deleteConfig;
}

+(ZIMMessageSendConfig *)cnvZIMMessageSendConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageSendConfig *sendConfig = [[ZIMMessageSendConfig alloc] init];
    sendConfig.priority = ((NSNumber *)[configDic objectForKey:@"priority"]).intValue;
    sendConfig.pushConfig = [ZIMPluginConverter cnvZIMPushConfigDicToObject:[configDic objectForKey:@"pushConfig"]];
    return sendConfig;
}

+(ZIMPushConfig *)cnvZIMPushConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title = (NSString *)[configDic objectForKey:@"title"];
    pushConfig.content = (NSString *)[configDic objectForKey:@"content"];
    pushConfig.extendedData = (NSString *)[configDic objectForKey:@"extendedData"];
    return pushConfig;
}

+(ZIMMessageQueryConfig *)cnvZIMMessageQueryConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.nextMessage = [ZIMPluginConverter cnvZIMMessageDicToObject:[configDic objectForKey:@"nextMessage"]];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).intValue;
    config.reverse = ((NSNumber *)[configDic objectForKey:@"reverse"]).boolValue;
    return config;
}

+(ZIMRoomInfo *)cnvZIMRoomInfoBasicToObject:(NSDictionary *)roomInfoDic{
    if(roomInfoDic == nil || roomInfoDic == NULL || [roomInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomInfo *roomInfo = [[ZIMRoomInfo alloc] init];
    roomInfo.roomID = [roomInfoDic objectForKey:@"roomID"];
    roomInfo.roomName = [roomInfoDic objectForKey:@"roomName"];
    return roomInfo;
}

+(NSDictionary *)cnvZIMRoomInfoObjectToBasic:(ZIMRoomInfo *)roomInfo{
    if(roomInfo == nil || roomInfo == NULL || [roomInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomInfoDic = [[NSMutableDictionary alloc] init];
    [roomInfoDic safeSetObject:roomInfo.roomID forKey:@"roomID"];
    [roomInfoDic safeSetObject:roomInfo.roomName forKey:@"roomName"];
    return roomInfoDic;
}

+(NSDictionary *)cnvZIMRoomFullInfoObjectToDic:(ZIMRoomFullInfo *)roomFullInfo{
    if(roomFullInfo == nil || roomFullInfo == NULL || [roomFullInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *roomFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *baseInfoDic = [ZIMPluginConverter cnvZIMRoomInfoObjectToBasic:roomFullInfo.baseInfo];
    [roomFullInfoDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return roomFullInfoDic;
}

+(ZIMRoomAdvancedConfig *)cnvZIMRoomAdvancedConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAdvancedConfig *config = [[ZIMRoomAdvancedConfig alloc] init];
    config.roomAttributes = [configDic safeObjectForKey:@"roomAttributes"];
    config.roomDestroyDelayTime = ((NSNumber *)[configDic objectForKey:@"roomDestroyDelayTime"]).unsignedIntValue;
    return config;
}

+(ZIMRoomMemberQueryConfig *)cnvZIMRoomMemberQueryConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomMemberQueryConfig *config = [[ZIMRoomMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = (NSString *)[configDic objectForKey:@"nextFlag"];
    return config;
}

+(ZIMRoomAttributesSetConfig *)cnvZIMRoomAttributesSetConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesSetConfig *config = [[ZIMRoomAttributesSetConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    return config;
}

+(ZIMRoomAttributesDeleteConfig *)cnvZIMRoomAttributesDeleteConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesDeleteConfig *config = [[ZIMRoomAttributesDeleteConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    return config;
}

+(ZIMRoomAttributesBatchOperationConfig *)cnvZIMRoomAttributesBatchOperationConfigDicToObject:(NSDictionary *)configDic{
    if(configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMRoomAttributesBatchOperationConfig *config = [[ZIMRoomAttributesBatchOperationConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft = ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    
    return config;
}

+(NSDictionary *)cnvZIMRoomAttributesUpdateInfoObjectToDic:(ZIMRoomAttributesUpdateInfo *)updateInfo{
    if(updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *basicUpdateInfo = [[NSMutableDictionary alloc] init];
    [basicUpdateInfo safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [basicUpdateInfo safeSetObject:updateInfo.roomAttributes forKey:@"roomAttributes"];
    return basicUpdateInfo;
}

+(NSArray *)cnvZIMRoomAttributesUpdateInfoListToBasicList:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList{
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

+(ZIMGroupInfo *)cnvZIMGroupInfoDicToObject:(NSDictionary *)groupInfoDic{
    if(groupInfoDic == nil || groupInfoDic == NULL || [groupInfoDic isEqual:[NSNull null]]){
        return nil;
    }
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupID = [groupInfoDic objectForKey:@"groupID"];
    info.groupName = [groupInfoDic objectForKey:@"groupName"];
    return info;
}

+(NSDictionary *)cnvZIMGroupInfoObjectToDic:(ZIMGroupInfo *)groupInfo{
    if(groupInfo == nil || groupInfo == NULL || [groupInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *groupInfoDic = [[NSMutableDictionary alloc] init];
    [groupInfoDic safeSetObject:groupInfo.groupID forKey:@"groupID"];
    [groupInfoDic safeSetObject:groupInfo.groupName forKey:@"groupName"];
    return groupInfoDic;
}

+(NSDictionary *)cnvZIMGroupMemberInfoObjectToDic:(ZIMGroupMemberInfo *)memberInfo{
    if(memberInfo == nil || memberInfo == NULL || [memberInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *memberInfoDic = (NSMutableDictionary *)[ZIMPluginConverter cnvZIMUserInfoObjectToBasic:memberInfo];
    [memberInfoDic safeSetObject:memberInfo.memberNickname forKey:@"memberNickname"];
    [memberInfoDic safeSetObject:[NSNumber numberWithInt:memberInfo.memberRole] forKey:@"memberRole"];
    return memberInfoDic;
    
    
    
    
    
    
}

+(NSArray *)cnvZIMGroupMemberInfoListToBasicList:(NSArray<ZIMGroupMemberInfo *> *)memberInfoList{
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

+(NSDictionary *)cnvZIMErrorUserInfoToDic:(ZIMErrorUserInfo *)errorUserInfo{
    if(errorUserInfo == nil || errorUserInfo == NULL || [errorUserInfo isEqual:[NSNull null]]){
        return nil;
    }
    NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
    [errorUserInfoDic safeSetObject:errorUserInfo.userID forKey:@"userID"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:errorUserInfo.reason] forKey:@"reason"];
    return errorUserInfoDic;
}

+(NSArray *)cnvZIMErrorUserInfoListToBasicList:(NSArray<ZIMErrorUserInfo *> *)errorUserInfoList{
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

+(NSDictionary *)cnvZIMGroupFullInfoObjectToDic:(ZIMGroupFullInfo *)groupFullInfo{
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
    [operatedInfoDic safeSetObject:operatedUserInfoDic forKey:@"operatedUserInfoDic"];
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
@end
