#include "ZIMPluginEventHandler.h"
#include <flutter/encodable_value.h>
#include <memory>

std::shared_ptr<ZIMPluginEventHandler> ZIMPluginEventHandler::m_instance = nullptr;

void ZIMPluginEventHandler::setEventSink(std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& eventSink)
{
	eventSink_ = std::move(eventSink);
}

void ZIMPluginEventHandler::clearEventSink()
{
	eventSink_.reset();
}

void ZIMPluginEventHandler::sendEvent(FTMap retMap) {
    if (eventSink_) {
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onError(ZIM* zim, const ZIMError& errorInfo) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onError");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("code")] = FTValue((int32_t)errorInfo.code);
        retMap[FTValue("message")] = FTValue(errorInfo.message);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onConnectionStateChanged(ZIM* zim, ZIMConnectionState state,
    ZIMConnectionEvent event,
    const std::string& extendedData) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onConnectionStateChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("state")] = FTValue((int32_t)state);
        retMap[FTValue("event")] = FTValue((int32_t)event);
        // TODO: It need rapidjson to convert
        retMap[FTValue("extendedData")] = FTValue("{}");

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onUserInfoUpdated(ZIM* zim, const ZIMUserFullInfo& info) {
    if(eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onUserInfoUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMUserFullInfoObjectToMap(info);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onTokenWillExpire(ZIM* zim, unsigned int second) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onTokenWillExpire");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("second")] = FTValue((int32_t)second);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onReceivePeerMessage(ZIM* zim,
    const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
    const std::string& fromUserID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onReceivePeerMessage");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
        retMap[FTValue("fromUserID")] = FTValue(fromUserID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onReceiveRoomMessage(ZIM* zim,
    const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
    const std::string& fromRoomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onReceiveRoomMessage");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
        retMap[FTValue("fromRoomID")] = FTValue(fromRoomID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onReceiveGroupMessage(ZIM* zim,
    const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
    const std::string& fromGroupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onReceiveGroupMessage");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
        retMap[FTValue("fromGroupID")] = FTValue(fromGroupID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onConversationChanged(
    ZIM* zim,
    const std::vector<ZIMConversationChangeInfo>& conversationChangeInfoList) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onConversationChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("conversationChangeInfoList")] = ZIMPluginConverter::cnvZIMConversationChangeInfoListToArray(conversationChangeInfoList);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onConversationsAllDeleted(
	ZIM* zim, const ZIMConversationsAllDeletedInfo& info) {
	if (eventSink_) {
		FTMap retMap;
		retMap[FTValue("method")] = FTValue("onConversationsAllDeleted");
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMConversationsAllDeletedInfoToMap(info);
		auto handle = this->engineEventMap[zim];
		retMap[FTValue("handle")] = FTValue(handle);
		eventSink_->Success(retMap);
	}
}

void ZIMPluginEventHandler::onMessageSentStatusChanged(
    ZIM* zim,
    const std::vector<ZIMMessageSentStatusChangeInfo>& messageSentStatusChangeInfoList) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onMessageSentStatusChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("messageSentStatusChangeInfoList")] = ZIMPluginConverter::cnvZIMMessageSentStatusChangeInfoListToArray(messageSentStatusChangeInfoList);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onConversationTotalUnreadMessageCountUpdated(ZIM* zim,
    unsigned int totalUnreadMessageCount) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onConversationTotalUnreadMessageCountUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("totalUnreadMessageCount")] = FTValue((int32_t)totalUnreadMessageCount);

        eventSink_->Success(retMap);
    }
}


void ZIMPluginEventHandler::onConversationMessageReceiptChanged(ZIM * zim,const std::vector<ZIMMessageReceiptInfo>& infos){
    if (!eventSink_) {
        return;
    }
    FTMap retMap;
    retMap[FTValue("method")] = FTValue("onConversationMessageReceiptChanged");
    auto handle = this->engineEventMap[zim];
    retMap[FTValue("handle")] = FTValue(handle);
    FTArray infosModel;
    for(ZIMMessageReceiptInfo info:infos){                
        FTMap infoModel = ZIMPluginConverter::cnvZIMMessageReceiptInfoToMap(info);
        infosModel.emplace_back(infoModel);
    }
    retMap[FTValue("infos")] = infosModel;
    eventSink_->Success(retMap);
}

void ZIMPluginEventHandler::onMessageReceiptChanged(ZIM* zim,const std::vector<ZIMMessageReceiptInfo>& infos){
    if (!eventSink_) {
        return;
    }
    FTMap retMap;
    retMap[FTValue("method")] = FTValue("onMessageReceiptChanged");
    auto handle = this->engineEventMap[zim];
    retMap[FTValue("handle")] = FTValue(handle);
    FTArray infosModel;
    for(ZIMMessageReceiptInfo info:infos){                
        FTMap infoModel = ZIMPluginConverter::cnvZIMMessageReceiptInfoToMap(info);
        infosModel.emplace_back(infoModel);
    }
    retMap[FTValue("infos")] = infosModel;
    eventSink_->Success(retMap);
}

void ZIMPluginEventHandler::onMessageRevokeReceived(ZIM* zim, const std::vector<std::shared_ptr<ZIMRevokeMessage>>& messageList){
    if (!eventSink_) {
        return;
    }
    FTMap retMap;
    retMap[FTValue("method")] = FTValue("onMessageRevokeReceived");
    auto handle = this->engineEventMap[zim];
    retMap[FTValue("handle")] = FTValue(handle);
    std::vector<std::shared_ptr<ZIMMessage>> dstMessageList;
    for (auto& message : messageList) {
        std::shared_ptr<ZIMMessage> dstMessage = message;
        dstMessageList.emplace_back(dstMessage);
    }
    retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(dstMessageList);
    eventSink_->Success(retMap);       
}

void ZIMPluginEventHandler::onBroadcastMessageReceived(ZIM* zim, const std::shared_ptr<ZIMMessage>& message) {
	if (!eventSink_) {
		return;
	}
	FTMap retMap;
	retMap[FTValue("method")] = FTValue("onBroadcastMessageReceived");
	auto handle = this->engineEventMap[zim];
	retMap[FTValue("handle")] = FTValue(handle);
	retMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
	eventSink_->Success(retMap);
}

void ZIMPluginEventHandler::onRoomStateChanged(ZIM* zim, ZIMRoomState state, ZIMRoomEvent event,
    const std::string& extendedData,
    const std::string& roomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomStateChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("state")] = FTValue((int32_t)state);
        retMap[FTValue("event")] = FTValue((int32_t)event);
        retMap[FTValue("roomID")] = FTValue(roomID);
        // TODO: It need rapidjson to convert
        retMap[FTValue("extendedData")] = FTValue("{}");

        eventSink_->Success(retMap);
    }
}


void ZIMPluginEventHandler::onMessageDeleted(ZIM* zim, const ZIMMessageDeletedInfo& deletedInfo){
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onMessageDeleted");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("deletedInfo")] = ZIMPluginConverter::cnvZIMMessageDeletedInfoToMap(deletedInfo);
        
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onRoomMemberJoined(ZIM* zim, const std::vector<ZIMUserInfo>& memberList,
    const std::string& roomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomMemberJoined");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("memberList")] = ZIMPluginConverter::cnvZIMUserListToArray(memberList);
        retMap[FTValue("roomID")] = FTValue(roomID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onRoomMemberLeft(ZIM* zim, const std::vector<ZIMUserInfo>& memberList,
    const std::string& roomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomMemberLeft");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("memberList")] = ZIMPluginConverter::cnvZIMUserListToArray(memberList);
        retMap[FTValue("roomID")] = FTValue(roomID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onRoomAttributesUpdated(ZIM* zim,
    const ZIMRoomAttributesUpdateInfo& updateInfo,
    const std::string& roomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomAttributesUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("updateInfo")] = ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoToMap(updateInfo);
        retMap[FTValue("roomID")] = FTValue(roomID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onRoomAttributesBatchUpdated(ZIM* zim,
    const std::vector<ZIMRoomAttributesUpdateInfo>& updateInfos,
    const std::string& roomID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomAttributesBatchUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("updateInfo")] = ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoListToArray(updateInfos);
        retMap[FTValue("roomID")] = FTValue(roomID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onRoomMemberAttributesUpdated(ZIM* zim, const std::vector<ZIMRoomMemberAttributesUpdateInfo>& infos,ZIMRoomOperatedInfo operatedInfo, const std::string& roomID){
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onRoomMemberAttributesUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("roomID")] = FTValue(roomID);
        FTArray infosModel;
        for(ZIMRoomMemberAttributesUpdateInfo info:infos){                
            FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesUpdateInfoToMap(info);
            infosModel.emplace_back(infoModel);
        }
        retMap[FTValue("infos")] = FTValue(infosModel);
        retMap[FTValue("operatedInfo")] = FTValue(ZIMPluginConverter::cnvZIMRoomOperatedInfoToMap(operatedInfo));
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupStateChanged(ZIM* zim, ZIMGroupState state, ZIMGroupEvent event,
    const ZIMGroupOperatedInfo& operatedInfo,
    const ZIMGroupFullInfo& groupInfo) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupStateChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);
        retMap[FTValue("state")] = FTValue(state);
        retMap[FTValue("event")] = FTValue(event);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupNameUpdated(ZIM* zim, const std::string& groupName,
    const ZIMGroupOperatedInfo& operatedInfo,
    const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupNameUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("groupName")] = FTValue(groupName);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupAvatarUrlUpdated(ZIM* zim, const std::string& groupAvatarUrl,
    const ZIMGroupOperatedInfo& operatedInfo,
    const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupAvatarUrlUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("groupAvatarUrl")] = FTValue(groupAvatarUrl);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupNoticeUpdated(ZIM* zim, const std::string& groupNotice,
    const ZIMGroupOperatedInfo& operatedInfo,
    const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupNoticeUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("groupNotice")] = FTValue(groupNotice);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupAttributesUpdated(ZIM* zim,
    const std::vector<ZIMGroupAttributesUpdateInfo>& groupAttributes,
    const ZIMGroupOperatedInfo& operatedInfo, const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupAttributesUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("updateInfo")] = ZIMPluginConverter::cnvZIMGroupAttributesUpdateInfoListToArray(groupAttributes);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupMemberStateChanged(ZIM* zim, ZIMGroupMemberState state,
    ZIMGroupMemberEvent event,
    const std::vector<ZIMGroupMemberInfo>& userList,
    const ZIMGroupOperatedInfo& operatedInfo,
    const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupMemberStateChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("state")] = FTValue(state);
        retMap[FTValue("event")] = FTValue(event);
        retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onGroupMemberInfoUpdated(ZIM* zim,
    const std::vector<ZIMGroupMemberInfo>& groupMemberInfos,
    const ZIMGroupOperatedInfo& operatedInfo,
    const std::string& groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupMemberInfoUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupID")] = FTValue(groupID);
        retMap[FTValue("userInfo")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(groupMemberInfos);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationReceived(ZIM* zim,
    const ZIMCallInvitationReceivedInfo& info,
    const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationReceived");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);

        FTMap infoMap;
        infoMap[FTValue("inviter")] = FTValue(info.inviter);
        infoMap[FTValue("caller")] = FTValue(info.caller);
        infoMap[FTValue("extendedData")] = FTValue(info.extendedData);
        infoMap[FTValue("mode")] = FTValue((int32_t)info.mode);
        infoMap[FTValue("timeout")] = FTValue((int32_t)info.timeout);
        infoMap[FTValue("createTime")] = FTValue((int64_t)info.createTime);
        infoMap[FTValue("callUserList")] = ZIMPluginConverter::cnvZIMCallUserInfoListToArray(info.callUserList);
        retMap[FTValue("info")] = infoMap;

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationCancelled(ZIM* zim,
    const ZIMCallInvitationCancelledInfo& info,
    const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationCancelled");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);

        FTMap infoMap;
        infoMap[FTValue("inviter")] = FTValue(info.inviter);
        infoMap[FTValue("extendedData")] = FTValue(info.extendedData);
        infoMap[FTValue("mode")] = FTValue((int32_t)info.mode);

        retMap[FTValue("info")] = infoMap;

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationAccepted(ZIM* zim,
    const ZIMCallInvitationAcceptedInfo& info,
    const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationAccepted");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);

        FTMap infoMap;
        infoMap[FTValue("invitee")] = FTValue(info.invitee);
        infoMap[FTValue("extendedData")] = FTValue(info.extendedData);

        retMap[FTValue("info")] = infoMap;

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationRejected(ZIM* zim,
    const ZIMCallInvitationRejectedInfo& info,
    const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationRejected");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);

        FTMap infoMap;
        infoMap[FTValue("invitee")] = FTValue(info.invitee);
        infoMap[FTValue("extendedData")] = FTValue(info.extendedData);

        retMap[FTValue("info")] = infoMap;

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationTimeout(ZIM* zim, const ZIMCallInvitationTimeoutInfo &info,const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationTimeout");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallInvitationTimeoutInfoToMap(info);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInviteesAnsweredTimeout(ZIM* zim,
    const std::vector<std::string>& invitees,
    const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInviteesAnsweredTimeout");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("callID")] = FTValue(callID);
        retMap[FTValue("invitees")] = ZIMPluginConverter::cnvStlVectorToFTArray(invitees);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallInvitationCreated(ZIM * zim,
                                         const ZIMCallInvitationCreatedInfo & info,
                                         const std::string & callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationCreated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallInvitationCreatedInfoToMap(info);
        retMap[FTValue("callID")] = FTValue(callID);

        eventSink_->Success(retMap);
    }

}

void ZIMPluginEventHandler::onCallInvitationEnded(ZIM* zim, const ZIMCallInvitationEndedInfo& info,
	const std::string& callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallInvitationEnded");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallInvitationEndedInfoToMap(info);
        retMap[FTValue("callID")] = FTValue(callID);

        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onCallUserStateChanged(ZIM * zim, const ZIMCallUserStateChangeInfo& info, const std::string & callID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onCallUserStateChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallUserStateChangedInfoToMap(info);
        retMap[FTValue("callID")] = FTValue(callID);
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onMessageReactionsChanged(ZIM * zim,const std::vector<ZIMMessageReaction> & reactions){
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onMessageReactionsChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("reactions")] = ZIMPluginConverter::cnvZIMMessageReactionListToArray(reactions);
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onBlacklistChanged(ZIM * zim, const std::vector<ZIMUserInfo> & userList ,const ZIMBlacklistChangeAction & action) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onBlacklistChanged");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("action")] = FTValue((int32_t)action);
        retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMUserListToArray(userList);
        eventSink_->Success(retMap);
    }
}

void ZIMPluginEventHandler::onFriendInfoUpdated(ZIM* zim,
    const std::vector<ZIMFriendInfo>& friendInfoList) {
	if (eventSink_) {
		FTMap retMap;
		retMap[FTValue("method")] = FTValue("onFriendInfoUpdated");
		auto handle = this->engineEventMap[zim];
		retMap[FTValue("handle")] = FTValue(handle);
		retMap[FTValue("friendInfoList")] = ZIMPluginConverter::cnvZIMFriendInfoToArray(friendInfoList);
		eventSink_->Success(retMap);
	}
}

void ZIMPluginEventHandler::onFriendListChanged(ZIM* zim, const std::vector<ZIMFriendInfo>& friendInfoList,ZIMFriendListChangeAction& action) {
	if (eventSink_) {
		FTMap retMap;
		retMap[FTValue("method")] = FTValue("onFriendListChanged");
		auto handle = this->engineEventMap[zim];
		retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("action")] = FTValue((int32_t)action);
        retMap[FTValue("friendInfoList")] = ZIMPluginConverter::cnvZIMFriendInfoToArray(friendInfoList);
		eventSink_->Success(retMap);
	}
}

void ZIMPluginEventHandler::onFriendApplicationUpdated(
    ZIM* zim,
    const std::vector<ZIMFriendApplicationInfo>& friendApplicationInfoList) {
	if (eventSink_) {
		FTMap retMap;
		retMap[FTValue("method")] = FTValue("onFriendApplicationUpdated");
		auto handle = this->engineEventMap[zim];
		retMap[FTValue("handle")] = FTValue(handle);
		retMap[FTValue("friendApplicationInfoList")] = ZIMPluginConverter::cnvZIMFriendApplicationInfoToArray(friendApplicationInfoList);
		eventSink_->Success(retMap);
	}
}

void ZIMPluginEventHandler::onFriendApplicationListChanged(
    ZIM* zim, const std::vector<ZIMFriendApplicationInfo>& friendApplicationInfoList ,ZIMFriendApplicationListChangeAction& action) {
	if (eventSink_) {
		FTMap retMap;
		retMap[FTValue("method")] = FTValue("onFriendApplicationListChanged");
		auto handle = this->engineEventMap[zim];
		retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("action")] = FTValue((int32_t)action);
		retMap[FTValue("friendApplicationInfoList")] = ZIMPluginConverter::cnvZIMFriendApplicationInfoToArray(friendApplicationInfoList);
		eventSink_->Success(retMap);
	}
}
void ZIMPluginEventHandler::onGroupMutedInfoUpdated(ZIM * zim, const ZIMGroupMuteInfo & groupMuteInfo,
                                        const ZIMGroupOperatedInfo & operatedInfo,
                                        const std::string & groupID) {
    if (eventSink_) {
        FTMap retMap;
        retMap[FTValue("method")] = FTValue("onGroupMutedInfoUpdated");
        auto handle = this->engineEventMap[zim];
        retMap[FTValue("handle")] = FTValue(handle);
        retMap[FTValue("groupMuteInfo")] = ZIMPluginConverter::cnvZIMGroupMuteInfoToMap(groupMuteInfo);
        retMap[FTValue("operatedInfo")] = ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(operatedInfo);
        retMap[FTValue("groupID")] = FTValue(groupID);
        eventSink_->Success(retMap);
    }
}

