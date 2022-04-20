import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import '../zim_defines.dart';
import 'zim_defines_extension.dart';

//MARK: Tools
class ZIMConverter {
  // static ZIMLoggedInResult CNVLoggedInMap(Map resultMap) {
  //   ZIMError errorInfo = ZIMError();
  //   Map errorMap = resultMap["ZIMError"];

  //   errorInfo.code = errorMap['code'];
  //   errorInfo.message = errorMap['message'];
  //   return ZIMLoggedInResult(errorInfo: errorInfo);
  // }
  static ZIMTokenRenewedResult cnvTokenRenewedMapToObject(Map resultMap) {
    String token = resultMap['token'];

    return ZIMTokenRenewedResult(token: token);
  }

  static ZIMUsersInfoQueriedResult cnvUsersInfoQueriedMapToObject(
      Map resultMap) {
    List userListBasic = resultMap['userList'];
    List errorUserListBasic = resultMap['errorUserList'];

    List<ZIMUserInfo> userList = [];
    for (Map userInfoMap in userListBasic) {
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = userInfoMap['userID'];
      userInfo.userName = userInfoMap['userName'];
      userList.add(userInfo);
    }

    List<ZIMErrorUserInfo> errorUserList = [];
    for (Map userInfoMap in errorUserListBasic) {
      ZIMErrorUserInfo errorUserInfo = ZIMErrorUserInfo();
      errorUserInfo.userID = userInfoMap['userID'];
      errorUserInfo.reason = userInfoMap['reason'];
      errorUserList.add(errorUserInfo);
    }

    return ZIMUsersInfoQueriedResult(
        userList: userList, errorUserList: errorUserList);
  }
}
