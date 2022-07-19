import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zim_example/topics/items/msg_items/receive_items/receive_image_msg_cell.dart';
import 'package:zego_zim_example/topics/items/msg_items/send_items/send_image_msg_cell.dart';

class MsgList extends StatefulWidget {
  MsgList(List<Widget> historyMessageWidgetList,
      {required this.loadMoreHistoryMsg})
      : _historyMessageWidgetList = historyMessageWidgetList;

  final List<Widget> _historyMessageWidgetList;

  Function loadMoreHistoryMsg;

  ScrollController scrollController = ScrollController();

  @override
  State<StatefulWidget> createState() => MsgListState();
}

class MsgListState extends State<MsgList> {
  bool isInvokeQueryMethod = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MsgList oldWidget) {
    super.didUpdateWidget(oldWidget);
    isInvokeQueryMethod = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.scrollController,
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          double progressMedian = notification.metrics.pixels /
              notification.metrics.maxScrollExtent;
          int progress = (progressMedian * 100).toInt();

          if (progress >= 90 && !isInvokeQueryMethod) {
            log('该刷新了');
            widget.loadMoreHistoryMsg();
            isInvokeQueryMethod = true;
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: widget.scrollController,
          reverse: true,
          child: Center(
            child: Column(
              children: widget._historyMessageWidgetList,
              //children: [],
            ),
          ),
        ),
      ),
    );
  }
}
