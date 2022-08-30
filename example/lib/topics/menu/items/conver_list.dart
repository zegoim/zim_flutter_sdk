import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zego_zim/zego_zim.dart';
import 'conver_list_cell.dart';

class ConverList extends StatefulWidget {
  List<ZIMConversation> _converList = <ZIMConversation>[];
  List<ConverListCell> _converWidgetList = <ConverListCell>[];
  @override
  State<StatefulWidget> createState() => ConverListState();
}

class ConverListState extends State<ConverList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    if (widget._converWidgetList.isEmpty) getMoreConverWidgetList();
    registerConverUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      // 显示进度条
      controller: scrollController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        controller: scrollController,
        child: Center(
          child: Column(children: widget._converWidgetList),
        ),
      ),
    );
  }

  getMoreConverWidgetList() async {
    ZIMConversationQueryConfig queryConfig = ZIMConversationQueryConfig();
    queryConfig.count = 20;
    try {
      queryConfig.nextConversation = widget._converList.last;
    } on StateError {
      queryConfig.nextConversation = null;
    }
    try {
      ZIMConversationListQueriedResult result =
          await ZIM.getInstance()!.queryConversationList(queryConfig);
      widget._converList.addAll(result.conversationList);
      List<ConverListCell> newConverWidgetList = [];
      for (ZIMConversation newConversation in result.conversationList) {
        ConverListCell newConverListCell = ConverListCell(newConversation);
        newConverWidgetList.add(newConverListCell);
      }
      widget._converWidgetList.addAll(newConverWidgetList);
      setState(() {});
    } on PlatformException catch (onError) {
      return null;
    }
  }

  registerConverUpdate() {
    ZIMEventHandler.onConversationChanged = (zim, conversationChangeInfoList) {
      for (ZIMConversationChangeInfo changeInfo in conversationChangeInfoList) {
        switch (changeInfo.event) {
          case ZIMConversationEvent.added:
            widget._converList.insert(0, changeInfo.conversation!);
            ConverListCell newConverListCell =
                ConverListCell(changeInfo.conversation!);
            widget._converWidgetList.insert(0, newConverListCell);

            break;
          case ZIMConversationEvent.updated:
            ZIMConversation oldConver = widget._converList.singleWhere(
                (element) =>
                    element.conversationID ==
                    changeInfo.conversation?.conversationID);
            int oldConverIndex = widget._converList.indexOf(oldConver);
            widget._converList[oldConverIndex] = changeInfo.conversation!;
            ConverListCell oldConverListCell = widget._converWidgetList
                .singleWhere((element) => element.conversation == oldConver);
            int oldConverListCellIndex =
                widget._converWidgetList.indexOf(oldConverListCell);
            ConverListCell newConverListCell =
                ConverListCell(changeInfo.conversation!);
            widget._converWidgetList[oldConverListCellIndex] =
                newConverListCell;

            break;
          case ZIMConversationEvent.disabled:
            ZIMConversation oldConver = widget._converList.singleWhere(
                (element) =>
                    element.conversationID ==
                    changeInfo.conversation?.conversationID);
            int oldConverIndex = widget._converList.indexOf(oldConver);
            widget._converList.removeAt(oldConverIndex);
            ConverListCell oldConverListCell = widget._converWidgetList
                .singleWhere((element) => element.conversation == oldConver);
            int oldConverListCellIndex =
                widget._converWidgetList.indexOf(oldConverListCell);
            widget._converWidgetList.removeAt(oldConverListCellIndex);
            break;
          default:
        }
        setState(() {});
      }
    };
  }
}
