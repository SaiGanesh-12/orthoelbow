import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ViewVideo.dart';

class AddVideos extends StatefulWidget {
  const AddVideos({Key? key}) : super(key: key);

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _videoURL;
  late VideoPlayerController _controller;
  String? _downloadURL;
  double _uploadProgress = 0.0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('');
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Upload'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            children: [
              SizedBox(height: 270,),
              _videoURL != null
                  ? _videoPreviewWidget()
                  : Text('Add the video by clicking Pick video and upload it by keep name'),
              const SizedBox(height: 16.0),
              Center(
                child: Container(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      foregroundColor: Colors.white
                    ),
                    onPressed: _pickVideo,
                    child: const Text('Pick Video'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewVideoScreen()),
          );
        },
        child: Icon(Icons.video_library),
      ),
    );
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      final videoFile = result.files.first;
      _videoURL = videoFile.path;
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(_videoURL!)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  Widget _videoPreviewWidget() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),

        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _uploadVideo,
          child: const Text('UPLOAD'),
        ),
        const SizedBox(height: 16.0),
        Container(
          width: 200,
          height: 200,
          child: CircularProgressIndicatorWithLabel(
            value: _uploadProgress,
          ),
        ),
      ],
    );
  }

  Future<void> _uploadVideo() async {
    if (_videoURL == null || titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all the fields')),
      );
      return;
    }

    final videoFile = File(_videoURL!);
    final fileName = videoFile.path.split('/').last;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('videos/$fileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(videoFile);

    uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
      });
    });

    try {
      await uploadTask;
      final downloadURL = await ref.getDownloadURL();

      _downloadURL = downloadURL.toString();

      await _firestore.collection('Videos').add({
        'videoUrl': _downloadURL,
        'title': titleController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload video')),
      );
    }

    titleController.clear();
    setState(() {
      _videoURL = null;
      _uploadProgress = 0.0;
    });
  }
}

class CircularProgressIndicatorWithLabel extends StatelessWidget {
  final double value;

  const CircularProgressIndicatorWithLabel({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: value,
          strokeWidth: 8,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 8),
        Text('${(value * 100).toStringAsFixed(1)}%'),
      ],
    );
  }
}
