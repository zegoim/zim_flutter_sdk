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
    NSString *json = @"{}";
    if(extendedData != nil){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extendedData options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    NSDictionary *resultDic = @{@"method":@"onConnectionStateChanged",@"state":[NSNumber numberWithInt:(int)state],@"event":[NSNumber numberWithInt:(int)event]};
    NSMutableDictionary *resultMtDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
    [resultMtDic safeSetObject:json forKey:@"extendedData"];
    _events(resultMtDic);
}

- (void)zim:(ZIM *)zim errorInfo:(ZIMError *)errorInfo{
    if(_events == nil){
        return;
    }
    
    NSDictionary *resultDic = @{@"method":@"onError",@"code":[NSNumber numberWithInt:(int)errorInfo.code],@"message":errorInfo.message};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim tokenWillExpire:(unsigned int)second{
    if(_events == nil){
        return;
    }
    
    NSDictionary *resultDic = @{@"method":@"onTokenWillExpire",@"second":[NSNumber numberWithUnsignedInt:second]};
    _events(resultDic);
}

// MARK: Conversation
- (void)zim:(ZIM *)zim
conversationChanged:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList{
    if(_events == nil){
        return;
    }
    NSArray *basicList = [ZIMPluginConverter cnvConversationChangeInfoListToBasicList:conversationChangeInfoList];
    NSDictionary *resultDic = @{@"method":@"onConversationChanged",@"conversationChangeInfoList":basicList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
conversationTotalUnreadMessageCountUpdated:(unsigned int)totalUnreadMessageCount{
    if(_events == nil){
        return;
    }
    NSDictionary *resultDic = @{@"method":@"onConversationTotalUnreadMessageCountUpdated",@"totalUnreadMessageCount":[NSNumber numberWithUnsignedInt:totalUnreadMessageCount]};
    _events(resultDic);
}

// MARK: Message

- (void)zim:(ZIM *)zim
    receivePeerMessage:(NSArray<ZIMMessage *> *)messageList
 fromUserID:(NSString *)fromUserID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceivePeerMessage",@"messageList":basicMessageList,@"fromUserID":fromUserID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveRoomMessage:(NSArray<ZIMMessage *> *)messageList
 fromRoomID:(NSString *)fromRoomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveRoomMessage",@"messageList":basicMessageList,@"fromRoomID":fromRoomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    receiveGroupMessage:(NSArray<ZIMMessage *> *)messageList
fromGroupID:(NSString *)fromGroupID{
    if(_events == nil){
        return;
    }
    NSArray *basicMessageList = [ZIMPluginConverter cnvZIMMessageListToDicList:messageList];
    NSDictionary *resultDic = @{@"method":@"onReceiveGroupMessage",@"messageList":basicMessageList,@"fromGroupID":fromGroupID};
    _events(resultDic);
}

// MARK: Room
- (void)zim:(ZIM *)zim
    roomMemberJoined:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMemberList = [ZIMPluginConverter cnvZIMUserInfoListTobasicList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberJoined",@"roomID":roomID,@"memberList":basicMemberList};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomMemberLeft:(NSArray<ZIMUserInfo *> *)memberList
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicMemberList = [ZIMPluginConverter cnvZIMUserInfoListTobasicList:memberList];
    NSDictionary *resultDic = @{@"method":@"onRoomMemberLeft",@"roomID":roomID,@"memberList":basicMemberList};
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
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onRoomStateChanged" forKey:@"method"];
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
    NSDictionary *updateInfoDic = [ZIMPluginConverter cnvZIMRoomAttributesUpdateInfoObjectToDic:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesUpdated",@"updateInfo":updateInfoDic,@"roomID":roomID};
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    roomAttributesBatchUpdated:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfo
     roomID:(NSString *)roomID{
    if(_events == nil){
        return;
    }
    NSArray *basicUpdateInfoList = [ZIMPluginConverter cnvZIMRoomAttributesUpdateInfoListToBasicList:updateInfo];
    NSDictionary *resultDic = @{@"method":@"onRoomAttributesBatchUpdated",@"updateInfo":basicUpdateInfoList,@"roomID":roomID};
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
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    NSDictionary *groupInfoDic = [ZIMPluginConverter cnvZIMGroupFullInfoObjectToDic:groupInfo];
    [resultDic safeSetObject:groupInfoDic forKey:@"groupInfo"];
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
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupName forKey:@"groupName"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
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
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupNotice forKey:@"groupNotice"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:@"onGroupNoticeUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    groupAttributesUpdated:(NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfo
              operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo
    groupID:(NSString *)groupID{
    if(_events == nil){
        return;
    }
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSArray *updateInfoArr = [ZIMPluginConverter cnvZIMGroupAttributesUpdateInfoListToBasicList:updateInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:updateInfoArr forKey:@"updateInfo"];
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
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSArray *userListArr = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userList];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    [resultDic safeSetObject:userListArr forKey:@"userList"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)state] forKey:@"state"];
    [resultDic safeSetObject:[NSNumber numberWithInt:(int)event] forKey:@"event"];
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
    NSDictionary *operatedInfoDic = [ZIMPluginConverter cnvZIMGroupOperatedInfoObjectToDic:operatedInfo];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:operatedInfoDic forKey:@"operatedInfo"];
    [resultDic safeSetObject:groupID forKey:@"groupID"];
    NSArray *basicUserInfoList = [ZIMPluginConverter cnvZIMGroupMemberInfoListToBasicList:userInfo];
    [resultDic safeSetObject:basicUserInfoList forKey:@"userInfo"];
    [resultDic safeSetObject:@"onGroupMemberInfoUpdated" forKey:@"method"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationReceived:(ZIMCallInvitationReceivedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *callInvitationReceivedInfoDic = [[NSMutableDictionary alloc] init];
    [callInvitationReceivedInfoDic safeSetObject:[NSNumber numberWithUnsignedInt:info.timeout] forKey:@"timeout"];
    [callInvitationReceivedInfoDic safeSetObject:info.inviter forKey:@"inviter"];
    [callInvitationReceivedInfoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationReceived" forKey:@"method"];
    [resultDic safeSetObject:callInvitationReceivedInfoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationCancelled:(ZIMCallInvitationCancelledInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.inviter forKey:@"inviter"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationCancelled" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationAccepted:(ZIMCallInvitationAcceptedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationAccepted" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInvitationRejected:(ZIMCallInvitationRejectedInfo *)info
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic safeSetObject:info.invitee forKey:@"invitee"];
    [infoDic safeSetObject:info.extendedData forKey:@"extendedData"];
    [resultDic safeSetObject:@"onCallInvitationRejected" forKey:@"method"];
    [resultDic safeSetObject:infoDic forKey:@"info"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim callInvitationTimeout:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInvitationTimeout" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    _events(resultDic);
}

- (void)zim:(ZIM *)zim
    callInviteesAnsweredTimeout:(NSArray<NSString *> *)invitees
     callID:(NSString *)callID{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic safeSetObject:@"onCallInviteesAnsweredTimeout" forKey:@"method"];
    [resultDic safeSetObject:callID forKey:@"callID"];
    [resultDic safeSetObject:invitees forKey:@"invitees"];
    _events(resultDic);
    
}



@end
