import 'package:flutter/material.dart';
import 'package:zego_zim_example/main.dart';

import '../topics/login/login_page.dart';

class RouteList {
  static Map<String, Widget> _routesMap = {};

  static Widget getRoluePage(String routeNamed, [Map? payloadMap]) {
    var targetPage = _routesMap[routeNamed];
    targetPage ??= pageFactory(routeNamed);
    return targetPage;
  }

  static Widget pageFactory(String routeNamed, [Map? payloadMap]) {
    var targetPage;
    switch (routeNamed) {
      case 'login_page':
        targetPage = LoginPage();
        break;
      default:

    }
    _routesMap[routeNamed] = targetPage;
    return targetPage;
  }
}
