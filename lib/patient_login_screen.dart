import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PatientsScreen/PatientHomeScreen.dart';

class PatientLogin extends StatefulWidget {
  const PatientLogin({Key? key}) : super(key: key);

  @override
  State<PatientLogin> createState() => _PatientLoginState();
}

class _PatientLoginState extends State<PatientLogin> {
  final TextEditingController _patientIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String patientID = _patientIDController.text.trim();
    String password = _passwordController.text.trim();

    if (patientID.isEmpty || password.isEmpty) {
      // Show error message if patient ID or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both patient ID and password')),
      );
      return;
    }

    try {
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance.collection('patients').doc(patientID).get();

      if (patientDoc.exists) {
        String correctPassword = patientDoc['password'];

        if (password == correctPassword) {
          // Passwords match, navigate to the next screen or perform any action
           Navigator.push(context, MaterialPageRoute(builder: (context) => PatientHomeScreen(pid: patientID,)));
          print('Login successful');
        } else {
          // Passwords don't match, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } else {
        // Patient ID not found, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient ID not found')),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show error message if there's any issue with Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Patient Login'),
      ),
      backgroundColor: Colors.teal[400],
      body: Center(
        child: Container(
          width: 350,
          height: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Patient ID TextField
              TextField(
                controller: _patientIDController,
                decoration: InputDecoration(
                  hintText: 'Patient ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Login Button
              Container(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[400],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _patientIDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
