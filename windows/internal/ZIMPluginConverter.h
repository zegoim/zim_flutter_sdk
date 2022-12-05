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

struct ZIM_FriendlyGet_fileUID {
    typedef std::string ZIMMediaMessage::* type;
};

struct ZIM_FriendlyGet_fileName {
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
    static FTMap cnvZIMUserFullInfoObjectToMap(const ZIMUserFullInfo &userFullInfo);
    static FTMap cnvZIMErrorUserInfoToMap(const ZIMErrorUserInfo& errorUserInfo);
    static FTMap cnvZIMErrorObjectToMap(const ZIMError& errorInfo);
    static FTArray cnvZIMUserListToArray(const std::vector<ZIMUserInfo>& userInfoList);
    static FTArray cnvZIMErrorUserListToArray(const std::vector<ZIMErrorUserInfo>& errorUserList);
    static FTArray cnvZIMConversationListToArray(const std::vector<std::shared_ptr<ZIMConversation>> &converationList);
    static FTMap cnvZIMConversationToMap(const std::shared_ptr<ZIMConversation>& conversation);
    static FTArray cnvZIMConversationChangeInfoListToArray(const std::vector<ZIMConversationChangeInfo> &convInfoList);
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
    static FTArray cnvZIMCallUserListToArray(const std::vector<ZIMCallUserInfo>& callUserList);
    static FTMap cnvZIMCallInvitationSentInfoToMap(const ZIMCallInvitationSentInfo& info);

public:
    static ZIMConversationDeleteConfig cnvZIMConversationDeleteConfigToObject(FTMap configMap);
    static std::shared_ptr<ZIMMessage> cnvZIMMessageToObject(FTMap messageMap);
    static std::shared_ptr<ZIMPushConfig> cnvZIMPushConfigToObject(FTMap configMap);
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
public:
    static std::unordered_map<std::string, std::string> cnvFTMapToSTLMap(FTMap map);
    static FTMap cnvSTLMapToFTMap(const std::unordered_map<std::string, std::string>& map);
    static FTArray cnvStlVectorToFTArray(const std::vector<std::string>& vec);
    static FTArray cnvStlVectorToFTArray(const std::vector<long long>& vec);
    static std::vector<std::string> cnvFTArrayToStlVector(FTArray ftArray);
};