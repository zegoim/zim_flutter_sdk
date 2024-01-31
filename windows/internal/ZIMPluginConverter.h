#pragma once

#include <memory>

#include <flutter/encodable_value.h>

#include <ZIM.h>
using namespace zim;

#define FTValue(varName) flutter::EncodableValue(varName)
#define FTMap flutter::EncodableMap
#define FTArray flutter::EncodableList

template<typename Tag, typename Tag::type M>
struct Rob {
    friend typename Tag::type get(Tag) {
        return M;
    }
};

struct ZIM_FriendlyGet_msgType {
    typedef ZIMMessageType ZIMMessage::* type;
};

struct ZIM_FriendlyGet_messageID {
    typedef long long ZIMMessage::* type;
};

struct ZIM_FriendlyGet_localMessageID {
    typedef long long ZIMMessage::* type;
};

struct ZIM_FriendlyGet_senderUserID {
    typedef std::string ZIMMessage::* type;
};

struct ZIM_FriendlyGet_conversationID {
    typedef std::string ZIMMessage::* type;
};

struct ZIM_FriendlyGet_conversationType {
    typedef ZIMConversationType ZIMMessage::* type;
};

struct ZIM_FriendlyGet_conversationSeq {
    typedef long long ZIMMessage::* type;
};

struct ZIM_FriendlyGet_direction {
    typedef ZIMMessageDirection ZIMMessage::* type;
};

struct ZIM_FriendlyGet_sentStatus {
    typedef ZIMMessageSentStatus ZIMMessage::* type;
};

struct ZIM_FriendlyGet_timestamp {
    typedef unsigned long long ZIMMessage::* type;
};

struct ZIM_FriendlyGet_orderKey {
    typedef long long ZIMMessage::* type;
};

struct ZIM_FriendlyGet_isUserInserted {
    typedef bool ZIMMessage::* type;
};

struct ZIM_FriendlyGet_isBroadcastMessage {
    typedef bool ZIMMessage::* type;
};

struct ZIM_FriendlyGet_fileUID {
    typedef std::string ZIMMediaMessage::* type;
};

struct ZIM_FriendlyGet_fileSize {
    typedef long long ZIMMediaMessage::* type;
};

struct ZIM_FriendlyGet_largeImageLocalPath {
    typedef std::string ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_thumbnailLocalPath {
    typedef std::string ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_videoFirstFrameLocalPath {
    typedef std::string ZIMVideoMessage::* type;
};

struct ZIM_FriendlyGet_originalImageWidth {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_originalImageHeight {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_largeImageWidth {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_largeImageHeight {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_thumbnailWidth {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_thumbnailHeight {
    typedef unsigned int ZIMImageMessage::* type;
};

struct ZIM_FriendlyGet_videoFirstFrameWidth {
    typedef unsigned int ZIMVideoMessage::* type;
};

struct ZIM_FriendlyGet_videoFirstFrameHeight {
    typedef unsigned int ZIMVideoMessage::* type;
};

struct ZIM_FriendlyGet_revokeType {
    typedef ZIMRevokeType ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_revokeTimestamp {
    typedef unsigned long long ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_originalMessageType {
    typedef ZIMMessageType ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_revokeStatus {
    typedef ZIMMessageRevokeStatus ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_operatedUserID {
    typedef std::string ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_originalTextMessageContent {
    typedef std::string ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_revokeExtendedData {
    typedef std::string ZIMRevokeMessage::* type;
};

struct ZIM_FriendlyGet_combineID {
	typedef std::string ZIMCombineMessage::* type;
};

struct ZIM_FriendlyGet_receiptStatus {
    typedef ZIMMessageReceiptStatus ZIMMessage::* type;
};


class ZIMPluginConverter
{
public:
    ~ZIMPluginConverter() {}
    ZIMPluginConverter() {}

public:
    static FTMap cnvZIMUserInfoObjectToMap(const ZIMUserInfo& userInfo);
    static FTMap cnvZIMRoomMemberInfoObjectToMap(const ZIMRoomMemberInfo& userInfo);
    static FTMap cnvZIMUserFullInfoObjectToMap(const ZIMUserFullInfo &userFullInfo);
    static FTMap cnvZIMErrorUserInfoToMap(const ZIMErrorUserInfo& errorUserInfo);
    static FTArray cnvZIMErrorUserInfoListToArray(const std::vector<ZIMErrorUserInfo>& errorUserInfoList);
    static FTMap cnvZIMErrorObjectToMap(const ZIMError& errorInfo);
    static FTArray cnvZIMUserListToArray(const std::vector<ZIMUserInfo>& userInfoList);
    static FTArray cnvZIMFriendInfoToArray(const std::vector<ZIMFriendInfo>& infoList);
    static FTArray cnvZIMFriendApplicationInfoToArray(const std::vector<ZIMFriendApplicationInfo>& infoList);
    static FTArray cnvZIMRoomMemberInfoListToArray(const std::vector<ZIMRoomMemberInfo>& roomMemberInfoList);
    static FTArray cnvZIMErrorUserListToArray(const std::vector<ZIMErrorUserInfo>& errorUserList);
    static FTArray cnvZIMConversationListToArray(const std::vector<std::shared_ptr<ZIMConversation>> &converationList);
    static FTMap cnvZIMConversationToMap(const std::shared_ptr<ZIMConversation>& conversation);
    static FTArray cnvZIMConversationChangeInfoListToArray(const std::vector<ZIMConversationChangeInfo> &convInfoList);
    static FTArray cnvZIMMessageSentStatusChangeInfoListToArray(const std::vector<ZIMMessageSentStatusChangeInfo>& messageSentStatusChangeInfoList);
    static flutter::EncodableValue cnvZIMMessageObjectToMap(ZIMMessage* message);
    static FTArray cnvZIMMessageListToArray(const std::vector<std::shared_ptr<ZIMMessage>>& messageList);
    static FTMap cnvZIMMessageReceiptInfoToMap(const ZIMMessageReceiptInfo& messageReceiptInfo);
    static FTArray cnvZIMMessageReceiptInfoListToArray(const std::vector<ZIMMessageReceiptInfo>& infos);
    static FTMap cnvZIMRoomInfoToMap(const ZIMRoomInfo& roomInfo);
    static FTMap cnvZIMRoomFullInfoToMap(const ZIMRoomFullInfo& roomInfo);
    static FTMap cnvZIMRoomAttributesUpdateInfoToMap(const ZIMRoomAttributesUpdateInfo& updateInfo);
    static FTArray cnvZIMRoomAttributesUpdateInfoListToArray(const std::vector<ZIMRoomAttributesUpdateInfo>& updateInfoList);
    static FTMap cnvZIMRoomMemberAttributesInfoToMap(const ZIMRoomMemberAttributesInfo& info);
    static FTMap cnvZIMRoomMemberAttributesOperatedInfoToMap(const ZIMRoomMemberAttributesOperatedInfo& info);
    static FTMap cnvZIMRoomMemberAttributesUpdateInfoToMap(const ZIMRoomMemberAttributesUpdateInfo& info);
    static FTMap cnvZIMRoomOperatedInfoToMap(const ZIMRoomOperatedInfo& info);
    static FTArray cnvZIMGroupMemberInfoListToArray(const std::vector<ZIMGroupMemberInfo>& memberList);
    static FTMap cnvZIMGroupMessageReceiptMemberQueryConfigToMap(const ZIMGroupMessageReceiptMemberQueryConfig& config);
    static FTMap cnvZIMGroupFullInfoToMap(const ZIMGroupFullInfo& groupInfo);
    static FTMap cnvZIMGroupMemberInfoToMap(const ZIMGroupMemberInfo& memberInfo);
    static FTMap cnvZIMGroupInfoToMap(const ZIMGroupInfo& groupInfo);
    static FTArray cnvZIMGroupListToArray(const std::vector<ZIMGroup>& groupList);
    static FTMap cnvZIMGroupOperatedInfoToMap(const ZIMGroupOperatedInfo& info);
    static FTMap cnvZIMGroupAttributesUpdateInfoToMap(const ZIMGroupAttributesUpdateInfo& updateInfo);
    static FTArray cnvZIMGroupAttributesUpdateInfoListToArray(const std::vector<ZIMGroupAttributesUpdateInfo>& updateInfoList);
    static FTMap cnvZIMCallUserInfoToMap(const ZIMCallUserInfo& userInfo);
    static FTMap cnvZIMCallInfoToMap(const ZIMCallInfo& userInfo);
    static FTMap cnvZIMCallInvitationCreatedInfoToMap(const ZIMCallInvitationCreatedInfo& info);
    static FTMap cnvZIMCallEndSentInfoToMap(const ZIMCallEndedSentInfo& callEndSentInfo);
    static FTMap cnvZIMCallJoinSentInfoToMap(const ZIMCallJoinSentInfo& callJoinSentInfo);
    static FTMap cnvZIMCallQuitSentInfoToMap(const ZIMCallQuitSentInfo& callQuitSentInfo);
    static FTArray cnvZIMCallUserInfoListToArray(const std::vector<ZIMCallUserInfo>& callUserList);
    static FTMap cnvZIMCallInvitationSentInfoToMap(const ZIMCallInvitationSentInfo& info);
    static FTMap cnvZIMCallingInvitationSentInfoToMap(const ZIMCallingInvitationSentInfo& info);
    static FTMap cnvZIMCallInvitationEndedInfoToMap(const ZIMCallInvitationEndedInfo& info);
    static FTMap cnvZIMCallUserStateChangedInfoToMap(const ZIMCallUserStateChangeInfo& info);
    static FTMap cnvZIMCallInvitationTimeoutInfoToMap(const ZIMCallInvitationTimeoutInfo& info);
    static FTArray cnvZIMConversationSearchInfoListToArray(const std::vector<ZIMConversationSearchInfo>& conversationSearchInfoList);
    static FTMap cnvZIMConversationsAllDeletedInfoToMap(const ZIMConversationsAllDeletedInfo& info);
    static FTArray cnvZIMGroupSearchInfoListToArray(const std::vector<ZIMGroupSearchInfo>& groupSearchInfoList);
    static FTMap cnvZIMMessageReactionToMap(const ZIMMessageReaction& reaction);
    static FTMap cnvZIMMessageReactionUserInfoToMap(const ZIMMessageReactionUserInfo& userInfo);
    static FTArray cnvZIMMessageReactionListToArray(const std::vector<ZIMMessageReaction>& reactionList);
    static FTArray cnvZIMMessageReactionUserInfoListToArray(const std::vector<ZIMMessageReactionUserInfo>& reactionUserInfoList);
    static FTMap cnvZIMMessageDeletedInfoToMap(const ZIMMessageDeletedInfo& info);
    static FTMap cnvZIMGroupMuteInfoToMap(const ZIMGroupMuteInfo& info);
    static FTMap cnvZIMFriendApplicationInfoToMap(const ZIMFriendApplicationInfo& info);
    static FTMap cnvZIMFriendInfoToMap(const ZIMFriendInfo& info);
    static FTMap cnvZIMFriendRelationInfoToMap(const ZIMFriendRelationInfo& info);
    static FTMap cnvZIMFriendSearchConfigToObject(FTMap configMap);
public:
    static ZIMConversationDeleteConfig cnvZIMConversationDeleteConfigToObject(FTMap configMap);
    static std::shared_ptr<ZIMConversation> cnvZIMConversationToObject(FTMap conversationMap);
    static std::shared_ptr<ZIMMessage> cnvZIMMessageToObject(FTMap messageMap);
    static ZIMLoginConfig cnvZIMLoginConfigToObject(FTMap configMap);
    static std::shared_ptr<ZIMPushConfig> cnvZIMPushConfigToObject(FTMap configMap, std::shared_ptr<ZIMVoIPConfig> &voIPConfigPtr);
    static std::vector<std::shared_ptr<ZIMMessage>> cnvZIMMessageArrayToObjectList(FTArray messageArray);
    static ZIMRoomInfo cnvZIMRoomInfoToObject(FTMap infoMap);
    static ZIMRoomAdvancedConfig cnvZIMRoomAdvancedConfigToObject(FTMap configMap);
    static ZIMRoomMemberQueryConfig cnvZIMRoomMemberQueryConfigToObject(FTMap configMap);
    static ZIMRoomAttributesSetConfig cnvZIMRoomAttributesSetConfigToObject(FTMap configMap);
    static ZIMRoomAttributesDeleteConfig cnvZIMRoomAttributesDeleteConfigToObject(FTMap configMap);
    static ZIMRoomAttributesBatchOperationConfig cnvZIMRoomAttributesBatchOperationConfigToObject(FTMap configMap);
    static ZIMRoomMemberAttributesSetConfig cnvZIMRoomMemberAttributesSetConfigToObject(FTMap configMap);
    static ZIMRoomMemberAttributesQueryConfig cnvZIMRoomMemberAttributesQueryConfigToObject(FTMap configMap);
    static ZIMGroupInfo cnvZIMGroupInfoToObject(FTMap infoMap);
    static ZIMGroupAdvancedConfig cnvZIMGroupAdvancedConfigToObject(FTMap configMap);
    static ZIMGroupMemberQueryConfig cnvZIMGroupMemberQueryConfigToObject(FTMap configMap);
    static ZIMGroupMessageReceiptMemberQueryConfig cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(FTMap configMap);
    static ZIMMessageSearchConfig cnvZIMMessageSearchConfigMapToObject(FTMap configMap);
    static ZIMConversationSearchConfig cnvZIMConversationSearchConfigMapToObject(FTMap configMap);
    static ZIMGroupSearchConfig cnvZIMGroupSearchConfigMapToObject(FTMap configMap);
    static ZIMGroupMemberSearchConfig cnvZIMGroupMemberSearchConfigMapToObject(FTMap configMap);
    static ZIMMessageReactionUserQueryConfig cnvZIMMessageReactionUserQueryConfigMapToObject(FTMap configMap);
    static std::shared_ptr<ZIMVoIPConfig> cnvZIMVoIPConfigConfigToObject(FTMap configMap);
    static ZIMBlacklistQueryConfig cnvZIMBlacklistQueryConfigToObject(FTMap configMap);
    static ZIMGroupMuteConfig cnvZIMGroupMuteConfigToObject(FTMap configMap);
    static ZIMGroupMemberMuteConfig cnvZIMGroupMemberMuteConfigToObject(FTMap configMap);
    static ZIMGroupMemberMutedListQueryConfig cnvZIMGroupMemberMutedListQueryConfigToBbject(FTMap configMap);
    
public:
    static ZIMFriendAddConfig cnvZIMFriendAddConfigToObject(FTMap configMap);
    static ZIMFriendApplicationAcceptConfig cnvZIMFriendApplicationAcceptConfigToObject(FTMap configMap);
    static ZIMFriendApplicationInfo cnvZIMFriendApplicationInfoToObject(FTMap configMap);
    static ZIMUserInfo cnvZIMUserInfoToObject(FTMap infoMap);
    static ZIMFriendApplicationListQueryConfig cnvZIMFriendApplicationListQueryConfigToObject(FTMap infoMap);
    static ZIMFriendApplicationRejectConfig cnvZIMFriendApplicationRejectConfigToObject(FTMap infoMap);
    static ZIMFriendDeleteConfig cnvZIMFriendDeleteConfigToObject(FTMap infoMap);
    static ZIMFriendInfo cnvZIMFriendInfoToObject(FTMap infoMap);
    static ZIMFriendListQueryConfig cnvZIMFriendListQueryConfigToObject(FTMap infoMap);
    static ZIMFriendApplicationSendConfig cnvZIMFriendApplicationSendConfigToObject(FTMap infoMap);
    static ZIMFriendRelationInfo cnvZIMFriendRelationInfoToObject(FTMap infoMap);

    static std::unordered_map<std::string, std::string> cnvFTMapToSTLMap(FTMap map);
    static int32_t cnvFTMapToInt32(flutter::EncodableValue value);
    static int64_t cnvFTMapToInt64(flutter::EncodableValue value);
    static FTMap cnvSTLMapToFTMap(const std::unordered_map<std::string, std::string>& map);
    static FTArray cnvStlVectorToFTArray(const std::vector<std::string>& vec);
    static FTArray cnvStlVectorToFTArray(const std::vector<long long>& vec);
    static FTArray cnvStlVectorToFTArray(const std::vector<int>& vec);
    static std::vector<std::string> cnvFTArrayToStlVector(FTArray ftArray);
    static std::vector<ZIMGroupMemberRole> cnvFTArrayToStlVectorInt(FTArray ftArray);
    static FTArray cnvZIMMessageMentionedInfoToMap(const std::vector<ZIMMessageMentionedInfo>& infoList);
};