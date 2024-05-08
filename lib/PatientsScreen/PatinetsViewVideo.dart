import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PatientViewVideo extends StatefulWidget {
  const PatientViewVideo({Key? key}) : super(key: key);

  @override
  State<PatientViewVideo> createState() => _PatientViewVideoState();
}

class _PatientViewVideoState extends State<PatientViewVideo> {
  late List<Map<String, String>> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('Videos').get();
      setState(() {
        _videos = snapshot.docs
            .map((doc) => {
          'videoUrl': doc['videoUrl'] as String,
          'title': doc['title'] as String,
        })
            .toList();
      });
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Videos'),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.teal[400],
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                _videos[index]['title'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: _videos[index]['videoUrl'] ?? '',
                    ),
                  ),
                );
              },
              trailing: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
              ),
            ),
          );
        },
      ),

    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    VideoPlayerController controller = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
}

