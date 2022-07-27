#include "include/zim_flutter_sdk/zim_flutter_sdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "zego_zim_plugin.h"

void ZegoZimPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  zim_flutter_sdk::ZegoZimPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
