#pragma once

#include <memory>
#include <flutter/event_channel.h>
#include "ZIMPluginConverter.h"

#include <ZIM.h>
using namespace zim;

class ZIMPluginEventHandler : public ZIMEventHandler
{
public:
    ~ZIMPluginEventHandler() {}
    ZIMPluginEventHandler() {}

    static std::shared_ptr<ZIMPluginEventHandler>& getInstance()
    {
        if (!m_instance) {
            m_instance = std::shared_ptr<ZIMPluginEventHandler>(new ZIMPluginEventHandler);
        }

        return m_instance;
    }

    void setEventSink(std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&eventSink);
    void clearEventSink();
    void sendEvent(FTMap retMap);

public:
    std::unordered_map<ZIM*, std::string> engineEventMap;

protected:
    void onError(ZIM* zim, const ZIMError& errorInfo);

    void onConnectionStateChanged(ZIM* zim, ZIMConnectionState state,
        ZIMConnectionEvent event,
        const std::string& extendedData);

    void onRoomStateChanged(ZIM* zim, ZIMRoomState state, ZIMRoomEvent event,
        const std::string& extendedData,
        const std::string& roomID);

    void onTokenWillExpire(ZIM* zim, unsigned int second);

    void onReceivePeerMessage(ZIM* zim,
            const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
            const std::string& fromUserID);

    void onReceiveRoomMessage(ZIM* zim,
            const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
            const std::string& fromRoomID);

    void onReceiveGroupMessage(ZIM* zim,
            const std::vector<std::shared_ptr<ZIMMessage>>& messageList,
            const std::string& fromGroupID);

    void onConversationChanged(
        ZIM* zim,
        const std::vector<ZIMConversationChangeInfo>& conversationChangeInfoList);

    void onConversationTotalUnreadMessageCountUpdated(ZIM* zim,
            unsigned int totalUnreadMessageCount);

    void onConversationMessageReceiptChanged(ZIM* zim,const std::vector<ZIMMessageReceiptInfo>& infos);

    void onMessageReceiptChanged(ZIM* zim,const std::vector<ZIMMessageReceiptInfo>& infos);

    void onMessageRevokeReceived(ZIM* zim, const std::vector<std::shared_ptr<ZIMRevokeMessage>>& messageList);

    void onRoomMemberJoined(ZIM* zim, const std::vector<ZIMUserInfo>& memberList,
        const std::string& roomID);

    void onRoomMemberLeft(ZIM* zim, const std::vector<ZIMUserInfo>& memberList,
        const std::string& roomID);

    void onRoomAttributesUpdated(ZIM* zim,
        const ZIMRoomAttributesUpdateInfo& updateInfo,
        const std::string& roomID);

    void onRoomAttributesBatchUpdated(ZIM* zim,
            const std::vector<ZIMRoomAttributesUpdateInfo>& updateInfos,
            const std::string& roomID);

    void onRoomMemberAttributesUpdated(ZIM* zim, const std::vector<ZIMRoomMemberAttributesUpdateInfo>& infos,ZIMRoomOperatedInfo operatedInfo, const std::string& roomID);

    void onGroupStateChanged(ZIM* zim, ZIMGroupState state, ZIMGroupEvent event,
        const ZIMGroupOperatedInfo& operatedInfo,
        const ZIMGroupFullInfo& groupInfo);

    void onGroupNameUpdated(ZIM* zim, const std::string& groupName,
        const ZIMGroupOperatedInfo& operatedInfo,
        const std::string& groupID);

    void onGroupAvatarUrlUpdated(ZIM* zim, const std::string& groupAvatarUrl,
        const ZIMGroupOperatedInfo& operatedInfo,
        const std::string& groupID);

    void onGroupNoticeUpdated(ZIM* zim, const std::string& groupNotice,
        const ZIMGroupOperatedInfo& operatedInfo,
        const std::string& groupID);

    void onGroupAttributesUpdated(ZIM* zim,
        const std::vector<ZIMGroupAttributesUpdateInfo>& groupAttributes,
        const ZIMGroupOperatedInfo& operatedInfo, const std::string& groupID);

    void onGroupMemberStateChanged(ZIM* zim, ZIMGroupMemberState state,
        ZIMGroupMemberEvent event,
        const std::vector<ZIMGroupMemberInfo>& userList,
        const ZIMGroupOperatedInfo& operatedInfo,
        const std::string& groupID);

    void onGroupMemberInfoUpdated(ZIM* /*zim*/,
        const std::vector<ZIMGroupMemberInfo>& groupMemberInfos,
        const ZIMGroupOperatedInfo& operatedInfo,
        const std::string& groupID);

    void onCallInvitationReceived(ZIM* zim,
        const ZIMCallInvitationReceivedInfo& info,
        const std::string& callID);

    void onCallInvitationCancelled(ZIM* zim,
        const ZIMCallInvitationCancelledInfo& info,
        const std::string& callID);

    void onCallInvitationAccepted(ZIM* zim,
        const ZIMCallInvitationAcceptedInfo& info,
        const std::string& callID);

    void onCallInvitationRejected(ZIM* zim,
        const ZIMCallInvitationRejectedInfo& info,
        const std::string& callID);

    void onCallInvitationTimeout(ZIM* zim, const std::string& callID);

    void onCallInviteesAnsweredTimeout(ZIM* zim,
        const std::vector<std::string>& invitees,
        const std::string& callID);

private:
    static std::shared_ptr<ZIMPluginEventHandler> m_instance;

private:
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> eventSink_;
};