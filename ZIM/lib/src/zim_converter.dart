import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import 'zim_define.dart';
import 'zim_define_extension.dart';
import 'zim_errorCode_extension.dart';

//MARK: Tools
class ZIMConverter {
  static ZIMLoggedInResult CNVLoggedInMap(Map resultMap) {
    ZIMError errorInfo = ZIMError();
    Map errorMap = resultMap["ZIMError"];

    errorInfo.code = ZIMErrorCodeExtension.mapValue[errorMap['code']];
    errorInfo.message = errorMap['message'];
    return ZIMLoggedInResult(errorInfo: errorInfo);
  }
}
