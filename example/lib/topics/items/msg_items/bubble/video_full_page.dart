import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullPage extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoFullPage({Key? key, required this.controller}) : super(key: key);

  @override
  _VideoFullPageState createState() => _VideoFullPageState();
}

class _VideoFullPageState extends State<VideoFullPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: Hero(
                    tag: "player",
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      widget.controller.pause();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          Navigator.pop(context);
          return false;
        });
  }
}
