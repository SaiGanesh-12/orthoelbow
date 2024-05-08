import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orthoflexelbow/PatientsScreen/PatientHomeScreen.dart';

class PatientReview extends StatefulWidget {
  final String pid;
  const PatientReview({Key? key, required this.pid}) : super(key: key);

  @override
  State<PatientReview> createState() => _PatientReviewState();
}

class _PatientReviewState extends State<PatientReview> {
  late TextEditingController dateOfAdmissionController;
  late TextEditingController dateOfSurgeryController;
  late TextEditingController postOpDateController;

  @override
  void initState() {
    super.initState();
    dateOfAdmissionController = TextEditingController();
    dateOfSurgeryController = TextEditingController();
    postOpDateController = TextEditingController();
    _fetchPatientData();
  }

  @override
  void dispose() {
    dateOfAdmissionController.dispose();
    dateOfSurgeryController.dispose();
    postOpDateController.dispose();
    super.dispose();
  }

  File? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final destination = 'review_photos/$fileName';
        await firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .putFile(_imageFile!);

        // Get download URL
        final downloadUrl = await firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _fetchPatientData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.pid)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        dateOfAdmissionController.text = data?['DOA'] ?? '';
        dateOfSurgeryController.text = data?['DOS'] ?? '';
        final postOpDate = DateTime.now()
            .difference(DateTime.parse(data?['DOS'] ?? ''))
            .inDays;
        postOpDateController.text = postOpDate.toString();
      }

    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  Future<void> _submitReview() async {
    try {
      await _uploadImage();

      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.pid)
          .set({
        'dateOfAdmission': dateOfAdmissionController.text,
        'dateOfSurgery': dateOfSurgeryController.text,
        'postOpDate': postOpDateController.text,
        'imageUrl': _imageUrl ?? '',
        'woundStatus': [],
        'rangeOfMovements': [],
        'flexion': [],
        'extension': [],
        'internalRotation': [],
        'externalRotation': [],
        'pronation': [],
        'supination': [],
        // Add other fields as needed
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PatientHomeScreen(pid: widget.pid)),
      );
    } catch (e) {
      print('Error submitting review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      appBar: AppBar(
        title: Text('Review Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: dateOfAdmissionController,
                  decoration: InputDecoration(
                    hintText: 'Date of admission',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Date of Surgery:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: dateOfSurgeryController,
                  decoration: InputDecoration(
                    hintText: 'Date of surgery',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Post-op Date:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: postOpDateController,
                  decoration: InputDecoration(
                    hintText: 'Post-op date',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Clinical Image:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[100],
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : Icon(Icons.image),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitReview,
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
