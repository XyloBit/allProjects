import 'package:alluploadapp/post.dart';
import 'package:alluploadapp/test.dart';
import 'package:alluploadapp/video_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: VideoUploader(),
      home: UploadVideoScreen(),
      // home: TestClass(),
    );
  }
}

