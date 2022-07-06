import 'dart:math';

class UUIDCenter{
    static get uuid {
    String randomstr = Random().nextInt(10).toString();
    for (var i = 0; i < 3; i++) {
      var str = Random().nextInt(10);
      randomstr = "$randomstr" + "$str";
    }
    var timenumber = DateTime.now().millisecondsSinceEpoch;//时间
    var uuid = "$randomstr" + "$timenumber";
    return uuid;
  }
}