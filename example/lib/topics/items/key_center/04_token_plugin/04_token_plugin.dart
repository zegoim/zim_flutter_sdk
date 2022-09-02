import 'package:flutter/services.dart';
import 'package:zego_zim_example/topics/items/key_center/key_center.dart';

class TokenPlugin {
  static const MethodChannel _channel = MethodChannel('token_plugin');

  static Future<String> makeToken(String userID) async {
    Map resultMap = await _channel.invokeMethod('makeToken', {
      "appID":KeyCenter.appID,
      "userID":userID,
      "secret":'',
    });
    return resultMap['token'];
  }
}
