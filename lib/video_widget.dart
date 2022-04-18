import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FileVideoWidget extends StatefulWidget {
  String? path;
  int? index;

  ValueNotifier<List<PlatformFile>> filesdata = ValueNotifier([]);
  FileVideoWidget(
      {required this.path,  this.index,required this.filesdata});

  @override
  _FileVideoWidgetState createState() => _FileVideoWidgetState();
}

class _FileVideoWidgetState extends State<FileVideoWidget> {
  late VideoPlayerController _controller;
  ValueNotifier<bool> ismute = ValueNotifier(false);
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(
      File(widget.path!),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    print(_controller.value.aspectRatio);
    print((w * 0.95) / (w - 90));
    return Container(
      width: w,
      margin: const EdgeInsets.all(10.0),
      height: w,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  Container(
                    height: w,
                    width: _controller.value.aspectRatio <= 1
                        ? w * _controller.value.aspectRatio
                        : w,
                    child: VideoPlayer(_controller),
                  ),
                  !_controller.value.isPlaying
                      ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.play();
                      });
                    },
                    child: const Center(
                      child: Image(
                        image:
                        AssetImage("assets/images/video_play.png"),
                        height: 64,
                        width: 64,
                      ),
                    ),
                  )
                      : GestureDetector(
                    child: Container(color: Colors.transparent),
                    onTap: () {
                      setState(() {
                        _controller.pause();
                      });
                    },
                  ),
                  Positioned(
                    bottom: 12.0,
                    right: 12.0,
                    child: ValueListenableBuilder(
                      valueListenable: ismute,
                      builder: (context, dynamic v, c) {
                        return GestureDetector(
                          onTap: () {
                            ismute.value
                                ? _controller.setVolume(100.0)
                                : _controller.setVolume(0.0);
                            ismute.value = !ismute.value;
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: const BoxDecoration(
                                color: Color(0x80000000),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                v
                                    ? CupertinoIcons.volume_off
                                    : CupertinoIcons.volume_up,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12.0,
                    right: 12.0,
                    child: ValueListenableBuilder(
                      valueListenable: ismute,
                      builder: (context, dynamic v, c) {
                        return GestureDetector(
                          onTap: () {
                            widget.filesdata.value.removeAt(widget.index!);

                            widget.filesdata.notifyListeners();

                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: const BoxDecoration(
                                color: Color(0x80000000),
                                shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.close_rounded,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: false,
                    colors: const VideoProgressColors(
                        bufferedColor: Colors.grey,
                        playedColor: Colors.blue,
                        backgroundColor: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}