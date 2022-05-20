import 'dart:math';
import 'package:zim/zim.dart';

class ZIMCommonData {
  static int progressSequence = 0;

  static Map<int, ZIMMediaDownloadingProgress> mediaDownloadingProgressMap = {};

  static Map<int, ZIMMediaUploadingProgress> mediaUploadingProgressMap = {};
}
