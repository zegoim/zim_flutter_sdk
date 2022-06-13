import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim_example/topics/menu/menu_model.dart';
import 'conver_list_cell.dart';

class ConverList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myState();
}

class _myState extends State<ConverList> {
  List<ConverListCell> _converList =
      MenuModel.shared().getCurrentConverWidgetList();
  
  getConverList() {
    MenuModel.shared().converListUpdate((converWidgetList) {
      setState(() {
        _converList = converWidgetList;
      });
    });
    return _converList;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: getConverList()
          ),
        ),
      ),
    );
  }
}
