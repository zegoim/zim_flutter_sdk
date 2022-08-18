#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
@interface ZIMPluginConverter:NSObject

+(nullable ZIMAppConfig*)cnvZIMAppConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMUserInfoQueryConfig*)cnvZIMUserInfoQueryConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)cnvZIMErrorObjectToDic:(nullable ZIMError *)errorInfo;


+(nullable NSDictionary *)cnvZIMUserFullInfoObjectToBasic:(nullable ZIMUserFullInfo *)userFullInfo;

+(nullable NSDictionary *)cnvZIMUserInfoObjectToBasic:(nullable ZIMUserInfo *)userInfo;

+(nullable NSArray *)cnvZIMUserInfoListTobasicList:(nullable NSArray<ZIMUserInfo *> *)userInfoList;

+(nullable ZIMConversation *)cnvZIMConversationDicToObject:(nullable NSDictionary *)conversationDic;

+(nullable ZIMMessage *)cnvZIMMessageDicToObject:(nullable NSDictionary *)messageDic;

+(nullable NSDictionary *)cnvZIMMessageObjectToDic:(nullable ZIMMessage *)message;

+(nullable NSArray *)cnvZIMConversationListObjectToBasic:(nullable NSArray<ZIMConversation *> *)conversationList;

+(nullable ZIMConversationDeleteConfig *)cnvZIMConversationDeleteConfigDicToObject:(nullable NSMutableDictionary *)configDic;

+(nullable NSArray *)cnvConversationChangeInfoListToBasicList:(nullable NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList;

+(nullable ZIMMessageSendConfig *)cnvZIMMessageSendConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMMessageQueryConfig *)cnvZIMMessageQueryConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSArray *)cnvZIMMessageListToDicList:(nullable NSArray<ZIMMessage *>*)messageList;

+(nullable NSArray<ZIMMessage *>*)cnvBasicListToZIMMessageList:(nullable NSArray *)basicList;

+(nullable ZIMMessageDeleteConfig *)cnvZIMMessageDeleteConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomInfo *)cnvZIMRoomInfoBasicToObject:(nullable NSDictionary *)roomInfoDic;

+(nullable NSDictionary *)cnvZIMRoomInfoObjectToBasic:(nullable ZIMRoomInfo *)roomInfo;

+(nullable NSDictionary *)cnvZIMRoomFullInfoObjectToDic:(nullable ZIMRoomFullInfo *)roomFullInfo;

+(nullable ZIMRoomAdvancedConfig *)cnvZIMRoomAdvancedConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomMemberQueryConfig *)cnvZIMRoomMemberQueryConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesSetConfig *)cnvZIMRoomAttributesSetConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesDeleteConfig *)cnvZIMRoomAttributesDeleteConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMRoomAttributesBatchOperationConfig *)cnvZIMRoomAttributesBatchOperationConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)cnvZIMRoomAttributesUpdateInfoObjectToDic:(nullable ZIMRoomAttributesUpdateInfo *)updateInfo;

+(nullable NSArray *)cnvZIMRoomAttributesUpdateInfoListToBasicList:(nullable NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList;

+(nullable NSDictionary *)cnvZIMGroupInfoObjectToDic:(nullable ZIMGroupInfo *)groupInfo;

+(nullable ZIMGroupInfo *)cnvZIMGroupInfoDicToObject:(nullable NSDictionary *)groupInfoDic;

+(nullable NSDictionary *)cnvZIMGroupMemberInfoObjectToDic:(nullable ZIMGroupMemberInfo *)memberInfo;

+(nullable NSArray *)cnvZIMGroupMemberInfoListToBasicList:(nullable NSArray<ZIMGroupMemberInfo *> *)memberInfoList;

+(nullable NSDictionary *)cnvZIMErrorUserInfoToDic:(nullable ZIMErrorUserInfo *)errorUserInfo;

+(nullable NSArray *)cnvZIMErrorUserInfoListToBasicList:(nullable NSArray<ZIMErrorUserInfo *> *)errorUserInfoList;

+(nullable NSDictionary *)cnvZIMGroupFullInfoObjectToDic:(nullable ZIMGroupFullInfo *)groupFullInfo;

+(nullable NSDictionary *)cnvZIMGroupAdvancedConfigObjectToDic:(nullable ZIMGroupAdvancedConfig *)config;

+(nullable ZIMGroupAdvancedConfig *)cnvZIMGroupAdvancedConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSDictionary*)cnvZIMGroupObjectToDic:(nullable ZIMGroup *)group;

+(nullable NSArray*)cnvZIMGroupListToBasicList:(nullable NSArray<ZIMGroup *> *)groupList;

+(nullable NSDictionary *)cnvZIMGroupMemberQueryConfigObjectToDic:(nullable ZIMGroupMemberQueryConfig *)config;

+(nullable ZIMGroupMemberQueryConfig *)cnvZIMGroupMemberQueryConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)cnvZIMGroupOperatedInfoObjectToDic:(nullable ZIMGroupOperatedInfo *)operatedInfo;

+(nullable NSDictionary *)cnvZIMGroupAttributesUpdateInfoObjectToDic:(nullable ZIMGroupAttributesUpdateInfo *)updateInfo;

+(nullable NSArray *)cnvZIMGroupAttributesUpdateInfoListToBasicList:(nullable NSArray<ZIMGroupAttributesUpdateInfo *> *)updateInfoList;

+(nullable ZIMCallInviteConfig *)cnvZIMCallInviteConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable NSDictionary *)cnvZIMCallInvitationSentInfoObjectToDic:(nullable ZIMCallInvitationSentInfo *)info;

+(nullable ZIMCallCancelConfig *)cnvZIMCallCancelConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMCallAcceptConfig *)cnvZIMCallAcceptConfigDicToObject:(nullable NSDictionary *)configDic;

+(nullable ZIMCallRejectConfig *)cnvZIMCallRejectConfigDicToObject:(nullable NSDictionary *)configDic;

@end
