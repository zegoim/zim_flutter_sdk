import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zego_zim_example/topics/login/login_page.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list.dart';
import 'package:zego_zim_example/topics/menu/menu_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myState();
}

class _myState extends State<SplashPage> {
  Timer? _countTimer;
  int _countDown = 1;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  //倒计时
  void _startCountDown() {
    _countTimer = Timer.periodic(
      const Duration(seconds: 1), //刷新频率
      (timer) {
        setState(() {
          if (_countDown < 1) {
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
            _countTimer?.cancel();
            _countTimer = null;
          } else {
            _countDown -= 1; //计数器减1
          }
        });
      },
    );
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
