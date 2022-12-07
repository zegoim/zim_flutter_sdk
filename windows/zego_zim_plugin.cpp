#include "include/zego_zim/zego_zim_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

#define ZIM_MAIN_CONFIG
#include "internal/ZIMPluginMethodHandler.h"
#include "internal/ZIMPluginEventHandler.h"


//namespace zim_flutter_sdk {

  
class ZegoZimPlugin : public flutter::Plugin, public flutter::StreamHandler<flutter::EncodableValue> {
 public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

    ZegoZimPlugin();

    virtual ~ZegoZimPlugin();

    // Disallow copy and assign.
    ZegoZimPlugin(const ZegoZimPlugin&) = delete;
    ZegoZimPlugin& operator=(const ZegoZimPlugin&) = delete;

protected:
    virtual std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnListenInternal(
        const flutter::EncodableValue* arguments,
        std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events) override;

    // Implementation of the public interface, to be provided by subclasses.
    virtual std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnCancelInternal(
        const flutter::EncodableValue* arguments) override;

 private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void ZegoZimPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
    auto methodChannel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "zego_zim_plugin",
            &flutter::StandardMethodCodec::GetInstance());

    auto eventChannel = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(registrar->messenger(), "zim_event_handler", &flutter::StandardMethodCodec::GetInstance());


    auto plugin = std::make_unique<ZegoZimPlugin>();

    eventChannel->SetStreamHandler(std::move(plugin));

    methodChannel->SetMethodCallHandler([plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
    });

    registrar->AddPlugin(std::move(plugin));
}

ZegoZimPlugin::ZegoZimPlugin() {}

ZegoZimPlugin::~ZegoZimPlugin() {}

std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> ZegoZimPlugin::OnListenInternal(
    const flutter::EncodableValue* arguments,
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events) {

    ZIMPluginEventHandler::getInstance()->setEventSink(std::move(events));
    std::cout << "on listen event" << std::endl;

    return nullptr;
}

std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> ZegoZimPlugin::OnCancelInternal(
    const flutter::EncodableValue* arguments) {

    ZIMPluginEventHandler::getInstance()->clearEventSink();
    std::cout << "on cancel listen event" << std::endl;

    return nullptr;
}

void ZegoZimPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    flutter::EncodableMap argument;
    if (std::holds_alternative<flutter::EncodableMap>(*method_call.arguments())) {
        argument = std::get<flutter::EncodableMap>(*method_call.arguments());
    }

    if (method_call.method_name().compare("getVersion") == 0) {
        ZIMPluginMethodHandler::getInstance().getVersion(argument, std::move(result));
    }
    else if (method_call.method_name() == "create") {
        ZIMPluginMethodHandler::getInstance().create(argument, std::move(result));
    }
    else if (method_call.method_name() == "destroy") {
        ZIMPluginMethodHandler::getInstance().destroy(argument, std::move(result));
    }
    else if (method_call.method_name() == "setLogConfig") {
        ZIMPluginMethodHandler::getInstance().setLogConfig(argument, std::move(result));
    }
    else if (method_call.method_name() == "setCacheConfig") {
        ZIMPluginMethodHandler::getInstance().setCacheConfig(argument, std::move(result));
    }
    else if (method_call.method_name() == "login") {
        ZIMPluginMethodHandler::getInstance().login(argument, std::move(result));
    }
    else if (method_call.method_name() == "logout") {
        ZIMPluginMethodHandler::getInstance().logout(argument, std::move(result));
    }
    else if (method_call.method_name() == "uploadLog") {
        ZIMPluginMethodHandler::getInstance().uploadLog(argument, std::move(result));
    }
    else if (method_call.method_name() == "renewToken") {
        ZIMPluginMethodHandler::getInstance().renewToken(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateUserName") {
        ZIMPluginMethodHandler::getInstance().updateUserName(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateUserAvatarUrl") {
        ZIMPluginMethodHandler::getInstance().updateUserAvatarUrl(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateUserExtendedData") {
        ZIMPluginMethodHandler::getInstance().updateUserExtendedData(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryUsersInfo") {
        ZIMPluginMethodHandler::getInstance().queryUsersInfo(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryConversationList") {
        ZIMPluginMethodHandler::getInstance().queryConversationList(argument, std::move(result));
    }
    else if (method_call.method_name() == "deleteConversation") {
        ZIMPluginMethodHandler::getInstance().deleteConversation(argument, std::move(result));
    }
    else if (method_call.method_name() == "clearConversationUnreadMessageCount") {
        ZIMPluginMethodHandler::getInstance().clearConversationUnreadMessageCount(argument, std::move(result));
    }
    else if (method_call.method_name() == "setConversationNotificationStatus") {
        ZIMPluginMethodHandler::getInstance().setConversationNotificationStatus(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendMessage") {
        ZIMPluginMethodHandler::getInstance().sendMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "insertMessageToLocalDB") {
        ZIMPluginMethodHandler::getInstance().insertMessageToLocalDB(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendPeerMessage") {
        ZIMPluginMethodHandler::getInstance().sendPeerMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendRoomMessage") {
        ZIMPluginMethodHandler::getInstance().sendRoomMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendGroupMessage") {
        ZIMPluginMethodHandler::getInstance().sendGroupMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendMediaMessage") {
        ZIMPluginMethodHandler::getInstance().sendMediaMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "revokeMessage") {
        ZIMPluginMethodHandler::getInstance().revokeMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendConversationMessageReceiptRead") {
        ZIMPluginMethodHandler::getInstance().sendConversationMessageReceiptRead(argument, std::move(result));
    }
    else if (method_call.method_name() == "sendMessageReceiptsRead") {
        ZIMPluginMethodHandler::getInstance().sendMessageReceiptsRead(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryMessageReceiptsInfo") {
        ZIMPluginMethodHandler::getInstance().queryMessageReceiptsInfo(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupMessageReceiptReadMemberList") {
        ZIMPluginMethodHandler::getInstance().queryGroupMessageReceiptReadMemberList(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupMessageReceiptUnreadMemberList") {
        ZIMPluginMethodHandler::getInstance().queryGroupMessageReceiptUnreadMemberList(argument, std::move(result));
    }
    else if (method_call.method_name() == "downloadMediaFile") {
        ZIMPluginMethodHandler::getInstance().downloadMediaFile(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryHistoryMessage") {
        ZIMPluginMethodHandler::getInstance().queryHistoryMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "deleteAllMessage") {
        ZIMPluginMethodHandler::getInstance().deleteAllMessage(argument, std::move(result));
    }
    else if (method_call.method_name() == "deleteMessages") {
        ZIMPluginMethodHandler::getInstance().deleteMessages(argument, std::move(result));
    }
    else if (method_call.method_name() == "enterRoom") {
        ZIMPluginMethodHandler::getInstance().enterRoom(argument, std::move(result));
    }
    else if (method_call.method_name() == "createRoom") {
        ZIMPluginMethodHandler::getInstance().createRoom(argument, std::move(result));
    }
    else if (method_call.method_name() == "createRoomWithConfig") {
        ZIMPluginMethodHandler::getInstance().createRoomWithConfig(argument, std::move(result));
    }
    else if (method_call.method_name() == "joinRoom") {
        ZIMPluginMethodHandler::getInstance().joinRoom(argument, std::move(result));
    }
    else if (method_call.method_name() == "leaveRoom") {
        ZIMPluginMethodHandler::getInstance().leaveRoom(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryRoomMemberList") {
        ZIMPluginMethodHandler::getInstance().queryRoomMemberList(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryRoomOnlineMemberCount") {
        ZIMPluginMethodHandler::getInstance().queryRoomOnlineMemberCount(argument, std::move(result));
    }
    else if (method_call.method_name() == "setRoomAttributes") {
        ZIMPluginMethodHandler::getInstance().setRoomAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "deleteRoomAttributes") {
        ZIMPluginMethodHandler::getInstance().deleteRoomAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "beginRoomAttributesBatchOperation") {
        ZIMPluginMethodHandler::getInstance().beginRoomAttributesBatchOperation(argument, std::move(result));
    }
    else if (method_call.method_name() == "endRoomAttributesBatchOperation") {
        ZIMPluginMethodHandler::getInstance().endRoomAttributesBatchOperation(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryRoomAllAttributes") {
        ZIMPluginMethodHandler::getInstance().queryRoomAllAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryRoomMembersAttributes") {
        ZIMPluginMethodHandler::getInstance().queryRoomMembersAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "setRoomMembersAttributes") {
        ZIMPluginMethodHandler::getInstance().setRoomMembersAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryRoomMemberAttributesList") {
        ZIMPluginMethodHandler::getInstance().queryRoomMemberAttributesList(argument, std::move(result));
    }
    else if (method_call.method_name() == "createGroup") {
        ZIMPluginMethodHandler::getInstance().createGroup(argument, std::move(result));
    }
    else if (method_call.method_name() == "createGroupWithConfig") {
        ZIMPluginMethodHandler::getInstance().createGroupWithConfig(argument, std::move(result));
    }
    else if (method_call.method_name() == "joinGroup") {
        ZIMPluginMethodHandler::getInstance().joinGroup(argument, std::move(result));
    }
    else if (method_call.method_name() == "dismissGroup") {
        ZIMPluginMethodHandler::getInstance().dismissGroup(argument, std::move(result));
    }
    else if (method_call.method_name() == "leaveGroup") {
        ZIMPluginMethodHandler::getInstance().leaveGroup(argument, std::move(result));
    }
    else if (method_call.method_name() == "inviteUsersIntoGroup") {
        ZIMPluginMethodHandler::getInstance().inviteUsersIntoGroup(argument, std::move(result));
    }
    else if (method_call.method_name() == "kickGroupMembers") {
        ZIMPluginMethodHandler::getInstance().kickGroupMembers(argument, std::move(result));
    }
    else if (method_call.method_name() == "transferGroupOwner") {
        ZIMPluginMethodHandler::getInstance().transferGroupOwner(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateGroupName") {
        ZIMPluginMethodHandler::getInstance().updateGroupName(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateGroupAvatarUrl") {
        ZIMPluginMethodHandler::getInstance().updateGroupAvatarUrl(argument, std::move(result));
    }
    else if (method_call.method_name() == "updateGroupNotice") {
        ZIMPluginMethodHandler::getInstance().updateGroupNotice(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupInfo") {
        ZIMPluginMethodHandler::getInstance().queryGroupInfo(argument, std::move(result));
    }
    else if (method_call.method_name() == "setGroupAttributes") {
        ZIMPluginMethodHandler::getInstance().setGroupAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "deleteGroupAttributes") {
        ZIMPluginMethodHandler::getInstance().deleteGroupAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupAttributes") {
        ZIMPluginMethodHandler::getInstance().queryGroupAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupAllAttributes") {
        ZIMPluginMethodHandler::getInstance().queryGroupAllAttributes(argument, std::move(result));
    }
    else if (method_call.method_name() == "setGroupMemberRole") {
        ZIMPluginMethodHandler::getInstance().setGroupMemberRole(argument, std::move(result));
    }
    else if (method_call.method_name() == "setGroupMemberNickname") {
        ZIMPluginMethodHandler::getInstance().setGroupMemberNickname(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupMemberInfo") {
        ZIMPluginMethodHandler::getInstance().queryGroupMemberInfo(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupList") {
        ZIMPluginMethodHandler::getInstance().queryGroupList(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupMemberList") {
        ZIMPluginMethodHandler::getInstance().queryGroupMemberList(argument, std::move(result));
    }
    else if (method_call.method_name() == "queryGroupMemberCount") {
        ZIMPluginMethodHandler::getInstance().queryGroupMemberCount(argument, std::move(result));
    }
    else if (method_call.method_name() == "callInvite") {
        ZIMPluginMethodHandler::getInstance().callInvite(argument, std::move(result));
    }
    else if (method_call.method_name() == "callCancel") {
        ZIMPluginMethodHandler::getInstance().callCancel(argument, std::move(result));
    }
    else if (method_call.method_name() == "callAccept") {
        ZIMPluginMethodHandler::getInstance().callAccept(argument, std::move(result));
    }
    else if (method_call.method_name() == "callReject") {
        ZIMPluginMethodHandler::getInstance().callReject(argument, std::move(result));
    }
    else {
        result->NotImplemented();
    
    }

}

void ZegoZimPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
    ZegoZimPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

//}  // namespace zim_flutter_sdk
