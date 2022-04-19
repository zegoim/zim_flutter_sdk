import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:zim/src/zim_event_handler.dart';
import 'package:zim/zim.dart';
import '../zim_defines.dart';

class ZIMEventHandlerImpl implements ZIMEventHandler {
  static const EventChannel _event = EventChannel('zim_event_handler');
  static StreamSubscription<dynamic>? _streamSubscription;

  /* EventHandler */

  static void registerEventHandler() async {
    _streamSubscription = _event.receiveBroadcastStream().listen(eventListener);
  }

  static void unregisterEventHandler() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  static void eventListener(dynamic data) {
    final Map<dynamic, dynamic> map = data;
    switch (map['method']) {
      case 'connectionStateChanged':
        if (ZIMEventHandler.connectionStateChanged == null) return;
        ZIMConnectionStateExtension.mapValue[map['state']];
        ZIMEventHandler.connectionStateChanged!(
            ZIMConnectionStateExtension.mapValue[map['state']]!,
            ZIMConnectionEventExtension.mapValue[map['event']]!,
            Map());
        //ZIMEventHandler.connectionStateChanged!()
        break;
      default:
        break;
    }
  }
}
