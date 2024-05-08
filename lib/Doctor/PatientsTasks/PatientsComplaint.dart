import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../DoctorhomeScreen.dart';

class Patientcomplaint extends StatefulWidget {
  final String pid;
  const Patientcomplaint({Key? key, required this.pid}) : super(key: key);

  @override
  State<Patientcomplaint> createState() => _PatientcomplaintState();
}

class _PatientcomplaintState extends State<Patientcomplaint> {
  TextEditingController patientComplaintController = TextEditingController();
  TextEditingController doctorSuggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0DA7A7),
      appBar: AppBar(
        title: Text(
          "Doctor's suggestions",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('patients').doc(widget.pid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
                if (data != null) {
                  // Set the text field values from Firestore data
                  patientComplaintController.text = data['pc'] ?? '';
                  doctorSuggestionController.text = data['ds'] ?? '';
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                          child: Text(
                            "Patient ",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 600,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Text(
                            "Doctor's Suggestion",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              controller: doctorSuggestionController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter doctor's suggestion",
                                contentPadding: EdgeInsets.symmetric(vertical: 70, horizontal: 10),
                              ),
                            ),
                          ),
                          Text(
                            "Patient's Complaint",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              enabled: false,
                              controller: patientComplaintController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Patient's complaint",
                                contentPadding: EdgeInsets.symmetric(vertical: 70, horizontal: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                _updateDoctorSuggestion();
                              },
                              child: Text(
                                "Send to Patient",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _updateDoctorSuggestion() {
    // Update doctor's suggestion in Firestore
    FirebaseFirestore.instance.collection('patients').doc(widget.pid).update({'ds': doctorSuggestionController.text}).then((_) {

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DoctorDashboard()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor\'s suggestion updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update doctor\'s suggestion: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
