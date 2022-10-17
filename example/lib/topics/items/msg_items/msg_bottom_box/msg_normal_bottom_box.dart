import 'dart:developer';
import 'package:universal_io/io.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_bottom_box/msg_bottom_model.dart';

import 'msg_bottom_box_expand/msg_normal_bottom_box_expand.dart';

class MsgNormalBottomBox extends StatefulWidget {
  MsgNormalBottomBox(
      {required this.sendTextFieldonSubmitted,
      required this.onCameraIconButtonOnPressed,
      required this.onImageIconButtonOnPressed,
      required this.onVideoIconButtonOnPressed});

  Function? nonselfOnTapResponse;
  double boxBottomPadding = 50;
  bool emojiShowing = false;
  bool bottomExpandShowing = false;
  void Function(String) sendTextFieldonSubmitted;

  void Function(String?) onCameraIconButtonOnPressed;
  void Function(String?) onImageIconButtonOnPressed;
  void Function(String?) onVideoIconButtonOnPressed;
  @override
  State<StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends State<MsgNormalBottomBox> {
  String sendTextMessageValue = '';
  final TextEditingController _controller = TextEditingController();

  _onEmojiSelected(dynamic emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  void initState() {
    MsgBottomModel.nonselfOnTapResponse = () {
      widget.boxBottomPadding = 50;
      widget.emojiShowing = false;
      FocusScope.of(context).unfocus();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('ontap bottom box');
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, widget.boxBottomPadding),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(width: 1, color: Colors.grey.shade300)),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 12.0), //阴影xy轴偏移量
                blurRadius: 15.0, //阴影模糊程度
                spreadRadius: 4.0 //阴影扩散程度
                ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(
                //     onPressed: () {},
                //     icon: const Icon(
                //       Icons.multitrack_audio,
                //       size: 30,
                //     )),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular((20.0))),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onTap: () {
                        setState(() {
                          widget.boxBottomPadding = 10;
                          widget.emojiShowing = false;
                          widget.bottomExpandShowing = false;
                        });
                      },
                      onSubmitted: (value) {
                        widget.sendTextFieldonSubmitted(value);
                        FocusScope.of(context).unfocus();
                        _controller.text = '';
                        setState(() {
                          widget.boxBottomPadding = 50;
                        });
                        log(value);
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
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.bottomExpandShowing = false;
                    Future.delayed(kTabScrollDuration, () {
                      setState(() {
                        widget.emojiShowing = !widget.emojiShowing;
                        if (widget.emojiShowing) {
                          widget.boxBottomPadding = 10;
                        } else {
                          widget.boxBottomPadding = 50;
                        }
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 30,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        widget.emojiShowing = false;
                        widget.bottomExpandShowing =
                            !widget.bottomExpandShowing;
                        if (widget.bottomExpandShowing) {
                          widget.boxBottomPadding = 10;
                        } else {
                          widget.boxBottomPadding = 50;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_sharp,
                      size: 30,
                    )),
              ],
            ),
            Offstage(
              offstage: !widget.emojiShowing,
              child: Container(
                height: 250,
                width: double.infinity,
                child: EmojiPicker(

                    onEmojiSelected: (Category? category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        columns: 5,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.values[1],
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: false,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        // tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
            Offstage(
              offstage: !widget.bottomExpandShowing,
              child: MsgNormalBottomBoxExpand(
                onCameraIconButtonOnPressed: (path) {
                  widget.onCameraIconButtonOnPressed(path);
                },
                onImageIconButtonOnPressed: (path) {
                  widget.onImageIconButtonOnPressed(path);
                },
                onVideoIconButtonOnPressed: (path) {
                  widget.onVideoIconButtonOnPressed(path);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
