import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orthoflexelbow/Doctor/DoctorhomeScreen.dart';

class CaseSheet extends StatefulWidget {
  final String pid;
  const CaseSheet({Key? key, required this.pid}) : super(key: key);

  @override
  State<CaseSheet> createState() => _CaseSheetState();
}

class _CaseSheetState extends State<CaseSheet> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void savePatientData() async {
    try {

      // Save patient details with photo URL to Firestore
      String pid = widget.pid;
      await _firestore.collection('patients').doc(pid).update({
        'ipno': _ipnumController.text,
        'address': _addressController.text,
        'DOA': _doaController.text,
        'DOS': _dosController.text,
        'DOD': _dodController.text,
        'Diagnosis': _diagnosisController.text,
        'procedure': _procedureController.text,
        'education': _educationController.text,
        'occupation':_occupationController.text,
        'mode of injury': _moiController.text,
        'cheif complaint': _ccController.text,
        'co-norbidities': _cmController.text,
        'drug history': _dhController.text,
        'past history': _pasthisController.text,
        'personal history': _perhisController.text,
        'system examination': _seController.text,
        'cardiovascular':_csController.text ,
        'respiratory system': _rsController.text,
        'abdomen': _abdomenController.text,
        'cns': _cnsController.text,
        'local examination': _leController.text,
        'right left upper': _rlulController.text,
        'soft  tissue': _stsController.text,
        'warmth': _warmthController.text,
        'swelling': _swellingController.text,
        'external injuries': _eiController.text,
        'range of movements': _romController.text,
        'sensations': _sensationsController.text,
        'distal pulse': _dpController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient details saved successfully')),
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DoctorDashboard()),
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

  TextEditingController _ipnumController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobilenoController = TextEditingController();
  TextEditingController _doaController = TextEditingController();
  TextEditingController _dosController = TextEditingController();
  TextEditingController _dodController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _procedureController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _moiController = TextEditingController();
  TextEditingController _ccController = TextEditingController();
  TextEditingController _cmController = TextEditingController();
  TextEditingController _dhController = TextEditingController();
  TextEditingController _pasthisController = TextEditingController();
  TextEditingController _perhisController = TextEditingController();
  TextEditingController _seController = TextEditingController();
  TextEditingController _csController = TextEditingController();
  TextEditingController _rsController = TextEditingController();
  TextEditingController _abdomenController = TextEditingController();
  TextEditingController _cnsController = TextEditingController();
  TextEditingController _leController = TextEditingController();
  TextEditingController _rlulController = TextEditingController();
  TextEditingController _stsController = TextEditingController();
  TextEditingController _warmthController = TextEditingController();
  TextEditingController _swellingController = TextEditingController();
  TextEditingController _eiController = TextEditingController();
  TextEditingController _romController = TextEditingController();
  TextEditingController _sensationsController = TextEditingController();
  TextEditingController _dpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Sheet'),
        backgroundColor: Color(0xFFD9D9D9),

      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF0DA7A7),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 30.0, bottom: 30.0),
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xFFD9D9D9),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      _buildTextField('IP Number', _ipnumController),
                      _buildTextField('Address', _addressController),

                      _buildText('Date of Admission', _doaController),
                      _buildText('Date of Surgery', _dosController),
                      _buildText('Date of Discharge', _dodController),
                      _buildTextField('Diagnosis', _diagnosisController),
                      _buildTextField('Procedure/Done', _procedureController),
                      _buildTextField('Education', _educationController),
                      _buildTextField('Occupation', _occupationController),
                      SizedBox(height: 30),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField('Mode of Injury', _moiController),
                      _buildTextField('Chief Complaint\'s', _ccController),
                      _buildTextField('Co-Morbidities', _cmController),
                      _buildTextField('Drug History', _dhController),
                      _buildTextField('Past History', _pasthisController),
                      _buildTextField('Personal History', _perhisController),
                      SizedBox(height: 30),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'General Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField('Systemic Examination', _seController),
                      _buildTextField('Cardiovascular System', _csController),
                      _buildTextField('Respiratory System', _rsController),
                      _buildTextField('Abdomen', _abdomenController),
                      _buildTextField('Central Nervous System', _cnsController),
                      SizedBox(height: 20),
                      _buildTextField('Local Examination', _leController),
                      _buildTextField('Right/Left Upper Limb', _rlulController),
                      _buildTextField('Soft Tissue Status', _stsController),
                      _buildTextField('Warmth', _warmthController),
                      _buildTextField('Swelling', _swellingController),
                      _buildTextField('External Injuries', _eiController),
                      _buildTextField('Range Of Movement', _romController),
                      _buildTextField('Sensations', _sensationsController),
                      _buildTextField('Distal Pulse', _dpController),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: savePatientData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 100),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 140.0,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18, // Use Sizer for responsive font sizing
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 18, // Use Sizer for responsive font sizing
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                isDense: true, // Reduce the height of the text field
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  _buildText(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        _pickDate(context, controller);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
      setState(() {
        controller.text = formattedDate; // Update the text field with the formatted date
      });
    }
  }


}