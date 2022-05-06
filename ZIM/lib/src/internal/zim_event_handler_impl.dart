import 'dart:async';
import 'dart:ffi';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zim/src/zim_event_handler.dart';
import 'package:zim/zim.dart';
import '../zim_defines.dart';
import 'zim_converter.dart';

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
      case 'onConnectionStateChanged':
        if (ZIMEventHandler.onConnectionStateChanged == null) return;
        ZIMEventHandler.onConnectionStateChanged!(
            ZIMConnectionStateExtension.mapValue[map['state']]!,
            ZIMConnectionEventExtension.mapValue[map['event']]!,
            json.decode(map['extendedData']));

        break;
      case 'onError':
        if (ZIMEventHandler.onError == null) return;
        ZIMError errorInfo =
            ZIMError(code: map['code'], message: map['message']);
        ZIMEventHandler.onError!(errorInfo);
        break;
      case 'onTokenWillExpire':
        if (ZIMEventHandler.onTokenWillExpire == null) return;
        ZIMEventHandler.onTokenWillExpire!(map['second']);
        break;
      case 'onConversationChanged':
        if (ZIMEventHandler.onConversationChanged == null) return;
        List<ZIMConversationChangeInfo> conversationChangeInfoList =
            ZIMConverter.cnvZIMConversationChangeInfoListBasicToObject(
                map['conversationChangeInfoList']);

        ZIMEventHandler.onConversationChanged!(conversationChangeInfoList);
        break;
      case 'onConversationTotalUnreadMessageCountUpdated':
        if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
            null) return;
        ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
            map['totalUnreadMessageCount']);
        break;
      case 'onReceivePeerMessage':
        if (ZIMEventHandler.onReceivePeerMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(messageList, map['fromUserID']);
        break;
      case 'onReceiveRoomMessage':
        if (ZIMEventHandler.onReceiveRoomMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(messageList, map['fromRoomID']);
        break;
      case 'onReceiveGroupMessage':
        if (ZIMEventHandler.onReceiveRoomMessage == null) return;
        List<ZIMMessage> messageList =
            ZIMConverter.cnvZIMMessageListMapToObject(map['messageList']);
        ZIMEventHandler.onReceivePeerMessage!(messageList, map['fromGroupID']);
        break;
      default:
        break;
    }
  }
}
