import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class UploadVideoScreen extends StatefulWidget {
  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final String accessToken = 'your-access-token';
  final String igUserId = 'your-ig-user-id';
  final String videoUrl = 'https://sparknet.wuaze.com/reel/reel.mp4';
  final String caption = 'Your video caption';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _uploadVideo,
        child: Text('Upload Video'),
      ),
    );
  }

  void _uploadVideo() async {
    final instagramUploader = InstagramUploader(accessToken, igUserId);

    await instagramUploader.uploadVideo(videoUrl, caption);
  }
}


class InstagramUploader {
  final String accessToken;
  final String igUserId;
  final Dio _dio = Dio();

  InstagramUploader(this.accessToken, this.igUserId);

  Future<void> uploadVideo(String videoUrl, String caption) async {
    try {
      // Step 1: Initiate the video upload
      Response response = await _dio.post(
        'https://graph.facebook.com/v16.0/$igUserId/media',
        data: {
          'media_type': 'VIDEO',
          'video_url': videoUrl,
          'caption': caption,
          'access_token': accessToken,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to initiate upload: ${response.data}');
      }

      String creationId = response.data['id'];

      // Step 2: Publish the video
      Response publishResponse = await _dio.post(
        'https://graph.facebook.com/v16.0/$igUserId/media_publish',
        data: {
          'creation_id': creationId,
          'access_token': accessToken,
        },
      );

      if (publishResponse.statusCode != 200) {
        throw Exception('Failed to publish video: ${publishResponse.data}');
      }

      print('Video published successfully: ${publishResponse.data}');
    } catch (e) {
      print('Error uploading video: $e');
    }
  }
}
