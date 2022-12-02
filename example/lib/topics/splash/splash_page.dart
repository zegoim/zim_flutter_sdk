import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/key_center/key_center.dart';
import 'package:zego_zim_example/topics/login/login_page.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list.dart';
import 'package:zego_zim_example/topics/menu/menu_page.dart';

import '../items/key_center/04_token_plugin/04_token_plugin.dart';
import '../login/user_model.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myState();
}

class _myState extends State<SplashPage> {
  Timer? _countTimer;
  int _countDown = 1;
  bool isResetZIM = false;
  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  //倒计时
  void _startCountDown() async {
    ZIMAppConfig appConfig = ZIMAppConfig();
    appConfig.appID = KeyCenter.appID;
    appConfig.appSign = KeyCenter.appSign;
    ZIM zim = ZIM.create(appConfig)!;

    log('create');
    final prefs = await SharedPreferences.getInstance();
    final String? userID = prefs.getString('userID');
    final String? userName = prefs.getString('userName');
    _countTimer = Timer.periodic(
      const Duration(seconds: 1), //刷新频率
      (timer) async {
        if (_countDown < 1) {
          _countTimer?.cancel();
          _countTimer = null;

          if (userID != null && userID != '' && isResetZIM == false) {
            ZIM.getInstance()!.destroy();
            log('destory');
            ZIM.create(appConfig);
            log('create');
            isResetZIM = true;
          }
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                transitionDuration:
                    const Duration(milliseconds: 1000), //动画时间为500毫秒
                pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) {
                  return FadeTransition(
                    //使用渐隐渐入过渡,
                    opacity: animation as Animation<double>,
                    child: LoginPage(), //路由B
                  );
                },
              ),
              (route) => false);
        } else {
          _countDown -= 1;
        }
      },
    );
    if (userID != null && userID != '') {
      String token = await TokenPlugin.makeToken(userID);
      ZIMUserInfo userInfo = ZIMUserInfo();
      userInfo.userID = userID;
      if (userName != null) {
        userInfo.userName = userName;
      }
      log('login');
      try {
        String token = await TokenPlugin.makeToken(userInfo.userID);

        await ZIM.getInstance()!.login(userInfo, token);
        log('success');
        _countTimer?.cancel();
        _countTimer = null;
        UserModel.shared().userInfo = userInfo;
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration:
                  const Duration(milliseconds: 1000), //动画时间为500毫秒
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return FadeTransition(
                  //使用渐隐渐入过渡,
                  opacity: animation as Animation<double>,
                  child: MenuPage(), //路由B
                );
              },
            ),
            (route) => false);
      } on PlatformException catch (onError) {
        _countTimer?.cancel();
        _countTimer = null;
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration:
                  const Duration(milliseconds: 1000), //动画时间为500毫秒
              pageBuilder: (BuildContext context, Animation animation,
                  Animation secondaryAnimation) {
                return FadeTransition(
                  //使用渐隐渐入过渡,
                  opacity: animation as Animation<double>,
                  child: LoginPage(), //路由B
                );
              },
            ),
            (route) => false);
      }
      // ZIM
      //     .getInstance()
      //     .login(userInfo, token)
      //     .then((value) => () {
      //           log('success');
      //           _countTimer?.cancel();
      //           _countTimer = null;
      //           UserModel.shared().userInfo = userInfo;
      //           Navigator.pushAndRemoveUntil(
      //               context,
      //               PageRouteBuilder(
      //                 transitionDuration:
      //                     const Duration(milliseconds: 1000), //动画时间为500毫秒
      //                 pageBuilder: (BuildContext context, Animation animation,
      //                     Animation secondaryAnimation) {
      //                   return FadeTransition(
      //                     //使用渐隐渐入过渡,
      //                     opacity: animation as Animation<double>,
      //                     child: MenuPage(), //路由B
      //                   );
      //                 },
      //               ),
      //               (route) => false);
      //         })
      //     .catchError((onError) {
      //   _countTimer?.cancel();
      //   _countTimer = null;
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       PageRouteBuilder(
      //         transitionDuration:
      //             const Duration(milliseconds: 1000), //动画时间为500毫秒
      //         pageBuilder: (BuildContext context, Animation animation,
      //             Animation secondaryAnimation) {
      //           return FadeTransition(
      //             //使用渐隐渐入过渡,
      //             opacity: animation as Animation<double>,
      //             child: LoginPage(), //路由B
      //           );
      //         },
      //       ),
      //       (route) => false);
      // });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _countTimer?.cancel();
    _countDown = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/images/liaotian.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 30),
            const Text(
              'ZEGO IM',
              textScaleFactor: 1.8,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ]),
    );
  }
}
