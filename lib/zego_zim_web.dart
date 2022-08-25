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

    var element = ScriptElement()
      ..src =
          'assets/packages/zego_zim/assets/index.js'
      ..type = 'application/javascript';

    document.body!.append(element);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getVersion':
        return getVersion();
      case 'create':
        return create(call.arguments['appConfig']);
      case 'destroy':
        return destroy();
      case 'login':
        return login(call.arguments['userInfo'], call.arguments['token']);
    }
  }

  static void _eventListener(dynamic event) {
  }

  static String getVersion() {
    return ZIM.getVersion();
  }

  static Future<void> create(dynamic appConfig) async {
    ZIM.create(appConfig);
  }

  static Future<void> destroy() async {
    ZIM.destroy();
  }

  static Future<void> login(dynamic userInfo, String token) async {
    if(ZIM.getInstance() == null) {
      return Future.value();
    }
    dynamic result = await handleThenable(ZIM.getInstance()!.login(userInfo, token));
    return;
  }
}
