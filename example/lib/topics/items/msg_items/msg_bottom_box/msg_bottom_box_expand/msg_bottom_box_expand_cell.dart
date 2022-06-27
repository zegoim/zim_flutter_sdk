import 'package:flutter/material.dart';

class MsgBottomBoxExpandCell extends StatefulWidget {
  IconButton targetIconButton;

  MsgBottomBoxExpandCell({required this.targetIconButton});

  @override
  State<StatefulWidget> createState() => _MsgBottomBoxExpandCellState();
}

class _MsgBottomBoxExpandCellState extends State<MsgBottomBoxExpandCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 40,right: 20),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      width: 300,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.grey.shade200,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.grey),
      ),
      child: widget.targetIconButton,
    );
  }
}
