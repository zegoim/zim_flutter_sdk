#pragma once

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>

#include <ZIM.h>
using namespace zim;

#define CheckZIMInstanceExistAndObtainZIM()                                                        \
    auto handle = std::get<std::string>(argument[FTValue("handle")]);                              \
    auto zim = this -> engineMap[handle];                                                          \
    if (!zim) {                                                                                    \
        result->Error("-1", "no native instance");                                                 \
        return;                                                                                    \
    }

class ZIMPluginMethodHandler {
  public:
    ~ZIMPluginMethodHandler() {}

    typedef flutter::EncodableMap FArgument;
    typedef std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> FResult;

    static ZIMPluginMethodHandler &getInstance() {
        static ZIMPluginMethodHandler m_instance;
        return m_instance;
    }

  public:
    void getVersion(FArgument &argument, FResult result);
    void create(FArgument &argument, FResult result);
    void destroy(FArgument &argument, FResult result);
    void setLogConfig(FArgument &argument, FResult result);
    void setAdvancedConfig(FArgument &argument, FResult result);
    void setCacheConfig(FArgument &argument, FResult result);
    void setGeofencingConfig(FArgument &argument, FResult result);
    void login(FArgument &argument, FResult result);
    void logout(FArgument &argument, FResult result);
    void uploadLog(FArgument &argument, FResult result);
    void renewToken(FArgument &argument, FResult result);
    void updateUserName(FArgument &argument, FResult result);
    void updateUserAvatarUrl(FArgument &argument, FResult result);
    void updateUserExtendedData(FArgument &argument, FResult result);
    void updateUserOfflinePushRule(FArgument &argument, FResult result);
    void querySelfUserInfo(FArgument &argument, FResult result);
    void queryUsersInfo(FArgument &argument, FResult result);
    void queryConversationList(FArgument &argument, FResult result);
    void queryConversation(FArgument &argument, FResult result);
    void queryConversationPinnedList(FArgument &argument, FResult result);
    void updateConversationPinnedState(FArgument &argument, FResult result);
    void deleteConversation(FArgument &argument, FResult result);
    void deleteAllConversations(FArgument &argument, FResult result);
    void clearConversationUnreadMessageCount(FArgument &argument, FResult result);
    void clearConversationTotalUnreadMessageCount(FArgument &argument, FResult result);
    void setConversationNotificationStatus(FArgument &argument, FResult result);
    void sendConversationMessageReceiptRead(FArgument &argument, FResult result);
    void setConversationDraft(FArgument &argument, FResult result);
    void sendMessage(FArgument &argument, FResult result);
    void insertMessageToLocalDB(FArgument &argument, FResult result);
    void updateMessageLocalExtendedData(FArgument &argument, FResult result);
    void sendPeerMessage(FArgument &argument, FResult result);
    void sendRoomMessage(FArgument &argument, FResult result);
    void sendGroupMessage(FArgument &argument, FResult result);
    void updateGroupJoinMode(FArgument &argument, FResult result);
    void updateGroupInviteMode(FArgument &argument, FResult result);
    void updateGroupBeInviteMode(FArgument &argument, FResult result);
    void sendMediaMessage(FArgument &argument, FResult result);
    void downloadMediaFile(FArgument &argument, FResult result);
    void replyMessage(FArgument &argument, FResult result);
    void queryHistoryMessage(FArgument &argument, FResult result);
    void queryMessages(FArgument &argument, FResult result);
    void queryRepliedMessageList(FArgument &argument, FResult result);
    void deleteAllMessage(FArgument &argument, FResult result);
    void deleteMessages(FArgument &argument, FResult result);
    void deleteAllConversationMessages(FArgument &argument, FResult result);
    void sendMessageReceiptsRead(FArgument &argument, FResult result);
    void queryMessageReceiptsInfo(FArgument &argument, FResult result);
    void queryGroupMessageReceiptReadMemberList(FArgument &argument, FResult result);
    void queryGroupMessageReceiptUnreadMemberList(FArgument &argument, FResult result);
    void searchLocalMessages(FArgument &argument, FResult result);
    void searchGlobalLocalMessages(FArgument &argument, FResult result);
    void searchLocalConversations(FArgument &argument, FResult result);
    void revokeMessage(FArgument &argument, FResult result);
    void enterRoom(FArgument &argument, FResult result);
    void createRoom(FArgument &argument, FResult result);
    void createRoomWithConfig(FArgument &argument, FResult result);
    void joinRoom(FArgument &argument, FResult result);
    void leaveRoom(FArgument &argument, FResult result);
    void leaveAllRoom(FArgument &argument, FResult result);
    void queryRoomMemberList(FArgument &argument, FResult result);
    void queryRoomMembers(FArgument &argument, FResult result);
    void queryRoomOnlineMemberCount(FArgument &argument, FResult result);
    void setRoomAttributes(FArgument &argument, FResult result);
    void deleteRoomAttributes(FArgument &argument, FResult result);
    void beginRoomAttributesBatchOperation(FArgument &argument, FResult result);
    void endRoomAttributesBatchOperation(FArgument &argument, FResult result);
    void queryRoomAllAttributes(FArgument &argument, FResult result);
    void setRoomMembersAttributes(FArgument &argument, FResult result);
    void queryRoomMembersAttributes(FArgument &argument, FResult result);
    void queryRoomMemberAttributesList(FArgument &argument, FResult result);
    void createGroup(FArgument &argument, FResult result);
    void createGroupWithConfig(FArgument &argument, FResult result);
    void joinGroup(FArgument &argument, FResult result);
    void dismissGroup(FArgument &argument, FResult result);
    void leaveGroup(FArgument &argument, FResult result);
    void inviteUsersIntoGroup(FArgument &argument, FResult result);
    void kickGroupMembers(FArgument &argument, FResult result);
    void transferGroupOwner(FArgument &argument, FResult result);
    void updateGroupName(FArgument &argument, FResult result);
    void updateGroupAvatarUrl(FArgument &argument, FResult result);
    void updateGroupNotice(FArgument &argument, FResult result);
    void queryGroupInfo(FArgument &argument, FResult result);
    void setGroupAttributes(FArgument &argument, FResult result);
    void deleteGroupAttributes(FArgument &argument, FResult result);
    void queryGroupAttributes(FArgument &argument, FResult result);
    void queryGroupAllAttributes(FArgument &argument, FResult result);
    void setGroupMemberRole(FArgument &argument, FResult result);
    void setGroupMemberNickname(FArgument &argument, FResult result);
    void queryGroupMemberInfo(FArgument &argument, FResult result);
    void queryGroupList(FArgument &argument, FResult result);
    void queryGroupMemberList(FArgument &argument, FResult result);
    void queryGroupMemberCount(FArgument &argument, FResult result);
    void searchLocalGroups(FArgument &argument, FResult result);
    void searchLocalGroupMembers(FArgument &argument, FResult result);
    void muteGroup(FArgument &argument, FResult result);
    void muteGroupMemberList(FArgument &argument, FResult result);
    void queryGroupMemberMutedList(FArgument &argument, FResult result);
    void callInvite(FArgument &argument, FResult result);
    void callingInvite(FArgument &argument, FResult result);
    void callQuit(FArgument &argument, FResult result);
    void callEnd(FArgument &argument, FResult result);
    void callCancel(FArgument &argument, FResult result);
    void callAccept(FArgument &argument, FResult result);
    void callReject(FArgument &argument, FResult result);
    void callJoin(FArgument &argument, FResult result);
    void queryCallList(FArgument &argument, FResult result);
    void addMessageReaction(FArgument &argument, FResult result);
    void deleteMessageReaction(FArgument &argument, FResult result);
    void queryMessageReactionUserList(FArgument &argument, FResult result);
    void importLocalMessages(FArgument &argument, FResult result);
    void exportLocalMessages(FArgument &argument, FResult result);
    void addUsersToBlacklist(FArgument &argument, FResult result);
    void removeUsersFromBlacklist(FArgument &argument, FResult result);
    void queryBlackList(FArgument &argument, FResult result);
    void checkUserIsInBlackList(FArgument &argument, FResult result);
    void addFriend(FArgument &argument, FResult result);
    void sendFriendApplication(FArgument &argument, FResult result);
    void deleteFriends(FArgument &argument, FResult result);
    void checkFriendsRelation(FArgument &argument, FResult result);
    void updateFriendAlias(FArgument &argument, FResult result);
    void updateFriendAttributes(FArgument &argument, FResult result);
    void queryFriendsInfo(FArgument &argument, FResult result);
    void acceptFriendApplication(FArgument &argument, FResult result);
    void rejectFriendApplication(FArgument &argument, FResult result);
    void queryFriendList(FArgument &argument, FResult result);
    void queryFriendApplicationList(FArgument &argument, FResult result);
    void queryCombineMessageDetail(FArgument &argument, FResult result);
    void searchLocalFriends(FArgument &argument, FResult result);
    void clearLocalFileCache(FArgument &argument, FResult result);
    void queryLocalFileCache(FArgument &argument, FResult result);
    void sendGroupJoinApplication(FArgument &argument, FResult result);
    void acceptGroupJoinApplication(FArgument &argument, FResult result);
    void rejectGroupJoinApplication(FArgument &argument, FResult result);
    void sendGroupInviteApplications(FArgument &argument, FResult result);
    void acceptGroupInviteApplication(FArgument &argument, FResult result);
    void rejectGroupInviteApplication(FArgument &argument, FResult result);
    void queryGroupApplicationList(FArgument &argument, FResult result);

  private:
    ZIMPluginMethodHandler() = default;

  private:
    std::unordered_map<std::string, ZIM *> engineMap;
};