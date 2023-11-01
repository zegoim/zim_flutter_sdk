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

+(nullable NSArray *)mZIMRoomMemberInfoList:(nullable NSArray<ZIMRoomMemberInfo *> *)userInfoList;

+(nullable ZIMConversation *)oZIMConversation:(nullable NSDictionary *)conversationDic;

+(nullable ZIMMessage *)oZIMMessage:(nullable NSDictionary *)messageDic;

+(nullable NSDictionary *)mZIMMessage:(nullable ZIMMessage *)message;

+(nullable NSDictionary *)mZIMMessageReceiptInfo:(nullable ZIMMessageReceiptInfo *)info;

+(nullable ZIMGroupMessageReceiptMemberQueryConfig *)oZIMGroupMessageReceiptMemberQueryConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageRevokeConfig *)oZIMMessageRevokeConfig:(nullable NSDictionary *)configDic;

+(nullable NSArray *)mZIMConversationList:(nullable NSArray<ZIMConversation *> *)conversationList;

+(nullable NSDictionary *)mZIMConversation:(nullable ZIMConversation *)conversation;

+(nullable ZIMConversationDeleteConfig *)oZIMConversationDeleteConfig:(nullable NSMutableDictionary *)configDic;

+(nullable ZIMConversationsAllDeleteConfig *)oZIMConversationsAllDeleteConfig:(nullable NSMutableDictionary *)configDic;

+(nullable NSArray *)mConversationChangeInfoList:(nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList;

+(nullable ZIMMessageSendConfig *)oZIMMessageSendConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageQueryConfig *)oZIMMessageQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSArray *)mZIMMessageList:(nullable NSArray<ZIMMessage *>*)messageList;

+(nullable NSArray<ZIMMessage *>*)oZIMMessageList:(nullable NSArray *)basicList;

+(nullable ZIMMessageDeleteConfig *)oZIMMessageDeleteConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageSearchConfig *)oZIMMessageSearchConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMConversationSearchConfig *) oZIMConversationMessageGlobalSearchConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMConversationMessageSearchInfo:(nullable ZIMConversationSearchInfo *)info;

+(nullable NSArray *)mZIMConversationMessageSearchInfoList:(nullable NSArray<ZIMConversationSearchInfo *> *)infoList;

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

+(nullable ZIMGroupSearchConfig *)oZIMGroupSearchConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMGroupMemberSearchConfig *)oZIMGroupMemberSearchConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMGroupSearchInfo:(nullable ZIMGroupSearchInfo *)groupSearchInfo;

+(nullable NSArray *)mZIMGroupSearchInfoList:(nullable NSArray<ZIMGroupSearchInfo *> *)groupSearchInfoList;

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

+(nullable ZIMCallingInviteConfig *)oZIMCallingInviteConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallQuitConfig *)oZIMCallQuitConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallEndConfig *)oZIMCallEndConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallInvitationQueryConfig *)oZIMQueryCallListConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMCallInvitationSentInfo:(nullable ZIMCallInvitationSentInfo *)info;

+(nullable NSDictionary *)mZIMCallingInvitationSentInfo:(nullable ZIMCallingInvitationSentInfo *)info;

+(nullable NSArray *)mZIMCallInfoList:(nullable NSArray<ZIMCallInfo *> *)callInfoList;

+(nullable ZIMCallCancelConfig *)oZIMCallCancelConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallAcceptConfig *)oZIMCallAcceptConfig:(nullable NSDictionary *)configDic;

+(nullable ZIMCallRejectConfig *)oZIMCallRejectConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mMessageSentStatusChangeInfo:(nullable ZIMMessageSentStatusChangeInfo *)changeInfo;

+(nullable NSArray *)mMessageSentStatusChangeInfoList:(nullable NSArray<ZIMMessageSentStatusChangeInfo *> *)messageSentStatusChangeInfoList;

+(nullable NSDictionary *)mZIMCallUserInfo:(nullable ZIMCallUserInfo *)callUserInfo;

+(nullable NSArray *)mZIMCallUserInfoList:(nullable NSArray<ZIMCallUserInfo *> *)callUserInfoList;

+(nullable NSDictionary *)mZIMCallEndSentInfo:(nullable ZIMCallEndedSentInfo *)info;

+(nullable NSDictionary *)mZIMCallQuitSentInfo:(nullable ZIMCallQuitSentInfo *)info;

+(nullable NSDictionary *)mZIMCallInvitationTimeoutInfo:(nullable ZIMCallInvitationTimeoutInfo *)info;

+(nullable NSDictionary *)mZIMMessageReaction:(nullable ZIMMessageReaction *)reaction;

+(nullable NSDictionary *)mZIMMessageReactionUserInfo:(nullable ZIMMessageReactionUserInfo *)userInfo;

+(nullable NSArray *)mZIMMessageReactionList:(nullable NSArray<ZIMMessageReaction *> *)reactions;

+(nullable NSArray *)mZIMMessageReactionUserInfoList:(nullable NSArray<ZIMMessageReactionUserInfo *> *)userInfoList;

+(nullable ZIMMessageReactionUserQueryConfig *)oZIMMessageReactionUsersQueryConfig:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)mZIMMessageDeletedInfo:(nullable ZIMMessageDeletedInfo *)info;

+(nullable ZIMCallJoinConfig *)oZIMCallJoinConfig:(nullable NSDictionary *)configMap;
@end
