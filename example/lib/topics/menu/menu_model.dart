import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list_cell.dart';

import 'items/conver_list.dart';

typedef ConverListUpdateCallBack = void Function(
    List<ConverListCell> converWidgetList);

class MenuModel {
  MenuModel() {
    registerConverUpdate();
  }
  static MenuModel? _menuModel;

  bool firstQuery = true;
  ConverList? _converWidgetListSubscriber;
  ConverListUpdateCallBack? subscriber;

  List<ZIMConversation> _converList = [];
  List<ConverListCell> _converWidgetList = [];

  static MenuModel shared() {
    _menuModel ??= MenuModel();
    return _menuModel!;
  }

  static release() {
    _menuModel = null;
  }

  List<ConverListCell> getCurrentConverWidgetList() {
    if (firstQuery) getMoreConverWidgetList();
    return _converWidgetList;
  }

  getMoreConverWidgetList() async {
    ZIMConversationQueryConfig queryConfig = ZIMConversationQueryConfig();
    queryConfig.count = 20;
    try {
      queryConfig.nextConversation = _converList.last;
    } on StateError {
      queryConfig.nextConversation = null;
    }
    try {
      ZIMConversationListQueriedResult result =
          await ZIM.getInstance().queryConversationList(queryConfig);
      _converList.addAll(result.conversationList);
      List<ConverListCell> newConverWidgetList = [];
      for (ZIMConversation newConversation in result.conversationList) {
        ConverListCell newConverListCell = ConverListCell(newConversation);
        newConverWidgetList.add(newConverListCell);
      }
      _converWidgetList.addAll(newConverWidgetList);
      if (subscriber != null) {
        subscriber!(_converWidgetList);
      }
    } on PlatformException catch (onError) {
      return null;
    }
  }

  registerConverUpdate() {
    ZIMEventHandler.onConversationChanged = (conversationChangeInfoList) {
      for (ZIMConversationChangeInfo changeInfo in conversationChangeInfoList) {
        switch (changeInfo.event) {
          case ZIMConversationEvent.added:
            _converList.insert(0, changeInfo.conversation!);
            ConverListCell newConverListCell =
                ConverListCell(changeInfo.conversation!);
            _converWidgetList.insert(0, newConverListCell);
            if (subscriber != null) {
              subscriber!(_converWidgetList);
            }
            break;
          default:
        }
      }
    };
  }

  converListUpdate(ConverListUpdateCallBack callBack) {
    subscriber = callBack;
  }
}
