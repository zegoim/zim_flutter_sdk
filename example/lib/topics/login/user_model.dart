import 'package:flutter/cupertino.dart';
import 'package:zego_zim/zego_zim.dart';

class UserModel {

  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  static UserModel? _userModel;

  static UserModel shared() {
    _userModel ??= UserModel();
    return _userModel!;
  }

  static release() {
    _userModel = null;
  }

  get preferenceToUserName {
    if (UserModel.shared().userInfo == null) {
      return "";
    }

    if (UserModel.shared().userInfo!.userName != "") {
      return UserModel.shared().userInfo!.userName;
    } else {
      return UserModel.shared().userInfo!.userID;
    }
  }

  ZIMUserInfo? userInfo;
}
