import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CaseSheetView extends StatefulWidget {
  final String pid;
  const CaseSheetView({Key? key, required this.pid}) : super(key: key);

  @override
  State<CaseSheetView> createState() => _CaseSheetViewState();
}

class _CaseSheetViewState extends State<CaseSheetView> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }
  void fetchPatientData() async {
    try {
      // Save patient details with photo URL to Firestore
      String pid = widget.pid;
      print(pid);


      // Assign values back to controllers
      DocumentSnapshot snapshot = await _firestore.collection('patients').doc(pid).get();
      var data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        _ipnumController.text = data['ipno'] ?? '';
        _addressController.text = data['address'] ?? '';
        _doaController.text = data['DOA'] ?? '';
        _dosController.text = data['DOS'] ?? '';
        _dodController.text = data['DOD'] ?? '';
        _diagnosisController.text = data['Diagnosis'] ?? '';
        _procedureController.text = data['procedure'] ?? '';
        _educationController.text = data['education'] ?? '';
        _occupationController.text = data['occupation'] ?? '';
        _moiController.text = data['mode of injury'] ?? '';
        _ccController.text = data['cheif complaint'] ?? '';
        _cmController.text = data['co-norbidities'] ?? '';
        _dhController.text = data['drug history'] ?? '';
        _pasthisController.text = data['past history'] ?? '';
        _perhisController.text = data['personal history'] ?? '';
        _seController.text = data['system examination'] ?? '';
        _csController.text = data['cardiovascular'] ?? '';
        _rsController.text = data['respiratory system'] ?? '';
        _abdomenController.text = data['abdomen'] ?? '';
        _cnsController.text = data['cns'] ?? '';
        _leController.text = data['local examination'] ?? '';
        _rlulController.text = data['right left upper'] ?? '';
        _stsController.text = data['soft  tissue'] ?? '';
        _warmthController.text = data['warmth'] ?? '';
        _swellingController.text = data['swelling'] ?? '';
        _eiController.text = data['external injuries'] ?? '';
        _romController.text = data['range of movements'] ?? '';
        _sensationsController.text = data['sensations'] ?? '';
        _dpController.text = data['distal pulse'] ?? '';
      }
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
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
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

  Future<void> _pickDate(BuildContext context,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(
          pickedDate); // Format the date
      setState(() {
        controller.text =
            formattedDate; // Update the text field with the formatted date
      });
    }
  }
}


