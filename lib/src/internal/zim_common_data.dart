import '../zim_defines.dart';

class ZIMCommonData {
  static  int _sequence = 0;

  static Map<int, ZIMMediaDownloadingProgress> mediaDownloadingProgressMap = {};

  static Map<int, ZIMMediaUploadingProgress> mediaUploadingProgressMap = {};

  static Map<int, ZIMMessage> messsageMap = {};

  static Map<int, ZIMMessageAttachedCallback> zimMessageAttachedCallbackMap =
      {};

  static int getSequence() {
    _sequence = _sequence + 1;
    return _sequence;
  }
}
