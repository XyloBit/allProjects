import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class VideoUploader extends StatefulWidget {
  @override
  _VideoUploaderState createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  String? _uploadStatus;
  Future<void> pickAndUploadVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null) {
        File videoFile = File(result.files.single.path!);
        uploadVideo(videoFile);
      } else {
        setState(() {
          _uploadStatus = "No file selected.";
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = "Error: $e";
      });
    }
  }

  void uploadVideo(File videoFile) async {
    String uploadUrl = "https://sparknet.wuaze.com/reel/";

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(videoFile.path, filename: videoFile.path.split('/').last),
    });

    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    dio.options.headers['Connection'] = 'keep-alive';

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      setState(() {
        _uploadStatus = "Upload successful: ${response.statusCode}";
      });
    } catch (e) {
      print("Error is: $e");
      setState(() {
        _uploadStatus = "Upload failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Uploader"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickAndUploadVideo,
              child: Text("Pick and Upload Video"),
            ),
            if (_uploadStatus != null) ...[
              SizedBox(height: 20),
              Text(
                _uploadStatus!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
