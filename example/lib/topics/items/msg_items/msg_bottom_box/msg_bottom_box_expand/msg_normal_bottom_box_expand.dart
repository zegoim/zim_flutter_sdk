import 'dart:developer';
import 'package:universal_io/io.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zim_example/topics/items/common_items/uuid_center.dart';
import 'package:zego_zim_example/topics/items/msg_items/msg_bottom_box/msg_bottom_box_expand/msg_bottom_box_expand_cell.dart';

class MsgNormalBottomBoxExpand extends StatefulWidget {
  MsgNormalBottomBoxExpand(
      {required this.onCameraIconButtonOnPressed,
      required this.onImageIconButtonOnPressed,
      required this.onVideoIconButtonOnPressed});
  void Function(String? photo) onCameraIconButtonOnPressed;
  void Function(String? path) onImageIconButtonOnPressed;
  void Function(String? path) onVideoIconButtonOnPressed;
  // void Function()? onImageIconButtonOnPressed;
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
                final XFile? cameraPhoto = await widget._picker
                    .pickImage(source: ImageSource.camera, imageQuality: 30);

                final String path =
                    (await getApplicationDocumentsDirectory()).path;
                File cameraPhotoFile = File(cameraPhoto!.path);
                final File newImage =
                    await cameraPhotoFile.copy('$path/${cameraPhoto.name}');
                widget.onCameraIconButtonOnPressed(newImage.path);
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
                final XFile? albumPhoto =
                    await widget._picker.pickImage(source: ImageSource.gallery);
                final String path =
                    (await getApplicationDocumentsDirectory()).path;

                File albumPhotoFile = File(albumPhoto!.path);
                final File newImage =
                    await albumPhotoFile.copy('$path/${albumPhoto.name}');

                widget.onImageIconButtonOnPressed(newImage.path);
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
                final XFile? albumVideo =
                    await widget._picker.pickVideo(source: ImageSource.gallery);
                log(albumVideo!.path);
                final String path =
                    (await getApplicationDocumentsDirectory()).path;

                File albumVideoFile = File(albumVideo.path);
                final File newVideo =
                    await albumVideoFile.copy('$path/${UUIDCenter.uuid}.mp4');
                widget.onVideoIconButtonOnPressed(newVideo.path);
              },
              icon: Icon(
                Icons.videocam_outlined,
                size: 30,
              ),
            ),
          ),
          // MsgBottomBoxExpandCell(
          //   targetIconButton: IconButton(
          //     onPressed: () async {
          //       FilePickerResult? result =
          //           await FilePicker.platform.pickFiles();

          //       // String? path = await FilesystemPicker.open(
          //       //     context: context, rootDirectory: Directory('rootPath'));
          //     },
          //     icon: Icon(
          //       Icons.folder_outlined,
          //       size: 30,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
