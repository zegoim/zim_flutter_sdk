import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_bottom_box/msg_bottom_box_expand/msg_bottom_box_expand_cell.dart';

class MsgNormalBottomBoxExpand extends StatefulWidget {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  XFile? video;

  @override
  State<StatefulWidget> createState() => MsgNormalBottomBoxExpandState();
}

class MsgNormalBottomBoxExpandState extends State<MsgNormalBottomBoxExpand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      child: GridView(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1.0),
        children: <Widget>[
          MsgBottomBoxExpandCell(
            targetIconButton: IconButton(
              onPressed: () async {
                final XFile? photo =
                    await widget._picker.pickImage(source: ImageSource.camera);
              },
              icon: Icon(
                Icons.camera_alt_outlined,
                size: 30,
              ),
            ),
          ),
          MsgBottomBoxExpandCell(
            targetIconButton: IconButton(
              onPressed: () async {
                widget.image =
                    await widget._picker.pickImage(source: ImageSource.gallery);
              },
              icon: Icon(
                Icons.photo_size_select_actual_outlined,
                size: 30,
              ),
            ),
          ),
          MsgBottomBoxExpandCell(
            targetIconButton: IconButton(
              onPressed: () async {
                widget.video =
                    await widget._picker.pickVideo(source: ImageSource.gallery);
              },
              icon: Icon(
                Icons.videocam_outlined,
                size: 30,
              ),
            ),
          ),
          MsgBottomBoxExpandCell(
            targetIconButton: IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                
                // String? path = await FilesystemPicker.open(
                //     context: context, rootDirectory: Directory('rootPath'));
              },
              icon: Icon(
                Icons.folder_outlined,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
