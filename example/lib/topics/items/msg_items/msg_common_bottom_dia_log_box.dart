import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_zim_example/topics/conversation/conver_model.dart';
import 'package:zego_zim_example/topics/menu/items/conver_list_cell.dart';

class BottomDiaLogBox extends StatefulWidget {
  ConverModel myModel;
  BottomDiaLogBox({required this.myModel});
  @override
  State<StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends State<BottomDiaLogBox> {
  String sendTextMessageValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 12.0), //阴影xy轴偏移量
              blurRadius: 15.0, //阴影模糊程度
              spreadRadius: 4.0 //阴影扩散程度
              ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular((20.0))),
              child: TextField(
                textInputAction: TextInputAction.send,
                onChanged: (value) {
                  sendTextMessageValue = value;
                },
                onEditingComplete: () {
                  //TODO:发送点击事件
                  if (sendTextMessageValue != '') {
                    widget.myModel.sendTextMessage(sendTextMessageValue);
                  }
                  FocusScope.of(context).unfocus();
                },
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, left: 15, right: 15),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_sharp,
                size: 30,
              )),
        ],
      ),
    );
  }
}
