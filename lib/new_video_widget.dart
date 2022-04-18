import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:multipalvideopicker/video_widget.dart';

class VideoView extends StatefulWidget {

  ValueNotifier<List<PlatformFile>> filesdata = ValueNotifier([]);

  VideoView({Key? key,  required this.filesdata})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video view "),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: widget.filesdata,
          builder: (context,a,d) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.filesdata.value.length, (index) {
                  return FileVideoWidget(
                    path: widget.filesdata.value[index].path,
                    index: index, filesdata: widget.filesdata,
                  );
                }));
          }
        ),
      ),
    );
  }
}
