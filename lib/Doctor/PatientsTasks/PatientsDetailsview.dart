import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PatientsDetailsView extends StatefulWidget {
  final String pid;
  const PatientsDetailsView({Key? key, required this.pid}) : super(key: key);

  @override
  State<PatientsDetailsView> createState() => _PatientsDetailsViewState();
}

class _PatientsDetailsViewState extends State<PatientsDetailsView> {
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

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    try {
      String pid = widget.pid;
      DocumentSnapshot snapshot =
      await _firestore.collection('patients').doc(pid).get();
      var data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          nameController.text = data['name'] ?? '';
          ageController.text = data['age'] ?? '';
          genderController.text = data['gender'] ?? '';
          numController.text = data['num'] ?? '';
          heightController.text = data['height'] ?? '';
          weightController.text = data['weight'] ?? '';
          villageController.text = data['village'] ?? '';
          dosController.text = data['dos'] ?? '';
          pidController.text = data['pid'] ?? '';
          passwordController.text = data['password'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch patient details: $e'),
          backgroundColor: Colors.red,
        ),
      );
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


                        buildTextField('Name', nameController),
                        buildTextField('Age', ageController),
                        buildTextField('Gender', genderController),
                        buildTextField('Mobile Number', numController),
                        buildTextField('Height', heightController),
                        buildTextField('Weight', weightController),
                        buildTextField('Village', villageController),
                        buildTextField('DOS', dosController),
                        buildTextField('PID', pidController),
                        buildTextField('Password', passwordController),
                        SizedBox(height: 20),

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
              readOnly: true,
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




}
