import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:zim/zim.dart';
import 'zim_define.dart';

class ZIMEventHandler {
  static void Function(
          ZIMConnectionState state, ZIMConnectionEvent event, Map extendedData)?
      connectionStateChanged;

  //static
}
