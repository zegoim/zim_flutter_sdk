@JS('ZIM')
library zim_web;

import 'package:js/js.dart';
import 'package:zego_zim/src/internal/zim_utils_web.dart';

@JS()
class ZIM {
  external static String getVersion();
  external static ZIM? create(dynamic appConfig);
  external static void destroy();
  external static ZIM? getInstance();
  external PromiseJsImpl<dynamic> login(ZIMUserInfo userInfo, String token);
}

@JS()
@anonymous
class ZIMAppConfig {
  external factory ZIMAppConfig({int appID});

  external int get appID;
}

@JS()
@anonymous
class ZIMUserInfo {
  external factory ZIMUserInfo({String userID, String userName});

  external String get userID;
  external String get userName;
}
