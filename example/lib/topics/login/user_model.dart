import 'package:zego_zim/zego_zim.dart';

class UserModel {
  static UserModel? _userModel;

  static UserModel shared() {
    _userModel ??= UserModel();
    return _userModel!;
  }

  static release() {
    _userModel = null;
  }

  ZIMUserInfo? userInfo;
}
