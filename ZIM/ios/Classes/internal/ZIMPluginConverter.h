#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>
#import "NSDictionary+safeInvoke.h"
#import "NSMutableDictionary+safeInvoke.h"
#import "NSMutableArray+safeInvoke.h"
#import "NSObject+safeInvoke.h"
@interface ZIMPluginConverter:NSObject

+(NSDictionary *)cnvZIMErrorObjectToDic:(ZIMError *)errorInfo;

+(NSDictionary *)cnvZIMUserInfoObjectToBasic:(ZIMUserInfo *)userInfo;

+(NSArray *)cnvZIMUserInfoListTobasicList:(NSArray<ZIMUserInfo *> *)userInfoList;

+(ZIMConversation *)cnvZIMConversationDicToObject:(NSDictionary *)conversationDic;

+(ZIMMessage *)cnvZIMMessageDicToObject:(NSDictionary *)messageDic;

+(NSDictionary *)cnvZIMMessageObjectToDic:(ZIMMessage *)message;

+(NSArray *)cnvZIMConversationListObjectToBasic:(NSArray<ZIMConversation *> *)conversationList;

+(ZIMConversationDeleteConfig *)cnvZIMConversationDeleteConfigDicToObject:(NSMutableDictionary *)configDic;

+(NSArray *)cnvConversationChangeInfoListToBasicList:(NSArray<ZIMConversationChangeInfo *> *)conversationChangeInfoList;

+(ZIMMessageSendConfig *)cnvZIMMessageSendConfigDicToObject:(NSDictionary *)configDic;

+(ZIMMessageQueryConfig *)cnvZIMMessageQueryConfigDicToObject:(NSDictionary *)configDic;

+(NSArray *)cnvZIMMessageListToDicList:(NSArray<ZIMMessage *>*)messageList;

+(NSArray<ZIMMessage *>*)cnvBasicListToZIMMessageList:(NSArray *)basicList;

+(ZIMMessageDeleteConfig *)cnvZIMMessageDeleteConfigDicToObject:(NSDictionary *)configDic;

+(ZIMRoomInfo *)cnvZIMRoomInfoBasicToObject:(NSDictionary *)roomInfoDic;

+(NSDictionary *)cnvZIMRoomInfoObjectToBasic:(ZIMRoomInfo *)roomInfo;

+(NSDictionary *)cnvZIMRoomFullInfoObjectToDic:(ZIMRoomFullInfo *)roomFullInfo;

+(ZIMRoomAdvancedConfig *)cnvZIMRoomAdvancedConfigDicToObject:(NSDictionary *)configDic;

+(ZIMRoomMemberQueryConfig *)cnvZIMRoomMemberQueryConfigDicToObject:(NSDictionary *)configDic;

+(ZIMRoomAttributesSetConfig *)cnvZIMRoomAttributesSetConfigDicToObject:(NSDictionary *)configDic;

+(ZIMRoomAttributesDeleteConfig *)cnvZIMRoomAttributesDeleteConfigDicToObject:(NSDictionary *)configDic;

+(ZIMRoomAttributesBatchOperationConfig *)cnvZIMRoomAttributesBatchOperationConfigDicToObject:(NSDictionary *)configDic;

+(NSDictionary *)cnvZIMRoomAttributesUpdateInfoObjectToDic:(ZIMRoomAttributesUpdateInfo *)updateInfo;

+(NSArray *)cnvZIMRoomAttributesUpdateInfoListToBasicList:(NSArray<ZIMRoomAttributesUpdateInfo *> *)updateInfoList;

+(NSDictionary *)cnvZIMGroupInfoObjectToDic:(ZIMGroupInfo *)groupInfo;

+(ZIMGroupInfo *)cnvZIMGroupInfoDicToObject:(NSDictionary *)groupInfoDic;

+(NSDictionary *)cnvZIMGroupMemberInfoObjectToDic:(ZIMGroupMemberInfo *)memberInfo;

+(NSArray *)cnvZIMGroupMemberInfoListToBasicList:(NSArray<ZIMGroupMemberInfo *> *)memberInfoList;

+(NSDictionary *)cnvZIMErrorUserInfoToDic:(ZIMErrorUserInfo *)errorUserInfo;

+(NSArray *)cnvZIMErrorUserInfoListToBasicList:(NSArray<ZIMErrorUserInfo *> *)errorUserInfoList;

+(NSDictionary *)cnvZIMGroupFullInfoObjectToDic:(ZIMGroupFullInfo *)groupFullInfo;

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
