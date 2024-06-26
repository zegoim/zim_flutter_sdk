﻿#pragma once

#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>

#include <ZIM.h>
using namespace zim;

class ZIMPluginMethodHandler 
{
public:
    ~ZIMPluginMethodHandler(){}

    static ZIMPluginMethodHandler & getInstance()
    {
        static ZIMPluginMethodHandler m_instance;
        return m_instance;
    }

public:
    void getVersion(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void create(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void destroy(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setLogConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setAdvancedConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setCacheConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setGeofencingConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void login(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void logout(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void uploadLog(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void renewToken(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateUserName(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateUserAvatarUrl(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateUserExtendedData(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateUserOfflinePushRule(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void querySelfUserInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryUsersInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryConversationList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryConversation(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryConversationPinnedList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateConversationPinnedState(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteConversation(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void deleteAllConversations(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void clearConversationUnreadMessageCount(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void clearConversationTotalUnreadMessageCount(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setConversationNotificationStatus(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendConversationMessageReceiptRead(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void setConversationDraft(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void insertMessageToLocalDB(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void updateMessageLocalExtendedData(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendPeerMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendRoomMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendGroupMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupJoinMode(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupInviteMode(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupBeInviteMode(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendMediaMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void downloadMediaFile(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryHistoryMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteAllMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteMessages(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void deleteAllConversationMessages(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void sendMessageReceiptsRead(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryMessageReceiptsInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMessageReceiptReadMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMessageReceiptUnreadMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void searchLocalMessages(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void searchGlobalLocalMessages(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void searchLocalConversations(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void revokeMessage(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void enterRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void createRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void createRoomWithConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void joinRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void leaveRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void leaveAllRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomMembers(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomOnlineMemberCount(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setRoomAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteRoomAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void beginRoomAttributesBatchOperation(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void endRoomAttributesBatchOperation(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomAllAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setRoomMembersAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomMembersAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryRoomMemberAttributesList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void createGroup(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void createGroupWithConfig(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void joinGroup(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void dismissGroup(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void leaveGroup(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void inviteUsersIntoGroup(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void kickGroupMembers(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void transferGroupOwner(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupName(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupAvatarUrl(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void updateGroupNotice(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setGroupAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteGroupAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupAllAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setGroupMemberRole(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void setGroupMemberNickname(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMemberInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMemberCount(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void searchLocalGroups(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void searchLocalGroupMembers(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void muteGroup(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void muteGroupMemberList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryGroupMemberMutedList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callInvite(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callingInvite(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callQuit(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callEnd(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);              
    void callCancel(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callAccept(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void callReject(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void callJoin(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryCallList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);  
    void addMessageReaction(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void deleteMessageReaction(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryMessageReactionUserList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void importLocalMessages(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void exportLocalMessages(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void addUsersToBlacklist(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void removeUsersFromBlacklist(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void queryBlackList(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void checkUserIsInBlackList(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void addFriend(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void sendFriendApplication(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void deleteFriends(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void checkFriendsRelation(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void updateFriendAlias(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void updateFriendAttributes(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryFriendsInfo(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void acceptFriendApplication(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void rejectFriendApplication(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryFriendList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryFriendApplicationList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryCombineMessageDetail(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void searchLocalFriends(flutter::EncodableMap& argument,
     std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void clearLocalFileCache(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryLocalFileCache(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void sendGroupJoinApplication(flutter::EncodableMap& argument,
							std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void acceptGroupJoinApplication(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void rejectGroupJoinApplication(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void sendGroupInviteApplications(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void acceptGroupInviteApplication(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void rejectGroupInviteApplication(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
	void queryGroupApplicationList(flutter::EncodableMap& argument,
								  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);



private:
    ZIMPluginMethodHandler() = default;
private:
    std::unordered_map<std::string, ZIM*> engineMap;
};