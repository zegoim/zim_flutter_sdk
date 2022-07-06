import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:zego_zim_example/topics/items/msg_items/bubble/video_full_page.dart';

class VideoBubble extends StatefulWidget {
  VideoBubble({required this.filelocalPath}) {
    image = FileImage(File(filelocalPath));
    _controller = VideoPlayerController.file(File(filelocalPath));
  }
  String filelocalPath;
  FileImage? image;
  @override
  State<StatefulWidget> createState() => VideoBubbleState();
  //final String localPath;
  VideoPlayerController? _controller;
}

class VideoBubbleState extends State<VideoBubble> {
  startPlayer() {
    widget._controller!.play();
    return VideoFullPage(controller: widget._controller!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('message');
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return ScaleTransition(
                //使用渐隐渐入过渡,
                // alignment: ,
                scale: animation as Animation<double>,
                child: GestureDetector(
                  onTap: () {
                  //  Navigator.pop(context);
                  },
                  child: startPlayer(),
                ));
          },
        ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 200.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).brightness == Brightness.light
                  ? Color.fromRGBO(237, 237, 237, 1)
                  : Color.fromRGBO(17, 17, 17, 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: FutureBuilder(
                        //显示缩略图

                        future: widget._controller!.initialize(),

                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio: 2 / 3,

                              // aspectRatio: _controller.value.aspectRatio,

                              child: VideoPlayer(widget._controller!),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  /* 播放 按钮所在位置 大小 可根据实际项目 需要 调整 */

                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
