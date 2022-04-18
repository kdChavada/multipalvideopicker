import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'new_video_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<List<PlatformFile>> newVideoData = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multiple Video Picker"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform
                  .pickFiles(allowMultiple: true, type: FileType.video);

              print(result!.files.length);

              newVideoData.value = result.files;

              print(
                  "new video  Data  =============================${newVideoData.value.length}");
            },
            child: Container(
              height: h * 0.2,
              width: w,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Pick Video",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoView(
                            filesdata: newVideoData,
                          )));
              print(
                  "--------------******************---------${newVideoData.value[0].path}");
            },
            child: Container(
              height: h * 0.2,
              width: w,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Video View",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
