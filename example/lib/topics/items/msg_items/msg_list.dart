import 'package:flutter/material.dart';
import 'package:zego_zim_example/topics/conversation/conver_model.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_text_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_text_msg_cell.dart';

class MsgList extends StatefulWidget {
  MsgList({required this.converModel});
  ConverModel converModel;

  @override
  State<StatefulWidget> createState() => _MyState();
}

class _MyState extends State<MsgList> {
  List<Widget> _messageCellList = [];

  ScrollController scrollController = ScrollController();

  // void _scrollToend() {
  //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
  // }

  getMessageList() {
    List<Widget> targetList = [];
    _messageCellList = widget.converModel.getCurrentMessageWidgetList();
    targetList.addAll(_messageCellList);

    widget.converModel.updateMessageWidgetList((converWidgetList) {
      setState(() {});
      scrollController.animateTo(
        scrollController.position.maxScrollExtent, //滚动到底部

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeOut,
      );
    });
    targetList.add(SizedBox(height: 200));
    return targetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // 显示进度条
      controller: scrollController,
      child: SingleChildScrollView(
        // padding: EdgeInsets.only(bottom: 20),
        controller: scrollController,
        primary: false,
        child: Center(
          child: Column(
              //动态创建一个List<Widget>

              children: getMessageList()),
        ),
      ),
    );
  }
}
