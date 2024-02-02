//
//  ZIMEventHandler.m
//  zego_zim
//
//  Created by lizhanpeng on 2022/7/25.
//

#import "ZIMEventHandler.h"
#import "ZIMPluginConverter.h"
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"

@interface ZIMEventHandler()

@property (nonatomic, strong) FlutterEventSink events;



@end


@implementation ZIMEventHandler

+ (instancetype)sharedInstance {
    static ZIMEventHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZIMEventHandler alloc] init];
    });
    return instance;
}

- (void)setEventSinks:(FlutterEventSink)sink {
    self.events = sink;
}

- (void)zim:(ZIM *)zim
    connectionStateChanged:(ZIMConnectionState)state
                     event:(ZIMConnectionEvent)event
extendedData:(NSDictionary *)extendedData{
    if(_events == nil){
        return;
    }
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onConnectionStateChanged" forKey:@"method"];
    [resultDic safeSetObject:[_engineEventMap objectForKey:zim] forKey:@"handle"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    NSString *json = @"{}";
    if(extendedData != nil){
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extendedData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *extendedjson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json = [extendedjson stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    [resultDic safeSetObject:json forKey:@"extendedData"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim errorInfo:(ZIMError *)errorInfo{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *resultDic = @{@"method":@"onError", @"handle": handle, @"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim userInfoUpdated:(ZIMUserFullInfo *)info{
    if(_events == nil){
        return;
    }
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[ZIMPluginConverter mZIMUserFullInfo:info] forKey:@"info"];
    [resultDic safeSetObject:[_engineEventMap objectForKey:zim] forKey:@"handle"];
    [resultDic safeSetObject:@"onUserInfoUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim messageDeleted:(ZIMMessageDeletedInfo *)deletedInfo{
    if(_events == nil){
        return;
    }
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[_engineEventMap objectForKey:zim] forKey:@"handle"];
    [resultDic safeSetObject:@"onMessageDeleted" forKey:@"method"];
    [resultDic safeSetObject:[ZIMPluginConverter mZIMMessageDeletedInfo:deletedInfo] forKey:@"deletedInfo"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim tokenWillExpire:(unsigned int)second{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *resultDic = @{@"method":@"onTokenWillExpire",@"handle": handle, @"second":[NSNumber numberWithUnsignedInt:second]};
    _events(resultDic);
}

// MARK: Conversation
- (void)zim:(ZIM *)zim
conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicList = [ZIMPluginConverter mConversationChangeInfoList:conversationChangeInfoList];
    NSDictionary *resultDic = @{@"method":@"onConversationChanged", @"handle": handle, @"conversationChangeInfoList":basicList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    conversationsAllDeleted:(ZIMConversationsAllDeletedInfo *)info{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    [infoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.count] forKey:@"count"];
    
    [resultDic safeSetObject:@"onConversationsAllDeleted" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *resultDic = @{@"method":@"onConversationTotalUnreadMessageCountUpdated",@"handle": handle, @"totalUnreadMessageCount":[NSNumber numberWithUnsignedInt:totalUnreadMessageCount]};
    _events(resultDic);
}

// MARK: Message


- (void)zim:(ZIM *)zim
    receivePeerMessage:(NSArray<ZIMMessage *> *)messageList
 fromUserID:(NSString *)fromUserID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicMessageList = [ZIMPluginConverter mZIMMessageList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceivePeerMessage", @"handle": handle, @"messageList":basicMessageList,@"fromUserID":fromUserID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList
 fromRoomID:(NSString *)fromRoomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicMessageList = [ZIMPluginConverter mZIMMessageList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveRoomMessage",@"handle": handle, @"messageList":basicMessageList,@"fromRoomID":fromRoomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList
fromGroupID:(NSString *)fromGroupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicMessageList = [ZIMPluginConverter mZIMMessageList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveGroupMessage",@"handle": handle, @"messageList":basicMessageList,@"fromGroupID":fromGroupID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim messageRevokeReceived:(NSArray<ZIMRevokeMessage *> *)messageList{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[ZIMPluginConverter mZIMMessageList:messageList] forKey:@"messageList"];
    [resultDic safeSetObject:@"onMessageRevokeReceived" forKey:@"method"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim broadcastMessageReceived:(ZIMMessage *)message{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[ZIMPluginConverter mZIMMessage:message] forKey:@"message"];
    [resultDic safeSetObject:@"onBroadcastMessageReceived" forKey:@"method"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim messageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onMessageReceiptChanged" forKey:@"method"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
    for (ZIMMessageReceiptInfo *info in infos) {
        [infosModel safeAddObject:[ZIMPluginConverter mZIMMessageReceiptInfo:info]];
    }
    [resultDic safeSetObject:infosModel forKey:@"infos"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim conversationMessageReceiptChanged:(NSArray<ZIMMessageReceiptInfo *> *)infos{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onConversationMessageReceiptChanged" forKey:@"method"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
    for (ZIMMessageReceiptInfo *info in infos) {
        [infosModel safeAddObject:[ZIMPluginConverter mZIMMessageReceiptInfo:info]];
    }
    [resultDic safeSetObject:infosModel forKey:@"infos"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    messageSentStatusChanged:
(NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicList = [ZIMPluginConverter mMessageSentStatusChangeInfoList:messageSentStatusChangeInfoList];
    NSDictionary *resultDic = @{@"method":@"onMessageSentStatusChanged", @"handle": handle, @"messageSentStatusChangeInfoList":basicList};
    _events(resultDic);
}


// MARK: Room
- (void)zim:(ZIM *)zim
    roomMemberJoined:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicMemberList = [ZIMPluginConverter mZIMUserInfoList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberJoined",@"handle": handle, @"roomID":roomID,@"memberList":basicMemberList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomMemberLeft:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicMemberList = [ZIMPluginConverter mZIMUserInfoList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberLeft",@"handle": handle, @"roomID":roomID,@"memberList":basicMemberList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomStateChanged:(ZIMRoomState)state
               event:(ZIMRoomEvent)event
        extendedData:(NSDictionary *)extendedData
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onRoomStateChanged" forKey:@"method"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    [resultDic safeSetObject:roomID forKey:@"roomID"];
    NSString *json = @"{}";
    if(extendedData != nil){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extendedData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    [resultDic safeSetObject:json forKey:@"extendedData"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomAttributesUpdated:(ZIMRoomAttributesUpdateInfo *)updateInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *updateInfoDic = [ZIMPluginConverter mZIMRoomAttributesUpdateInfo:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesUpdated",@"handle": handle, @"updateInfo":updateInfoDic,@"roomID":roomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomAttributesBatchUpdated:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSArray *basicUpdateInfoList = [ZIMPluginConverter mZIMRoomAttributesUpdateInfoList:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesBatchUpdated",@"handle": handle, @"updateInfo":basicUpdateInfoList,@"roomID":roomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomMemberAttributesUpdated:(NSArray<ZIMRoomMemberAttributesUpdateInfo *> *)infos
                   operatedInfo:(ZIMRoomOperatedInfo *)operatedInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableArray *infosModel = [[NSMutableArray alloc] init];
    for (ZIMRoomMemberAttributesUpdateInfo *updateInfo in infos) {
        [infosModel safeAddObject:[ZIMPluginConverter mZIMRoomMemberAttributesUpdateInfo:updateInfo]];
    }
    NSDictionary *operatedInfoModel = [ZIMPluginConverter mZIMRoomOperatedInfo:operatedInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberAttributesUpdated",@"handle": handle, @"infos":infosModel,@"roomID":roomID,@"operatedInfo":operatedInfoModel};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupStateChanged:(ZIMGroupState)state
                event:(ZIMGroupEvent)event
         operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
  groupInfo:(ZIMGroupFullInfo *)groupInfo{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    NSDictionary *groupInfoDic = [ZIMPluginConverter mZIMGroupFullInfo:groupInfo];
    [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupStateChanged" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupNameUpdated:(NSString *)groupName
        operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupName forKey:@"groupName"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupNameUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupNoticeUpdated:(NSString *)groupNotice
          operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupNotice forKey:@"groupNotice"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupNoticeUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupAvatarUrlUpdated:(NSString *)groupAvatarUrl
             operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupAvatarUrl forKey:@"groupAvatarUrl"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupAvatarUrlUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupMutedInfoUpdated:(ZIMGroupMuteInfo *)muteInfo
             operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
                  groupID:(NSString *)groupID {
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSDictionary *muteInfoDic = [ZIMPluginConverter mZIMGroupMuteInfo:muteInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:muteInfoDic forKey:@"groupMuteInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupMuteInfoUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupAttributesUpdated:(NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSArray *updateInfoArr = [ZIMPluginConverter mZIMGroupAttributesUpdateInfoList:updateInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:updateInfoArr forKey:@"updateInfo"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupAttributesUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupMemberStateChanged:(ZIMGroupMemberState)state
                      event:(ZIMGroupMemberEvent)event
                   userList:(NSArray<ZIMGroupMemberInfo *> *)userList
               operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSArray *userListArr = [ZIMPluginConverter mZIMGroupMemberInfoList:userList];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:userListArr forKey:@"userList"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupMemberStateChanged" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupMemberInfoUpdated:(NSArray<ZIMGroupMemberInfo *> *)userInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSDictionary *operatedInfoDic = [ZIMPluginConverter mZIMGroupOperatedInfo:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    NSArray *basicUserInfoList = [ZIMPluginConverter mZIMGroupMemberInfoList:userInfo];
    [resultDic safeSetObject:basicUserInfoList forKey:@"userInfo"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:@"onGroupMemberInfoUpdated" forKey:@"method"];
    _events(resultDic);
}



- (void)zim:(ZIM *)zim
    callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info
     callID:(NSString *)callID{
    
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *callInvitationReceivedInfoDic = [[NSMutableDictionary alloc] init];
    [callInvitationReceivedInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [callInvitationReceivedInfoDic safeSetObject:info.inviter forKey:@"inviter"];
    [callInvitationReceivedInfoDic safeSetObject:info.caller forKey:@"caller"];
    [callInvitationReceivedInfoDic safeSetObject:[NSNumber numberWithInt:(int)info.mode] forKey:@"mode"];
    [callInvitationReceivedInfoDic safeSetObject:[NSNumber numberWithLongLong:info.createTime] forKey:@"createTime"];
    [callInvitationReceivedInfoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:info.callUserList] forKey:@"callUserList"];
    [callInvitationReceivedInfoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationReceived" forKey:@"method"];
    [resultDic safeSetObject:callInvitationReceivedInfoDic forKey:@"info"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationCancelled:(ZIMCallInvitationCancelledInfo *)info
     callID:(NSString *)callID{
    
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.inviter forKey:@"inviter"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [infoDic safeSetObject:[NSNumber numberWithInt:(int)info.mode] forKey:@"mode"];
    [resultDic safeSetObject:@"onCallInvitationCancelled" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationAccepted:(ZIMCallInvitationAcceptedInfo *)info
     callID:(NSString *)callID{
    
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationAccepted" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationRejected:(ZIMCallInvitationRejectedInfo *)info
     callID:(NSString *)callID{
    
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationRejected" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim callInvitationTimeout:(ZIMCallInvitationTimeoutInfo *)info callID:(NSString *)callID{
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInvitationTimeout" forKey:@"method"];
    [resultDic safeSetObject:[ZIMPluginConverter mZIMCallInvitationTimeoutInfo:info] forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInviteesAnsweredTimeout:(NSArray<NSString *> *)invitees
     callID:(NSString *)callID{
    
    NSString *handle = [_engineEventMap objectForKey:zim];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInviteesAnsweredTimeout" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:invitees forKey:@"invitees"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
    
}

- (void)zim:(ZIM *)zim
    callInvitationCreated:(ZIMCallInvitationCreatedInfo *)info
     callID:(NSString *)callID{
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSDictionary *infoMap = [ZIMPluginConverter mZIMCallInvitationCreatedInfo:info];
    [resultDic safeSetObject:@"onCallInvitationCreated" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:infoMap forKey:@"info"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationEnded:(ZIMCallInvitationEndedInfo *)info
     callID:(NSString *)callID{
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    [infoDic safeSetObject:info.caller forKey:@"caller"];
    [infoDic safeSetObject:info.operatedUserID forKey:@"operatedUserID"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [infoDic safeSetObject:[NSNumber numberWithInt:(int)info.mode] forKey:@"mode"];
    [infoDic safeSetObject:[NSNumber numberWithLongLong:info.endTime] forKey:@"endTime"];
    
    [resultDic safeSetObject:@"onCallInvitationEnded" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(NSString *)callID{
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:[ZIMPluginConverter mZIMCallUserInfoList:info.callUserList] forKey:@"callUserList"];
    [resultDic safeSetObject:@"onCallUserStateChanged" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim messageReactionsChanged:(NSArray<ZIMMessageReaction *> *)reactions{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *reactionsArray = [ZIMPluginConverter mZIMMessageReactionList:reactions];
    
    [resultDic safeSetObject:@"onMessageReactionsChanged" forKey:@"method"];
    [resultDic safeSetObject:reactionsArray forKey:@"reactions"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}



- (void)zim:(ZIM *)zim blacklistChanged:(NSArray<ZIMUserInfo *> *)userList action:(ZIMBlacklistChangeAction)action{
    if(_events == nil){
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *userInfoBasic = [ZIMPluginConverter mZIMUserInfoList:userList];
    
    [resultDic safeSetObject:@"onBlacklistChanged" forKey:@"method"];
    [resultDic safeSetObject:userInfoBasic forKey:@"userList"];
    [resultDic safeSetObject:[NSNumber numberWithInteger:action] forKey:@"action"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim friendInfoUpdated:(NSArray<ZIMFriendInfo *> *)friendInfoList {
    if (_events == nil) {
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *friendInfoBasic = [ZIMPluginConverter mZIMFriendInfoList:friendInfoList];
    
    [resultDic safeSetObject:@"onFriendInfoUpdated" forKey:@"method"];
    [resultDic safeSetObject:friendInfoBasic forKey:@"friendInfoList"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim friendListChanged:(NSArray<ZIMFriendInfo *> *)friendInfoList
     action:(ZIMFriendListChangeAction)action{
    if (_events == nil) {
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *friendInfoBasic = [ZIMPluginConverter mZIMFriendInfoList:friendInfoList];
    
    [resultDic safeSetObject:@"onFriendListChanged" forKey:@"method"];
    [resultDic safeSetObject:[NSNumber numberWithInteger:action] forKey:@"action"];
    [resultDic safeSetObject:friendInfoBasic forKey:@"friendInfoList"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim friendApplicationUpdated:(NSArray<ZIMFriendApplicationInfo *> *)friendApplicationInfoList {
    if (_events == nil) {
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *friendAppInfoBasic = [ZIMPluginConverter mZIMFriendApplicationInfoList:friendApplicationInfoList];
    
    [resultDic safeSetObject:@"onFriendApplicationUpdated" forKey:@"method"];
    [resultDic safeSetObject:friendAppInfoBasic forKey:@"friendApplicationInfoList"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim friendApplicationListChanged:(NSArray<ZIMFriendApplicationInfo *> *)friendApplicationInfoList
     action:(ZIMFriendApplicationListChangeAction)action {
    if (_events == nil) {
        return;
    }
    NSString *handle = [_engineEventMap objectForKey:zim];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSArray *friendAppInfoBasic = [ZIMPluginConverter mZIMFriendApplicationInfoList:friendApplicationInfoList];
    
    [resultDic safeSetObject:@"onFriendApplicationListChanged" forKey:@"method"];
    [resultDic safeSetObject:[NSNumber numberWithInteger:action] forKey:@"action"];
    [resultDic safeSetObject:friendAppInfoBasic forKey:@"friendApplicationInfoList"];
    [resultDic safeSetObject:handle forKey:@"handle"];
    _events(resultDic);
}


#pragma mark - Getter
- (NSMapTable *)engineEventMap {
    if (!_engineEventMap) {
        _engineEventMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
    }
    return _engineEventMap;
}

@end
