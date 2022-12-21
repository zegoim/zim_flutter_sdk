#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
@interface ZIMPluginConverter:NSObject

+(nullable ZIMAppConfig*)oZIMAppConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMUsersInfoQueryConfig*)oZIMUserInfoQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMErrorObject:(nullable ZIMError *)errorInfo;


+(nullable NSDictionary *)mZIMUserFullInfo:(nullable ZIMUserFullInfo *)userFullInfo;

+(nullable NSDictionary *)mZIMUserInfo:(nullable ZIMUserInfo *)userInfo;

+(nullable NSArray *)mZIMUserInfoList:(nullable NSArray<ZIMUserInfo *> *)userInfoList;

+(nullable ZIMConversation *)oZIMConversation:(nullable NSDictionary *)conversationDic;

+(nullable ZIMMessage *)oZIMMessage:(nullable NSDictionary *)messageDic;

+(nullable NSDictionary *)mZIMMessage:(nullable ZIMMessage *)message;

+(nullable NSDictionary *)mZIMMessageReceiptInfo:(nullable ZIMMessageReceiptInfo *)info;

+(nullable ZIMGroupMessageReceiptMemberQueryConfig *)oZIMGroupMessageReceiptMemberQueryConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageRevokeConfig *)oZIMMessageRevokeConfig:(nullable NSDictionary *)configDic;

+(nullable NSArray *)mZIMConversationList:(nullable NSArray<ZIMConversation *> *)conversationList;

+(nullable ZIMConversationDeleteConfig *)oZIMConversationDeleteConfig:(nullable NSMutableDictionary *)configDic;

+(nullable NSArray *)mConversationChangeInfoList:(nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList;

+(nullable ZIMMessageSendConfig *)oZIMMessageSendConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageQueryConfig *)oZIMMessageQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSArray *)mZIMMessageList:(nullable NSArray<ZIMMessage *>*)messageList;

+(nullable NSArray<ZIMMessage *>*)oZIMMessageList:(nullable NSArray *)basicList;

+(nullable ZIMMessageDeleteConfig *)oZIMMessageDeleteConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomInfo *)oZIMRoomInfo:(nullable NSDictionary *)roomInfoDic;

+(nullable NSDictionary *)mZIMRoomInfo:(nullable ZIMRoomInfo *)roomInfo;

+(nullable NSDictionary *)mZIMRoomFullInfo:(nullable ZIMRoomFullInfo *)roomFullInfo;

+(nullable ZIMRoomAdvancedConfig *)oZIMRoomAdvancedConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomMemberQueryConfig *)oZIMRoomMemberQueryConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesSetConfig *)oZIMRoomAttributesSetConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesDeleteConfig *)oZIMRoomAttributesDeleteConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesBatchOperationConfig *)oZIMRoomAttributesBatchOperationConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMRoomAttributesUpdateInfo:(nullable ZIMRoomAttributesUpdateInfo *)updateInfo;

+(nullable NSArray *)mZIMRoomAttributesUpdateInfoList:(nullable NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList;

+(nullable ZIMRoomMemberAttributesSetConfig *)oZIMRoomMemberAttributesSetConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary*)mZIMRoomMemberAttributesOperatedInfo:(nullable ZIMRoomMemberAttributesOperatedInfo *)info;

+(nullable NSDictionary*)mZIMRoomMemberAttributesInfo:(nullable ZIMRoomMemberAttributesInfo *)info;

+(nullable ZIMRoomMemberAttributesQueryConfig *)oZIMRoomMemberAttributesQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMRoomMemberAttributesUpdateInfo:(nullable ZIMRoomMemberAttributesUpdateInfo *)info;

+(nullable NSDictionary *)mZIMRoomOperatedInfo:(nullable ZIMRoomOperatedInfo *)info;

+(nullable NSDictionary *)mZIMGroupInfo:(nullable ZIMGroupInfo *)groupInfo;

+(nullable ZIMGroupInfo *)oZIMGroupInfo:(nullable NSDictionary *)groupInfoDic;

+(nullable NSDictionary *)mZIMGroupMemberInfo:(nullable ZIMGroupMemberInfo *)memberInfo;

+(nullable NSArray *)mZIMGroupMemberInfoList:(nullable NSArray<ZIMGroupMemberInfo *> *)memberInfoList;

+(nullable NSDictionary *)mZIMErrorUserInfo:(nullable ZIMErrorUserInfo *)errorUserInfo;

+(nullable NSArray *)mZIMErrorUserInfoList:(nullable NSArray<ZIMErrorUserInfo *> *)errorUserInfoList;

+(nullable NSDictionary *)mZIMGroupFullInfo:(nullable ZIMGroupFullInfo *)groupFullInfo;

+(nullable NSDictionary *)mZIMGroupAdvancedConfig:(nullable ZIMGroupAdvancedConfig *)config;

+(nullable ZIMGroupAdvancedConfig *)oZIMGroupAdvancedConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary*)mZIMGroup:(nullable ZIMGroup *)group;

+(nullable NSArray*)mZIMGroupList:(nullable NSArray<ZIMGroup *> *)groupList;

+(nullable NSDictionary *)mZIMGroupMemberQueryConfig:(nullable ZIMGroupMemberQueryConfig *)config;

+(nullable ZIMGroupMemberQueryConfig *)oZIMGroupMemberQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMGroupOperatedInfo:(nullable ZIMGroupOperatedInfo *)operatedInfo;

+(nullable NSDictionary *)mZIMGroupAttributesUpdateInfo:(nullable ZIMGroupAttributesUpdateInfo *)updateInfo;

+(nullable NSArray *)mZIMGroupAttributesUpdateInfoList:(nullable NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfoList;

+(nullable ZIMCallInviteConfig *)oZIMCallInviteConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMCallInvitationSentInfo:(nullable ZIMCallInvitationSentInfo *)info;

+(nullable ZIMCallCancelConfig *)oZIMCallCancelConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallAcceptConfig *)oZIMCallAcceptConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallRejectConfig *)oZIMCallRejectConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mMessageSentStatusChangeInfo:(nullable ZIMMessageSentStatusChangeInfo *)changeInfo;

+(nullable NSArray *)mMessageSentStatusChangeInfoList:(nullable NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList;
@end
