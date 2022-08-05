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
