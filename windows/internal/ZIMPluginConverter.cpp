#include "ZIMPluginConverter.h"

ZIMMessageType ZIMMessage::*get(ZIM_FriendlyGet_msgType);
template struct Rob<ZIM_FriendlyGet_msgType, &ZIMMessage::type>;

long long ZIMMessage::*get(ZIM_FriendlyGet_messageID);
template struct Rob<ZIM_FriendlyGet_messageID, &ZIMMessage::messageID>;

long long ZIMMessage::*get(ZIM_FriendlyGet_localMessageID);
template struct Rob<ZIM_FriendlyGet_localMessageID, &ZIMMessage::localMessageID>;

std::string ZIMMessage::*get(ZIM_FriendlyGet_senderUserID);
template struct Rob<ZIM_FriendlyGet_senderUserID, &ZIMMessage::senderUserID>;

std::string ZIMMessage::*get(ZIM_FriendlyGet_cbInnerID);
template struct Rob<ZIM_FriendlyGet_cbInnerID, &ZIMMessage::cbInnerID>;

std::string ZIMMessage::*get(ZIM_FriendlyGet_conversationID);
template struct Rob<ZIM_FriendlyGet_conversationID, &ZIMMessage::conversationID>;

ZIMConversationType ZIMMessage::*get(ZIM_FriendlyGet_conversationType);
template struct Rob<ZIM_FriendlyGet_conversationType, &ZIMMessage::conversationType>;

long long ZIMMessage::*get(ZIM_FriendlyGet_conversationSeq);
template struct Rob<ZIM_FriendlyGet_conversationSeq, &ZIMMessage::conversationSeq>;

long long ZIMMessage::*get(ZIM_FriendlyGet_messageSeq);
template struct Rob<ZIM_FriendlyGet_messageSeq, &ZIMMessage::messageSeq>;

ZIMMessageDirection ZIMMessage::*get(ZIM_FriendlyGet_direction);
template struct Rob<ZIM_FriendlyGet_direction, &ZIMMessage::direction>;

ZIMMessageSentStatus ZIMMessage::*get(ZIM_FriendlyGet_sentStatus);
template struct Rob<ZIM_FriendlyGet_sentStatus, &ZIMMessage::sentStatus>;

unsigned long long ZIMMessage::*get(ZIM_FriendlyGet_timestamp);
template struct Rob<ZIM_FriendlyGet_timestamp, &ZIMMessage::timestamp>;

long long ZIMMessage::*get(ZIM_FriendlyGet_orderKey);
template struct Rob<ZIM_FriendlyGet_orderKey, &ZIMMessage::orderKey>;

bool ZIMMessage::*get(ZIM_FriendlyGet_isUserInserted);
template struct Rob<ZIM_FriendlyGet_isUserInserted, &ZIMMessage::userInserted>;

bool ZIMMessage::*get(ZIM_FriendlyGet_isBroadcastMessage);
template struct Rob<ZIM_FriendlyGet_isBroadcastMessage, &ZIMMessage::broadcastMessage>;

bool ZIMMessage::*get(ZIM_FriendlyGet_isServerMessage);
template struct Rob<ZIM_FriendlyGet_isServerMessage, &ZIMMessage::broadcastMessage>;

std::shared_ptr<ZIMMessageRepliedInfo> ZIMMessage::*get(ZIM_FriendlyGet_repliedInfo);
template struct Rob<ZIM_FriendlyGet_repliedInfo, &ZIMMessage::repliedInfo>;

int ZIMMessage::*get(ZIM_FriendlyGet_rootRepliedCount);
template struct Rob<ZIM_FriendlyGet_rootRepliedCount, &ZIMMessage::rootRepliedCount>;

std::string ZIMMediaMessage::*get(ZIM_FriendlyGet_fileUID);
template struct Rob<ZIM_FriendlyGet_fileUID, &ZIMMediaMessage::fileUID>;

long long ZIMMediaMessage::*get(ZIM_FriendlyGet_fileSize);
template struct Rob<ZIM_FriendlyGet_fileSize, &ZIMMediaMessage::fileSize>;

std::string ZIMImageMessage::*get(ZIM_FriendlyGet_largeImageLocalPath);
template struct Rob<ZIM_FriendlyGet_largeImageLocalPath, &ZIMImageMessage::largeImageLocalPath>;

std::string ZIMImageMessage::*get(ZIM_FriendlyGet_thumbnailLocalPath);
template struct Rob<ZIM_FriendlyGet_thumbnailLocalPath, &ZIMImageMessage::thumbnailLocalPath>;

std::string ZIMVideoMessage::*get(ZIM_FriendlyGet_videoFirstFrameLocalPath);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameLocalPath,
                    &ZIMVideoMessage::videoFirstFrameLocalPath>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_originalImageWidth);
template struct Rob<ZIM_FriendlyGet_originalImageWidth, &ZIMImageMessage::originalImageWidth>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_originalImageHeight);
template struct Rob<ZIM_FriendlyGet_originalImageHeight, &ZIMImageMessage::originalImageHeight>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_largeImageWidth);
template struct Rob<ZIM_FriendlyGet_largeImageWidth, &ZIMImageMessage::largeImageWidth>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_largeImageHeight);
template struct Rob<ZIM_FriendlyGet_largeImageHeight, &ZIMImageMessage::largeImageHeight>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_thumbnailWidth);
template struct Rob<ZIM_FriendlyGet_thumbnailWidth, &ZIMImageMessage::thumbnailWidth>;

unsigned int ZIMImageMessage::*get(ZIM_FriendlyGet_thumbnailHeight);
template struct Rob<ZIM_FriendlyGet_thumbnailHeight, &ZIMImageMessage::thumbnailHeight>;

unsigned int ZIMVideoMessage::*get(ZIM_FriendlyGet_videoFirstFrameWidth);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameWidth, &ZIMVideoMessage::videoFirstFrameWidth>;

unsigned int ZIMVideoMessage::*get(ZIM_FriendlyGet_videoFirstFrameHeight);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameHeight, &ZIMVideoMessage::videoFirstFrameHeight>;

ZIMRevokeType ZIMRevokeMessage::*get(ZIM_FriendlyGet_revokeType);
template struct Rob<ZIM_FriendlyGet_revokeType, &ZIMRevokeMessage::revokeType>;

unsigned long long ZIMRevokeMessage::*get(ZIM_FriendlyGet_revokeTimestamp);
template struct Rob<ZIM_FriendlyGet_revokeTimestamp, &ZIMRevokeMessage::revokeTimestamp>;

ZIMMessageType ZIMRevokeMessage::*get(ZIM_FriendlyGet_originalMessageType);
template struct Rob<ZIM_FriendlyGet_originalMessageType, &ZIMRevokeMessage::originalMessageType>;

ZIMMessageRevokeStatus ZIMRevokeMessage::*get(ZIM_FriendlyGet_revokeStatus);
template struct Rob<ZIM_FriendlyGet_revokeStatus, &ZIMRevokeMessage::revokeStatus>;

std::string ZIMRevokeMessage::*get(ZIM_FriendlyGet_operatedUserID);
template struct Rob<ZIM_FriendlyGet_operatedUserID, &ZIMRevokeMessage::operatedUserID>;

std::string ZIMRevokeMessage::*get(ZIM_FriendlyGet_originalTextMessageContent);
template struct Rob<ZIM_FriendlyGet_originalTextMessageContent,
                    &ZIMRevokeMessage::originalTextMessageContent>;

std::string ZIMRevokeMessage::*get(ZIM_FriendlyGet_revokeExtendedData);
template struct Rob<ZIM_FriendlyGet_revokeExtendedData, &ZIMRevokeMessage::revokeExtendedData>;

std::string ZIMCombineMessage::*get(ZIM_FriendlyGet_combineID);
template struct Rob<ZIM_FriendlyGet_combineID, &ZIMCombineMessage::combineID>;

ZIMMessageReceiptStatus ZIMMessage::*get(ZIM_FriendlyGet_receiptStatus);
template struct Rob<ZIM_FriendlyGet_receiptStatus, &ZIMMessage::receiptStatus>;

std::unordered_map<std::string, std::string> ZIMPluginConverter::cnvFTMapToSTLMap(FTMap ftMap) {
    std::unordered_map<std::string, std::string> stlMap;
    for (auto &ftObj : ftMap) {
        auto key = std::get<std::string>(ftObj.first);
        auto value = std::get<std::string>(ftObj.second);

        stlMap[key] = value;
    }

    return stlMap;
}

int32_t ZIMPluginConverter::cnvFTValueToInt32(flutter::EncodableValue value) {
    int32_t num = 0;
    if (std::holds_alternative<int32_t>(value)) {
        num = std::get<int32_t>(value);
    } else if (std::holds_alternative<int64_t>(value)) {
        num = (int32_t)std::get<int64_t>(value);
    }
    return num;
}

int64_t ZIMPluginConverter::cnvFTValueToInt64(flutter::EncodableValue value) {
    int64_t num = 0;
    if (std::holds_alternative<int32_t>(value)) {
        num = (int64_t)std::get<int32_t>(value);
    } else if (std::holds_alternative<int64_t>(value)) {
        num = std::get<int64_t>(value);
    }
    return num;
}

FTMap ZIMPluginConverter::cnvSTLMapToFTMap(
    const std::unordered_map<std::string, std::string> &map) {
    FTMap ftMap;
    for (auto &obj : map) {
        auto key = FTValue(obj.first);
        auto value = FTValue(obj.second);

        ftMap[key] = value;
    }

    return ftMap;
}

FTArray ZIMPluginConverter::cnvStlVectorToFTArray(const std::vector<long long> &vec) {
    FTArray ftArray;
    for (auto &value : vec) {
        ftArray.emplace_back(FTValue((int64_t)value));
    }

    return ftArray;
}

FTArray ZIMPluginConverter::cnvStlVectorToFTArray(const std::vector<int> &vec) {
    FTArray ftArray;
    for (auto &value : vec) {
        ftArray.emplace_back(FTValue((int32_t)value));
    }

    return ftArray;
}

FTArray ZIMPluginConverter::cnvStlVectorToFTArray(const std::vector<std::string> &vec) {
    FTArray ftArray;
    for (auto &str : vec) {
        ftArray.emplace_back(FTValue(str));
    }

    return ftArray;
}

std::vector<std::string> ZIMPluginConverter::cnvFTArrayToStlVector(FTArray ftArray) {
    std::vector<std::string> vec;
    for (auto &strObj : ftArray) {
        auto str = std::get<std::string>(strObj);
        vec.emplace_back(str);
    }

    return vec;
}

std::vector<int> ZIMPluginConverter::cnvFTArrayToStlVectorIntValue(FTArray ftArray) {
    std::vector<int> vec;
    for (auto &intObj : ftArray) {
        auto intValue = std::get<int32_t>(intObj);
        vec.emplace_back(intValue);
    }
    return vec;
}

std::vector<long long> ZIMPluginConverter::cnvFTArrayToInt64Vec(FTArray ftArray) {
    std::vector<long long> vec;
    for (auto &intObj : ftArray) {
        auto intValue = cnvFTValueToInt64(intObj);
        vec.emplace_back(intValue);
    }
    return vec;
}

std::vector<ZIMGroupMemberRole> ZIMPluginConverter::cnvFTArrayToStlVectorInt(FTArray ftArray) {
    std::vector<ZIMGroupMemberRole> vec;
    for (auto &intObj : ftArray) {
        auto intValue = cnvFTValueToInt32(intObj);
        vec.emplace_back(intValue);
    }
    return vec;
}

FTMap ZIMPluginConverter::cnvZIMMessageRootRepliedCountInfoToMap(
    const ZIMMessageRootRepliedCountInfo &info) {

    FTMap infoMap;
    infoMap[FTValue("conversationID")] = FTValue(info.conversationID);
    infoMap[FTValue("conversationType")] = FTValue(info.conversationType);
    infoMap[FTValue("messageID")] = FTValue(info.messageID);
    infoMap[FTValue("count")] = FTValue(static_cast<int32_t>(info.count));

    return infoMap;
}

FTArray ZIMPluginConverter::cnvZIMMessageRootRepliedCountInfoListToArray(
    const std::vector<ZIMMessageRootRepliedCountInfo> &infos) {

    FTArray infoArray;

    for (const auto &info : infos) {
        infoArray.emplace_back(cnvZIMMessageRootRepliedCountInfoToMap(info));
    }

    return infoArray;
}

zim::ZIMConversationBaseInfo ZIMPluginConverter::oZIMConversationBaseInfo(FTMap ftmap) {
    auto convID = std::get<std::string>(ftmap[FTValue("conversationID")]);
    auto convType =
        static_cast<ZIMConversationType>(cnvFTValueToInt32(ftmap[FTValue("conversationType")]));

    return ZIMConversationBaseInfo(convID, convType);
}

std::vector<zim::ZIMConversationBaseInfo>
ZIMPluginConverter::oZIMConversationBaseInfoList(FTArray ftArray) {
    std::vector<zim::ZIMConversationBaseInfo> infos;

    for (auto &info : ftArray) {
        infos.emplace_back(oZIMConversationBaseInfo(std::get<FTMap>(info)));
    }

    return infos;
}

FTMap ZIMPluginConverter::mZIMConversationBaseInfo(const ZIMConversationBaseInfo &info) {
    FTMap convBaseInfoMap;

    convBaseInfoMap[FTValue("conversationID")] = FTValue(info.conversationID);
    convBaseInfoMap[FTValue("conversationType")] = FTValue(info.conversationType);

    return convBaseInfoMap;
}

FTArray ZIMPluginConverter::aZIMConversationBaseInfoList(
    const std::vector<ZIMConversationBaseInfo> &infos) {
    FTArray infoList;

    for (const auto &info : infos) {
        infoList.emplace_back(mZIMConversationBaseInfo(info));
    }

    return infoList;
}

zim::ZIMConversationFilterOption ZIMPluginConverter::oZIMConversationFilterOption(FTMap ftmap) {

    zim::ZIMConversationFilterOption option;

    FTArray markArray = std::get<FTArray>(ftmap[FTValue("marks")]);
    for (auto &intObj : markArray) {
        auto intValue = std::get<int32_t>(intObj);
        option.marks.emplace_back(intValue);
    }
    FTArray convTypeArray = std::get<FTArray>(ftmap[FTValue("conversationTypes")]);
    for (auto &intObj : convTypeArray) {
        auto intValue = std::get<int32_t>(intObj);
        option.conversationTypes.emplace_back(static_cast<ZIMConversationType>(intValue));
    }
    option.isOnlyUnreadConversation = std::get<bool>(ftmap[FTValue("isOnlyUnreadConversation")]);
    return option;
}

zim::ZIMConversationTotalUnreadMessageCountQueryConfig
ZIMPluginConverter::oZIMConversationTotalUnreadCountQueryConfig(FTMap ftmap) {

    zim::ZIMConversationTotalUnreadMessageCountQueryConfig config;

    FTArray markArray = std::get<FTArray>(ftmap[FTValue("marks")]);
    for (auto &intObj : markArray) {
        auto intValue = std::get<int32_t>(intObj);
        config.marks.emplace_back(intValue);
    }
    FTArray convTypeArray = std::get<FTArray>(ftmap[FTValue("conversationTypes")]);
    for (auto &intObj : convTypeArray) {
        auto intValue = std::get<int32_t>(intObj);
        config.conversationTypes.emplace_back(static_cast<ZIMConversationType>(intValue));
    }
    return config;
}

FTMap ZIMPluginConverter::cnvZIMUserInfoObjectToMap(const ZIMUserInfo &userInfo) {
    FTMap userInfoMap;
    userInfoMap[FTValue("userID")] = FTValue(userInfo.userID);
    userInfoMap[FTValue("userName")] = FTValue(userInfo.userName);
    userInfoMap[FTValue("userAvatarUrl")] = FTValue(userInfo.userAvatarUrl);

    return userInfoMap;
}

flutter::EncodableValue
ZIMPluginConverter::cnvZIMUserInfoPtrToObj(const std::shared_ptr<ZIMUserInfo> userPtr) {
    if (!userPtr) {
        return FTValue(std::monostate());
    }

    auto notConstUserPtr = std::const_pointer_cast<ZIMUserInfo>(userPtr);
    FTMap userInfoMap;
    userInfoMap[FTValue("userID")] = FTValue(userPtr->userID);
    userInfoMap[FTValue("userName")] = FTValue(userPtr->userName);
    userInfoMap[FTValue("userAvatarUrl")] = FTValue(userPtr->userAvatarUrl);

    auto groupMemberSimpleInfo =
        std::dynamic_pointer_cast<ZIMGroupMemberSimpleInfo>(notConstUserPtr);
    if (groupMemberSimpleInfo) {
        userInfoMap[FTValue("memberNickname")] = FTValue(groupMemberSimpleInfo->memberNickname);
        userInfoMap[FTValue("memberRole")] = FTValue(groupMemberSimpleInfo->memberRole);
        userInfoMap[FTValue("classType")] = FTValue("ZIMGroupMemberSimpleInfo");
    }

    auto groupMemberInfo = std::dynamic_pointer_cast<ZIMGroupMemberInfo>(notConstUserPtr);
    if (groupMemberInfo) {
        userInfoMap[FTValue("memberNickname")] = FTValue(groupMemberInfo->memberNickname);
        userInfoMap[FTValue("memberRole")] = FTValue(groupMemberInfo->memberRole);
        userInfoMap[FTValue("memberAvatarUrl")] = FTValue(groupMemberInfo->memberAvatarUrl);
        userInfoMap[FTValue("muteExpiredTime")] = FTValue(groupMemberInfo->muteExpiredTime);
        userInfoMap[FTValue("classType")] = FTValue("ZIMGroupMemberInfo");
    }

    auto friendInfo = std::dynamic_pointer_cast<ZIMFriendInfo>(notConstUserPtr);
    if (friendInfo) {
        userInfoMap[FTValue("friendAlias")] = FTValue(friendInfo->friendAlias);
        userInfoMap[FTValue("createTime")] = FTValue(friendInfo->createTime);
        userInfoMap[FTValue("wording")] = FTValue(friendInfo->wording);
        userInfoMap[FTValue("friendAttributes")] = cnvSTLMapToFTMap(friendInfo->friendAttributes);
        userInfoMap[FTValue("classType")] = FTValue("ZIMFriendInfo");
    }
    return userInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMUserInfoPtrListToArray(
    const std::vector<std::shared_ptr<ZIMUserInfo>> userInfoList) {
    FTArray userInfoListArray;

    for (const auto &userInfo : userInfoList) {
        userInfoListArray.emplace_back(cnvZIMUserInfoPtrToObj(userInfo));
    }

    return userInfoListArray;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberInfoObjectToMap(const ZIMRoomMemberInfo &userInfo) {
    FTMap userInfoMap;
    userInfoMap[FTValue("userID")] = FTValue(userInfo.userID);
    userInfoMap[FTValue("userName")] = FTValue(userInfo.userName);

    return userInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMUserFullInfoObjectToMap(const ZIMUserFullInfo &userFullInfo) {
    FTMap userFullInfoMap;
    userFullInfoMap[FTValue("baseInfo")] = cnvZIMUserInfoObjectToMap(userFullInfo.baseInfo);
    userFullInfoMap[FTValue("userAvatarUrl")] = FTValue(userFullInfo.userAvatarUrl);
    userFullInfoMap[FTValue("extendedData")] = FTValue(userFullInfo.extendedData);

    return userFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMErrorUserInfoToMap(const ZIMErrorUserInfo &errorUserInfo) {
    FTMap errorUserInfoMap;
    errorUserInfoMap[FTValue("userID")] = FTValue(errorUserInfo.userID);
    errorUserInfoMap[FTValue("reason")] = FTValue((int32_t)errorUserInfo.reason);

    return errorUserInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMErrorObjectToMap(const ZIMError &errorInfo) {
    FTMap errorInfoMap;
    errorInfoMap[FTValue("code")] = FTValue(errorInfo.code);
    errorInfoMap[FTValue("message")] = FTValue(errorInfo.message);

    return errorInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMUserListToArray(const std::vector<ZIMUserInfo> &userInfoList) {
    FTArray userInfoListArray;
    for (auto &userInfo : userInfoList) {
        FTMap userInfoMap = cnvZIMUserInfoObjectToMap(userInfo);
        userInfoListArray.emplace_back(userInfoMap);
    }

    return userInfoListArray;
}

FTArray ZIMPluginConverter::cnvZIMFriendInfoToArray(const std::vector<ZIMFriendInfo> &infoList) {
    FTArray userInfoListArray;
    for (auto &userInfo : infoList) {
        FTMap userInfoMap = cnvZIMFriendInfoToMap(userInfo);
        userInfoListArray.emplace_back(userInfoMap);
    }

    return userInfoListArray;
}

FTArray ZIMPluginConverter::cnvZIMFriendApplicationInfoToArray(
    const std::vector<ZIMFriendApplicationInfo> &infoList) {
    FTArray userInfoListArray;
    for (auto &userInfo : infoList) {
        FTMap userInfoMap = cnvZIMFriendApplicationInfoToMap(userInfo);
        userInfoListArray.emplace_back(userInfoMap);
    }

    return userInfoListArray;
}

FTArray ZIMPluginConverter::cnvZIMRoomMemberInfoListToArray(
    const std::vector<ZIMRoomMemberInfo> &roomMemberInfoList) {
    FTArray userInfoListArray;
    for (auto &userInfo : roomMemberInfoList) {
        FTMap userInfoMap = cnvZIMRoomMemberInfoObjectToMap(userInfo);
        userInfoListArray.emplace_back(userInfoMap);
    }

    return userInfoListArray;
}

FTArray
ZIMPluginConverter::cnvZIMErrorUserListToArray(const std::vector<ZIMErrorUserInfo> &errorUserList) {
    FTArray errorUserListArray;
    for (auto &errorUserInfo : errorUserList) {
        FTMap errorInfoMap = cnvZIMErrorUserInfoToMap(errorUserInfo);
        errorUserListArray.emplace_back(errorInfoMap);
    }

    return errorUserListArray;
}

FTArray ZIMPluginConverter::cnvZIMConversationListToArray(
    const std::vector<std::shared_ptr<ZIMConversation>> &converationList) {
    FTArray conversationListArray;
    for (auto &conversation : converationList) {
        FTMap convMap = cnvZIMConversationToMap(conversation);
        conversationListArray.emplace_back(convMap);
    }

    return conversationListArray;
}

FTMap ZIMPluginConverter::cnvZIMConversationToMap(
    const std::shared_ptr<ZIMConversation> &conversation) {
    FTMap conversationMap;
    conversationMap[FTValue("conversationID")] = FTValue(conversation->conversationID);
    conversationMap[FTValue("conversationName")] = FTValue(conversation->conversationName);
    conversationMap[FTValue("conversationAlias")] = FTValue(conversation->conversationAlias);
    conversationMap[FTValue("conversationAvatarUrl")] =
        FTValue(conversation->conversationAvatarUrl);
    conversationMap[FTValue("type")] = FTValue(conversation->type);
    conversationMap[FTValue("notificationStatus")] = FTValue(conversation->notificationStatus);
    conversationMap[FTValue("unreadMessageCount")] =
        FTValue((int32_t)conversation->unreadMessageCount);
    conversationMap[FTValue("orderKey")] = FTValue(conversation->orderKey);
    conversationMap[FTValue("lastMessage")] =
        cnvZIMMessageObjectToMap(conversation->lastMessage.get());
    conversationMap[FTValue("isPinned")] = FTValue(conversation->isPinned);
    conversationMap[FTValue("mentionedInfoList")] =
        cnvZIMMessageMentionedInfoToMap(conversation->mentionedInfoList);
    conversationMap[FTValue("draft")] = FTValue(conversation->draft);
    conversationMap[FTValue("marks")] = FTValue(cnvStlVectorToFTArray(conversation->marks));
    return conversationMap;
}

FTMap ZIMPluginConverter::cnvZIMFileCacheInfoToMap(const ZIMFileCacheInfo &fileCacheInfo) {
    FTMap fileCacheInfoMap;
    fileCacheInfoMap[FTValue("totalFileSize")] = FTValue((int64_t)fileCacheInfo.totalFileSize);
    return fileCacheInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMConversationChangeInfoListToArray(
    const std::vector<ZIMConversationChangeInfo> &convInfoList) {
    FTArray convInfoArray;
    for (auto &convInfo : convInfoList) {
        FTMap convInfoMap;
        convInfoMap[FTValue("event")] = FTValue(convInfo.event);
        if (convInfo.conversation) {
            convInfoMap[FTValue("conversation")] =
                ZIMPluginConverter::cnvZIMConversationToMap(convInfo.conversation);
        } else {
            convInfoMap[FTValue("conversation")] = FTValue(std::monostate());
        }

        convInfoArray.emplace_back(convInfoMap);
    }

    return convInfoArray;
}

FTArray ZIMPluginConverter::cnvZIMMessageSentStatusChangeInfoListToArray(
    const std::vector<ZIMMessageSentStatusChangeInfo> &messageSentStatusChangeInfoList) {
    FTArray messageSentStatusInfoArray;
    for (auto &messageSentStatusChangeInfo : messageSentStatusChangeInfoList) {
        FTMap messageSentStatusChangeInfoMap;
        messageSentStatusChangeInfoMap[FTValue("status")] =
            FTValue(messageSentStatusChangeInfo.status);
        messageSentStatusChangeInfoMap[FTValue("message")] =
            cnvZIMMessageObjectToMap(messageSentStatusChangeInfo.message.get());
        messageSentStatusChangeInfoMap[FTValue("reason")] =
            FTValue(messageSentStatusChangeInfo.reason);
        messageSentStatusInfoArray.emplace_back(messageSentStatusChangeInfoMap);
    }

    return messageSentStatusInfoArray;
}

flutter::EncodableValue ZIMPluginConverter::cnvZIMTipsMessageChangeInfoToMap(
    const std::shared_ptr<ZIMTipsMessageChangeInfo> changeInfo) {
    if (!changeInfo) {
        return FTValue(std::monostate());
    }

    FTMap changeInfoMap;
    changeInfoMap[FTValue("type")] = FTValue(changeInfo->getType());

    auto notConstPtr = std::const_pointer_cast<ZIMTipsMessageChangeInfo>(changeInfo);

    auto groupChangeInfo = std::dynamic_pointer_cast<ZIMTipsMessageGroupChangeInfo>(notConstPtr);
    if (groupChangeInfo) {
        changeInfoMap[FTValue("classType")] = FTValue("ZIMTipsMessageGroupChangeInfo");
        changeInfoMap[FTValue("groupDataFlag")] =
            FTValue((int32_t)(groupChangeInfo->getGroupDataFlag()));
        changeInfoMap[FTValue("groupName")] = FTValue(groupChangeInfo->getGroupName());
        changeInfoMap[FTValue("groupNotice")] = FTValue(groupChangeInfo->getGroupNotice());
        changeInfoMap[FTValue("groupAvatarUrl")] = FTValue(groupChangeInfo->getGroupAvatarUrl());
        changeInfoMap[FTValue("groupMuteInfo")] =
            FTValue(cnvZIMGroupMuteInfoPtrToObj(groupChangeInfo->getGroupMutedInfo()));
        return changeInfoMap;
    }

    auto groupMemberChangeInfo =
        std::dynamic_pointer_cast<ZIMTipsMessageGroupMemberChangeInfo>(notConstPtr);
    if (groupMemberChangeInfo) {
        changeInfoMap[FTValue("classType")] = FTValue("ZIMTipsMessageGroupMemberChangeInfo");
        changeInfoMap[FTValue("muteExpiredTime")] =
            FTValue((int64_t)(groupMemberChangeInfo->getMuteExpiredTime()));
        changeInfoMap[FTValue("role")] = FTValue((int32_t)(groupMemberChangeInfo->getMemberRole()));
        return changeInfoMap;
    }

    return changeInfoMap;
}

flutter::EncodableValue ZIMPluginConverter::cnvZIMMessageObjectToMap(ZIMMessage *message) {
    FTMap messageMap;
    if (!message) {
        return FTValue(std::monostate());
    }

    messageMap[FTValue("type")] = FTValue(message->getType());
    messageMap[FTValue("messageID")] = FTValue(message->getMessageID());
    messageMap[FTValue("localMessageID")] = FTValue(message->getLocalMessageID());
    messageMap[FTValue("senderUserID")] = FTValue(message->getSenderUserID());
    messageMap[FTValue("conversationID")] = FTValue(message->getConversationID());
    messageMap[FTValue("direction")] = FTValue(message->getDirection());
    messageMap[FTValue("sentStatus")] = FTValue(message->getSentStatus());
    messageMap[FTValue("conversationType")] = FTValue(message->getConversationType());
    messageMap[FTValue("timestamp")] = FTValue((int64_t)message->getTimestamp());
    messageMap[FTValue("conversationSeq")] = FTValue(message->getConversationSeq());
    messageMap[FTValue("messageSeq")] = FTValue(message->getMessageSeq());
    messageMap[FTValue("orderKey")] = FTValue(message->getOrderKey());
    messageMap[FTValue("isUserInserted")] = FTValue(message->isUserInserted());
    messageMap[FTValue("receiptStatus")] = FTValue(message->getReceiptStatus());
    messageMap[FTValue("extendedData")] = FTValue(message->extendedData);
    messageMap[FTValue("localExtendedData")] = FTValue(message->localExtendedData);
    messageMap[FTValue("reactions")] =
        ZIMPluginConverter::cnvZIMMessageReactionListToArray(message->reactions);
    messageMap[FTValue("isBroadcastMessage")] = FTValue(message->isBroadcastMessage());
    messageMap[FTValue("isMentionAll")] = FTValue(message->isMentionAll);
    messageMap[FTValue("isServerMessage")] = FTValue(message->isServerMessage());
    messageMap[FTValue("mentionedUserIDs")] = cnvStlVectorToFTArray(message->mentionedUserIDs);
    messageMap[FTValue("cbInnerID")] = FTValue(message->getCbInnerID());
    messageMap[FTValue("repliedInfo")] =
        FTValue(ZIMPluginConverter::cnvZIMMessageRepliedInfoToMap(message->getRepliedInfo()));
    messageMap[FTValue("rootRepliedCount")] = FTValue(message->getRootRepliedCount());

    if (message->getType() >= ZIM_MESSAGE_TYPE_IMAGE &&
        message->getType() <= ZIM_MESSAGE_TYPE_VIDEO) {
        auto mediaMessage = (ZIMMediaMessage *)message;
        messageMap[FTValue("fileLocalPath")] = FTValue(mediaMessage->fileLocalPath);
        messageMap[FTValue("fileDownloadUrl")] = FTValue(mediaMessage->fileDownloadUrl);
        messageMap[FTValue("fileUID")] = FTValue(mediaMessage->getFileUID());
        messageMap[FTValue("fileName")] = FTValue(mediaMessage->fileName);
        messageMap[FTValue("fileSize")] = FTValue(mediaMessage->getFileSize());
    }

    switch (message->getType()) {
    case ZIM_MESSAGE_TYPE_TEXT: {
        auto textMessage = (ZIMTextMessage *)message;
        messageMap[FTValue("message")] = FTValue(textMessage->message);
        break;
    }
    case ZIM_MESSAGE_TYPE_COMMAND: {
        auto commandMessage = (ZIMCommandMessage *)message;
        messageMap[FTValue("message")] = FTValue(commandMessage->message);
        break;
    }
    case ZIM_MESSAGE_TYPE_BARRAGE: {
        auto barrageMessage = (ZIMBarrageMessage *)message;
        messageMap[FTValue("message")] = FTValue(barrageMessage->message);
        break;
    }
    case ZIM_MESSAGE_TYPE_FILE:
        break;
    case ZIM_MESSAGE_TYPE_IMAGE: {
        auto imageMessage = (ZIMImageMessage *)message;
        messageMap[FTValue("thumbnailDownloadUrl")] = FTValue(imageMessage->thumbnailDownloadUrl);
        messageMap[FTValue("thumbnailLocalPath")] = FTValue(imageMessage->getThumbnailLocalPath());
        messageMap[FTValue("largeImageDownloadUrl")] = FTValue(imageMessage->largeImageDownloadUrl);
        messageMap[FTValue("largeImageLocalPath")] =
            FTValue(imageMessage->getLargeImageLocalPath());
        messageMap[FTValue("originalImageWidth")] =
            FTValue((int32_t)imageMessage->getOriginalImageWidth());
        messageMap[FTValue("originalImageHeight")] =
            FTValue((int32_t)imageMessage->getOriginalImageHeight());
        messageMap[FTValue("largeImageWidth")] =
            FTValue((int32_t)imageMessage->getLargeImageWidth());
        messageMap[FTValue("largeImageHeight")] =
            FTValue((int32_t)imageMessage->getLargeImageHeight());
        messageMap[FTValue("thumbnailWidth")] =
            FTValue((int32_t)imageMessage->getThumbnailImageWidth());
        messageMap[FTValue("thumbnailHeight")] =
            FTValue((int32_t)imageMessage->getThumbnailImageHeight());
        break;
    }
    case ZIM_MESSAGE_TYPE_AUDIO: {
        auto audioMessage = (ZIMAudioMessage *)message;
        messageMap[FTValue("audioDuration")] = FTValue((int64_t)audioMessage->audioDuration);
        break;
    }
    case ZIM_MESSAGE_TYPE_VIDEO: {
        auto videoMessage = (ZIMVideoMessage *)message;
        messageMap[FTValue("videoDuration")] = FTValue((int64_t)videoMessage->videoDuration);
        messageMap[FTValue("videoFirstFrameDownloadUrl")] =
            FTValue(videoMessage->videoFirstFrameDownloadUrl);
        messageMap[FTValue("videoFirstFrameLocalPath")] =
            FTValue(videoMessage->getVideoFirstFrameLocalPath());
        messageMap[FTValue("videoFirstFrameWidth")] =
            FTValue((int32_t)videoMessage->getVideoFirstFrameWidth());
        messageMap[FTValue("videoFirstFrameHeight")] =
            FTValue((int32_t)videoMessage->getVideoFirstFrameHeight());
        break;
    }
    case ZIM_MESSAGE_TYPE_SYSTEM: {
        auto systemMessage = (ZIMSystemMessage *)message;
        messageMap[FTValue("message")] = FTValue(systemMessage->message);
        break;
    }
    case ZIM_MESSAGE_TYPE_CUSTOM: {
        auto customMessage = (ZIMCustomMessage *)message;
        messageMap[FTValue("message")] = FTValue(customMessage->message);
        messageMap[FTValue("searchedContent")] = FTValue(customMessage->searchedContent);
        messageMap[FTValue("subType")] = FTValue((int32_t)customMessage->subType);
        break;
    }
    case ZIM_MESSAGE_TYPE_REVOKE: {
        auto revokeMessage = (ZIMRevokeMessage *)message;
        messageMap[FTValue("revokeType")] = FTValue(revokeMessage->getRevokeType());
        messageMap[FTValue("revokeStatus")] = FTValue(revokeMessage->getRevokeStatus());
        messageMap[FTValue("originalMessageType")] =
            FTValue(revokeMessage->getOriginalMessageType());
        messageMap[FTValue("revokeTimestamp")] =
            FTValue((int64_t)revokeMessage->getRevokeTimestamp());
        messageMap[FTValue("operatedUserID")] = FTValue(revokeMessage->getOperatedUserID());
        messageMap[FTValue("originalTextMessageContent")] =
            FTValue(revokeMessage->getOriginalTextMessageContent());
        messageMap[FTValue("revokeExtendedData")] = FTValue(revokeMessage->getRevokeExtendedData());
        break;
    }
    case ZIM_MESSAGE_TYPE_COMBINE: {
        auto combineMessage = (ZIMCombineMessage *)message;
        messageMap[FTValue("title")] = FTValue(combineMessage->title);
        messageMap[FTValue("summary")] = FTValue(combineMessage->summary);
        messageMap[FTValue("combineID")] = FTValue(combineMessage->getCombineID());
        auto messageArray =
            ZIMPluginConverter::cnvZIMMessageListToArray(combineMessage->messageList);
        messageMap[FTValue("messageList")] = messageArray;
        break;
    }
    case ZIM_MESSAGE_TYPE_TIPS: {
        auto tipsMessage = static_cast<ZIMTipsMessage *>(message);
        messageMap[FTValue("event")] = FTValue(tipsMessage->getEvent());
        messageMap[FTValue("operatedUser")] =
            FTValue(cnvZIMUserInfoPtrToObj(tipsMessage->getOperatedUser()));
        messageMap[FTValue("targetUserList")] =
            FTValue(cnvZIMUserInfoPtrListToArray(tipsMessage->getTargetUserList()));
        if (tipsMessage->getEvent() !=
                ZIMTipsMessageEvent::ZIM_TIPS_MESSAGE_EVENT_GROUP_INFO_CHANGED &&
            tipsMessage->getEvent() !=
                ZIMTipsMessageEvent::ZIM_TIPS_MESSAGE_EVENT_GROUP_MEMBER_INFO_CHANGED) {
            messageMap[FTValue("changeInfo")] = FTValue(std::monostate());
        } else {
            messageMap[FTValue("changeInfo")] =
                FTValue(cnvZIMTipsMessageChangeInfoToMap(tipsMessage->getChangeInfo()));
        }
        break;
    }
    case ZIM_MESSAGE_TYPE_UNKNOWN:
    default:
        break;
    }

    return messageMap;
}

flutter::EncodableValue ZIMPluginConverter::cnvZIMMessageRepliedInfoToMap(
    const std::shared_ptr<ZIMMessageRepliedInfo> &repliedInfoPtr) {
    if (!repliedInfoPtr) {
        return FTValue(std::monostate());
    }

    FTMap infoMap;
    infoMap[FTValue("messageID")] = FTValue(repliedInfoPtr->messageID);
    infoMap[FTValue("messageSeq")] = FTValue(repliedInfoPtr->messageSeq);
    infoMap[FTValue("senderUserID")] = FTValue(repliedInfoPtr->senderUserID);
    infoMap[FTValue("sentTime")] = FTValue((int64_t)repliedInfoPtr->sentTime);
    infoMap[FTValue("state")] = FTValue(repliedInfoPtr->state);
    infoMap[FTValue("messageInfo")] = cnvZIMMessageLiteInfoToMap(repliedInfoPtr->messageInfo);

    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMMessageLiteInfoToMap(
    const std::shared_ptr<ZIMMessageLiteInfo> &infoPtr) {
    FTMap infoMap;
    if (!infoPtr) {
        return infoMap;
    }

    auto type = infoPtr->type;
    infoMap[FTValue("type")] = FTValue(type);
    switch (type) {
    case ZIM_MESSAGE_TYPE_TEXT: {
        auto textLiteInfo = std::static_pointer_cast<ZIMTextMessageLiteInfo>(infoPtr);
        infoMap[FTValue("message")] = FTValue(textLiteInfo->message);
        break;
    }
    case ZIM_MESSAGE_TYPE_CUSTOM: {
        auto customLiteInfo = std::static_pointer_cast<ZIMCustomMessageLiteInfo>(infoPtr);
        infoMap[FTValue("message")] = FTValue(customLiteInfo->message);
        infoMap[FTValue("subType")] = FTValue(static_cast<int32_t>(customLiteInfo->subType));
        break;
    }
    case ZIM_MESSAGE_TYPE_COMBINE: {
        auto cbLiteInfo = std::static_pointer_cast<ZIMCombineMessageLiteInfo>(infoPtr);
        infoMap[FTValue("title")] = FTValue(cbLiteInfo->title);
        infoMap[FTValue("summary")] = FTValue(cbLiteInfo->summary);
        break;
    }
    case ZIM_MESSAGE_TYPE_IMAGE: {
        auto imageLiteInfo = std::static_pointer_cast<ZIMImageMessageLiteInfo>(infoPtr);
        infoMap[FTValue("originalImageWidth")] =
            FTValue((int32_t)imageLiteInfo->originalImageWidth);
        infoMap[FTValue("originalImageHeight")] =
            FTValue((int32_t)imageLiteInfo->originalImageHeight);
        infoMap[FTValue("largeImageDownloadUrl")] = FTValue(imageLiteInfo->largeImageDownloadUrl);
        infoMap[FTValue("largeImageLocalPath")] = FTValue(imageLiteInfo->largeImageLocalPath);
        infoMap[FTValue("largeImageWidth")] =
            FTValue(static_cast<int32_t>(imageLiteInfo->largeImageWidth));
        infoMap[FTValue("largeImageHeight")] =
            FTValue(static_cast<int32_t>(imageLiteInfo->largeImageHeight));
        infoMap[FTValue("thumbnailDownloadUrl")] = FTValue(imageLiteInfo->thumbnailDownloadUrl);
        infoMap[FTValue("thumbnailLocalPath")] = FTValue(imageLiteInfo->thumbnailLocalPath);
        infoMap[FTValue("thumbnailWidth")] =
            FTValue(static_cast<int32_t>(imageLiteInfo->thumbnailWidth));
        infoMap[FTValue("thumbnailHeight")] =
            FTValue(static_cast<int32_t>(imageLiteInfo->thumbnailHeight));
        break;
    }
    case ZIM_MESSAGE_TYPE_FILE: {
        break;
    }
    case ZIM_MESSAGE_TYPE_AUDIO: {
        auto audioLiteInfo = std::static_pointer_cast<ZIMAudioMessageLiteInfo>(infoPtr);
        infoMap[FTValue("audioDuration")] =
            FTValue(static_cast<int32_t>(audioLiteInfo->audioDuration));
        break;
    }
    case ZIM_MESSAGE_TYPE_VIDEO: {
        auto videoLiteInfo = std::static_pointer_cast<ZIMVideoMessageLiteInfo>(infoPtr);
        infoMap[FTValue("videoDuration")] =
            FTValue(static_cast<int32_t>(videoLiteInfo->videoDuration));
        infoMap[FTValue("videoFirstFrameDownloadUrl")] =
            FTValue(videoLiteInfo->videoFirstFrameDownloadUrl);
        infoMap[FTValue("videoFirstFrameLocalPath")] =
            FTValue(videoLiteInfo->videoFirstFrameLocalPath);
        infoMap[FTValue("videoFirstFrameWidth")] =
            FTValue((int32_t)videoLiteInfo->videoFirstFrameWidth);
        infoMap[FTValue("videoFirstFrameHeight")] =
            FTValue((int32_t)videoLiteInfo->videoFirstFrameHeight);
        break;
    }
    case ZIM_MESSAGE_TYPE_UNKNOWN:
    default:
        break;
    }

    if (type >= ZIM_MESSAGE_TYPE_IMAGE && type <= ZIM_MESSAGE_TYPE_VIDEO) {
        auto mediaLiteInfo = std::static_pointer_cast<ZIMMediaMessageLiteInfo>(infoPtr);
        infoMap[FTValue("fileLocalPath")] = FTValue(mediaLiteInfo->fileLocalPath);
        infoMap[FTValue("fileDownloadUrl")] = FTValue(mediaLiteInfo->fileDownloadUrl);
        infoMap[FTValue("fileName")] = FTValue(mediaLiteInfo->fileName);
        infoMap[FTValue("fileSize")] = FTValue(mediaLiteInfo->fileSize);
    }

    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMMessageRootRepliedInfoToMap(const ZIMMessageRootRepliedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("state")] = FTValue(info.state);
    infoMap[FTValue("senderUserID")] = FTValue(info.senderUserID);
    infoMap[FTValue("sentTime")] = FTValue((int64_t)info.sentTime);
    infoMap[FTValue("repliedCount")] = FTValue((int32_t)info.repliedCount);
    infoMap[FTValue("message")] = FTValue(cnvZIMMessageObjectToMap(info.message.get()));

    return infoMap;
}

ZIMConversationDeleteConfig
ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(FTMap configMap) {
    ZIMConversationDeleteConfig config;
    config.isAlsoDeleteServerConversation =
        std::get<bool>(configMap[FTValue("isAlsoDeleteServerConversation")]);

    return config;
}

std::shared_ptr<ZIMConversation>
ZIMPluginConverter::cnvZIMConversationToObject(FTMap conversationMap) {
    std::shared_ptr<ZIMConversation> conversationPtr = std::make_shared<ZIMConversation>();

    conversationPtr->conversationID =
        std::get<std::string>(conversationMap[FTValue("conversationID")]);
    conversationPtr->conversationName =
        std::get<std::string>(conversationMap[FTValue("conversationName")]);
    conversationPtr->conversationAlias =
        std::get<std::string>(conversationMap[FTValue("conversationAlias")]);
    conversationPtr->conversationAvatarUrl =
        std::get<std::string>(conversationMap[FTValue("conversationAvatarUrl")]);
    conversationPtr->isPinned = std::get<bool>(conversationMap[FTValue("isPinned")]);
    conversationPtr->type = (ZIMConversationType)ZIMPluginConverter::cnvFTValueToInt32(
        conversationMap[FTValue("type")]);
    conversationPtr->notificationStatus =
        (ZIMConversationNotificationStatus)ZIMPluginConverter::cnvFTValueToInt32(
            conversationMap[FTValue("notificationStatus")]);
    conversationPtr->unreadMessageCount = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
        conversationMap[FTValue("unreadMessageCount")]);
    conversationPtr->orderKey =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(conversationMap[FTValue("orderKey")]);
    conversationPtr->draft = std::get<std::string>(conversationMap[FTValue("draft")]);
    if (std::holds_alternative<std::monostate>(
            conversationMap[std::get<FTMap>(conversationMap[FTValue("lastMessage")])])) {
        conversationPtr->lastMessage = nullptr;
    } else {
        conversationPtr->lastMessage =
            cnvZIMMessageToObject(std::get<FTMap>(conversationMap[FTValue("lastMessage")]));
    }
    return conversationPtr;
}

std::shared_ptr<ZIMMessage> ZIMPluginConverter::cnvZIMMessageToObject(FTMap messageMap) {
    std::shared_ptr<ZIMMessage> messagePtr = nullptr;

    ZIMMessageType msgType =
        (ZIMMessageType)ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("type")]);
    switch (msgType) {
    case zim::ZIM_MESSAGE_TYPE_UNKNOWN: {
        messagePtr = std::make_shared<ZIMMessage>();
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_TEXT: {
        messagePtr = std::make_shared<ZIMTextMessage>();
        auto textMessagePtr = std::static_pointer_cast<ZIMTextMessage>(messagePtr);
        textMessagePtr->message = std::get<std::string>(messageMap[FTValue("message")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_COMMAND: {
        messagePtr = std::make_shared<ZIMCommandMessage>();
        auto commandMessage = std::static_pointer_cast<ZIMCommandMessage>(messagePtr);
        commandMessage->message = std::get<std::vector<uint8_t>>(messageMap[FTValue("message")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_IMAGE: {
        messagePtr = std::make_shared<ZIMImageMessage>(
            std::get<std::string>(messageMap[FTValue("fileLocalPath")]));
        auto imageMessagePtr = std::static_pointer_cast<ZIMImageMessage>(messagePtr);
        imageMessagePtr->largeImageDownloadUrl =
            std::get<std::string>(messageMap[FTValue("largeImageDownloadUrl")]);
        imageMessagePtr->thumbnailDownloadUrl =
            std::get<std::string>(messageMap[FTValue("thumbnailDownloadUrl")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageLocalPath()) =
            std::get<std::string>(messageMap[FTValue("largeImageLocalPath")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailLocalPath()) =
            std::get<std::string>(messageMap[FTValue("thumbnailLocalPath")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_originalImageWidth()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("originalImageWidth")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_originalImageHeight()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("originalImageHeight")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageWidth()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("largeImageWidth")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageHeight()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("largeImageHeight")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailWidth()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("thumbnailWidth")]);
        (*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailHeight()) =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("thumbnailHeight")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_FILE: {
        messagePtr = std::make_shared<ZIMFileMessage>(
            std::get<std::string>(messageMap[FTValue("fileLocalPath")]));
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_AUDIO: {
        messagePtr = std::make_shared<ZIMAudioMessage>(
            std::get<std::string>(messageMap[FTValue("fileLocalPath")]),
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("audioDuration")]));
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_VIDEO: {
        messagePtr = std::make_shared<ZIMVideoMessage>(
            std::get<std::string>(messageMap[FTValue("fileLocalPath")]),
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("videoDuration")]));
        auto videoMessagePtr = std::static_pointer_cast<ZIMVideoMessage>(messagePtr);
        videoMessagePtr->videoFirstFrameDownloadUrl =
            std::get<std::string>(messageMap[FTValue("videoFirstFrameDownloadUrl")]);
        (*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameLocalPath()) =
            std::get<std::string>(messageMap[FTValue("videoFirstFrameLocalPath")]);
        (*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameWidth()) =
            ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("videoFirstFrameWidth")]);
        (*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameHeight()) =
            ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("videoFirstFrameHeight")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_BARRAGE: {
        messagePtr = std::make_shared<ZIMBarrageMessage>();
        auto barrageMessage = std::static_pointer_cast<ZIMBarrageMessage>(messagePtr);
        barrageMessage->message = std::get<std::string>(messageMap[FTValue("message")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_SYSTEM: {
        messagePtr = std::make_shared<ZIMSystemMessage>();
        auto systemMessage = std::static_pointer_cast<ZIMSystemMessage>(messagePtr);
        systemMessage->message = std::get<std::string>(messageMap[FTValue("message")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_CUSTOM: {
        messagePtr = std::make_shared<ZIMCustomMessage>("", 0);
        auto customMessage = std::static_pointer_cast<ZIMCustomMessage>(messagePtr);
        customMessage->message = std::get<std::string>(messageMap[FTValue("message")]);
        customMessage->searchedContent =
            std::get<std::string>(messageMap[FTValue("searchedContent")]);
        customMessage->subType =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("subType")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_REVOKE: {
        messagePtr = std::make_shared<ZIMRevokeMessage>();
        auto revokeMessagePtr = std::static_pointer_cast<ZIMRevokeMessage>(messagePtr);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeType()) =
            (ZIMRevokeType)ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("revokeType")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeTimestamp()) =
            (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(
                messageMap[FTValue("revokeTimestamp")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_originalMessageType()) =
            (ZIMMessageType)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("originalMessageType")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeStatus()) =
            (ZIMMessageRevokeStatus)ZIMPluginConverter::cnvFTValueToInt32(
                messageMap[FTValue("revokeStatus")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_operatedUserID()) =
            std::get<std::string>(messageMap[FTValue("operatedUserID")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_originalTextMessageContent()) =
            std::get<std::string>(messageMap[FTValue("originalTextMessageContent")]);
        (*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeExtendedData()) =
            std::get<std::string>(messageMap[FTValue("revokeExtendedData")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_COMBINE: {
        messagePtr = std::make_shared<ZIMCombineMessage>();
        auto combineMessagePtr = std::static_pointer_cast<ZIMCombineMessage>(messagePtr);
        if (std::holds_alternative<FTArray>(messageMap[FTValue("messageList")])) {
            for (auto &msg : std::get<FTArray>(messageMap[FTValue("messageList")])) {
                if (std::holds_alternative<FTMap>(msg)) {
                    combineMessagePtr->messageList.emplace_back(
                        cnvZIMMessageToObject(std::get<FTMap>(msg)));
                }
            }
        }
        combineMessagePtr->title = std::get<std::string>(messageMap[FTValue("title")]);
        combineMessagePtr->summary = std::get<std::string>(messageMap[FTValue("summary")]);
        (*combineMessagePtr.get()).*get(ZIM_FriendlyGet_combineID()) =
            std::get<std::string>(messageMap[FTValue("combineID")]);
        break;
    }
    case zim::ZIM_MESSAGE_TYPE_TIPS: {
        messagePtr = std::make_shared<ZIMTipsMessage>();
        break;
    }
    default:
        break;
    }
    if (msgType >= ZIM_MESSAGE_TYPE_IMAGE && msgType <= ZIM_MESSAGE_TYPE_VIDEO) {
        auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
        mediaMessagePtr->fileDownloadUrl =
            std::get<std::string>(messageMap[FTValue("fileDownloadUrl")]);
        mediaMessagePtr->fileName = std::get<std::string>(messageMap[FTValue("fileName")]);
        (*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileUID()) =
            std::get<std::string>(messageMap[FTValue("fileUID")]);
        (*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileSize()) =
            (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("fileSize")]);
    }

    (*messagePtr.get()).*get(ZIM_FriendlyGet_msgType()) = msgType;
    (*messagePtr.get()).*get(ZIM_FriendlyGet_senderUserID()) =
        std::get<std::string>(messageMap[FTValue("senderUserID")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_conversationID()) =
        std::get<std::string>(messageMap[FTValue("conversationID")]);
    messagePtr->extendedData = std::get<std::string>(messageMap[FTValue("extendedData")]);
    messagePtr->localExtendedData = std::get<std::string>(messageMap[FTValue("localExtendedData")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_direction()) =
        (ZIMMessageDirection)ZIMPluginConverter::cnvFTValueToInt32(
            messageMap[FTValue("direction")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_sentStatus()) =
        (ZIMMessageSentStatus)ZIMPluginConverter::cnvFTValueToInt32(
            messageMap[FTValue("sentStatus")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_conversationType()) =
        (ZIMConversationType)ZIMPluginConverter::cnvFTValueToInt32(
            messageMap[FTValue("conversationType")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_isUserInserted()) =
        (bool)std::get<bool>(messageMap[FTValue("isUserInserted")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_messageID()) =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("messageID")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_localMessageID()) =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("localMessageID")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_conversationSeq()) =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("conversationSeq")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_messageSeq()) =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("messageSeq")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_timestamp()) =
        (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("timestamp")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_orderKey()) =
        (long long)ZIMPluginConverter::cnvFTValueToInt64(messageMap[FTValue("orderKey")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_receiptStatus()) =
        (ZIMMessageReceiptStatus)ZIMPluginConverter::cnvFTValueToInt32(
            messageMap[FTValue("receiptStatus")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_isBroadcastMessage()) =
        (bool)std::get<bool>(messageMap[FTValue("isBroadcastMessage")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_cbInnerID()) =
        std::get<std::string>(messageMap[FTValue("cbInnerID")]);
    messagePtr->isMentionAll = (bool)std::get<bool>(messageMap[FTValue("isMentionAll")]);
    (*messagePtr.get()).*get(ZIM_FriendlyGet_isServerMessage()) =
        (bool)std::get<bool>(messageMap[FTValue("isServerMessage")]);
    messagePtr->mentionedUserIDs =
        cnvFTArrayToStlVector(std::get<FTArray>(messageMap[FTValue("mentionedUserIDs")]));
    if (std::holds_alternative<FTMap>(messageMap[FTValue("repliedInfo")])) {
        (*messagePtr.get()).*get(ZIM_FriendlyGet_repliedInfo()) =
            cnvZIMMessageRepliedInfoToObject(std::get<FTMap>(messageMap[FTValue("repliedInfo")]));
    }

    (*messagePtr.get()).*get(ZIM_FriendlyGet_rootRepliedCount()) =
        ZIMPluginConverter::cnvFTValueToInt32(messageMap[FTValue("rootRepliedCount")]);

    return messagePtr;
}

ZIMLoginConfig ZIMPluginConverter::cnvZIMLoginConfigToObject(FTMap configMap) {
    ZIMLoginConfig loginConfig;
    loginConfig.userName = std::get<std::string>(configMap[FTValue("userName")]);
    loginConfig.token = std::get<std::string>(configMap[FTValue("token")]);
    loginConfig.isOfflineLogin = std::get<bool>(configMap[FTValue("isOfflineLogin")]);
    return loginConfig;
}

std::shared_ptr<ZIMPushConfig>
ZIMPluginConverter::cnvZIMPushConfigToObject(FTMap configMap,
                                             std::shared_ptr<ZIMVoIPConfig> &voIPConfigPtr) {
    auto config = std::make_shared<ZIMPushConfig>();
    config->title = std::get<std::string>(configMap[FTValue("title")]);
    config->content = std::get<std::string>(configMap[FTValue("content")]);
    config->payload = std::get<std::string>(configMap[FTValue("payload")]);
    config->resourcesID = std::get<std::string>(configMap[FTValue("resourcesID")]);
    config->enableBadge = std::get<bool>(configMap[FTValue("enableBadge")]);
    config->badgeIncrement =
        ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("badgeIncrement")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("voIPConfig")])) {
        voIPConfigPtr = nullptr;
        config->voIPConfig = nullptr;
    } else {
        voIPConfigPtr =
            cnvZIMVoIPConfigConfigToObject(std::get<FTMap>(configMap[FTValue("voIPConfig")]));
        config->voIPConfig = voIPConfigPtr.get();
    }
    return config;
}

FTArray ZIMPluginConverter::cnvZIMMessageListToArray(
    const std::vector<std::shared_ptr<ZIMMessage>> &messageList) {
    FTArray messageArray;
    for (auto &message : messageList) {
        auto messageMap = cnvZIMMessageObjectToMap(message.get());
        if (std::holds_alternative<FTMap>(messageMap)) {
            messageArray.emplace_back(messageMap);
        }
    }

    return messageArray;
}

FTMap ZIMPluginConverter::cnvZIMMessageReceiptInfoToMap(
    const ZIMMessageReceiptInfo &messageReceiptInfo) {
    FTMap infoMap;

    infoMap[FTValue("conversationType")] = FTValue(messageReceiptInfo.conversationType);
    infoMap[FTValue("conversationID")] = FTValue(messageReceiptInfo.conversationID);
    infoMap[FTValue("messageID")] = FTValue((int64_t)messageReceiptInfo.messageID);
    infoMap[FTValue("status")] = FTValue(messageReceiptInfo.status);
    infoMap[FTValue("readMemberCount")] = FTValue((int32_t)messageReceiptInfo.readMemberCount);
    infoMap[FTValue("unreadMemberCount")] = FTValue((int32_t)messageReceiptInfo.unreadMemberCount);
    infoMap[FTValue("isSelfOperated")] = FTValue(messageReceiptInfo.isSelfOperated);
    return infoMap;
}

FTArray ZIMPluginConverter::cnvZIMMessageReceiptInfoListToArray(
    const std::vector<ZIMMessageReceiptInfo> &infos) {
    FTArray infosArray;
    for (auto &info : infos) {
        auto infoMap = cnvZIMMessageReceiptInfoToMap(info);
        infosArray.emplace_back(infoMap);
    }
    return infosArray;
}

std::vector<std::shared_ptr<ZIMMessage>>
ZIMPluginConverter::cnvZIMMessageArrayToObjectList(FTArray messageArray) {
    std::vector<std::shared_ptr<ZIMMessage>> messageList;

    for (auto &messageMap : messageArray) {
        if (std::holds_alternative<FTMap>(messageMap)) {
            auto messagePtr =
                ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(messageMap));
            messageList.emplace_back(messagePtr);
        }
    }

    return messageList;
}

ZIMRoomInfo ZIMPluginConverter::cnvZIMRoomInfoToObject(FTMap infoMap) {
    ZIMRoomInfo roomInfo;
    roomInfo.roomID = std::get<std::string>(infoMap[FTValue("roomID")]);
    roomInfo.roomName = std::get<std::string>(infoMap[FTValue("roomName")]);

    return roomInfo;
}

FTMap ZIMPluginConverter::cnvZIMRoomInfoToMap(const ZIMRoomInfo &roomInfo) {
    FTMap roomInfoMap;
    roomInfoMap[FTValue("roomID")] = FTValue(roomInfo.roomID);
    roomInfoMap[FTValue("roomName")] = FTValue(roomInfo.roomName);

    return roomInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomFullInfoToMap(const ZIMRoomFullInfo &roomInfo) {
    FTMap roomFullInfoMap;

    auto roomInfoMap = cnvZIMRoomInfoToMap(roomInfo.baseInfo);
    roomFullInfoMap[FTValue("baseInfo")] = roomInfoMap;

    return roomFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoToMap(
    const ZIMRoomAttributesUpdateInfo &updateInfo) {
    FTMap roomAttrInfoMap;
    roomAttrInfoMap[FTValue("action")] = FTValue((int32_t)updateInfo.action);
    roomAttrInfoMap[FTValue("roomAttributes")] = cnvSTLMapToFTMap(updateInfo.roomAttributes);

    return roomAttrInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoListToArray(
    const std::vector<ZIMRoomAttributesUpdateInfo> &updateInfoList) {
    FTArray roomAttrInfoArray;
    for (auto &updateInfo : updateInfoList) {
        FTMap updateInfoMap = cnvZIMRoomAttributesUpdateInfoToMap(updateInfo);
        roomAttrInfoArray.emplace_back(updateInfoMap);
    }

    return roomAttrInfoArray;
}

ZIMRoomMemberAttributesSetConfig
ZIMPluginConverter::cnvZIMRoomMemberAttributesSetConfigToObject(FTMap configMap) {
    ZIMRoomMemberAttributesSetConfig config;
    config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
    return config;
}

ZIMRoomMemberAttributesQueryConfig
ZIMPluginConverter::cnvZIMRoomMemberAttributesQueryConfigToObject(FTMap configMap) {
    ZIMRoomMemberAttributesQueryConfig config;
    config.nextFlag = std::get<std::string>(configMap[FTValue("nextFlag")]);
    config.count = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    return config;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(
    const ZIMRoomMemberAttributesInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("userID")] = info.userID;
    infoMap[FTValue("attributes")] = cnvSTLMapToFTMap(info.attributes);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesOperatedInfoToMap(
    const ZIMRoomMemberAttributesOperatedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("attributesInfo")] =
        ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info.attributesInfo);
    infoMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(info.errorKeys);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesUpdateInfoToMap(
    const ZIMRoomMemberAttributesUpdateInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("attributesInfo")] =
        ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info.attributesInfo);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomOperatedInfoToMap(const ZIMRoomOperatedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("userID")] = info.userID;
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupInfoToMap(const ZIMGroupInfo &groupInfo) {
    FTMap groupInfoMap;
    groupInfoMap[FTValue("groupID")] = groupInfo.groupID;
    groupInfoMap[FTValue("groupName")] = groupInfo.groupName;
    groupInfoMap[FTValue("groupAvatarUrl")] = groupInfo.groupAvatarUrl;
    groupInfoMap[FTValue("groupAlias")] = groupInfo.groupAlias;

    return groupInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupListToArray(const std::vector<ZIMGroup> &groupList) {
    FTArray groupArray;
    for (auto &group : groupList) {
        FTMap groupMap;
        groupMap[FTValue("baseInfo")] = cnvZIMGroupInfoToMap(group.baseInfo);
        groupMap[FTValue("notificationStatus")] = FTValue((int32_t)group.notificationStatus);

        groupArray.emplace_back(groupMap);
    }

    return groupArray;
}

FTMap ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(const ZIMGroupOperatedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("operatedUserInfo")] =
        ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(info.operatedUserInfo);
    infoMap[FTValue("userID")] = FTValue(info.userID);
    infoMap[FTValue("userName")] = FTValue(info.userName);
    infoMap[FTValue("memberNickname")] = FTValue(info.memberNickname);
    infoMap[FTValue("memberRole")] = FTValue((int32_t)info.memberRole);

    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupVerifyInfoToMap(const ZIMGroupVerifyInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("joinMode")] = FTValue((int32_t)info.joinMode);
    infoMap[FTValue("inviteMode")] = FTValue((int32_t)info.inviteMode);
    infoMap[FTValue("beInviteMode")] = FTValue((int32_t)info.beInviteMode);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupAttributesUpdateInfoToMap(
    const ZIMGroupAttributesUpdateInfo &updateInfo) {
    FTMap updateInfoMap;
    updateInfoMap[FTValue("action")] = FTValue(updateInfo.action);
    updateInfoMap[FTValue("groupAttributes")] = cnvSTLMapToFTMap(updateInfo.groupAttributes);

    return updateInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupAttributesUpdateInfoListToArray(
    const std::vector<ZIMGroupAttributesUpdateInfo> &updateInfoList) {
    FTArray updateInfoArray;
    for (auto &updateInfo : updateInfoList) {
        FTMap updateInfoMap = cnvZIMGroupAttributesUpdateInfoToMap(updateInfo);
        updateInfoArray.emplace_back(updateInfoMap);
    }

    return updateInfoArray;
}

FTMap ZIMPluginConverter::convZIMGroupEnterInfo(const ZIMGroupEnterInfo &groupEnterInfo) {
    FTMap groupEnterInfoMap;

    groupEnterInfoMap[FTValue("enterTime")] = FTValue((int64_t)groupEnterInfo.enterTime);
    groupEnterInfoMap[FTValue("enterType")] = FTValue((int32_t)groupEnterInfo.enterType);
    if (groupEnterInfo.operatedUser != nullptr) {
        groupEnterInfoMap[FTValue("operatedUser")] =
            cnvZIMGroupMemberSimpleInfoToMap(groupEnterInfo.operatedUser);
    }
    return groupEnterInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(const ZIMGroupMemberInfo &memberInfo) {
    FTMap groupMemberInfoMap;

    groupMemberInfoMap[FTValue("userID")] = FTValue(memberInfo.userID);
    groupMemberInfoMap[FTValue("userName")] = FTValue(memberInfo.userName);
    groupMemberInfoMap[FTValue("userAvatarUrl")] = FTValue(memberInfo.userAvatarUrl);
    groupMemberInfoMap[FTValue("memberNickname")] = FTValue(memberInfo.memberNickname);
    groupMemberInfoMap[FTValue("memberRole")] = FTValue((int32_t)memberInfo.memberRole);
    groupMemberInfoMap[FTValue("memberAvatarUrl")] = FTValue(memberInfo.memberAvatarUrl);
    groupMemberInfoMap[FTValue("muteExpiredTime")] = FTValue((int64_t)memberInfo.muteExpiredTime);
    groupMemberInfoMap[FTValue("groupEnterInfo")] =
        convZIMGroupEnterInfo(memberInfo.groupEnterInfo);

    return groupMemberInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(
    const std::vector<ZIMGroupMemberInfo> &memberList) {
    FTArray groupMemberArray;

    for (auto &groupMemberInfo : memberList) {
        FTMap groupMemberMap = cnvZIMGroupMemberInfoToMap(groupMemberInfo);
        groupMemberArray.emplace_back(groupMemberMap);
    }
    return groupMemberArray;
}

FTMap ZIMPluginConverter::cnvZIMGroupFullInfoToMap(const ZIMGroupFullInfo &groupInfo) {
    FTMap groupFullInfoMap;

    groupFullInfoMap[FTValue("baseInfo")] = cnvZIMGroupInfoToMap(groupInfo.baseInfo);
    groupFullInfoMap[FTValue("groupNotice")] = FTValue(groupInfo.groupNotice);
    groupFullInfoMap[FTValue("groupAttributes")] = cnvSTLMapToFTMap(groupInfo.groupAttributes);
    groupFullInfoMap[FTValue("notificationStatus")] =
        FTValue((int32_t)groupInfo.notificationStatus);
    groupFullInfoMap[FTValue("mutedInfo")] = cnvZIMGroupMuteInfoToMap(groupInfo.mutedInfo);
    groupFullInfoMap[FTValue("verifyInfo")] = cnvZIMGroupVerifyInfoToMap(groupInfo.verifyInfo);
    groupFullInfoMap[FTValue("createTime")] = FTValue(groupInfo.createTime);
    groupFullInfoMap[FTValue("maxMemberCount")] = FTValue(groupInfo.maxMemberCount);

    return groupFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallUserInfoToMap(const ZIMCallUserInfo &userInfo) {
    FTMap userInfoMap;
    userInfoMap[FTValue("userID")] = FTValue(userInfo.userID);
    userInfoMap[FTValue("state")] = FTValue((int32_t)userInfo.state);
    userInfoMap[FTValue("extendedData")] = FTValue(userInfo.extendedData);
    return userInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallInfoToMap(const ZIMCallInfo &callInfo) {
    FTMap callInfoMap;
    callInfoMap[FTValue("callID")] = FTValue(callInfo.callID);
    callInfoMap[FTValue("caller")] = FTValue(callInfo.caller);
    callInfoMap[FTValue("createTime")] = FTValue((int64_t)callInfo.createTime);
    //callInfoMap[FTValue("callDuration")] = FTValue((int64_t)callInfo.callDuration);
    //callInfoMap[FTValue("userDuration")] = FTValue((int64_t)callInfo.userDuration);
    //callInfoMap[FTValue("timeout")] = FTValue((int32_t)callInfo.timeout);
    callInfoMap[FTValue("endTime")] = FTValue((int64_t)callInfo.endTime);
    callInfoMap[FTValue("state")] = FTValue((int32_t)callInfo.state);
    callInfoMap[FTValue("mode")] = FTValue((int32_t)callInfo.mode);
    callInfoMap[FTValue("callUserList")] = cnvZIMCallUserInfoListToArray(callInfo.callUserList);
    callInfoMap[FTValue("extendedData")] = FTValue(callInfo.extendedData);

    return callInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallInvitationCreatedInfoToMap(
    const ZIMCallInvitationCreatedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("mode")] = FTValue((int32_t)info.mode);
    infoMap[FTValue("caller")] = FTValue(info.caller);
    infoMap[FTValue("extendedData")] = FTValue(info.extendedData);
    infoMap[FTValue("timeout")] = FTValue((int32_t)info.timeout);
    infoMap[FTValue("createTime")] = FTValue((int64_t)info.createTime);
    infoMap[FTValue("callUserList")] = cnvZIMCallUserInfoListToArray(info.callUserList);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallEndSentInfoToMap(const ZIMCallEndedSentInfo &callEndSentInfo) {
    FTMap callInfoMap;
    callInfoMap[FTValue("createTime")] = FTValue((int64_t)callEndSentInfo.createTime);
    callInfoMap[FTValue("acceptTime")] = FTValue((int64_t)callEndSentInfo.acceptTime);
    callInfoMap[FTValue("endTime")] = FTValue((int64_t)callEndSentInfo.endTime);
    //callInfoMap[FTValue("callDuration")] = FTValue((int64_t)callEndedSentInfo.callDuration);
    //callInfoMap[FTValue("userDuration")] = FTValue((int64_t)callEndedSentInfo.userDuration);

    return callInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallJoinSentInfoToMap(const ZIMCallJoinSentInfo &callJoinSentInfo) {
    FTMap callInfoMap;
    callInfoMap[FTValue("createTime")] = FTValue((int64_t)callJoinSentInfo.createTime);
    callInfoMap[FTValue("joinTime")] = FTValue((int64_t)callJoinSentInfo.joinTime);
    callInfoMap[FTValue("extendedData")] = FTValue(callJoinSentInfo.extendedData);
    callInfoMap[FTValue("callUserList")] =
        cnvZIMCallUserInfoListToArray(callJoinSentInfo.callUserList);

    return callInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallQuitSentInfoToMap(const ZIMCallQuitSentInfo &callQuitSentInfo) {
    FTMap callInfoMap;
    callInfoMap[FTValue("createTime")] = FTValue((int64_t)callQuitSentInfo.createTime);
    callInfoMap[FTValue("acceptTime")] = FTValue((int64_t)callQuitSentInfo.acceptTime);
    callInfoMap[FTValue("quitTime")] = FTValue((int64_t)callQuitSentInfo.quitTime);

    return callInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMErrorUserInfoListToArray(
    const std::vector<ZIMErrorUserInfo> &errorUserInfoList) {
    FTArray errorUserInfoArray;
    for (auto &user : errorUserInfoList) {
        FTMap userMap = cnvZIMErrorUserInfoToMap(user);
        errorUserInfoArray.emplace_back(userMap);
    }

    return errorUserInfoArray;
}

FTArray ZIMPluginConverter::cnvZIMCallUserInfoListToArray(
    const std::vector<ZIMCallUserInfo> &callUserList) {
    FTArray callUserArray;
    for (auto &user : callUserList) {
        FTMap userMap = cnvZIMCallUserInfoToMap(user);
        callUserArray.emplace_back(userMap);
    }

    return callUserArray;
}

FTMap ZIMPluginConverter::cnvZIMCallInvitationSentInfoToMap(const ZIMCallInvitationSentInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("timeout")] = FTValue((int32_t)info.timeout);
    sentInfoMap[FTValue("errorList")] = cnvZIMErrorUserInfoListToArray(info.errorUserList);
    sentInfoMap[FTValue("errorInvitees")] = cnvZIMCallUserInfoListToArray(info.errorInvitees);

    return sentInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallingInvitationSentInfoToMap(
    const ZIMCallingInvitationSentInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("errorInvitees")] = cnvZIMErrorUserInfoListToArray(info.errorUserList);

    return sentInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallInvitationEndedInfoToMap(
    const ZIMCallInvitationEndedInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("caller")] = FTValue(info.caller);
    sentInfoMap[FTValue("operatedUserID")] = FTValue(info.operatedUserID);
    sentInfoMap[FTValue("extendedData")] = FTValue(info.extendedData);
    sentInfoMap[FTValue("mode")] = FTValue((int32_t)info.mode);
    sentInfoMap[FTValue("endTime")] = FTValue((int64_t)info.endTime);
    return sentInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallUserStateChangedInfoToMap(
    const ZIMCallUserStateChangeInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("callUserList")] = cnvZIMCallUserInfoListToArray(info.callUserList);
    return sentInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallInvitationTimeoutInfoToMap(
    const ZIMCallInvitationTimeoutInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("mode")] = FTValue((int32_t)info.mode);
    return sentInfoMap;
}

ZIMRoomAdvancedConfig ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(FTMap configMap) {
    ZIMRoomAdvancedConfig config;
    config.roomDestroyDelayTime =
        ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("roomDestroyDelayTime")]);

    auto roomAttrsMap = std::get<FTMap>(configMap[FTValue("roomAttributes")]);
    for (auto &roomAttr : roomAttrsMap) {
        auto key = std::get<std::string>(roomAttr.first);
        auto value = std::get<std::string>(roomAttr.second);
        config.roomAttributes[key] = value;
    }

    return config;
}

ZIMRoomMemberQueryConfig ZIMPluginConverter::cnvZIMRoomMemberQueryConfigToObject(FTMap configMap) {
    ZIMRoomMemberQueryConfig config;
    config.count = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    config.nextFlag = std::get<std::string>(configMap[FTValue("nextFlag")]);

    return config;
}

ZIMRoomAttributesSetConfig
ZIMPluginConverter::cnvZIMRoomAttributesSetConfigToObject(FTMap configMap) {
    ZIMRoomAttributesSetConfig config;
    config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
    config.isForce = std::get<bool>(configMap[FTValue("isForce")]);
    config.isUpdateOwner = std::get<bool>(configMap[FTValue("isUpdateOwner")]);

    return config;
}

ZIMRoomAttributesDeleteConfig
ZIMPluginConverter::cnvZIMRoomAttributesDeleteConfigToObject(FTMap configMap) {
    ZIMRoomAttributesDeleteConfig config;
    config.isForce = std::get<bool>(configMap[FTValue("isForce")]);

    return config;
}

ZIMRoomAttributesBatchOperationConfig
ZIMPluginConverter::cnvZIMRoomAttributesBatchOperationConfigToObject(FTMap configMap) {
    ZIMRoomAttributesBatchOperationConfig config;
    config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
    config.isForce = std::get<bool>(configMap[FTValue("isForce")]);
    config.isUpdateOwner = std::get<bool>(configMap[FTValue("isUpdateOwner")]);

    return config;
}

ZIMGroupInfo ZIMPluginConverter::cnvZIMGroupInfoToObject(FTMap infoMap) {
    ZIMGroupInfo info;
    info.groupID = std::get<std::string>(infoMap[FTValue("groupID")]);
    info.groupName = std::get<std::string>(infoMap[FTValue("groupName")]);
    info.groupAlias = std::get<std::string>(infoMap[FTValue("groupAlias")]);
    info.groupAvatarUrl = std::get<std::string>(infoMap[FTValue("groupAvatarUrl")]);

    return info;
}

ZIMGroupAdvancedConfig ZIMPluginConverter::cnvZIMGroupAdvancedConfigToObject(FTMap configMap) {
    ZIMGroupAdvancedConfig config;
    config.groupNotice = std::get<std::string>(configMap[FTValue("groupNotice")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("groupAttributes")])) {
        config.groupAttributes = std::unordered_map<std::string, std::string>();
    } else {
        config.groupAttributes =
            cnvFTMapToSTLMap(std::get<FTMap>(configMap[FTValue("groupAttributes")]));
    }
    config.maxMemberCount =
        (int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("maxMemberCount")]);
    config.joinMode =
        (ZIMGroupJoinMode)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("joinMode")]);
    config.inviteMode =
        (ZIMGroupInviteMode)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("inviteMode")]);
    config.beInviteMode = (ZIMGroupBeInviteMode)ZIMPluginConverter::cnvFTValueToInt32(
        configMap[FTValue("beInviteMode")]);
    return config;
}

ZIMGroupMemberQueryConfig
ZIMPluginConverter::cnvZIMGroupMemberQueryConfigToObject(FTMap configMap) {
    ZIMGroupMemberQueryConfig config;
    config.count = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    config.nextFlag =
        (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("nextFlag")]);

    return config;
}

ZIMGroupMessageReceiptMemberQueryConfig
ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(FTMap configMap) {
    ZIMGroupMessageReceiptMemberQueryConfig config;
    config.count = std::get<int32_t>(configMap[FTValue("count")]);
    config.nextFlag = std::get<int32_t>(configMap[FTValue("nextFlag")]);
    return config;
}

ZIMMessageSearchConfig ZIMPluginConverter::cnvZIMMessageSearchConfigMapToObject(FTMap configMap) {
    ZIMMessageSearchConfig config;
    std::shared_ptr<ZIMMessage> nextMessagePtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextMessage")])) {
        config.nextMessage = nullptr;
    } else {
        auto nextMessageMap = std::get<FTMap>(configMap[FTValue("nextMessage")]);
        nextMessagePtr = ZIMPluginConverter::cnvZIMMessageToObject(nextMessageMap);
        config.nextMessage = nextMessagePtr;
    }
    config.count = (unsigned int)std::get<int32_t>(configMap[FTValue("count")]);
    config.order = (ZIMMessageOrder)std::get<int32_t>(configMap[FTValue("order")]);
    config.keywords = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("keywords")]));
    config.senderUserIDs = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("senderUserIDs")]));
    for (auto &msgTypeObj : std::get<FTArray>(configMap[FTValue("messageTypes")])) {
        auto msgType = (ZIMMessageType)std::get<int32_t>(msgTypeObj);
        config.messageTypes.emplace_back(msgType);
    }
    for (auto &subMsgTypeObj : std::get<FTArray>(configMap[FTValue("subMessageTypes")])) {
        auto subMsgType = (unsigned int)std::get<int32_t>(subMsgTypeObj);
        config.subMessageTypes.emplace_back(subMsgType);
    }
    config.startTime = cnvFTValueToInt64(configMap[FTValue("startTime")]);
    config.endTime = cnvFTValueToInt64(configMap[FTValue("endTime")]);

    return config;
}

ZIMConversationSearchConfig
ZIMPluginConverter::cnvZIMConversationSearchConfigMapToObject(FTMap configMap) {
    ZIMConversationSearchConfig config;
    config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);
    config.totalConversationCount = std::get<int32_t>(configMap[FTValue("totalConversationCount")]);
    config.conversationMessageCount =
        std::get<int32_t>(configMap[FTValue("conversationMessageCount")]);
    config.keywords = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("keywords")]));
    config.senderUserIDs = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("senderUserIDs")]));

    for (auto &msgTypeObj : std::get<FTArray>(configMap[FTValue("messageTypes")])) {
        auto msgType = (ZIMMessageType)std::get<int32_t>(msgTypeObj);
        config.messageTypes.emplace_back(msgType);
    }

    for (auto &subMsgTypeObj : std::get<FTArray>(configMap[FTValue("subMessageTypes")])) {
        auto subMsgType = (unsigned int)std::get<int32_t>(subMsgTypeObj);
        config.subMessageTypes.emplace_back(subMsgType);
    }

    config.startTime = cnvFTValueToInt64(configMap[FTValue("startTime")]);
    config.endTime = cnvFTValueToInt64(configMap[FTValue("endTime")]);

    return config;
}

ZIMGroupSearchConfig ZIMPluginConverter::cnvZIMGroupSearchConfigMapToObject(FTMap configMap) {
    ZIMGroupSearchConfig config;
    config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);
    config.count = std::get<int32_t>(configMap[FTValue("count")]);
    config.keywords = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[(FTValue("keywords"))]));
    config.isAlsoMatchGroupMemberUserName =
        std::get<bool>(configMap[FTValue("isAlsoMatchGroupMemberUserName")]);
    config.isAlsoMatchGroupMemberNickname =
        std::get<bool>(configMap[FTValue("isAlsoMatchGroupMemberNickname")]);

    return config;
}

std::shared_ptr<ZIMVoIPConfig> ZIMPluginConverter::cnvZIMVoIPConfigConfigToObject(FTMap configMap) {
    std::shared_ptr<ZIMVoIPConfig> config = std::make_shared<ZIMVoIPConfig>();
    config->iOSVoIPHandleType =
        (ZIMCXHandleType)std::get<int32_t>(configMap[FTValue("iOSVoIPHandleType")]);
    config->iOSVoIPHandleValue = std::get<std::string>(configMap[FTValue("iOSVoIPHandleValue")]);
    config->iOSVoIPHasVideo = std::get<bool>(configMap[FTValue("iOSVoIPHasVideo")]);

    return config;
}

ZIMGroupMemberSearchConfig
ZIMPluginConverter::cnvZIMGroupMemberSearchConfigMapToObject(FTMap configMap) {
    ZIMGroupMemberSearchConfig config;
    config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);
    config.count = std::get<int32_t>(configMap[FTValue("count")]);
    config.keywords = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("keywords")]));
    config.isAlsoMatchGroupMemberNickname =
        std::get<bool>(configMap[FTValue("isAlsoMatchGroupMemberNickname")]);

    return config;
}

FTArray ZIMPluginConverter::cnvZIMConversationSearchInfoListToArray(
    const std::vector<ZIMConversationSearchInfo> &conversationSearchInfoList) {
    FTArray searchInfoArray;
    for (auto &convInfo : conversationSearchInfoList) {
        FTMap convSearchInfoMap;
        convSearchInfoMap[FTValue("conversationID")] = FTValue(convInfo.conversationID);
        convSearchInfoMap[FTValue("conversationType")] = FTValue(convInfo.conversationType);
        convSearchInfoMap[FTValue("totalMessageCount")] =
            FTValue((int32_t)convInfo.totalMessageCount);
        convSearchInfoMap[FTValue("messageList")] =
            ZIMPluginConverter::cnvZIMMessageListToArray(convInfo.messageList);
        searchInfoArray.emplace_back(convSearchInfoMap);
    }

    return searchInfoArray;
}

FTMap ZIMPluginConverter::cnvZIMConversationsAllDeletedInfoToMap(
    const ZIMConversationsAllDeletedInfo &info) {
    FTMap sentInfoMap;
    sentInfoMap[FTValue("count")] = FTValue((int32_t)info.count);
    return sentInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupSearchInfoListToArray(
    const std::vector<ZIMGroupSearchInfo> &groupSearchInfoList) {
    FTArray searchInfoArray;
    for (auto &groupSearchInfo : groupSearchInfoList) {
        FTMap groupSearchInfoMap;
        groupSearchInfoMap[FTValue("groupInfo")] =
            ZIMPluginConverter::cnvZIMGroupInfoToMap(groupSearchInfo.groupInfo);
        groupSearchInfoMap[FTValue("userList")] =
            ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(groupSearchInfo.userList);
        searchInfoArray.emplace_back(groupSearchInfoMap);
    }

    return searchInfoArray;
}

FTMap ZIMPluginConverter::cnvZIMMessageReactionToMap(const ZIMMessageReaction &reaction) {
    FTMap reactionMap;
    reactionMap[FTValue("conversationID")] = FTValue(reaction.conversationID);
    reactionMap[FTValue("conversationType")] = FTValue(reaction.conversationType);
    reactionMap[FTValue("messageID")] = FTValue(reaction.messageID);
    reactionMap[FTValue("totalCount")] = FTValue((int32_t)reaction.totalCount);
    reactionMap[FTValue("reactionType")] = FTValue(reaction.reactionType);
    reactionMap[FTValue("isSelfIncluded")] = FTValue(reaction.isSelfIncluded);
    reactionMap[FTValue("userList")] =
        FTValue(ZIMPluginConverter::cnvZIMMessageReactionUserInfoListToArray(reaction.userList));
    return reactionMap;
}

FTArray ZIMPluginConverter::cnvZIMMessageMentionedInfoToMap(
    const std::vector<ZIMMessageMentionedInfo> &infoList) {
    FTArray array;
    for (auto &info : infoList) {
        FTMap map;
        map[FTValue("type")] = FTValue(info.type);
        map[FTValue("fromUserID")] = FTValue(info.fromUserID);
        map[FTValue("messageID")] = FTValue(info.messageID);
        map[FTValue("messageSeq")] = FTValue(info.messageSeq);
        array.emplace_back(map);
    }
    return array;
}

FTMap ZIMPluginConverter::cnvZIMMessageReactionUserInfoToMap(
    const ZIMMessageReactionUserInfo &userInfo) {
    FTMap reactionMap;
    reactionMap[FTValue("userID")] = FTValue(userInfo.userID);
    return reactionMap;
}

FTMap ZIMPluginConverter::cnvZIMMessageDeletedInfoToMap(const ZIMMessageDeletedInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("conversationID")] = FTValue(info.conversationID);
    infoMap[FTValue("conversationType")] = FTValue(info.conversationType);
    infoMap[FTValue("messageDeleteType")] = FTValue(info.messageDeleteType);
    infoMap[FTValue("isDeleteConversationAllMessage")] =
        FTValue(info.isDeleteConversationAllMessage);
    infoMap[FTValue("messageList")] =
        ZIMPluginConverter::cnvZIMMessageListToArray(info.messageList);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupMuteInfoToMap(const ZIMGroupMuteInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("mode")] = FTValue(info.mode);
    infoMap[FTValue("expiredTime")] = FTValue((int64_t)info.expiredTime);
    infoMap[FTValue("roles")] = ZIMPluginConverter::cnvStlVectorToFTArray(info.roles);
    return infoMap;
}

flutter::EncodableValue
ZIMPluginConverter::cnvZIMGroupMuteInfoPtrToObj(const std::shared_ptr<ZIMGroupMuteInfo> infoPtr) {
    if (!infoPtr) {
        return FTValue(std::monostate());
    }

    FTMap muteInfoMap;

    muteInfoMap[FTValue("mode")] = FTValue(infoPtr->mode);
    muteInfoMap[FTValue("expiredTime")] = FTValue((int64_t)infoPtr->expiredTime);
    muteInfoMap[FTValue("roles")] = ZIMPluginConverter::cnvStlVectorToFTArray(infoPtr->roles);
    return muteInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMMessageReactionListToArray(
    const std::vector<ZIMMessageReaction> &reactionList) {
    FTArray reactionArray;
    for (auto &reaction : reactionList) {
        FTMap reactionMap = ZIMPluginConverter::cnvZIMMessageReactionToMap(reaction);
        reactionArray.emplace_back(reactionMap);
    }
    return reactionArray;
}

FTArray ZIMPluginConverter::cnvZIMMessageReactionUserInfoListToArray(
    const std::vector<ZIMMessageReactionUserInfo> &reactionUserInfoList) {
    FTArray reactionUserInfoArray;
    for (auto &userInfo : reactionUserInfoList) {
        FTMap userInfoMap = ZIMPluginConverter::cnvZIMMessageReactionUserInfoToMap(userInfo);
        reactionUserInfoArray.emplace_back(userInfoMap);
    }
    return reactionUserInfoArray;
}

ZIMMessageReactionUserQueryConfig
ZIMPluginConverter::cnvZIMMessageReactionUserQueryConfigMapToObject(FTMap configMap) {
    ZIMMessageReactionUserQueryConfig config;
    config.nextFlag =
        (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("nextFlag")]);
    config.count = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    config.reactionType = std::get<std::string>(configMap[FTValue("reactionType")]);
    return config;
}

ZIMBlacklistQueryConfig ZIMPluginConverter::cnvZIMBlacklistQueryConfigToObject(FTMap configMap) {
    ZIMBlacklistQueryConfig config;
    config.count = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    config.nextFlag =
        (unsigned int)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("nextFlag")]);
    return config;
}

ZIMGroupMuteConfig ZIMPluginConverter::cnvZIMGroupMuteConfigToObject(FTMap configMap) {
    ZIMGroupMuteConfig config;
    config.mode = (ZIMGroupMuteMode)std::get<int32_t>(configMap[FTValue("mode")]);
    config.duration = std::get<int32_t>(configMap[FTValue("duration")]);
    config.roles = ZIMPluginConverter::cnvFTArrayToStlVectorInt(
        std::get<FTArray>(configMap[FTValue("roles")]));
    return config;
}

ZIMGroupJoinApplicationSendConfig
ZIMPluginConverter::cnvZIMGroupJoinApplicationSendConfigToObject(FTMap configMap) {
    ZIMGroupJoinApplicationSendConfig config{};
    config.wording = std::get<std::string>(configMap[FTValue("wording")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupJoinApplicationAcceptConfig
ZIMPluginConverter::cnvZIMGroupJoinApplicationAcceptConfigToObject(FTMap configMap) {
    ZIMGroupJoinApplicationAcceptConfig config{};
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupJoinApplicationRejectConfig
ZIMPluginConverter::cnvZIMGroupJoinApplicationRejectConfigToObject(FTMap configMap) {
    ZIMGroupJoinApplicationRejectConfig config{};
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupInviteApplicationSendConfig
ZIMPluginConverter::cnvZIMGroupInviteApplicationSendConfigToObject(FTMap configMap) {
    ZIMGroupInviteApplicationSendConfig config{};
    config.wording = std::get<std::string>(configMap[FTValue("wording")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupInviteApplicationAcceptConfig
ZIMPluginConverter::cnvZIMGroupInviteApplicationAcceptConfigToObject(FTMap configMap) {
    ZIMGroupInviteApplicationAcceptConfig config;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupInviteApplicationRejectConfig
ZIMPluginConverter::cnvZIMGroupInviteApplicationRejectConfigToObject(FTMap configMap) {
    ZIMGroupInviteApplicationRejectConfig config;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
        std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    return config;
}

ZIMGroupApplicationListQueryConfig
ZIMPluginConverter::cnvZIMGroupApplicationListQueryConfigToObject(FTMap configMap) {
    ZIMGroupApplicationListQueryConfig config;
    config.nextFlag =
        (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("nextFlag")]);
    config.count = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    return config;
}

ZIMGroupMemberMuteConfig ZIMPluginConverter::cnvZIMGroupMemberMuteConfigToObject(FTMap configMap) {
    ZIMGroupMemberMuteConfig config;
    config.duration = std::get<int32_t>(configMap[FTValue("duration")]);
    return config;
}

ZIMGroupMemberMutedListQueryConfig
ZIMPluginConverter::cnvZIMGroupMemberMutedListQueryConfigToObject(FTMap configMap) {
    ZIMGroupMemberMutedListQueryConfig config;
    config.nextFlag =
        (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("nextFlag")]);
    config.count = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    return config;
}

ZIMFileCacheClearConfig ZIMPluginConverter::cnvZIMFileCacheClearConfigToObject(FTMap configMap) {
    ZIMFileCacheClearConfig config;
    config.endTime =
        (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("endTime")]);
    return config;
}

ZIMFileCacheQueryConfig ZIMPluginConverter::cnvZIMFileCacheQueryConfigToObject(FTMap configMap) {
    ZIMFileCacheQueryConfig config;
    config.endTime =
        (unsigned long long)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("endTime")]);
    return config;
}

ZIMUserOfflinePushRule ZIMPluginConverter::cnvZIMUserOfflinePushRuleToObject(FTMap ruleMap) {
    ZIMUserOfflinePushRule offlinePushRule;
    offlinePushRule.onlinePlatforms = ZIMPluginConverter::cnvFTArrayToStlVectorIntValue(
        std::get<FTArray>(ruleMap[FTValue("onlinePlatforms")]));
    offlinePushRule.notToReceiveOfflinePushPlatforms =
        ZIMPluginConverter::cnvFTArrayToStlVectorIntValue(
            std::get<FTArray>(ruleMap[FTValue("notToReceiveOfflinePushPlatforms")]));
    return offlinePushRule;
}

ZIMFriendAddConfig ZIMPluginConverter::cnvZIMFriendAddConfigToObject(FTMap configMap) {
    ZIMFriendAddConfig config;
    config.wording = std::get<std::string>(configMap[FTValue("wording")]);
    config.friendAlias = std::get<std::string>(configMap[FTValue("friendAlias")]);

    auto attrsMap = std::get<FTMap>(configMap[FTValue("friendAttributes")]);
    for (auto &attr : attrsMap) {
        auto key = std::get<std::string>(attr.first);
        auto value = std::get<std::string>(attr.second);
        config.friendAttributes[key] = value;
    }
    return config;
}

ZIMFriendApplicationAcceptConfig
ZIMPluginConverter::cnvZIMFriendApplicationAcceptConfigToObject(FTMap configMap) {
    ZIMFriendApplicationAcceptConfig config;
    config.friendAlias = std::get<std::string>(configMap[FTValue("friendAlias")]);
    auto attrsMap = std::get<FTMap>(configMap[FTValue("friendAttributes")]);
    for (auto &attr : attrsMap) {
        auto key = std::get<std::string>(attr.first);
        auto value = std::get<std::string>(attr.second);
        config.friendAttributes[key] = value;
    }
    return config;
}

ZIMMessageSendConfig ZIMPluginConverter::oZIMMessageSendConfig(FTMap configMap) {
    ZIMMessageSendConfig config;

    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;

    config.priority =
        (ZIMMessagePriority)ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    config.isNotifyMentionedUsers = std::get<bool>(configMap[FTValue("isNotifyMentionedUsers")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    return config;
}

ZIMMessageRepliedListQueryConfig
ZIMPluginConverter::oZIMMessageRepliedListQueryConfig(FTMap configMap) {
    ZIMMessageRepliedListQueryConfig config;

    config.count = static_cast<unsigned int>(cnvFTValueToInt32(configMap[FTValue("count")]));
    config.nextFlag =
        static_cast<unsigned long long>(cnvFTValueToInt64(configMap[FTValue("nextFlag")]));

    return config;
}

std::shared_ptr<ZIMMessageRepliedInfo>
ZIMPluginConverter::cnvZIMMessageRepliedInfoToObject(FTMap infoMap) {
    std::shared_ptr<ZIMMessageRepliedInfo> infoPtr = std::make_shared<ZIMMessageRepliedInfo>();
    infoPtr->state = (ZIMMessageRepliedInfoState)cnvFTValueToInt32(infoMap[FTValue("state")]);
    infoPtr->messageInfo = ZIMPluginConverter::cnvZIMMessageLiteInfoToObject(
        std::get<FTMap>(infoMap[FTValue("messageInfo")]));
    infoPtr->senderUserID = std::get<std::string>(infoMap[FTValue("senderUserID")]);
    infoPtr->sentTime = (unsigned long long)cnvFTValueToInt64(infoMap[FTValue("sentTime")]);
    infoPtr->messageID = cnvFTValueToInt64(infoMap[FTValue("messageID")]);
    infoPtr->messageSeq = cnvFTValueToInt64(infoMap[FTValue("messageSeq")]);

    return infoPtr;
}

std::shared_ptr<ZIMMessageLiteInfo>
ZIMPluginConverter::cnvZIMMessageLiteInfoToObject(FTMap infoMap) {
    std::shared_ptr<ZIMMessageLiteInfo> infoPtr;

    ZIMMessageType msgType =
        (ZIMMessageType)ZIMPluginConverter::cnvFTValueToInt32(infoMap[FTValue("type")]);
    switch (msgType) {
    case ZIM_MESSAGE_TYPE_TEXT: {
        infoPtr = std::make_shared<ZIMTextMessageLiteInfo>();
        auto textLiteInfo = std::static_pointer_cast<ZIMTextMessageLiteInfo>(infoPtr);
        textLiteInfo->message = std::get<std::string>(infoMap[FTValue("message")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_CUSTOM: {
        infoPtr = std::make_shared<ZIMCustomMessageLiteInfo>();
        auto customLiteInfo = std::static_pointer_cast<ZIMCustomMessageLiteInfo>(infoPtr);
        customLiteInfo->message = std::get<std::string>(infoMap[FTValue("message")]);
        customLiteInfo->subType =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(infoMap[FTValue("subType")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_COMBINE: {
        infoPtr = std::make_shared<ZIMCombineMessageLiteInfo>();
        auto cbLiteInfo = std::static_pointer_cast<ZIMCombineMessageLiteInfo>(infoPtr);
        cbLiteInfo->title = std::get<std::string>(infoMap[FTValue("title")]);
        cbLiteInfo->summary = std::get<std::string>(infoMap[FTValue("summary")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_REVOKE: {
        infoPtr = std::make_shared<ZIMRevokeMessageLiteInfo>();
        break;
    }
    case ZIM_MESSAGE_TYPE_IMAGE: {
        infoPtr = std::make_shared<ZIMImageMessageLiteInfo>();
        auto imageLiteInfo = std::static_pointer_cast<ZIMImageMessageLiteInfo>(infoPtr);
        imageLiteInfo->originalImageWidth = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("originalImageWidth")]);
        imageLiteInfo->originalImageHeight = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("originalImageHeight")]);
        imageLiteInfo->largeImageDownloadUrl =
            std::get<std::string>(infoMap[FTValue("largeImageDownloadUrl")]);
        imageLiteInfo->largeImageLocalPath =
            std::get<std::string>(infoMap[FTValue("largeImageLocalPath")]);
        imageLiteInfo->largeImageWidth = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("largeImageWidth")]);
        imageLiteInfo->largeImageHeight = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("largeImageHeight")]);
        imageLiteInfo->thumbnailDownloadUrl =
            std::get<std::string>(infoMap[FTValue("thumbnailDownloadUrl")]);
        imageLiteInfo->thumbnailLocalPath =
            std::get<std::string>(infoMap[FTValue("thumbnailLocalPath")]);
        imageLiteInfo->thumbnailWidth =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(infoMap[FTValue("thumbnailWidth")]);
        imageLiteInfo->thumbnailHeight = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("thumbnailHeight")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_FILE: {
        infoPtr = std::make_shared<ZIMFileMessageLiteInfo>();
        break;
    }
    case ZIM_MESSAGE_TYPE_AUDIO: {
        infoPtr = std::make_shared<ZIMAudioMessageLiteInfo>();
        auto audioLiteInfo = std::static_pointer_cast<ZIMAudioMessageLiteInfo>(infoPtr);
        audioLiteInfo->audioDuration =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(infoMap[FTValue("audioDuration")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_VIDEO: {
        infoPtr = std::make_shared<ZIMVideoMessageLiteInfo>();
        auto videoLiteInfo = std::static_pointer_cast<ZIMVideoMessageLiteInfo>(infoPtr);
        videoLiteInfo->videoDuration =
            (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(infoMap[FTValue("videoDuration")]);
        videoLiteInfo->videoFirstFrameDownloadUrl =
            std::get<std::string>(infoMap[FTValue("videoFirstFrameDownloadUrl")]);
        videoLiteInfo->videoFirstFrameLocalPath =
            std::get<std::string>(infoMap[FTValue("videoFirstFrameLocalPath")]);
        videoLiteInfo->videoFirstFrameWidth = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("videoFirstFrameWidth")]);
        videoLiteInfo->videoFirstFrameHeight = (unsigned int)ZIMPluginConverter::cnvFTValueToInt32(
            infoMap[FTValue("videoFirstFrameHeight")]);
        break;
    }
    case ZIM_MESSAGE_TYPE_UNKNOWN:
    default:
        infoPtr = std::make_shared<ZIMMessageLiteInfo>();
        break;
    }

    if (msgType >= ZIM_MESSAGE_TYPE_IMAGE && msgType <= ZIM_MESSAGE_TYPE_VIDEO) {
        auto mediaLiteInfo = std::static_pointer_cast<ZIMMediaMessageLiteInfo>(infoPtr);
        mediaLiteInfo->fileName = std::get<std::string>(infoMap[FTValue("fileName")]);
        mediaLiteInfo->fileSize =
            ZIMPluginConverter::cnvFTValueToInt64(infoMap[FTValue("fileSize")]);
        mediaLiteInfo->fileDownloadUrl = std::get<std::string>(infoMap[FTValue("fileDownloadUrl")]);
        mediaLiteInfo->fileLocalPath = std::get<std::string>(infoMap[FTValue("fileLocalPath")]);
    }

    return infoPtr;
}

ZIMFriendSearchConfig ZIMPluginConverter::cnvZIMFriendSearchConfigToObject(FTMap configMap) {
    ZIMFriendSearchConfig config;
    config.count = cnvFTValueToInt32(configMap[FTValue("count")]);
    config.nextFlag = cnvFTValueToInt32(configMap[FTValue("nextFlag")]);
    config.keywords = ZIMPluginConverter::cnvFTArrayToStlVector(
        std::get<FTArray>(configMap[FTValue("keywords")]));
    config.isAlsoMatchFriendAlias = std::get<bool>(configMap[FTValue("isAlsoMatchFriendAlias")]);
    return config;
}

std::shared_ptr<ZIMUserInfo> ZIMPluginConverter::cnvZIMUserInfoToObject(FTMap infoMap) {
    std::shared_ptr<ZIMUserInfo> info;

    std::string classType = std::get<std::string>(infoMap[FTValue("classType")]);

    if (classType == "ZIMGroupMemberSimpleInfo") {
        auto simpleInfo = std::make_shared<ZIMGroupMemberSimpleInfo>();
        simpleInfo->memberNickname = std::get<std::string>(infoMap[FTValue("memberNickname")]);
        simpleInfo->memberRole = cnvFTValueToInt32(infoMap[FTValue("memberRole")]);
        info = simpleInfo;
    } else if (classType == "ZIMGroupMemberInfo") {
        auto memberInfo = std::make_shared<ZIMGroupMemberInfo>();
        memberInfo->memberNickname = std::get<std::string>(infoMap[FTValue("memberNickname")]);
        memberInfo->memberRole = cnvFTValueToInt32(infoMap[FTValue("memberRole")]);
        memberInfo->memberAvatarUrl = std::get<std::string>(infoMap[FTValue("memberAvatarUrl")]);
        memberInfo->muteExpiredTime = cnvFTValueToInt64(infoMap[FTValue("muteExpiredTime")]);
        info = memberInfo;
    } else if (classType == "ZIMFriendInfo") {
        auto friendInfo = std::make_shared<ZIMFriendInfo>();
        friendInfo->friendAlias = std::get<std::string>(infoMap[FTValue("friendAlias")]);
        friendInfo->createTime = cnvFTValueToInt64(infoMap[FTValue("createTime")]);
        friendInfo->wording = std::get<std::string>(infoMap[FTValue("wording")]);
        auto attrsMap = std::get<FTMap>(infoMap[FTValue("friendAttributes")]);
        for (auto &attr : attrsMap) {
            auto key = std::get<std::string>(attr.first);
            auto value = std::get<std::string>(attr.second);
            friendInfo->friendAttributes[key] = value;
        }
        info = friendInfo;
    }

    info->userID = std::get<std::string>(infoMap[FTValue("userID")]);
    info->userName = std::get<std::string>(infoMap[FTValue("userName")]);
    info->userAvatarUrl = std::get<std::string>(infoMap[FTValue("userAvatarUrl")]);

    return info;
}

ZIMFriendApplicationListQueryConfig
ZIMPluginConverter::cnvZIMFriendApplicationListQueryConfigToObject(FTMap infoMap) {
    ZIMFriendApplicationListQueryConfig config;
    config.count = cnvFTValueToInt32(infoMap[FTValue("count")]);
    config.nextFlag = cnvFTValueToInt32(infoMap[FTValue("nextFlag")]);
    return config;
}

ZIMFriendApplicationRejectConfig
ZIMPluginConverter::cnvZIMFriendApplicationRejectConfigToObject(FTMap infoMap) {
    ZIMFriendApplicationRejectConfig config;
    return config;
}

ZIMFriendDeleteConfig ZIMPluginConverter::cnvZIMFriendDeleteConfigToObject(FTMap infoMap) {
    ZIMFriendDeleteConfig config;
    config.type = (ZIMFriendDeleteType)cnvFTValueToInt32(infoMap[FTValue("type")]);
    return config;
}

ZIMFriendInfo ZIMPluginConverter::cnvZIMFriendInfoToObject(FTMap infoMap) {
    ZIMFriendInfo info;
    info.userID = std::get<std::string>(infoMap[FTValue("userID")]);
    info.userName = std::get<std::string>(infoMap[FTValue("userName")]);
    info.userAvatarUrl = std::get<std::string>(infoMap[FTValue("userAvatarUrl")]);
    info.friendAlias = std::get<std::string>(infoMap[FTValue("friendAlias")]);
    info.createTime = cnvFTValueToInt64(infoMap[FTValue("createTime")]);
    info.wording = std::get<std::string>(infoMap[FTValue("wording")]);
    auto attrsMap = std::get<FTMap>(infoMap[FTValue("friendAttributes")]);
    for (auto &attr : attrsMap) {
        auto key = std::get<std::string>(attr.first);
        auto value = std::get<std::string>(attr.second);
        info.friendAttributes[key] = value;
    }
    return info;
}

ZIMFriendListQueryConfig ZIMPluginConverter::cnvZIMFriendListQueryConfigToObject(FTMap infoMap) {
    ZIMFriendListQueryConfig config;
    config.count = cnvFTValueToInt32(infoMap[FTValue("count")]);
    config.nextFlag = cnvFTValueToInt32(infoMap[FTValue("nextFlag")]);
    return config;
}

ZIMFriendApplicationSendConfig
ZIMPluginConverter::cnvZIMFriendApplicationSendConfigToObject(FTMap infoMap) {
    ZIMFriendApplicationSendConfig config;
    config.wording = std::get<std::string>(infoMap[FTValue("wording")]);
    config.friendAlias = std::get<std::string>(infoMap[FTValue("friendAlias")]);
    auto attrsMap = std::get<FTMap>(infoMap[FTValue("friendAttributes")]);
    for (auto &attr : attrsMap) {
        auto key = std::get<std::string>(attr.first);
        auto value = std::get<std::string>(attr.second);
        config.friendAttributes[key] = value;
    }
    return config;
}

ZIMFriendRelationInfo ZIMPluginConverter::cnvZIMFriendRelationInfoToObject(FTMap infoMap) {
    ZIMFriendRelationInfo info;
    info.userID = std::get<std::string>(infoMap[FTValue("userID")]);
    info.type = (ZIMUserRelationType)cnvFTValueToInt32(infoMap[FTValue("type")]);
    return info;
}

ZIMFriendApplicationInfo ZIMPluginConverter::cnvZIMFriendApplicationInfoToObject(FTMap infoMap) {
    ZIMFriendApplicationInfo info;
    auto apUser = cnvZIMUserInfoToObject(std::get<FTMap>(infoMap[FTValue("applyUser")]));
    info.applyUser = apUser ? *apUser : ZIMUserInfo();
    info.wording = std::get<std::string>(infoMap[FTValue("wording")]);
    info.createTime = cnvFTValueToInt64(infoMap[FTValue("createTime")]);
    info.updateTime = cnvFTValueToInt64(infoMap[FTValue("updateTime")]);
    info.type = (ZIMFriendApplicationType)cnvFTValueToInt32(infoMap[FTValue("type")]);
    info.state = (ZIMFriendApplicationState)cnvFTValueToInt32(infoMap[FTValue("state")]);
    return info;
}

FTMap ZIMPluginConverter::cnvZIMFriendApplicationInfoToMap(const ZIMFriendApplicationInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("applyUser")] = cnvZIMUserInfoObjectToMap(info.applyUser);
    infoMap[FTValue("wording")] = FTValue(info.wording);
    infoMap[FTValue("createTime")] = FTValue(info.createTime);
    infoMap[FTValue("updateTime")] = FTValue(info.updateTime);
    infoMap[FTValue("type")] = FTValue((int32_t)info.type);
    infoMap[FTValue("state")] = FTValue((int32_t)info.state);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupMemberSimpleInfoToMap(
    std::shared_ptr<ZIMGroupMemberSimpleInfo> operatedUser) {
    FTMap infoMap;
    infoMap[FTValue("userID")] = FTValue(operatedUser->userID);
    infoMap[FTValue("userName")] = FTValue(operatedUser->userName);
    infoMap[FTValue("userAvatarUrl")] = FTValue(operatedUser->userAvatarUrl);
    infoMap[FTValue("memberNickname")] = FTValue(operatedUser->memberNickname);
    infoMap[FTValue("memberRole")] = FTValue((int32_t)operatedUser->memberRole);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupApplicationInfoToMap(const ZIMGroupApplicationInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("groupInfo")] = cnvZIMGroupInfoToMap(info.groupInfo);
    infoMap[FTValue("applyUser")] = cnvZIMUserInfoObjectToMap(info.applyUser);
    if (info.operatedUser != nullptr) {
        infoMap[FTValue("operatedUser")] = cnvZIMGroupMemberSimpleInfoToMap(info.operatedUser);
    }
    infoMap[FTValue("wording")] = FTValue(info.wording);
    infoMap[FTValue("createTime")] = FTValue((int64_t)info.createTime);
    infoMap[FTValue("updateTime")] = FTValue((int64_t)info.updateTime);
    infoMap[FTValue("type")] = FTValue((int32_t)info.type);
    infoMap[FTValue("state")] = FTValue((int32_t)info.state);
    return infoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupApplicationInfoToArray(
    const std::vector<ZIMGroupApplicationInfo> &infoList) {
    FTArray infoListArray;
    for (auto &info : infoList) {
        FTMap infoMap = cnvZIMGroupApplicationInfoToMap(info);
        infoListArray.emplace_back(infoMap);
    }
    return infoListArray;
}

FTMap ZIMPluginConverter::cnvZIMUserOfflinePushRuleToMap(
    const ZIMUserOfflinePushRule &offlinePushRule) {
    FTMap infoMap;
    infoMap[FTValue("onlinePlatforms")] = cnvStlVectorToFTArray(offlinePushRule.onlinePlatforms);
    infoMap[FTValue("notToReceiveOfflinePushPlatforms")] =
        cnvStlVectorToFTArray(offlinePushRule.notToReceiveOfflinePushPlatforms);
    return infoMap;
}
FTMap ZIMPluginConverter::cnvZIMUserRuleToMap(const ZIMUserRule &rule) {
    FTMap infoMap;
    infoMap[FTValue("offlinePushRule")] = cnvZIMUserOfflinePushRuleToMap(rule.offlinePushRule);
    return infoMap;
}
FTMap ZIMPluginConverter::cnvZIMSelfUserInfoToMap(const ZIMSelfUserInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("userRule")] = cnvZIMUserRuleToMap(info.userRule);
    infoMap[FTValue("userFullInfo")] = cnvZIMUserFullInfoObjectToMap(info.userFullInfo);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMFriendInfoToMap(const ZIMFriendInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("userID")] = FTValue(info.userID);
    infoMap[FTValue("userName")] = FTValue(info.userName);
    infoMap[FTValue("userAvatarUrl")] = FTValue(info.userAvatarUrl);
    infoMap[FTValue("friendAlias")] = FTValue(info.friendAlias);
    infoMap[FTValue("createTime")] = FTValue(info.createTime);
    infoMap[FTValue("wording")] = FTValue(info.wording);
    infoMap[FTValue("friendAttributes")] = cnvSTLMapToFTMap(info.friendAttributes);
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMFriendRelationInfoToMap(const ZIMFriendRelationInfo &info) {
    FTMap infoMap;
    infoMap[FTValue("type")] = FTValue((int32_t)info.type);
    infoMap[FTValue("userID")] = FTValue(info.userID);
    return infoMap;
}
