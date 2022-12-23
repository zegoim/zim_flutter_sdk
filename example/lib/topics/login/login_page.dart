import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/dia_log_items/error_dia_log.dart';
import 'package:zego_zim_example/topics/items/key_center/04_token_plugin/04_token_plugin.dart';
import 'package:zego_zim_example/topics/login/user_model.dart';
import 'package:zego_zim_example/topics/menu/menu_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  bool isUseToken = false;
  String token = "";
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  ZIMUserInfo userInfo = ZIMUserInfo();

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text("loading..."),
              )
            ],
          ),
        );
      },
    );
  }

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
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('use token'),
                      Switch(
                          value: widget.isUseToken,
                          onChanged: (onChanged) {
                            setState(() {
                              widget.isUseToken = onChanged;
                            });
                          })
                    ],
                  )),
              ElevatedButton(
                onPressed: (() async {
                  if (widget.isUseToken) {
                    showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "please input token",
                            ),
                            content: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 0.25),
                                //borderRadius: BorderRadius.circular((20.0)),
                              ),
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  widget.token = value;
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 0, left: 15, right: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: (() {
                                    login(widget.token);
                                    Navigator.of(context).pop();
                                  }),
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  } else {
                    login("");
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

  login(String token) async {
    try {
      showLoadingDialog();
      await ZIM.getInstance()!.login(userInfo, token);
      Navigator.of(context).pop;
      log('success');
      UserModel.shared().userInfo = userInfo;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userID', userInfo.userID);
      await prefs.setString('userName', userInfo.userName);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: ((context) {
        return MenuPage();
      })), (route) => false);
    } on PlatformException catch (onError) {
      Navigator.of(context).pop();
      bool? delete = await ErrorDiaLog.showFailedDialog(
          context, onError.code, onError.message!);
    }
  }
}
