import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js';

import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zego_zim/src/internal/zim_utils_web.dart';
import 'package:zego_zim/src/zim_defines_web.dart';

/// A web implementation of the ZimFlutterSdkPlatform of the ZimFlutterSdk plugin.
class ZegoZimPlugin {
  /// Constructs a ZegoZimPluginWeb
  ZegoZimPlugin();

  static final StreamController _evenController = StreamController();

  static void registerWith(Registrar registrar) {
    //ZimFlutterSdkPlatform.instance = ZimFlutterSdkWeb();
    final MethodChannel channel = MethodChannel(
      'zego_zim_plugin',
      const StandardMethodCodec(),
      registrar,
    );

    // ignore: unused_local_variable
    /*final eventChannel = PluginEventChannel(
        'zim_event_handler',
        const StandardMethodCodec(),
        registrar);*/

    final pluginInstance = ZegoZimPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
    //eventChannel.setController(ZegoZimPlugin._evenController);

    /*_evenController.stream.listen((event) {
      _eventListener(event);
    });*/

    // var element = ScriptElement()
    //   ..src = 'assets/packages/zego_zim/assets/index.js'
    //   ..type = 'application/javascript';

    // document.body!.append(element);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getVersion':
        return getVersion();
      case 'create':
        return create(call.arguments['config']);
      case 'destroy':
        return destroy();
      case 'login':
        return login(call.arguments['userID'], call.arguments['userName'],
            call.arguments['token']);
    }
  }

  static void _eventListener(dynamic event) {}

  static String getVersion() {
    return ZIM.getVersion();
  }

  static Future<void> create(dynamic appConfig) async {
    ZIMAppConfig _appConfig = ZIMAppConfig(appID: appConfig["appID"]);

    ZIM.create(_appConfig);
    return Future.value();
  }

  static Future<void> destroy() async {
    ZIM.destroy();

    return Future.value();
  }

  static Future<void> login(
      String userID, String userName, String token) async {
    ;

    ZIMUserInfo _userInfo = ZIMUserInfo(userID: userID, userName: userName);

    if (ZIM.getInstance() == null) {
      return Future.value();
    }

    ZIM.getInstance()!.login(_userInfo, token);
    return Future.value();
    ;
  }
}
