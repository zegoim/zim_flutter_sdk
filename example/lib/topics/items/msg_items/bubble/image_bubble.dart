import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageBubble extends StatefulWidget {
  ImageBubble({required this.filelocalPath}) {
    image = FileImage(File(filelocalPath));
  }
  String filelocalPath;
  ImageProvider<Object>? image;
  @override
  State<StatefulWidget> createState() => ImageBubbleState();
  //final String localPath;
}

class ImageBubbleState extends State<ImageBubble> {
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
                    Navigator.pop(context);
                  },
                  child: PhotoView(imageProvider: widget.image),
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
                child: Image(image: widget.image!)),
          ),
        ),
      ),
    );
  }
}
