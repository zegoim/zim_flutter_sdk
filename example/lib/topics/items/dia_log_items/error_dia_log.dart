import 'package:flutter/material.dart';

class ErrorDiaLog {
  static Future<bool?> showFailedDialog(BuildContext context,
      String code, String message) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Error",
            ),
            content: Text('code:' + code + '\n\n' + 'message:' + message),
            actions: <Widget>[
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  child: const Text('OK'))
            ],
          );
        });
  }
}
