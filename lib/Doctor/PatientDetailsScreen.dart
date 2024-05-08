import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orthoflexelbow/Doctor/CaseSheet.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController numController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController dosController = TextEditingController();
  final TextEditingController pidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker(); // Create an instance of ImagePicker
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Detail\'s'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // This will navigate back
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF0DA7A7),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                            ),
                          ),
                        ),

                        buildTextField('Name', nameController),
                        buildTextFieldNo('Age', ageController),
                        buildTextField('Gender', genderController),
                        buildTextFieldNo('Mobile Number', numController),
                        buildTextFieldNo('Height', heightController),
                        buildTextFieldNo('Weight', weightController),
                        buildTextField('Village', villageController),
                        buildTextField('DOS', dosController),
                        buildTextField('PID', pidController),
                        buildTextField('Password', passwordController),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            savePatientData();
                          },
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildTextFieldNo(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          SizedBox(
            width: 10.0,
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          SizedBox(
            width: 10.0,
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void savePatientData() async {
    try {
      // Upload image to Firebase Storage
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('profile_pics').child(imageFileName);
      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String photoUrl = await snapshot.ref.getDownloadURL();

      // Save patient details with photo URL to Firestore
      String pid = pidController.text;
      await _firestore.collection('patients').doc(pid).set({
        'name': nameController.text,
        'age': ageController.text,
        'gender': genderController.text,
        'num': numController.text,
        'height': heightController.text,
        'weight': weightController.text,
        'village': villageController.text,
        'dos': dosController.text,
        'password': passwordController.text,
        'pid':pid,
        'pc':'nil',
        'ds':'nil',
        'photoUrl': photoUrl, // Add the photo URL to Firestore
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient details saved successfully')),
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CaseSheet(pid: pid)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save patient details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


}
