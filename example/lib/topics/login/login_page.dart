import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';
import 'package:zego_zim_example/topics/menu/menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  ZIMUserInfo userInfo = ZIMUserInfo();
  String token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        shadowColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  const SizedBox(width: 50),
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
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.25),
                  borderRadius: BorderRadius.circular((20.0)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    userInfo.userID = value;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 0, left: 15, right: 15),
                      border: InputBorder.none,
                      labelText: 'User ID'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.25),
                  borderRadius: BorderRadius.circular((20.0)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    userInfo.userName = value;
                  },
                  onEditingComplete: () {
                    //TODO:发送点击事件
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 0, left: 15, right: 15),
                      border: InputBorder.none,
                      labelText: 'User Name'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.25),
                  borderRadius: BorderRadius.circular((20.0)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    token = value;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 0, left: 15, right: 15),
                      border: InputBorder.none,
                      labelText: 'Token'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: (() async {
                    try {
                      await ZIM.getInstance().login(userInfo, token);
                      log('success');
                      UserModel.shared().userInfo = userInfo;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MenuPage();
                      }));
                    } on PlatformException catch (onError) {
                      log(onError.code);
                      log(onError.message!);
                    }
                  }),
                  child: const Text('login'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
