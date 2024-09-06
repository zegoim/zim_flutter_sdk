#import "ZIMPluginConverter.h"

@interface ZIMPluginConverter ()

@end

@implementation ZIMPluginConverter

+ (nullable ZIMAppConfig *)oZIMAppConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMAppConfig *config = [[ZIMAppConfig alloc] init];
    config.appID = [[configDic safeObjectForKey:@"appID"] unsignedIntValue];
    config.appSign = [configDic safeObjectForKey:@"appSign"];
    return config;
}

+ (nullable ZIMLoginConfig *)oZIMLoginConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMLoginConfig *config = [[ZIMLoginConfig alloc] init];
    config.userName = [configDic objectForKey:@"userName"];
    config.token = [configDic objectForKey:@"token"];
    config.isOfflineLogin = [[configDic objectForKey:@"isOfflineLogin"] boolValue];
    return config;
}

+ (nullable ZIMUsersInfoQueryConfig *)oZIMUserInfoQueryConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMUsersInfoQueryConfig *config = [[ZIMUsersInfoQueryConfig alloc] init];
    config.isQueryFromServer = [[configDic safeObjectForKey:@"isQueryFromServer"] boolValue];
    return config;
}

+ (nullable NSDictionary *)mZIMErrorObject:(nullable ZIMError *)errorInfo {
    if (errorInfo == nil || errorInfo == NULL || [errorInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
    [errorInfoDic safeSetObject:[NSNumber numberWithInt:(int)errorInfo.code] forKey:@"code"];
    [errorInfoDic safeSetObject:errorInfo.message forKey:@"message"];
    return errorInfoDic;
}

+ (nullable NSDictionary *)mZIMUserFullInfo:(nullable ZIMUserFullInfo *)userFullInfo {
    if (userFullInfo == nil || userFullInfo == NULL || [userFullInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *userFullInfoDic = [[NSMutableDictionary alloc] init];
    [userFullInfoDic safeSetObject:userFullInfo.userAvatarUrl forKey:@"userAvatarUrl"];
    [userFullInfoDic safeSetObject:userFullInfo.extendedData forKey:@"extendedData"];
    NSDictionary *baseInfodic = [ZIMPluginConverter mZIMUserInfo:userFullInfo.baseInfo];
    [userFullInfoDic safeSetObject:baseInfodic forKey:@"baseInfo"];
    return userFullInfoDic;
}

+ (nullable NSDictionary *)mZIMUserInfo:(nullable ZIMUserInfo *)userInfo {
    if (userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic safeSetObject:userInfo.userID forKey:@"userID"];
    [userInfoDic safeSetObject:userInfo.userName forKey:@"userName"];
    if (userInfo.userAvatarUrl != nil) {
        [userInfoDic safeSetObject:userInfo.userAvatarUrl forKey:@"userAvatarUrl"];
    } else {
        [userInfoDic safeSetObject:@"" forKey:@"userAvatarUrl"];
    }
    if ([userInfo isKindOfClass:[ZIMGroupMemberSimpleInfo class]]) {
        ZIMGroupMemberSimpleInfo *subInfo = (ZIMGroupMemberSimpleInfo *)userInfo;
        [userInfoDic setObject:subInfo.memberNickname forKey:@"memberNickname"];
        [userInfoDic setObject:@(subInfo.memberRole) forKey:@"memberRole"];
        [userInfoDic setObject:@"ZIMGroupMemberSimpleInfo" forKey:@"classType"];
    } else if ([userInfo isKindOfClass:[ZIMGroupMemberInfo class]]) {
        ZIMGroupMemberInfo *subInfo = (ZIMGroupMemberInfo *)userInfo;
        [userInfoDic setObject:subInfo.memberNickname forKey:@"memberNickname"];
        [userInfoDic setObject:@(subInfo.memberRole) forKey:@"memberRole"];
        if (subInfo.memberAvatarUrl != nil) {
            [userInfoDic setObject:subInfo.memberAvatarUrl forKey:@"memberAvatarUrl"];
        } else {
            [userInfoDic setObject:@"" forKey:@"memberAvatarUrl"];
        }
        [userInfoDic setObject:@(subInfo.muteExpiredTime) forKey:@"muteExpiredTime"];
        [userInfoDic setObject:@"ZIMGroupMemberInfo" forKey:@"classType"];
    } else if ([userInfo isKindOfClass:[ZIMFriendInfo class]]) {
        ZIMFriendInfo *subInfo = (ZIMFriendInfo *)userInfo;
        [userInfoDic setObject:subInfo.friendAlias forKey:@"friendAlias"];
        [userInfoDic setObject:@(subInfo.createTime) forKey:@"createTime"];
        [userInfoDic setObject:subInfo.wording forKey:@"wording"];
        [userInfoDic setObject:subInfo.friendAttributes forKey:@"friendAttributes"];
        [userInfoDic setObject:@"ZIMFriendInfo" forKey:@"classType"];
    }
    return userInfoDic;
}

+ (nullable NSDictionary *)mZIMGroupMemberSimpleInfo:
    (nullable ZIMGroupMemberSimpleInfo *)groupMemberSimpleInfo {
    if (groupMemberSimpleInfo == nil || groupMemberSimpleInfo == NULL ||
        [groupMemberSimpleInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *groupMemberSimpleInfoDic = [[NSMutableDictionary alloc] init];
    [groupMemberSimpleInfoDic safeSetObject:groupMemberSimpleInfo.memberNickname
                                     forKey:@"memberNickname"];
    [groupMemberSimpleInfoDic safeSetObject:groupMemberSimpleInfo.userID forKey:@"userID"];
    [groupMemberSimpleInfoDic safeSetObject:groupMemberSimpleInfo.userName forKey:@"userName"];
    [groupMemberSimpleInfoDic safeSetObject:groupMemberSimpleInfo.userAvatarUrl
                                     forKey:@"userAvatarUrl"];
    [groupMemberSimpleInfoDic
        safeSetObject:[NSNumber numberWithInt:(int)groupMemberSimpleInfo.memberRole]
               forKey:@"memberRole"];
    return groupMemberSimpleInfoDic;
}

+ (nullable NSDictionary *)mZIMRoomMemberInfo:(nullable ZIMRoomMemberInfo *)userInfo {
    if (userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic safeSetObject:userInfo.userID forKey:@"userID"];
    [userInfoDic safeSetObject:userInfo.userName forKey:@"userName"];
    return userInfoDic;
}

+ (nullable NSArray *)mZIMUserInfoList:(nullable NSArray<ZIMUserInfo *> *)userInfoList {
    if (userInfoList == nil || userInfoList == NULL || [userInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicZIMUserInfoList = [[NSMutableArray alloc] init];
    for (ZIMUserInfo *userInfo in userInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMUserInfo:userInfo];
        [basicZIMUserInfoList safeAddObject:userInfoDic];
    }
    return basicZIMUserInfoList;
}

+ (nullable NSArray *)mZIMRoomMemberInfoList:(nullable NSArray<ZIMRoomMemberInfo *> *)userInfoList {
    if (userInfoList == nil || userInfoList == NULL || [userInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicZIMUserInfoList = [[NSMutableArray alloc] init];
    for (ZIMRoomMemberInfo *userInfo in userInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMRoomMemberInfo:userInfo];
        [basicZIMUserInfoList safeAddObject:userInfoDic];
    }
    return basicZIMUserInfoList;
}

+ (nullable NSDictionary *)mZIMUserOfflinePushRule:
    (nullable ZIMUserOfflinePushRule *)offlinePushRule {
    if (offlinePushRule == nil || offlinePushRule == NULL ||
        [offlinePushRule isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:offlinePushRule.onlinePlatforms forKey:@"onlinePlatforms"];
    [dic setObject:offlinePushRule.notToReceiveOfflinePushPlatforms
            forKey:@"notToReceiveOfflinePushPlatforms"];
    return dic;
}

+ (nullable ZIMUserOfflinePushRule *)oZIMUserOfflinePushRule:(nullable NSDictionary *)ruleDic {
    if (ruleDic == nil || ruleDic == NULL || [ruleDic isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    ZIMUserOfflinePushRule *offlinePushRule = [[ZIMUserOfflinePushRule alloc] init];
    offlinePushRule.onlinePlatforms = [ruleDic objectForKey:@"onlinePlatforms"];
    offlinePushRule.notToReceiveOfflinePushPlatforms =
        [ruleDic objectForKey:@"notToReceiveOfflinePushPlatforms"];
    return offlinePushRule;
}

+ (nullable NSDictionary *)mZIMUserRule:(nullable ZIMUserRule *)userRule {
    if (userRule == nil || userRule == NULL || [userRule isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[ZIMPluginConverter mZIMUserOfflinePushRule:userRule.offlinePushRule]
            forKey:@"offlinePushRule"];
    return dic;
}

+ (nullable NSDictionary *)mZIMSelfUserInfo:(nullable ZIMSelfUserInfo *)selfUserInfo {
    if (selfUserInfo == nil || selfUserInfo == NULL || [selfUserInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[ZIMPluginConverter mZIMUserRule:selfUserInfo.userRule] forKey:@"userRule"];
    [dic setObject:[ZIMPluginConverter mZIMUserFullInfo:selfUserInfo.userFullInfo]
            forKey:@"userFullInfo"];
    return dic;
}

+ (nullable ZIMConversation *)oZIMConversation:(nullable NSDictionary *)conversationDic {
    if (conversationDic == nil || conversationDic == NULL ||
        [conversationDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMConversation *conversation;
    ZIMConversationType type = ((NSNumber *)[conversationDic objectForKey:@"type"]).intValue;
    if (type == ZIMConversationTypeGroup) {
        conversation = [[ZIMGroupConversation alloc] init];
        ((ZIMGroupConversation *)conversation).mutedExpiredTime =
            [[conversationDic objectForKey:@"mutedExpiredTime"] longLongValue];
        ((ZIMGroupConversation *)conversation).isDisabled =
            [[conversationDic objectForKey:@"isDisabled"] boolValue];
    } else {
        conversation = [[ZIMConversation alloc] init];
    }
    conversation.conversationID = (NSString *)[conversationDic objectForKey:@"conversationID"];
    conversation.conversationName = (NSString *)[conversationDic objectForKey:@"conversationName"];
    conversation.conversationAlias =
        (NSString *)[conversationDic objectForKey:@"conversationAlias"];
    conversation.conversationAvatarUrl =
        (NSString *)[conversationDic objectForKey:@"conversationAvatarUrl"];
    conversation.type = ((NSNumber *)[conversationDic objectForKey:@"type"]).intValue;
    conversation.notificationStatus =
        ((NSNumber *)[conversationDic objectForKey:@"notificationStatus"]).intValue;
    conversation.unreadMessageCount =
        ((NSNumber *)[conversationDic objectForKey:@"unreadMessageCount"]).intValue;
    conversation.orderKey = ((NSNumber *)[conversationDic objectForKey:@"orderKey"]).longLongValue;
    conversation.lastMessage = [ZIMPluginConverter
        oZIMMessage:(NSDictionary *)[conversationDic objectForKey:@"lastMessage"]];
    conversation.isPinned = ((NSNumber *)[conversationDic objectForKey:@"isPinned"]).boolValue;
    conversation.draft = (NSString *)[conversationDic objectForKey:@"draft"];
    conversation.marks = [conversationDic objectForKey:@"marks"];
    return conversation;
}

+ (nullable NSDictionary *)mZIMConversation:(nullable ZIMConversation *)conversation {
    if (conversation == nil || conversation == NULL || [conversation isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *conversationDic = [[NSMutableDictionary alloc] init];
    [conversationDic safeSetObject:conversation.conversationID forKey:@"conversationID"];
    [conversationDic safeSetObject:conversation.conversationName forKey:@"conversationName"];
    [conversationDic safeSetObject:conversation.conversationAlias forKey:@"conversationAlias"];
    [conversationDic safeSetObject:conversation.conversationAvatarUrl
                            forKey:@"conversationAvatarUrl"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.type] forKey:@"type"];
    [conversationDic safeSetObject:[NSNumber numberWithInt:(int)conversation.notificationStatus]
                            forKey:@"notificationStatus"];
    [conversationDic safeSetObject:[NSNumber numberWithUnsignedInt:conversation.unreadMessageCount]
                            forKey:@"unreadMessageCount"];
    [conversationDic safeSetObject:[NSNumber numberWithLongLong:conversation.orderKey]
                            forKey:@"orderKey"];
    [conversationDic safeSetObject:[ZIMPluginConverter mZIMMessage:conversation.lastMessage]
                            forKey:@"lastMessage"];
    [conversationDic safeSetObject:[NSNumber numberWithBool:conversation.isPinned]
                            forKey:@"isPinned"];
    [conversationDic
        safeSetObject:[ZIMPluginConverter mZIMMentionedInfoList:conversation.mentionedInfoList]
               forKey:@"mentionedInfoList"];
    [conversationDic safeSetObject:conversation.draft forKey:@"draft"];
    [conversationDic safeSetObject:conversation.marks forKey:@"marks"];
    if (conversation.type == ZIMConversationTypeGroup) {
        if ([conversation isKindOfClass:[ZIMGroupConversation class]]) {
            [conversationDic
                safeSetObject:@(((ZIMGroupConversation *)conversation).mutedExpiredTime)
                       forKey:@"mutedExpiredTime"];
            [conversationDic safeSetObject:@(((ZIMGroupConversation *)conversation).isDisabled)
                                    forKey:@"isDisabled"];
        }
    }
    return conversationDic;
}

+ (nullable NSArray *)mZIMConversationList:(nullable NSArray<ZIMConversation *> *)conversationList {
    if (conversationList == nil || conversationList == NULL ||
        [conversationList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *conversationBasicList = [[NSMutableArray alloc] init];
    for (ZIMConversation *conversation in conversationList) {
        [conversationBasicList safeAddObject:[ZIMPluginConverter mZIMConversation:conversation]];
    }
    return conversationBasicList;
}

+ (nullable NSArray *)mConversationChangeInfoList:
    (nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList {
    if (conversationChangeInfoList == nil || conversationChangeInfoList == NULL ||
        [conversationChangeInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicChangeInfoList = [[NSMutableArray alloc] init];
    for (ZIMConversationChangeInfo *changeInfo in conversationChangeInfoList) {
        NSDictionary *changeInfoDic = [ZIMPluginConverter mConversationChangeInfo:changeInfo];
        [basicChangeInfoList safeAddObject:changeInfoDic];
    }
    return basicChangeInfoList;
}

+ (nullable NSArray *)mMessageSentStatusChangeInfoList:
    (nullable NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList {
    if (messageSentStatusChangeInfoList == nil || messageSentStatusChangeInfoList == NULL ||
        [messageSentStatusChangeInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicChangeInfoList = [[NSMutableArray alloc] init];
    for (ZIMMessageSentStatusChangeInfo *changeInfo in messageSentStatusChangeInfoList) {
        NSDictionary *changeInfoDic = [ZIMPluginConverter mMessageSentStatusChangeInfo:changeInfo];
        [basicChangeInfoList safeAddObject:changeInfoDic];
    }
    return basicChangeInfoList;
}

+ (nullable NSDictionary *)mConversationChangeInfo:
    (nullable ZIMConversationChangeInfo *)changeInfo {
    if (changeInfo == nil || changeInfo == NULL || [changeInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *changeInfoDic = [[NSMutableDictionary alloc] init];
    [changeInfoDic safeSetObject:[NSNumber numberWithInt:(int)changeInfo.event] forKey:@"event"];
    NSDictionary *conversationDic = [ZIMPluginConverter mZIMConversation:changeInfo.conversation];
    [changeInfoDic safeSetObject:conversationDic forKey:@"conversation"];
    return changeInfoDic;
}

+ (nullable NSDictionary *)mMessageSentStatusChangeInfo:
    (nullable ZIMMessageSentStatusChangeInfo *)changeInfo {
    if (changeInfo == nil || changeInfo == NULL || [changeInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *changeInfoDic = [[NSMutableDictionary alloc] init];
    [changeInfoDic safeSetObject:[NSNumber numberWithInt:(int)changeInfo.status] forKey:@"status"];
    NSDictionary *messageDic = [ZIMPluginConverter mZIMMessage:changeInfo.message];
    [changeInfoDic safeSetObject:messageDic forKey:@"message"];
    [changeInfoDic safeSetObject:changeInfo.reason forKey:@"reason"];
    return changeInfoDic;
}

+ (nullable ZIMMessage *)oZIMMessage:(nullable NSDictionary *)messageDic {
    if (messageDic == nil || messageDic == NULL || [messageDic isEqual:[NSNull null]]) {
        return nil;
    }
    id msg;
    ZIMMessageType msgType = ((NSNumber *)[messageDic safeObjectForKey:@"type"]).intValue;
    switch (msgType) {
    case ZIMMessageTypeUnknown: {
        msg = [[ZIMMessage alloc] init];
        break;
    }
    case ZIMMessageTypeText: {
        msg = [[ZIMTextMessage alloc] init];
        ((ZIMTextMessage *)msg).message = (NSString *)[messageDic safeObjectForKey:@"message"];
        break;
    }
    case ZIMMessageTypeCommand: {
        msg = [[ZIMCommandMessage alloc] init];
        ((ZIMCommandMessage *)msg).message =
            ((FlutterStandardTypedData *)[messageDic safeObjectForKey:@"message"]).data;
        break;
    }
    case ZIMMessageTypeBarrage: {
        msg = [[ZIMBarrageMessage alloc] init];
        ((ZIMBarrageMessage *)msg).message = (NSString *)[messageDic safeObjectForKey:@"message"];
        break;
    }
    case ZIMMessageTypeFile: {
        msg = [[ZIMFileMessage alloc] init];
        break;
    }
    case ZIMMessageTypeAudio: {
        msg = [[ZIMAudioMessage alloc] init];

        ((ZIMAudioMessage *)msg).audioDuration =
            ((NSNumber *)[messageDic safeObjectForKey:@"audioDuration"]).unsignedIntValue;
        break;
    }
    case ZIMMessageTypeVideo: {
        msg = [[ZIMVideoMessage alloc] init];
        ((ZIMVideoMessage *)msg).videoDuration =
            ((NSNumber *)[messageDic safeObjectForKey:@"videoDuration"]).unsignedIntValue;
        [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                   safeObjectForKey:@"videoFirstFrameDownloadUrl"]
                                        forKey:@"videoFirstFrameDownloadUrl"];
        [((ZIMVideoMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                   safeObjectForKey:@"videoFirstFrameLocalPath"]
                                        forKey:@"videoFirstFrameLocalPath"];
        [((ZIMVideoMessage *)msg)
            safeSetValue:@(CGSizeMake(
                             [[messageDic safeObjectForKey:@"videoFirstFrameWidth"] doubleValue],
                             [[messageDic safeObjectForKey:@"videoFirstFrameHeight"] doubleValue]))
                  forKey:@"videoFirstFrameSize"];
        break;
    }
    case ZIMMessageTypeImage: {
        msg = [[ZIMImageMessage alloc] init];
        ((ZIMImageMessage *)msg).thumbnailDownloadUrl =
            [messageDic safeObjectForKey:@"thumbnailDownloadUrl"];
        [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"thumbnailLocalPath"]
                                        forKey:@"thumbnailLocalPath"];
        [((ZIMImageMessage *)msg) safeSetValue:[messageDic
                                                   safeObjectForKey:@"largeImageDownloadUrl"]
                                        forKey:@"largeImageDownloadUrl"];
        [((ZIMImageMessage *)msg) safeSetValue:[messageDic safeObjectForKey:@"largeImageLocalPath"]
                                        forKey:@"largeImageLocalPath"];
        [((ZIMImageMessage *)msg)
            safeSetValue:@(CGSizeMake(
                             [[messageDic safeObjectForKey:@"originalImageWidth"] doubleValue],
                             [[messageDic safeObjectForKey:@"originalImageHeight"] doubleValue]))
                  forKey:@"originalImageSize"];
        [((ZIMImageMessage *)msg)
            safeSetValue:@(CGSizeMake(
                             [[messageDic safeObjectForKey:@"largeImageWidth"] doubleValue],
                             [[messageDic safeObjectForKey:@"largeImageHeight"] doubleValue]))
                  forKey:@"largeImageSize"];
        [((ZIMImageMessage *)msg)
            safeSetValue:@(CGSizeMake(
                             [[messageDic safeObjectForKey:@"thumbnailWidth"] doubleValue],
                             [[messageDic safeObjectForKey:@"thumbnailHeight"] doubleValue]))
                  forKey:@"thumbnailSize"];
        break;
    }
    case ZIMMessageTypeSystem: {
        msg = [[ZIMSystemMessage alloc] init];
        ((ZIMSystemMessage *)msg).message = [messageDic safeObjectForKey:@"message"];
        break;
    }
    case ZIMMessageTypeCustom: {
        msg = [[ZIMCustomMessage alloc] init];
        ((ZIMCustomMessage *)msg).message = [messageDic safeObjectForKey:@"message"];
        ((ZIMCustomMessage *)msg).searchedContent =
            [messageDic safeObjectForKey:@"searchedContent"];
        ((ZIMCustomMessage *)msg).subType =
            ((NSNumber *)[messageDic safeObjectForKey:@"subType"]).unsignedIntValue;
        break;
    }
    case ZIMMessageTypeRevoke: {
        msg = [[ZIMRevokeMessage alloc] init];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSNumber *)[messageDic
                                                    safeObjectForKey:@"revokeType"]
                                         forKey:@"revokeType"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSNumber *)[messageDic
                                                    safeObjectForKey:@"revokeTimestamp"]
                                         forKey:@"revokeTimestamp"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSNumber *)[messageDic
                                                    safeObjectForKey:@"originalMessageType"]
                                         forKey:@"originalMessageType"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSNumber *)[messageDic
                                                    safeObjectForKey:@"revokeStatus"]
                                         forKey:@"revokeStatus"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                    safeObjectForKey:@"operatedUserID"]
                                         forKey:@"operatedUserID"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                    safeObjectForKey:@"originalTextMessageContent"]
                                         forKey:@"originalTextMessageContent"];
        [((ZIMRevokeMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                    safeObjectForKey:@"revokeExtendedData"]
                                         forKey:@"revokeExtendedData"];
        break;
    }
    case ZIMMessageTypeCombine: {
        msg = [[ZIMCombineMessage alloc] init];
        [((ZIMCombineMessage *)msg) safeSetValue:(NSString *)[messageDic
                                                     safeObjectForKey:@"combineID"]
                                          forKey:@"combineID"];
        ((ZIMCombineMessage *)msg).title = [messageDic safeObjectForKey:@"title"];
        ((ZIMCombineMessage *)msg).summary = [messageDic safeObjectForKey:@"summary"];
        NSArray *messageList =
            [ZIMPluginConverter oZIMMessageList:[messageDic safeObjectForKey:@"messageList"]];
        ((ZIMCombineMessage *)msg).messageList = messageList;
        break;
    }
    case ZIMMessageTypeTips: {
        msg = [[ZIMTipsMessage alloc] init];
        break;
    }
    default:
        break;
    }
    [msg safeSetValue:[messageDic safeObjectForKey:@"mentionedUserIDs"] forKey:@"mentionedUserIDs"];
    [msg safeSetValue:[messageDic safeObjectForKey:@"isMentionAll"] forKey:@"isMentionAll"];
    [msg safeSetValue:[messageDic safeObjectForKey:@"isServerMessage"] forKey:@"isServerMessage"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"type"] forKey:@"type"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"messageID"] forKey:@"messageID"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"localMessageID"]
               forKey:@"localMessageID"];
    [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"senderUserID"]
               forKey:@"senderUserID"];
    [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"conversationID"]
               forKey:@"conversationID"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"direction"] forKey:@"direction"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"sentStatus"] forKey:@"sentStatus"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"conversationType"]
               forKey:@"conversationType"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"timestamp"] forKey:@"timestamp"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"conversationSeq"]
               forKey:@"conversationSeq"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"messageSeq"] forKey:@"messageSeq"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"orderKey"] forKey:@"orderKey"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"isUserInserted"]
               forKey:@"isUserInserted"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"receiptStatus"]
               forKey:@"receiptStatus"];
    [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"extendedData"]
               forKey:@"extendedData"];
    [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"localExtendedData"]
               forKey:@"localExtendedData"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"isBroadcastMessage"]
               forKey:@"isBroadcastMessage"];
    [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"cbInnerID"] forKey:@"cbInnerID"];
    [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"rootRepliedCount"]
               forKey:@"rootRepliedCount"];
    [msg safeSetValue:[ZIMPluginConverter
                          oZIMMessageRepliedInfo:[messageDic safeObjectForKey:@"repliedInfo"]]
               forKey:@"repliedInfo"];

    if ([msg isKindOfClass:[ZIMMediaMessage class]]) {
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileLocalPath"]
                   forKey:@"fileLocalPath"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileDownloadUrl"]
                   forKey:@"fileDownloadUrl"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileUID"] forKey:@"fileUID"];
        [msg safeSetValue:(NSString *)[messageDic safeObjectForKey:@"fileName"] forKey:@"fileName"];
        [msg safeSetValue:(NSNumber *)[messageDic safeObjectForKey:@"fileSize"] forKey:@"fileSize"];
    }

    return msg;
}

+ (nullable NSDictionary *)mZIMMessage:(nullable ZIMMessage *)message {
    if (message == nil || message == NULL || [message isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];

    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.type] forKey:@"type"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.messageID] forKey:@"messageID"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.localMessageID]
                       forKey:@"localMessageID"];

    [messageDic safeSetObject:message.senderUserID forKey:@"senderUserID"];
    [messageDic safeSetObject:message.conversationID forKey:@"conversationID"];
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.direction] forKey:@"direction"];
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.sentStatus]
                       forKey:@"sentStatus"];
    [messageDic safeSetObject:[NSNumber numberWithBool:message.isUserInserted]
                       forKey:@"isUserInserted"];
    [messageDic safeSetObject:[NSNumber numberWithInt:(int)message.conversationType]
                       forKey:@"conversationType"];

    [messageDic safeSetObject:[NSNumber numberWithUnsignedLongLong:message.timestamp]
                       forKey:@"timestamp"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.messageSeq]
                       forKey:@"messageSeq"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.conversationSeq]
                       forKey:@"conversationSeq"];
    [messageDic safeSetObject:[NSNumber numberWithLongLong:message.orderKey] forKey:@"orderKey"];
    [messageDic safeSetObject:[NSNumber numberWithUnsignedInteger:message.receiptStatus]
                       forKey:@"receiptStatus"];
    [messageDic safeSetObject:message.extendedData forKey:@"extendedData"];
    [messageDic safeSetObject:message.localExtendedData forKey:@"localExtendedData"];
    [messageDic safeSetObject:[NSNumber numberWithBool:message.isBroadcastMessage]
                       forKey:@"isBroadcastMessage"];
    [messageDic safeSetObject:[ZIMPluginConverter mZIMMessageReactionList:message.reactions]
                       forKey:@"reactions"];
    [messageDic safeSetObject:[NSNumber numberWithBool:message.isMentionAll]
                       forKey:@"isMentionAll"];
    [messageDic safeSetObject:[NSNumber numberWithBool:message.isServerMessage]
                       forKey:@"isServerMessage"];
    [messageDic safeSetObject:message.mentionedUserIDs forKey:@"mentionedUserIDs"];
    [messageDic safeSetObject:message.cbInnerID forKey:@"cbInnerID"];
    [messageDic safeSetObject:[NSNumber numberWithUnsignedInteger:message.rootRepliedCount]
                       forKey:@"rootRepliedCount"];
    if (message.repliedInfo) {
        [messageDic safeSetObject:[ZIMPluginConverter mZIMMessageRepliedInfo:message.repliedInfo]
                           forKey:@"repliedInfo"];
    }

    if ([message isKindOfClass:[ZIMMediaMessage class]]) {
        ZIMMediaMessage *mediaMsg = (ZIMMediaMessage *)message;
        [messageDic safeSetObject:mediaMsg.fileLocalPath forKey:@"fileLocalPath"];
        [messageDic safeSetObject:mediaMsg.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [messageDic safeSetObject:mediaMsg.fileUID forKey:@"fileUID"];
        [messageDic safeSetObject:mediaMsg.fileName forKey:@"fileName"];
        [messageDic safeSetObject:[NSNumber numberWithLongLong:mediaMsg.fileSize]
                           forKey:@"fileSize"];
    }

    switch (message.type) {
    case ZIMMessageTypeUnknown: {
        break;
    }
    case ZIMMessageTypeText: {
        ZIMTextMessage *txtMsg = (ZIMTextMessage *)message;
        [messageDic safeSetObject:txtMsg.message forKey:@"message"];
        break;
    }
    case ZIMMessageTypeCommand: {
        ZIMCommandMessage *cmdMsg = (ZIMCommandMessage *)message;
        [messageDic safeSetObject:[FlutterStandardTypedData typedDataWithBytes:cmdMsg.message]
                           forKey:@"message"];
        break;
    }
    case ZIMMessageTypeBarrage: {
        ZIMBarrageMessage *brgMsg = (ZIMBarrageMessage *)message;
        [messageDic safeSetObject:brgMsg.message forKey:@"message"];
        break;
    }
    case ZIMMessageTypeFile: {
        break;
    }
    case ZIMMessageTypeImage: {
        ZIMImageMessage *imgMsg = (ZIMImageMessage *)message;
        [messageDic safeSetObject:imgMsg.thumbnailDownloadUrl forKey:@"thumbnailDownloadUrl"];
        [messageDic safeSetObject:imgMsg.thumbnailLocalPath forKey:@"thumbnailLocalPath"];
        [messageDic safeSetObject:imgMsg.largeImageDownloadUrl forKey:@"largeImageDownloadUrl"];
        [messageDic safeSetObject:imgMsg.largeImageLocalPath forKey:@"largeImageLocalPath"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.originalImageSize.height]
                           forKey:@"originalImageHeight"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.originalImageSize.width]
                           forKey:@"originalImageWidth"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.largeImageSize.height]
                           forKey:@"largeImageHeight"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.largeImageSize.width]
                           forKey:@"largeImageWidth"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.thumbnailSize.height]
                           forKey:@"thumbnailHeight"];
        [messageDic safeSetObject:[NSNumber numberWithInt:imgMsg.thumbnailSize.width]
                           forKey:@"thumbnailWidth"];
        break;
    }
    case ZIMMessageTypeVideo: {
        ZIMVideoMessage *videoMsg = (ZIMVideoMessage *)message;
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:videoMsg.videoDuration]
                           forKey:@"videoDuration"];
        [messageDic safeSetObject:videoMsg.videoFirstFrameDownloadUrl
                           forKey:@"videoFirstFrameDownloadUrl"];
        [messageDic safeSetObject:videoMsg.videoFirstFrameLocalPath
                           forKey:@"videoFirstFrameLocalPath"];
        [messageDic safeSetObject:[NSNumber numberWithInt:videoMsg.videoFirstFrameSize.height]
                           forKey:@"videoFirstFrameHeight"];
        [messageDic safeSetObject:[NSNumber numberWithInt:videoMsg.videoFirstFrameSize.width]
                           forKey:@"videoFirstFrameWidth"];
        break;
    }
    case ZIMMessageTypeAudio: {
        ZIMAudioMessage *audioMsg = (ZIMAudioMessage *)message;
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:audioMsg.audioDuration]
                           forKey:@"audioDuration"];
        break;
    }
    case ZIMMessageTypeSystem: {
        ZIMSystemMessage *sysMsg = (ZIMSystemMessage *)message;
        [messageDic safeSetObject:sysMsg.message forKey:@"message"];
        break;
    }
    case ZIMMessageTypeCustom: {
        ZIMCustomMessage *customMsg = (ZIMCustomMessage *)message;
        [messageDic safeSetObject:customMsg.message forKey:@"message"];
        [messageDic safeSetObject:customMsg.searchedContent forKey:@"searchedContent"];
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInt:customMsg.subType]
                           forKey:@"subType"];
        break;
    }
    case ZIMMessageTypeRevoke: {
        ZIMRevokeMessage *revokeMsg = (ZIMRevokeMessage *)message;
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInteger:revokeMsg.revokeType]
                           forKey:@"revokeType"];
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInteger:revokeMsg.revokeStatus]
                           forKey:@"revokeStatus"];
        [messageDic safeSetObject:[NSNumber numberWithUnsignedLongLong:revokeMsg.revokeTimestamp]
                           forKey:@"revokeTimestamp"];
        [messageDic safeSetObject:revokeMsg.operatedUserID forKey:@"operatedUserID"];
        [messageDic safeSetObject:revokeMsg.revokeExtendedData forKey:@"revokeExtendedData"];
        [messageDic safeSetObject:[NSNumber numberWithUnsignedInteger:revokeMsg.originalMessageType]
                           forKey:@"originalMessageType"];
        [messageDic safeSetObject:revokeMsg.originalTextMessageContent
                           forKey:@"originalTextMessageContent"];
        break;
    }
    case ZIMMessageTypeCombine: {
        ZIMCombineMessage *combineMessage = (ZIMCombineMessage *)message;
        [messageDic safeSetObject:combineMessage.title forKey:@"title"];
        [messageDic safeSetObject:combineMessage.summary forKey:@"summary"];
        [messageDic safeSetObject:combineMessage.combineID forKey:@"combineID"];
        [messageDic safeSetObject:[ZIMPluginConverter mZIMMessageList:combineMessage.messageList]
                           forKey:@"messageList"];
        break;
    }
    case ZIMMessageTypeTips: {
        ZIMTipsMessage *tipsMessage = (ZIMTipsMessage *)message;
        [messageDic setObject:@(tipsMessage.event) forKey:@"event"];
        if (tipsMessage.operatedUser != nil) {
            [messageDic setObject:[ZIMPluginConverter mZIMUserInfo:tipsMessage.operatedUser]
                           forKey:@"operatedUser"];
        }
        if (tipsMessage.changeInfo != nil) {
            [messageDic
                setObject:[ZIMPluginConverter mZIMTipsMessageChangeInfo:tipsMessage.changeInfo]
                   forKey:@"changeInfo"];
        }
        [messageDic setObject:[ZIMPluginConverter mZIMUserInfoList:tipsMessage.targetUserList]
                       forKey:@"targetUserList"];
        break;
    }
    default:
        break;
    }
    return messageDic;
}

+ (nullable NSArray *)mZIMMessageList:(nullable NSArray<ZIMMessage *> *)messageList {
    if (messageList == nil || messageList == NULL || [messageList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessage *msg in messageList) {
        [DicArr addObject:[ZIMPluginConverter mZIMMessage:msg]];
    }
    return DicArr;
}

+ (nullable NSArray *)mZIMMentionedInfoList:
    (nullable NSArray<ZIMMessageMentionedInfo *> *)mentionedInfoList {
    if (mentionedInfoList == nil || mentionedInfoList == NULL ||
        [mentionedInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessageMentionedInfo *info in mentionedInfoList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic safeSetObject:[NSNumber numberWithInt:(int)info.type] forKey:@"type"];
        [dic safeSetObject:info.fromUserID forKey:@"fromUserID"];
        [dic safeSetObject:[NSNumber numberWithLongLong:info.messageID] forKey:@"messageID"];
        [dic safeSetObject:[NSNumber numberWithLongLong:info.messageSeq] forKey:@"messageSeq"];
        [DicArr addObject:dic];
    }
    return DicArr;
}

+ (nullable NSArray<ZIMMessage *> *)oZIMMessageList:(nullable NSArray *)basicList {
    if (basicList == nil || basicList == NULL || [basicList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray<ZIMMessage *> *messageList = [[NSMutableArray alloc] init];
    for (NSDictionary *msgDic in basicList) {
        [messageList addObject:[ZIMPluginConverter oZIMMessage:msgDic]];
    }
    return messageList;
}

+ (nullable ZIMMessageRevokeConfig *)oZIMMessageRevokeConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMMessageRevokeConfig *config = [[ZIMMessageRevokeConfig alloc] init];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];
    config.revokeExtendedData = [configDic safeObjectForKey:@"revokeExtendedData"];
    return config;
}

+ (nullable NSDictionary *)mZIMMessageReceiptInfo:(nullable ZIMMessageReceiptInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoModel = [[NSMutableDictionary alloc] init];
    [infoModel safeSetObject:info.conversationID forKey:@"conversationID"];
    [infoModel safeSetObject:[NSNumber numberWithUnsignedInteger:info.conversationType]
                      forKey:@"conversationType"];
    [infoModel safeSetObject:[NSNumber numberWithLongLong:info.messageID] forKey:@"messageID"];
    [infoModel safeSetObject:[NSNumber numberWithUnsignedInteger:info.status] forKey:@"status"];
    [infoModel safeSetObject:[NSNumber numberWithUnsignedInt:info.readMemberCount]
                      forKey:@"readMemberCount"];
    [infoModel safeSetObject:[NSNumber numberWithUnsignedInt:info.unreadMemberCount]
                      forKey:@"unreadMemberCount"];
    [infoModel safeSetObject:[NSNumber numberWithBool:info.isSelfOperated]
                      forKey:@"isSelfOperated"];
    return infoModel;
}

+ (nullable ZIMGroupMessageReceiptMemberQueryConfig *)oZIMGroupMessageReceiptMemberQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupMessageReceiptMemberQueryConfig *queryConfig =
        [[ZIMGroupMessageReceiptMemberQueryConfig alloc] init];
    queryConfig.nextFlag = [[configDic safeObjectForKey:@"nextFlag"] unsignedIntValue];
    queryConfig.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    return queryConfig;
}

+ (nullable ZIMMessageDeleteConfig *)oZIMMessageDeleteConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMMessageDeleteConfig *deleteConfig = [[ZIMMessageDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerMessage =
        ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerMessage"]).boolValue;
    return deleteConfig;
}

+ (nullable NSDictionary *)mZIMMessageDeleteConfig:(nullable ZIMMessageDeleteConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithBool:config.isAlsoDeleteServerMessage]
                      forKey:@"isAlsoDeleteServerMessage"];
    return configDic;
}

+ (nullable ZIMMessageSearchConfig *)oZIMMessageSearchConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMMessageSearchConfig *config = [[ZIMMessageSearchConfig alloc] init];
    config.nextMessage = [ZIMPluginConverter oZIMMessage:[configDic objectForKey:@"nextMessage"]];
    config.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    config.order = (ZIMMessageOrder)[[configDic safeObjectForKey:@"order"] integerValue];
    config.keywords = [configDic safeObjectForKey:@"keywords"];
    config.messageTypes = [configDic safeObjectForKey:@"messageTypes"];
    config.subMessageTypes = [configDic safeObjectForKey:@"subMessageTypes"];
    config.senderUserIDs = [configDic safeObjectForKey:@"senderUserIDs"];
    config.startTime = [[configDic safeObjectForKey:@"startTime"] longLongValue];
    config.endTime = [[configDic safeObjectForKey:@"endTime"] longLongValue];

    return config;
}

+ (nullable ZIMConversationSearchConfig *)oZIMConversationMessageGlobalSearchConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMConversationSearchConfig *config = [[ZIMConversationSearchConfig alloc] init];
    config.nextFlag = [[configDic safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.totalConversationCount =
        [[configDic safeObjectForKey:@"totalConversationCount"] unsignedIntValue];
    config.conversationMessageCount =
        [[configDic safeObjectForKey:@"conversationMessageCount"] unsignedIntValue];
    config.keywords = [configDic safeObjectForKey:@"keywords"];
    config.messageTypes = [configDic safeObjectForKey:@"messageTypes"];
    config.subMessageTypes = [configDic safeObjectForKey:@"subMessageTypes"];
    config.senderUserIDs = [configDic safeObjectForKey:@"senderUserIDs"];
    config.startTime = [[configDic safeObjectForKey:@"startTime"] longLongValue];
    config.endTime = [[configDic safeObjectForKey:@"endTime"] longLongValue];

    return config;
}

+ (nullable NSDictionary *)mZIMConversationMessageSearchInfo:
    (nullable ZIMConversationSearchInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:info.conversationID forKey:@"conversationID"];
    [configDic safeSetObject:@(info.conversationType) forKey:@"conversationType"];
    [configDic safeSetObject:@(info.totalMessageCount) forKey:@"totalMessageCount"];
    [configDic safeSetObject:[ZIMPluginConverter mZIMMessageList:info.messageList]
                      forKey:@"messageList"];

    return configDic;
}

+ (nullable NSArray *)mZIMConversationMessageSearchInfoList:
    (nullable NSArray<ZIMConversationSearchInfo *> *)infoList {
    if (infoList == nil || infoList == NULL || [infoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMConversationSearchInfo *info in infoList) {
        [DicArr addObject:[ZIMPluginConverter mZIMConversationMessageSearchInfo:info]];
    }
    return DicArr;
}

+ (nullable ZIMConversationDeleteConfig *)oZIMConversationDeleteConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMConversationDeleteConfig *deleteConfig = [[ZIMConversationDeleteConfig alloc] init];
    deleteConfig.isAlsoDeleteServerConversation =
        ((NSNumber *)[configDic objectForKey:@"isAlsoDeleteServerConversation"]).boolValue;
    return deleteConfig;
}

+ (nullable ZIMMessageSendConfig *)oZIMMessageSendConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMMessageSendConfig *sendConfig = [[ZIMMessageSendConfig alloc] init];
    sendConfig.priority = [[configDic objectForKey:@"priority"] unsignedIntegerValue];
    sendConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic objectForKey:@"pushConfig"]];
    sendConfig.hasReceipt = [[configDic safeObjectForKey:@"hasReceipt"] boolValue];
    sendConfig.isNotifyMentionedUsers =
        [[configDic safeObjectForKey:@"isNotifyMentionedUsers"] boolValue];
    return sendConfig;
}

+ (nullable ZIMPushConfig *)oZIMPushConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMPushConfig *pushConfig = [[ZIMPushConfig alloc] init];
    pushConfig.title = (NSString *)[configDic objectForKey:@"title"];
    pushConfig.content = (NSString *)[configDic objectForKey:@"content"];
    pushConfig.payload = (NSString *)[configDic objectForKey:@"payload"];
    pushConfig.resourcesID = (NSString *)[configDic objectForKey:@"resourcesID"];
    pushConfig.enableBadge = [[configDic objectForKey:@"enableBadge"] boolValue];
    pushConfig.badgeIncrement = [[configDic objectForKey:@"badgeIncrement"] intValue];
    pushConfig.voIPConfig =
        [ZIMPluginConverter oZIMVoIPConfig:[configDic objectForKey:@"voIPConfig"]];
    return pushConfig;
}

+ (nullable ZIMVoIPConfig *)oZIMVoIPConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMVoIPConfig *voIPConfig = [[ZIMVoIPConfig alloc] init];
    voIPConfig.iOSVoIPHandleType = [[configDic safeObjectForKey:@"iOSVoIPHandleType"] integerValue];
    voIPConfig.iOSVoIPHandleValue = [configDic safeObjectForKey:@"iOSVoIPHandleValue"];
    voIPConfig.iOSVoIPHasVideo = [[configDic safeObjectForKey:@"iOSVoIPHasVideo"] boolValue];
    return voIPConfig;
}

+ (nullable ZIMMessageQueryConfig *)oZIMMessageQueryConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.nextMessage = [ZIMPluginConverter oZIMMessage:[configDic objectForKey:@"nextMessage"]];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).intValue;
    config.reverse = ((NSNumber *)[configDic objectForKey:@"reverse"]).boolValue;
    return config;
}

+ (nullable ZIMMessageRepliedListQueryConfig *)oZIMMessageRepliedListQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMMessageRepliedListQueryConfig *config = [[ZIMMessageRepliedListQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = ((NSNumber *)[configDic objectForKey:@"nextFlag"]).longLongValue;

    return config;
}

+ (nullable ZIMMessageRepliedInfo *)oZIMMessageRepliedInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMMessageRepliedInfo *info = [[ZIMMessageRepliedInfo alloc] init];
    info.state = (ZIMMessageRepliedInfoState)((NSNumber *)[infoDic objectForKey:@"state"]).intValue;
    info.senderUserID = (NSString *)[infoDic objectForKey:@"senderUserID"];
    info.sentTime = ((NSNumber *)[infoDic objectForKey:@"sentTime"]).longLongValue;
    info.messageID = ((NSNumber *)[infoDic objectForKey:@"messageID"]).longLongValue;
    info.messageSeq = ((NSNumber *)[infoDic objectForKey:@"messageSeq"]).longLongValue;
    info.messageInfo =
        [ZIMPluginConverter oZIMMessageLiteInfo:[infoDic objectForKey:@"messageInfo"]];

    return info;
}

+ (nullable NSDictionary *)mZIMMessageRepliedInfo:(nullable ZIMMessageRepliedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:@(info.state) forKey:@"state"];
    [infoDic safeSetObject:info.senderUserID forKey:@"senderUserID"];
    [infoDic safeSetObject:@(info.sentTime) forKey:@"sentTime"];
    [infoDic safeSetObject:@(info.messageID) forKey:@"messageID"];
    [infoDic safeSetObject:@(info.messageSeq) forKey:@"messageSeq"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMMessageLiteInfo:info.messageInfo]
                    forKey:@"messageInfo"];

    return infoDic;
}

+ (nullable ZIMMessageLiteInfo *)oZIMMessageLiteInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMMessageType type = (ZIMMessageType)((NSNumber *)[infoDic objectForKey:@"type"]).intValue;
    ZIMMessageLiteInfo *info;
    if (type == ZIMMessageTypeText) {
        info = [[ZIMTextMessageLiteInfo alloc] init];
        ZIMTextMessageLiteInfo *textLiteInfo = (ZIMTextMessageLiteInfo *)info;
        textLiteInfo.message = [infoDic objectForKey:@"message"];

    } else if (type == ZIMMessageTypeCustom) {
        info = [[ZIMCustomMessageLiteInfo alloc] init];
        ZIMCustomMessageLiteInfo *customLiteInfo = (ZIMCustomMessageLiteInfo *)info;
        customLiteInfo.message = [infoDic objectForKey:@"message"];
        customLiteInfo.subType = ((NSNumber *)[infoDic objectForKey:@"subType"]).unsignedIntValue;

    } else if (type == ZIMMessageTypeCombine) {
        info = [[ZIMCombineMessageLiteInfo alloc] init];
        ZIMCombineMessageLiteInfo *cbLiteInfo = (ZIMCombineMessageLiteInfo *)info;
        cbLiteInfo.title = [infoDic objectForKey:@"title"];
        cbLiteInfo.summary = [infoDic objectForKey:@"summary"];

    } else if (type == ZIMMessageTypeRevoke) {
        info = [[ZIMRevokeMessageLiteInfo alloc] init];

    } else if (type == ZIMMessageTypeImage) {
        info = [[ZIMImageMessageLiteInfo alloc] init];
        ZIMImageMessageLiteInfo *imageLiteInfo = (ZIMImageMessageLiteInfo *)info;
        imageLiteInfo.originalImageSize =
            CGSizeMake([[infoDic objectForKey:@"originalImageWidth"] doubleValue],
                       [[infoDic objectForKey:@"originalImageHeight"] doubleValue]);
        imageLiteInfo.largeImageDownloadUrl = [infoDic objectForKey:@"largeImageDownloadUrl"];
        imageLiteInfo.largeImageLocalPath = [infoDic objectForKey:@"largeImageLocalPath"];
        imageLiteInfo.largeImageSize =
            CGSizeMake([[infoDic objectForKey:@"largeImageWidth"] doubleValue],
                       [[infoDic objectForKey:@"largeImageHeight"] doubleValue]);
        imageLiteInfo.thumbnailDownloadUrl = [infoDic objectForKey:@"thumbnailDownloadUrl"];
        imageLiteInfo.thumbnailLocalPath = [infoDic objectForKey:@"thumbnailLocalPath"];
        imageLiteInfo.thumbnailSize =
            CGSizeMake([[infoDic objectForKey:@"thumbnailWidth"] doubleValue],
                       [[infoDic objectForKey:@"thumbnailHeight"] doubleValue]);

    } else if (type == ZIMMessageTypeFile) {
        info = [[ZIMFileMessageLiteInfo alloc] init];

    } else if (type == ZIMMessageTypeAudio) {
        info = [[ZIMAudioMessageLiteInfo alloc] init];
        ZIMAudioMessageLiteInfo *audioLiteInfo = (ZIMAudioMessageLiteInfo *)info;
        audioLiteInfo.audioDuration = [[infoDic objectForKey:@"audioDuration"] unsignedIntValue];

    } else if (type == ZIMMessageTypeVideo) {
        info = [[ZIMVideoMessageLiteInfo alloc] init];
        ZIMVideoMessageLiteInfo *videoLiteInfo = (ZIMVideoMessageLiteInfo *)info;
        videoLiteInfo.videoDuration = [[infoDic objectForKey:@"videoDuration"] unsignedIntValue];
        videoLiteInfo.videoFirstFrameDownloadUrl =
            [infoDic objectForKey:@"videoFirstFrameDownloadUrl"];
        videoLiteInfo.videoFirstFrameLocalPath = [infoDic objectForKey:@"videoFirstFrameLocalPath"];
        videoLiteInfo.videoFirstFrameSize =
            CGSizeMake([[infoDic objectForKey:@"videoFirstFrameWidth"] doubleValue],
                       [[infoDic objectForKey:@"videoFirstFrameHeight"] doubleValue]);

    } else {
        info = [[ZIMMessageLiteInfo alloc] init];
    }

    if ([info isKindOfClass:[ZIMMediaMessage class]]) {
        ZIMMediaMessageLiteInfo *mediaLiteInfo = (ZIMMediaMessageLiteInfo *)info;
        mediaLiteInfo.fileName = [infoDic objectForKey:@"fileName"];
        mediaLiteInfo.fileDownloadUrl = [infoDic objectForKey:@"fileDownloadUrl"];
        mediaLiteInfo.fileLocalPath = [infoDic objectForKey:@"fileLocalPath"];
        mediaLiteInfo.fileSize = [[infoDic objectForKey:@"fileSize"] longLongValue];
    }

    return info;
}

+ (nullable NSDictionary *)mZIMMessageLiteInfo:(nullable ZIMMessageLiteInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:@(info.type) forKey:@"type"];
    if (info.type == ZIMMessageTypeText) {
        ZIMTextMessageLiteInfo *textLiteInfo = (ZIMTextMessageLiteInfo *)info;
        [infoDic safeSetObject:textLiteInfo.message forKey:@"message"];

    } else if (info.type == ZIMMessageTypeCustom) {
        ZIMCustomMessageLiteInfo *customLiteInfo = (ZIMCustomMessageLiteInfo *)info;
        [infoDic safeSetObject:customLiteInfo.message forKey:@"message"];
        [infoDic safeSetObject:@(customLiteInfo.subType) forKey:@"subType"];

    } else if (info.type == ZIMMessageTypeCombine) {
        ZIMCombineMessageLiteInfo *cbLiteInfo = (ZIMCombineMessageLiteInfo *)info;
        [infoDic safeSetObject:cbLiteInfo.title forKey:@"title"];
        [infoDic safeSetObject:cbLiteInfo.summary forKey:@"summary"];

    } else if (info.type == ZIMMessageTypeImage) {
        ZIMImageMessageLiteInfo *imageLiteInfo = (ZIMImageMessageLiteInfo *)info;
        [infoDic safeSetObject:imageLiteInfo.fileName forKey:@"fileName"];
        [infoDic safeSetObject:imageLiteInfo.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [infoDic safeSetObject:imageLiteInfo.fileLocalPath forKey:@"fileLocalPath"];
        [infoDic safeSetObject:@(imageLiteInfo.fileSize) forKey:@"fileSize"];

        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.originalImageSize.width]
                        forKey:@"originalImageWidth"];
        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.originalImageSize.height]
                        forKey:@"originalImageHeight"];

        [infoDic safeSetObject:imageLiteInfo.largeImageDownloadUrl forKey:@"largeImageDownloadUrl"];
        [infoDic safeSetObject:imageLiteInfo.largeImageLocalPath forKey:@"largeImageLocalPath"];
        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.largeImageSize.width]
                        forKey:@"largeImageWidth"];
        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.largeImageSize.height]
                        forKey:@"largeImageHeight"];

        [infoDic safeSetObject:imageLiteInfo.thumbnailDownloadUrl forKey:@"thumbnailDownloadUrl"];
        [infoDic safeSetObject:imageLiteInfo.thumbnailLocalPath forKey:@"thumbnailLocalPath"];
        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.thumbnailSize.width]
                        forKey:@"thumbnailWidth"];
        [infoDic safeSetObject:[NSNumber numberWithInt:imageLiteInfo.thumbnailSize.height]
                        forKey:@"thumbnailHeight"];

    } else if (info.type == ZIMMessageTypeFile) {
        ZIMFileMessageLiteInfo *fileLiteInfo = (ZIMFileMessageLiteInfo *)info;
        [infoDic safeSetObject:fileLiteInfo.fileName forKey:@"fileName"];
        [infoDic safeSetObject:fileLiteInfo.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [infoDic safeSetObject:fileLiteInfo.fileLocalPath forKey:@"fileLocalPath"];
        [infoDic safeSetObject:@(fileLiteInfo.fileSize) forKey:@"fileSize"];

    } else if (info.type == ZIMMessageTypeAudio) {
        ZIMAudioMessageLiteInfo *audioLiteInfo = (ZIMAudioMessageLiteInfo *)info;
        [infoDic safeSetObject:audioLiteInfo.fileName forKey:@"fileName"];
        [infoDic safeSetObject:audioLiteInfo.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [infoDic safeSetObject:audioLiteInfo.fileLocalPath forKey:@"fileLocalPath"];
        [infoDic safeSetObject:@(audioLiteInfo.fileSize) forKey:@"fileSize"];

        [infoDic safeSetObject:@(audioLiteInfo.audioDuration) forKey:@"audioDuration"];

    } else if (info.type == ZIMMessageTypeVideo) {
        ZIMVideoMessageLiteInfo *videoLiteInfo = (ZIMVideoMessageLiteInfo *)info;
        [infoDic safeSetObject:videoLiteInfo.fileName forKey:@"fileName"];
        [infoDic safeSetObject:videoLiteInfo.fileDownloadUrl forKey:@"fileDownloadUrl"];
        [infoDic safeSetObject:videoLiteInfo.fileLocalPath forKey:@"fileLocalPath"];
        [infoDic safeSetObject:@(videoLiteInfo.fileSize) forKey:@"fileSize"];

        [infoDic safeSetObject:@(videoLiteInfo.videoDuration) forKey:@"videoDuration"];
        [infoDic safeSetObject:videoLiteInfo.videoFirstFrameDownloadUrl
                        forKey:@"videoFirstFrameDownloadUrl"];
        [infoDic safeSetObject:videoLiteInfo.videoFirstFrameLocalPath
                        forKey:@"videoFirstFrameLocalPath"];
        [infoDic safeSetObject:[NSNumber numberWithInt:videoLiteInfo.videoFirstFrameSize.width]
                        forKey:@"videoFirstFrameWidth"];
        [infoDic safeSetObject:[NSNumber numberWithInt:videoLiteInfo.videoFirstFrameSize.height]
                        forKey:@"videoFirstFrameHeight"];
    }

    return infoDic;
}

+ (nullable NSDictionary *)mZIMMessageRootRepliedInfo:(nullable ZIMMessageRootRepliedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:@((int)info.state) forKey:@"state"];
    [infoDic safeSetObject:info.senderUserID forKey:@"senderUserID"];
    [infoDic safeSetObject:@(info.sentTime) forKey:@"sentTime"];
    [infoDic safeSetObject:@(info.repliedCount) forKey:@"repliedCount"];
    if (info.message) {
        [infoDic safeSetObject:[ZIMPluginConverter mZIMMessage:info.message] forKey:@"message"];
    }

    return infoDic;
}

+ (nullable NSDictionary *)mZIMMessageRootRepliedCountInfo:
    (nullable ZIMMessageRootRepliedCountInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.conversationID forKey:@"conversationID"];
    [infoDic safeSetObject:@(info.conversationType) forKey:@"conversationType"];
    [infoDic safeSetObject:@(info.count) forKey:@"count"];
    [infoDic safeSetObject:@(info.messageID) forKey:@"messageID"];

    return infoDic;
}

+ (nullable NSArray *)mZIMMessageRootRepliedCountInfoList:
    (nullable NSArray<ZIMMessageRootRepliedCountInfo *> *)infoList {
    if (infoList == nil || infoList == NULL || [infoList isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableArray *DicArr = [[NSMutableArray alloc] init];
    for (ZIMMessageRootRepliedCountInfo *info in infoList) {
        [DicArr addObject:[ZIMPluginConverter mZIMMessageRootRepliedCountInfo:info]];
    }

    return DicArr;
}

+ (nullable ZIMRoomInfo *)oZIMRoomInfo:(nullable NSDictionary *)roomInfoDic {
    if (roomInfoDic == nil || roomInfoDic == NULL || [roomInfoDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomInfo *roomInfo = [[ZIMRoomInfo alloc] init];
    roomInfo.roomID = [roomInfoDic objectForKey:@"roomID"];
    roomInfo.roomName = [roomInfoDic objectForKey:@"roomName"];
    return roomInfo;
}

+ (nullable NSDictionary *)mZIMRoomInfo:(nullable ZIMRoomInfo *)roomInfo {
    if (roomInfo == nil || roomInfo == NULL || [roomInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *roomInfoDic = [[NSMutableDictionary alloc] init];
    [roomInfoDic safeSetObject:roomInfo.roomID forKey:@"roomID"];
    [roomInfoDic safeSetObject:roomInfo.roomName forKey:@"roomName"];
    return roomInfoDic;
}

+ (nullable NSDictionary *)mZIMRoomFullInfo:(nullable ZIMRoomFullInfo *)roomFullInfo {
    if (roomFullInfo == nil || roomFullInfo == NULL || [roomFullInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *roomFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *baseInfoDic = [ZIMPluginConverter mZIMRoomInfo:roomFullInfo.baseInfo];
    [roomFullInfoDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return roomFullInfoDic;
}

+ (nullable ZIMRoomAdvancedConfig *)oZIMRoomAdvancedConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomAdvancedConfig *config = [[ZIMRoomAdvancedConfig alloc] init];
    config.roomAttributes = [configDic safeObjectForKey:@"roomAttributes"];
    config.roomDestroyDelayTime =
        ((NSNumber *)[configDic objectForKey:@"roomDestroyDelayTime"]).unsignedIntValue;
    return config;
}

+ (nullable ZIMRoomMemberQueryConfig *)oZIMRoomMemberQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomMemberQueryConfig *config = [[ZIMRoomMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = (NSString *)[configDic objectForKey:@"nextFlag"];
    return config;
}

+ (nullable ZIMRoomAttributesSetConfig *)oZIMRoomAttributesSetConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomAttributesSetConfig *config = [[ZIMRoomAttributesSetConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft =
        ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;
    return config;
}

+ (nullable ZIMRoomAttributesDeleteConfig *)oZIMRoomAttributesDeleteConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomAttributesDeleteConfig *config = [[ZIMRoomAttributesDeleteConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    return config;
}

+ (nullable ZIMRoomAttributesBatchOperationConfig *)oZIMRoomAttributesBatchOperationConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomAttributesBatchOperationConfig *config =
        [[ZIMRoomAttributesBatchOperationConfig alloc] init];
    config.isForce = ((NSNumber *)[configDic objectForKey:@"isForce"]).boolValue;
    config.isDeleteAfterOwnerLeft =
        ((NSNumber *)[configDic objectForKey:@"isDeleteAfterOwnerLeft"]).boolValue;
    config.isUpdateOwner = ((NSNumber *)[configDic objectForKey:@"isUpdateOwner"]).boolValue;

    return config;
}

+ (nullable NSDictionary *)mZIMRoomAttributesUpdateInfo:
    (nullable ZIMRoomAttributesUpdateInfo *)updateInfo {
    if (updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *basicUpdateInfo = [[NSMutableDictionary alloc] init];
    [basicUpdateInfo safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action]
                            forKey:@"action"];
    [basicUpdateInfo safeSetObject:updateInfo.roomAttributes forKey:@"roomAttributes"];
    return basicUpdateInfo;
}

+ (nullable NSArray *)mZIMRoomAttributesUpdateInfoList:
    (nullable NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList {
    if (updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicUpadteInfoList = [[NSMutableArray alloc] init];
    for (ZIMRoomAttributesUpdateInfo *updateInfo in updateInfoList) {
        NSDictionary *updateInfoDic = [ZIMPluginConverter mZIMRoomAttributesUpdateInfo:updateInfo];
        [basicUpadteInfoList safeAddObject:updateInfoDic];
    }
    return basicUpadteInfoList;
}

+ (nullable ZIMGroupInfo *)oZIMGroupInfo:(nullable NSDictionary *)groupInfoDic {
    if (groupInfoDic == nil || groupInfoDic == NULL || [groupInfoDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupInfo *info = [[ZIMGroupInfo alloc] init];
    info.groupID = [groupInfoDic objectForKey:@"groupID"];
    info.groupName = [groupInfoDic objectForKey:@"groupName"];
    info.groupAvatarUrl = [groupInfoDic objectForKey:@"groupAvatarUrl"];
    return info;
}

+ (nullable NSDictionary *)mZIMGroupInfo:(nullable ZIMGroupInfo *)groupInfo {
    if (groupInfo == nil || groupInfo == NULL || [groupInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *groupInfoDic = [[NSMutableDictionary alloc] init];
    [groupInfoDic safeSetObject:groupInfo.groupID forKey:@"groupID"];
    [groupInfoDic safeSetObject:groupInfo.groupName forKey:@"groupName"];
    [groupInfoDic safeSetObject:groupInfo.groupAvatarUrl forKey:@"groupAvatarUrl"];
    return groupInfoDic;
}

+ (nullable NSDictionary *)mZIMGroupVerifyInfo:(nullable ZIMGroupVerifyInfo *)verifyInfo {
    if (verifyInfo == nil || verifyInfo == NULL || [verifyInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *verifyInfoDic = [[NSMutableDictionary alloc] init];
    [verifyInfoDic safeSetObject:@(verifyInfo.joinMode) forKey:@"joinMode"];
    [verifyInfoDic safeSetObject:@(verifyInfo.inviteMode) forKey:@"inviteMode"];
    [verifyInfoDic safeSetObject:@(verifyInfo.beInviteMode) forKey:@"beInviteMode"];
    return verifyInfoDic;
}

+ (nullable NSDictionary *)mZIMGroupMuteInfo:(nullable ZIMGroupMuteInfo *)muteInfo {
    if (muteInfo == nil || muteInfo == NULL || [muteInfo isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *muteInfoMap = [[NSMutableDictionary alloc] init];
    [muteInfoMap safeSetObject:[NSNumber numberWithInt:(int)muteInfo.mode] forKey:@"mode"];
    [muteInfoMap safeSetObject:[NSNumber numberWithLongLong:muteInfo.expiredTime]
                        forKey:@"expiredTime"];
    [muteInfoMap safeSetObject:muteInfo.roles forKey:@"roles"];

    return muteInfoMap;
}

+ (nullable ZIMGroupMuteInfo *)oZIMGroupMuteInfo:(nullable NSDictionary *)muteInfoDic {
    if (muteInfoDic == nil || muteInfoDic == NULL || [muteInfoDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMGroupMuteInfo *muteInfo = [[ZIMGroupMuteInfo alloc] init];

    muteInfo.mode = ((NSNumber *)[muteInfoDic objectForKey:@"mode"]).intValue;
    muteInfo.expiredTime = [muteInfoDic[@"expiredTime"] longValue];
    NSMutableArray *roles = [[NSMutableArray alloc] init];
    for (NSNumber *role in muteInfoDic[@"roles"]) {
        [roles addObject:role];
    }
    muteInfo.roles = roles;

    return muteInfo;
}

+ (nullable NSDictionary *)mZIMGroupEnterInfo:(nullable ZIMGroupEnterInfo *)enterInfo {
    if (enterInfo == nil || enterInfo == NULL || [enterInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *enterInfoMap = [[NSMutableDictionary alloc] init];
    [enterInfoMap safeSetObject:[NSNumber numberWithLongLong:enterInfo.enterTime]
                         forKey:@"enterTime"];
    [enterInfoMap safeSetObject:[NSNumber numberWithInt:(int)enterInfo.enterType]
                         forKey:@"enterType"];
    [enterInfoMap
        safeSetObject:[ZIMPluginConverter mZIMGroupMemberSimpleInfo:enterInfo.operatedUser]
               forKey:@"operatedUser"];
    return enterInfoMap;
}

+ (nullable NSDictionary *)mZIMGroupMemberInfo:(nullable ZIMGroupMemberInfo *)memberInfo {
    if (memberInfo == nil || memberInfo == NULL || [memberInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *memberInfoDic =
        (NSMutableDictionary *)[ZIMPluginConverter mZIMUserInfo:memberInfo];
    [memberInfoDic safeSetObject:memberInfo.memberNickname forKey:@"memberNickname"];
    [memberInfoDic safeSetObject:[NSNumber numberWithInt:memberInfo.memberRole]
                          forKey:@"memberRole"];
    [memberInfoDic safeSetObject:memberInfo.userID forKey:@"userID"];
    [memberInfoDic safeSetObject:memberInfo.userName forKey:@"userName"];
    [memberInfoDic safeSetObject:memberInfo.memberAvatarUrl ? memberInfo.memberAvatarUrl : @""
                          forKey:@"memberAvatarUrl"];
    [memberInfoDic safeSetObject:memberInfo.userAvatarUrl ? memberInfo.userAvatarUrl : @""
                          forKey:@"userAvatarUrl"];
    [memberInfoDic safeSetObject:[NSNumber numberWithLongLong:memberInfo.muteExpiredTime]
                          forKey:@"muteExpiredTime"];
    [memberInfoDic
        safeSetObject:memberInfo.groupEnterInfo
                          ? [ZIMPluginConverter mZIMGroupEnterInfo:memberInfo.groupEnterInfo]
                          : [NSNull null]
               forKey:@"groupEnterInfo"];
    return memberInfoDic;
}

+ (nullable NSArray *)mZIMGroupMemberInfoList:
    (nullable NSArray<ZIMGroupMemberInfo *> *)memberInfoList {
    if (memberInfoList == nil || memberInfoList == NULL || [memberInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupMemberInfo *info in memberInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMGroupMemberInfo:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+ (nullable ZIMGroupSearchConfig *)oZIMGroupSearchConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMGroupSearchConfig *config = [[ZIMGroupSearchConfig alloc] init];
    config.nextFlag = [[configDic safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    config.keywords = [configDic safeObjectForKey:@"keywords"];
    config.isAlsoMatchGroupMemberUserName =
        [[configDic safeObjectForKey:@"isAlsoMatchGroupMemberUserName"] boolValue];
    config.isAlsoMatchGroupMemberNickname =
        [[configDic safeObjectForKey:@"isAlsoMatchGroupMemberNickname"] boolValue];

    return config;
}

+ (nullable ZIMGroupMemberSearchConfig *)oZIMGroupMemberSearchConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }

    ZIMGroupMemberSearchConfig *config = [[ZIMGroupMemberSearchConfig alloc] init];
    config.nextFlag = [[configDic safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    config.keywords = [configDic safeObjectForKey:@"keywords"];
    config.isAlsoMatchGroupMemberNickname =
        [[configDic safeObjectForKey:@"isAlsoMatchGroupMemberNickname"] boolValue];

    return config;
}

+ (nullable NSDictionary *)mZIMGroupSearchInfo:(nullable ZIMGroupSearchInfo *)groupSearchInfo {
    if (groupSearchInfo == nil || groupSearchInfo == NULL ||
        [groupSearchInfo isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableDictionary *searchInfoDic = [[NSMutableDictionary alloc] init];
    [searchInfoDic safeSetObject:[ZIMPluginConverter mZIMGroupInfo:groupSearchInfo.groupInfo]
                          forKey:@"groupInfo"];
    [searchInfoDic
        safeSetObject:[ZIMPluginConverter mZIMGroupMemberInfoList:groupSearchInfo.userList]
               forKey:@"userList"];

    return searchInfoDic;
}

+ (nullable NSArray *)mZIMGroupSearchInfoList:
    (nullable NSArray<ZIMGroupSearchInfo *> *)groupSearchInfoList {
    if (groupSearchInfoList == nil || groupSearchInfoList == NULL ||
        [groupSearchInfoList isEqual:[NSNull null]]) {
        return nil;
    }

    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupSearchInfo *searchInfo in groupSearchInfoList) {
        NSDictionary *searchInfoDic = [ZIMPluginConverter mZIMGroupSearchInfo:searchInfo];
        [basicList safeAddObject:searchInfoDic];
    }

    return basicList;
}

+ (nullable NSDictionary *)mZIMErrorUserInfo:(nullable ZIMErrorUserInfo *)errorUserInfo {
    if (errorUserInfo == nil || errorUserInfo == NULL || [errorUserInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
    [errorUserInfoDic safeSetObject:errorUserInfo.userID forKey:@"userID"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:errorUserInfo.reason]
                             forKey:@"reason"];
    return errorUserInfoDic;
}

+ (nullable NSArray *)mZIMErrorUserInfoList:
    (nullable NSArray<ZIMErrorUserInfo *> *)errorUserInfoList {
    if (errorUserInfoList == nil || errorUserInfoList == NULL ||
        [errorUserInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMErrorUserInfo *errorUserInfo in errorUserInfoList) {
        NSDictionary *errorUserInfoDic = [ZIMPluginConverter mZIMErrorUserInfo:errorUserInfo];
        [basicList safeAddObject:errorUserInfoDic];
    }
    return basicList;
}

+ (nullable NSDictionary *)mZIMGroupApplicationInfo:
    (nullable ZIMGroupApplicationInfo *)groupApplicationInfo {
    if (groupApplicationInfo == nil || groupApplicationInfo == NULL ||
        [groupApplicationInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *errorUserInfoDic = [[NSMutableDictionary alloc] init];
    [errorUserInfoDic
        safeSetObject:[NSNumber numberWithUnsignedLongLong:groupApplicationInfo.updateTime]
               forKey:@"updateTime"];
    [errorUserInfoDic safeSetObject:groupApplicationInfo.wording forKey:@"wording"];
    [errorUserInfoDic
        safeSetObject:[ZIMPluginConverter mZIMGroupInfo:groupApplicationInfo.groupInfo]
               forKey:@"groupInfo"];
    [errorUserInfoDic safeSetObject:[ZIMPluginConverter mZIMUserInfo:groupApplicationInfo.applyUser]
                             forKey:@"applyUser"];
    if (groupApplicationInfo.operatedUser != nil && groupApplicationInfo.operatedUser != NULL) {
        [errorUserInfoDic
            safeSetObject:[ZIMPluginConverter
                              mZIMGroupMemberSimpleInfo:groupApplicationInfo.operatedUser]
                   forKey:@"operatedUser"];
    }
    [errorUserInfoDic
        safeSetObject:[NSNumber numberWithUnsignedLongLong:groupApplicationInfo.createTime]
               forKey:@"createTime"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:(int)groupApplicationInfo.type]
                             forKey:@"type"];
    [errorUserInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:(int)groupApplicationInfo.state]
                             forKey:@"state"];
    return errorUserInfoDic;
}

+ (nullable NSArray *)mZIMGroupApplicationInfoList:
    (nullable NSArray<ZIMGroupApplicationInfo *> *)groupApplicationInfoList {
    if (groupApplicationInfoList == nil || groupApplicationInfoList == NULL ||
        [groupApplicationInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupApplicationInfo *applicationInfo in groupApplicationInfoList) {
        NSDictionary *applicationInfoDic =
            [ZIMPluginConverter mZIMGroupApplicationInfo:applicationInfo];
        [basicList safeAddObject:applicationInfoDic];
    }
    return basicList;
}

+ (nullable NSDictionary *)mZIMGroupFullInfo:(nullable ZIMGroupFullInfo *)groupFullInfo {
    if (groupFullInfo == nil || groupFullInfo == NULL || [groupFullInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *groupFullInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupInfo:groupFullInfo.baseInfo];
    NSDictionary *groupMuteInfoDic = [ZIMPluginConverter mZIMGroupMuteInfo:groupFullInfo.mutedInfo];
    [groupFullInfoDic safeSetObject:groupInfoDic forKey:@"baseInfo"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupNotice forKey:@"groupNotice"];
    [groupFullInfoDic safeSetObject:groupFullInfo.groupAttributes forKey:@"groupAttributes"];
    [groupFullInfoDic safeSetObject:@(groupFullInfo.notificationStatus)
                             forKey:@"notificationStatus"];
    [groupFullInfoDic safeSetObject:groupMuteInfoDic forKey:@"mutedInfo"];
    [groupFullInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:groupFullInfo.maxMemberCount]
                             forKey:@"maxMemberCount"];
    [groupFullInfoDic safeSetObject:[NSNumber numberWithLongLong:groupFullInfo.createTime]
                             forKey:@"createTime"];
    [groupFullInfoDic
        safeSetObject:[ZIMPluginConverter mZIMGroupVerifyInfo:groupFullInfo.verifyInfo]
               forKey:@"verifyInfo"];
    return groupFullInfoDic;
}

+ (nullable NSDictionary *)mZIMGroupAdvancedConfig:(nullable ZIMGroupAdvancedConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:config.groupNotice forKey:@"groupNotice"];
    [configDic safeSetObject:config.groupAttributes forKey:@"groupAttributes"];
    return configDic;
}

+ (nullable ZIMGroupAdvancedConfig *)oZIMGroupAdvancedConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupAdvancedConfig *config = [[ZIMGroupAdvancedConfig alloc] init];
    config.groupAttributes = [configDic safeObjectForKey:@"groupAttributes"];
    config.groupNotice = [configDic safeObjectForKey:@"groupNotice"];
    config.maxMemberCount = ((NSNumber *)[configDic objectForKey:@"maxMemberCount"]).intValue;
    config.joinMode = ((NSNumber *)[configDic objectForKey:@"joinMode"]).unsignedIntValue;
    config.inviteMode = ((NSNumber *)[configDic objectForKey:@"inviteMode"]).unsignedIntValue;
    config.beInviteMode = ((NSNumber *)[configDic objectForKey:@"beInviteMode"]).unsignedIntValue;
    return config;
}

+ (nullable NSDictionary *)mZIMGroupMuteConfig:(nullable ZIMGroupMuteConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithInt:(int)config.mode] forKey:@"mode"];
    [configDic safeSetObject:[NSNumber numberWithInt:config.duration] forKey:@"duration"];
    [configDic safeSetObject:config.roles forKey:@"roles"];
    return configDic;
}

+ (nullable ZIMGroupMuteConfig *)oZIMGroupMuteConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupMuteConfig *config = [[ZIMGroupMuteConfig alloc] init];
    config.mode = ((NSNumber *)[configDic objectForKey:@"mode"]).intValue;
    config.duration = ((NSNumber *)[configDic objectForKey:@"duration"]).intValue;
    config.roles = [configDic safeObjectForKey:@"roles"];
    return config;
}

+ (nullable NSDictionary *)mZIMGroupMemberMuteConfig:(nullable ZIMGroupMemberMuteConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithInt:config.duration] forKey:@"duration"];
    return configDic;
}

+ (nullable ZIMGroupMemberMuteConfig *)oZIMGroupMemberMuteConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupMemberMuteConfig *config = [[ZIMGroupMemberMuteConfig alloc] init];
    config.duration = ((NSNumber *)[configDic objectForKey:@"duration"]).intValue;
    return config;
}

+ (nullable NSDictionary *)mZIMGroupMemberMutedListQueryConfig:
    (nullable ZIMGroupMemberMutedListQueryConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithUnsignedLongLong:config.nextFlag]
                      forKey:@"nextFlag"];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.count] forKey:@"count"];
    return configDic;
}

+ (nullable ZIMGroupMemberMutedListQueryConfig *)oZIMGroupMemberMutedListQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupMemberMutedListQueryConfig *config = [[ZIMGroupMemberMutedListQueryConfig alloc] init];
    config.nextFlag = ((NSNumber *)[configDic safeObjectForKey:@"nextFlag"]).unsignedLongLongValue;
    config.count = ((NSNumber *)[configDic safeObjectForKey:@"count"]).unsignedIntValue;
    return config;
}

+ (nullable NSDictionary *)mZIMGroup:(nullable ZIMGroup *)group {
    if (group == nil || group == NULL || [group isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *groupDic = [[NSMutableDictionary alloc] init];
    [groupDic safeSetObject:[NSNumber numberWithInt:(int)group.notificationStatus]
                     forKey:@"notificationStatus"];
    NSDictionary *baseInfoDic = [ZIMPluginConverter mZIMGroupInfo:group.baseInfo];
    [groupDic safeSetObject:baseInfoDic forKey:@"baseInfo"];
    return groupDic;
}

+ (nullable NSArray *)mZIMGroupList:(nullable NSArray<ZIMGroup *> *)groupList {
    if (groupList == nil || groupList == NULL || [groupList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicGroupList = [[NSMutableArray alloc] init];
    for (ZIMGroup *group in groupList) {
        NSDictionary *groupDic = [ZIMPluginConverter mZIMGroup:group];
        [basicGroupList safeAddObject:groupDic];
    }
    return basicGroupList;
}

+ (nullable NSDictionary *)mZIMGroupMemberQueryConfig:(nullable ZIMGroupMemberQueryConfig *)config {
    if (config == nil || config == NULL || [config isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.count] forKey:@"count"];
    [configDic safeSetObject:[NSNumber numberWithUnsignedInt:config.nextFlag] forKey:@"nextFlag"];
    return configDic;
}

+ (nullable ZIMGroupMemberQueryConfig *)oZIMGroupMemberQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupMemberQueryConfig *config = [[ZIMGroupMemberQueryConfig alloc] init];
    config.count = ((NSNumber *)[configDic safeObjectForKey:@"count"]).unsignedIntValue;
    config.nextFlag = ((NSNumber *)[configDic safeObjectForKey:@"nextFlag"]).unsignedIntValue;
    return config;
}

//+(nullable NSDictionary *)cnv

+ (nullable NSDictionary *)mZIMGroupOperatedInfo:(nullable ZIMGroupOperatedInfo *)operatedInfo {
    if (operatedInfo == nil || operatedInfo == NULL || [operatedInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *operatedInfoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *operatedUserInfoDic =
        [ZIMPluginConverter mZIMGroupMemberInfo:operatedInfo.operatedUserInfo];
    [operatedInfoDic safeSetObject:operatedUserInfoDic forKey:@"operatedUserInfo"];
    [operatedInfoDic safeSetObject:operatedInfo.userID forKey:@"userID"];
    [operatedInfoDic safeSetObject:operatedInfo.userName forKey:@"userName"];
    [operatedInfoDic safeSetObject:operatedInfo.memberNickname forKey:@"memberNickname"];
    [operatedInfoDic safeSetObject:@(operatedInfo.memberRole) forKey:@"memberRole"];
    return operatedInfoDic;
}

+ (nullable NSDictionary *)mZIMGroupAttributesUpdateInfo:
    (nullable ZIMGroupAttributesUpdateInfo *)updateInfo {
    if (updateInfo == nil || updateInfo == NULL || [updateInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *updateInfoDic = [[NSMutableDictionary alloc] init];
    [updateInfoDic safeSetObject:[NSNumber numberWithInt:(int)updateInfo.action] forKey:@"action"];
    [updateInfoDic safeSetObject:updateInfo.groupAttributes forKey:@"groupAttributes"];
    return updateInfoDic;
}

+ (nullable NSArray *)mZIMGroupAttributesUpdateInfoList:
    (nullable NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfoList {
    if (updateInfoList == nil || updateInfoList == NULL || [updateInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMGroupAttributesUpdateInfo *info in updateInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMGroupAttributesUpdateInfo:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+ (nullable NSDictionary *)mZIMCallUserInfo:(ZIMCallUserInfo *)callUserInfo {
    if (callUserInfo == nil || callUserInfo == NULL || [callUserInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *callUserInfoDic = [[NSMutableDictionary alloc] init];
    [callUserInfoDic safeSetObject:callUserInfo.userID forKey:@"userID"];
    [callUserInfoDic safeSetObject:[NSNumber numberWithInt:(int)callUserInfo.state]
                            forKey:@"state"];
    [callUserInfoDic safeSetObject:callUserInfo.extendedData forKey:@"extendedData"];
    return callUserInfoDic;
}

+ (nullable NSArray *)mZIMCallUserInfoList:(nullable NSArray<ZIMCallUserInfo *> *)callUserInfoList {
    if (callUserInfoList == nil || callUserInfoList == NULL ||
        [callUserInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMCallUserInfo *userInfo in callUserInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMCallUserInfo:userInfo];
        [basicList safeAddObject:userInfoDic];
    }
    return basicList;
}

+ (nullable ZIMCallInviteConfig *)oZIMCallInviteConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallInviteConfig *config = [[ZIMCallInviteConfig alloc] init];
    config.timeout = ((NSNumber *)[configDic safeObjectForKey:@"timeout"]).unsignedIntValue;
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    config.mode = ((NSNumber *)[configDic objectForKey:@"mode"]).intValue;
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];
    config.enableNotReceivedCheck = [[configDic objectForKey:@"enableNotReceivedCheck"] boolValue];
    return config;
}

+ (nullable ZIMCallingInviteConfig *)oZIMCallingInviteConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallingInviteConfig *config = [[ZIMCallingInviteConfig alloc] init];

    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];

    return config;
}

+ (nullable ZIMCallQuitConfig *)oZIMCallQuitConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallQuitConfig *config = [[ZIMCallQuitConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];
    return config;
}

+ (nullable ZIMCallEndConfig *)oZIMCallEndConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallEndConfig *config = [[ZIMCallEndConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];
    return config;
}

+ (nullable ZIMCallInvitationQueryConfig *)oZIMQueryCallListConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallInvitationQueryConfig *queryConfig = [[ZIMCallInvitationQueryConfig alloc] init];
    queryConfig.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    queryConfig.nextFlag = [[configDic safeObjectForKey:@"nextFlag"] longLongValue];
    return queryConfig;
}

+ (nullable NSDictionary *)mZIMCallInvitationSentInfo:(nullable ZIMCallInvitationSentInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:info.errorInvitees]
                    forKey:@"errorInvitees"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMErrorUserInfoList:info.errorUserList]
                    forKey:@"errorList"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallingInvitationSentInfo:
    (nullable ZIMCallingInvitationSentInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMErrorUserInfoList:info.errorUserList]
                    forKey:@"errorInvitees"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallQuitSentInfo:(nullable ZIMCallQuitSentInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.acceptTime] forKey:@"acceptTime"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.quitTime] forKey:@"quitTime"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallEndSentInfo:(nullable ZIMCallEndedSentInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.endTime] forKey:@"endTime"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.acceptTime] forKey:@"acceptTime"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallInvitationCreatedInfo:
    (nullable ZIMCallInvitationCreatedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithInt:(int)info.mode] forKey:@"mode"];
    [infoDic safeSetObject:info.caller forKey:@"caller"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:info.callUserList]
                    forKey:@"callUserList"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallInfo:(ZIMCallInfo *)callInfo {
    if (callInfo == nil || callInfo == NULL || [callInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *callInfoDic = [[NSMutableDictionary alloc] init];
    [callInfoDic safeSetObject:callInfo.callID forKey:@"callID"];
    [callInfoDic safeSetObject:callInfo.caller forKey:@"caller"];
    [callInfoDic safeSetObject:[NSNumber numberWithLongLong:callInfo.createTime]
                        forKey:@"createTime"];
    [callInfoDic safeSetObject:[NSNumber numberWithLongLong:callInfo.endTime] forKey:@"endTime"];
    [callInfoDic safeSetObject:[NSNumber numberWithInt:(int)callInfo.state] forKey:@"state"];
    [callInfoDic safeSetObject:[NSNumber numberWithInt:(int)callInfo.mode] forKey:@"mode"];
    [callInfoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:callInfo.callUserList]
                        forKey:@"callUserList"];
    [callInfoDic safeSetObject:callInfo.extendedData forKey:@"extendedData"];
    return callInfoDic;
}

+ (nullable NSArray *)mZIMCallInfoList:(nullable NSArray<ZIMCallInfo *> *)callInfoList {
    if (callInfoList == nil || callInfoList == NULL || [callInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMCallInfo *info in callInfoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMCallInfo:info];
        [basicList safeAddObject:infoDic];
    }
    return basicList;
}

+ (nullable ZIMCallCancelConfig *)oZIMCallCancelConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallCancelConfig *config = [[ZIMCallCancelConfig alloc] init];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configDic safeObjectForKey:@"pushConfig"]];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+ (nullable ZIMGroupInviteApplicationSendConfig *)oZIMGroupInviteApplicationSendConfig:
    (nullable NSDictionary *)configMap;
{
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupInviteApplicationSendConfig *groupInviteApplicationSendConfig =
        [[ZIMGroupInviteApplicationSendConfig alloc] init];
    groupInviteApplicationSendConfig.wording = [configMap safeObjectForKey:@"wording"];
    groupInviteApplicationSendConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return groupInviteApplicationSendConfig;
}

+ (nullable ZIMGroupJoinApplicationSendConfig *)oZIMGroupJoinApplicationSendConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupJoinApplicationSendConfig *joinApplicationSendConfig =
        [[ZIMGroupJoinApplicationSendConfig alloc] init];
    joinApplicationSendConfig.wording = [configMap safeObjectForKey:@"wording"];
    joinApplicationSendConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return joinApplicationSendConfig;
}

+ (nullable ZIMGroupInviteApplicationAcceptConfig *)oZIMGroupInviteApplicationAcceptConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupInviteApplicationAcceptConfig *inviteApplicationAcceptConfig =
        [[ZIMGroupInviteApplicationAcceptConfig alloc] init];
    inviteApplicationAcceptConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return inviteApplicationAcceptConfig;
}

+ (nullable ZIMGroupJoinApplicationAcceptConfig *)oZIMGroupJoinApplicationAcceptConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupJoinApplicationAcceptConfig *joinApplicationAcceptConfig =
        [[ZIMGroupJoinApplicationAcceptConfig alloc] init];
    joinApplicationAcceptConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return joinApplicationAcceptConfig;
}

+ (nullable ZIMGroupJoinApplicationRejectConfig *)oZIMGroupJoinApplicationRejectConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupJoinApplicationRejectConfig *joinApplicationRejectConfig =
        [[ZIMGroupJoinApplicationRejectConfig alloc] init];
    joinApplicationRejectConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return joinApplicationRejectConfig;
}

+ (nullable ZIMGroupInviteApplicationRejectConfig *)oZIMGroupInviteApplicationRejectConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupInviteApplicationRejectConfig *inviteApplicationRejectConfig =
        [[ZIMGroupInviteApplicationRejectConfig alloc] init];
    inviteApplicationRejectConfig.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return inviteApplicationRejectConfig;
}

+ (nullable ZIMGroupApplicationListQueryConfig *)oZIMGroupApplicationListQueryConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMGroupApplicationListQueryConfig *queryConfig =
        [[ZIMGroupApplicationListQueryConfig alloc] init];
    queryConfig.count = [[configMap safeObjectForKey:@"count"] unsignedIntValue];
    queryConfig.nextFlag = [[configMap safeObjectForKey:@"nextFlag"] unsignedIntValue];
    return queryConfig;
}

+ (nullable ZIMCallAcceptConfig *)oZIMCallAcceptConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallAcceptConfig *config = [[ZIMCallAcceptConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}

+ (nullable ZIMCallRejectConfig *)oZIMCallRejectConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallRejectConfig *config = [[ZIMCallRejectConfig alloc] init];
    config.extendedData = [configDic safeObjectForKey:@"extendedData"];
    return config;
}
+ (nullable ZIMRoomMemberAttributesSetConfig *)oZIMRoomMemberAttributesSetConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomMemberAttributesSetConfig *setConfig = [[ZIMRoomMemberAttributesSetConfig alloc] init];
    setConfig.isDeleteAfterOwnerLeft =
        [[configDic safeObjectForKey:@"isDeleteAfterOwnerLeft"] boolValue];
    return setConfig;
}

+ (nullable NSDictionary *)mZIMRoomMemberAttributesInfo:
    (nullable ZIMRoomMemberAttributesInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.attributes forKey:@"attributes"];
    [infoDic safeSetObject:info.userID forKey:@"userID"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMRoomMemberAttributesOperatedInfo:
    (nullable ZIMRoomMemberAttributesOperatedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.errorKeys forKey:@"errorKeys"];
    NSDictionary *attributesInfoDic =
        [ZIMPluginConverter mZIMRoomMemberAttributesInfo:info.attributesInfo];
    [infoDic safeSetObject:attributesInfoDic forKey:@"attributesInfo"];
    return infoDic;
}

+ (nullable ZIMRoomMemberAttributesQueryConfig *)oZIMRoomMemberAttributesQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMRoomMemberAttributesQueryConfig *queryConfig =
        [[ZIMRoomMemberAttributesQueryConfig alloc] init];
    queryConfig.count = [[configDic safeObjectForKey:@"count"] unsignedIntValue];
    queryConfig.nextFlag = [configDic safeObjectForKey:@"nextFlag"];
    return queryConfig;
}

+ (nullable NSDictionary *)mZIMRoomMemberAttributesUpdateInfo:
    (nullable ZIMRoomMemberAttributesUpdateInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMRoomMemberAttributesInfo:info.attributesInfo]
                    forKey:@"attributesInfo"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMRoomOperatedInfo:(nullable ZIMRoomOperatedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.userID forKey:@"userID"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMCallInvitationTimeoutInfo:
    (nullable ZIMCallInvitationTimeoutInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithInt:(int)info.mode] forKey:@"mode"];
    return infoDic;
}

+ (nullable NSDictionary *)mZIMMessageReaction:(nullable ZIMMessageReaction *)reaction {
    if (reaction == nil || reaction == NULL || [reaction isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:reaction.conversationID forKey:@"conversationID"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:reaction.messageID] forKey:@"messageID"];
    [infoDic safeSetObject:reaction.reactionType forKey:@"reactionType"];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInteger:reaction.conversationType]
                    forKey:@"conversationType"];
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInteger:reaction.totalCount]
                    forKey:@"totalCount"];
    [infoDic safeSetObject:[NSNumber numberWithBool:reaction.isSelfIncluded]
                    forKey:@"isSelfIncluded"];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMMessageReactionUserInfoList:reaction.userList]
                    forKey:@"userList"];

    return infoDic;
}

+ (nullable NSDictionary *)mZIMMessageReactionUserInfo:
    (nullable ZIMMessageReactionUserInfo *)userInfo {
    if (userInfo == nil || userInfo == NULL || [userInfo isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:userInfo.userID forKey:@"userID"];
    return infoDic;
}

+ (nullable NSArray *)mZIMMessageReactionList:(nullable NSArray<ZIMMessageReaction *> *)reactions {
    if (reactions == nil || reactions == NULL || [reactions isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *infoDic = [[NSMutableArray alloc] init];
    for (ZIMMessageReaction *reaction in reactions) {
        NSDictionary *reactionInfoDic = [ZIMPluginConverter mZIMMessageReaction:reaction];
        [infoDic safeAddObject:reactionInfoDic];
    }
    return infoDic;
}

+ (nullable NSArray *)mZIMMessageReactionUserInfoList:
    (nullable NSArray<ZIMMessageReactionUserInfo *> *)userInfoList {
    if (userInfoList == nil || userInfoList == NULL || [userInfoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *infoDic = [[NSMutableArray alloc] init];
    for (ZIMMessageReactionUserInfo *userInfo in userInfoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMMessageReactionUserInfo:userInfo];
        [infoDic safeAddObject:userInfoDic];
    }
    return infoDic;
}

+ (nullable ZIMMessageReactionUserQueryConfig *)oZIMMessageReactionUsersQueryConfig:
    (nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMMessageReactionUserQueryConfig *config = [[ZIMMessageReactionUserQueryConfig alloc] init];
    config.nextFlag = ((NSNumber *)[configDic safeObjectForKey:@"nextFlag"]).unsignedLongLongValue;
    config.reactionType = [configDic safeObjectForKey:@"reactionType"];
    config.count = ((NSNumber *)[configDic objectForKey:@"count"]).unsignedIntValue;
    return config;
}

+ (nullable NSDictionary *)mZIMMessageDeletedInfo:(nullable ZIMMessageDeletedInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:info.conversationID forKey:@"conversationID"];
    [infoDic setObject:[NSNumber numberWithInteger:info.conversationType]
                forKey:@"conversationType"];
    [infoDic setObject:[NSNumber numberWithInteger:info.messageDeleteType]
                forKey:@"messageDeleteType"];
    [infoDic setObject:[NSNumber numberWithBool:info.isDeleteConversationAllMessage]
                forKey:@"isDeleteConversationAllMessage"];
    [infoDic setObject:[ZIMPluginConverter mZIMMessageList:info.messageList] forKey:@"messageList"];
    return infoDic;
}

+ (nullable ZIMCallJoinConfig *)oZIMCallJoinConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMCallJoinConfig *config = [[ZIMCallJoinConfig alloc] init];
    config.extendedData = [configMap objectForKey:@"extendedData"];
    return config;
}

+ (nullable ZIMBlacklistQueryConfig *)oZIMBlacklistQueryConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMBlacklistQueryConfig *queryConfig = [[ZIMBlacklistQueryConfig alloc] init];
    queryConfig.nextFlag = [[configMap objectForKey:@"nextFlag"] unsignedIntValue];
    queryConfig.count = [[configMap objectForKey:@"count"] unsignedIntValue];
    return queryConfig;
}

+ (nullable ZIMFriendAddConfig *)oZIMFriendAddConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendAddConfig *config = [[ZIMFriendAddConfig alloc] init];
    config.wording = [configMap objectForKey:@"wording"];
    config.friendAlias = [configMap objectForKey:@"friendAlias"];
    config.friendAttributes = [configMap safeObjectForKey:@"friendAttributes"];
    return config;
}

+ (nullable ZIMFriendApplicationAcceptConfig *)oZIMFriendApplicationAcceptConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendApplicationAcceptConfig *config = [[ZIMFriendApplicationAcceptConfig alloc] init];
    config.friendAlias = [configMap objectForKey:@"friendAlias"];
    config.friendAttributes = [configMap safeObjectForKey:@"friendAttributes"];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return config;
}

+ (nullable ZIMFriendApplicationInfo *)oZIMFriendApplicationInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendApplicationInfo *info = [[ZIMFriendApplicationInfo alloc] init];
    info.applyUser = [ZIMPluginConverter oZIMUserInfo:[infoDic objectForKey:@"applyUser"]];
    info.wording = (NSString *)[infoDic objectForKey:@"wording"];
    info.createTime = ((NSNumber *)[infoDic safeObjectForKey:@"createTime"]).unsignedLongLongValue;
    info.updateTime = ((NSNumber *)[infoDic safeObjectForKey:@"updateTime"]).unsignedLongLongValue;
    info.type = ((NSNumber *)[infoDic objectForKey:@"type"]).intValue;
    info.state = ((NSNumber *)[infoDic objectForKey:@"state"]).intValue;

    return info;
}

+ (nullable ZIMUserInfo *)oZIMUserInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }
    NSString *classType = [infoDic safeObjectForKey:@"classType"];
    ZIMUserInfo *info;
    if (classType != nil) {
        if ([classType isEqual:@"ZIMGroupMemberSimpleInfo"]) {
            info = [[ZIMGroupMemberSimpleInfo alloc] init];
            ZIMGroupMemberSimpleInfo *subInfo = (ZIMGroupMemberSimpleInfo *)info;
            subInfo.memberNickname = [infoDic objectForKey:@"memberNickname"];
            subInfo.memberRole = [[infoDic objectForKey:@"memberRole"] intValue];
        } else if ([classType isEqual:@"ZIMGroupMemberInfo"]) {
            info = [[ZIMGroupMemberInfo alloc] init];
            ZIMGroupMemberInfo *subInfo = (ZIMGroupMemberInfo *)info;
            subInfo.memberNickname = [infoDic objectForKey:@"memberNickname"];
            subInfo.memberRole = [[infoDic objectForKey:@"memberRole"] intValue];
            subInfo.memberAvatarUrl = [infoDic objectForKey:@"memberAvatarUrl"];
            subInfo.muteExpiredTime = [[infoDic objectForKey:@"muteExpiredTime"] longLongValue];
        } else if ([classType isEqual:@"ZIMFriendInfo"]) {
            info = [[ZIMFriendInfo alloc] init];
            ZIMFriendInfo *subInfo = (ZIMFriendInfo *)info;
            subInfo.friendAlias = [infoDic objectForKey:@"friendAlias"];
            subInfo.createTime = [[infoDic objectForKey:@"createTime"] longLongValue];
            subInfo.wording = [infoDic objectForKey:@"wording"];
            subInfo.friendAttributes = [infoDic objectForKey:@"friendAttributes"];
        } else {
            info = [[ZIMUserInfo alloc] init];
        }
    } else {
        info = [[ZIMUserInfo alloc] init];
    }

    info.userID = (NSString *)[infoDic objectForKey:@"userID"];
    info.userName = (NSString *)[infoDic objectForKey:@"userName"];
    info.userAvatarUrl = (NSString *)[infoDic objectForKey:@"userAvatarUrl"];
    return info;
}

+ (nullable NSDictionary *)mZIMFriendApplicationInfo:(nullable ZIMFriendApplicationInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    NSDictionary *baseInfodic = [ZIMPluginConverter mZIMUserInfo:info.applyUser];
    [infoDic safeSetObject:baseInfodic forKey:@"applyUser"];
    [infoDic safeSetObject:info.wording forKey:@"wording"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.updateTime] forKey:@"updateTime"];
    [infoDic safeSetObject:[NSNumber numberWithInteger:info.type] forKey:@"type"];
    [infoDic safeSetObject:[NSNumber numberWithInteger:info.state] forKey:@"state"];
    return infoDic;
}

+ (nullable NSArray *)mZIMFriendApplicationInfoList:
    (nullable NSArray<ZIMFriendApplicationInfo *> *)infoList {
    if (infoList == nil || infoList == NULL || [infoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *infoDic = [[NSMutableArray alloc] init];
    for (ZIMFriendApplicationInfo *userInfo in infoList) {
        NSDictionary *userInfoDic = [ZIMPluginConverter mZIMFriendApplicationInfo:userInfo];
        [infoDic safeAddObject:userInfoDic];
    }
    return infoDic;
}

+ (nullable ZIMFriendApplicationListQueryConfig *)oZIMFriendApplicationListQueryConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendApplicationListQueryConfig *config =
        [[ZIMFriendApplicationListQueryConfig alloc] init];
    config.nextFlag = [[configMap safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.count = [[configMap safeObjectForKey:@"count"] unsignedIntValue];

    return config;
}

+ (nullable ZIMFriendApplicationRejectConfig *)oZIMFriendApplicationRejectConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendApplicationRejectConfig *config = [[ZIMFriendApplicationRejectConfig alloc] init];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return config;
}

+ (nullable ZIMFriendDeleteConfig *)oZIMFriendDeleteConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendDeleteConfig *config = [[ZIMFriendDeleteConfig alloc] init];
    config.type = [[configMap safeObjectForKey:@"type"] unsignedIntValue];

    return config;
}

+ (nullable NSDictionary *)mZIMFriendInfo:(nullable ZIMFriendInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.userID forKey:@"userID"];
    [infoDic safeSetObject:info.userName forKey:@"userName"];
    [infoDic safeSetObject:info.userAvatarUrl forKey:@"userAvatarUrl"];
    [infoDic safeSetObject:info.friendAlias forKey:@"friendAlias"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [infoDic safeSetObject:info.wording forKey:@"wording"];
    [infoDic safeSetObject:info.friendAttributes forKey:@"friendAttributes"];
    return infoDic;
}

+ (nullable NSArray *)mZIMFriendInfoList:(nullable NSArray<ZIMFriendInfo *> *)infoList {
    if (infoList == nil || infoList == NULL || [infoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicInfoList = [[NSMutableArray alloc] init];
    for (ZIMFriendInfo *info in infoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMFriendInfo:info];
        [basicInfoList safeAddObject:infoDic];
    }
    return basicInfoList;
}

+ (nullable ZIMFriendInfo *)oZIMFriendInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendInfo *info = [[ZIMFriendInfo alloc] init];
    info.userID = (NSString *)[infoDic objectForKey:@"userID"];
    info.userName = (NSString *)[infoDic objectForKey:@"userName"];
    info.userAvatarUrl = (NSString *)[infoDic objectForKey:@"userAvatarUrl"];

    info.wording = (NSString *)[infoDic objectForKey:@"wording"];
    info.friendAlias = (NSString *)[infoDic objectForKey:@"friendAlias"];
    info.createTime = ((NSNumber *)[infoDic safeObjectForKey:@"createTime"]).unsignedLongLongValue;
    info.friendAttributes = [infoDic safeObjectForKey:@"friendAttributes"];
    return info;
}

+ (nullable ZIMFriendListQueryConfig *)oZIMFriendListQueryConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendListQueryConfig *config = [[ZIMFriendListQueryConfig alloc] init];
    config.nextFlag = [[configMap safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.count = [[configMap safeObjectForKey:@"count"] unsignedIntValue];

    return config;
}

+ (nullable ZIMFriendRelationCheckConfig *)oZIMFriendRelationCheckConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendRelationCheckConfig *config = [[ZIMFriendRelationCheckConfig alloc] init];
    config.type = [[configMap safeObjectForKey:@"type"] unsignedIntValue];

    return config;
}

+ (nullable NSDictionary *)mZIMFriendRelationInfo:(nullable ZIMFriendRelationInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.userID forKey:@"userID"];
    [infoDic safeSetObject:[NSNumber numberWithInteger:info.type] forKey:@"type"];
    return infoDic;
}

+ (nullable NSArray *)mZIMFriendRelationInfoList:
    (nullable NSArray<ZIMFriendRelationInfo *> *)infoList {
    if (infoList == nil || infoList == NULL || [infoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicInfoList = [[NSMutableArray alloc] init];
    for (ZIMFriendRelationInfo *info in infoList) {
        NSDictionary *infoDic = [ZIMPluginConverter mZIMFriendRelationInfo:info];
        [basicInfoList safeAddObject:infoDic];
    }
    return basicInfoList;
}

+ (nullable ZIMFriendRelationInfo *)oZIMFriendRelationInfo:(nullable NSDictionary *)infoDic {
    if (infoDic == nil || infoDic == NULL || [infoDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendRelationInfo *info = [[ZIMFriendRelationInfo alloc] init];
    info.userID = (NSString *)[infoDic objectForKey:@"userID"];
    info.type = [[infoDic safeObjectForKey:@"type"] unsignedIntValue];
    return info;
}

+ (nullable ZIMFriendApplicationSendConfig *)oZIMFriendApplicationSendConfig:
    (nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendApplicationSendConfig *config = [[ZIMFriendApplicationSendConfig alloc] init];
    config.wording = [configMap objectForKey:@"wording"];
    config.friendAlias = [configMap safeObjectForKey:@"friendAlias"];
    config.friendAttributes = [configMap safeObjectForKey:@"friendAttributes"];
    config.pushConfig =
        [ZIMPluginConverter oZIMPushConfig:[configMap safeObjectForKey:@"pushConfig"]];
    return config;
}

+ (nullable ZIMFileCacheClearConfig *)oZIMFileCacheClearConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFileCacheClearConfig *config = [[ZIMFileCacheClearConfig alloc] init];
    config.endTime = [[configDic safeObjectForKey:@"endTime"] longLongValue];
    return config;
}

+ (nullable ZIMFileCacheQueryConfig *)oZIMFileCacheQueryConfig:(nullable NSDictionary *)configDic {
    if (configDic == nil || configDic == NULL || [configDic isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFileCacheQueryConfig *config = [[ZIMFileCacheQueryConfig alloc] init];
    config.endTime = [[configDic safeObjectForKey:@"endTime"] longLongValue];
    return config;
}

+ (nullable NSDictionary *)mZIMFileCacheInfo:(nullable ZIMFileCacheInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.totalFileSize]
                    forKey:@"totalFileSize"];

    return infoDic;
}

+ (nullable ZIMFriendSearchConfig *)oZIMFriendSearchConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || configMap == NULL || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMFriendSearchConfig *config = [[ZIMFriendSearchConfig alloc] init];
    config.nextFlag = [[configMap safeObjectForKey:@"nextFlag"] unsignedIntValue];
    config.count = [[configMap safeObjectForKey:@"count"] unsignedIntValue];
    config.keywords = [configMap safeObjectForKey:@"keywords"];
    config.isAlsoMatchFriendAlias = [[configMap objectForKey:@"isAlsoMatchFriendAlias"] boolValue];
    return config;
}

+ (nullable NSDictionary *)mZIMTipsMessageChangeInfo:(nullable ZIMTipsMessageChangeInfo *)info {
    if (info == nil || info == NULL || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(info.type) forKey:@"type"];
    if ([info isKindOfClass:[ZIMTipsMessageGroupChangeInfo class]]) {
        ZIMTipsMessageGroupChangeInfo *subInfo = (ZIMTipsMessageGroupChangeInfo *)info;
        [dic setObject:@"ZIMTipsMessageGroupChangeInfo" forKey:@"classType"];
        [dic setObject:@(subInfo.groupDataFlag) forKey:@"groupDataFlag"];
        [dic setObject:subInfo.groupName forKey:@"groupName"];
        [dic setObject:subInfo.groupNotice forKey:@"groupNotice"];
        [dic setObject:subInfo.groupAvatarUrl forKey:@"groupAvatarUrl"];
        if (subInfo.groupMutedInfo != nil) {
            [dic setObject:[ZIMPluginConverter mZIMGroupMuteInfo:subInfo.groupMutedInfo]
                    forKey:@"groupMuteInfo"];
        }
    } else if ([info isKindOfClass:[ZIMTipsMessageGroupMemberChangeInfo class]]) {
        ZIMTipsMessageGroupMemberChangeInfo *subInfo = (ZIMTipsMessageGroupMemberChangeInfo *)info;
        [dic setObject:@(subInfo.memberRole) forKey:@"role"];
        [dic setObject:@(subInfo.muteExpiredTime) forKey:@"muteExpiredTime"];
        [dic setObject:@"ZIMTipsMessageGroupMemberChangeInfo" forKey:@"classType"];
    }
    return dic;
}

+ (nullable ZIMConversationBaseInfo *)oZIMConversationBaseInfo:(nullable NSDictionary *)infoMap {
    if (infoMap == nil || [infoMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMConversationBaseInfo *baseInfo = [[ZIMConversationBaseInfo alloc] init];
    baseInfo.conversationID = [infoMap objectForKey:@"conversationID"];
    baseInfo.conversationType = [[infoMap objectForKey:@"conversationType"] integerValue];
    return baseInfo;
}

+ (nullable NSArray<ZIMConversationBaseInfo *> *)oZIMConversationBaseInfoList:
    (nullable NSArray *)basicList {
    if (basicList == nil || [basicList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray<ZIMConversationBaseInfo *> *infoList = [[NSMutableArray alloc] init];
    for (NSDictionary *basicMap in basicList) {
        [infoList addObject:[ZIMPluginConverter oZIMConversationBaseInfo:basicMap]];
    }
    return infoList;
}

+ (nullable NSDictionary *)mZIMConversationBaseInfo:(nullable ZIMConversationBaseInfo *)info {
    if (info == nil || [info isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableDictionary *basicInfo = [[NSMutableDictionary alloc] init];
    [basicInfo setObject:info.conversationID forKey:@"conversationID"];
    [basicInfo setObject:@(info.conversationType) forKey:@"conversationType"];
    return basicInfo;
}

+ (nullable NSArray *)mZIMConversationBaseInfoList:
    (nullable NSArray<ZIMConversationBaseInfo *> *)infoList {
    if (infoList == nil || [infoList isEqual:[NSNull null]]) {
        return nil;
    }
    NSMutableArray *basicList = [[NSMutableArray alloc] init];
    for (ZIMConversationBaseInfo *info in infoList) {
        [basicList addObject:[ZIMPluginConverter mZIMConversationBaseInfo:info]];
    }
    return basicList;
}

+ (nullable ZIMConversationFilterOption *)oZIMConversationFilterOption:
    (nullable NSDictionary *)optionMap {
    if (optionMap == nil || [optionMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMConversationFilterOption *option = [[ZIMConversationFilterOption alloc] init];
    option.marks = [optionMap objectForKey:@"marks"];
    option.conversationTypes = [optionMap objectForKey:@"conversationTypes"];
    option.isOnlyUnreadConversation =
        [[optionMap objectForKey:@"isOnlyUnreadConversation"] boolValue];
    return option;
}

+ (nullable ZIMConversationTotalUnreadMessageCountQueryConfig *)
    oZIMConversationTotalUnreadMessageCountQueryConfig:(nullable NSDictionary *)configMap {
    if (configMap == nil || [configMap isEqual:[NSNull null]]) {
        return nil;
    }
    ZIMConversationTotalUnreadMessageCountQueryConfig *queryConfig =
        [[ZIMConversationTotalUnreadMessageCountQueryConfig alloc] init];
    queryConfig.marks = [configMap objectForKey:@"marks"];
    queryConfig.conversationTypes = [configMap objectForKey:@"conversationTypes"];
    return queryConfig;
}

@end
