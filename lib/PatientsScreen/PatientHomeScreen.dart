import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orthoflexelbow/Doctor/PatientsTasks/Review.dart';
import 'package:orthoflexelbow/PatientsScreen/PEditProfile.dart';
import 'package:orthoflexelbow/PatientsScreen/ViewTask.dart';
import 'package:orthoflexelbow/PatientsScreen/quiz.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Doctor/PatientsTasks/Graphs.dart';
import '../login_option_screen.dart';
import 'Complaints.dart';
import 'PatinetsViewVideo.dart';
import 'ReviewPt.dart';

class PatientHomeScreen extends StatefulWidget {
  final String pid;
  const PatientHomeScreen({Key? key, required this.pid}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  late String name="";
  late String email="";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override

  Future<int?> getDoctorMobile() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctor')
          .doc('XWHm3vnIM5OB9JODo11AIzCg2fu2')
          .get();

      if (snapshot.exists) {
        // Extract mobile field value
        dynamic mobile = snapshot.get('mobile');
        if (mobile != null) {
          // Return mobile value
          return int.tryParse(mobile.toString());
        }
      }

      // Return null if mobile field doesn't exist or document doesn't exist
      return null;
    } catch (error) {
      // Handle error
      print('Error fetching doctor mobile: $error');
      return null;
    }
  }

  void _openWhatsApp() async {
    int? doctorMobile = await getDoctorMobile();
    if (doctorMobile != null) {
      var contact = doctorMobile.toString();
      var androidUrl = "whatsapp://send?phone=$contact&text=Hi Doctor, I need some help";
      var iosUrl =
          "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

      try {
        if (Platform.isIOS) {
          await launchUrl(Uri.parse(iosUrl));
        } else {
          await launchUrl(Uri.parse(androidUrl));
        }
      } on Exception {
        print('WhatsApp is not installed.');
      }
    } else {
      print('Doctor mobile number not found.');
    }
  }


  void initState() {
    super.initState();
    fetchUserData();
    getDoctorMobile();
  }

  Future<void> fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userData =
          await _firestore.collection('patients').doc(widget.pid).get();

      setState(() {
        name = userData['name'];
        email = userData['num'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      appBar: AppBar(
        elevation: 0,
        title: Text('Patients Dashboard'),
        actions: [
          GestureDetector(
            onTap: () {
              _openWhatsApp();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assests/whatsapp.jpg', // Replace 'assets/whatsapp.png' with the path to your PNG icon
                width: 40, // Adjust width as needed
                height: 40, // Adjust height as needed
              ),
            ),
          ),
        ],



      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PEditProfile(
                            pid: widget.pid,
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginOptionScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // Image at top center
            SizedBox(
              height: 50,
            ),
            Container(
              width: 210,
              child: Image.asset(
                'assests/logo.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 40),
            Container(
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PatientViewVideo()),
                      );
                    },
                    child: Text('View Videos')
                )),
            SizedBox(height: 20,),
            Container(
              width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewTask(pid: widget.pid)),
                    );
                  },
                  child: Text('Daily Task')),
            ),
            SizedBox(height: 20,),
            Container(width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Quiz(pid: widget.pid,)),
                    );
                  },
                  child: Text('Questionaires')),
            ),
            SizedBox(height: 20,),
            Container(width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PtComplaints(pid: widget.pid,)),
                    );
                  },
                  child: Text('Complaints')),
            ),
            SizedBox(height: 20,),
            Container(width: 250,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PatientReview(pid: widget.pid,)),
                    );
                  },
                  child: Text('Review')),
            ),
          ],
        ),
      ),
    );
  }
}
