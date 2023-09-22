import 'dart:async';

import 'package:flutter/services.dart';
import 'package:zego_zim/src/internal/zim_converter.dart';
import 'package:zego_zim/src/internal/zim_engine.dart';
import 'package:zego_zim/src/internal/zim_event_handler_impl.dart';
import 'package:zego_zim/zego_zim.dart';

class ZIMManager {
  static const MethodChannel channel = MethodChannel('zego_zim_plugin');
//  static StreamSubscription<dynamic>? streamSubscription;

  static int handleSequence = 0;

  static Map<String, ZIMEngine> engineMap = {};

  static String? instanceHandle;

  static ZIMEngine? getInstance() {
    return engineMap[instanceHandle];
  }

  static Future<String> getVersion() async {
    return await channel.invokeMethod('getVersion');
  }

  static setAdvancedConfig(String key, String value) async {
    return await channel.invokeMethod('setAdvancedConfig',{'key':key,'value':value});
  }

  static setLogConfig(ZIMLogConfig config) {
    channel.invokeMethod(
        'setLogConfig', {'logPath': config.logPath, 'logSize': config.logSize, 'logLevel': config.logLevel});
  }

  static setCacheConfig(ZIMCacheConfig config) {
    channel.invokeMethod('setCacheConfig', {'cachePath': config.cachePath});
  }

  static ZIMEngine? createEngine(ZIMAppConfig config) {
    ZIMEventHandlerImpl.registerEventHandler();
    if (ZIMManager.engineMap.isNotEmpty) {
      return null;
    }

    String handle = generateHandle();

    ZIMEngine engine = ZIMEngine(
        handle: handle,
        channel: channel,
        appID: config.appID,
        appSign: config.appSign);

    engineMap[handle] = engine;
    if (instanceHandle == null) {
      ZIMManager.instanceHandle = handle;
    }
    channel.invokeMethod("create",
        {"handle": handle, "config": ZIMConverter.mZIMAppConfig(config)});
    return engine;
  }

  static bool destroyEngine(String handle) {
    if (engineMap.containsKey(handle)) {
      engineMap.remove(handle);
      if (instanceHandle == handle) {
        instanceHandle = null;
      }
      return true;
    }
    return false;
  }

  static String generateHandle() {
    handleSequence = handleSequence + 1;
    return '$handleSequence';
  }
}
